<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import api from '../../api/axios'
import { useAuthStore } from '../../stores/auth'
import { useLanguageStore } from '../../stores/language'
import { useNotificationStore } from '../../stores/notifications'

const route = useRoute()
const auth = useAuthStore()
const language = useLanguageStore()
const notifications = useNotificationStore()

const messages = ref([])
const loading = ref(true)
const error = ref('')
const success = ref('')

const isPrestataire = computed(() => auth.isPrestataire)
const isMembre = computed(() => auth.isMembre)

const showMessageForm = computed(() => {
  if (!isPrestataire.value) {
    return true
  }

  return !!route.query.destinataire_id
})

const form = ref({
  destinataire_id: route.query.destinataire_id || '',
  contenu: '',
})

onMounted(async () => {
  await loadMessages()
  await markMessagesAsRead()
})

async function loadMessages() {
  loading.value = true
  error.value = ''

  try {
    const response = await api.get('/messages')
    messages.value = response.data.data || response.data || []
  } catch (e) {
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
  } catch (e) {
    console.warn('Impossible de marquer les messages comme lus.')
  }
}

async function sendMessage() {
  error.value = ''
  success.value = ''

  if (!form.value.destinataire_id || !form.value.contenu.trim()) {
    error.value = language.t('messages.messageRequired')
    return
  }

  try {
    await api.post('/messages', {
      destinataire_id: form.value.destinataire_id,
      contenu: form.value.contenu.trim(),
    })

    success.value = language.t('messages.sentSuccess')
    form.value.contenu = ''

    await loadMessages()
  } catch (e) {
    error.value = e.response?.data?.message || language.t('messages.sendError')
  }
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
            <div class="message-avatar">
              {{ message.expediteur?.prenom?.charAt(0) || 'U' }}
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

              <small v-if="message.reservation">
                {{ language.t('messages.linkedReservation') }} :
                {{ message.reservation.annonce?.titre || language.t('messages.reservedService') }}
              </small>
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

        <div v-if="route.query.destinataire_id" class="recipient-box">
          <span>{{ language.t('messages.messageTo') }}</span>

          <strong>
            {{ route.query.destinataire_nom || language.t('messages.selectedProvider') }}
          </strong>

          <small v-if="route.query.annonce_titre">
            {{ language.t('messages.about') }} : {{ route.query.annonce_titre }}
          </small>
        </div>

        <div v-else class="recipient-box warning">
          <span>{{ language.t('messages.noProviderSelected') }}</span>
          <strong>{{ language.t('messages.chooseProvider') }}</strong>
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
