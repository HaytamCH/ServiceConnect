<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'

const auth = useAuthStore()
const language = useLanguageStore()
const router = useRouter()

const loading = ref(true)
const saving = ref(false)
const error = ref('')
const success = ref('')
const previewUrl = ref('')
const photoInput = ref(null)
const removePhotoRequested = ref(false)
let selectedPhotoUrl = ''
const showDeleteForm = ref(false)
const deletePassword = ref('')
const deleteConfirmed = ref(false)
const deleting = ref(false)
const deleteError = ref('')

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
  } catch {
    error.value = language.t('profile.loadError')
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

  if (selectedPhotoUrl) {
    URL.revokeObjectURL(selectedPhotoUrl)
  }

  form.value.photo_profil = file
  removePhotoRequested.value = false
  selectedPhotoUrl = URL.createObjectURL(file)
  previewUrl.value = selectedPhotoUrl
}

function removeProfilePhoto() {
  if (selectedPhotoUrl) {
    URL.revokeObjectURL(selectedPhotoUrl)
    selectedPhotoUrl = ''
  }

  form.value.photo_profil = null
  previewUrl.value = ''
  removePhotoRequested.value = true

  if (photoInput.value) {
    photoInput.value.value = ''
  }
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

    if (removePhotoRequested.value) {
      data.append('remove_photo', '1')
    }

    const response = await api.post('/profile', data)

    const updatedUser = response.data.data || response.data.user || response.data

    auth.setUser(updatedUser)

    if (selectedPhotoUrl) {
      URL.revokeObjectURL(selectedPhotoUrl)
      selectedPhotoUrl = ''
    }

    form.value.photo_profil = null
    removePhotoRequested.value = false
    previewUrl.value = updatedUser.photo_profil_url || ''

    if (photoInput.value) {
      photoInput.value.value = ''
    }

    success.value = language.t('profile.updateSuccess')
  } catch (e) {
    error.value = e.response?.data?.message || language.t('profile.updateError')
  } finally {
    saving.value = false
  }
}

async function deleteAccount() {
  deleteError.value = ''

  if (!deleteConfirmed.value) {
    deleteError.value = language.t('profile.confirmationRequired')
    return
  }

  const confirmed = window.confirm(language.t('profile.confirmDialog'))

  if (!confirmed) {
    return
  }

  deleting.value = true

  try {
    await api.delete('/profile', {
      data: {
        password: deletePassword.value,
        confirmation: deleteConfirmed.value,
      },
    })

    auth.clearSession()

    await router.replace({
      name: 'login',
      query: { account_deleted: '1' },
    })
  } catch (e) {
    deleteError.value = e.response?.data?.message || language.t('profile.unsubscribeError')
  } finally {
    deleting.value = false
  }
}
</script>

