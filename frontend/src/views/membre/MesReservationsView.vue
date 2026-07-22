<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl } from '../../utils/slug'
import { useNotificationStore } from '../../stores/notifications'

const language = useLanguageStore()
const notifications = useNotificationStore()

const reservations = ref([])
const loading = ref(true)
const error = ref('')
const paymentError = ref('')
const payingReservationId = ref(null)

onMounted(async () => {
  await loadReservations()
  await markReservationNotificationsAsRead()
})

async function loadReservations() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/mes-reservations')
    reservations.value = response.data.data || response.data || []
  } catch (e) {
    error.value = language.t('reservations.loadError')
  } finally {
    loading.value = false
  }
}

async function markReservationNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=reservation_acceptee')
    await api.patch('/notifications/mark-as-read?type=reservation_refusee')
    await api.patch('/notifications/mark-as-read?type=reservation_alternative')
    await api.patch('/notifications/mark-as-read?type=reservation_terminee')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications de réservation comme lues.')
  }
}

async function payReservation(reservation) {
  paymentError.value = ''
  payingReservationId.value = reservation.id

  try {
    const response = await api.post('/paiements', {
      reservation_id: reservation.id,
      methode: 'stripe',
    })

    const checkoutUrl = response.data.checkout_url

    if (!checkoutUrl) {
      paymentError.value = language.t('reservations.paymentUrlError')
      return
    }

    window.location.href = checkoutUrl
  } catch (e) {
    paymentError.value =
      e.response?.data?.message || language.t('reservations.paymentError')
  } finally {
    payingReservationId.value = null
  }
}

function formatDate(date) {
  if (!date) {
    return language.t('reservations.dateUndefined')
  }

  const locale =
    language.current === 'en'
      ? 'en-GB'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Date(date).toLocaleString(locale)
}

function statutLabel(statut) {
  const labels = {
    en_attente: language.t('reservations.statusPending'),
    acceptee: language.t('reservations.statusAccepted'),
    refusee: language.t('reservations.statusRefused'),
    alternative_proposee: language.t('reservations.statusAlternative'),
    annulee: language.t('reservations.statusCancelled'),
    terminee: language.t('reservations.statusFinished'),
  }

  return labels[statut] || statut
}
</script>

<template>
  <section class="member-page">
    <div class="member-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('account.title') }} › {{ language.t('reservations.title') }}
        </p>

        <h1>{{ language.t('reservations.title') }}</h1>

        <p>
          {{ language.t('reservations.subtitle') }}
        </p>
      </div>

      <RouterLink to="/annonces" class="primary-small-btn">
        {{ language.t('reservations.bookService') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('reservations.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="paymentError" class="error-message">
      {{ paymentError }}
    </p>

    <div v-if="!loading && reservations.length" class="reservation-list">
      <article
        v-for="reservation in reservations"
        :key="reservation.id"
        class="reservation-card"
      >
        <div class="reservation-main">
          <h2>
            {{ reservation.annonce?.titre || language.t('reservations.reservedService') }}
          </h2>

          <p>
            {{ language.t('reservations.provider') }} :
            <strong>
              {{ reservation.prestataire?.prenom }}
              {{ reservation.prestataire?.nom }}
            </strong>
          </p>

          <p>
            {{ language.t('reservations.serviceDate') }} :
            <strong>{{ formatDate(reservation.date_service) }}</strong>
          </p>

          <p v-if="reservation.message_demande">
            {{ language.t('reservations.message') }} :
            {{ reservation.message_demande }}
          </p>
        </div>

        <div class="reservation-side">
          <span class="status-badge" :class="reservation.statut">
            {{ statutLabel(reservation.statut) }}
          </span>

          <button
            v-if="reservation.statut === 'acceptee'"
            type="button"
            class="primary-small-btn"
            :disabled="payingReservationId === reservation.id"
            @click="payReservation(reservation)"
          >
            {{
              payingReservationId === reservation.id
                ? language.t('reservations.paymentLoading')
                : language.t('reservations.payWithStripe')
            }}
          </button>

          <RouterLink
            v-if="reservation.annonce"
            :to="annonceUrl(reservation.annonce)"
            class="secondary-small-btn"
          >
            {{ language.t('reservations.viewAnnouncement') }}
          </RouterLink>
        </div>
      </article>
    </div>

    <div v-if="!loading && reservations.length === 0" class="empty-results">
      <h2>{{ language.t('reservations.noReservationTitle') }}</h2>
      <p>{{ language.t('reservations.noReservationText') }}</p>
    </div>
  </section>
</template>
