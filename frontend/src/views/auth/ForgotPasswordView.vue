<script setup>
import { ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const language = useLanguageStore()

const email = ref('')
const loading = ref(false)
const error = ref('')
const success = ref('')

async function submitForgotPassword() {
  loading.value = true
  error.value = ''
  success.value = ''

  try {
    await api.post('/auth/forgot-password', {
      email: email.value,
    })

    success.value = language.t('auth.forgotPasswordSuccess')
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      language.t('auth.forgotPasswordError')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="auth-page">
    <div class="auth-card">
      <div class="auth-header">
        <h1>{{ language.t('auth.forgotPasswordTitle') }}</h1>

        <p>
          {{ language.t('auth.forgotPasswordSubtitle') }}
        </p>
      </div>

      <form class="auth-form" @submit.prevent="submitForgotPassword">
        <div class="form-group">
          <label>{{ language.t('auth.email') }}</label>

          <input
            v-model="email"
            type="email"
            :placeholder="language.t('auth.emailPlaceholder')"
            required
          />
        </div>

        <p v-if="error" class="error-message">
          {{ error }}
        </p>

        <p v-if="success" class="success-message">
          {{ success }}
        </p>

        <button class="auth-submit" type="submit" :disabled="loading">
          {{
            loading
              ? language.t('auth.forgotPasswordLoading')
              : language.t('auth.forgotPasswordButton')
          }}
        </button>
      </form>

      <div class="auth-links">
        <RouterLink to="/login">
          {{ language.t('auth.backToLogin') }}
        </RouterLink>
      </div>
    </div>
  </section>
</template>
