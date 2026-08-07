<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useLanguageStore } from '../../stores/language'

const language = useLanguageStore()

const categories = ref([])
const loading = ref(true)
const error = ref('')

function getCategoryVisual(nom) {
  const name = (nom || '').toLowerCase()

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
  <section class="public-page">
    <div class="public-page-header">
      <p class="breadcrumb">ServiceConnect › {{ language.t('categories.breadcrumb') }}</p>

      <div class="public-page-title-row">
        <div>
          <h1>{{ language.t('categories.title') }}</h1>
          <p>{{ language.t('categories.subtitle') }}</p>
        </div>

        <RouterLink to="/" class="secondary-small-btn">
          {{ language.t('categories.backHome') }}
        </RouterLink>
      </div>
    </div>

    <p v-if="loading" class="info-message">
      {{ language.t('home.loadingCategories') }}
    </p>

    <p v-if="error" class="warning-message">
      {{ error }}
    </p>

    <div v-if="!loading && categories.length" class="category-grid all-categories-grid">
      <RouterLink
        v-for="categorie in categories"
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

    <div v-if="!loading && categories.length === 0" class="empty-results">
      <h2>{{ language.t('categories.emptyTitle') }}</h2>
      <p>{{ language.t('categories.emptyText') }}</p>
    </div>
  </section>
</template>
