<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'

const auth = useAuthStore()
const route = useRoute()
const router = useRouter()

const users = ref([])
const loading = ref(true)
const updatingId = ref(null)
const error = ref('')
const success = ref('')

const currentPage = ref(1)
const lastPage = ref(1)
const totalUsers = ref(0)


const search = ref(String(route.query.search || ''))

onMounted(async () => {
  const pageFromUrl = Number(route.query.page || 1)
  await loadUsers(pageFromUrl)
})

async function loadUsers(page = 1) {
  loading.value = true
  error.value = ''

  try {
    const params = {
      page,
    }

    if (search.value.trim()) {
      params.search = search.value.trim()
    }

    const response = await api.get('/admin/users', { params })
    const payload = response.data

    users.value = payload.data || []
    currentPage.value = payload.current_page || 1
    lastPage.value = payload.last_page || 1
    totalUsers.value = payload.total || users.value.length
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les utilisateurs.'
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
    path: '/admin/users',
    query,
  })

  await loadUsers(page)
}

async function submitSearch() {
  const query = {
    page: 1,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  await router.push({
    path: '/admin/users',
    query,
  })

  await loadUsers(1)
}

async function resetSearch() {
  search.value = ''

  await router.push({
    path: '/admin/users',
    query: {
      page: 1,
    },
  })

  await loadUsers(1)
}
async function updateUserStatus(user, statut) {
  if (user.statut === statut) {
    return
  }

  updatingId.value = user.id
  error.value = ''
  success.value = ''

  try {
    await api.patch(`/admin/users/${user.id}/statut`, {
      statut,
    })

    user.statut = statut
    success.value = 'Statut de l’utilisateur mis à jour.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de modifier le statut de cet utilisateur.'
  } finally {
    updatingId.value = null
  }
}

async function acceptProviderRequest(user) {
  updatingId.value = user.id
  error.value = ''
  success.value = ''

  try {
    const response = await api.patch(`/admin/users/${user.id}/demande-prestataire/accepter`)
    Object.assign(user, response.data.data || {})
    success.value = 'Demande prestataire acceptée.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible d’accepter cette demande.'
  } finally {
    updatingId.value = null
  }
}

async function rejectProviderRequest(user) {
  updatingId.value = user.id
  error.value = ''
  success.value = ''

  try {
    const response = await api.patch(`/admin/users/${user.id}/demande-prestataire/refuser`)
    Object.assign(user, response.data.data || {})
    success.value = 'Demande prestataire refusée.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de refuser cette demande.'
  } finally {
    updatingId.value = null
  }
}

function providerRequestLabel(statut) {
  const labels = {
    aucune: 'Aucune',
    en_attente: 'En attente',
    acceptee: 'Acceptée',
    refusee: 'Refusée',
  }

  return labels[statut] || 'Aucune'
}

function formatDate(date) {
  if (!date) {
    return 'Date non définie'
  }

  return new Date(date).toLocaleDateString('fr-BE')
}

function getUserName(user) {
  return `${user.prenom || ''} ${user.nom || ''}`.trim() || 'Utilisateur'
}

function roleLabel(role) {
  const labels = {
    membre: 'Membre',
    prestataire: 'Prestataire',
    administrateur: 'Administrateur',
  }

  return labels[role] || role
}

function statusLabel(statut) {
  const labels = {
    actif: 'Actif',
    suspendu: 'Suspendu',
    desactive: 'Désactivé',
  }

  return labels[statut] || statut
}

function canEditStatus(user) {
  if (user.role === 'administrateur' && user.id === auth.user?.id) {
    return false
  }

  return true
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Utilisateurs</p>
        <h1>Gestion des utilisateurs</h1>
        <p>Consultez les comptes membres, prestataires et administrateurs.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des utilisateurs...</p>
    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>

    <section v-if="!loading" class="admin-panel">
      <div class="admin-panel-header">
        <!-- Bloc du titre -->
        <div>
          <h2>Liste des utilisateurs</h2>

          <p>
            {{ totalUsers }} utilisateur(s) au total —
            page {{ currentPage }} sur {{ lastPage }}
          </p>
        </div>

        <!-- Formulaire de recherche -->
        <form class="admin-search-form" @submit.prevent="submitSearch">
          <input
            v-model="search"
            type="search"
            placeholder="Rechercher par nom, prénom, email, téléphone..."
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

      <div v-if="users.length" class="admin-table-wrapper">
        <table class="admin-table">
          <thead>
          <tr>
            <th>Utilisateur</th>
            <th>Email</th>
            <th>Rôle</th>
            <th>Statut</th>
            <th>Localisation</th>
            <th>Date d’inscription</th>
            <th>Demande prestataire</th>
            <th>Action admin</th>
          </tr>
          </thead>

          <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>
              <strong>{{ getUserName(user) }}</strong>
              <small v-if="user.telephone">{{ user.telephone }}</small>
            </td>

            <td>{{ user.email }}</td>

            <td>
                <span class="admin-badge role" :class="user.role">
                  {{ roleLabel(user.role) }}
                </span>
            </td>

            <td>
                <span class="admin-badge status" :class="user.statut">
                  {{ statusLabel(user.statut) }}
                </span>
            </td>

            <td>{{ user.localisation || 'Non indiquée' }}</td>

            <td>{{ formatDate(user.created_at) }}</td>

            <td>
              <span
                class="admin-badge status"
                :class="user.demande_prestataire_statut || 'aucune'"
              >
                {{ providerRequestLabel(user.demande_prestataire_statut) }}
              </span>

              <div
                v-if="user.demande_prestataire_statut === 'en_attente'"
                class="admin-request-actions"
              >
                <small v-if="user.demande_prestataire_description">
                  {{ user.demande_prestataire_description }}
                </small>

                <small v-if="user.demande_prestataire_localisation">
                  📍 {{ user.demande_prestataire_localisation }}
                </small>

                <button
                  type="button"
                  class="primary-small-btn"
                  :disabled="updatingId === user.id"
                  @click="acceptProviderRequest(user)"
                >
                  Accepter
                </button>

                <button
                  type="button"
                  class="secondary-small-btn"
                  :disabled="updatingId === user.id"
                  @click="rejectProviderRequest(user)"
                >
                  Refuser
                </button>
              </div>
            </td>

            <td>
              <select
                :value="user.statut"
                :disabled="!canEditStatus(user) || updatingId === user.id"
                @change="updateUserStatus(user, $event.target.value)"
              >
                <option value="actif">Actif</option>
                <option value="suspendu">Suspendu</option>
                <option value="desactive">Désactivé</option>
              </select>

              <small v-if="!canEditStatus(user)" class="admin-note">
                Compte admin actuel
              </small>
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

      <div v-if="!users.length" class="empty-results">
        <h2>Aucun utilisateur trouvé</h2>

        <p v-if="search">
          Aucun utilisateur ne correspond à la recherche « {{ search }} ».
        </p>

        <p v-else>
          Aucun compte n’est disponible pour le moment.
        </p>
      </div>
    </section>
  </section>
</template>
