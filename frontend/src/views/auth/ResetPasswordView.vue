<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const route = useRoute()
const router = useRouter()
const language = useLanguageStore()

const form = ref({
  token: String(route.query.token || ''),
  email: String(route.query.email || ''),
  password: '',
  password_confirmation: '',
})

const loading = ref(false)
const error = ref('')
const success = ref('')
const showPassword = ref(false)
const showPasswordConfirmation = ref(false)

async function submitResetPassword() {
  loading.value = true
  error.value = ''
  success.value = ''

  try {
    await api.post('/auth/reset-password', form.value)

    success.value = language.t('auth.resetPasswordSuccess')

    setTimeout(() => {
      router.push('/login')
    }, 1500)
  } catch (e) {
    error.value =
      e.response?.data?.message ||
      language.t('auth.resetPasswordError')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="auth-page">
    <div class="auth-card">
      <div class="auth-header">
        <h1>{{ language.t('auth.resetPasswordTitle') }}</h1>

        <p>
          {{ language.t('auth.resetPasswordSubtitle') }}
        </p>
      </div>

      <form class="auth-form" @submit.prevent="submitResetPassword">
        <div class="form-group">
          <label>{{ language.t('auth.email') }}</label>

          <input
            v-model="form.email"
            type="email"
            required
          />
        </div>

        <div class="form-group">
          <label>{{ language.t('auth.newPassword') }}</label>

          <div class="password-field">
            <input
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              :placeholder="language.t('auth.newPasswordPlaceholder')"
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

        <div class="form-group">
          <label>{{ language.t('auth.confirmNewPassword') }}</label>

          <div class="password-field">
            <input
              v-model="form.password_confirmation"
              :type="showPasswordConfirmation ? 'text' : 'password'"
              :placeholder="language.t('auth.confirmNewPasswordPlaceholder')"
              required
            />

            <button
              type="button"
              class="password-toggle"
              @click="showPasswordConfirmation = !showPasswordConfirmation"
            >
              {{ showPasswordConfirmation ? '🙈' : '👁️' }}
            </button>
          </div>
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
              ? language.t('auth.resetPasswordLoading')
              : language.t('auth.resetPasswordButton')
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
