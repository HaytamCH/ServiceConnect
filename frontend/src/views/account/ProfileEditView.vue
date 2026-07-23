<script setup>
import { onMounted, ref } from 'vue'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'

const auth = useAuthStore()

const loading = ref(true)
const saving = ref(false)
const error = ref('')
const success = ref('')
const previewUrl = ref('')

const form = ref({
  nom: '',
  prenom: '',
  email: '',
  telephone: '',
  langue: 'fr',
  localisation: '',
  description_profil: '',
  photo_profil: null,
})

onMounted(async () => {
  try {
    await auth.fetchUser()

    form.value.nom = auth.user?.nom || ''
    form.value.prenom = auth.user?.prenom || ''
    form.value.email = auth.user?.email || ''
    form.value.telephone = auth.user?.telephone || ''
    form.value.langue = auth.user?.langue || 'fr'
    form.value.localisation = auth.user?.localisation || ''
    form.value.description_profil = auth.user?.description_profil || ''

    previewUrl.value = auth.user?.photo_profil_url || ''
  } catch (e) {
    error.value = 'Impossible de charger vos informations.'
  } finally {
    loading.value = false
  }
})

function handlePhotoChange(event) {
  const file = event.target.files?.[0]

  if (!file) {
    form.value.photo_profil = null
    return
  }

  form.value.photo_profil = file
  previewUrl.value = URL.createObjectURL(file)
}

async function submitProfile() {
  error.value = ''
  success.value = ''
  saving.value = true

  try {
    const data = new FormData()

    data.append('nom', form.value.nom)
    data.append('prenom', form.value.prenom)
    data.append('email', form.value.email)
    data.append('telephone', form.value.telephone || '')
    data.append('langue', form.value.langue || 'fr')
    data.append('localisation', form.value.localisation || '')
    data.append('description_profil', form.value.description_profil || '')

    if (form.value.photo_profil) {
      data.append('photo_profil', form.value.photo_profil)
    }

    const response = await api.post('/profile', data)

    const updatedUser = response.data.data || response.data.user || response.data

    auth.setUser(updatedUser)
    success.value = 'Votre profil a été mis à jour avec succès.'
  } catch (e) {
    error.value = e.response?.data?.message || 'Impossible de mettre à jour le profil.'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <section class="account-page">
    <div class="account-card profile-edit-card">
      <div class="profile-edit-header">
        <div>
          <p class="breadcrumb">Mon espace › Modifier mon profil</p>
          <h1>Modifier mon profil</h1>
          <p>Modifiez vos informations personnelles et votre photo de profil.</p>
        </div>

        <RouterLink to="/mon-espace" class="secondary-small-btn">
          Retour
        </RouterLink>
      </div>

      <p v-if="loading">Chargement...</p>

      <p v-if="error" class="error-message">
        {{ error }}
      </p>

      <p v-if="success" class="success-message">
        {{ success }}
      </p>

      <form v-if="!loading" class="profile-edit-form" @submit.prevent="submitProfile">
        <div class="profile-photo-zone">
          <div class="profile-photo-preview user-avatar">
            <img v-if="previewUrl" :src="previewUrl" alt="Photo de profil" />
            <span v-else class="default-avatar-icon"></span>
          </div>

          <div>
            <label for="photo_profil">Photo de profil</label>
            <input
              id="photo_profil"
              type="file"
              accept="image/jpeg,image/png,image/webp"
              @change="handlePhotoChange"
            />
            <small>Formats acceptés : JPG, PNG, WEBP. Taille maximale : 2 Mo.</small>
          </div>
        </div>

        <div class="profile-form-grid">
          <div class="form-group">
            <label>Nom</label>
            <input v-model="form.nom" type="text" required />
          </div>

          <div class="form-group">
            <label>Prénom</label>
            <input v-model="form.prenom" type="text" required />
          </div>

          <div class="form-group">
            <label>Email</label>
            <input v-model="form.email" type="email" required />
          </div>

          <div class="form-group">
            <label>Téléphone</label>
            <input v-model="form.telephone" type="text" />
          </div>

          <div class="form-group">
            <label>Langue</label>
            <select v-model="form.langue">
              <option value="fr">Français</option>
              <option value="en">Anglais</option>
              <option value="nl">Néerlandais</option>
            </select>
          </div>

          <div class="form-group">
            <label>Localisation</label>
            <input v-model="form.localisation" type="text" />
          </div>
        </div>

        <div class="form-group">
          <label>Description du profil</label>
          <textarea
            v-model="form.description_profil"
            rows="5"
            placeholder="Présentez brièvement votre profil ou vos services..."
          ></textarea>
        </div>

        <div class="form-actions left">
          <button type="submit" class="primary-small-btn" :disabled="saving">
            {{ saving ? 'Enregistrement...' : 'Enregistrer les modifications' }}
          </button>

          <RouterLink to="/mon-espace" class="secondary-small-btn">
            Annuler
          </RouterLink>
        </div>
      </form>
    </div>
  </section>
</template>
