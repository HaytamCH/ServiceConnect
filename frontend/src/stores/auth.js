import { defineStore } from 'pinia'
import api from '../api/axios'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: JSON.parse(localStorage.getItem('user') || 'null'),
  }),

  getters: {
    isAuthenticated: (state) => !!state.token,

    // Un prestataire garde aussi les droits d'un membre
    isMembre: (state) => {
      return state.user?.role === 'membre' || state.user?.role === 'prestataire'
    },

    isPrestataire: (state) => state.user?.role === 'prestataire',
    isAdmin: (state) => state.user?.role === 'administrateur',
  },

  actions: {
    async login(credentials) {
      const response = await api.post('/auth/login', credentials)

      this.token = response.data.token
      this.user = response.data.user

      localStorage.setItem('token', this.token)
      localStorage.setItem('user', JSON.stringify(this.user))

      return response.data
    },

    async register(formData) {
      const response = await api.post('/auth/register', formData)

      this.token = response.data.token
      this.user = response.data.user

      localStorage.setItem('token', this.token)
      localStorage.setItem('user', JSON.stringify(this.user))

      return response.data
    },

    async fetchUser() {
      if (!this.token) {
        return null
      }

      const response = await api.get('/auth/me')

      this.user = response.data.data || response.data.user || response.data

      localStorage.setItem('user', JSON.stringify(this.user))

      return this.user
    },

    async logout() {
      try {
        if (this.token) {
          await api.post('/auth/logout')
        }
      } catch (e) {
        console.warn('Déconnexion côté serveur impossible.')
      } finally {
        this.token = null
        this.user = null

        localStorage.removeItem('token')
        localStorage.removeItem('user')
      }
    },
  },
})
