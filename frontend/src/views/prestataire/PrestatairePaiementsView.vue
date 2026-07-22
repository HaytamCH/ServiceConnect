<script setup>
import { computed, onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl } from '../../utils/slug'
import { useNotificationStore } from '../../stores/notifications'

const language = useLanguageStore()
const notifications = useNotificationStore()

const SERVICE_COMMISSION_RATE = 0.10
const STRIPE_RATE = 0.015
const STRIPE_FIXED_FEE = 0.25

const paiements = ref([])
const loading = ref(true)
const error = ref('')

const paiementsAcceptes = computed(() => {
  return paiements.value.filter((paiement) => paiement.statut === 'accepte')
})

const totalBrutRecu = computed(() => {
  return paiementsAcceptes.value.reduce((total, paiement) => {
    return total + Number(paiement.montant || 0)
  }, 0)
})

const totalCommissionServiceConnect = computed(() => {
  return paiementsAcceptes.value.reduce((total, paiement) => {
    return total + calculateServiceCommission(paiement)
  }, 0)
})

const totalFraisStripe = computed(() => {
  return paiementsAcceptes.value.reduce((total, paiement) => {
    return total + calculateStripeFee(paiement)
  }, 0)
})

const totalNetPrestataire = computed(() => {
  return totalBrutRecu.value - totalCommissionServiceConnect.value - totalFraisStripe.value
})

function calculateServiceCommission(paiement) {
  return Number(paiement.montant || 0) * SERVICE_COMMISSION_RATE
}

function calculateStripeFee(paiement) {
  if (paiement.methode !== 'stripe' || paiement.statut !== 'accepte') {
    return 0
  }

  return Number(paiement.montant || 0) * STRIPE_RATE + STRIPE_FIXED_FEE
}

function formatCurrency(value) {
  const locale =
    language.current === 'en'
      ? 'en-BE'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: 'EUR',
  }).format(Number(value || 0))
}

onMounted(async () => {
  await loadPaiements()
  await markProviderPaymentNotificationsAsRead()
})

async function loadPaiements() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/prestataire/paiements')
    const payload = response.data.data || response.data

    if (Array.isArray(payload)) {
      paiements.value = payload
    } else if (Array.isArray(payload.data)) {
      paiements.value = payload.data
    } else {
      paiements.value = []
    }
  } catch (e) {
    error.value = language.t('providerPayments.loadError')
  } finally {
    loading.value = false
  }
}

async function markProviderPaymentNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=paiement_recu')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications de paiement reçu comme lues.')
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

function getClientName(paiement) {
  const membre = paiement.membre || paiement.reservation?.membre

  if (!membre) {
    return language.t('providerPayments.client')
  }

  return `${membre.prenom || ''} ${membre.nom || ''}`.trim()
}

function getAnnonceTitle(paiement) {
  return paiement.reservation?.annonce?.titre || language.t('providerPayments.defaultTitle')
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('provider.receivedPayments') }}
        </p>

        <h1>{{ language.t('provider.receivedPayments') }}</h1>

        <p>
          {{ language.t('providerPayments.subtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/dashboard" class="secondary-small-btn">
        {{ language.t('common.backToDashboard') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('providerPayments.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <section v-if="!loading && paiements.length" class="payment-summary-grid">
      <article class="payment-summary-card">
        <span>💶</span>
        <div>
          <h2>{{ formatCurrency(totalBrutRecu) }}</h2>
          <p>Total brut reçu</p>
        </div>
      </article>

      <article class="payment-summary-card">
        <span>🏦</span>
        <div>
          <h2>{{ formatCurrency(totalCommissionServiceConnect) }}</h2>
          <p>Commission ServiceConnect estimée</p>
        </div>
      </article>

      <article class="payment-summary-card">
        <span>💳</span>
        <div>
          <h2>{{ formatCurrency(totalFraisStripe) }}</h2>
          <p>Frais Stripe estimés</p>
        </div>
      </article>

      <article class="payment-summary-card">
        <span>✅</span>
        <div>
          <h2>{{ formatCurrency(totalNetPrestataire) }}</h2>
          <p>Net estimé à reverser</p>
        </div>
      </article>
    </section>

    <div v-if="!loading && paiements.length" class="prestataire-payment-list">
      <article
        v-for="paiement in paiements"
        :key="paiement.id"
        class="prestataire-payment-card"
      >
        <div class="payment-icon">
          💶
        </div>

        <div class="payment-content">
          <div class="payment-top">
            <span class="payment-method">
              {{ methodeLabel(paiement.methode) }}
            </span>

            <span class="muted-text">
              {{ formatDate(paiement.created_at) }}
            </span>
          </div>

          <h2>{{ getAnnonceTitle(paiement) }}</h2>

          <p>
            {{ language.t('providerPayments.client') }} :
            <strong>{{ getClientName(paiement) }}</strong>
          </p>

          <p>
            {{ language.t('payments.reservationNumber') }} {{ paiement.reservation_id }}
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
            :to="{
    path: annonceUrl(paiement.reservation.annonce),
    query: { retour: 'prestataire' }
  }"
            class="secondary-small-btn"
          >
            {{ language.t('reservations.viewAnnouncement') }}
          </RouterLink>

        </div>
      </article>
    </div>

    <div v-if="!loading && paiements.length === 0" class="empty-results">
      <h2>{{ language.t('providerPayments.emptyTitle') }}</h2>
      <p>{{ language.t('providerPayments.emptyText') }}</p>
    </div>
  </section>
</template>
