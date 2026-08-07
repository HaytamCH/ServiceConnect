<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import heroImage from '../../assets/images/serviceconnect-hero.webp'
import { useLanguageStore } from '../../stores/language'

const language = useLanguageStore()

const categories = ref([])
const loading = ref(true)
const error = ref(null)

const router = useRouter()

const searchForm = ref({
  search: '',
  localisation: '',
})

function getCategoryVisual(nom) {
  const name = nom.toLowerCase()

  if (name.includes('bricolage')) {
    return {
      icon: '🔧',
      color: 'blue',
      descriptionKey: 'bricolage',
    }
  }

  if (name.includes('nettoyage')) {
    return {
      icon: '🧹',
      color: 'green',
      descriptionKey: 'nettoyage',
    }
  }

  if (name.includes('jardinage')) {
    return {
      icon: '🌿',
      color: 'green',
      descriptionKey: 'jardinage',
    }
  }

  if (name.includes('baby') || name.includes('garde')) {
    return {
      icon: '👶',
      color: 'orange',
      descriptionKey: 'babySitting',
    }
  }

  if (name.includes('informatique')) {
    return {
      icon: '💻',
      color: 'purple',
      descriptionKey: 'informatique',
    }
  }

  if (name.includes('plomberie')) {
    return {
      icon: '🚰',
      color: 'blue',
      descriptionKey: 'plomberie',
    }
  }

  if (name.includes('électricité') || name.includes('electricite')) {
    return {
      icon: '💡',
      color: 'orange',
      descriptionKey: 'electricite',
    }
  }

  if (name.includes('aide')) {
    return {
      icon: '🏠',
      color: 'blue',
      descriptionKey: 'aide',
    }
  }

  if (
    name.includes('coiffeur') ||
    name.includes('coiffure') ||
    name.includes('cheveux') ||
    name.includes('barbier')
  ) {
    return {
      icon: '💇',
      color: 'purple',
      descriptionKey: 'default',
    }
  }

  if (name.includes('transport') || name.includes('déménagement')) {
    return {
      icon: '🚚',
      color: 'orange',
      descriptionKey: 'default',
    }
  }

  if (name.includes('cours') || name.includes('math') || name.includes('soutien') || name.includes('prof')) {
    return {
      icon: '📚',
      color: 'blue',
      descriptionKey: 'mathematique',
    }
  }

  if (name.includes('danse')) {
    return {
      icon: '💃',
      color: 'purple',
      descriptionKey: 'danse',
    }
  }

  if (name.includes('animaux') || name.includes('chien') || name.includes('chat')) {
    return {
      icon: '🐾',
      color: 'green',
      descriptionKey: 'default',
    }
  }

  return {
    icon: '🛠️',
    color: 'blue',
    descriptionKey: 'default',
  }
}

function submitHomeSearch() {
  const query = {}

  if (searchForm.value.search.trim()) {
    query.search = searchForm.value.search.trim()
  }

  if (searchForm.value.localisation.trim()) {
    query.localisation = searchForm.value.localisation.trim()
  }

  router.push({
    path: '/annonces',
    query,
  })
}

function getCategoryDescription(categorie) {
  if (!categorie) {
    return ''
  }

  if (categorie.descriptionKey === 'default') {
    return categorie.description || language.t('home.categoryDescriptions.default')
  }

  return language.t(`home.categoryDescriptions.${categorie.descriptionKey}`)
}

function getCategoryName(categorie) {
  if (!categorie) {
    return ''
  }

  if (categorie.descriptionKey === 'default') {
    return categorie.nom
  }

  return language.t(`home.categoryNames.${categorie.descriptionKey}`)
}

