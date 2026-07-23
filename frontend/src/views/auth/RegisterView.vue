<script setup>
import { computed, ref } from 'vue'
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
  description_profil: '',
  password: '',
  password_confirmation: '',
})

const loading = ref(false)
const error = ref('')

const passwordRules = computed(() => {
  return {
    minLength: form.value.password.length >= 8,
    uppercase: /[A-Z]/.test(form.value.password),
    number: /[0-9]/.test(form.value.password),
    special: /[^A-Za-z0-9]/.test(form.value.password),
  }
})

const isPasswordValid = computed(() => {
  return (
    passwordRules.value.minLength &&
    passwordRules.value.uppercase &&
    passwordRules.value.number &&
    passwordRules.value.special
  )
})

const passwordsMatch = computed(() => {
  if (!form.value.password_confirmation) {
    return true
  }

  return form.value.password === form.value.password_confirmation
})

function firstBackendError(e) {
  const errors = e.response?.data?.errors

  if (errors) {
    const firstKey = Object.keys(errors)[0]

    if (firstKey && errors[firstKey]?.length) {
      return errors[firstKey][0]
    }
  }

  return e.response?.data?.message || language.t('auth.registerError')
}

async function submitRegister() {
  loading.value = true
  error.value = ''

  if (form.value.role === 'prestataire') {
    if (!form.value.description_profil.trim()) {
      error.value = 'La description du profil est obligatoire pour une demande prestataire.'
      loading.value = false
      return
    }

    if (form.value.description_profil.trim().length < 20) {
      error.value = 'La description du profil doit contenir au moins 20 caractères.'
      loading.value = false
      return
    }

    if (!form.value.localisation.trim()) {
      error.value = 'La localisation est obligatoire pour une demande prestataire.'
      loading.value = false
      return
    }

    if (!form.value.telephone.trim()) {
      error.value = 'Le numéro de téléphone est obligatoire pour une demande prestataire.'
      loading.value = false
      return
    }
  }

  if (!isPasswordValid.value) {
    error.value = 'Le mot de passe ne respecte pas encore toutes les conditions.'
    loading.value = false
    return
  }

  if (form.value.password !== form.value.password_confirmation) {
    error.value = 'Les deux mots de passe ne correspondent pas.'
    loading.value = false
    return
  }

  try {
    await auth.register(form.value)

    if (form.value.role === 'prestataire') {
      router.push('/devenir-prestataire')
    } else {
      router.push('/')
    }
  } catch (e) {
    error.value = firstBackendError(e)
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

          <small v-if="form.role === 'prestataire'" class="form-help-text">
            Votre compte sera créé immédiatement, mais l’accès prestataire devra être validé par un administrateur.
          </small>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>
              {{ language.t('auth.phone') }}
              <span v-if="form.role === 'prestataire'">*</span>
            </label>

            <input
              v-model="form.telephone"
              type="text"
              :required="form.role === 'prestataire'"
              placeholder="+32 470 00 00 00"
            />
          </div>

          <div class="form-group">
            <label>
              {{ language.t('becomeProvider.locationLabel') }}
              <span v-if="form.role === 'prestataire'">*</span>
            </label>

            <input
              v-model="form.localisation"
              type="text"
              placeholder="Bruxelles"
              :required="form.role === 'prestataire'"
            />
          </div>
        </div>

        <div v-if="form.role === 'prestataire'" class="form-group">
          <label>Description de votre profil prestataire *</label>

          <textarea
            v-model="form.description_profil"
            rows="5"
            placeholder="Ex : Prestataire spécialisé dans les petits travaux à domicile, disponible à Bruxelles et alentours."
            required
          ></textarea>

          <small class="form-help-text">
            Minimum 20 caractères. Cette description sera vérifiée par l’administrateur.
          </small>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>{{ language.t('auth.password') }}</label>
            <input v-model="form.password" type="password" required />

            <ul class="password-rules">
              <li :class="{ valid: passwordRules.minLength, invalid: !passwordRules.minLength }">
                <span>{{ passwordRules.minLength ? '✓' : '✕' }}</span>
                Minimum 8 caractères
              </li>

              <li :class="{ valid: passwordRules.uppercase, invalid: !passwordRules.uppercase }">
                <span>{{ passwordRules.uppercase ? '✓' : '✕' }}</span>
                Au moins une majuscule
              </li>

              <li :class="{ valid: passwordRules.number, invalid: !passwordRules.number }">
                <span>{{ passwordRules.number ? '✓' : '✕' }}</span>
                Au moins un chiffre
              </li>

              <li :class="{ valid: passwordRules.special, invalid: !passwordRules.special }">
                <span>{{ passwordRules.special ? '✓' : '✕' }}</span>
                Au moins un caractère spécial
              </li>
            </ul>
          </div>

          <div class="form-group">
            <label>{{ language.t('auth.passwordConfirmation') }}</label>
            <input v-model="form.password_confirmation" type="password" required />

            <p
              v-if="form.password_confirmation"
              class="password-match-message"
              :class="{ valid: passwordsMatch, invalid: !passwordsMatch }"
            >
              {{
                passwordsMatch
                  ? '✓ Les mots de passe correspondent.'
                  : '✕ Les mots de passe ne correspondent pas.'
              }}
            </p>
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
