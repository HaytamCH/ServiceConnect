<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import serviceImage from '../../assets/images/handyman-service.webp'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { extractIdFromSlug, prestataireUrl } from '../../utils/slug'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const language = useLanguageStore()

const annonce = ref(null)
const loading = ref(true)
const error = ref(null)

const selectedDisponibiliteId = ref(null)
const reservationLoading = ref(false)
const reservationMessage = ref('')
const reservationError = ref('')

const currentLike = ref(null)
const likeLoading = ref(false)
const likeMessage = ref('')
const likeError = ref('')

const shareMessage = ref('')
const shareError = ref('')

const availableDisponibilites = computed(() => {
  return (annonce.value?.disponibilites || [])
    .filter((disponibilite) => disponibilite.disponible !== false)
    .slice(0, 3)
})

const backLink = computed(() => {
  if (route.query.retour === 'prestataire') {
    return '/prestataire/annonces'
  }

  if (route.query.retour === 'admin') {
    const query = {
      page: route.query.admin_page || 1,
    }

    if (route.query.admin_search) {
      query.search = route.query.admin_search
    }

    return {
      path: '/admin/annonces',
      query,
    }
  }

  return '/annonces'
})

const backLabel = computed(() => {
  if (route.query.retour === 'prestataire') {
    return language.t('announcementDetail.backToMyAnnouncements')
  }

  if (route.query.retour === 'admin') {
    return 'Retour à la gestion des annonces'
  }

  return language.t('common.backToServices')
})

onMounted(async () => {
  try {
    const annonceId = extractIdFromSlug(route.params.id)
    const response = await api.get(`/annonces/${annonceId}`)
    annonce.value = response.data.data

    if (auth.isAuthenticated) {
      await loadCurrentLike()
    }
  } catch (e) {
    error.value = language.t('announcementDetail.loadError')
  } finally {
    loading.value = false
  }
})

function extractArray(response) {
  return response.data.data || []
}

async function loadCurrentLike() {
  try {
    const response = await api.get('/mes-likes')
    const likes = extractArray(response)

    currentLike.value =
      likes.find((like) => {
        const likedAnnonceId = like.annonce_id || like.annonce?.id

        return (
          like.type_cible === 'annonce' &&
          Number(likedAnnonceId) === Number(annonce.value.id)
        )
      }) || null
  } catch (e) {
    currentLike.value = null
  }
}

function selectDisponibilite(disponibilite) {
  selectedDisponibiliteId.value = disponibilite.id
  reservationError.value = ''
  reservationMessage.value = ''
}

async function reserveAnnonce() {
  reservationError.value = ''
  reservationMessage.value = ''

  if (!auth.isAuthenticated) {
    router.push({
      path: '/login',
      query: {
        redirect: route.fullPath,
      },
    })

    return
  }

  if (!annonce.value) {
    reservationError.value = language.t('announcementDetail.notFound')
    return
  }

  if (
    annonce.value.prestataire?.id &&
    auth.user?.id &&
    Number(annonce.value.prestataire.id) === Number(auth.user.id)
  ) {
    reservationError.value = language.t('announcementDetail.ownAnnouncementReservation')
    return
  }

  if (!selectedDisponibiliteId.value) {
    reservationError.value = language.t('announcementDetail.chooseSlot')
    return
  }

  reservationLoading.value = true

  try {
    await api.post('/reservations', {
      annonce_id: annonce.value.id,
      disponibilite_id: selectedDisponibiliteId.value,
      message_demande: null,
    })

    const reservedSlot = annonce.value.disponibilites.find(
      (disponibilite) => Number(disponibilite.id) === Number(selectedDisponibiliteId.value),
    )

    if (reservedSlot) {
      reservedSlot.disponible = false
    }

    selectedDisponibiliteId.value = null
    reservationMessage.value = language.t('announcementDetail.reservationSuccess')

    setTimeout(() => {
      router.push('/mes-reservations')
    }, 700)
  } catch (e) {
    reservationError.value =
      e.response?.data?.message || language.t('announcementDetail.reservationError')
  } finally {
    reservationLoading.value = false
  }
}

async function toggleAnnonceFavorite() {
  likeMessage.value = ''
  likeError.value = ''

  if (!auth.isAuthenticated) {
    router.push({
      path: '/login',
      query: {
        redirect: route.fullPath,
      },
    })

    return
  }

  if (!annonce.value) {
    likeError.value = language.t('announcementDetail.notFound')
    return
  }

  likeLoading.value = true

  try {
    if (currentLike.value) {
      await api.delete(`/likes/${currentLike.value.id}`)
      currentLike.value = null
      likeMessage.value = language.t('announcementDetail.favoriteRemoved')
    } else {
      const response = await api.post('/likes', {
        type_cible: 'annonce',
        annonce_id: annonce.value.id,
      })

      currentLike.value = response.data.data || response.data.like || response.data
      likeMessage.value = language.t('announcementDetail.favoriteAdded')

      await loadCurrentLike()
    }
  } catch (e) {
    likeError.value =
      e.response?.data?.message || language.t('announcementDetail.favoriteError')
  } finally {
    likeLoading.value = false
  }
}

async function shareAnnonce() {
  shareMessage.value = ''
  shareError.value = ''

  if (!annonce.value) {
    shareError.value = language.t('announcementDetail.notFound')
    return
  }

  const shareUrl = `${window.location.origin}${route.fullPath}`

  const shareData = {
    title: annonce.value.titre,
    text: language.t('announcementDetail.shareText').replace('{title}', annonce.value.titre),
    url: shareUrl,
  }

  try {
    if (navigator.share) {
      await navigator.share(shareData)
      shareMessage.value = language.t('announcementDetail.shareSuccess')
    } else {
      await navigator.clipboard.writeText(shareUrl)
      shareMessage.value = language.t('announcementDetail.shareCopied')
    }
  } catch (e) {
    shareError.value = language.t('announcementDetail.shareError')
  }
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

  if (key === 'default') {
    return categorie.nom
  }

  return language.t(`home.categoryNames.${key}`)
}

  const key = getCategoryKey(categorie.nom)
  return language.t(`home.categoryNames.${key}`)
}

