import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import AdminLayout from './components/layout/AdminLayout'
import LoginPage     from './pages/LoginPage'
import Dashboard     from './pages/Dashboard'
import MoviesPage    from './pages/movies/MoviesPage'
import CinemasPage   from './pages/cinemas/CinemasPage'
import RoomsPage     from './pages/rooms/RoomsPage'
import ShowtimesPage from './pages/showtimes/ShowtimesPage'
import ProductsPage  from './pages/products/ProductsPage'
import DiscountsPage from './pages/discounts/DiscountsPage'
import StatisticsPage from './pages/statistics/StatisticsPage'

function PrivateRoute({ children }) {
  const { isAuth } = useAuth()
  return isAuth ? children : <Navigate to="/login" replace />
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<PrivateRoute><AdminLayout /></PrivateRoute>}>
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard"   element={<Dashboard />} />
            <Route path="movies"      element={<MoviesPage />} />
            <Route path="cinemas"     element={<CinemasPage />} />
            <Route path="rooms"       element={<RoomsPage />} />
            <Route path="showtimes"   element={<ShowtimesPage />} />
            <Route path="products"    element={<ProductsPage />} />
            <Route path="discounts"   element={<DiscountsPage />} />
            <Route path="statistics"  element={<StatisticsPage />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}
