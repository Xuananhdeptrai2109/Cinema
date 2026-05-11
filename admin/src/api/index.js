/**
 * api/index.js
 * Tập trung tất cả API calls cho Admin site.
 * Mọi endpoint đều qua axios instance đã có JWT interceptor (client.js)
 */
import api from '../utils/client'

// ── Auth ─────────────────────────────────────────────────────────────────────
export const authApi = {
  login: (credentials) => api.post('/auth/login', credentials),
  me:    ()            => api.get('/auth/me'),
}

// ── Movies ───────────────────────────────────────────────────────────────────
export const movieApi = {
  getAll:  ()           => api.get('/admin/movies'),
  getById: (id)         => api.get(`/admin/movies/${id}`),
  create:  (data)       => api.post('/admin/movies', data),
  update:  (id, data)   => api.put(`/admin/movies/${id}`, data),
  delete:  (id)         => api.delete(`/admin/movies/${id}`),
}

// ── Genres ───────────────────────────────────────────────────────────────────
export const genreApi = {
  getAll: () => api.get('/admin/genres'),
}

// ── Cinemas ──────────────────────────────────────────────────────────────────
export const cinemaApi = {
  getAll:  ()           => api.get('/admin/cinemas'),
  getById: (id)         => api.get(`/admin/cinemas/${id}`),
  create:  (data)       => api.post('/admin/cinemas', data),
  update:  (id, data)   => api.put(`/admin/cinemas/${id}`, data),
  delete:  (id)         => api.delete(`/admin/cinemas/${id}`),
}

// ── Cities / Provinces ───────────────────────────────────────────────────────
export const cityApi = {
  getAll: () => api.get('/admin/provinces'),
}

// ── Rooms ─────────────────────────────────────────────────────────────────────
export const roomApi = {
  getAll:  ()           => api.get('/admin/rooms'),
  getById: (id)         => api.get(`/admin/rooms/${id}`),
  create:  (data)       => api.post('/admin/rooms', data),
  update:  (id, data)   => api.put(`/admin/rooms/${id}`, data),
  delete:  (id)         => api.delete(`/admin/rooms/${id}`),
}

// ── Showtimes ─────────────────────────────────────────────────────────────────
export const showtimeApi = {
  getAll:  ()           => api.get('/admin/showtimes'),
  getById: (id)         => api.get(`/admin/showtimes/${id}`),
  create:  (data)       => api.post('/admin/showtimes', data),
  update:  (id, data)   => api.put(`/admin/showtimes/${id}`, data),
  delete:  (id)         => api.delete(`/admin/showtimes/${id}`),
}

// ── Products ──────────────────────────────────────────────────────────────────
export const productApi = {
  getAll:  ()           => api.get('/admin/products'),
  getById: (id)         => api.get(`/admin/products/${id}`),
  create:  (data)       => api.post('/admin/products', data),
  update:  (id, data)   => api.put(`/admin/products/${id}`, data),
  delete:  (id)         => api.delete(`/admin/products/${id}`),
}

// ── Discounts ─────────────────────────────────────────────────────────────────
export const discountApi = {
  getAll:  ()           => api.get('/admin/discounts'),
  getById: (id)         => api.get(`/admin/discounts/${id}`),
  create:  (data)       => api.post('/admin/discounts', data),
  update:  (id, data)   => api.put(`/admin/discounts/${id}`, data),
  delete:  (id)         => api.delete(`/admin/discounts/${id}`),
}

// ── Statistics ────────────────────────────────────────────────────────────────
export const statsApi = {
  /** Tổng quan dashboard: totalRevenue, totalTickets, totalMovies, totalUsers, revenueChart, ticketChart */
  overview:  ()         => api.get('/admin/stats/overview'),

  /** Biểu đồ doanh thu — params: { period: 'day'|'week'|'month', from, to, cinemaId? } */
  revenue:   (params)   => api.get('/admin/stats/revenue',   { params }),

  /** Số liệu vé bán — params: { period, cinemaId? } */
  tickets:   (params)   => api.get('/admin/stats/tickets',   { params }),

  /** Top phim bán vé nhiều — params: { limit? } */
  topMovies: (params)   => api.get('/admin/stats/top-movies', { params }),

  /** Thống kê theo rạp — params: { from, to } */
  byCinema:  ()         => api.get('/admin/stats/revenue/by-cinema'),
  byMovie:   (params)   => api.get('/admin/stats/revenue/by-movie', { params }),
  byDate:    (params)   => api.get('/admin/stats/revenue/by-date', { params }),

  /** Hành vi khách hàng */
  customers: ()         => api.get('/admin/stats/customers'),
}