function formatDate(date) {
  if (!date) {
    return ''
  }

  const locale =
    language.current === 'en'
      ? 'en-GB'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Date(date).toLocaleString(locale)
}

function reviewsLabel(count) {
  return language.t('announcementDetail.reviews').replace('{count}', count)
}
</script>

<template>
  <section class="annonce-detail-page">
    <RouterLink :to="backLink" class="back-link">
      ← {{ backLabel }}
    </RouterLink>

    <p v-if="loading">
      {{ language.t('announcementDetail.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <div v-if="annonce" class="detail-layout">
      <main class="detail-card">
        <div class="detail-main">
          <img class="detail-image" :src="serviceImage" :alt="annonce.titre" />

          <div class="detail-info">
            <span class="service-badge">
              {{ getCategoryName(annonce.categorie) }}
            </span>

            <h1>{{ annonce.titre }}</h1>

            <div class="detail-meta">
              <span>
                👤 {{ language.t('announcementDetail.provider') }} :
                {{ annonce.prestataire?.prenom }} {{ annonce.prestataire?.nom }}
              </span>

              <span>
                📍 {{ annonce.localisation || annonce.prestataire?.localisation }}
              </span>

              <span>
                💶 {{ annonce.tarif }} €/h
              </span>

              <span>
                ⭐ {{ annonce.note_moyenne || language.t('announcementDetail.newProvider') }}
                —
                {{ reviewsLabel(annonce.nombre_avis || 0) }}
              </span>
            </div>

            <p class="detail-description">
              {{ annonce.description }}
            </p>
          </div>
        </div>

        <div class="availability-section">
          <h2>{{ language.t('announcementDetail.availabilities') }}</h2>

          <div v-if="availableDisponibilites.length" class="slot-grid">
            <button
              v-for="disponibilite in availableDisponibilites"
              :key="disponibilite.id"
              type="button"
              class="slot-card slot-button"
              :class="{ selected: selectedDisponibiliteId === disponibilite.id }"
              @click="selectDisponibilite(disponibilite)"
            >
              <strong>{{ language.t('announcementDetail.availableSlot') }}</strong>
              <span>{{ formatDate(disponibilite.date_debut) }}</span>
              <small>{{ language.t('announcementDetail.selectSlot') }}</small>
            </button>
          </div>

          <p v-else class="muted-text">
            {{ language.t('announcementDetail.noAvailability') }}
          </p>
        </div>

        <div class="detail-actions">
          <button
            type="button"
            class="primary-action"
            :disabled="reservationLoading || !availableDisponibilites.length"
            @click="reserveAnnonce"
          >
            {{
              reservationLoading
                ? language.t('announcementDetail.reservationLoading')
                : language.t('common.reserve')
            }}
          </button>

          <RouterLink
            v-if="annonce.prestataire"
            :to="{
              path: '/mes-messages',
              query: {
                destinataire_id: annonce.prestataire.id,
                destinataire_nom: `${annonce.prestataire.prenom} ${annonce.prestataire.nom}`,
                annonce_id: annonce.id,
                annonce_titre: annonce.titre
              }
            }"
            class="secondary-action"
          >
            {{ language.t('common.message') }}
          </RouterLink>

          <button
            type="button"
            class="secondary-action"
            :class="{ liked: currentLike }"
            :disabled="likeLoading"
            @click="toggleAnnonceFavorite"
          >
            {{
              likeLoading
                ? language.t('announcementDetail.processing')
                : currentLike
                  ? language.t('common.removeFavorite')
                  : language.t('common.like')
            }}
          </button>

          <button type="button" class="secondary-action" @click="shareAnnonce">
            {{ language.t('common.share') }}
          </button>
        </div>

        <p v-if="reservationMessage" class="success-message">
          {{ reservationMessage }}
        </p>

        <p v-if="reservationError" class="error-message">
          {{ reservationError }}
        </p>

        <p v-if="likeMessage" class="success-message">
          {{ likeMessage }}
        </p>

        <p v-if="likeError" class="error-message">
          {{ likeError }}
        </p>

        <p v-if="shareMessage" class="success-message">
          {{ shareMessage }}
        </p>

        <p v-if="shareError" class="error-message">
          {{ shareError }}
        </p>
      </main>

      <aside class="provider-card">
        <div class="provider-avatar-large">
          {{ annonce.prestataire?.prenom?.charAt(0) || 'P' }}
        </div>

        <h2>{{ annonce.prestataire?.prenom }} {{ annonce.prestataire?.nom }}</h2>

        <p>
          {{
            annonce.prestataire?.description_profil ||
            language.t('announcementDetail.localProviderText')
          }}
        </p>

        <ul>
          <li>📍 {{ annonce.prestataire?.localisation || annonce.localisation }}</li>
          <li>✅ {{ language.t('announcementDetail.activeProfile') }}</li>
          <li>🔒 {{ language.t('home.securePayment') }}</li>
        </ul>

        <RouterLink
          v-if="annonce.prestataire"
          :to="prestataireUrl(annonce.prestataire)"
          class="provider-profile-link"
        >
          {{ language.t('search.viewProfile') }}
        </RouterLink>
      </aside>
    </div>
  </section>
</template>
