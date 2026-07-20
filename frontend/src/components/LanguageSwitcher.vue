<script setup>
import { useLanguageStore } from '../stores/language'

const language = useLanguageStore()
</script>

<template>
  <select
    class="language-switcher"
    :value="language.current"
    @change="language.setLanguage($event.target.value)"
  >
    <option value="fr">FR</option>
    <option value="en">EN</option>
    <option value="nl">NL</option>
  </select>
</template>
