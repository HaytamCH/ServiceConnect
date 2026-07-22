<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { annonceUrl } from '../../utils/slug'
import { useNotificationStore } from '../../stores/notifications'

const route = useRoute()
const router = useRouter()

const notifications = useNotificationStore()

const annonces = ref([])
const loading = ref(true)
const updatingId = ref(null)
const error = ref('')
const success = ref('')

const currentPage = ref(1)
const lastPage = ref(1)
const totalAnnonces = ref(0)

const search = ref(String(route.query.search || ''))

onMounted(async () => {
  const pageFromUrl = Number(route.query.page || 1)
  await loadAnnonces(pageFromUrl)
  await markAnnonceNotificationsAsRead()
})

async function markAnnonceNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=admin_annonce_en_attente')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications annonces comme lues.')
  }
}

async function loadAnnonces(page = 1) {
  loading.value = true
  error.value = ''

  try {
    const params = {
      page,
    }

    if (search.value.trim()) {
      params.search = search.value.trim()
    }

    const response = await api.get('/admin/annonces', { params })
    const payload = response.data

    annonces.value = payload.data || []
    currentPage.value = payload.current_page || 1
    lastPage.value = payload.last_page || 1
    totalAnnonces.value = payload.total || annonces.value.length
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les annonces.'
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
    path: '/admin/annonces',
    query,
  })

  await loadAnnonces(page)
}

async function submitSearch() {
  const query = {
    page: 1,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  await router.push({
    path: '/admin/annonces',
    query,
  })

  await loadAnnonces(1)
}

async function resetSearch() {
  search.value = ''

  await router.push({
    path: '/admin/annonces',
    query: {
      page: 1,
    },
  })

  await loadAnnonces(1)
}
async function updateAnnonceStatus(annonce, statut) {
  if (annonce.statut === statut) {
    return
  }

  updatingId.value = annonce.id
  error.value = ''
  success.value = ''

  try {
    const response = await api.patch(`/admin/annonces/${annonce.id}/statut`, {
      statut,
    })

    const updatedAnnonce = response.data.data
    annonce.statut = updatedAnnonce.statut

    success.value = 'Statut de l’annonce mis à jour.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de modifier le statut de cette annonce.'
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

function formatTarif(tarif) {
  return new Intl.NumberFormat('fr-BE', {
    style: 'currency',
    currency: 'EUR',
  }).format(Number(tarif || 0))
}

function getPrestataireName(prestataire) {
  if (!prestataire) {
    return 'Prestataire inconnu'
  }

  return `${prestataire.prenom || ''} ${prestataire.nom || ''}`.trim()
}

function statusLabel(statut) {
  const labels = {
    brouillon: 'Brouillon',
    en_attente: 'En attente',
    publiee: 'Publiée',
    suspendue: 'Suspendue',
    supprimee: 'Supprimée',
  }

  return labels[statut] || statut
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Annonces</p>
        <h1>Gestion des annonces</h1>
        <p>Modérez les annonces publiées par les prestataires.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des annonces...</p>
    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>

    <section v-if="!loading" class="admin-panel">
      <div class="admin-panel-header">
        <div>
          <h2>Liste des annonces</h2>

          <p>
            {{ totalAnnonces }} annonce(s) au total —
            page {{ currentPage }} sur {{ lastPage }}
          </p>
        </div>

        <form class="admin-search-form" @submit.prevent="submitSearch">
          <input
            v-model="search"
            type="search"
            placeholder="Rechercher par titre, prestataire, email, catégorie..."
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

      <div v-if="annonces.length" class="admin-table-wrapper">
        <table class="admin-table">
          <thead>
          <tr>
            <th>Annonce</th>
            <th>Prestataire</th>
            <th>Catégorie</th>
            <th>Tarif</th>
            <th>Localisation</th>
            <th>Statut</th>
            <th>Date</th>
            <th>Action admin</th>
          </tr>
          </thead>

          <tbody>
          <tr v-for="annonce in annonces" :key="annonce.id">
            <td>
              <strong>{{ annonce.titre }}</strong>
              <small>{{ annonce.description }}</small>

              <RouterLink
                v-if="annonce.statut === 'publiee'"
                :to="{
                path: annonceUrl(annonce),
                query: {
                  retour: 'admin',
                  admin_page: currentPage,
                  admin_search: search || undefined
                }
              }"
                class="admin-inline-link"
              >
                Voir l’annonce publique
              </RouterLink>
            </td>

            <td>
              <strong>{{ getPrestataireName(annonce.prestataire) }}</strong>
              <small>{{ annonce.prestataire?.email || 'Email non disponible' }}</small>
            </td>

            <td>
              {{ annonce.categorie?.nom || 'Non indiquée' }}
            </td>

            <td>
              {{ formatTarif(annonce.tarif) }}
            </td>

            <td>
              {{ annonce.localisation || 'Non indiquée' }}
            </td>

            <td>
                <span class="admin-badge announcement-status" :class="annonce.statut">
                  {{ statusLabel(annonce.statut) }}
                </span>
            </td>

            <td>
              {{ formatDate(annonce.created_at) }}
            </td>

            <td>
              <select
                :value="annonce.statut"
                :disabled="updatingId === annonce.id"
                @change="updateAnnonceStatus(annonce, $event.target.value)"
              >
                <option value="brouillon">Brouillon</option>
                <option value="en_attente">En attente</option>
                <option value="publiee">Publiée</option>
                <option value="suspendue">Suspendue</option>
                <option value="supprimee">Supprimée</option>
              </select>
            </td>
          </tr>
          </tbody>
        </table>
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

      <div v-if="annonces.length === 0" class="empty-results">
        <h2>Aucune annonce trouvée</h2>

        <p v-if="search">
          Aucune annonce ne correspond à la recherche « {{ search }} ».
        </p>

        <p v-else>
          Aucune annonce n’est disponible pour le moment.
        </p>
      </div>
    </section>
  </section>
</template>
