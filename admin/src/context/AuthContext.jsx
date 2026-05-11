import { createContext, useContext, useState, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [token, setToken] = useState(() => localStorage.getItem('admin_token'))
  const [user,  setUser]  = useState(() => {
    try { return JSON.parse(localStorage.getItem('admin_user')) } catch { return null }
  })

  const login = useCallback((tok, userData) => {
    localStorage.setItem('admin_token', tok)
    localStorage.setItem('admin_user', JSON.stringify(userData))
    setToken(tok)
    setUser(userData)
  }, [])

  const logout = useCallback(() => {
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_user')
    setToken(null)
    setUser(null)
  }, [])

  return (
    <AuthContext.Provider value={{ token, user, login, logout, isAuth: !!token }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
