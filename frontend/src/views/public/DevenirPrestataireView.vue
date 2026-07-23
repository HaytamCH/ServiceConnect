<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'

const router = useRouter()
const auth = useAuthStore()
const language = useLanguageStore()

const loading = ref(false)
const error = ref('')
const success = ref('')

const isConnected = computed(() => auth.isAuthenticated)
const isMembre = computed(() => auth.user?.role === 'membre')
const isPrestataire = computed(() => auth.user?.role === 'prestataire')

const form = ref({
  description_profil: '',
  localisation: auth.user?.localisation || '',
  telephone: auth.user?.telephone || '',
})

async function submitDevenirPrestataire() {
  loading.value = true
  error.value = ''
  success.value = ''

  if (!form.value.description_profil.trim()) {
    error.value = language.t('becomeProvider.descriptionRequired')
    loading.value = false
    return
  }

  if (!form.value.localisation.trim()) {
    error.value = language.t('becomeProvider.locationRequired')
    loading.value = false
    return
  }

  try {
    const response = await api.patch('/devenir-prestataire', {
      description_profil: form.value.description_profil.trim(),
      localisation: form.value.localisation.trim(),
      telephone: form.value.telephone?.trim() || null,
    })

    const user = response.data.data || response.data.user

    auth.user = user
    localStorage.setItem('user', JSON.stringify(user))

    success.value = language.t('becomeProvider.successActivated')

    setTimeout(() => {
      router.push('/prestataire/dashboard')
    }, 700)
  } catch (e) {
    error.value = e.response?.data?.message || language.t('becomeProvider.errorActivate')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="become-provider-page">
    <div class="become-provider-layout">
      <main class="become-provider-main">
        <div class="become-provider-intro">
          <p class="breadcrumb">
            ServiceConnect › {{ language.t('nav.becomeProvider') }}
          </p>

          <h1>{{ language.t('becomeProvider.title') }}</h1>

          <p>
            {{ language.t('becomeProvider.subtitle') }}
          </p>
        </div>

        <div v-if="!isConnected" class="become-provider-panel">
          <h2>{{ language.t('becomeProvider.createAccountTitle') }}</h2>

          <p>
            {{ language.t('becomeProvider.createAccountText') }}
          </p>

          <div class="form-actions left">
            <RouterLink to="/register?role=prestataire" class="primary-small-btn">
              {{ language.t('becomeProvider.createProviderAccount') }}
            </RouterLink>

            <RouterLink to="/login?redirect=/devenir-prestataire" class="secondary-small-btn">
              {{ language.t('nav.login') }}
            </RouterLink>
          </div>
        </div>

        <div v-else-if="isPrestataire" class="become-provider-panel">
          <h2>{{ language.t('becomeProvider.alreadyProviderTitle') }}</h2>

          <p>
            {{ language.t('becomeProvider.alreadyProviderText') }}
          </p>

          <RouterLink to="/prestataire/dashboard" class="primary-small-btn">
            {{ language.t('becomeProvider.goDashboard') }}
          </RouterLink>
        </div>

        <form
          v-else-if="isMembre"
          class="become-provider-panel"
          @submit.prevent="submitDevenirPrestataire"
        >
          <h2>{{ language.t('becomeProvider.activateTitle') }}</h2>

          <p>
            {{ language.t('becomeProvider.activateText') }}
          </p>

          <p v-if="error" class="error-message">
            {{ error }}
          </p>

          <p v-if="success" class="success-message">
            {{ success }}
          </p>

          <div class="form-group">
            <label>{{ language.t('becomeProvider.descriptionLabel') }}</label>

            <textarea
              v-model="form.description_profil"
              rows="6"
              :placeholder="language.t('becomeProvider.descriptionPlaceholder')"
              required
            ></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>{{ language.t('becomeProvider.locationLabel') }}</label>

              <input
                v-model="form.localisation"
                type="text"
                placeholder="Bruxelles"
                required
              />
            </div>

            <div class="form-group">
              <label>{{ language.t('becomeProvider.phoneLabel') }}</label>

              <input
                v-model="form.telephone"
                type="text"
                placeholder="+32 470 00 00 00"
              />
            </div>
          </div>

          <div class="form-actions left">
            <button type="submit" class="primary-small-btn" :disabled="loading">
              {{
                loading
                  ? language.t('becomeProvider.activationLoading')
                  : language.t('nav.becomeProvider')
              }}
            </button>
          </div>
        </form>
      </main>

      <aside class="become-provider-card">
        <h2>{{ language.t('becomeProvider.whyTitle') }}</h2>

        <ul>
          <li>📢 {{ language.t('becomeProvider.reasonPublish') }}</li>
          <li>🗓️ {{ language.t('becomeProvider.reasonAvailability') }}</li>
          <li>📩 {{ language.t('becomeProvider.reasonReservations') }}</li>
          <li>💶 {{ language.t('becomeProvider.reasonPayments') }}</li>
          <li>⭐ {{ language.t('becomeProvider.reasonReviews') }}</li>
        </ul>
      </aside>
    </div>
  </section>
</template>
