import { defineStore } from 'pinia'
import { translations } from '../i18n/translations'

export const useLanguageStore = defineStore('language', {
  state: () => ({
    current: localStorage.getItem('language') || 'fr',
  }),

  actions: {
    setLanguage(language) {
      if (!translations[language]) {
        return
      }

      this.current = language
      localStorage.setItem('language', language)
    },

    t(key) {
      const parts = key.split('.')
      let value = translations[this.current] || translations.fr

      for (const part of parts) {
        if (!value || value[part] === undefined) {
          return key
        }

        value = value[part]
      }

      return value
    },
  },
})