onMounted(async () => {
  try {
    const response = await api.get('/categories')
    const data = response.data.data || response.data || []

    categories.value = data.map((categorie) => {
      const visual = getCategoryVisual(categorie.nom)

      return {
        ...categorie,
        icon: visual.icon,
        color: visual.color,
        descriptionKey: visual.descriptionKey,
      }
    })
  } catch {
    error.value = language.t('home.categoriesLoadError')
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <section class="hero">
    <div class="hero-left">
      <h1>{{ language.t('home.title') }}</h1>
      <p>{{ language.t('home.subtitle') }}</p>

      <form class="search-panel"  @submit.prevent="submitHomeSearch">
        <div class="search-field">
          <label>{{ language.t('home.searchQuestion') }}</label>
          <div class="input-line">
            <span>🔍</span>
            <input
              v-model="searchForm.search"
              type="text"
              :placeholder="language.t('home.searchPlaceholder')"
            />
          </div>
        </div>

        <div class="search-field">
          <label>{{ language.t('home.locationQuestion') }}</label>
          <div class="input-line">
            <span>📍</span>
            <input
              v-model="searchForm.localisation"
              type="text"
              :placeholder="language.t('home.locationPlaceholder')"
            />
          </div>
        </div>

        <button type="submit" class="search-btn">
          {{ language.t('common.search') }}
        </button>

        <div class="trust-row">
          <span>🛡️ {{ language.t('home.verifiedProviders') }}</span>
          <span>✅ {{ language.t('home.authenticReviews') }}</span>
          <span>🔒 {{ language.t('home.securePayment') }}</span>
        </div>
      </form>
    </div>

    <div class="hero-right">
      <img class="hero-image" :src="heroImage" alt="ServiceConnect" />
    </div>
  </section>

  <section class="categories-section">
    <h2>{{ language.t('home.popularCategories') }}</h2>

    <p v-if="loading" class="info-message">
      {{ language.t('home.loadingCategories') }}
    </p>

    <p v-if="error" class="warning-message">
      {{ error }}
    </p>

    <div v-if="!loading" class="category-grid">
      <RouterLink
        v-for="categorie in categories.slice(0, 5)"
        :key="categorie.id"
        :to="{
          path: '/annonces',
          query: {
      categorie_id: categorie.id
    }
  }"
        class="category-card category-card-link"
      >
        <div class="category-icon" :class="categorie.color">
          {{ categorie.icon }}
        </div>

        <div class="category-text">
          <h3>{{ getCategoryName(categorie) }}</h3>
          <p>{{ getCategoryDescription(categorie) }}</p>
        </div>

        <span class="category-arrow">›</span>
      </RouterLink>
    </div>

    <div class="center-action">
      <RouterLink to="/categories" class="secondary-btn">
        {{ language.t('home.viewAllCategories') }} ›
      </RouterLink>
    </div>
  </section>

  <section class="why-section">
    <h2>{{ language.t('home.whyTitle') }}</h2>

    <div class="why-grid">
      <div class="why-card">
        <div class="why-icon blue-light">🛡️</div>
        <div>
          <h3>{{ language.t('home.trustTitle') }}</h3>
          <p>{{ language.t('home.trustText') }}</p>
        </div>
      </div>

      <div class="why-card">
        <div class="why-icon green-light">🕒</div>
        <div>
          <h3>{{ language.t('home.bookingTitle') }}</h3>
          <p>{{ language.t('home.bookingText') }}</p>
        </div>
      </div>

      <div class="why-card">
        <div class="why-icon orange-light">📍</div>
        <div>
          <h3>{{ language.t('home.localTitle') }}</h3>
          <p>{{ language.t('home.localText') }}</p>
        </div>
      </div>
    </div>

    <div class="stats-row">
      <div>
        <strong>12 500+</strong>
        <span>{{ language.t('home.statsProviders') }}</span>
      </div>

      <div>
        <strong>45 000+</strong>
        <span>{{ language.t('home.statsReviews') }}</span>
      </div>

      <div>
        <strong>85 000+</strong>
        <span>{{ language.t('home.statsReservations') }}</span>
      </div>

      <div>
        <strong>98%</strong>
        <span>{{ language.t('home.statsSatisfied') }}</span>
      </div>
    </div>
  </section>
</template>
