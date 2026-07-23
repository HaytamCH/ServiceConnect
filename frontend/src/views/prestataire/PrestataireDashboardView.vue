<script setup>
import { computed, onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'

const auth = useAuthStore()
const language = useLanguageStore()

const dashboard = ref({})
const loading = ref(true)
const error = ref('')

const user = computed(() => auth.user)

const notifications = useNotificationStore()

oonMounted(async () => {
  await loadDashboard()
  await markProviderAcceptedNotificationAsRead()
})


async function markProviderAcceptedNotificationAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=demande_prestataire_acceptee')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer la notification prestataire acceptée comme lue.')
  }
}

async function loadDashboard() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/prestataire/dashboard')
    dashboard.value = response.data.data || response.data || {}
  } catch (e) {
    error.value = language.t('provider.loadDashboardError')
  } finally {
    loading.value = false
  }
}

function getValue(...keys) {
  for (const key of keys) {
    if (dashboard.value && dashboard.value[key] !== undefined) {
      return dashboard.value[key]
    }
  }

  return 0
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.dashboardShort') }}
        </p>

        <p>
          {{ language.t('provider.welcome') }},
          <strong>{{ user?.prenom }} {{ user?.nom }}</strong>.
          {{ language.t('provider.dashboardIntro') }}
        </p>
      </div>

      <RouterLink to="/prestataire/annonces/nouvelle" class="primary-small-btn">
        {{ language.t('provider.newAnnouncement') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('provider.loadingDashboard') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <div v-if="!loading && !error" class="prestataire-stats-grid">
      <article class="prestataire-stat-card">
        <span class="stat-icon blue">📢</span>
        <div>
          <strong>{{ getValue('annonces', 'nombre_annonces', 'annonces_count') }}</strong>
          <p>{{ language.t('provider.publishedAnnouncements') }}</p>
        </div>
      </article>

      <article class="prestataire-stat-card">
        <span class="stat-icon orange">📅</span>
        <div>
          <strong>{{ getValue('reservations', 'nombre_reservations', 'reservations_count') }}</strong>
          <p>{{ language.t('provider.receivedReservations') }}</p>
        </div>
      </article>

      <article class="prestataire-stat-card">
        <span class="stat-icon green">⏳</span>
        <div>
          <strong>{{ getValue('reservations_en_attente', 'en_attente') }}</strong>
          <p>{{ language.t('provider.pendingRequests') }}</p>
        </div>
      </article>

      <article class="prestataire-stat-card">
        <span class="stat-icon purple">⭐</span>
        <div>
          <strong>{{ getValue('avis', 'nombre_avis', 'avis_count') }}</strong>
          <p>{{ language.t('provider.receivedReviews') }}</p>
        </div>
      </article>
    </div>

    <div v-if="!loading && !error" class="prestataire-actions-grid">
      <RouterLink to="/prestataire/annonces" class="prestataire-action-card">
        <span>📢</span>
        <h2>{{ language.t('provider.myAnnouncements') }}</h2>
        <p>{{ language.t('provider.myAnnouncementsText') }}</p>
      </RouterLink>

      <RouterLink to="/prestataire/disponibilites" class="prestataire-action-card">
        <span>🗓️</span>
        <h2>{{ language.t('provider.myAvailabilities') }}</h2>
        <p>{{ language.t('provider.myAvailabilitiesText') }}</p>
      </RouterLink>

      <RouterLink to="/prestataire/reservations" class="prestataire-action-card">
        <span>📩</span>
        <h2>{{ language.t('provider.receivedReservations') }}</h2>
        <p>{{ language.t('provider.receivedReservationsText') }}</p>
      </RouterLink>

      <RouterLink to="/prestataire/avis" class="prestataire-action-card">
        <span>⭐</span>
        <h2>{{ language.t('provider.receivedReviews') }}</h2>
        <p>{{ language.t('provider.receivedReviewsText') }}</p>
      </RouterLink>

      <RouterLink to="/prestataire/paiements" class="prestataire-action-card">
        <span>💶</span>
        <h2>{{ language.t('provider.receivedPayments') }}</h2>
        <p>{{ language.t('provider.receivedPaymentsText') }}</p>
      </RouterLink>
    </div>
  </section>
</template>
