import { useEffect, useState } from 'react'
import type { FormEvent, ReactElement } from 'react'
import { AuthError, login } from '../services/authService'

const BRAND_NAME = 'Scrum Planning'
const BRAND_SLOGAN = 'Planifica con claridad, entrega con confianza.'
const BRAND_DESCRIPTION = 'Backlog, sprints y tareas de tu equipo, en un solo lugar.'

type ToastType = 'error' | 'success'

interface ToastState {
  message: string
  type: ToastType
}

interface LoginProps {
  onSuccess?: () => void
}

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/

const validateIdentifier = (value: string): string => {
  if (!value) return 'Ingresa tu correo o usuario.'

  if (value.includes('@')) {
    if (value.length > 80 || !EMAIL_REGEX.test(value)) {
      return 'Escribe un correo válido, por ejemplo nombre@empresa.com.'
    }
    return ''
  }

  if (value.length < 3 || value.length > 80 || /\s/.test(value)) {
    return 'El usuario debe tener entre 3 y 80 caracteres y no puede incluir espacios.'
  }

  return ''
}

const validatePassword = (value: string): string => {
  if (!value) return 'Ingresa tu contraseña.'
  if (value.length > 128) return 'La contraseña no puede superar los 128 caracteres.'
  return ''
}

const Login = ({ onSuccess }: LoginProps): ReactElement => {
  const [identifier, setIdentifier] = useState<string>('')
  const [password, setPassword] = useState<string>('')
  const [isPasswordVisible, setIsPasswordVisible] = useState<boolean>(false)
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false)
  const [toast, setToast] = useState<ToastState | null>(null)
  const [identifierError, setIdentifierError] = useState<string>('')
  const [passwordError, setPasswordError] = useState<string>('')

  useEffect(() => {
    if (!toast) return

    const timeoutId = window.setTimeout(() => setToast(null), 4000)
    return () => window.clearTimeout(timeoutId)
  }, [toast])

  const handleSubmit = async (e: FormEvent<HTMLFormElement>): Promise<void> => {
    e.preventDefault()
    if (isSubmitting) return

    const normalizedIdentifier = identifier.trim()
    const nextIdentifierError = validateIdentifier(normalizedIdentifier)
    const nextPasswordError = validatePassword(password)

    setIdentifierError(nextIdentifierError)
    setPasswordError(nextPasswordError)

    if (nextIdentifierError) {
      setToast({ message: nextIdentifierError, type: 'error' })
      return
    }

    if (nextPasswordError) {
      setToast({ message: nextPasswordError, type: 'error' })
      return
    }

    setIsSubmitting(true)

    try {
      await login(normalizedIdentifier, password)
      setToast({ message: 'Sesión iniciada', type: 'success' })
      onSuccess?.()
    } catch (error) {
      if (error instanceof AuthError && error.status === 401) {
        setToast({ message: 'Usuario o contraseña incorrectos.', type: 'error' })
      } else if (error instanceof AuthError) {
        setToast({ message: error.message, type: 'error' })
      } else {
        setToast({ message: 'No pudimos iniciar sesión. Inténtalo de nuevo.', type: 'error' })
      }
    } finally {
      setIsSubmitting(false)
    }
  }

  const inputClass = (hasError: boolean): string =>
    `peer w-full rounded-xl border bg-white px-4 pb-3 pt-6 text-base text-slate-900 transition placeholder:text-transparent focus:outline-none focus:ring-4 ${
      hasError
        ? 'border-red-400 focus:border-red-500 focus:ring-red-500/15'
        : 'border-slate-300 focus:border-violet-500 focus:ring-violet-500/15'
    }`

  const floatingLabelClass =
    'pointer-events-none absolute left-4 top-3 text-xs font-medium text-slate-600 transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:text-base peer-focus:top-3 peer-focus:translate-y-0 peer-focus:text-xs peer-focus:text-violet-700'

  return (
    <main className="relative min-h-screen overflow-hidden bg-linear-to-br from-violet-100 via-white to-indigo-100 text-slate-900">
      <div aria-hidden="true" className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -left-40 -top-40 h-120 w-120 rounded-full bg-violet-300/55 blur-3xl" />
        <div className="absolute -bottom-48 right-0 h-152 w-152 rounded-full bg-indigo-300/50 blur-3xl" />
        <div className="absolute bottom-20 left-1/3 h-72 w-72 rounded-full bg-violet-200/35 blur-3xl" />
      </div>

      <div className="relative mx-auto grid min-h-screen w-full max-w-7xl items-center gap-12 px-5 py-10 sm:px-8 lg:grid-cols-2 lg:px-12">
        <section className="hidden max-w-xl lg:block">
          <img src="/scrum-planning-logo.svg" alt={BRAND_NAME} className="mb-16 h-14 w-auto" />

          <h1 className="text-5xl font-semibold leading-tight tracking-tight xl:text-6xl">
            {BRAND_SLOGAN}
          </h1>
          <p className="mt-6 max-w-lg text-lg leading-8 text-slate-600">{BRAND_DESCRIPTION}</p>
        </section>

        <section className="mx-auto w-full max-w-md">
          <img
            src="/scrum-planning-logo.svg"
            alt={BRAND_NAME}
            className="mx-auto mb-8 h-12 w-auto lg:hidden"
          />

          <div className="rounded-3xl border border-slate-200 bg-white/95 p-7 shadow-xl shadow-slate-200/70 backdrop-blur-xl sm:p-10">
            <div className="mb-8">
              <h2 className="text-3xl font-semibold tracking-tight text-slate-900">Inicia sesión</h2>
              <p className="mt-2 text-base leading-6 text-slate-600">
                Usa tu correo o tu nombre de usuario para entrar a tu espacio de trabajo.
              </p>
            </div>

            <form onSubmit={handleSubmit} noValidate className="space-y-5">
              <div className="relative">
                <input
                  id="identifier"
                  type="text"
                  inputMode="email"
                  value={identifier}
                  onChange={(e) => {
                    setIdentifier(e.target.value)
                    if (identifierError) setIdentifierError('')
                  }}
                  placeholder=" "
                  autoComplete="username"
                  autoCapitalize="none"
                  spellCheck={false}
                  disabled={isSubmitting}
                  aria-invalid={Boolean(identifierError)}
                  aria-describedby={identifierError ? 'identifier-error' : undefined}
                  className={inputClass(Boolean(identifierError))}
                />
                <label htmlFor="identifier" className={floatingLabelClass}>
                  Correo o usuario
                </label>
                {identifierError && (
                  <p id="identifier-error" className="mt-2 text-sm font-medium text-red-600">
                    {identifierError}
                  </p>
                )}
              </div>

              <div className="relative">
                <input
                  id="password"
                  type={isPasswordVisible ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => {
                    setPassword(e.target.value)
                    if (passwordError) setPasswordError('')
                  }}
                  placeholder=" "
                  autoComplete="current-password"
                  disabled={isSubmitting}
                  aria-invalid={Boolean(passwordError)}
                  aria-describedby={passwordError ? 'password-error' : undefined}
                  className={`${inputClass(Boolean(passwordError))} pr-12`}
                />
                <label htmlFor="password" className={floatingLabelClass}>
                  Contraseña
                </label>
                <button
                  type="button"
                  aria-label={isPasswordVisible ? 'Ocultar contraseña' : 'Mostrar contraseña'}
                  aria-pressed={isPasswordVisible}
                  onClick={() => setIsPasswordVisible((visible) => !visible)}
                  className="absolute right-3 top-3 rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900 focus:outline-none focus:ring-2 focus:ring-violet-500"
                >
                  {isPasswordVisible ? (
                    <svg aria-hidden="true" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.8" d="M3 3l18 18M10.6 10.6a2 2 0 002.8 2.8M9.9 5.2A10.7 10.7 0 0112 5c5 0 8.5 4.5 9.5 7-.4 1-1.2 2.1-2.3 3.2M6.2 6.2C4.3 7.4 3 9.2 2.5 12c.5 1.4 1.7 3.2 3.7 4.8A9.8 9.8 0 0012 19c1.1 0 2.1-.2 3-.5" />
                    </svg>
                  ) : (
                    <svg aria-hidden="true" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.8" d="M2.5 12S6 5 12 5s9.5 7 9.5 7-3.5 7-9.5 7-9.5-7-9.5-7Z" />
                      <circle cx="12" cy="12" r="3" strokeWidth="1.8" />
                    </svg>
                  )}
                </button>
                {passwordError && (
                  <p id="password-error" className="mt-2 text-sm font-medium text-red-600">
                    {passwordError}
                  </p>
                )}
              </div>

              <button
                type="submit"
                disabled={isSubmitting}
                className="flex w-full items-center justify-center gap-2 rounded-xl bg-violet-600 py-3.5 font-semibold text-white shadow-lg shadow-violet-950/20 transition hover:bg-violet-500 focus:outline-none focus:ring-4 focus:ring-violet-400/30 active:scale-[0.99] disabled:cursor-not-allowed disabled:opacity-70"
              >
                {isSubmitting && (
                  <svg className="h-4 w-4 animate-spin motion-reduce:animate-none" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                    <circle cx="12" cy="12" r="9" stroke="currentColor" strokeOpacity="0.3" strokeWidth="3" />
                    <path d="M21 12a9 9 0 0 0-9-9" stroke="currentColor" strokeWidth="3" strokeLinecap="round" />
                  </svg>
                )}
                {isSubmitting ? 'Iniciando sesión' : 'Iniciar sesión'}
              </button>
            </form>
          </div>
        </section>
      </div>

      {toast && (
        <div
          role="alert"
          className="toast-enter fixed right-5 top-5 z-50 flex max-w-sm items-start gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-800 shadow-xl shadow-slate-900/10"
        >
          <div
            className={`mt-0.5 grid h-8 w-8 shrink-0 place-items-center rounded-full ${
              toast.type === 'success' ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'
            }`}
          >
            <svg aria-hidden="true" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              {toast.type === 'success' ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              )}
            </svg>
          </div>
          <p className="py-1 leading-6">{toast.message}</p>
          <button
            type="button"
            aria-label="Cerrar notificación"
            onClick={() => setToast(null)}
            className="ml-1 rounded-lg p-1 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700"
          >
            <svg aria-hidden="true" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      )}
    </main>
  )
}

export default Login
