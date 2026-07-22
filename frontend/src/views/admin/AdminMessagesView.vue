<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useNotificationStore } from '../../stores/notifications'

const route = useRoute()
const router = useRouter()
const notifications = useNotificationStore()

const messages = ref([])
const loading = ref(true)
const error = ref('')

const currentPage = ref(1)
const lastPage = ref(1)
const totalMessages = ref(0)

const search = ref(String(route.query.search || ''))

onMounted(async () => {
  const pageFromUrl = Number(route.query.page || 1)
  await loadMessages(pageFromUrl)
  await markMessageNotificationsAsRead()
})

async function loadMessages(page = 1) {
  loading.value = true
  error.value = ''

  try {
    const params = {
      page,
    }

    if (search.value.trim()) {
      params.search = search.value.trim()
    }

    const response = await api.get('/admin/messages', { params })
    const payload = response.data

    messages.value = payload.data || []
    currentPage.value = payload.current_page || 1
    lastPage.value = payload.last_page || 1
    totalMessages.value = payload.total || messages.value.length
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les messages.'
  } finally {
    loading.value = false
  }
}

async function markMessageNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=admin_message_echange')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications messages comme lues.')
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
    path: '/admin/messages',
    query,
  })

  await loadMessages(page)
}

async function submitSearch() {
  const query = {
    page: 1,
  }

  if (search.value.trim()) {
    query.search = search.value.trim()
  }

  await router.push({
    path: '/admin/messages',
    query,
  })

  await loadMessages(1)
}

async function resetSearch() {
  search.value = ''

  await router.push({
    path: '/admin/messages',
    query: {
      page: 1,
    },
  })

  await loadMessages(1)
}

function formatDate(date) {
  if (!date) {
    return 'Date non définie'
  }

  return new Date(date).toLocaleString('fr-BE')
}

function getFullName(user) {
  if (!user) {
    return 'Utilisateur inconnu'
  }

  return `${user.prenom || ''} ${user.nom || ''}`.trim()
}

function roleLabel(role) {
  const labels = {
    membre: 'Membre',
    prestataire: 'Prestataire',
    administrateur: 'Administrateur',
  }

  return labels[role] || role || ''
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Messages</p>
        <h1>Messages échangés</h1>
        <p>Consultez les échanges entre les membres et les prestataires.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des messages...</p>
    <p v-if="error" class="error-message">{{ error }}</p>

    <section v-if="!loading" class="admin-panel">
      <div class="admin-panel-header">
        <div>
          <h2>Liste des messages</h2>
          <p>
            {{ totalMessages }} message(s) au total —
            page {{ currentPage }} sur {{ lastPage }}
          </p>
        </div>

        <form class="admin-search-form" @submit.prevent="submitSearch">
          <input
            v-model="search"
            type="search"
            placeholder="Rechercher par nom, email, téléphone, contenu, annonce..."
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

      <div v-if="messages.length" class="admin-review-list">
        <article
          v-for="message in messages"
          :key="message.id"
          class="admin-review-card"
        >
          <div class="admin-review-top">
            <div>
              <h3>
                {{ getFullName(message.expediteur) }}
                →
                {{ getFullName(message.destinataire) }}
              </h3>

              <p class="admin-review-meta">
                Expéditeur :
                <strong>{{ getFullName(message.expediteur) }}</strong>
                <span v-if="message.expediteur?.role">
                  — {{ roleLabel(message.expediteur.role) }}
                </span>
                <span v-if="message.expediteur?.email">
                  — {{ message.expediteur.email }}
                </span>
                <span v-if="message.expediteur?.telephone">
                  — {{ message.expediteur.telephone }}
                </span>
              </p>

              <p class="admin-review-meta">
                Destinataire :
                <strong>{{ getFullName(message.destinataire) }}</strong>
                <span v-if="message.destinataire?.role">
                  — {{ roleLabel(message.destinataire.role) }}
                </span>
                <span v-if="message.destinataire?.email">
                  — {{ message.destinataire.email }}
                </span>
                <span v-if="message.destinataire?.telephone">
                  — {{ message.destinataire.telephone }}
                </span>
              </p>

              <p class="admin-review-date">
                Envoyé le {{ formatDate(message.created_at) }}
              </p>

              <p v-if="message.reservation" class="admin-review-date">
                Réservation #{{ message.reservation.id }}
                — {{ message.reservation.statut }}
                <span v-if="message.reservation.annonce">
                  — {{ message.reservation.annonce.titre }}
                </span>
              </p>
            </div>

            <span class="admin-badge status actif">
              Message
            </span>
          </div>

          <div class="admin-review-content">
            <p>{{ message.contenu }}</p>
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

      <div v-if="messages.length === 0" class="empty-results">
        <h2>Aucun message trouvé</h2>

        <p v-if="search">
          Aucun message ne correspond à la recherche « {{ search }} ».
        </p>

        <p v-else>
          Aucun message n’est disponible pour le moment.
        </p>
      </div>
    </section>
  </section>
</template>
