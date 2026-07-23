<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'


const language = useLanguageStore()
const notifications = useNotificationStore()

const avis = ref([])
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  await loadAvis()
  await markReviewNotificationsAsRead()
})

async function markReviewNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=avis_recu')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications d’avis comme lues.')
  }
}
async function loadAvis() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/prestataire/avis')
    const payload = response.data.data || response.data

    if (Array.isArray(payload)) {
      avis.value = payload
    } else if (Array.isArray(payload.data)) {
      avis.value = payload.data
    } else {
      avis.value = []
    }
  } catch (e) {
    error.value = language.t('providerReviews.loadError')
  } finally {
    loading.value = false
  }
}

function getMembreName(membre) {
  if (!membre) {
    return language.t('providerReservations.member')
  }

  return `${membre.prenom || ''} ${membre.nom || ''}`.trim()
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

  return new Date(date).toLocaleDateString(locale)
}

function renderStars(note) {
  const value = Number(note || 0)
  return '★'.repeat(value) + '☆'.repeat(5 - value)
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.receivedReviews') }}
        </p>

        <h1>{{ language.t('provider.receivedReviews') }}</h1>

        <p>
          {{ language.t('providerReviews.subtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/dashboard" class="secondary-small-btn">
        {{ language.t('common.backToDashboard') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('providerReviews.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <div v-if="!loading && avis.length" class="review-list">
      <article v-for="item in avis" :key="item.id" class="review-card">
        <div class="review-avatar">
          {{ item.membre?.prenom?.charAt(0) || 'M' }}
        </div>

        <div class="review-content">
          <div class="review-top">
            <div>
              <h2>{{ getMembreName(item.membre) }}</h2>

              <p v-if="item.annonce" class="muted-text">
                {{ language.t('providerReviews.reviewAbout') }} : {{ item.annonce.titre }}
              </p>
            </div>

            <span class="review-date">
              {{ formatDate(item.created_at) }}
            </span>
          </div>

          <div class="review-stars">
            {{ renderStars(item.note) }}
            <strong>{{ item.note }}/5</strong>
          </div>

          <p class="review-comment">
            {{ item.commentaire || language.t('providerReviews.noComment') }}
          </p>

          <span
            class="status-badge"
            :class="item.visible ? 'publiee' : 'suspendue'"
          >
            {{
              item.visible
                ? language.t('providerReviews.visible')
                : language.t('providerReviews.hidden')
            }}
          </span>
        </div>
      </article>
    </div>

    <div v-if="!loading && avis.length === 0" class="empty-results">
      <h2>{{ language.t('providerReviews.emptyTitle') }}</h2>
      <p>{{ language.t('providerReviews.emptyText') }}</p>
    </div>
  </section>
</template>
