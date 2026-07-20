<script setup>
import { computed, ref } from 'vue'
import { useLanguageStore } from '../stores/language'

const language = useLanguageStore()

const STORAGE_KEY = 'serviceconnect_cookie_consent'

const savedConsent = localStorage.getItem(STORAGE_KEY)

const visible = ref(!savedConsent)
const showSettings = ref(false)

const preferences = ref({
  necessary: true,
  analytics: false,
  personalization: false,
})

const currentYear = computed(() => new Date().getFullYear())

function saveConsent(type) {
  const consent = {
    type,
    date: new Date().toISOString(),
    preferences: preferences.value,
  }

  localStorage.setItem(STORAGE_KEY, JSON.stringify(consent))
  visible.value = false
}

function acceptAll() {
  preferences.value.analytics = true
  preferences.value.personalization = true
  saveConsent('all')
}

function rejectOptional() {
  preferences.value.analytics = false
  preferences.value.personalization = false
  saveConsent('necessary_only')
}

function saveSettings() {
  saveConsent('custom')
}
</script>

<template>
  <div v-if="visible" class="cookie-banner">
    <div class="cookie-content">
      <div class="cookie-text">
        <h2>{{ language.t('cookies.title') }}</h2>

        <p>
          {{ language.t('cookies.description') }}
        </p>

        <RouterLink to="/cookies" class="cookie-link">
          {{ language.t('cookies.policyLink') }}
        </RouterLink>
      </div>

      <div class="cookie-actions">
        <button type="button" class="cookie-secondary-btn" @click="showSettings = !showSettings">
          {{ language.t('cookies.settings') }}
        </button>

        <button type="button" class="cookie-dark-btn" @click="rejectOptional">
          {{ language.t('cookies.rejectOptional') }}
        </button>

        <button type="button" class="cookie-dark-btn" @click="acceptAll">
          {{ language.t('cookies.acceptAll') }}
        </button>
      </div>
    </div>

    <div v-if="showSettings" class="cookie-settings">
      <div class="cookie-setting-item">
        <div>
          <strong>{{ language.t('cookies.necessaryTitle') }}</strong>
          <p>{{ language.t('cookies.necessaryText') }}</p>
        </div>

        <span class="cookie-required">
          {{ language.t('cookies.alwaysActive') }}
        </span>
      </div>

      <label class="cookie-setting-item">
        <div>
          <strong>{{ language.t('cookies.analyticsTitle') }}</strong>
          <p>{{ language.t('cookies.analyticsText') }}</p>
        </div>

        <input v-model="preferences.analytics" type="checkbox" />
      </label>

      <label class="cookie-setting-item">
        <div>
          <strong>{{ language.t('cookies.personalizationTitle') }}</strong>
          <p>{{ language.t('cookies.personalizationText') }}</p>
        </div>

        <input v-model="preferences.personalization" type="checkbox" />
      </label>

      <div class="cookie-settings-footer">
        <small>
          © {{ currentYear }} ServiceConnect
        </small>

        <button type="button" class="cookie-save-btn" @click="saveSettings">
          {{ language.t('cookies.saveSettings') }}
        </button>
      </div>
    </div>
  </div>
</template>
