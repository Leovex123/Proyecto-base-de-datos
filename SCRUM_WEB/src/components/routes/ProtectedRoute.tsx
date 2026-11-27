import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'
import { isAuthenticated } from '../../services/authService'

const ProtectedRoute = (): ReactElement =>
  isAuthenticated() ? <Outlet /> : <Navigate to="/login" replace />

export default ProtectedRoute
