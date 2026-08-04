# Déploiement de ServiceConnect

Ce fichier reprend la configuration que j’utilise pour la démonstration de ServiceConnect : [https://serviceconnect.jobsacademie.tech](https://serviceconnect.jobsacademie.tech).

## Composition de la stack

La stack contient quatre services :

| Service | Image | Rôle |
| --- | --- | --- |
| `database` | `mysql:8.0` | conserve les données de l’application |
| `backend-init` | `ghcr.io/haytamch/serviceconnect-backend:latest` | prépare la base avant le démarrage de Laravel |
| `backend` | `ghcr.io/haytamch/serviceconnect-backend:latest` | exécute l’API Laravel avec Apache et PHP 8.4 |
| `frontend` | `ghcr.io/haytamch/serviceconnect-frontend:latest` | sert l’interface Vue avec Nginx |

Le frontend utilise le port `8201` du serveur et le backend le port `8200`. MySQL reste uniquement accessible à l’intérieur du réseau Docker.

## Ordre de démarrage

J’ai séparé l’initialisation de la base du conteneur principal afin d’avoir un démarrage prévisible :

1. MySQL démarre et passe son healthcheck ;
2. `backend-init` se connecte à MySQL ;
3. si la table `users` n’existe pas, le script importe `serviceconnect_dump.sql` depuis l’image backend ;
4. Laravel exécute les migrations avec `php artisan migrate --force` ;
5. `ProductionSeeder` ajoute les catégories de référence seulement si elles sont absentes ;
6. `backend-init` termine son travail avec le code `0` ;
7. le backend démarre et répond au healthcheck `/up` ;
8. le frontend démarre à son tour.

Le statut `Exited (0)` de `backend-init` est donc normal. Sur une base déjà initialisée, le dump n’est pas importé une seconde fois et les données existantes restent en place.

## Données persistantes

J’utilise deux volumes nommés :

```text
serviceconnect_mysql_prod_data_v1
serviceconnect_public_uploads_prod_v1
```

Le premier contient la base MySQL. Le second contient les fichiers publics, notamment les photos de profil. Lors d’une mise à jour, je remplace les conteneurs mais je garde ces deux volumes.

Le dump inclus dans l’image permet de préparer une nouvelle base vide avec les données fictives du TFE. Pour garder les changements réalisés après le déploiement, il faut aussi prévoir une sauvegarde SQL récente.

## Configuration dans Portainer

La stack est liée au dépôt Git avec les paramètres suivants :

```text
Repository URL : https://github.com/HaytamCH/ServiceConnect.git
Reference      : refs/heads/main
Compose path   : docker-compose.production.yml
```

Voici les variables utilisées :

| Variable | Valeur ou rôle |
| --- | --- |
| `APP_KEY` | clé Laravel conservée entre les déploiements |
| `APP_URL` | `https://serviceconnect.jobsacademie.tech` |
| `FRONTEND_URL` | `https://serviceconnect.jobsacademie.tech` |
| `FRONTEND_PORT` | `8201` |
| `BACKEND_PORT` | `8200` |
| `DB_DATABASE` | `serviceconnect` |
| `DB_ROOT_PASSWORD` | mot de passe root de la base MySQL |
| `MAIL_FROM_ADDRESS` | adresse utilisée dans les e-mails enregistrés dans les logs |
| `STRIPE_KEY` | clé publique Stripe de test `pk_test_...` |
| `STRIPE_SECRET` | clé secrète Stripe de test `sk_test_...` |
| `STRIPE_WEBHOOK_SECRET` | secret de signature `whsec_...` du webhook déployé |

Dans ma stack, `APP_URL` et `FRONTEND_URL` sont enregistrées sans slash final. Les mots de passe et les clés Stripe restent dans les variables Portainer et ne sont pas enregistrés dans le dépôt.

## GitHub Actions et GHCR

Un push sur `main` lance le workflow **Build ServiceConnect**. Il effectue les opérations suivantes :

1. validation de Composer et installation des dépendances Laravel ;
2. contrôle des routes et exécution des tests PHP ;
3. installation des dépendances du frontend et build Vue ;
4. validation du fichier Compose ;
5. construction des images backend et frontend ;
6. publication des images dans GHCR avec les tags `latest` et SHA du commit.

Le push prépare donc les nouvelles images, mais il ne met pas automatiquement à jour les conteneurs du serveur.

## Mise à jour d’une version

Quand je publie une modification de l’application :

1. je pousse le commit sur `main` ;
2. j’attends que **Build ServiceConnect** soit entièrement vert dans GitHub Actions ;
3. dans Portainer, la stack est mise à jour depuis le dépôt ;
4. l’option **Pull latest image** ou **Re-pull image** récupère les nouvelles images ;
5. la stack est redéployée en conservant les volumes ;
6. je vérifie les états des services et les URL publiques.

États attendus :

```text
database       healthy
backend-init   exited (0)
backend        healthy
frontend       healthy
```

URL de contrôle :

```text
https://serviceconnect.jobsacademie.tech
https://serviceconnect.jobsacademie.tech/up
https://serviceconnect.jobsacademie.tech/api/v1/categories
```

## Ajouter une table à la base de données

Pour ajouter une table, je crée une migration Laravel au lieu de modifier directement la base du serveur :

```bash
php artisan make:migration create_nom_de_la_table_table
php artisan migrate
php artisan test
```

Après avoir poussé la migration, il faut attendre la fin de GitHub Actions puis mettre à jour la stack dans Portainer. Au redéploiement, `backend-init` exécute automatiquement `php artisan migrate --force` et crée la nouvelle table.

Il n’est pas nécessaire de supprimer le volume MySQL ni de réimporter tout le dump. Si la nouvelle table a besoin de données de référence, je peux les ajouter dans un seeder idempotent. Pour une future installation sur une base vide, les migrations sont exécutées après l’import du dump et créeront également cette table.

## Paiement Stripe

Le webhook Stripe de l’environnement de test utilise cette URL :

```text
https://serviceconnect.jobsacademie.tech/api/v1/stripe/webhook
```

Il écoute deux événements :

```text
checkout.session.completed
checkout.session.expired
```

Quand un membre paie, Laravel crée une session Stripe Checkout. Après le paiement, Stripe appelle le webhook. Laravel vérifie la signature, passe le paiement à `accepte` et enregistre la référence `pi_...`. La redirection du navigateur affiche ensuite la page « Mes paiements ».

Le secret affiché dans la destination Stripe est celui que j’utilise dans `STRIPE_WEBHOOK_SECRET`. Le secret créé par Stripe CLI sert uniquement aux tests locaux.

Pour vérifier la configuration chargée par Laravel :

```sh
printenv APP_URL
printenv FRONTEND_URL
php artisan tinker --execute="echo config('app.url'), PHP_EOL; echo config('app.frontend_url'), PHP_EOL;"
```

Les deux URL doivent correspondre au domaine public. Dans Stripe, l’événement `checkout.session.completed` doit être livré avec un code HTTP `200`.

## E-mails

Pour la démonstration, j’utilise `MAIL_MAILER=log`. Les e-mails ne quittent pas le serveur : leur contenu se trouve dans les logs du backend.

## Problèmes déjà rencontrés

| Problème | Solution appliquée |
| --- | --- |
| MySQL redémarrait avec une erreur InnoDB | utilisation d’un volume MySQL 8.0 propre, puis conservation du volume fonctionnel |
| Le dump n’était pas disponible de façon fiable dans Portainer | ajout du dump dans l’image backend et import par `backend-init` |
| Risque de réimporter les données | vérification de la table `users` avant l’import |
| Le dump provenait de MariaDB | adaptation du SQL pour MySQL 8.0 |
| Une ancienne image restait en cache | utilisation de **Re-pull image** après la fin de GitHub Actions |
| Stripe redirigeait vers localhost | configuration de `APP_URL` et `FRONTEND_URL` avec le domaine HTTPS |
| Le paiement restait en attente | création du webhook Stripe et installation de son secret dans Portainer |
