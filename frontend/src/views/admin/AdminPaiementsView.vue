<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'

const route = useRoute()
const router = useRouter()

const paiements = ref([])
const loading = ref(true)
const updatingId = ref(null)
const error = ref('')
const success = ref('')

const search = ref(String(route.query.search || ''))
const statusFilter = ref(String(route.query.statut || ''))

const currentPage = ref(1)
const lastPage = ref(1)
const totalPaiements = ref(0)

onMounted(async () => {
  const pageFromUrl = Number(route.query.page || 1)
  await loadPaiements(pageFromUrl)
})

function buildQuery(page = 1) {
  const query = {
    page,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  if (statusFilter.value) {
    query.statut = statusFilter.value
  }

  return query
}

async function loadPaiements(page = 1) {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/admin/paiements', {
      params: buildQuery(page),
    })

    const payload = response.data

    paiements.value = payload.data || []
    currentPage.value = payload.current_page || 1
    lastPage.value = payload.last_page || 1
    totalPaiements.value = payload.total || paiements.value.length
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les paiements.'
  } finally {
    loading.value = false
  }
}

async function changePage(page) {
  if (page < 1 || page > lastPage.value || page === currentPage.value) {
    return
  }

  await router.push({
    path: '/admin/paiements',
    query: buildQuery(page),
  })

  await loadPaiements(page)
}

async function submitSearch() {
  await router.push({
    path: '/admin/paiements',
    query: buildQuery(1),
  })

  await loadPaiements(1)
}

async function resetFilters() {
  search.value = ''
  statusFilter.value = ''

  await router.push({
    path: '/admin/paiements',
    query: {
      page: 1,
    },
  })

  await loadPaiements(1)
}

async function updatePaymentStatus(paiement, statut) {
  if (paiement.statut === statut) {
    return
  }

  const oldStatus = paiement.statut

  updatingId.value = paiement.id
  error.value = ''
  success.value = ''

  try {
    await api.patch(`/admin/paiements/${paiement.id}/statut`, {
      statut,
    })

    paiement.statut = statut
    success.value = 'Statut du paiement mis à jour.'
  } catch (e) {
    paiement.statut = oldStatus
    error.value = e.response?.data?.message || 'Impossible de modifier le statut du paiement.'
  } finally {
    updatingId.value = null
  }
}

function getFullName(user) {
  if (!user) {
    return 'Utilisateur inconnu'
  }

  return `${user.prenom || ''} ${user.nom || ''}`.trim() || 'Utilisateur inconnu'
}

function getPrestataire(paiement) {
  return paiement.reservation?.prestataire || null
}

function getAnnonce(paiement) {
  return paiement.reservation?.annonce || null
}

function formatAmount(paiement) {
  return new Intl.NumberFormat('fr-BE', {
    style: 'currency',
    currency: paiement.devise || 'EUR',
  }).format(Number(paiement.montant || 0))
}

function formatDate(date) {
  if (!date) {
    return 'Date non définie'
  }

  return new Date(date).toLocaleString('fr-BE')
}

function statutLabel(statut) {
  const labels = {
    en_attente: 'En attente',
    accepte: 'Accepté',
    refuse: 'Refusé',
    rembourse: 'Remboursé',
  }

  return labels[statut] || statut
}

function methodeLabel(methode) {
  const labels = {
    stripe: 'Stripe',
    paypal: 'PayPal',
    virement_bancaire: 'Virement bancaire',
  }

  return labels[methode] || methode
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Paiements</p>
        <h1>Gestion des paiements</h1>
        <p>Consultez les paiements effectués via ServiceConnect.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des paiements...</p>
    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>

    <section v-if="!loading" class="admin-panel">
      <div class="admin-panel-header">
        <div>
          <h2>Liste des paiements</h2>
          <p>
            {{ totalPaiements }} paiement(s) au total —
            page {{ currentPage }} sur {{ lastPage }}
          </p>
        </div>

        <form class="admin-search-form" @submit.prevent="submitSearch">
          <input
            v-model="search"
            type="search"
            placeholder="Rechercher membre, prestataire, email, téléphone..."
          />

          <select v-model="statusFilter" class="admin-filter-select">
            <option value="">Tous les statuts</option>
            <option value="en_attente">En attente</option>
            <option value="accepte">Accepté</option>
            <option value="refuse">Refusé</option>
            <option value="rembourse">Remboursé</option>
          </select>

          <button type="submit" class="primary-small-btn">
            Rechercher
          </button>

          <button
            v-if="search || statusFilter"
            type="button"
            class="secondary-small-btn"
            @click="resetFilters"
          >
            Réinitialiser
          </button>
        </form>
      </div>

      <div v-if="paiements.length" class="admin-table-wrapper">
        <table class="admin-table">
          <thead>
          <tr>
            <th>Paiement</th>
            <th>Membre</th>
            <th>Prestataire</th>
            <th>Annonce</th>
            <th>Montant</th>
            <th>Méthode</th>
            <th>Statut</th>
            <th>Date</th>
            <th>Action admin</th>
          </tr>
          </thead>

          <tbody>
          <tr v-for="paiement in paiements" :key="paiement.id">
            <td>
              <strong>#{{ paiement.id }}</strong>
              <small>Réservation #{{ paiement.reservation_id }}</small>

              <small
                v-if="paiement.transaction_externe_id"
                class="admin-payment-reference"
              >
                Réf. {{ paiement.transaction_externe_id }}
              </small>
            </td>

            <td>
              <strong>{{ getFullName(paiement.membre) }}</strong>
              <small v-if="paiement.membre?.email">{{ paiement.membre.email }}</small>
              <small v-if="paiement.membre?.telephone">{{ paiement.membre.telephone }}</small>
            </td>

            <td>
              <strong>{{ getFullName(getPrestataire(paiement)) }}</strong>
              <small v-if="getPrestataire(paiement)?.email">
                {{ getPrestataire(paiement).email }}
              </small>
              <small v-if="getPrestataire(paiement)?.telephone">
                {{ getPrestataire(paiement).telephone }}
              </small>
            </td>

            <td>
              <strong>{{ getAnnonce(paiement)?.titre || 'Annonce inconnue' }}</strong>
              <small v-if="getAnnonce(paiement)?.localisation">
                {{ getAnnonce(paiement).localisation }}
              </small>
            </td>

            <td>
              <strong class="admin-money">
                {{ formatAmount(paiement) }}
              </strong>
            </td>

            <td>
              {{ methodeLabel(paiement.methode) }}
            </td>

            <td>
                <span class="admin-badge payment-status" :class="paiement.statut">
                  {{ statutLabel(paiement.statut) }}
                </span>
            </td>

            <td>
              {{ formatDate(paiement.created_at) }}
            </td>

            <td>
              <select
                :value="paiement.statut"
                :disabled="updatingId === paiement.id"
                @change="updatePaymentStatus(paiement, $event.target.value)"
              >
                <option value="en_attente">En attente</option>
                <option value="accepte">Accepté</option>
                <option value="refuse">Refusé</option>
                <option value="rembourse">Remboursé</option>
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

      <div v-if="paiements.length === 0" class="empty-results">
        <h2>Aucun paiement trouvé</h2>
        <p>Aucun paiement ne correspond à votre recherche.</p>
      </div>
    </section>
  </section>
</template>
