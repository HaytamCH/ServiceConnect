<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { extractIdFromSlug, annonceUrl } from '../../utils/slug'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const prestataire = ref(null)
const loading = ref(true)
const error = ref(null)

const currentLike = ref(null)
const likeLoading = ref(false)
const likeMessage = ref('')
const likeError = ref('')

const isOwnProfile = computed(() => {
  return Number(auth.user?.id) === Number(prestataire.value?.id)
})

onMounted(async () => {
  try {
    const prestataireId = extractIdFromSlug(route.params.id)
    const response = await api.get(`/prestataires/${prestataireId}`)
    prestataire.value = response.data.data

    if (auth.isAuthenticated) {
      await loadCurrentLike()
    }
  } catch (e) {
    error.value = 'Impossible de charger le profil du prestataire.'
  } finally {
    loading.value = false
  }
})

function getProfilePhotoUrl(user) {
  return user?.photo_profil_url || ''
}

function extractArray(response) {
  return response.data.data || []
}

async function loadCurrentLike() {
  try {
    const response = await api.get('/mes-likes')
    const likes = extractArray(response)

    currentLike.value =
      likes.find((like) => {
        const likedPrestataireId = like.prestataire_id || like.prestataire?.id

        return (
          like.type_cible === 'prestataire' &&
          Number(likedPrestataireId) === Number(prestataire.value.id)
        )
      }) || null
  } catch (e) {
    currentLike.value = null
  }
}

async function toggleProviderFavorite() {
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

  if (!prestataire.value) {
    likeError.value = 'Prestataire introuvable.'
    return
  }

  if (isOwnProfile.value) {
    likeError.value = 'Vous ne pouvez pas ajouter votre propre profil aux favoris.'
    return
  }

  likeLoading.value = true

  try {
    if (currentLike.value) {
      await api.delete(`/likes/${currentLike.value.id}`)
      currentLike.value = null
      likeMessage.value = 'Prestataire retiré de vos favoris.'
    } else {
      const response = await api.post('/likes', {
        type_cible: 'prestataire',
        prestataire_id: prestataire.value.id,
      })

      currentLike.value = response.data.data || response.data.like || response.data
      likeMessage.value = 'Prestataire ajouté à vos favoris.'

      await loadCurrentLike()
    }
  } catch (e) {
    likeError.value =
      e.response?.data?.message || 'Impossible de modifier ce favori.'
  } finally {
    likeLoading.value = false
  }
}
</script>

<template>
  <section class="provider-page">
    <RouterLink to="/annonces" class="back-link">
      ← Retour aux services
    </RouterLink>

    <p v-if="loading">Chargement du profil...</p>
    <p v-if="error" class="error-message">{{ error }}</p>

    <div v-if="prestataire" class="provider-profile-layout">
      <section class="provider-hero-card">
        <div class="provider-main-info">
          <div class="provider-avatar-xl user-avatar">
            <img
              v-if="getProfilePhotoUrl(prestataire)"
              :src="getProfilePhotoUrl(prestataire)"
              alt="Photo du prestataire"
            />

            <span v-else class="default-avatar-icon"></span>
          </div>

          <div>
            <h1>{{ prestataire.prenom }} {{ prestataire.nom }}</h1>
            <p class="provider-role">Prestataire ServiceConnect</p>

            <div class="provider-facts">
              <span>📍 {{ prestataire.localisation || 'Localisation non indiquée' }}</span>
              <span>⭐ {{ prestataire.note_moyenne || 'Nouveau' }} — {{ prestataire.nombre_avis || 0 }} avis</span>
              <span v-if="prestataire.paiement_active">🔒 Paiement en ligne activé</span>
              <span v-else>💶 Paiement à confirmer</span>
            </div>
          </div>
        </div>

        <div class="provider-description">
          <p>
            {{ prestataire.description_profil || 'Ce prestataire propose des services locaux via ServiceConnect.' }}
          </p>
        </div>
      </section>

      <section class="provider-content-grid">
        <main class="provider-services-card">
          <div class="section-heading">
            <h2>Services proposés</h2>
            <span>{{ prestataire.annonces?.length || 0 }} service(s)</span>
          </div>

          <div v-if="prestataire.annonces?.length" class="provider-services-grid">
            <RouterLink
              v-for="annonce in prestataire.annonces"
              :key="annonce.id"
              :to="annonceUrl(annonce)"
              class="provider-service-item"
            >
              <div class="service-icon">🛠️</div>

              <div>
                <h3>{{ annonce.titre }}</h3>
                <p>{{ annonce.categorie?.nom || 'Service local' }}</p>
                <strong>{{ annonce.tarif || 25 }} €/h</strong>
              </div>
            </RouterLink>
          </div>

          <p v-else class="muted-text">
            Ce prestataire n’a pas encore publié d’annonce visible.
          </p>
        </main>

        <aside class="provider-side-card">
          <h2>Informations</h2>

          <ul>
            <li>✅ Profil actif</li>
            <li>📍 {{ prestataire.localisation || 'Belgique' }}</li>
            <li>⭐ {{ prestataire.nombre_avis || 0 }} avis client(s)</li>
            <li>🔒 Sécurité ServiceConnect</li>
          </ul>

          <RouterLink
            v-if="!isOwnProfile"
            :to="{
              path: '/mes-messages',
              query: {
                destinataire_id: prestataire.id,
                destinataire_nom: `${prestataire.prenom} ${prestataire.nom}`
              }
            }"
            class="primary-action full-width"
          >
            Contacter
          </RouterLink>

          <button
            v-if="!isOwnProfile"
            type="button"
            class="secondary-action full-width"
            :class="{ liked: currentLike }"
            :disabled="likeLoading"
            @click="toggleProviderFavorite"
          >
            {{
              likeLoading
                ? 'Traitement...'
                : currentLike
                  ? 'Retirer des favoris'
                  : 'Ajouter aux favoris'
            }}
          </button>

          <p v-if="isOwnProfile" class="muted-text">
            Ceci est votre profil prestataire.
          </p>

          <p v-if="likeMessage" class="success-message">
            {{ likeMessage }}
          </p>

          <p v-if="likeError" class="error-message">
            {{ likeError }}
          </p>

          <RouterLink to="/annonces" class="secondary-action full-width">
            Voir les services
          </RouterLink>
        </aside>
      </section>
    </div>
  </section>
</template>
