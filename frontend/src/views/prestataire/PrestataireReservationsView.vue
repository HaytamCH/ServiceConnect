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
const updating = ref(false)
const error = ref('')
const success = ref('')
const activeAlternativeReservationId = ref(null)
const alternativeForms = ref({})

onMounted(async () => {
  await loadReservations()
  await markProviderReservationNotificationsAsRead()
})
async function loadReservations() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/prestataire/reservations')
    const payload = response.data.data || response.data

    if (Array.isArray(payload)) {
      reservations.value = payload
    } else if (Array.isArray(payload.data)) {
      reservations.value = payload.data
    } else {
      reservations.value = []
    }
  } catch {
    error.value = language.t('providerReservations.loadError')
  } finally {
    loading.value = false
  }
}

async function markProviderReservationNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=reservation_recue')
    await api.patch('/notifications/mark-as-read?type=reservation_alternative_acceptee')
    await api.patch('/notifications/mark-as-read?type=reservation_alternative_refusee')
    await notifications.loadSummary()
  } catch {
    console.warn('Impossible de marquer les notifications de réservation reçue comme lues.')
  }
}

async function updateStatut(reservationId, statut) {
  updating.value = true
  error.value = ''
  success.value = ''

  try {
    await api.patch(`/prestataire/reservations/${reservationId}/statut`, {
      statut,
    })

    success.value = language.t('providerReservations.updateSuccess')
    await loadReservations()
  } catch (e) {
    error.value = e.response?.data?.message || language.t('providerReservations.updateError')
  } finally {
    updating.value = false
  }
}

function toggleAlternativeForm(reservation) {
  error.value = ''
  success.value = ''

  if (activeAlternativeReservationId.value === reservation.id) {
    activeAlternativeReservationId.value = null
    return
  }

  activeAlternativeReservationId.value = reservation.id

  if (!alternativeForms.value[reservation.id]) {
    alternativeForms.value[reservation.id] = {
      date_alternative_debut: '',
      date_alternative_fin: '',
      message_alternative: '',
    }
  }
}

function minimumAlternativeDate() {
  const date = new Date(Date.now() + 60 * 1000)
  const localDate = new Date(date.getTime() - date.getTimezoneOffset() * 60 * 1000)

  return localDate.toISOString().slice(0, 16)
}

async function submitAlternative(reservation) {
  const form = alternativeForms.value[reservation.id]

  if (!form?.date_alternative_debut || !form?.date_alternative_fin) {
    error.value = 'Veuillez indiquer le début et la fin du nouveau créneau.'
    return
  }

  const startDate = new Date(form.date_alternative_debut)
  const endDate = new Date(form.date_alternative_fin)

  if (Number.isNaN(startDate.getTime()) || startDate <= new Date()) {
    error.value = 'Le nouveau créneau doit commencer dans le futur.'
    return
  }

  if (Number.isNaN(endDate.getTime()) || endDate <= startDate) {
    error.value = 'La fin du nouveau créneau doit être postérieure à son début.'
    return
  }

  updating.value = true
  error.value = ''
  success.value = ''

  try {
    await api.patch(`/prestataire/reservations/${reservation.id}/statut`, {
      statut: 'alternative_proposee',
      date_alternative_debut: form.date_alternative_debut,
      date_alternative_fin: form.date_alternative_fin,
      message_alternative: form.message_alternative?.trim() || null,
    })

    success.value = 'Une alternative a été proposée au membre.'
    activeAlternativeReservationId.value = null
    await loadReservations()
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de proposer cette alternative.'
  } finally {
    updating.value = false
  }
}

function formatDate(date) {
  if (!date) {
    return language.t('provider.dateUndefined')
  }

  const locale = language.current === 'en' ? 'en-GB' : language.current === 'nl' ? 'nl-BE' : 'fr-BE'

  return new Date(date).toLocaleString(locale)
}

