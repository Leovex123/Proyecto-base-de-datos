import { useEffect, useState } from 'react'
import type { ReactElement } from 'react'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'
import { getCurrentUserName, logout } from '../../services/authService'
import Navbar from './Navbar'
import Sidebar from './Sidebar'
import { APP_NAME, NAV_ITEMS } from './navigation'

const AppLayout = (): ReactElement => {
  const [isSidebarOpen, setIsSidebarOpen] = useState<boolean>(false)
  const { pathname } = useLocation()
  const navigate = useNavigate()

  const title = NAV_ITEMS.find((item) => item.path === pathname)?.label ?? 'Inicio'

  useEffect(() => {
    document.title = `${title} | ${APP_NAME}`
  }, [title])

  useEffect(() => {
    if (!isSidebarOpen) return

    const handleKeyDown = (e: KeyboardEvent): void => {
      if (e.key === 'Escape') setIsSidebarOpen(false)
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [isSidebarOpen])

  const handleLogout = (): void => {
    logout()
    navigate('/login', { replace: true })
  }

  return (
    <div className="min-h-screen bg-linear-to-br from-violet-50 via-white to-indigo-50 text-slate-900">
      <Sidebar isOpen={isSidebarOpen} onClose={() => setIsSidebarOpen(false)} />

      <div className="flex min-h-screen flex-col lg:pl-64">
        <Navbar
          title={title}
          userName={getCurrentUserName()}
          isSidebarOpen={isSidebarOpen}
          onMenuClick={() => setIsSidebarOpen(true)}
          onLogout={handleLogout}
        />

        <main className="flex-1 px-4 py-6 sm:px-6 sm:py-8 lg:px-8">
          <div className="mx-auto w-full max-w-6xl">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  )
}

export default AppLayout
