import { useEffect, useState } from 'react'
import type { FormEvent, ReactElement } from 'react'

const Login = (): ReactElement => {
  const [email, setEmail] = useState<string>('')
  const [password, setPassword] = useState<string>('')
  const [isPasswordVisible, setIsPasswordVisible] = useState<boolean>(false)
  const [toastMessage, setToastMessage] = useState<string>('')
  const [emailError, setEmailError] = useState<string>('')
  const [passwordError, setPasswordError] = useState<string>('')

  useEffect(() => {
    if (!toastMessage) return

    const timeoutId = window.setTimeout(() => setToastMessage(''), 4000)
    return () => window.clearTimeout(timeoutId)
  }, [toastMessage])

  const handleSubmit = (e: FormEvent<HTMLFormElement>): void => {
    e.preventDefault()

    const normalizedEmail = email.trim()
    let nextEmailError = ''
    let nextPasswordError = ''

    if (!normalizedEmail) {
      nextEmailError = 'Ingresa tu correo electrónico.'
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
      nextEmailError = 'Ingresa un correo electrónico válido.'
    }

    if (!password) {
      nextPasswordError = 'Ingresa tu contraseña.'
    } else if (password.length < 6) {
      nextPasswordError = 'La contraseña debe tener al menos 6 caracteres.'
    }

    setEmailError(nextEmailError)
    setPasswordError(nextPasswordError)

    if (nextEmailError) {
      setToastMessage(nextEmailError)
      return
    }

    if (nextPasswordError) {
      setToastMessage(nextPasswordError)
      return
    }

    setToastMessage('El servicio de autenticación aún no está conectado.')
  }

  return (
    <main className="relative min-h-screen overflow-hidden bg-gradient-to-br from-violet-100 via-white to-indigo-100 text-slate-900">
      <div aria-hidden="true" className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -left-40 -top-40 h-[30rem] w-[30rem] rounded-full bg-violet-300/55 blur-3xl" />
        <div className="absolute -bottom-48 right-0 h-[38rem] w-[38rem] rounded-full bg-indigo-300/50 blur-3xl" />
        <div className="absolute bottom-20 left-1/3 h-72 w-72 rounded-full bg-violet-200/35 blur-3xl" />
      </div>

      <div className="relative mx-auto grid min-h-screen w-full max-w-7xl items-center gap-12 px-5 py-10 sm:px-8 lg:grid-cols-2 lg:px-12">
        <section className="hidden max-w-xl lg:block">
          <img
            src="/scrum-planning-logo.svg"
            alt="Scrum Planning"
            className="mb-16 h-14 w-auto"
          />

          <p className="mb-5 text-base font-semibold uppercase tracking-[0.18em] text-violet-700">
            Tu equipo, en sintonía
          </p>
          <h1 className="text-5xl font-semibold leading-tight tracking-tight xl:text-6xl">
            Las grandes ideas empiezan con un buen plan.
          </h1>
          <p className="mt-6 max-w-lg text-lg leading-8 text-slate-600">
            Organiza tus proyectos, acompaña cada avance y construye mejores resultados en equipo.
          </p>
        </section>

        <section className="mx-auto w-full max-w-md">
          <img
            src="/scrum-planning-logo.svg"
            alt="Scrum Planning"
            className="mb-8 h-12 w-auto mx-auto lg:hidden"
          />

          <div className="rounded-3xl border border-slate-200 bg-white/95 p-7 shadow-xl shadow-slate-200/70 backdrop-blur-xl sm:p-10">
            <div className="mb-8">
              <p className="mb-3 text-base font-semibold text-violet-700">Qué bueno verte</p>
              <h2 className="text-3xl font-semibold tracking-tight text-slate-900">Inicia sesión</h2>
              <p className="mt-2 text-base leading-6 text-slate-600">
                Ingresa tus datos para continuar con tu espacio de trabajo.
              </p>
            </div>

            <form onSubmit={handleSubmit} noValidate className="space-y-5">
              <div className="relative">
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    if (emailError) setEmailError('')
                  }}
                  placeholder=" "
                  autoComplete="email"
                  aria-invalid={Boolean(emailError)}
                  aria-describedby={emailError ? 'email-error' : undefined}
                  className={`peer w-full rounded-xl border bg-white px-4 pb-3 pt-6 text-base text-slate-900 transition placeholder:text-transparent focus:outline-none focus:ring-4 ${
                    emailError
                      ? 'border-red-400 focus:border-red-500 focus:ring-red-500/15'
                      : 'border-slate-300 focus:border-violet-500 focus:ring-violet-500/15'
                  }`}
                />
                <label
                  htmlFor="email"
                  className="pointer-events-none absolute left-4 top-3 text-xs font-medium text-slate-600 transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:text-base peer-focus:top-3 peer-focus:translate-y-0 peer-focus:text-xs peer-focus:text-violet-700"
                >
                  Correo electrónico
                </label>
                {emailError && (
                  <p id="email-error" className="mt-2 text-sm font-medium text-red-600">
                    {emailError}
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
                  aria-invalid={Boolean(passwordError)}
                  aria-describedby={passwordError ? 'password-error' : undefined}
                  className={`peer w-full rounded-xl border bg-white px-4 pb-3 pr-12 pt-6 text-base text-slate-900 transition placeholder:text-transparent focus:outline-none focus:ring-4 ${
                    passwordError
                      ? 'border-red-400 focus:border-red-500 focus:ring-red-500/15'
                      : 'border-slate-300 focus:border-violet-500 focus:ring-violet-500/15'
                  }`}
                />
                <label
                  htmlFor="password"
                  className="pointer-events-none absolute left-4 top-3 text-xs font-medium text-slate-600 transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:text-base peer-focus:top-3 peer-focus:translate-y-0 peer-focus:text-xs peer-focus:text-violet-700"
                >
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
                className="flex w-full items-center justify-center gap-2 rounded-xl bg-violet-500 py-3.5 font-semibold text-white shadow-lg shadow-violet-950/30 transition hover:bg-violet-400 focus:outline-none focus:ring-4 focus:ring-violet-400/30 active:scale-[0.99]"
              >
                Iniciar sesión
              </button>
            </form>

            <p className="mt-8 text-center text-sm leading-6 text-slate-600">
              Al continuar, accedes de forma segura a tu espacio de trabajo.
            </p>
          </div>
        </section>
      </div>

      {toastMessage && (
        <div
          role="alert"
          className="toast-enter fixed right-5 top-5 z-50 flex max-w-sm items-start gap-3 rounded-2xl border border-violet-200 bg-white px-4 py-3 text-sm text-slate-800 shadow-xl shadow-violet-950/15"
        >
          <div className="mt-0.5 grid h-8 w-8 shrink-0 place-items-center rounded-full bg-violet-100 text-violet-700">
            <svg aria-hidden="true" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <p className="py-1 leading-6">{toastMessage}</p>
          <button
            type="button"
            aria-label="Cerrar notificación"
            onClick={() => setToastMessage('')}
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