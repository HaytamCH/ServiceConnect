<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'

const route = useRoute()
const router = useRouter()

const avis = ref([])
const loading = ref(true)
const updatingId = ref(null)
const error = ref('')
const success = ref('')

const currentPage = ref(1)
const lastPage = ref(1)
const totalAvis = ref(0)

const search = ref(String(route.query.search || ''))

onMounted(async () => {
  const pageFromUrl = Number(route.query.page || 1)
  await loadAvis(pageFromUrl)
})

async function loadAvis(page = 1) {
  loading.value = true
  error.value = ''

  try {
    const params = {
      page,
    }

    if (search.value.trim()) {
      params.search = search.value.trim()
    }

    const response = await api.get('/admin/avis', { params })
    const payload = response.data

    avis.value = payload.data || []
    currentPage.value = payload.current_page || 1
    lastPage.value = payload.last_page || 1
    totalAvis.value = payload.total || avis.value.length
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les avis.'
  } finally {
    loading.value = false
  }
}

async function changePage(page) {
  if (page < 1 || page > lastPage.value || page === currentPage.value) {
    return
  }

  const query = {
    page,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  await router.push({
    path: '/admin/avis',
    query,
  })

  await loadAvis(page)
}

async function submitSearch() {
  const query = {
    page: 1,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  await router.push({
    path: '/admin/avis',
    query,
  })

  await loadAvis(1)
}

async function resetSearch() {
  search.value = ''

  await router.push({
    path: '/admin/avis',
    query: {
      page: 1,
    },
  })

  await loadAvis(1)
}

async function toggleVisibility(item) {
  updatingId.value = item.id
  error.value = ''
  success.value = ''

  try {
    const response = await api.patch(`/admin/avis/${item.id}/visibilite`, {
      visible: !item.visible,
    })

    const updatedAvis = response.data.data
    item.visible = updatedAvis.visible

    success.value = item.visible
      ? 'Avis affiché avec succès.'
      : 'Avis masqué avec succès.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de modifier la visibilité de cet avis.'
  } finally {
    updatingId.value = null
  }
}

function formatDate(date) {
  if (!date) {
    return 'Date non définie'
  }

  return new Date(date).toLocaleDateString('fr-BE')
}

function getFullName(user) {
  if (!user) {
    return 'Utilisateur inconnu'
  }

  return `${user.prenom || ''} ${user.nom || ''}`.trim()
}

function getStars(note) {
  const value = Number(note || 0)
  return '⭐'.repeat(value)
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Avis</p>
        <h1>Gestion des avis</h1>
        <p>Consultez, affichez ou masquez les avis laissés par les membres.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des avis...</p>
    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>

    <section v-if="!loading" class="admin-panel">
      <div class="admin-panel-header">
        <div>
          <h2>Liste des avis</h2>
          <p>
            {{ totalAvis }} avis au total —
            page {{ currentPage }} sur {{ lastPage }}
          </p>
        </div>

        <form class="admin-search-form" @submit.prevent="submitSearch">
          <input
            v-model="search"
            type="search"
            placeholder="Rechercher membre, prestataire, email, téléphone..."
          />

          <button type="submit" class="primary-small-btn">
            Rechercher
          </button>

          <button
            v-if="search"
            type="button"
            class="secondary-small-btn"
            @click="resetSearch"
          >
            Réinitialiser
          </button>
        </form>
      </div>

      <div v-if="avis.length" class="admin-review-list">
        <article
          v-for="item in avis"
          :key="item.id"
          class="admin-review-card"
        >
          <div class="admin-review-top">
            <div>
              <h3>{{ item.annonce?.titre || 'Annonce inconnue' }}</h3>

              <p class="admin-review-meta">
                Membre :
                <strong>{{ getFullName(item.membre) }}</strong>
                <span v-if="item.membre?.email"> — {{ item.membre.email }}</span>
                <span v-if="item.membre?.telephone"> — {{ item.membre.telephone }}</span>
              </p>

              <p class="admin-review-meta">
                Prestataire :
                <strong>{{ getFullName(item.prestataire) }}</strong>
                <span v-if="item.prestataire?.email"> — {{ item.prestataire.email }}</span>
                <span v-if="item.prestataire?.telephone"> — {{ item.prestataire.telephone }}</span>
              </p>

              <p class="admin-review-date">
                Réservation #{{ item.reservation?.id || item.reservation_id || 'N/A' }} :
                {{ item.reservation?.statut || 'Statut non disponible' }}
                <span v-if="item.reservation?.date_service">
                  —
                  {{ formatDate(item.reservation.date_service) }}
                </span>
              </p>
            </div>

            <span
              class="admin-badge status"
              :class="item.visible ? 'actif' : 'desactive'"
            >
              {{ item.visible ? 'Visible' : 'Masqué' }}
            </span>
          </div>

          <div class="admin-review-content">
            <strong>{{ getStars(item.note) }} {{ item.note }}/5</strong>
            <p>{{ item.commentaire || 'Aucun commentaire.' }}</p>
          </div>

          <div class="admin-category-actions">
            <button
              type="button"
              class="secondary-small-btn"
              :disabled="updatingId === item.id"
              @click="toggleVisibility(item)"
            >
              {{
                updatingId === item.id
                  ? 'Modification...'
                  : item.visible
                    ? 'Masquer l’avis'
                    : 'Afficher l’avis'
              }}
            </button>
          </div>
        </article>
      </div>

      <div v-if="lastPage > 1" class="admin-pagination">
        <button
          type="button"
          class="secondary-small-btn"
          :disabled="currentPage === 1"
          @click="changePage(currentPage - 1)"
        >
          Précédent
        </button>

        <span>
          Page {{ currentPage }} / {{ lastPage }}
        </span>

        <button
          type="button"
          class="secondary-small-btn"
          :disabled="currentPage === lastPage"
          @click="changePage(currentPage + 1)"
        >
          Suivant
        </button>
      </div>

      <div v-if="avis.length === 0" class="empty-results">
        <h2>Aucun avis</h2>
        <p>Aucun avis n’est disponible pour le moment.</p>
      </div>
    </section>
  </section>
</template>
