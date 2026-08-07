<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { legalPageTranslations } from '../../i18n/legalPages'
import { useLanguageStore } from '../../stores/language'

const route = useRoute()
const language = useLanguageStore()

const frenchPages = {
  confidentialite: {
    breadcrumb: 'ServiceConnect › Confidentialité',
    title: 'Politique de confidentialité',
    subtitle: 'Cette page explique comment ServiceConnect collecte, utilise et protège les données personnelles des utilisateurs.',
    sections: [
      {
        title: '1. Données collectées',
        paragraphs: [
          'ServiceConnect peut collecter les informations nécessaires à la création et à l’utilisation d’un compte : nom, prénom, adresse e-mail, téléphone, localisation, rôle du compte et informations de profil.',
          'Lorsque l’utilisateur utilise la plateforme, certaines données liées aux annonces, réservations, messages, avis, favoris et paiements peuvent également être enregistrées afin d’assurer le fonctionnement du service.',
        ],
      },
      {
        title: '2. Utilisation des données',
        paragraphs: [
          'Les données sont utilisées pour permettre la mise en relation entre les membres et les prestataires, gérer les réservations, afficher les annonces, envoyer des messages et assurer le suivi des paiements.',
          'Elles peuvent également être utilisées pour améliorer la sécurité, prévenir les abus et garantir une expérience plus fiable sur la plateforme.',
        ],
      },
      {
        title: '3. Sécurité et accès',
        paragraphs: [
          'L’accès aux espaces personnels est protégé par un système d’authentification. Les données sensibles ne sont accessibles qu’aux utilisateurs autorisés selon leur rôle : membre, prestataire ou administrateur.',
          'ServiceConnect applique une logique de contrôle d’accès afin qu’un utilisateur ne puisse consulter que les informations qui le concernent.',
        ],
      },
      {
        title: '4. Durée de conservation',
        paragraphs: [
          'Les données sont conservées pendant la durée nécessaire au fonctionnement du service, au suivi des demandes et au respect des obligations légales ou administratives applicables.',
        ],
      },
      {
        title: '5. Droits des utilisateurs',
        paragraphs: [
          'Chaque utilisateur peut demander l’accès, la correction ou la suppression de ses données personnelles, dans les limites permises par la loi et par les besoins de fonctionnement du service.',
        ],
      },
    ],
  },

  cookies: {
    breadcrumb: 'ServiceConnect › Cookies',
    title: 'Politique en matière de cookies',
    subtitle: 'Cette page présente l’utilisation des cookies sur ServiceConnect.',
    sections: [
      {
        title: '1. Qu’est-ce qu’un cookie ?',
        paragraphs: [
          'Un cookie est un petit fichier enregistré dans le navigateur de l’utilisateur. Il peut permettre au site de fonctionner correctement, de mémoriser certaines préférences ou de mesurer l’utilisation du service.',
        ],
      },
      {
        title: '2. Cookies nécessaires',
        paragraphs: [
          'Les cookies nécessaires sont indispensables au bon fonctionnement de la plateforme. Ils permettent par exemple de maintenir une session utilisateur ou de conserver les préférences de consentement.',
          'Ces cookies ne peuvent pas être désactivés depuis la bannière car ils sont nécessaires au fonctionnement du site.',
        ],
      },
      {
        title: '3. Cookies facultatifs',
        paragraphs: [
          'ServiceConnect prévoit des cookies facultatifs pour la mesure d’audience et la personnalisation. Dans la version actuelle du projet, aucun outil externe de suivi n’est activé.',
          'La bannière permet toutefois déjà à l’utilisateur d’accepter, refuser ou personnaliser ses choix, afin de prévoir une évolution future conforme au consentement.',
        ],
      },
      {
        title: '4. Gestion du consentement',
        paragraphs: [
          'Les choix de l’utilisateur sont enregistrés localement dans le navigateur. L’utilisateur peut réinitialiser ses préférences en supprimant les données locales de son navigateur.',
        ],
      },
    ],
  },

  confiance: {
    breadcrumb: 'ServiceConnect › Confiance et sécurité',
    title: 'Confiance et sécurité',
    subtitle: 'ServiceConnect met en place plusieurs mécanismes pour favoriser une relation fiable entre membres et prestataires.',
    sections: [
      {
        title: '1. Profils utilisateurs',
        paragraphs: [
          'Chaque utilisateur doit créer un compte afin d’accéder aux fonctionnalités principales de la plateforme. Les informations de profil permettent d’identifier le membre ou le prestataire dans le cadre des échanges.',
          'Les prestataires peuvent présenter leurs services, leur localisation, leurs disponibilités et leurs informations professionnelles utiles.',
        ],
      },
      {
        title: '2. Avis et réputation',
        paragraphs: [
          'Les avis permettent aux membres de partager leur expérience après une réservation. Ils contribuent à renforcer la confiance et à aider les futurs utilisateurs dans leur choix.',
          'Les avis peuvent être modérés par l’administration afin de limiter les abus, les contenus inappropriés ou les comportements frauduleux.',
        ],
      },
      {
        title: '3. Paiement sécurisé',
        paragraphs: [
          'ServiceConnect prévoit un système de paiement lié aux réservations. Dans une version réelle, le paiement peut être traité par un prestataire externe sécurisé comme Stripe.',
          'Les informations sensibles de paiement ne doivent pas être stockées directement par ServiceConnect. Elles sont traitées par le prestataire de paiement choisi.',
        ],
      },
      {
        title: '4. Contrôle des accès',
        paragraphs: [
          'Les accès sont séparés selon les rôles. Un membre peut réserver, envoyer des messages, gérer ses favoris et consulter ses paiements. Un prestataire peut publier des annonces, gérer ses disponibilités et répondre aux réservations.',
          'Un administrateur peut gérer les contenus importants de la plateforme, comme les utilisateurs, les catégories, les annonces, les avis et les paiements.',
        ],
      },
      {
        title: '5. Signalement et assistance',
        paragraphs: [
          'En cas de problème, les utilisateurs peuvent contacter l’équipe ServiceConnect afin de demander de l’aide, signaler un contenu ou obtenir des informations sur l’utilisation de la plateforme.',
        ],
      },
    ],
  },

  conditions: {
    breadcrumb: 'ServiceConnect › Conditions générales',
    title: 'Conditions générales d’utilisation',
    subtitle: 'Ces conditions définissent les règles d’utilisation de la plateforme ServiceConnect.',
    sections: [
      {
        title: '1. Objet de la plateforme',
        paragraphs: [
          'ServiceConnect est une plateforme de mise en relation entre des membres recherchant un service local et des prestataires proposant leurs services.',
          'La plateforme facilite la publication d’annonces, la recherche de services, les réservations, les échanges par messages, les avis, les favoris et le suivi des paiements.',
        ],
      },
      {
        title: '2. Rôle de ServiceConnect',
        paragraphs: [
          'ServiceConnect agit comme intermédiaire technique entre les membres et les prestataires. La plateforme ne réalise pas elle-même les prestations proposées.',
          'Le prestataire reste responsable de la qualité, de la réalisation et du respect des engagements liés à son service. Le membre reste responsable des informations qu’il fournit lors de sa demande.',
        ],
      },
      {
        title: '3. Comptes utilisateurs',
        paragraphs: [
          'L’utilisateur s’engage à fournir des informations exactes lors de son inscription et à maintenir son compte à jour.',
          'Un compte peut avoir un rôle de membre, de prestataire ou d’administrateur. Un prestataire peut également utiliser certaines fonctionnalités réservées aux membres, comme les favoris ou les réservations.',
        ],
      },
      {
        title: '4. Annonces et réservations',
        paragraphs: [
          'Les prestataires peuvent publier des annonces décrivant leurs services, leurs tarifs, leur localisation et leurs disponibilités.',
          'Les membres peuvent effectuer une demande de réservation sur base des disponibilités proposées. Le prestataire peut accepter, refuser ou proposer une alternative selon la situation.',
        ],
      },
      {
        title: '5. Paiements',
        paragraphs: [
          'Les paiements sont liés aux réservations acceptées. Le montant dépend du tarif indiqué dans l’annonce.',
          'Dans une version réelle, ServiceConnect peut utiliser un prestataire externe de paiement afin de sécuriser la transaction.',
        ],
      },
      {
        title: '6. Comportements interdits',
        paragraphs: [
          'Il est interdit de publier des contenus faux, injurieux, discriminatoires, frauduleux ou contraires à la loi.',
          'ServiceConnect peut suspendre ou désactiver un compte en cas d’abus, de fraude, de non-respect des règles ou d’utilisation anormale de la plateforme.',
        ],
      },
    ],
  },

  mentions: {
    breadcrumb: 'ServiceConnect › Mentions légales',
    title: 'Mentions légales',
    subtitle: 'Cette page regroupe les informations générales relatives à ServiceConnect.',
    sections: [
      {
        title: '1. Éditeur du site',
        paragraphs: [
          'Le site ServiceConnect est édité dans le cadre d’un projet de fin d’études. Les informations présentées servent à démontrer le fonctionnement d’une plateforme de services locaux.',
          'Nom du projet : ServiceConnect.',
          'Activité : plateforme de mise en relation entre membres et prestataires de services locaux.',
        ],
      },
      {
        title: '2. Hébergement',
        paragraphs: [
          'Dans le cadre du développement local, l’application peut être exécutée sur un environnement de test. En production, les informations de l’hébergeur devront être complétées avec les coordonnées réelles du prestataire choisi.',
        ],
      },
      {
        title: '3. Propriété intellectuelle',
        paragraphs: [
          'Les textes, interfaces, éléments graphiques, structures de pages et composants développés pour ServiceConnect appartiennent au projet ServiceConnect, sauf mention contraire.',
          'Toute reproduction ou réutilisation sans autorisation est interdite.',
        ],
      },
      {
        title: '4. Responsabilité',
        paragraphs: [
          'ServiceConnect met à disposition un service de mise en relation. La plateforme ne peut pas garantir à elle seule la réalisation parfaite de chaque prestation, qui dépend du prestataire et des informations communiquées par le membre.',
        ],
      },
    ],
  },

  aide: {
    breadcrumb: 'ServiceConnect › Centre d’aide',
    title: 'Centre d’aide',
    subtitle: 'Retrouvez les réponses aux questions fréquentes sur l’utilisation de ServiceConnect.',
    sections: [
      {
        title: '1. Créer un compte',
        paragraphs: [
          'Pour utiliser les principales fonctionnalités de ServiceConnect, l’utilisateur doit créer un compte. Il peut s’inscrire comme membre ou comme prestataire.',
          'Un membre peut rechercher un service, réserver, envoyer des messages, ajouter des favoris et laisser des avis.',
        ],
      },
      {
        title: '2. Devenir prestataire',
        paragraphs: [
          'Un utilisateur peut activer son profil prestataire afin de publier des annonces, gérer ses disponibilités et recevoir des demandes de réservation.',
          'Un prestataire conserve également certaines fonctionnalités de membre, comme les favoris, les messages ou les réservations.',
        ],
      },
      {
        title: '3. Réserver un service',
        paragraphs: [
          'Pour réserver un service, l’utilisateur consulte une annonce, choisit une disponibilité et envoie une demande au prestataire.',
          'Le prestataire peut ensuite accepter, refuser ou proposer une alternative.',
        ],
      },
      {
        title: '4. Gérer les favoris',
        paragraphs: [
          'Les membres peuvent ajouter des annonces ou des prestataires à leurs favoris afin de les retrouver plus facilement.',
        ],
      },
      {
        title: '5. Contacter un prestataire',
        paragraphs: [
          'La messagerie permet aux utilisateurs d’échanger avec un prestataire au sujet d’un service, d’une annonce ou d’une réservation.',
        ],
      },
      {
        title: '6. Besoin d’aide ?',
        paragraphs: [
          'En cas de difficulté, l’utilisateur peut contacter l’équipe ServiceConnect. Dans une version complète, un formulaire de contact ou une adresse e-mail de support pourra être ajouté.',
        ],
      },
    ],
  },
}

