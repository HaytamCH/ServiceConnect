<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'
import { annonceUrl } from '../../utils/slug'

const route = useRoute()
const auth = useAuthStore()
const language = useLanguageStore()
const notifications = useNotificationStore()

const messages = ref([])
const loading = ref(true)
const error = ref('')
const success = ref('')

const selectedRecipientName = ref('')
const selectedAnnonceTitle = ref('')

const isPrestataire = computed(() => auth.isPrestataire)
const isMembre = computed(() => auth.isMembre)

const form = ref({
  destinataire_id: '',
  annonce_id: '',
  contenu: '',
})

const showMessageForm = computed(() => {
  return !!form.value.destinataire_id
})

onMounted(async () => {
  await initialiseMessageFormFromRoute()
  await loadMessages()
  await markMessagesAsRead()
})

async function initialiseMessageFormFromRoute() {
  if (!auth.user && auth.token) {
    try {
      await auth.fetchUser()
    } catch {
      console.warn('Utilisateur non rechargé.')
    }
  }

  const destinataireId = String(route.query.destinataire_id || '')

  if (!destinataireId) {
    return
  }

  if (isSelfRecipient(destinataireId)) {
    form.value.destinataire_id = ''
    form.value.annonce_id = ''
    selectedRecipientName.value = ''
    selectedAnnonceTitle.value = ''
    return
  }

  form.value.destinataire_id = destinataireId
  form.value.annonce_id = String(route.query.annonce_id || '')
  selectedRecipientName.value = String(route.query.destinataire_nom || '')
  selectedAnnonceTitle.value = String(route.query.annonce_titre || '')
}

async function loadMessages() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/messages')
    messages.value = response.data.data || response.data || []
  } catch {
    error.value = language.t('messages.loadError')
  } finally {
    loading.value = false
  }
}

async function markMessagesAsRead() {
  try {
    await api.patch('/messages/mark-as-read')
    await api.patch('/notifications/mark-as-read?type=message')
    await notifications.loadSummary()
  } catch {
    console.warn('Impossible de marquer les messages comme lus.')
  }
}

function isSelfRecipient(id) {
  return Number(id) === Number(auth.user?.id)
}

function getOtherPerson(message) {
  const currentUserId = Number(auth.user?.id)

  if (Number(message.expediteur_id) === currentUserId) {
    return message.destinataire
  }

  if (Number(message.destinataire_id) === currentUserId) {
    return message.expediteur
  }

  return null
}

function selectReplyRecipient(message) {
  error.value = ''
  success.value = ''

  const otherPerson = getOtherPerson(message)

  if (!otherPerson || isSelfRecipient(otherPerson.id)) {
    error.value = language.t('messages.recipientSelectError')
    return
  }

  const annonce = getLinkedAnnonce(message)

  form.value.destinataire_id = otherPerson.id
  form.value.annonce_id = annonce?.id || ''
  form.value.contenu = ''

  selectedRecipientName.value = getPersonName(otherPerson)
  selectedAnnonceTitle.value = annonce?.titre || ''

  window.scrollTo({
    top: 0,
    behavior: 'smooth',
  })
}

async function sendMessage() {
  error.value = ''
  success.value = ''

  if (!form.value.destinataire_id || !form.value.contenu.trim()) {
    error.value = language.t('messages.messageRequired')
    return
  }

  if (isSelfRecipient(form.value.destinataire_id)) {
    error.value = language.t('messages.selfMessageError')
    return
  }

  try {
    const payload = {
      destinataire_id: form.value.destinataire_id,
      contenu: form.value.contenu.trim(),
    }

    if (form.value.annonce_id) {
      payload.annonce_id = form.value.annonce_id
    }

    await api.post('/messages', payload)

    success.value = language.t('messages.sentSuccess')
    form.value.contenu = ''

    await loadMessages()
  } catch (e) {
    error.value = e.response?.data?.message || language.t('messages.sendError')
  }
}

function getProfilePhotoUrl(user) {
  return user?.photo_profil_url || ''
}

function formatDate(date) {
  if (!date) {
    return ''
  }

  const locale =
    language.current === 'en'
      ? 'en-GB'
      : language.current === 'nl'
        ? 'nl-BE'
        : 'fr-BE'

  return new Date(date).toLocaleString(locale)
}

