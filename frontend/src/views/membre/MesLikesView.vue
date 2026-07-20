<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl, prestataireUrl } from '../../utils/slug'

const language = useLanguageStore()

const likes = ref([])
const loading = ref(true)
const error = ref('')
const success = ref('')

onMounted(async () => {
  await loadLikes()
})

async function loadLikes() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/mes-likes')
    likes.value = response.data.data || []
  } catch (e) {
    error.value = language.t('favorites.loadError')
  } finally {
    loading.value = false
  }
}

async function removeLike(id) {
  success.value = ''
  error.value = ''

  try {
    await api.delete(`/likes/${id}`)
    likes.value = likes.value.filter((like) => like.id !== id)
    success.value = language.t('favorites.removedSuccess')
  } catch (e) {
    error.value = language.t('favorites.removeError')
  }
}

function getTitle(like) {
  if (like.type_cible === 'annonce') {
    return like.annonce?.titre || language.t('favorites.favoriteAnnouncement')
  }

  return (
    `${like.prestataire?.prenom || ''} ${like.prestataire?.nom || ''}`.trim() ||
    language.t('favorites.favoriteProvider')
  )
}

function getDescription(like) {
  if (like.type_cible === 'annonce') {
    return like.annonce?.description || language.t('favorites.localServiceFavorite')
  }

  return like.prestataire?.description_profil || language.t('favorites.providerFavorite')
}

function getLink(like) {
  if (like.type_cible === 'annonce' && like.annonce) {
    return annonceUrl(like.annonce)
  }

  if (like.type_cible === 'prestataire' && like.prestataire) {
    return prestataireUrl(like.prestataire)
  }

  return '/annonces'
}

function getTypeLabel(type) {
  if (type === 'annonce') {
    return language.t('favorites.typeAnnouncement')
  }

  if (type === 'prestataire') {
    return language.t('favorites.typeProvider')
  }

  return language.t('favorites.typeFavorite')
}
</script>

<template>
  <section class="member-page">
    <div class="member-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('account.title') }} › {{ language.t('favorites.breadcrumb') }}
        </p>

        <h1>{{ language.t('favorites.title') }}</h1>

        <p>
          {{ language.t('favorites.subtitle') }}
        </p>
      </div>

      <RouterLink to="/annonces" class="primary-small-btn">
        {{ language.t('favorites.discoverServices') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('favorites.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <div v-if="!loading && likes.length" class="favorite-list">
      <article v-for="like in likes" :key="like.id" class="favorite-card">
        <div class="favorite-icon">
          ♥
        </div>

        <div class="favorite-content">
          <span class="favorite-type">
            {{ getTypeLabel(like.type_cible) }}
          </span>

          <h2>{{ getTitle(like) }}</h2>

          <p>{{ getDescription(like) }}</p>
        </div>

        <div class="favorite-actions">
          <RouterLink :to="getLink(like)" class="secondary-small-btn">
            {{ language.t('favorites.consult') }}
          </RouterLink>

          <button type="button" class="danger-small-btn" @click="removeLike(like.id)">
            {{ language.t('favorites.remove') }}
          </button>
        </div>
      </article>
    </div>

    <div v-if="!loading && likes.length === 0" class="empty-results">
      <h2>{{ language.t('favorites.emptyTitle') }}</h2>
      <p>{{ language.t('favorites.emptyText') }}</p>
    </div>
  </section>
</template>
