<script setup>
import { useLanguageStore } from '../stores/language'

const language = useLanguageStore()
</script>

<template>
  <footer class="app-footer">
    <p>
      © 2026 ServiceConnect — {{ language.t('footer.description') }}
    </p>

    <div class="footer-links">
      <RouterLink to="/confidentialite">
        {{ language.t('footer.privacy') }}
      </RouterLink>

      <RouterLink to="/cookies">
        {{ language.t('footer.cookies') }}
      </RouterLink>

      <RouterLink to="/confiance-securite">
        {{ language.t('footer.trustSecurity') }}
      </RouterLink>

      <RouterLink to="/conditions">
        {{ language.t('footer.terms') }}
      </RouterLink>

      <RouterLink to="/mentions-legales">
        {{ language.t('footer.legal') }}
      </RouterLink>

      <RouterLink to="/centre-aide">
        {{ language.t('footer.helpCenter') }}
      </RouterLink>
    </div>
  </footer>
</template>
