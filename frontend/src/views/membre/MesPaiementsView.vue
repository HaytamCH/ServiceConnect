<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl } from '../../utils/slug'
import { useNotificationStore } from '../../stores/notifications'

const language = useLanguageStore()
const notifications = useNotificationStore()

const paiements = ref([])
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  await loadPaiements()
  await markPaymentNotificationsAsRead()
})

async function loadPaiements() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/mes-paiements')
    paiements.value = response.data.data || response.data || []
  } catch (e) {
    error.value = language.t('payments.loadError')
  } finally {
    loading.value = false
  }
}

async function markPaymentNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=paiement_accepte')
    await api.patch('/notifications/mark-as-read?type=paiement_refuse')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications de paiement comme lues.')
  }
}

function formatAmount(paiement) {
  const montant = Number(paiement.montant || 0)

  const locale =
    language.current === 'en'
      ? 'en-BE'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: paiement.devise || 'EUR',
  }).format(montant)
}

function formatDate(date) {
  if (!date) {
    return language.t('payments.dateUndefined')
  }

  const locale =
    language.current === 'en'
      ? 'en-GB'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Date(date).toLocaleString(locale)
}

function statutLabel(statut) {
  const labels = {
    en_attente: language.t('payments.statusPending'),
    accepte: language.t('payments.statusAccepted'),
    refuse: language.t('payments.statusRefused'),
    rembourse: language.t('payments.statusRefunded'),
  }

  return labels[statut] || statut
}

function methodeLabel(methode) {
  const labels = {
    stripe: 'Stripe',
    paypal: 'PayPal',
    virement_bancaire: language.t('payments.methodBankTransfer'),
  }

  return labels[methode] || methode
}
</script>

<template>
  <section class="member-page">
    <div class="member-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('account.title') }} › {{ language.t('payments.title') }}
        </p>

        <h1>{{ language.t('payments.title') }}</h1>

        <p>
          {{ language.t('payments.subtitle') }}
        </p>
      </div>

      <RouterLink to="/annonces" class="primary-small-btn">
        {{ language.t('reservations.bookService') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('payments.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <div v-if="!loading && paiements.length" class="payment-list">
      <article
        v-for="paiement in paiements"
        :key="paiement.id"
        class="payment-card"
      >
        <div class="payment-main">
          <span class="payment-method">
            {{ methodeLabel(paiement.methode) }}
          </span>

          <h2>
            {{ paiement.reservation?.annonce?.titre || language.t('payments.defaultTitle') }}
          </h2>

          <p>
            {{ language.t('payments.reservationNumber') }} {{ paiement.reservation_id }}
          </p>

          <p>
            {{ language.t('payments.date') }} :
            <strong>{{ formatDate(paiement.created_at) }}</strong>
          </p>

          <p v-if="paiement.transaction_externe_id">
            {{ language.t('payments.reference') }} :
            <strong>{{ paiement.transaction_externe_id }}</strong>
          </p>
        </div>

        <div class="payment-side">
          <strong class="payment-amount">
            {{ formatAmount(paiement) }}
          </strong>

          <span class="status-badge" :class="paiement.statut">
            {{ statutLabel(paiement.statut) }}
          </span>

          <RouterLink
            v-if="paiement.reservation?.annonce"
            :to="annonceUrl(paiement.reservation.annonce)"
            class="secondary-small-btn"
          >
            {{ language.t('reservations.viewAnnouncement') }}
          </RouterLink>
        </div>
      </article>
    </div>

    <div v-if="!loading && paiements.length === 0" class="empty-results">
      <h2>{{ language.t('payments.emptyTitle') }}</h2>
      <p>{{ language.t('payments.emptyText') }}</p>
    </div>
  </section>
</template>