const page = computed(() => {
  const pageKey = route.meta.pageKey || 'confidentialite'
  const translatedPages = legalPageTranslations[language.current]

  return translatedPages?.[pageKey] || frenchPages[pageKey] || frenchPages.confidentialite
})
</script>

<template>
  <section class="legal-page">
    <div class="legal-hero">
      <p class="breadcrumb">{{ page.breadcrumb }}</p>
      <h1>{{ page.title }}</h1>
      <p>{{ page.subtitle }}</p>
    </div>

    <div class="legal-layout">
      <aside class="legal-menu">
        <RouterLink to="/confidentialite">{{ language.t('footer.privacy') }}</RouterLink>
        <RouterLink to="/cookies">{{ language.t('footer.cookies') }}</RouterLink>
        <RouterLink to="/confiance-securite">{{ language.t('footer.trustSecurity') }}</RouterLink>
        <RouterLink to="/conditions">{{ language.t('footer.terms') }}</RouterLink>
        <RouterLink to="/mentions-legales">{{ language.t('footer.legal') }}</RouterLink>
        <RouterLink to="/centre-aide">{{ language.t('footer.helpCenter') }}</RouterLink>
      </aside>

      <main class="legal-card">
        <section
          v-for="section in page.sections"
          :key="section.title"
          class="legal-section"
        >
          <h2>{{ section.title }}</h2>

          <p
            v-for="paragraph in section.paragraphs"
            :key="paragraph"
          >
            {{ paragraph }}
          </p>
        </section>
      </main>
    </div>
  </section>
</template>