<template>
  <section class="account-page">
    <div class="account-card profile-edit-card">
      <div class="profile-edit-header">
        <div>
          <p class="breadcrumb">{{ language.t('profile.breadcrumb') }}</p>
          <h1>{{ language.t('profile.title') }}</h1>
          <p>{{ language.t('profile.subtitle') }}</p>
        </div>

        <RouterLink to="/mon-espace" class="secondary-small-btn">
          {{ language.t('profile.back') }}
        </RouterLink>
      </div>

      <p v-if="loading">{{ language.t('profile.loading') }}</p>

      <p v-if="error" class="error-message">
        {{ error }}
      </p>

      <p v-if="success" class="success-message">
        {{ success }}
      </p>

      <form v-if="!loading" class="profile-edit-form" @submit.prevent="submitProfile">
        <div class="profile-photo-zone">
          <div class="profile-photo-preview user-avatar">
            <img v-if="previewUrl" :src="previewUrl" :alt="language.t('profile.photoAlt')" />
            <span v-else class="default-avatar-icon"></span>
          </div>

          <div>
            <label for="photo_profil">{{ language.t('profile.photo') }}</label>
            <input
              id="photo_profil"
              ref="photoInput"
              type="file"
              accept="image/jpeg,image/png,image/webp"
              @change="handlePhotoChange"
            />
            <div class="profile-photo-actions">
              <small>{{ language.t('profile.photoHelp') }}</small>

              <button
                v-if="previewUrl || form.photo_profil"
                type="button"
                class="secondary-small-btn profile-photo-remove"
                @click="removeProfilePhoto"
              >
                {{ language.t('profile.removePhoto') }}
              </button>
            </div>

            <small v-if="removePhotoRequested" class="profile-photo-removal-note">
              {{ language.t('profile.photoRemovalPending') }}
            </small>
          </div>
        </div>

        <div class="profile-form-grid">
          <div class="form-group">
            <label>{{ language.t('profile.lastName') }}</label>
            <input v-model="form.nom" type="text" required />
          </div>

          <div class="form-group">
            <label>{{ language.t('profile.firstName') }}</label>
            <input v-model="form.prenom" type="text" required />
          </div>

          <div class="form-group">
            <label>{{ language.t('profile.email') }}</label>
            <input v-model="form.email" type="email" required />
          </div>

          <div class="form-group">
            <label>{{ language.t('profile.phone') }}</label>
            <input v-model="form.telephone" type="text" />
          </div>

          <div class="form-group">
            <label>{{ language.t('profile.language') }}</label>
            <select v-model="form.langue">
              <option value="fr">{{ language.t('profile.french') }}</option>
              <option value="en">{{ language.t('profile.english') }}</option>
              <option value="nl">{{ language.t('profile.dutch') }}</option>
            </select>
          </div>

          <div class="form-group">
            <label>{{ language.t('profile.location') }}</label>
            <input v-model="form.localisation" type="text" />
          </div>
        </div>

        <div class="form-group">
          <label>{{ language.t('profile.description') }}</label>
          <textarea
            v-model="form.description_profil"
            rows="5"
            :placeholder="language.t('profile.descriptionPlaceholder')"
          ></textarea>
        </div>

        <div class="form-actions left">
          <button type="submit" class="primary-small-btn" :disabled="saving">
            {{ saving ? language.t('profile.saving') : language.t('profile.save') }}
          </button>

          <RouterLink to="/mon-espace" class="secondary-small-btn">
            {{ language.t('profile.cancel') }}
          </RouterLink>
        </div>
      </form>

      <section
        v-if="!loading && auth.isMembre"
        class="account-danger-zone"
        aria-labelledby="delete-account-title"
      >
        <div>
          <p class="danger-zone-label">{{ language.t('profile.dangerZone') }}</p>
          <h2 id="delete-account-title">{{ language.t('profile.unsubscribeTitle') }}</h2>
          <p>{{ language.t('profile.unsubscribeText') }}</p>
          <p v-if="auth.isPrestataire" class="danger-zone-provider-note">
            {{ language.t('profile.providerRemovalText') }}
          </p>
        </div>

        <button
          v-if="!showDeleteForm"
          type="button"
          class="delete-account-button"
          @click="showDeleteForm = true"
        >
          {{ language.t('profile.requestUnsubscribe') }}
        </button>

        <form v-else class="delete-account-form" @submit.prevent="deleteAccount">
          <div class="form-group">
            <label for="delete-account-password">{{ language.t('profile.currentPassword') }}</label>
            <input
              id="delete-account-password"
              v-model="deletePassword"
              type="password"
              autocomplete="current-password"
              required
            />
          </div>

          <label class="delete-account-confirmation">
            <input v-model="deleteConfirmed" type="checkbox" required />
            <span>{{ language.t('profile.unsubscribeConfirmation') }}</span>
          </label>

          <p v-if="deleteError" class="error-message">{{ deleteError }}</p>

          <div class="delete-account-actions">
            <button type="submit" class="delete-account-button" :disabled="deleting">
              {{
                deleting
                  ? language.t('profile.unsubscribing')
                  : language.t('profile.confirmUnsubscribe')
              }}
            </button>

            <button
              type="button"
              class="secondary-small-btn"
              :disabled="deleting"
              @click="showDeleteForm = false"
            >
              {{ language.t('profile.cancel') }}
            </button>
          </div>
        </form>
      </section>
    </div>
  </section>
</template>
