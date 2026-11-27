const AUTHENTICATE_URL = '/websocket/users/authenticate'
const TOKEN_KEY = 'scrum_access_token'

interface TokenResponse {
  access_token: string
  token_type: string
  message_user: string
}

interface TokenClaims {
  name?: string
  exp?: number
}

export class AuthError extends Error {
  status: number

  constructor(message: string, status: number) {
    super(message)
    this.name = 'AuthError'
    this.status = status
  }
}

export const login = async (identifier: string, password: string): Promise<TokenResponse> => {
  let response: Response

  try {
    response = await fetch(AUTHENTICATE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userName: identifier, userPassword: password }),
    })
  } catch {
    throw new AuthError('No pudimos conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.', 0)
  }

  const body = await response.json().catch(() => null)

  if (!response.ok) {
    const detail =
      typeof body?.detail === 'string' ? body.detail : 'No pudimos iniciar sesión. Inténtalo de nuevo.'
    throw new AuthError(detail, response.status)
  }

  sessionStorage.setItem(TOKEN_KEY, body.access_token)
  return body as TokenResponse
}

export const getAccessToken = (): string | null => sessionStorage.getItem(TOKEN_KEY)

export const logout = (): void => sessionStorage.removeItem(TOKEN_KEY)

// Solo lectura para la interfaz: la validación real del token la hace el backend.
const readClaims = (): TokenClaims | null => {
  const token = getAccessToken()
  if (!token) return null

  try {
    const payload = token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')
    const bytes = Uint8Array.from(atob(payload), (char) => char.charCodeAt(0))
    return JSON.parse(new TextDecoder().decode(bytes)) as TokenClaims
  } catch {
    return null
  }
}

export const isAuthenticated = (): boolean => {
  const claims = readClaims()
  if (!claims) return false

  if (typeof claims.exp === 'number' && claims.exp * 1000 <= Date.now()) {
    logout()
    return false
  }

  return true
}

export const getCurrentUserName = (): string => readClaims()?.name ?? ''
