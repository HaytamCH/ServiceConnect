<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'

const router = useRouter()
const language = useLanguageStore()
const notifications = useNotificationStore()

const OTHER_CATEGORY_VALUE = '__other__'

const categories = ref([])
const loading = ref(false)
const requestLoading = ref(false)
const loadingCategories = ref(true)
const error = ref('')
const success = ref('')

const form = ref({
  titre: '',
  description: '',
  categorie_id: '',
  tarif: '',
  localisation: '',
})

const demandeCategorie = ref({
  nom: '',
  description: '',
})

const isOtherCategory = computed(() => {
  return form.value.categorie_id === OTHER_CATEGORY_VALUE
})

onMounted(async () => {
  await loadCategories()
  await markCategoryRequestNotificationsAsRead()
})

async function loadCategories() {
  loadingCategories.value = true
  error.value = ''

  try {
    const response = await api.get('/categories')
    categories.value = response.data.data || response.data || []
  } catch (e) {
    error.value = language.t('announcementForm.categoriesLoadError')
  } finally {
    loadingCategories.value = false
  }
}

async function markCategoryRequestNotificationsAsRead() {
  try {
    await api.patch('/notifications/mark-as-read?type=demande_categorie_acceptee')
    await api.patch('/notifications/mark-as-read?type=demande_categorie_refusee')
    await notifications.loadSummary()
  } catch (e) {
    console.warn('Impossible de marquer les notifications de catégorie comme lues.')
  }
}

function getCategoryKey(nom) {
  const name = (nom || '').toLowerCase()

  if (name.includes('bricolage')) return 'bricolage'
  if (name.includes('nettoyage')) return 'nettoyage'
  if (name.includes('jardinage')) return 'jardinage'
  if (name.includes('baby') || name.includes('garde')) return 'babySitting'
  if (name.includes('informatique')) return 'informatique'
  if (name.includes('plomberie')) return 'plomberie'
  if (name.includes('électricité') || name.includes('electricite')) return 'electricite'
  if (name.includes('aide')) return 'aide'

  return 'default'
}

function getCategoryName(categorie) {
  const key = getCategoryKey(categorie.nom)

  if (key === 'default') {
    return categorie.nom
  }

  return language.t(`home.categoryNames.${key}`)
}

async function submitCategoryRequest() {
  error.value = ''
  success.value = ''

  if (!demandeCategorie.value.nom.trim()) {
    error.value = 'Le nom de la nouvelle catégorie est obligatoire.'
    return
  }

  requestLoading.value = true

  try {
    await api.post('/prestataire/demandes-categories', {
      nom: demandeCategorie.value.nom.trim(),
      description: demandeCategorie.value.description.trim() || null,
    })

    success.value =
      'Votre demande de catégorie a été envoyée à l’administrateur. Après validation, vous pourrez l’utiliser pour publier une annonce.'

    demandeCategorie.value = {
      nom: '',
      description: '',
    }

    form.value.categorie_id = ''
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value =
        e.response?.data?.message ||
        'Impossible d’envoyer cette demande de catégorie.'
    }
  } finally {
    requestLoading.value = false
  }
}

async function submitAnnonce() {
  loading.value = true
  error.value = ''
  success.value = ''

  if (isOtherCategory.value) {
    error.value =
      'Vous devez d’abord envoyer la demande de nouvelle catégorie à l’administrateur.'
    loading.value = false
    return
  }

  try {
    if (!form.value.categorie_id) {
      error.value = 'Veuillez choisir une catégorie.'
      loading.value = false
      return
    }

    if (!form.value.tarif || Number(form.value.tarif) < 10) {
      error.value = language.t('announcementForm.priceError')
      loading.value = false
      return
    }

    if (!form.value.localisation.trim()) {
      error.value = language.t('becomeProvider.locationRequired')
      loading.value = false
      return
    }

    await api.post('/prestataire/annonces', {
      titre: form.value.titre.trim(),
      description: form.value.description.trim(),
      categorie_id: form.value.categorie_id,
      tarif: Number(form.value.tarif),
      localisation: form.value.localisation.trim(),
    })

    success.value = language.t('announcementForm.createSuccess')

    setTimeout(() => {
      router.push('/prestataire/annonces')
    }, 700)
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value = e.response?.data?.message || language.t('announcementForm.createError')
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('announcementForm.newBreadcrumb') }}
        </p>

        <h1>{{ language.t('provider.newAnnouncement') }}</h1>

        <p>
          {{ language.t('announcementForm.createSubtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
        {{ language.t('availability.backToAnnouncements') }}
      </RouterLink>
    </div>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <form class="prestataire-form-card" @submit.prevent="submitAnnonce">
      <div class="form-group">
        <label>{{ language.t('announcementForm.titleLabel') }}</label>

        <input
          v-model="form.titre"
          type="text"
          :placeholder="language.t('announcementForm.titlePlaceholder')"
          required
        />
      </div>

      <div class="form-group">
        <label>{{ language.t('search.category') }}</label>

        <select v-model="form.categorie_id" required>
          <option value="" disabled>
            {{
              loadingCategories
                ? language.t('common.loading')
                : language.t('announcementForm.chooseCategory')
            }}
          </option>

          <option
            v-for="categorie in categories"
            :key="categorie.id"
            :value="categorie.id"
          >
            {{ getCategoryName(categorie) }}
          </option>

          <option :value="OTHER_CATEGORY_VALUE">
            Autre catégorie
          </option>
        </select>
      </div>

      <div v-if="isOtherCategory" class="category-request-box">
        <h2>Proposer une nouvelle catégorie</h2>

        <p>
          La catégorie proposée sera envoyée à l’administrateur. Après validation,
          elle sera ajoutée à la liste des catégories disponibles.
        </p>

        <div class="form-group">
          <label>Nom de la catégorie proposée</label>

          <input
            v-model="demandeCategorie.nom"
            type="text"
            placeholder="Ex : Coiffure, Déménagement, Photographie..."
          />
        </div>

        <div class="form-group">
          <label>Description de la catégorie</label>

          <textarea
            v-model="demandeCategorie.description"
            rows="4"
            placeholder="Expliquez brièvement à quoi correspond cette catégorie."
          ></textarea>
        </div>

        <button
          type="button"
          class="primary-small-btn"
          :disabled="requestLoading"
          @click="submitCategoryRequest"
        >
          {{
            requestLoading
              ? 'Envoi de la demande...'
              : 'Envoyer la demande à l’administrateur'
          }}
        </button>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>{{ language.t('announcementForm.priceLabel') }}</label>

          <input
            v-model="form.tarif"
            type="number"
            min="10"
            step="0.01"
            placeholder="25"
            required
          />
        </div>

        <div class="form-group">
          <label>{{ language.t('becomeProvider.locationLabel') }}</label>

          <input
            v-model="form.localisation"
            type="text"
            placeholder="Bruxelles"
            required
          />
        </div>
      </div>

      <div class="form-group">
        <label>{{ language.t('announcementForm.descriptionLabel') }}</label>

        <textarea
          v-model="form.description"
          rows="7"
          :placeholder="language.t('announcementForm.descriptionPlaceholder')"
          required
        ></textarea>
      </div>

      <div class="form-actions">
        <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
          {{ language.t('common.cancel') }}
        </RouterLink>

        <button type="submit" class="primary-small-btn" :disabled="loading || isOtherCategory">
          {{
            loading
              ? language.t('announcementForm.creating')
              : language.t('announcementForm.publish')
          }}
        </button>
      </div>
    </form>
  </section>
</template>
