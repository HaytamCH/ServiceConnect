<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'

const router = useRouter()
const route = useRoute()
const auth = useAuthStore()
const language = useLanguageStore()

const form = ref({
  email: '',
  password: '',
})

const loading = ref(false)
const error = ref('')
const showPassword = ref(false)

const disabledMessage = localStorage.getItem('account_disabled_message')

if (disabledMessage) {
  error.value = disabledMessage
  localStorage.removeItem('account_disabled_message')
} else if (route.query.account_disabled) {
  error.value =
    'Votre compte a été désactivé. Veuillez contacter le service client ou l’administrateur pour plus d’informations.'
}

async function submitLogin() {
  loading.value = true
  error.value = ''

  try {
    await auth.login(form.value)

    const redirect = route.query.redirect || '/'
    router.push(redirect)
  } catch (e) {
    error.value = e.response?.data?.message || language.t('auth.loginError')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="auth-page">
    <div class="auth-card">
      <div class="auth-header">
        <h1>{{ language.t('auth.loginTitle') }}</h1>
        <p>{{ language.t('auth.loginSubtitle') }}</p>
      </div>

      <form class="auth-form" @submit.prevent="submitLogin">
        <div class="form-group">
          <label>{{ language.t('auth.email') }}</label>

          <input
            v-model="form.email"
            type="email"
            placeholder="membre1@serviceconnect.test"
            required
          />
        </div>

        <div class="form-group">
          <label>{{ language.t('auth.password') }}</label>

          <div class="password-field">
            <input
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              :placeholder="language.t('auth.passwordPlaceholder')"
              required
            />

            <button
              type="button"
              class="password-toggle"
              @click="showPassword = !showPassword"
            >
              {{ showPassword ? '🙈' : '👁️' }}
            </button>
          </div>
        </div>

        <p v-if="error" class="error-message">
          {{ error }}
        </p>

        <button class="auth-submit" type="submit" :disabled="loading">
          {{
            loading
              ? language.t('auth.loginLoading')
              : language.t('auth.loginButton')
          }}
        </button>
      </form>

      <div class="auth-links">
        <RouterLink to="/forgot-password">
          {{ language.t('auth.forgotPassword') }}
        </RouterLink>

        <RouterLink to="/register">
          {{ language.t('auth.createAccount') }}
        </RouterLink>
      </div>
    </div>
  </section>
</template>
