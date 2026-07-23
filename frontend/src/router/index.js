import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/public/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  scrollBehavior() {
    return { top: 0 }
  },
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
      meta: {
        title: 'ServiceConnect — Trouvez un service local',
        description: 'Trouvez et réservez un prestataire local de confiance en Belgique.',
      },
    },
    {
      path: '/annonces',
      name: 'annonces',
      component: () => import('../views/public/SearchResultsView.vue'),
      meta: {
        title: 'Services locaux — ServiceConnect',
        description: 'Recherchez des annonces de services locaux par catégorie et localisation.',
      },
    },
    {
      path: '/categories',
      name: 'categories',
      component: () => import('../views/public/CategoriesView.vue'),
      meta: {
        title: 'Catégories — ServiceConnect',
        description: 'Consultez toutes les catégories de services disponibles sur ServiceConnect.',
      },
    },
    {
      path: '/annonces/:id',
      name: 'annonce-detail',
      component: () => import('../views/public/AnnonceDetailView.vue'),
      props: true,
      meta: {
        title: 'Détail du service — ServiceConnect',
        description: 'Consultez les détails d’un service local disponible sur ServiceConnect.',
      },
    },
    {
      path: '/prestataires/:id',
      name: 'prestataire-detail',
      component: () => import('../views/public/ProviderProfileView.vue'),
      props: true,
      meta: {
        title: 'Profil prestataire — ServiceConnect',
        description: 'Consultez le profil d’un prestataire local sur ServiceConnect.',
      },
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/auth/LoginView.vue'),
      meta: {
        title: 'Connexion — ServiceConnect',
        description: 'Connectez-vous à votre compte ServiceConnect.',
      },
    },
    {
      path: '/forgot-password',
      name: 'forgot-password',
      component: () => import('../views/auth/ForgotPasswordView.vue'),
      meta: {
        title: 'Mot de passe oublié — ServiceConnect',
        description: 'Demandez un lien de réinitialisation de mot de passe.',
      },
    },
    {
      path: '/reset-password',
      name: 'reset-password',
      component: () => import('../views/auth/ResetPasswordView.vue'),
      meta: {
        title: 'Réinitialiser le mot de passe — ServiceConnect',
        description: 'Choisissez un nouveau mot de passe pour votre compte ServiceConnect.',
      },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../views/auth/RegisterView.vue'),
      meta: {
        title: 'Inscription — ServiceConnect',
        description: 'Créez un compte membre ou prestataire sur ServiceConnect.',
      },
    },
    {
      path: '/mon-espace',
      name: 'account',
      component: () => import('../views/account/AccountHomeView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mon espace — ServiceConnect',
        description: 'Espace personnel ServiceConnect.',
      },
    },
    {
      path: '/mon-profil',
      name: 'profile-edit',
      component: () => import('../views/account/ProfileEditView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Modifier mon profil — ServiceConnect',
        description: 'Modifiez vos informations personnelles sur ServiceConnect.',
      },
    },
    {
      path: '/mes-reservations',
      name: 'mes-reservations',
      component: () => import('../views/membre/MesReservationsView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes réservations — ServiceConnect',
        description: 'Consultez vos réservations ServiceConnect.',
      },
    },
    {
      path: '/mes-favoris',
      name: 'mes-favoris',
      component: () => import('../views/membre/MesLikesView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes favoris — ServiceConnect',
        description: 'Consultez vos annonces et prestataires favoris.',
      },
    },
    {
      path: '/mes-messages',
      name: 'mes-messages',
      component: () => import('../views/membre/MesMessagesView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes messages — ServiceConnect',
        description: 'Consultez vos échanges avec les prestataires.',
      },
    },
    {
      path: '/mes-paiements',
      name: 'mes-paiements',
      component: () => import('../views/membre/MesPaiementsView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes paiements — ServiceConnect',
        description: 'Consultez l’historique de vos paiements ServiceConnect.',
      },
    },
    {
      path: '/prestataire/dashboard',
      name: 'prestataire-dashboard',
      component: () => import('../views/prestataire/PrestataireDashboardView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Dashboard prestataire — ServiceConnect',
        description: 'Tableau de bord du prestataire ServiceConnect.',
      },
    },
    {
      path: '/prestataire/annonces',
      name: 'prestataire-annonces',
      component: () => import('../views/prestataire/PrestataireAnnoncesView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes annonces — ServiceConnect',
        description: 'Gestion des annonces du prestataire.',
      },
    },
    {
      path: '/prestataire/annonces/nouvelle',
      name: 'prestataire-annonce-create',
      component: () => import('../views/prestataire/PrestataireAnnonceCreateView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Publier une annonce — ServiceConnect',
        description: 'Créer une nouvelle annonce de service.',
      },
    },
    {
      path: '/prestataire/annonces/:id/modifier',
      name: 'prestataire-annonce-edit',
      component: () => import('../views/prestataire/PrestataireAnnonceEditView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Modifier une annonce — ServiceConnect',
        description: 'Modifier une annonce de service.',
      },
    },
    {
      path: '/prestataire/disponibilites',
      name: 'prestataire-disponibilites',
      component: () => import('../views/prestataire/PrestataireDisponibilitesView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Mes disponibilités — ServiceConnect',
        description: 'Gestion des disponibilités du prestataire.',
      },
    },
    {
      path: '/prestataire/reservations',
      name: 'prestataire-reservations',
      component: () => import('../views/prestataire/PrestataireReservationsView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Réservations reçues — ServiceConnect',
        description: 'Gestion des réservations reçues par le prestataire.',
      },
    },
    {
      path: '/prestataire/avis',
      name: 'prestataire-avis',
      component: () => import('../views/prestataire/PrestataireAvisView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Avis reçus — ServiceConnect',
        description: 'Consultation des avis reçus par le prestataire.',
      },
    },
    {
      path: '/prestataire/paiements',
      name: 'prestataire-paiements',
      component: () => import('../views/prestataire/PrestatairePaiementsView.vue'),
      meta: {
        requiresAuth: true,
        title: 'Paiements reçus — ServiceConnect',
        description: 'Consultation des paiements reçus par le prestataire.',
      },
    },
    {
      path: '/devenir-prestataire',
      name: 'devenir-prestataire',
      component: () => import('../views/public/DevenirPrestataireView.vue'),
      meta: {
        title: 'Devenir prestataire — ServiceConnect',
        description: 'Proposez vos services locaux sur ServiceConnect.',
      },
    },
    {
      path: '/confidentialite',
      name: 'confidentialite',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'confidentialite',
        title: 'Politique de confidentialité — ServiceConnect',
        description: 'Politique de confidentialité de ServiceConnect.',
      },
    },
    {
      path: '/cookies',
      name: 'cookies',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'cookies',
        title: 'Politique de cookies — ServiceConnect',
        description: 'Politique en matière de cookies de ServiceConnect.',
      },
    },
    {
      path: '/confiance-securite',
      name: 'confiance-securite',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'confiance',
        title: 'Confiance et sécurité — ServiceConnect',
        description: 'Mesures de confiance et de sécurité sur ServiceConnect.',
      },
    },
    {
      path: '/conditions',
      name: 'conditions',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'conditions',
        title: 'Conditions générales — ServiceConnect',
        description: 'Conditions générales d’utilisation de ServiceConnect.',
      },
    },
    {
      path: '/mentions-legales',
      name: 'mentions-legales',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'mentions',
        title: 'Mentions légales — ServiceConnect',
        description: 'Mentions légales de ServiceConnect.',
      },
    },
    {
      path: '/centre-aide',
      name: 'centre-aide',
      component: () => import('../views/legal/LegalPageView.vue'),
      meta: {
        pageKey: 'aide',
        title: 'Centre d’aide — ServiceConnect',
        description: 'Centre d’aide ServiceConnect.',
      },
    },
    {
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      component: () => import('../views/admin/AdminDashboardView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Administration — ServiceConnect',
        description: 'Tableau de bord administrateur ServiceConnect.',
      },
    },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: () => import('../views/admin/AdminUsersView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Gestion utilisateurs — ServiceConnect',
        description: 'Gestion des utilisateurs ServiceConnect.',
      },
    },
    {
      path: '/admin/annonces',
      name: 'admin-annonces',
      component: () => import('../views/admin/AdminAnnoncesView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Gestion annonces — ServiceConnect',
        description: 'Gestion des annonces ServiceConnect.',
      },
    },
    {
      path: '/admin/categories',
      name: 'admin-categories',
      component: () => import('../views/admin/AdminCategoriesView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Gestion catégories — ServiceConnect',
        description: 'Gestion des catégories ServiceConnect.',
      },
    },
    {
      path: '/admin/avis',
      name: 'admin-avis',
      component: () => import('../views/admin/AdminAvisView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Gestion avis — ServiceConnect',
        description: 'Gestion des avis ServiceConnect.',
      },
    },
    {
      path: '/admin/messages',
      name: 'admin-messages',
      component: () => import('../views/admin/AdminMessagesView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Messages — Administration ServiceConnect',
        description: 'Consultation des messages échangés sur ServiceConnect.',
      },
    },
    {
      path: '/admin/paiements',
      name: 'admin-paiements',
      component: () => import('../views/admin/AdminPaiementsView.vue'),
      meta: {
        requiresAuth: true,
        requiresAdmin: true,
        title: 'Gestion paiements — ServiceConnect',
        description: 'Gestion des paiements ServiceConnect.',
      },
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: '/',
    },
  ],
})

router.afterEach((to) => {
  document.title = to.meta.title || 'ServiceConnect — Services locaux en Belgique'

  const description = document.querySelector('meta[name="description"]')
  if (description) {
    description.setAttribute(
      'content',
      to.meta.description || 'ServiceConnect facilite la recherche de prestataires locaux.',
    )
  }
})
router.beforeEach((to) => {
  const token = localStorage.getItem('token')
  const storedUser = localStorage.getItem('user')

  let user = null

  if (storedUser) {
    try {
      user = JSON.parse(storedUser)
    } catch (e) {
      user = null
      localStorage.removeItem('user')
    }
  }

  if (to.meta.requiresAuth && !token) {
    return {
      path: '/login',
      query: {
        redirect: to.fullPath,
      },
    }
  }

  if (to.meta.requiresAdmin && user?.role !== 'administrateur') {
    return {
      path: '/mon-espace',
    }
  }
})
export default router
