<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl } from '../../utils/slug'
import { useNotificationStore } from '../../stores/notifications'

const language = useLanguageStore()
const notifications = useNotificationStore()

const annonces = ref([])
const loading = ref(true)
const error = ref('')
const success = ref('')

onMounted(async () => {
  await loadAnnonces()
  await markAnnouncementNotificationsAsRead()
})


async function markAnnouncementNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=annonce_validee')
    await notifications.loadSummary()
  } catch {
    console.warn('Impossible de marquer les notifications d’annonces comme lues.')
  }
}
async function loadAnnonces() {
  loading.value = true
  error.value = ''

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
  } catch  {
    error.value = language.t('provider.announcementsLoadError')
  } finally {
    loading.value = false
  }
}

async function deleteAnnonce(id) {
  const confirmation = confirm(language.t('provider.deleteAnnouncementConfirm'))

  if (!confirmation) {
    return
  }

  success.value = ''
  error.value = ''

  try {
    await api.delete(`/prestataire/annonces/${id}`)
    annonces.value = annonces.value.filter((annonce) => annonce.id !== id)
    success.value = language.t('provider.announcementDeleted')
  } catch (e) {
    error.value = e.response?.data?.message || language.t('provider.deleteAnnouncementError')
  }
}

function statutLabel(statut) {
  const labels = {
    brouillon: language.t('provider.statusDraft'),
    en_attente: language.t('provider.statusPending'),
    publiee: language.t('provider.statusPublished'),
    suspendue: language.t('provider.statusSuspended'),
    supprimee: language.t('provider.statusDeleted'),
  }

  return labels[statut] || statut
}

function formatDate(date) {
  if (!date) {
    return language.t('provider.dateUndefined')
  }

  const locale = language.current === 'en' ? 'en-GB' : language.current === 'nl' ? 'nl-BE' : 'fr-BE'

  return new Date(date).toLocaleDateString(locale)
}

function createdAtLabel(date) {
  return language.t('provider.createdOn').replace('{date}', formatDate(date))
}

function getCategoryKey(nom) {
  const name = (nom || '').toLowerCase()

  if (name.includes('bricolage')) return 'bricolage'
  if (name.includes('nettoyage')) return 'nettoyage'
  if (name.includes('jardinage')) return 'jardinage'
  if (name.includes('baby') || name.includes('garde')) return 'babySitting'
  if (name.includes('informatique')) return 'informatique'
  if (name.includes('plomberie')) return 'plomberie'
  if (name.includes('électricité') || name.includes('electricite')) return 'electricite'
  if (name.includes('aide')) return 'aide'

  return 'default'
}

function getCategoryName(categorie) {
  if (!categorie) {
    return ''
  }

  const key = getCategoryKey(categorie.nom)
  return language.t(`home.categoryNames.${key}`)
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.myAnnouncements') }}
        </p>

        <h1>{{ language.t('provider.myAnnouncements') }}</h1>

        <p>
          {{ language.t('provider.myAnnouncementsPageText') }}
        </p>
      </div>

      <RouterLink to="/prestataire/annonces/nouvelle" class="primary-small-btn">
        {{ language.t('provider.newAnnouncement') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('provider.loadingAnnouncements') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <div v-if="!loading && annonces.length" class="prestataire-list">
      <article
        v-for="annonce in annonces"
        :key="annonce.id"
        class="prestataire-list-card"
      >
        <div class="prestataire-list-icon">
          📢
        </div>

        <div class="prestataire-list-content">
          <div class="prestataire-list-top">
            <span class="status-badge" :class="annonce.statut">
              {{ statutLabel(annonce.statut) }}
            </span>

            <span class="muted-text">
              {{ createdAtLabel(annonce.created_at) }}
            </span>
          </div>

          <h2>{{ annonce.titre }}</h2>

          <p>
            {{ annonce.description }}
          </p>

          <div class="prestataire-list-meta">
            <span>
              📍 {{ annonce.localisation || language.t('provider.locationUndefined') }}
            </span>

            <span>
              💶 {{ annonce.tarif || 0 }} €/h
            </span>

            <span v-if="annonce.categorie">
              🏷️ {{ getCategoryName(annonce.categorie) }}
            </span>
          </div>
        </div>

        <div class="prestataire-list-actions">
          <RouterLink
            :to="{
              path: annonceUrl(annonce),
              query: { retour: 'prestataire' }
            }"
            class="secondary-small-btn"
          >
            {{ language.t('common.view') }}
          </RouterLink>

          <RouterLink
            :to="`/prestataire/annonces/${annonce.id}/modifier`"
            class="secondary-small-btn"
          >
            {{ language.t('common.edit') }}
          </RouterLink>

          <RouterLink
            :to="`/prestataire/disponibilites?annonce_id=${annonce.id}`"
            class="secondary-small-btn"
          >
            {{ language.t('provider.myAvailabilities') }}
          </RouterLink>

          <button
            type="button"
            class="danger-small-btn"
            @click="deleteAnnonce(annonce.id)"
          >
            {{ language.t('common.delete') }}
          </button>
        </div>
      </article>
    </div>

    <div v-if="!loading && annonces.length === 0" class="empty-results">
      <h2>{{ language.t('provider.noAnnouncementTitle') }}</h2>
      <p>{{ language.t('provider.noAnnouncementText') }}</p>
    </div>
  </section>
</template>
