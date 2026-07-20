<script setup>
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const route = useRoute()
const language = useLanguageStore()

const annonces = ref([])
const disponibilites = ref([])
const loading = ref(true)
const saving = ref(false)
const error = ref('')
const success = ref('')

const form = ref({
  annonce_id: route.query.annonce_id || '',
  date_debut: '',
  date_fin: '',
})

onMounted(async () => {
  await Promise.all([
    loadAnnonces(),
    loadDisponibilites(),
  ])
})

async function loadAnnonces() {
  try {
    const response = await api.get('/prestataire/annonces')
    const payload = response.data.data || response.data

    if (Array.isArray(payload)) {
      annonces.value = payload
    } else if (Array.isArray(payload.data)) {
      annonces.value = payload.data
    } else {
      annonces.value = []
    }
  } catch (e) {
    error.value = language.t('provider.announcementsLoadError')
  }
}

async function loadDisponibilites() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/prestataire/disponibilites')
    const payload = response.data.data || response.data

    if (Array.isArray(payload)) {
      disponibilites.value = payload
    } else if (Array.isArray(payload.data)) {
      disponibilites.value = payload.data
    } else {
      disponibilites.value = []
    }
  } catch (e) {
    error.value = language.t('availability.loadError')
  } finally {
    loading.value = false
  }
}

async function submitDisponibilite() {
  saving.value = true
  error.value = ''
  success.value = ''

  if (!form.value.annonce_id) {
    error.value = language.t('availability.chooseAnnouncementError')
    saving.value = false
    return
  }

  if (!form.value.date_debut || !form.value.date_fin) {
    error.value = language.t('availability.requiredDatesError')
    saving.value = false
    return
  }

  const dateDebut = new Date(form.value.date_debut)
  const dateFin = new Date(form.value.date_fin)
  const now = new Date()

  if (dateDebut < now) {
    error.value = language.t('availability.startFutureError')
    saving.value = false
    return
  }

  if (dateFin <= dateDebut) {
    error.value = language.t('availability.endAfterStartError')
    saving.value = false
    return
  }

  try {
    await api.post('/prestataire/disponibilites', {
      annonce_id: form.value.annonce_id,
      date_debut: form.value.date_debut,
      date_fin: form.value.date_fin,
      disponible: true,
    })

    success.value = language.t('availability.addSuccess')

    form.value.date_debut = ''
    form.value.date_fin = ''

    await loadDisponibilites()
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value = e.response?.data?.message || language.t('availability.addError')
    }
  } finally {
    saving.value = false
  }
}

async function deleteDisponibilite(id) {
  const confirmation = confirm(language.t('availability.deleteConfirm'))

  if (!confirmation) {
    return
  }

  success.value = ''
  error.value = ''

  try {
    await api.delete(`/prestataire/disponibilites/${id}`)
    disponibilites.value = disponibilites.value.filter((disponibilite) => disponibilite.id !== id)
    success.value = language.t('availability.deleteSuccess')
  } catch (e) {
    error.value = e.response?.data?.message || language.t('availability.deleteError')
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

function getAnnonceTitle(disponibilite) {
  return disponibilite.annonce?.titre || language.t('availability.announcementNumber').replace('{id}', disponibilite.annonce_id)
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.myAvailabilities') }}
        </p>

        <h1>{{ language.t('provider.myAvailabilities') }}</h1>

        <p>
          {{ language.t('availability.subtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
        {{ language.t('availability.backToAnnouncements') }}
      </RouterLink>
    </div>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <div class="prestataire-two-columns">
      <form class="prestataire-form-card" @submit.prevent="submitDisponibilite">
        <h2>{{ language.t('availability.addTitle') }}</h2>

        <div class="form-group">
          <label>{{ language.t('availability.relatedAnnouncement') }}</label>

          <select v-model="form.annonce_id" required>
            <option value="" disabled>
              {{ language.t('availability.chooseAnnouncement') }}
            </option>

            <option
              v-for="annonce in annonces"
              :key="annonce.id"
              :value="annonce.id"
            >
              {{ annonce.titre }}
            </option>
          </select>
        </div>

        <div class="form-group">
          <label>{{ language.t('availability.startDate') }}</label>

          <input
            v-model="form.date_debut"
            type="datetime-local"
            required
          />
        </div>

        <div class="form-group">
          <label>{{ language.t('availability.endDate') }}</label>

          <input
            v-model="form.date_fin"
            type="datetime-local"
            required
          />
        </div>

        <div class="form-actions">
          <button type="submit" class="primary-small-btn" :disabled="saving">
            {{
              saving
                ? language.t('availability.adding')
                : language.t('availability.addSlot')
            }}
          </button>
        </div>
      </form>

      <section class="prestataire-panel-card">
        <h2>{{ language.t('availability.savedSlots') }}</h2>

        <p v-if="loading">
          {{ language.t('availability.loading') }}
        </p>

        <div v-if="!loading && disponibilites.length" class="availability-list">
          <article
            v-for="disponibilite in disponibilites"
            :key="disponibilite.id"
            class="availability-item"
          >
            <div>
              <span class="status-badge publiee">
                {{ language.t('availability.available') }}
              </span>

              <h3>{{ getAnnonceTitle(disponibilite) }}</h3>

              <p>
                {{ language.t('availability.start') }} :
                <strong>{{ formatDate(disponibilite.date_debut) }}</strong>
              </p>

              <p>
                {{ language.t('availability.end') }} :
                <strong>{{ formatDate(disponibilite.date_fin) }}</strong>
              </p>
            </div>

            <button
              type="button"
              class="danger-small-btn"
              @click="deleteDisponibilite(disponibilite.id)"
            >
              {{ language.t('common.delete') }}
            </button>
          </article>
        </div>

        <div v-if="!loading && disponibilites.length === 0" class="empty-results">
          <h2>{{ language.t('availability.emptyTitle') }}</h2>
          <p>{{ language.t('availability.emptyText') }}</p>
        </div>
      </section>
    </div>
  </section>
</template>
