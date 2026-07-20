<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'

const categories = ref([])
const loading = ref(true)
const saving = ref(false)
const editingId = ref(null)
const deletingId = ref(null)
const error = ref('')
const success = ref('')

const form = ref({
  nom: '',
  description: '',
  active: true,
})

const editForm = ref({
  nom: '',
  description: '',
  active: true,
})

onMounted(async () => {
  await loadCategories()
})

async function loadCategories() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/admin/categories')
    categories.value = response.data.data || response.data || []
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de charger les catégories.'
  } finally {
    loading.value = false
  }
}

async function createCategory() {
  saving.value = true
  error.value = ''
  success.value = ''

  if (!form.value.nom.trim()) {
    error.value = 'Le nom de la catégorie est obligatoire.'
    saving.value = false
    return
  }

  try {
    await api.post('/admin/categories', {
      nom: form.value.nom.trim(),
      description: form.value.description.trim() || null,
      active: form.value.active,
    })

    success.value = 'Catégorie créée avec succès.'

    form.value = {
      nom: '',
      description: '',
      active: true,
    }

    await loadCategories()
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value = e.response?.data?.message || 'Impossible de créer cette catégorie.'
    }
  } finally {
    saving.value = false
  }
}

function startEdit(categorie) {
  editingId.value = categorie.id

  editForm.value = {
    nom: categorie.nom || '',
    description: categorie.description || '',
    active: Boolean(categorie.active),
  }

  error.value = ''
  success.value = ''
}

function cancelEdit() {
  editingId.value = null

  editForm.value = {
    nom: '',
    description: '',
    active: true,
  }
}

async function updateCategory(categorie) {
  saving.value = true
  error.value = ''
  success.value = ''

  if (!editForm.value.nom.trim()) {
    error.value = 'Le nom de la catégorie est obligatoire.'
    saving.value = false
    return
  }

  try {
    const response = await api.put(`/admin/categories/${categorie.id}`, {
      nom: editForm.value.nom.trim(),
      description: editForm.value.description.trim() || null,
      active: editForm.value.active,
    })

    const updatedCategory = response.data.data

    categorie.nom = updatedCategory.nom
    categorie.description = updatedCategory.description
    categorie.active = updatedCategory.active

    success.value = 'Catégorie modifiée avec succès.'
    cancelEdit()
  } catch (e) {
    if (e.response?.data?.errors) {
      const firstError = Object.values(e.response.data.errors)[0][0]
      error.value = firstError
    } else {
      error.value = e.response?.data?.message || 'Impossible de modifier cette catégorie.'
    }
  } finally {
    saving.value = false
  }
}

async function deleteCategory(categorie) {
  const confirmation = confirm(
    `Voulez-vous vraiment supprimer ou désactiver la catégorie "${categorie.nom}" ?`,
  )

  if (!confirmation) {
    return
  }

  deletingId.value = categorie.id
  error.value = ''
  success.value = ''

  try {
    const response = await api.delete(`/admin/categories/${categorie.id}`)

    success.value = response.data.message || 'Catégorie supprimée avec succès.'

    await loadCategories()
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de supprimer cette catégorie.'
  } finally {
    deletingId.value = null
  }
}

function statusLabel(active) {
  return active ? 'Active' : 'Désactivée'
}
</script>

<template>
  <section class="admin-page">
    <div class="admin-header">
      <div>
        <p class="breadcrumb">Administration › Catégories</p>
        <h1>Gestion des catégories</h1>
        <p>Organisez les types de services proposés sur ServiceConnect.</p>
      </div>

      <RouterLink to="/admin/dashboard" class="secondary-small-btn">
        Retour dashboard
      </RouterLink>
    </div>

    <p v-if="loading">Chargement des catégories...</p>
    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>

    <div v-if="!loading" class="admin-two-columns">
      <form class="admin-panel" @submit.prevent="createCategory">
        <div class="admin-panel-header">
          <div>
            <h2>Nouvelle catégorie</h2>
            <p>Ajoutez une catégorie de service.</p>
          </div>
        </div>

        <div class="form-group">
          <label>Nom</label>
          <input
            v-model="form.nom"
            type="text"
            placeholder="Ex : Transport"
            required
          />
        </div>

        <div class="form-group">
          <label>Description</label>
          <textarea
            v-model="form.description"
            rows="5"
            placeholder="Décrivez brièvement cette catégorie."
          ></textarea>
        </div>

        <label class="admin-checkbox">
          <input v-model="form.active" type="checkbox" />
          Catégorie active
        </label>

        <div class="form-actions left">
          <button type="submit" class="primary-small-btn" :disabled="saving">
            {{ saving ? 'Création...' : 'Créer la catégorie' }}
          </button>
        </div>
      </form>

      <section class="admin-panel">
        <div class="admin-panel-header">
          <div>
            <h2>Liste des catégories</h2>
            <p>{{ categories.length }} catégorie(s) affichée(s)</p>
          </div>
        </div>

        <div v-if="categories.length" class="admin-category-list">
          <article
            v-for="categorie in categories"
            :key="categorie.id"
            class="admin-category-card"
          >
            <template v-if="editingId === categorie.id">
              <div class="form-group">
                <label>Nom</label>
                <input v-model="editForm.nom" type="text" required />
              </div>

              <div class="form-group">
                <label>Description</label>
                <textarea v-model="editForm.description" rows="4"></textarea>
              </div>

              <label class="admin-checkbox">
                <input v-model="editForm.active" type="checkbox" />
                Catégorie active
              </label>

              <div class="admin-category-actions">
                <button
                  type="button"
                  class="primary-small-btn"
                  :disabled="saving"
                  @click="updateCategory(categorie)"
                >
                  Enregistrer
                </button>

                <button
                  type="button"
                  class="secondary-small-btn"
                  @click="cancelEdit"
                >
                  Annuler
                </button>
              </div>
            </template>

            <template v-else>
              <div class="admin-category-main">
                <div>
                  <h3>{{ categorie.nom }}</h3>
                  <p>{{ categorie.description || 'Aucune description.' }}</p>

                  <small>
                    {{ categorie.annonces_count || 0 }} annonce(s) liée(s)
                  </small>
                </div>

                <span
                  class="admin-badge status"
                  :class="categorie.active ? 'actif' : 'desactive'"
                >
                  {{ statusLabel(categorie.active) }}
                </span>
              </div>

              <div class="admin-category-actions">
                <button
                  type="button"
                  class="secondary-small-btn"
                  @click="startEdit(categorie)"
                >
                  Modifier
                </button>

                <button
                  type="button"
                  class="danger-small-btn"
                  :disabled="deletingId === categorie.id"
                  @click="deleteCategory(categorie)"
                >
                  {{ deletingId === categorie.id ? 'Suppression...' : 'Supprimer' }}
                </button>
              </div>
            </template>
          </article>
        </div>

        <div v-else class="empty-results">
          <h2>Aucune catégorie</h2>
          <p>Aucune catégorie n’est disponible pour le moment.</p>
        </div>
      </section>
    </div>
  </section>
</template>
