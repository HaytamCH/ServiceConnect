<script setup>
import { computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { useNotificationStore } from '../stores/notifications'
import LanguageSwitcher from './LanguageSwitcher.vue'
import { useLanguageStore } from '../stores/language'


const router = useRouter()
const auth = useAuthStore()
const notifications = useNotificationStore()
const language = useLanguageStore()

const isConnected = computed(() => auth.isAuthenticated)
const user = computed(() => auth.user)
const notificationTotal = computed(() => notifications.total)

const userPhotoUrl = computed(() => user.value?.photo_profil_url || '')

onMounted(async () => {
  if (isConnected.value) {
    await notifications.loadSummary()
  }
})

watch(isConnected, async (connected) => {
  if (connected) {
    await notifications.loadSummary()
  } else {
    notifications.clear()
  }
})

async function logout() {
  await auth.logout()
  notifications.clear()
  router.push('/')
}
</script>

<template>
  <header class="app-header">
    <RouterLink to="/" class="logo">
      <span class="logo-mark" aria-hidden="true">
        <svg viewBox="0 0 64 64" class="logo-svg">
          <path
            d="M19 20C13 14 5 17 5 25c0 5 4 9 9 14l18 18 18-18c5-5 9-9 9-14 0-8-8-11-14-5L32 33 19 20Z"
            fill="none"
            stroke="currentColor"
            stroke-width="5"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
          <path
            d="M20 38l6-6 6 6 6-6 6 6"
            fill="none"
            stroke="currentColor"
            stroke-width="4"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>
      </span>

      <span>ServiceConnect</span>
    </RouterLink>

    <nav class="nav">
      <RouterLink to="/">
        {{ language.t('nav.home') }}
      </RouterLink>

      <RouterLink to="/annonces">
        {{ language.t('nav.services') }}
      </RouterLink>

      <RouterLink to="/devenir-prestataire">
        {{ language.t('nav.becomeProvider') }}
      </RouterLink>

      <LanguageSwitcher />

      <RouterLink v-if="isConnected" to="/mon-espace" class="login-btn account-link-with-badge">
        <span class="header-user-avatar user-avatar">
          <img v-if="userPhotoUrl" :src="userPhotoUrl" alt="Photo de profil" />
          <span v-else class="default-avatar-icon"></span>
        </span>

        <span>{{ user?.prenom || language.t('nav.account') }}</span>

        <span v-if="notificationTotal > 0" class="notification-badge">
          {{ notificationTotal }}
        </span>
      </RouterLink>

      <button v-if="isConnected" type="button" class="logout-btn" @click="logout">
        {{ language.t('nav.logout') }}
      </button>

      <RouterLink v-else to="/login" class="login-btn">
        👤 {{ language.t('nav.login') }}
      </RouterLink>
    </nav>
  </header>
</template>