function isReservationSlotExpired(reservation) {
  const serviceDate = new Date(reservation.date_service)

  return Number.isNaN(serviceDate.getTime()) || serviceDate <= new Date()
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

function getMembreName(membre) {
  if (!membre) {
    return language.t('providerReservations.member')
  }

  return `${membre.prenom || ''} ${membre.nom || ''}`.trim()
}

function createdAtLabel(date) {
  return language.t('providerReservations.createdOn').replace('{date}', formatDate(date))
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.receivedReservations') }}
        </p>

        <h1>{{ language.t('provider.receivedReservations') }}</h1>

        <p>
          {{ language.t('providerReservations.subtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/dashboard" class="secondary-small-btn">
        {{ language.t('common.backToDashboard') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('providerReservations.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <div v-if="!loading && reservations.length" class="prestataire-list">
      <article
        v-for="reservation in reservations"
        :key="reservation.id"
        class="prestataire-list-card reservation-provider-card"
      >
        <div class="prestataire-list-icon">📩</div>

        <div class="prestataire-list-content">
          <div class="prestataire-list-top">
            <span class="status-badge" :class="reservation.statut">
              {{ statutLabel(reservation.statut) }}
            </span>

            <span class="muted-text">
              {{ createdAtLabel(reservation.created_at) }}
            </span>
          </div>

          <h2>
            {{ reservation.annonce?.titre || language.t('providerReservations.requestedService') }}
          </h2>

          <p>
            {{ language.t('providerReservations.member') }} :
            <strong>{{ getMembreName(reservation.membre) }}</strong>
          </p>

          <p>
            {{ language.t('reservations.serviceDate') }} :
            <strong>{{ formatDate(reservation.date_service) }}</strong>
          </p>

          <p
            v-if="reservation.statut === 'en_attente' && isReservationSlotExpired(reservation)"
            class="expired-slot-note"
          >
            {{ language.t('providerReservations.expiredInitialSlot') }}
          </p>

          <p v-if="reservation.message_demande">
            {{ language.t('reservations.message') }} :
            {{ reservation.message_demande }}
          </p>

          <div
            v-if="activeAlternativeReservationId === reservation.id"
            class="alternative-form-box"
          >
            <h3>Proposer un nouveau créneau</h3>

            <div class="form-row">
              <div class="form-group">
                <label>Début du nouveau créneau</label>
                <input
                  v-model="alternativeForms[reservation.id].date_alternative_debut"
                  type="datetime-local"
                  :min="minimumAlternativeDate()"
                />
              </div>

              <div class="form-group">
                <label>Fin du nouveau créneau</label>
                <input
                  v-model="alternativeForms[reservation.id].date_alternative_fin"
                  type="datetime-local"
                  :min="
                    alternativeForms[reservation.id].date_alternative_debut ||
                    minimumAlternativeDate()
                  "
                />
              </div>
            </div>

            <div class="form-group">
              <label>Message pour le membre</label>
              <textarea
                v-model="alternativeForms[reservation.id].message_alternative"
                rows="3"
                placeholder="Expliquez brièvement pourquoi vous proposez ce nouveau créneau."
              ></textarea>
            </div>

            <div class="form-actions left">
              <button
                type="button"
                class="primary-small-btn"
                :disabled="updating"
                @click="submitAlternative(reservation)"
              >
                Envoyer l’alternative
              </button>

              <button
                type="button"
                class="secondary-small-btn"
                @click="toggleAlternativeForm(reservation)"
              >
                Annuler
              </button>
            </div>
          </div>

          <div class="prestataire-list-meta">
            <span v-if="reservation.annonce">
              🏷️
              {{ reservation.annonce.categorie?.nom || language.t('providerReservations.service') }}
            </span>

            <span v-if="reservation.annonce?.tarif"> 💶 {{ reservation.annonce.tarif }} €/h </span>
          </div>
        </div>

        <div class="prestataire-list-actions">
          <button
            v-if="reservation.statut === 'en_attente' && !isReservationSlotExpired(reservation)"
            type="button"
            class="primary-small-btn"
            :disabled="updating"
            @click="updateStatut(reservation.id, 'acceptee')"
          >
            {{ language.t('providerReservations.accept') }}
          </button>

          <button
            v-if="reservation.statut === 'en_attente'"
            type="button"
            class="danger-small-btn"
            :disabled="updating"
            @click="updateStatut(reservation.id, 'refusee')"
          >
            {{ language.t('providerReservations.refuse') }}
          </button>

          <button
            v-if="reservation.statut === 'en_attente'"
            type="button"
            class="secondary-small-btn"
            :disabled="updating"
            @click="toggleAlternativeForm(reservation)"
          >
            Proposer une alternative
          </button>

          <button
            v-if="reservation.statut === 'acceptee'"
            type="button"
            class="secondary-small-btn"
            :disabled="updating"
            @click="updateStatut(reservation.id, 'terminee')"
          >
            {{ language.t('providerReservations.markFinished') }}
          </button>

          <RouterLink
            v-if="reservation.annonce"
            :to="{
              path: annonceUrl(reservation.annonce),
              query: { retour: 'prestataire' },
            }"
            class="secondary-small-btn"
          >
            {{ language.t('reservations.viewAnnouncement') }}
          </RouterLink>

          <RouterLink to="/mes-messages" class="secondary-small-btn">
            {{ language.t('messages.title') }}
          </RouterLink>
        </div>
      </article>
    </div>

    <div v-if="!loading && reservations.length === 0" class="empty-results">
      <h2>{{ language.t('providerReservations.emptyTitle') }}</h2>
      <p>{{ language.t('providerReservations.emptyText') }}</p>
    </div>
  </section>
</template>
