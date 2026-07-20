<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const route = useRoute()
const router = useRouter()
const language = useLanguageStore()

const categories = ref([])
const loading = ref(true)
const saving = ref(false)
const error = ref('')
const success = ref('')

const form = ref({
  titre: '',
  description: '',
  categorie_id: '',
  tarif: '',
  localisation: '',
})

onMounted(async () => {
  await Promise.all([
    loadCategories(),
    loadAnnonce(),
  ])
})

async function loadCategories() {
  try {
    const response = await api.get('/categories')
    categories.value = response.data.data || response.data || []
  } catch (e) {
    error.value = language.t('announcementForm.categoriesLoadError')
  }
}

async function loadAnnonce() {
  loading.value = true

  try {
    const response = await api.get(`/prestataire/annonces/${route.params.id}`)
    const annonce = response.data.data || response.data

    form.value = {
      titre: annonce.titre || '',
      description: annonce.description || '',
      categorie_id: annonce.categorie_id || annonce.categorie?.id || '',
      tarif: annonce.tarif || '',
      localisation: annonce.localisation || '',
    }
  } catch (e) {
    error.value = e.response?.data?.message || language.t('announcementForm.loadEditError')
  } finally {
    loading.value = false
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
  return language.t(`home.categoryNames.${key}`)
}

async function submitUpdate() {
  saving.value = true
  error.value = ''
  success.value = ''

  if (!form.value.titre.trim()) {
    error.value = language.t('announcementForm.titleRequired')
    saving.value = false
    return
  }

  if (!form.value.description.trim() || form.value.description.trim().length < 10) {
    error.value = language.t('announcementForm.descriptionError')
    saving.value = false
    return
  }

  if (!form.value.categorie_id) {
    error.value = language.t('announcementForm.categoryRequired')
    saving.value = false
    return
  }

  if (!form.value.tarif || Number(form.value.tarif) < 10) {
    error.value = language.t('announcementForm.priceError')
    saving.value = false
    return
  }

  if (!form.value.localisation.trim()) {
    error.value = language.t('becomeProvider.locationRequired')
    saving.value = false
    return
  }

  try {
    await api.put(`/prestataire/annonces/${route.params.id}`, {
      titre: form.value.titre.trim(),
      description: form.value.description.trim(),
      categorie_id: form.value.categorie_id,
      tarif: Number(form.value.tarif),
      localisation: form.value.localisation.trim(),
    })

    success.value = language.t('announcementForm.updateSuccess')

    setTimeout(() => {
      router.push('/prestataire/annonces')
    }, 700)
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value = e.response?.data?.message || language.t('announcementForm.updateError')
    }
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <section class="prestataire-page">
    <div class="prestataire-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('provider.space') }} › {{ language.t('announcementForm.editBreadcrumb') }}
        </p>

        <h1>{{ language.t('announcementForm.editTitle') }}</h1>

        <p>
          {{ language.t('announcementForm.editSubtitle') }}
        </p>
      </div>

      <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
        {{ language.t('availability.backToAnnouncements') }}
      </RouterLink>
    </div>

    <p v-if="loading">
      {{ language.t('announcementForm.loadingEdit') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <form v-if="!loading" class="prestataire-form-card" @submit.prevent="submitUpdate">
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
            {{ language.t('announcementForm.chooseCategory') }}
          </option>

          <option
            v-for="categorie in categories"
            :key="categorie.id"
            :value="categorie.id"
          >
            {{ getCategoryName(categorie) }}
          </option>
        </select>
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
          :placeholder="language.t('announcementForm.editDescriptionPlaceholder')"
          required
        ></textarea>
      </div>

      <div class="form-actions">
        <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
          {{ language.t('common.cancel') }}
        </RouterLink>

        <button type="submit" class="primary-small-btn" :disabled="saving">
          {{
            saving
              ? language.t('announcementForm.updating')
              : language.t('announcementForm.saveChanges')
          }}
        </button>
      </div>
    </form>
  </section>
</template>
