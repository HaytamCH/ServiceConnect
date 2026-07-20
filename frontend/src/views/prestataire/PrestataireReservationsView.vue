<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl } from '../../utils/slug'


const language = useLanguageStore()

const reservations = ref([])
const loading = ref(true)
const updating = ref(false)
const error = ref('')
const success = ref('')

onMounted(async () => {
  await loadReservations()
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
  } catch (e) {
    error.value = language.t('providerReservations.loadError')
  } finally {
    loading.value = false
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

function formatDate(date) {
  if (!date) {
    return language.t('provider.dateUndefined')
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
        <div class="prestataire-list-icon">
          📩
        </div>

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

          <p v-if="reservation.message_demande">
            {{ language.t('reservations.message') }} :
            {{ reservation.message_demande }}
          </p>

          <div class="prestataire-list-meta">
            <span v-if="reservation.annonce">
              🏷️ {{ reservation.annonce.categorie?.nom || language.t('providerReservations.service') }}
            </span>

            <span v-if="reservation.annonce?.tarif">
              💶 {{ reservation.annonce.tarif }} €/h
            </span>
          </div>
        </div>

        <div class="prestataire-list-actions">
          <button
            v-if="reservation.statut === 'en_attente'"
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
          query: { retour: 'prestataire' }
        }"
            class="secondary-small-btn"
          >
            {{ language.t('reservations.viewAnnouncement') }}
          </RouterLink>


          <RouterLink
            to="/mes-messages"
            class="secondary-small-btn"
          >
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
