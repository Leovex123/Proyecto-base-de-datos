import type { ReactElement } from 'react'
import { APP_NAME } from './navigation'

interface NavbarProps {
  title: string
  userName: string
  isSidebarOpen: boolean
  onMenuClick: () => void
  onLogout: () => void
}

const Navbar = ({ title, userName, isSidebarOpen, onMenuClick, onLogout }: NavbarProps): ReactElement => {
  const displayName = userName || 'Usuario'

  return (
    <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/80 backdrop-blur-xl">
      <div className="flex h-16 items-center gap-3 px-4 sm:px-6 lg:px-8">
        <button
          type="button"
          aria-label="Abrir menú"
          aria-expanded={isSidebarOpen}
          aria-controls="app-sidebar"
          onClick={onMenuClick}
          className="-ml-2 rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 hover:text-slate-900 focus:outline-none focus:ring-2 focus:ring-violet-500 lg:hidden"
        >
          <svg aria-hidden="true" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.8" d="M4 7h16M4 12h16M4 17h16" />
          </svg>
        </button>

        <nav aria-label="Ubicación actual" className="min-w-0 flex-1">
          <ol className="flex items-center gap-2">
            <li className="hidden text-sm text-slate-500 sm:block">{APP_NAME}</li>
            <li aria-hidden="true" className="hidden text-slate-300 sm:block">
              /
            </li>
            <li aria-current="page" className="truncate text-base font-semibold text-slate-900">
              {title}
            </li>
          </ol>
        </nav>

        <div className="flex items-center gap-2 sm:gap-3">
          <div className="flex items-center gap-2">
            <span
              aria-hidden="true"
              className="grid h-9 w-9 place-items-center rounded-full bg-violet-100 text-sm font-semibold text-violet-700"
            >
              {displayName.charAt(0).toUpperCase()}
            </span>
            <span className="hidden max-w-40 truncate text-sm font-medium text-slate-700 md:block">
              {displayName}
            </span>
          </div>

          <button
            type="button"
            onClick={onLogout}
            aria-label="Cerrar sesión"
            className="flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium text-slate-600 transition hover:bg-slate-100 hover:text-slate-900 focus:outline-none focus:ring-2 focus:ring-violet-500"
          >
            <svg aria-hidden="true" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.8" d="M15 17l5-5-5-5M20 12H9M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4" />
            </svg>
            <span className="hidden sm:inline">Cerrar sesión</span>
          </button>
        </div>
      </div>
    </header>
  )
}

export default Navbar
