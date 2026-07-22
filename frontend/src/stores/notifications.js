import { defineStore } from 'pinia'
import api from '../api/axios'

export const useNotificationStore = defineStore('notifications', {
  state: () => ({
    summary: {
      total: 0,
      messages: {
        non_lus: 0,
      },
      reservations_membre: {
        acceptees: 0,
        refusees: 0,
        alternatives: 0,
      },
      reservations_prestataire: {
        en_attente: 0,
      },
    },
    loading: false,
    error: '',
  }),

  getters: {
    total: (state) => state.summary?.total || 0,
    messagesNonLus: (state) => state.summary?.messages?.non_lus || 0,
    reservationsAcceptees: (state) => state.summary?.reservations_membre?.acceptees || 0,
    reservationsRefusees: (state) => state.summary?.reservations_membre?.refusees || 0,
    reservationsAlternatives: (state) => state.summary?.reservations_membre?.alternatives || 0,
    reservationsPrestataireEnAttente: (state) =>
      state.summary?.reservations_prestataire?.en_attente || 0,
  },

  actions: {
    async loadSummary() {
      this.loading = true
      this.error = ''

      try {
        const response = await api.get('/notifications/summary')
        this.summary = response.data.data || response.data || this.summary
      } catch (e) {
        this.error = 'Impossible de charger les notifications.'
      } finally {
        this.loading = false
      }
    },

    clear() {
      this.summary = {
        total: 0,
        messages: {
          non_lus: 0,
        },
        reservations_membre: {
          acceptees: 0,
          refusees: 0,
          alternatives: 0,
        },
        reservations_prestataire: {
          en_attente: 0,
        },
      }
      this.error = ''
    },
  },
})
