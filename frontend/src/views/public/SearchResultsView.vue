<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'
import { annonceUrl, prestataireUrl } from '../../utils/slug'

const route = useRoute()
const router = useRouter()
const language = useLanguageStore()

const annonces = ref([])
const categories = ref([])
const loading = ref(true)
const error = ref(null)

const filters = ref({
  search: '',
  categorie_id: '',
  localisation: '',
  tarif_min: '',
  tarif_max: '',
})

function syncFiltersFromUrl() {
  filters.value = {
    search: String(route.query.search || ''),
    categorie_id: String(route.query.categorie_id || route.query.categorie || ''),
    localisation: String(route.query.localisation || ''),
    tarif_min: String(route.query.tarif_min || ''),
    tarif_max: String(route.query.tarif_max || ''),
  }
}

function buildQueryFromFilters() {
  const query = {}

  if (filters.value.search.trim()) {
    query.search = filters.value.search.trim()
  }

  if (filters.value.categorie_id) {
    query.categorie_id = filters.value.categorie_id
  }

  if (filters.value.localisation.trim()) {
    query.localisation = filters.value.localisation.trim()
  }

  if (filters.value.tarif_min) {
    query.tarif_min = filters.value.tarif_min
  }

  if (filters.value.tarif_max) {
    query.tarif_max = filters.value.tarif_max
  }

  return query
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
  if (!categorie) {
    return ''
  }

  const key = getCategoryKey(categorie.nom)

  if (key === 'default') {
    return categorie.nom
  }

  return language.t(`home.categoryNames.${key}`)
}

function servicesFoundLabel(count) {
  return language.t('search.servicesFound').replace('{count}', count)
}

async function loadCategories() {
  const response = await api.get('/categories')
  categories.value = response.data.data || response.data || []
}

async function loadAnnonces() {
  loading.value = true
  error.value = null

  try {
    const params = {}

    if (filters.value.search.trim()) {
      params.search = filters.value.search.trim()
    }

    if (filters.value.categorie_id) {
      params.categorie_id = filters.value.categorie_id
    }

    if (filters.value.localisation.trim()) {
      params.localisation = filters.value.localisation.trim()
    }

    if (filters.value.tarif_min) {
      params.tarif_min = filters.value.tarif_min
    }

    if (filters.value.tarif_max) {
      params.tarif_max = filters.value.tarif_max
    }

    const response = await api.get('/annonces', { params })
    annonces.value = response.data.data || response.data || []
  } catch (e) {
    error.value = language.t('search.loadError')
  } finally {
    loading.value = false
  }
}

async function applyFilters() {
  await router.push({
    path: '/annonces',
    query: buildQueryFromFilters(),
  })

  await loadAnnonces()
}

async function resetFilters() {
  filters.value = {
    search: '',
    categorie_id: '',
    localisation: '',
    tarif_min: '',
    tarif_max: '',
  }

  await router.push('/annonces')
  await loadAnnonces()
}

onMounted(async () => {
  try {
    await loadCategories()
    syncFiltersFromUrl()
    await loadAnnonces()
  } catch (e) {
    error.value = language.t('search.dataLoadError')
    loading.value = false
  }
})
</script>

<template>
  <section class="results-page">
    <div class="results-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('nav.home') }} › {{ language.t('nav.services') }}
        </p>

        <p>
          {{ language.t('search.subtitle') }}
        </p>
      </div>
    </div>

    <div class="results-layout">
      <aside class="filters-card">
        <div class="filters-title">
          <h2>{{ language.t('search.filters') }}</h2>

          <button type="button" @click="resetFilters">
            {{ language.t('search.reset') }}
          </button>
        </div>

        <div class="filter-group">
          <label>Recherche</label>

          <input
            v-model="filters.search"
            type="search"
            placeholder="Ex : bricolage, baby-sitting, coiffeur..."
          />
        </div>

        <div class="filter-group">
          <label>{{ language.t('search.category') }}</label>

          <select v-model="filters.categorie_id">
            <option value="">
              {{ language.t('search.allCategories') }}
            </option>

            <option
              v-for="categorie in categories"
              :key="categorie.id"
              :value="String(categorie.id)"
            >
              {{ getCategoryName(categorie) }}
            </option>
          </select>
        </div>

        <div class="filter-group">
          <label>{{ language.t('search.location') }}</label>

          <input
            v-model="filters.localisation"
            type="text"
            placeholder="Ex : Bruxelles, Liège, Gent..."
          />
        </div>

        <div class="filter-row">
          <div class="filter-group">
            <label>{{ language.t('search.minPrice') }}</label>
            <input v-model="filters.tarif_min" type="number" placeholder="10" />
          </div>

          <div class="filter-group">
            <label>{{ language.t('search.maxPrice') }}</label>
            <input v-model="filters.tarif_max" type="number" placeholder="50" />
          </div>
        </div>

        <button class="filter-submit" type="button" @click="applyFilters">
          {{ language.t('search.showResults') }}
        </button>
      </aside>

      <main class="results-content">
        <div class="results-toolbar">
          <strong>{{ servicesFoundLabel(annonces.length) }}</strong>
          <span>🛡️ {{ language.t('home.verifiedProviders') }}</span>
          <span>🔒 {{ language.t('home.securePayment') }}</span>
        </div>

        <p v-if="loading">
          {{ language.t('search.loadingAnnouncements') }}
        </p>

        <p v-if="error" class="error-message">
          {{ error }}
        </p>

        <div v-if="!loading && annonces.length" class="annonce-list">
          <article
            v-for="annonce in annonces"
            :key="annonce.id"
            class="annonce-card"
          >
            <div class="provider-avatar">
              {{ annonce.prestataire?.prenom?.charAt(0) || 'P' }}
            </div>

            <div class="annonce-info">
              <h2>{{ annonce.titre }}</h2>

              <p>
                {{ annonce.prestataire?.prenom }} {{ annonce.prestataire?.nom }}
                —
                {{ annonce.localisation || annonce.prestataire?.localisation }}
              </p>

              <div class="annonce-meta">
                <span>
                  ⭐ {{ annonce.note_moyenne || language.t('search.newProvider') }}
                </span>

                <span>
                  ✅ {{ language.t('search.available') }}
                </span>

                <span v-if="annonce.categorie">
                  {{ getCategoryName(annonce.categorie) }}
                </span>
              </div>
            </div>

            <div class="annonce-actions">
              <strong>{{ annonce.tarif || 25 }} €/h</strong>

              <RouterLink :to="annonceUrl(annonce)" class="primary-small-btn">
                {{ language.t('search.consult') }}
              </RouterLink>

              <RouterLink
                v-if="annonce.prestataire"
                :to="prestataireUrl(annonce.prestataire)"
                class="secondary-small-btn"
              >
                {{ language.t('search.viewProfile') }}
              </RouterLink>
            </div>
          </article>
        </div>

        <div v-if="!loading && annonces.length === 0" class="empty-results">
          <h2>{{ language.t('search.noServiceTitle') }}</h2>
          <p>{{ language.t('search.noServiceText') }}</p>
        </div>
      </main>
    </div>
  </section>
</template>
