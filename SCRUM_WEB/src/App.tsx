import type { ReactElement } from 'react'
import { Navigate, Route, Routes, useNavigate } from 'react-router-dom'
import AppLayout from './components/layout/AppLayout'
import { NAV_ITEMS } from './components/layout/navigation'
import ProtectedRoute from './components/routes/ProtectedRoute'
import Home from './pages/Home'
import Login from './pages/Login'
import SectionPage from './pages/SectionPage'
import { isAuthenticated } from './services/authService'

const LoginRoute = (): ReactElement => {
  const navigate = useNavigate()

  if (isAuthenticated()) return <Navigate to="/home" replace />

  // Pequeña pausa para que se alcance a ver el aviso "Sesión iniciada"
  return <Login onSuccess={() => window.setTimeout(() => navigate('/home', { replace: true }), 700)} />
}

const App = (): ReactElement => {
  const sections = NAV_ITEMS.filter((item) => item.path !== '/home')

  return (
    <Routes>
      <Route path="/login" element={<LoginRoute />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<AppLayout />}>
          <Route path="/home" element={<Home />} />
          {sections.map((section) => (
            <Route key={section.path} path={section.path} element={<SectionPage section={section} />} />
          ))}
        </Route>
      </Route>

      <Route path="*" element={<Navigate to={isAuthenticated() ? '/home' : '/login'} replace />} />
    </Routes>
  )
}

export default App
