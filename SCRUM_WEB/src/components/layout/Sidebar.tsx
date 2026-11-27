import type { ReactElement } from 'react'
import { NavLink } from 'react-router-dom'
import NavIcon from './NavIcon'
import { APP_NAME, NAV_ITEMS } from './navigation'

interface SidebarProps {
  isOpen: boolean
  onClose: () => void
}

const Sidebar = ({ isOpen, onClose }: SidebarProps): ReactElement => (
  <>
    {isOpen && (
      <div
        aria-hidden="true"
        onClick={onClose}
        className="fixed inset-0 z-40 bg-slate-900/40 backdrop-blur-[2px] lg:hidden"
      />
    )}

    <aside
      id="app-sidebar"
      aria-label="Menú principal"
      className={`fixed inset-y-0 left-0 z-50 flex w-72 max-w-[85vw] flex-col border-r border-slate-200 bg-white transition-[transform,visibility] duration-200 motion-reduce:transition-none lg:w-64 lg:translate-x-0 ${
        isOpen ? 'translate-x-0 shadow-2xl' : 'max-lg:invisible max-lg:-translate-x-full'
      }`}
    >
      <div className="flex h-16 shrink-0 items-center justify-between border-b border-slate-100 px-5">
        <img src="/scrum-planning-logo.svg" alt={APP_NAME} className="h-9 w-auto" />
        <button
          type="button"
          aria-label="Cerrar menú"
          onClick={onClose}
          className="rounded-lg p-2 text-slate-500 transition hover:bg-slate-100 hover:text-slate-900 focus:outline-none focus:ring-2 focus:ring-violet-500 lg:hidden"
        >
          <svg aria-hidden="true" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <nav aria-label="Secciones" className="flex-1 overflow-y-auto px-3 py-4">
        <ul className="space-y-1">
          {NAV_ITEMS.map((item) => (
            <li key={item.path}>
              <NavLink
                to={item.path}
                onClick={onClose}
                className={({ isActive }) =>
                  `flex items-center gap-3 rounded-xl px-3 py-2.5 text-[15px] font-medium transition focus:outline-none focus-visible:ring-2 focus-visible:ring-violet-500 ${
                    isActive
                      ? 'bg-violet-100 text-violet-800'
                      : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900'
                  }`
                }
              >
                <NavIcon path={item.icon} />
                {item.label}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </aside>
  </>
)

export default Sidebar
