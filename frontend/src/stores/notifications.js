import { defineStore } from 'pinia'
import api from '../api/axios'

const emptySummary = {
  total: 0,

  messages: {
    non_lus: 0,
  },

  avis_prestataire: {
    recus: 0,
  },

  reservations_membre: {
    acceptees: 0,
    refusees: 0,
    alternatives: 0,
    terminees: 0,
  },

  reservations_prestataire: {
    en_attente: 0,
  },

  paiements: {
    acceptes: 0,
    refuses: 0,
    recus: 0,
  },

  demande_prestataire: {
    acceptee: 0,
    refusee: 0,
  },

  admin: {
    annonces_en_attente: 0,
    avis_a_moderer: 0,
    messages_a_surveiller: 0,
    demandes_prestataires: 0,
  },

}

export const useNotificationStore = defineStore('notifications', {
  state: () => ({
    summary: { ...emptySummary },
    loading: false,
    error: '',
  }),

  getters: {
    total: (state) => state.summary?.total || 0,

    messagesNonLus: (state) => state.summary?.messages?.non_lus || 0,

    reservationsAcceptees: (state) =>
      state.summary?.reservations_membre?.acceptees || 0,

    reservationsRefusees: (state) =>
      state.summary?.reservations_membre?.refusees || 0,

    reservationsAlternatives: (state) =>
      state.summary?.reservations_membre?.alternatives || 0,

    reservationsTerminees: (state) =>
      state.summary?.reservations_membre?.terminees || 0,

    reservationsPrestataireEnAttente: (state) =>
      state.summary?.reservations_prestataire?.en_attente || 0,

    paiementsAcceptes: (state) =>
      state.summary?.paiements?.acceptes || 0,

    paiementsRefuses: (state) =>
      state.summary?.paiements?.refuses || 0,

    paiementsRecus: (state) =>
      state.summary?.paiements?.recus || 0,

    avisRecus: (state) =>
      state.summary?.avis_prestataire?.recus || 0,

    adminAnnoncesEnAttente: (state) =>
      state.summary?.admin?.annonces_en_attente || 0,

    adminAvisAModerer: (state) =>
      state.summary?.admin?.avis_a_moderer || 0,

    adminMessagesASurveiller: (state) =>
      state.summary?.admin?.messages_a_surveiller || 0,

    demandePrestataireAcceptee: (state) =>
      state.summary?.demande_prestataire?.acceptee || 0,

    demandePrestataireRefusee: (state) =>
      state.summary?.demande_prestataire?.refusee || 0,

    adminDemandesPrestataires: (state) =>
      state.summary?.admin?.demandes_prestataires || 0,
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
      this.summary = { ...emptySummary }
      this.error = ''
    },
  },
})
