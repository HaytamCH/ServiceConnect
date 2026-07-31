# Déploiement de ServiceConnect avec Portainer

Cette configuration est prévue pour la démonstration du TFE. Les e-mails restent volontairement envoyés vers le canal Laravel `log` et sont visibles dans les logs du conteneur backend.

## Architecture

- `database` utilise MariaDB 11.4 et restaure `serviceconnect_dump.sql` uniquement lorsque son volume est vide.
- `backend-init` attend MariaDB, exécute les migrations puis le seeder de référence non destructif, et s'arrête avec le code 0.
- `backend` démarre seulement si l'initialisation a réussi. Les photos envoyées sont conservées dans un volume distinct.
- `frontend` sert Vue et transmet `/api/*` et `/storage/*` au backend. Le navigateur n'accède jamais directement à MariaDB ou au port Apache.
- GitHub Actions construit trois images GHCR avec les tags `latest` et SHA du commit.

## 1. Préparer GitHub Container Registry

Après le premier push sur `main`, attendre que l'action **Build ServiceConnect** soit verte. Elle publie :

- `ghcr.io/haytamch/serviceconnect-database:<SHA>`
- `ghcr.io/haytamch/serviceconnect-backend:<SHA>`
- `ghcr.io/haytamch/serviceconnect-frontend:<SHA>`

Utiliser le SHA complet du même commit pour les trois images. Si les packages GHCR sont privés, ajouter dans Portainer un registre `ghcr.io` avec le nom d'utilisateur GitHub et un Personal Access Token ayant au minimum le droit `read:packages`.

## 2. Créer les volumes dans Portainer

Dans **Volumes**, créer exactement ces deux volumes avant le premier déploiement :

- `serviceconnect_mariadb_data_v2`
- `serviceconnect_public_uploads_v2`

Le suffixe `v2` est volontaire : il empêche MariaDB de réutiliser le volume MySQL 8 corrompu. Ne pas rattacher l'ancien volume `mysql_data` à cette stack.

## 3. Configurer les variables de la stack

Dans Portainer, créer ou mettre à jour la stack depuis le dépôt Git, avec `docker-compose.yml` comme chemin Compose. Ajouter les variables suivantes dans **Environment variables** :

| Variable | Valeur attendue |
| --- | --- |
| `IMAGE_TAG` | SHA complet du commit dont l'action GitHub est verte |
| `APP_URL` | URL utilisée par le jury, par exemple `http://192.168.1.50:8080` |
| `APP_PORT` | `8080`, ou un autre port libre |
| `APP_KEY` | résultat de `php artisan key:generate --show` |
| `DB_DATABASE` | `serviceconnect` |
| `DB_USERNAME` | `serviceconnect` |
| `DB_PASSWORD` | mot de passe fort réservé à l'application |
| `DB_ROOT_PASSWORD` | autre mot de passe fort pour MariaDB |
| `MAIL_FROM_ADDRESS` | par exemple `noreply@serviceconnect.local` |

Les variables Stripe sont facultatives. Les ajouter seulement si la démonstration utilise réellement Stripe : `STRIPE_KEY`, `STRIPE_SECRET` et `STRIPE_WEBHOOK_SECRET`.

Ne jamais placer les mots de passe, `APP_KEY` ou les clés Stripe dans Git. `portainer.env.example` sert uniquement de liste de référence.

## 4. Premier déploiement

1. Activer l'option Portainer permettant de récupérer les images récentes du registre.
2. Déployer la stack.
3. Suivre d'abord les logs de `database`. Sur un volume vide, l'import SQL doit se terminer sans erreur.
4. Vérifier ensuite `backend-init`. Le conteneur doit afficher les migrations, le seeder, puis terminer avec le code `0`. Son état `exited (0)` est normal.
5. Vérifier que `database`, `backend` et `frontend` sont `healthy`.
6. Ouvrir `APP_URL`, se connecter avec un compte du dump, contrôler les annonces, une photo de profil et une action envoyant un e-mail dans les logs backend.

Le premier import peut être plus lent que les redéploiements. Dès que le volume MariaDB contient la base, le dump n'est plus rejoué et les données créées pendant la démonstration sont conservées.

## 5. Redéploiements suivants

Après un nouveau push et une action GitHub verte :

1. remplacer `IMAGE_TAG` par le nouveau SHA complet ;
2. redéployer la stack en demandant à Portainer de récupérer les images ;
3. vérifier que `backend-init` termine avec le code `0` ;
4. ne pas supprimer les deux volumes `v2`.

Les migrations sont ainsi exécutées automatiquement à chaque version, tandis que `ProductionSeeder` n'ajoute les catégories que si la table est vide. Il ne supprime et ne remplace aucune donnée.

## 6. Réinitialisation exacte de la démonstration

Cette opération supprime les changements effectués depuis le dernier import. Elle ne doit être utilisée que pour revenir volontairement aux données contenues dans le dump versionné.

1. arrêter puis supprimer la stack ;
2. supprimer uniquement `serviceconnect_mariadb_data_v2` et `serviceconnect_public_uploads_v2` ;
3. recréer ces deux volumes vides avec exactement les mêmes noms ;
4. redéployer la stack avec le même `IMAGE_TAG` validé.

MariaDB réimporte alors `serviceconnect_dump.sql`. Le volume des fichiers publics est initialisé depuis l'image backend et récupère la photo de profil de démonstration versionnée.

## Diagnostic rapide

- `backend-init` échoue sur la connexion : vérifier les quatre variables `DB_*` et l'état de santé de `database`.
- MariaDB indique encore une corruption InnoDB : le mauvais ancien volume a été réutilisé ; contrôler le nom exact `serviceconnect_mariadb_data_v2`.
- Portainer ne peut pas télécharger une image GHCR : vérifier le registre, le PAT `read:packages`, le propriétaire `haytamch` et le `IMAGE_TAG`.
- Le frontend affiche une erreur API : vérifier que `backend` est `healthy` et que l'image frontend a été construite avec `/api/v1`.
- Une photo est absente après le tout premier démarrage : vérifier que `serviceconnect_public_uploads_v2` était réellement vide lors de sa première utilisation.
