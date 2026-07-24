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

const activeReviewReservationId = ref(null)
const postingReviewId = ref(null)
const reviewError = ref('')
const reviewSuccess = ref('')

const reviewForms = ref({})

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

function getPaiement(reservation) {
  return reservation.paiement || null
}

function isReservationPaid(reservation) {
  return getPaiement(reservation)?.statut === 'accepte'
}

function paymentLabel(reservation) {
  const paiement = getPaiement(reservation)

  if (!paiement) {
    return ''
  }

  const labels = {
    en_attente: 'Paiement en attente',
    accepte: 'Paiement effectué',
    refuse: 'Paiement refusé',
    rembourse: 'Paiement remboursé',
  }

  return labels[paiement.statut] || paiement.statut
}

function hasAvis(reservation) {
  return Array.isArray(reservation.avis) && reservation.avis.length > 0
}

function getAvis(reservation) {
  if (!hasAvis(reservation)) {
    return null
  }

  return reservation.avis[0]
}

function canLeaveAvis(reservation) {
  return (
    reservation.statut === 'terminee' &&
    isReservationPaid(reservation) &&
    !hasAvis(reservation)
  )
}

function toggleReviewForm(reservation) {
  reviewError.value = ''
  reviewSuccess.value = ''

  if (activeReviewReservationId.value === reservation.id) {
    activeReviewReservationId.value = null
    return
  }

  activeReviewReservationId.value = reservation.id

  if (!reviewForms.value[reservation.id]) {
    reviewForms.value[reservation.id] = {
      note: 5,
      commentaire: '',
    }
  }
}

async function submitAvis(reservation) {
  reviewError.value = ''
  reviewSuccess.value = ''
  postingReviewId.value = reservation.id

  const form = reviewForms.value[reservation.id]

  if (!form || !form.note) {
    reviewError.value = 'Veuillez sélectionner une note.'
    postingReviewId.value = null
    return
  }

  try {
    await api.post('/avis', {
      reservation_id: reservation.id,
      note: Number(form.note),
      commentaire: form.commentaire.trim(),
    })

    reviewSuccess.value = 'Votre avis a été publié avec succès.'
    activeReviewReservationId.value = null

    await loadReservations()
  } catch (e) {
    reviewError.value =
      e.response?.data?.message || 'Impossible de publier cet avis.'
  } finally {
    postingReviewId.value = null
  }
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

    <p v-if="reviewError" class="error-message">
      {{ reviewError }}
    </p>

    <p v-if="reviewSuccess" class="success-message">
      {{ reviewSuccess }}
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

          <div v-if="hasAvis(reservation)" class="reservation-review-box">
            <strong>Votre avis : {{ getAvis(reservation).note }}/5 ⭐</strong>
            <p>
              {{ getAvis(reservation).commentaire || 'Aucun commentaire ajouté.' }}
            </p>
          </div>

          <div
            v-if="activeReviewReservationId === reservation.id"
            class="reservation-review-form"
          >
            <div class="form-group">
              <label>Note</label>

              <select v-model="reviewForms[reservation.id].note">
                <option value="5">5 - Excellent</option>
                <option value="4">4 - Très bien</option>
                <option value="3">3 - Correct</option>
                <option value="2">2 - Moyen</option>
                <option value="1">1 - Mauvais</option>
              </select>
            </div>

            <div class="form-group">
              <label>Commentaire</label>

              <textarea
                v-model="reviewForms[reservation.id].commentaire"
                rows="4"
                placeholder="Partagez votre expérience avec ce prestataire..."
              ></textarea>
            </div>

            <div class="review-form-actions">
              <button
                type="button"
                class="primary-small-btn"
                :disabled="postingReviewId === reservation.id"
                @click="submitAvis(reservation)"
              >
                {{
                  postingReviewId === reservation.id
                    ? 'Publication...'
                    : 'Publier l’avis'
                }}
              </button>

              <button
                type="button"
                class="secondary-small-btn"
                @click="toggleReviewForm(reservation)"
              >
                Annuler
              </button>
            </div>
          </div>
        </div>

        <div class="reservation-side">
          <span class="status-badge" :class="reservation.statut">
            {{ statutLabel(reservation.statut) }}
          </span>

          <span
            v-if="isReservationPaid(reservation)"
            class="status-badge accepte"
          >
            {{ paymentLabel(reservation) }}
          </span>

          <button
            v-else-if="reservation.statut === 'acceptee'"
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

          <button
            v-if="canLeaveAvis(reservation)"
            type="button"
            class="secondary-small-btn"
            @click="toggleReviewForm(reservation)"
          >
            Laisser un avis
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
