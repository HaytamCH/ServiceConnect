<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'

const router = useRouter()
const auth = useAuthStore()
const language = useLanguageStore()

const loading = ref(false)
const error = ref('')
const success = ref('')

const isConnected = computed(() => auth.isAuthenticated)
const isMembre = computed(() => auth.user?.role === 'membre')
const isPrestataire = computed(() => auth.user?.role === 'prestataire')

const notifications = useNotificationStore()

const form = ref({
  description_profil: '',
  localisation: auth.user?.localisation || '',
  telephone: auth.user?.telephone || '',
})

const demandeStatut = computed(() => auth.user?.demande_prestataire_statut || 'aucune')
const hasPendingRequest = computed(() => demandeStatut.value === 'en_attente')
const hasRejectedRequest = computed(() => demandeStatut.value === 'refusee')


async function contactAdmin() {
  error.value = ''

  try {
    const response = await api.get('/support/admin-contact')
    const admin = response.data.data

    router.push({
      path: '/mes-messages',
      query: {
        destinataire_id: admin.id,
        destinataire_nom: `${admin.prenom} ${admin.nom}`,
      },
    })
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de contacter l’administrateur.'
  }
}


onMounted(async () => {
  if (auth.isAuthenticated) {
    await auth.fetchUser()
  }

  if (auth.user?.demande_prestataire_statut === 'refusee') {
    try {
      await api.patch('/notifications/mark-as-read?type=demande_prestataire_refusee')
      await notifications.loadSummary()
    } catch (e) {
      console.warn('Notification de refus non marquée comme lue.')
    }
  }
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

  if (!form.value.telephone.trim()) {
    error.value = 'Le numéro de téléphone est obligatoire pour devenir prestataire.'
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

    success.value = 'Votre demande a été envoyée. Elle doit être validée par un administrateur.'
    await auth.fetchUser()

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

        <div v-else-if="hasPendingRequest" class="become-provider-panel">
          <h2>Demande en attente</h2>

          <p>
            Votre demande pour devenir prestataire a bien été envoyée.
            Elle doit maintenant être validée par un administrateur.
          </p>

          <RouterLink to="/mon-espace" class="secondary-small-btn">
            Retour à mon espace
          </RouterLink>
        </div>

        <form
          v-else-if="isMembre && !hasPendingRequest"
          class="become-provider-panel"
          @submit.prevent="submitDevenirPrestataire"
        >
          <h2>{{ language.t('becomeProvider.activateTitle') }}</h2>

          <p>
            {{ language.t('becomeProvider.activateText') }}
          </p>

          <div v-if="hasRejectedRequest" class="provider-request-refused">
            <h3>Demande refusée</h3>

            <p>
              Votre demande pour devenir prestataire a été refusée par l’administrateur.
              Si vous souhaitez obtenir plus d’informations ou compléter votre demande,
              vous pouvez contacter l’administrateur.
            </p>

            <button type="button" class="secondary-small-btn" @click="contactAdmin">
              Contacter l’administrateur
            </button>
          </div>

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
                required
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
