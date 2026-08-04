# ServiceConnect

ServiceConnect est une application de démonstration réalisée pour un TFE. Elle met en relation des membres et des prestataires autour d'annonces, de réservations, de messages, d'avis et de paiements de démonstration.

## Technologies

- API Laravel 12, PHP 8.4 et Sanctum
- interface Vue 3 et Vite 8
- MySQL 8.0
- Apache et Nginx dans des conteneurs Docker
- GitHub Actions pour vérifier l'application et publier les images dans GHCR
- Portainer pour exécuter la stack

## Déploiement

La procédure complète, les variables à créer, les volumes à préparer et les contrôles après déploiement sont décrits dans [DEPLOYMENT.md](DEPLOYMENT.md).

Le dump `serviceconnect_dump.sql` et la photo de profil de démonstration sont volontairement versionnés : toutes les données sont fictives et doivent être restaurées à l'identique pour la présentation devant le jury. Le Compose de production actuel n'importe pas automatiquement ce dump dans un volume vide : le volume MySQL et les sauvegardes doivent donc être conservés lors des redéploiements.

Les e-mails utilisent volontairement `MAIL_MAILER=log`. Ils sont consultables dans les logs du conteneur backend.

## Vérifications locales

```bash
composer install
php artisan test

cd frontend
npm ci
npm run build
```

Le déploiement Portainer utilise directement les images GHCR. Il ne construit pas le projet sur le serveur.

Le fichier de stack est `docker-compose.production.yml`. Par défaut, le frontend est publié sur le port `8201` et le backend sur le port `8200`. Les variables de configuration sont centralisées dans le modèle racine `.env.example` ; aucun fichier `.env` séparé n'est nécessaire dans `frontend/`.