function getPersonName(person) {
  if (!person) {
    return language.t('messages.user')
  }

  return `${person.prenom || ''} ${person.nom || ''}`.trim()
}

function getLinkedAnnonce(message) {
  if (message.annonce) {
    return message.annonce
  }

  if (message.reservation?.annonce) {
    return message.reservation.annonce
  }

  return null
}

function canOpenAnnonce(message) {
  const annonce = getLinkedAnnonce(message)

  return annonce && annonce.statut === 'publiee'
}

function getAnnonceTitle(message) {
  const annonce = getLinkedAnnonce(message)

  return annonce?.titre || language.t('messages.reservedService')
}
</script>

<template>
  <section class="member-page">
    <div class="member-header">
      <div>
        <p class="breadcrumb">
          {{ language.t('account.title') }} › {{ language.t('messages.title') }}
        </p>

        <h1>{{ language.t('messages.title') }}</h1>

        <p>
          {{ language.t('messages.subtitle') }}
        </p>
      </div>

      <div class="form-actions left">
        <RouterLink v-if="isMembre" to="/annonces" class="primary-small-btn">
          {{ language.t('messages.contactProvider') }}
        </RouterLink>

        <RouterLink v-if="isPrestataire" to="/prestataire/dashboard" class="secondary-small-btn">
          {{ language.t('common.backToDashboard') }}
        </RouterLink>
      </div>
    </div>

    <p v-if="loading">
      {{ language.t('messages.loading') }}
    </p>

    <p v-if="error" class="error-message">
      {{ error }}
    </p>

    <p v-if="success" class="success-message">
      {{ success }}
    </p>

    <div class="messages-layout" :class="{ 'messages-layout-full': !showMessageForm }">
      <section class="messages-card">
        <h2>{{ language.t('messages.conversation') }}</h2>

        <div v-if="!loading && messages.length" class="message-list">
          <article v-for="message in messages" :key="message.id" class="message-item">
            <div class="message-avatar user-avatar">
              <img
                v-if="getProfilePhotoUrl(message.expediteur)"
                :src="getProfilePhotoUrl(message.expediteur)"
                alt="Photo utilisateur"
              />

              <span v-else class="default-avatar-icon"></span>
            </div>

            <div class="message-content">
              <div class="message-top">
                <strong>
                  {{ getPersonName(message.expediteur) }}
                  →
                  {{ getPersonName(message.destinataire) }}
                </strong>

                <span>{{ formatDate(message.created_at) }}</span>
              </div>

              <p>{{ message.contenu }}</p>

              <RouterLink
                v-if="canOpenAnnonce(message)"
                :to="annonceUrl(getLinkedAnnonce(message))"
                class="admin-inline-link"
              >
                {{ language.t('messages.viewListing') }} : {{ getAnnonceTitle(message) }}
              </RouterLink>

              <small v-else-if="getLinkedAnnonce(message)">
                {{ language.t('messages.linkedListingUnavailable') }} : {{ getAnnonceTitle(message) }}
              </small>

              <div class="message-actions">
                <button
                  type="button"
                  class="secondary-small-btn"
                  @click="selectReplyRecipient(message)"
                >
                  {{ language.t('messages.reply') }}
                </button>
              </div>
            </div>
          </article>
        </div>

        <div v-if="!loading && messages.length === 0" class="empty-results">
          <h2>{{ language.t('messages.noMessageTitle') }}</h2>
          <p>{{ language.t('messages.noMessageText') }}</p>
        </div>
      </section>

      <aside v-if="showMessageForm" class="message-form-card">
        <h2>{{ language.t('messages.newMessage') }}</h2>

        <div class="recipient-box">
          <span>{{ language.t('messages.messageTo') }}</span>

          <strong>
            {{ selectedRecipientName || language.t('messages.selectedProvider') }}
          </strong>

          <small v-if="selectedAnnonceTitle">
            {{ language.t('messages.about') }} : {{ selectedAnnonceTitle }}
          </small>
        </div>

        <div class="form-group">
          <label>{{ language.t('common.message') }}</label>

          <textarea
            v-model="form.contenu"
            rows="6"
            :placeholder="language.t('messages.writePlaceholder')"
          ></textarea>
        </div>

        <button type="button" class="auth-submit" @click="sendMessage">
          {{ language.t('messages.send') }}
        </button>
      </aside>
    </div>
  </section>
</template>
