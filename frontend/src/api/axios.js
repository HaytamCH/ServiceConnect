import axios from 'axios'

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api/v1',
  headers: {
    Accept: 'application/json',
  },
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')

  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }

  return config
})

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const message = error.response?.data?.message || ''
    const status = error.response?.status

    if (
      status === 403 &&
      message.includes('Votre compte a été désactivé')
    ) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      localStorage.setItem('account_disabled_message', message)

      if (window.location.pathname !== '/login') {
        window.location.href = '/login?account_disabled=1'
      }
    }

    return Promise.reject(error)
  },
)

export default api
