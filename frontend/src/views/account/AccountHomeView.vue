<script setup>
import { computed } from 'vue'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'

const auth = useAuthStore()
const language = useLanguageStore()

const user = computed(() => auth.user)

const isMembre = computed(() => auth.isMembre)
const isPrestataire = computed(() => auth.isPrestataire)
const isAdmin = computed(() => auth.isAdmin)

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

      <div class="account-actions">
        <RouterLink to="/annonces" class="primary-small-btn">
          {{ language.t('account.viewServices') }}
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

          <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
            {{ language.t('account.myAnnouncements') }}
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
