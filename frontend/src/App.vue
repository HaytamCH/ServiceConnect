<script setup>
import AppHeader from './components/AppHeader.vue'
import AppFooter from './components/AppFooter.vue'
import CookieBanner from './components/CookieBanner.vue'
</script>

<template>
  <div class="app">
    <AppHeader />

    <main class="main-content">
      <RouterView />
    </main>

    <AppFooter />
    <CookieBanner />
  </div>
</template>
