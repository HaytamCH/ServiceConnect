<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'

const stats = ref(null)
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  await loadDashboard()
})

async function loadDashboard() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/admin/dashboard')
    stats.value = response.data.data
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger le tableau de bord administrateur.'
  } finally {
    loading.value = false
  }
}

function formatAmount(value) {
  return new Intl.NumberFormat('fr-BE', {
    style: 'currency',
    currency: 'EUR',
  }).format(Number(value || 0))
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Tableau de bord</p>
        <h1>Tableau de bord administrateur</h1>
        <p>Suivez l’activité générale de la plateforme ServiceConnect.</p>
      </div>

      <RouterLink to="/mon-espace" class="secondary-small-btn">
        Retour à mon espace
      </RouterLink>
    </div>

    <p v-if="loading">Chargement du tableau de bord...</p>
    <p v-if="error" class="error-message">{{ error }}</p>

    <div v-if="!loading && stats" class="admin-stats-grid">
      <article class="admin-stat-card">
        <span>👥</span>
        <h2>{{ stats.nombre_utilisateurs }}</h2>
        <p>Utilisateurs</p>
      </article>

      <article class="admin-stat-card">
        <span>🙋</span>
        <h2>{{ stats.nombre_membres }}</h2>
        <p>Membres</p>
      </article>

      <article class="admin-stat-card">
        <span>🛠️</span>
        <h2>{{ stats.nombre_prestataires }}</h2>
        <p>Prestataires</p>
      </article>

      <article class="admin-stat-card">
        <span>🛡️</span>
        <h2>{{ stats.nombre_administrateurs }}</h2>
        <p>Administrateurs</p>
      </article>

      <article class="admin-stat-card">
        <span>📂</span>
        <h2>{{ stats.nombre_categories }}</h2>
        <p>Catégories</p>
      </article>

      <article class="admin-stat-card">
        <span>📢</span>
        <h2>{{ stats.nombre_annonces }}</h2>
        <p>Annonces</p>
      </article>

      <article class="admin-stat-card">
        <span>⏳</span>
        <h2>{{ stats.nombre_annonces_en_attente }}</h2>
        <p>Annonces en attente</p>
      </article>

      <article class="admin-stat-card">
        <span>✅</span>
        <h2>{{ stats.nombre_annonces_publiees }}</h2>
        <p>Annonces publiées</p>
      </article>

      <article class="admin-stat-card">
        <span>📅</span>
        <h2>{{ stats.nombre_reservations }}</h2>
        <p>Réservations</p>
      </article>

      <article class="admin-stat-card">
        <span>⭐</span>
        <h2>{{ stats.nombre_avis }}</h2>
        <p>Avis</p>
      </article>

      <article class="admin-stat-card">
        <span>💙</span>
        <h2>{{ stats.nombre_likes }}</h2>
        <p>Favoris</p>
      </article>

      <article class="admin-stat-card">
        <span>💬</span>
        <h2>{{ stats.nombre_messages }}</h2>
        <p>Messages</p>
      </article>

      <article class="admin-stat-card">
        <span>💶</span>
        <h2>{{ stats.nombre_paiements }}</h2>
        <p>Paiements</p>
      </article>
    </div>

    <section v-if="!loading && stats" class="admin-payment-summary">
      <article class="admin-total-card">
        <div>
          <h2>Montant brut payé</h2>
          <p>Total des paiements acceptés par les membres.</p>
        </div>

        <strong>{{ formatAmount(stats.montant_brut_paiements_acceptes) }}</strong>
      </article>

      <article class="admin-total-card">
        <div>
          <h2>Commission ServiceConnect</h2>
          <p>Commission estimée à 10 % sur les paiements acceptés.</p>
        </div>

        <strong>{{ formatAmount(stats.commission_serviceconnect) }}</strong>
      </article>

      <article class="admin-total-card">
        <div>
          <h2>Frais Stripe estimés</h2>
          <p>Estimation basée sur 1,5 % + 0,25 € par paiement Stripe accepté.</p>
        </div>

        <strong>{{ formatAmount(stats.frais_stripe_estimes) }}</strong>
      </article>

      <article class="admin-total-card">
        <div>
          <h2>Net prestataires</h2>
          <p>Montant estimé à reverser aux prestataires après commission et frais Stripe.</p>
        </div>

        <strong>{{ formatAmount(stats.montant_net_prestataires) }}</strong>
      </article>
    </section>

    <section class="admin-actions-grid">
      <RouterLink to="/admin/users" class="admin-action-card">
        <span>👥</span>
        <h2>Utilisateurs</h2>
        <p>Consulter les membres, prestataires et administrateurs.</p>
      </RouterLink>

      <RouterLink to="/admin/annonces" class="admin-action-card">
        <span>📢</span>
        <h2>Annonces</h2>
        <p>Modérer les annonces publiées par les prestataires.</p>
      </RouterLink>

      <RouterLink to="/admin/categories" class="admin-action-card">
        <span>📂</span>
        <h2>Catégories</h2>
        <p>Créer, modifier ou désactiver les catégories de services.</p>
      </RouterLink>

      <RouterLink to="/admin/messages" class="admin-action-card">
        <span>💬</span>
        <h2>Messages</h2>
        <p>Consulter les échanges entre membres et prestataires.</p>
      </RouterLink>

      <RouterLink to="/admin/avis" class="admin-action-card">
        <span>⭐</span>
        <h2>Avis</h2>
        <p>Afficher ou masquer les avis laissés par les membres.</p>
      </RouterLink>

      <RouterLink to="/admin/paiements" class="admin-action-card">
        <span>💶</span>
        <h2>Paiements</h2>
        <p>Suivre les paiements effectués via ServiceConnect.</p>
      </RouterLink>
    </section>
  </section>
</template>
