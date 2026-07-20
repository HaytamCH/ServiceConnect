<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const router = useRouter()
const language = useLanguageStore()

const categories = ref([])
const loading = ref(false)
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

onMounted(async () => {
  await loadCategories()
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

async function submitAnnonce() {
  loading.value = true
  error.value = ''
  success.value = ''

  try {
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
      titre: form.value.titre,
      description: form.value.description,
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
          :placeholder="language.t('announcementForm.descriptionPlaceholder')"
          required
        ></textarea>
      </div>

      <div class="form-actions">
        <RouterLink to="/prestataire/annonces" class="secondary-small-btn">
          {{ language.t('common.cancel') }}
        </RouterLink>

        <button type="submit" class="primary-small-btn" :disabled="loading">
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
