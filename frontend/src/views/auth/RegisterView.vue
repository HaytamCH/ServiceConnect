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
  nom: '',
  prenom: '',
  email: '',
  telephone: '',
  localisation: '',
  role: route.query.role === 'prestataire' ? 'prestataire' : 'membre',
  password: '',
  password_confirmation: '',
})

const loading = ref(false)
const error = ref('')

async function submitRegister() {
  loading.value = true
  error.value = ''

  try {
    await auth.register(form.value)
    router.push('/')
  } catch (e) {
    error.value = e.response?.data?.message || language.t('auth.registerError')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="auth-page">
    <div class="auth-card large">
      <div class="auth-header">
        <h1>{{ language.t('auth.registerTitle') }}</h1>
        <p>{{ language.t('auth.registerSubtitle') }}</p>
      </div>

      <form class="auth-form" @submit.prevent="submitRegister">
        <div class="form-row">
          <div class="form-group">
            <label>{{ language.t('auth.lastName') }}</label>
            <input v-model="form.nom" type="text" required />
          </div>

          <div class="form-group">
            <label>{{ language.t('auth.firstName') }}</label>
            <input v-model="form.prenom" type="text" required />
          </div>
        </div>

        <div class="form-group">
          <label>{{ language.t('auth.email') }}</label>
          <input v-model="form.email" type="email" required />
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>{{ language.t('auth.phone') }}</label>
            <input v-model="form.telephone" type="text" />
          </div>

          <div class="form-group">
            <label>{{ language.t('becomeProvider.locationLabel') }}</label>
            <input v-model="form.localisation" type="text" placeholder="Bruxelles" />
          </div>
        </div>

        <div class="form-group">
          <label>{{ language.t('auth.accountType') }}</label>

          <select v-model="form.role">
            <option value="membre">
              {{ language.t('auth.memberAccount') }}
            </option>

            <option value="prestataire">
              {{ language.t('auth.providerAccount') }}
            </option>
          </select>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>{{ language.t('auth.password') }}</label>
            <input v-model="form.password" type="password" required />
          </div>

          <div class="form-group">
            <label>{{ language.t('auth.passwordConfirmation') }}</label>
            <input v-model="form.password_confirmation" type="password" required />
          </div>
        </div>

        <p v-if="error" class="error-message">
          {{ error }}
        </p>

        <button class="auth-submit" type="submit" :disabled="loading">
          {{
            loading
              ? language.t('auth.registerLoading')
              : language.t('auth.registerButton')
          }}
        </button>
      </form>

      <div class="auth-links">
        <RouterLink to="/login">
          {{ language.t('auth.alreadyAccount') }}
        </RouterLink>
      </div>
    </div>
  </section>
</template>
