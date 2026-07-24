<script setup>
import { computed, onMounted } from 'vue'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'

const auth = useAuthStore()
const language = useLanguageStore()
const notifications = useNotificationStore()

const user = computed(() => auth.user)

const isMembre = computed(() => auth.isMembre)
const isPrestataire = computed(() => auth.isPrestataire)
const isAdmin = computed(() => auth.isAdmin)

const visibleNotificationsCount = computed(() => {
  if (isAdmin.value) {
    return (
      notifications.adminAnnoncesEnAttente +
      notifications.adminAvisAModerer +
      notifications.adminMessagesASurveiller +
      notifications.adminDemandesPrestataires
    )
  }

  return (
    notifications.messagesNonLus +
    notifications.reservationsPrestataireEnAttente +
    notifications.reservationsAcceptees +
    notifications.reservationsRefusees +
    notifications.reservationsAlternatives +
    notifications.annoncesValidees +
    notifications.avisRecus +
    notifications.demandePrestataireAcceptee +
    notifications.demandePrestataireRefusee
  )
})

const hasNotifications = computed(() => visibleNotificationsCount.value > 0)

onMounted(async () => {
  await notifications.loadSummary()
})

function getRoleLabel(role) {
  if (role === 'membre') {
    return language.t('account.roleMembre')
  }

  if (role === 'prestataire') {
    return language.t('account.roleMemberProvider')
  }

  if (role === 'administrateur') {
    return language.t('account.roleAdmin')
  }

  return role || ''
}
</script>

<template>
  <section class="account-page">
    <div class="account-card">
      <h1>{{ language.t('account.title') }}</h1>

      <p>
        {{ language.t('account.welcome') }},
        <strong>{{ user?.prenom }} {{ user?.nom }}</strong>
      </p>

      <p class="muted-text">
        {{ language.t('account.role') }} :
        <strong>{{ getRoleLabel(user?.role) }}</strong>
      </p>

      <div class="account-notifications">
        <h2>Notifications</h2>

        <p v-if="notifications.loading" class="muted-text">
          Chargement des notifications...
        </p>

        <div v-else-if="hasNotifications" class="notification-list">
          <RouterLink
            v-if="notifications.messagesNonLus > 0"
            to="/mes-messages"
            class="notification-item"
          >
            <span>💬</span>
            <strong>{{ notifications.messagesNonLus }}</strong>
            <p>message(s) non lu(s)</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.reservationsPrestataireEnAttente > 0"
            to="/prestataire/reservations"
            class="notification-item"
          >
            <span>📩</span>
            <strong>{{ notifications.reservationsPrestataireEnAttente }}</strong>
            <p>demande(s) de réservation en attente</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.annoncesValidees > 0"
            to="/prestataire/annonces"
            class="notification-item"
          >
            <span>📢</span>
            <strong>{{ notifications.annoncesValidees }}</strong>
            <p>annonce(s) validée(s) et publiée(s)</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.reservationsAcceptees > 0"
            to="/mes-reservations"
            class="notification-item"
          >
            <span>✅</span>
            <strong>{{ notifications.reservationsAcceptees }}</strong>
            <p>réservation(s) acceptée(s)</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.reservationsRefusees > 0"
            to="/mes-reservations"
            class="notification-item"
          >
            <span>❌</span>
            <strong>{{ notifications.reservationsRefusees }}</strong>
            <p>réservation(s) refusée(s)</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.reservationsAlternatives > 0"
            to="/mes-reservations"
            class="notification-item"
          >
            <span>🔁</span>
            <strong>{{ notifications.reservationsAlternatives }}</strong>
            <p>alternative(s) proposée(s)</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.avisRecus > 0"
            to="/prestataire/avis"
            class="notification-item"
          >
            <span>⭐</span>
            <strong>{{ notifications.avisRecus }}</strong>
            <p>nouvel avis reçu</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.demandePrestataireAcceptee > 0"
            to="/prestataire/dashboard"
            class="notification-item"
          >
            <span>✅</span>
            <strong>{{ notifications.demandePrestataireAcceptee }}</strong>
            <p>demande prestataire acceptée</p>
          </RouterLink>

          <RouterLink
            v-if="notifications.demandePrestataireRefusee > 0"
            to="/devenir-prestataire"
            class="notification-item"
          >
            <span>❌</span>
            <strong>{{ notifications.demandePrestataireRefusee }}</strong>
            <p>demande prestataire refusée</p>
          </RouterLink>

          <template v-if="isAdmin">
            <RouterLink
              v-if="notifications.adminDemandesPrestataires > 0"
              to="/admin/users"
              class="notification-item"
            >
              <span>🧾</span>
              <strong>{{ notifications.adminDemandesPrestataires }}</strong>
              <p>demande(s) prestataire à traiter</p>
            </RouterLink>

            <RouterLink
              v-if="notifications.adminAnnoncesEnAttente > 0"
              to="/admin/annonces"
              class="notification-item"
            >
              <span>📢</span>
              <strong>{{ notifications.adminAnnoncesEnAttente }}</strong>
              <p>annonce(s) en attente de validation</p>
            </RouterLink>

            <RouterLink
              v-if="notifications.adminAvisAModerer > 0"
              to="/admin/avis"
              class="notification-item"
            >
              <span>⭐</span>
              <strong>{{ notifications.adminAvisAModerer }}</strong>
              <p>avis récent(s) à surveiller</p>
            </RouterLink>

            <RouterLink
              v-if="notifications.adminMessagesASurveiller > 0"
              to="/admin/messages"
              class="notification-item"
            >
              <span>💬</span>
              <strong>{{ notifications.adminMessagesASurveiller }}</strong>
              <p>message(s) échangé(s) à surveiller</p>
            </RouterLink>
          </template>
        </div>

        <p v-else class="muted-text">
          Aucune nouvelle notification.
        </p>
      </div>

      <div class="account-actions">
        <RouterLink to="/annonces" class="primary-small-btn">
          {{ language.t('account.viewServices') }}
        </RouterLink>

        <RouterLink to="/mon-profil" class="secondary-small-btn">
          Modifier mon profil
        </RouterLink>

        <template v-if="isMembre">
          <RouterLink to="/mes-reservations" class="secondary-small-btn">
            {{ language.t('account.myReservations') }}
          </RouterLink>

          <RouterLink to="/mes-favoris" class="secondary-small-btn">
            {{ language.t('account.myFavorites') }}
          </RouterLink>

          <RouterLink to="/mes-messages" class="secondary-small-btn">
            {{ language.t('account.myMessages') }}
          </RouterLink>

          <RouterLink to="/mes-paiements" class="secondary-small-btn">
            {{ language.t('account.myPayments') }}
          </RouterLink>
        </template>

        <template v-if="isPrestataire">
          <RouterLink to="/prestataire/dashboard" class="secondary-small-btn">
            {{ language.t('account.providerSpace') }}
          </RouterLink>

        </template>

        <template v-if="isAdmin">
          <RouterLink to="/admin/dashboard" class="secondary-small-btn">
            {{ language.t('account.administration') }}
          </RouterLink>
        </template>
      </div>
    </div>
  </section>
</template>
