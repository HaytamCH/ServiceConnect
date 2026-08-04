# Déploiement de ServiceConnect avec Portainer

Cette configuration correspond à la démonstration du TFE actuellement déployée sur `https://serviceconnect.jobsacademie.tech`. Les e-mails restent volontairement envoyés vers le canal Laravel `log` et sont visibles dans les logs du backend.

## Architecture actuelle

- `database` utilise l'image officielle `mysql:8.0` et le volume persistant `serviceconnect_mysql_prod_data_v1`.
- `backend-init` attend MySQL, exécute les migrations et le seeder de production non destructif, puis s'arrête avec le code `0`.
- `backend` expose Laravel sur le port `8200` et conserve les fichiers publics dans `serviceconnect_public_uploads_prod_v1`.
- `frontend` expose Vue/Nginx sur le port `8201` et transmet `/api/*`, `/storage/*` et `/up` au backend.
- GitHub Actions vérifie l'application et publie les images backend et frontend dans GHCR avec les tags `latest` et SHA du commit.

Le Compose actuel n'importe pas automatiquement `serviceconnect_dump.sql` dans un volume vide. Il ne faut donc jamais supprimer `serviceconnect_mysql_prod_data_v1` sans disposer d'une sauvegarde SQL vérifiée.

## Configuration Portainer

Utiliser le dépôt Git avec :

```text
Repository URL : https://github.com/HaytamCH/ServiceConnect.git
Reference      : refs/heads/main
Compose path   : docker-compose.production.yml
```

Configurer ces variables dans la stack :

| Variable | Valeur attendue |
| --- | --- |
| `APP_URL` | `https://serviceconnect.jobsacademie.tech` |
| `FRONTEND_URL` | `https://serviceconnect.jobsacademie.tech` |
| `FRONTEND_PORT` | `8201` |
| `BACKEND_PORT` | `8200` |
| `APP_KEY` | clé Laravel existante, ou résultat de `php artisan key:generate --show` |
| `DB_DATABASE` | `serviceconnect` |
| `DB_ROOT_PASSWORD` | mot de passe root du volume MySQL actuel |
| `MAIL_FROM_ADDRESS` | par exemple `noreply@serviceconnect.local` |
| `STRIPE_KEY` | clé publique Stripe du mode test |
| `STRIPE_SECRET` | clé secrète Stripe du mode test |
| `STRIPE_WEBHOOK_SECRET` | secret `whsec_...` de l'endpoint webhook déployé |

Ne jamais placer `APP_KEY`, les mots de passe ou les secrets Stripe dans Git. Le fichier racine `.env.example` est uniquement un modèle.

## Redéploiement

Après un push sur `main` :

1. attendre que l'action GitHub **Build ServiceConnect** soit verte ;
2. dans Portainer, mettre à jour la stack depuis le dépôt ;
3. activer la récupération des images récentes afin de remplacer les images `latest` en cache ;
4. vérifier que `backend-init` termine avec `Exited (0)` ;
5. vérifier que `database`, `backend` et `frontend` sont `healthy` ;
6. ne supprimer aucun des deux volumes de production.

Endpoints de contrôle :

```text
https://serviceconnect.jobsacademie.tech
https://serviceconnect.jobsacademie.tech/up
https://serviceconnect.jobsacademie.tech/api/v1/categories
```

## Configuration Stripe

Dans le Dashboard Stripe en mode test, créer cet endpoint webhook :

```text
https://serviceconnect.jobsacademie.tech/api/v1/stripe/webhook
```

Écouter au minimum :

```text
checkout.session.completed
checkout.session.expired
```

Copier le secret `whsec_...` de cet endpoint dans `STRIPE_WEBHOOK_SECRET`, puis redéployer la stack. Le secret d'un Stripe CLI local ne doit pas être utilisé sur le serveur.

Dans la console du conteneur backend, contrôler l'environnement et le cache Laravel :

```sh
printenv APP_URL
printenv FRONTEND_URL
php artisan tinker --execute="echo config('app.url'), PHP_EOL; echo config('app.frontend_url'), PHP_EOL;"
```

Les quatre valeurs doivent être exactement :

```text
https://serviceconnect.jobsacademie.tech
```

Si le cache contient encore une ancienne valeur :

```sh
php artisan optimize:clear
php artisan config:cache
```

Une session Stripe existante conserve ses anciennes URL de retour. Après une correction, revenir dans ServiceConnect et démarrer un nouveau paiement au lieu de réutiliser l'ancienne page Checkout.

Après le paiement avec la carte de test `4242 4242 4242 4242`, vérifier dans le Dashboard Stripe que l'événement webhook a reçu une réponse HTTP `200`. Sans webhook valide, le retour vers le site peut fonctionner mais le paiement restera `en_attente` dans ServiceConnect.

## Diagnostic rapide

- Redirection Stripe vers localhost : contrôler `APP_URL`, `FRONTEND_URL`, le cache Laravel, puis créer une nouvelle session Checkout.
- Paiement toujours `en_attente` : contrôler la livraison de `checkout.session.completed` et `STRIPE_WEBHOOK_SECRET`.
- Erreur `FRONTEND_URL must be configured in Portainer` : ajouter explicitement la variable HTTPS dans la stack.
- Image GHCR non mise à jour : redéployer en activant la récupération de l'image `latest`.
- Erreur InnoDB ou redémarrage continu de MySQL : ne pas réutiliser un ancien volume corrompu et ne pas supprimer le volume de production fonctionnel.
- Perte des données de démonstration après création d'un volume vide : restaurer une sauvegarde SQL ; le dump n'est pas importé automatiquement par le Compose actuel.
