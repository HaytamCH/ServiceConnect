-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 28 juil. 2026 à 21:14
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `serviceconnect`
--

-- --------------------------------------------------------

--
-- Structure de la table `annonces`
--

CREATE TABLE `annonces` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `prestataire_id` bigint(20) UNSIGNED NOT NULL,
  `categorie_id` bigint(20) UNSIGNED NOT NULL,
  `titre` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `tarif` decimal(10,2) DEFAULT NULL,
  `localisation` varchar(255) DEFAULT NULL,
  `statut` enum('brouillon','en_attente','publiee','suspendue','supprimee') NOT NULL DEFAULT 'en_attente',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `annonces`
--

INSERT INTO `annonces` (`id`, `prestataire_id`, `categorie_id`, `titre`, `description`, `tarif`, `localisation`, `statut`, `created_at`, `updated_at`) VALUES
(1, 89, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 51.81, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 104, 1, 'Montage de meuble à domicile', 'Montage de meuble à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 48.71, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 81, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 22.02, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 97, 3, 'Nettoyage de terrasse', 'Nettoyage de terrasse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 53.76, 'Ixelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 72, 3, 'Taille de haies', 'Taille de haies. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 48.53, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 83, 1, 'Fixation d’étagères murales', 'Fixation d’étagères murales. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.88, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 89, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 48.67, 'Forest', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 100, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 53.79, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 84, 8, 'Accompagnement rendez-vous', 'Accompagnement rendez-vous. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.42, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 87, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 18.64, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 74, 5, 'Dépannage informatique à domicile', 'Dépannage informatique à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 33.06, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 78, 8, 'Petits services quotidiens', 'Petits services quotidiens. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.78, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 95, 5, 'Installation ordinateur et imprimante', 'Installation ordinateur et imprimante. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 27.95, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 93, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 23.29, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 99, 2, 'Entretien régulier du logement', 'Entretien régulier du logement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 46.13, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 77, 6, 'Petite intervention sanitaire', 'Petite intervention sanitaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 27.46, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 111, 4, 'Garde ponctuelle le week-end', 'Garde ponctuelle le week-end. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 23.47, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 72, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.37, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 73, 1, 'Petits travaux de réparation', 'Petits travaux de réparation. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.29, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 93, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 27.46, 'Uccle', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 82, 5, 'Aide à l’utilisation du PC', 'Aide à l’utilisation du PC. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 25.84, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 86, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 38.14, 'Ixelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 105, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 35.47, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 102, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 28.97, 'Ixelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 73, 5, 'Dépannage informatique à domicile', 'Dépannage informatique à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 38.28, 'Forest', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 108, 2, 'Entretien régulier du logement', 'Entretien régulier du logement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 37.37, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 81, 6, 'Petite intervention sanitaire', 'Petite intervention sanitaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.06, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 97, 8, 'Aide administrative simple', 'Aide administrative simple. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 46.80, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 102, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 28.91, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 88, 3, 'Taille de haies', 'Taille de haies. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 33.51, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 74, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 26.64, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 83, 2, 'Nettoyage après déménagement', 'Nettoyage après déménagement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 35.93, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 78, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.03, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 98, 4, 'Baby-sitting après l’école', 'Baby-sitting après l’école. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 23.88, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 88, 1, 'Fixation d’étagères murales', 'Fixation d’étagères murales. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 32.25, 'Ixelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 102, 6, 'Petite intervention sanitaire', 'Petite intervention sanitaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 26.07, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 89, 8, 'Petits services quotidiens', 'Petits services quotidiens. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 20.94, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 89, 3, 'Entretien complet du jardin', 'Entretien complet du jardin. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 31.36, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 77, 6, 'Petite intervention sanitaire', 'Petite intervention sanitaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 26.35, 'Uccle', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 96, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 47.71, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 95, 3, 'Nettoyage de terrasse', 'Nettoyage de terrasse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.89, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 106, 5, 'Installation ordinateur et imprimante', 'Installation ordinateur et imprimante. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 45.36, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 82, 8, 'Aide administrative simple', 'Aide administrative simple. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 30.23, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 106, 2, 'Nettoyage de vitres', 'Nettoyage de vitres. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.42, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 96, 8, 'Aide administrative simple', 'Aide administrative simple. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 47.05, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 78, 3, 'Taille de haies', 'Taille de haies. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 38.61, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 102, 4, 'Garde ponctuelle le week-end', 'Garde ponctuelle le week-end. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.09, 'Ixelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 90, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.06, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 88, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.70, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 82, 1, 'Petits travaux de réparation', 'Petits travaux de réparation. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 36.01, 'Schaerbeek', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 96, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 35.86, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 84, 3, 'Entretien complet du jardin', 'Entretien complet du jardin. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 27.13, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 77, 5, 'Dépannage informatique à domicile', 'Dépannage informatique à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 35.51, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 107, 8, 'Petits services quotidiens', 'Petits services quotidiens. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.91, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 79, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 26.21, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 111, 1, 'Fixation d’étagères murales', 'Fixation d’étagères murales. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 18.96, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 108, 2, 'Nettoyage après déménagement', 'Nettoyage après déménagement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.05, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 77, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 28.99, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 95, 7, 'Installation de luminaire', 'Installation de luminaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 53.35, 'Etterbeek', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 77, 2, 'Entretien régulier du logement', 'Entretien régulier du logement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.24, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 107, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 20.01, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 93, 5, 'Aide à l’utilisation du PC', 'Aide à l’utilisation du PC. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 54.85, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 95, 6, 'Petite intervention sanitaire', 'Petite intervention sanitaire. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 22.12, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 80, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 38.58, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 72, 1, 'Montage de meuble à domicile', 'Montage de meuble à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 43.46, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 80, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.33, 'Forest', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 77, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 32.56, 'Schaerbeek', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 103, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 52.63, 'Uccle', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 89, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 46.91, 'Etterbeek', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 109, 2, 'Nettoyage de vitres', 'Nettoyage de vitres. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.10, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 80, 5, 'Dépannage informatique à domicile', 'Dépannage informatique à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 22.45, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 89, 4, 'Garde d’enfants en soirée', 'Garde d’enfants en soirée. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 52.72, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 97, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.07, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 98, 2, 'Nettoyage après déménagement', 'Nettoyage après déménagement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 41.49, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 79, 1, 'Petits travaux de réparation', 'Petits travaux de réparation. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.17, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 105, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 48.62, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 73, 2, 'Nettoyage de vitres', 'Nettoyage de vitres. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 51.20, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 91, 3, 'Taille de haies', 'Taille de haies. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 41.39, 'Forest', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 90, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 36.82, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 82, 7, 'Remplacement interrupteur', 'Remplacement interrupteur. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 49.50, 'Uccle', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 96, 1, 'Petits travaux de réparation', 'Petits travaux de réparation. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 54.42, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 81, 2, 'Nettoyage de vitres', 'Nettoyage de vitres. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 52.23, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 83, 8, 'Aide administrative simple', 'Aide administrative simple. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 34.57, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 72, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 36.78, 'Uccle', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 91, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 32.59, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 72, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 25.16, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 92, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 28.17, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 111, 2, 'Nettoyage après déménagement', 'Nettoyage après déménagement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 33.22, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 92, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 23.19, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 91, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.85, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 110, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 45.58, 'Ixelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 82, 3, 'Entretien complet du jardin', 'Entretien complet du jardin. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.28, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 99, 3, 'Entretien complet du jardin', 'Entretien complet du jardin. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 53.95, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 83, 3, 'Nettoyage de terrasse', 'Nettoyage de terrasse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.27, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 74, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 25.37, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 93, 8, 'Aide aux courses', 'Aide aux courses. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.56, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 83, 4, 'Accompagnement enfant à domicile', 'Accompagnement enfant à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 54.72, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 91, 4, 'Garde ponctuelle le week-end', 'Garde ponctuelle le week-end. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 49.60, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 87, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 21.28, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 83, 2, 'Entretien régulier du logement', 'Entretien régulier du logement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 41.80, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 92, 4, 'Garde d’enfants en soirée', 'Garde d’enfants en soirée. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 41.87, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 89, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 27.50, 'Ixelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 79, 6, 'Réparation de robinet', 'Réparation de robinet. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 52.66, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 82, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 38.36, 'Etterbeek', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 96, 3, 'Tonte de pelouse', 'Tonte de pelouse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 50.06, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(106, 74, 4, 'Garde ponctuelle le week-end', 'Garde ponctuelle le week-end. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 42.08, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 91, 8, 'Accompagnement rendez-vous', 'Accompagnement rendez-vous. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 24.13, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 77, 1, 'Installation de tringles et rideaux', 'Installation de tringles et rideaux. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 39.90, 'Bruxelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 111, 6, 'Remplacement flexible douche', 'Remplacement flexible douche. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 30.95, 'Bruxelles', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 72, 3, 'Nettoyage de terrasse', 'Nettoyage de terrasse. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 31.66, 'Ixelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 77, 7, 'Petit dépannage électrique', 'Petit dépannage électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 37.96, 'Anderlecht', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 96, 4, 'Accompagnement enfant à domicile', 'Accompagnement enfant à domicile. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 25.09, 'Schaerbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(113, 77, 8, 'Accompagnement rendez-vous', 'Accompagnement rendez-vous. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 37.22, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(114, 86, 7, 'Pose de prise électrique', 'Pose de prise électrique. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 52.91, 'Bruxelles', 'suspendue', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(115, 80, 8, 'Petits services quotidiens', 'Petits services quotidiens. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 19.90, 'Uccle', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(116, 110, 4, 'Garde d’enfants en soirée', 'Garde d’enfants en soirée. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 53.57, 'Etterbeek', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(117, 97, 2, 'Nettoyage après déménagement', 'Nettoyage après déménagement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 36.74, 'Anderlecht', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(118, 80, 4, 'Garde d’enfants en soirée', 'Garde d’enfants en soirée. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 23.48, 'Forest', 'publiee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(119, 84, 4, 'Garde ponctuelle le week-end', 'Garde ponctuelle le week-end. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 36.47, 'Ixelles', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(120, 111, 2, 'Nettoyage complet d’appartement', 'Nettoyage complet d’appartement. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.', 48.07, 'Uccle', 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(121, 72, 1, 'Montage de meuble rapide', 'Service de montage de meubles à domicile pour particuliers.', 30.00, 'Bruxelles', 'publiee', '2026-07-13 21:19:25', '2026-07-19 13:39:35'),
(122, 72, 5, 'ch', 'd', NULL, 'Anderlecht', 'supprimee', '2026-07-13 21:21:37', '2026-07-13 21:34:10'),
(123, 72, 5, 'ANALYSTE FONCTION', 'Dakchi nadi', 158.00, 'Gent', 'publiee', '2026-07-13 21:35:11', '2026-07-19 13:39:47'),
(124, 72, 5, 'softawre', 'Creation de projet avec du typescript , ..', 33.00, 'bruxelles', 'publiee', '2026-07-22 12:28:11', '2026-07-22 15:25:16'),
(125, 72, 5, 'espionnage', 'Espionner ton partenaire....', 60.00, 'bruxelles', 'publiee', '2026-07-22 17:04:58', '2026-07-22 17:13:10'),
(126, 116, 7, 'Installation des panneaux solaires', 'Je suis un spécialiste dans l\'installation des panneaux solaires.', 50.00, 'bruxelles', 'publiee', '2026-07-24 12:48:04', '2026-07-24 13:39:27');

-- --------------------------------------------------------

--
-- Structure de la table `avis`
--

CREATE TABLE `avis` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `membre_id` bigint(20) UNSIGNED NOT NULL,
  `prestataire_id` bigint(20) UNSIGNED NOT NULL,
  `annonce_id` bigint(20) UNSIGNED NOT NULL,
  `reservation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `note` tinyint(3) UNSIGNED NOT NULL,
  `commentaire` text DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `avis`
--

INSERT INTO `avis` (`id`, `membre_id`, `prestataire_id`, `annonce_id`, `reservation_id`, `note`, `commentaire`, `visible`, `created_at`, `updated_at`) VALUES
(1, 30, 82, 43, 72, 4, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 56, 102, 29, 61, 4, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 8, 91, 98, 11, 4, 'Prestataire ponctuel et travail bien réalisé.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 14, 77, 113, 22, 3, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 63, 91, 98, 1, 3, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 22, 89, 38, 118, 4, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 12, 86, 114, 88, 5, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 17, 78, 33, 14, 5, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 65, 102, 29, 4, 3, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 7, 91, 78, 92, 4, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 34, 77, 60, 95, 3, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 7, 103, 68, 23, 3, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 67, 102, 29, 25, 4, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 26, 82, 50, 28, 3, 'Prestataire ponctuel et travail bien réalisé.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 57, 96, 105, 35, 5, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 55, 87, 10, 96, 3, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 40, 82, 43, 59, 3, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 11, 80, 71, 60, 5, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 61, 82, 80, 57, 5, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 53, 88, 49, 70, 4, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 47, 99, 15, 30, 4, 'Prestataire ponctuel et travail bien réalisé.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 61, 89, 37, 67, 3, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 57, 77, 108, 104, 4, 'Intervention correcte et professionnelle.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 54, 103, 68, 98, 4, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 39, 72, 5, 69, 3, 'Prestataire ponctuel et travail bien réalisé.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 45, 92, 89, 112, 4, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 66, 89, 69, 18, 3, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 46, 78, 33, 74, 3, 'Prestataire ponctuel et travail bien réalisé.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 31, 102, 24, 20, 4, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 26, 77, 113, 27, 5, 'Je recommande ce prestataire pour ce type de service.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 19, 91, 98, 79, 4, 'Bonne communication et résultat conforme à la demande.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 27, 77, 113, 38, 3, 'Service sérieux et intervention rapide.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 69, 77, 111, 51, 3, 'Prestataire ponctuel et travail bien réalisé.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 112, 72, 124, 125, 4, 'Informaticien très professionnel, je le recommande vivement.', 1, '2026-07-22 22:39:44', '2026-07-22 22:39:44'),
(102, 116, 72, 123, 126, 5, 'top', 1, '2026-07-24 12:37:01', '2026-07-24 13:23:43');

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `nom`, `description`, `active`, `created_at`, `updated_at`) VALUES
(1, 'Bricolage', 'Petits travaux, montage de meubles, réparations et fixations.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 'Nettoyage', 'Nettoyage à domicile, entretien régulier et nettoyage ponctuel.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 'Jardinage', 'Tonte, taille de haies, entretien de jardin et plantations.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 'Baby-sitting', 'Garde d’enfants à domicile et aide ponctuelle aux familles.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 'Informatique', 'Aide informatique, installation, dépannage et configuration.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 'Plomberie', 'Petites réparations, robinetterie et interventions sanitaires.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 'Électricité', 'Installation de luminaires, prises, interrupteurs et petits dépannages.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 'Aide à domicile', 'Aide quotidienne, accompagnement et petits services à la personne.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 'Danse', 'Une catégorie  pour les danseurs professionnel', 1, '2026-07-24 17:51:47', '2026-07-24 17:51:47');

-- --------------------------------------------------------

--
-- Structure de la table `demande_categories`
--

CREATE TABLE `demande_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `prestataire_id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `statut` enum('en_attente','acceptee','refusee') NOT NULL DEFAULT 'en_attente',
  `categorie_id` bigint(20) UNSIGNED DEFAULT NULL,
  `motif_refus` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `demande_categories`
--

INSERT INTO `demande_categories` (`id`, `prestataire_id`, `nom`, `description`, `statut`, `categorie_id`, `motif_refus`, `created_at`, `updated_at`) VALUES
(1, 116, 'Danse', 'Une catégorie  pour les danseurs professionnel', 'acceptee', 10, NULL, '2026-07-24 17:50:21', '2026-07-24 17:51:47');

-- --------------------------------------------------------

--
-- Structure de la table `disponibilites`
--

CREATE TABLE `disponibilites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `annonce_id` bigint(20) UNSIGNED NOT NULL,
  `date_debut` datetime NOT NULL,
  `date_fin` datetime NOT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `disponibilites`
--

INSERT INTO `disponibilites` (`id`, `annonce_id`, `date_debut`, `date_fin`, `disponible`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-06-09 02:18:12', '2026-06-09 04:18:12', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 1, '2026-06-26 01:07:02', '2026-06-26 03:07:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 2, '2026-06-26 21:28:09', '2026-06-26 23:28:09', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 2, '2026-06-12 13:44:09', '2026-06-12 15:44:09', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 3, '2026-06-25 11:15:34', '2026-06-25 13:15:34', 0, '2026-05-16 17:10:05', '2026-07-17 23:45:51'),
(6, 3, '2026-06-02 15:21:15', '2026-06-02 17:21:15', 0, '2026-05-16 17:10:05', '2026-07-17 21:26:34'),
(7, 4, '2026-06-12 19:52:04', '2026-06-12 21:52:04', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 4, '2026-05-23 20:04:49', '2026-05-23 22:04:49', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 5, '2026-06-24 21:32:07', '2026-06-24 23:32:07', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 5, '2026-05-18 08:00:16', '2026-05-18 10:00:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 6, '2026-06-05 00:25:41', '2026-06-05 02:25:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 6, '2026-06-24 09:18:53', '2026-06-24 11:18:53', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 7, '2026-06-12 09:07:32', '2026-06-12 11:07:32', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 7, '2026-05-28 00:29:39', '2026-05-28 02:29:39', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 8, '2026-06-18 13:23:54', '2026-06-18 15:23:54', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 8, '2026-05-26 23:35:00', '2026-05-27 01:35:00', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 9, '2026-06-29 08:17:10', '2026-06-29 10:17:10', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 9, '2026-06-23 23:49:02', '2026-06-24 01:49:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 10, '2026-06-05 02:50:01', '2026-06-05 04:50:01', 0, '2026-05-16 17:10:05', '2026-07-24 12:42:09'),
(20, 10, '2026-06-17 18:56:11', '2026-06-17 20:56:11', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 11, '2026-06-04 18:30:49', '2026-06-04 20:30:49', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 11, '2026-05-20 20:00:22', '2026-05-20 22:00:22', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 12, '2026-05-23 04:38:14', '2026-05-23 06:38:14', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 12, '2026-05-22 07:10:05', '2026-05-22 09:10:05', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 13, '2026-05-24 03:02:20', '2026-05-24 05:02:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 13, '2026-05-20 12:55:43', '2026-05-20 14:55:43', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 14, '2026-06-03 00:20:56', '2026-06-03 02:20:56', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 14, '2026-06-29 22:31:04', '2026-06-30 00:31:04', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 15, '2026-06-02 05:06:52', '2026-06-02 07:06:52', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 15, '2026-06-21 18:34:27', '2026-06-21 20:34:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 16, '2026-06-07 20:45:26', '2026-06-07 22:45:26', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 16, '2026-05-26 17:42:52', '2026-05-26 19:42:52', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 17, '2026-06-11 14:23:37', '2026-06-11 16:23:37', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 17, '2026-06-26 23:42:18', '2026-06-27 01:42:18', 0, '2026-05-16 17:10:05', '2026-07-17 23:50:53'),
(35, 18, '2026-06-27 08:46:41', '2026-06-27 10:46:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 18, '2026-05-24 06:32:10', '2026-05-24 08:32:10', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 19, '2026-06-19 08:50:46', '2026-06-19 10:50:46', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 19, '2026-05-19 23:03:40', '2026-05-20 01:03:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 20, '2026-06-19 16:25:45', '2026-06-19 18:25:45', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 20, '2026-06-07 21:30:06', '2026-06-07 23:30:06', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 21, '2026-06-29 14:09:37', '2026-06-29 16:09:37', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 21, '2026-06-11 02:18:49', '2026-06-11 04:18:49', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 22, '2026-06-28 23:05:39', '2026-06-29 01:05:39', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 22, '2026-06-08 03:03:11', '2026-06-08 05:03:11', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 23, '2026-05-19 07:31:55', '2026-05-19 09:31:55', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 23, '2026-05-18 16:29:18', '2026-05-18 18:29:18', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 24, '2026-06-25 08:24:57', '2026-06-25 10:24:57', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 24, '2026-06-29 13:24:40', '2026-06-29 15:24:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 25, '2026-06-30 13:47:25', '2026-06-30 15:47:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 25, '2026-06-22 22:44:49', '2026-06-23 00:44:49', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 26, '2026-06-29 10:10:00', '2026-06-29 12:10:00', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 26, '2026-05-29 12:46:55', '2026-05-29 14:46:55', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 27, '2026-05-28 17:36:29', '2026-05-28 19:36:29', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 27, '2026-06-11 18:43:32', '2026-06-11 20:43:32', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 28, '2026-05-27 01:39:36', '2026-05-27 03:39:36', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 28, '2026-06-08 01:56:51', '2026-06-08 03:56:51', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 29, '2026-05-26 19:07:00', '2026-05-26 21:07:00', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 29, '2026-06-28 10:40:25', '2026-06-28 12:40:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 30, '2026-06-06 07:13:08', '2026-06-06 09:13:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 30, '2026-06-26 06:04:57', '2026-06-26 08:04:57', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 31, '2026-06-10 03:08:17', '2026-06-10 05:08:17', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 31, '2026-05-27 21:20:21', '2026-05-27 23:20:21', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 32, '2026-06-12 04:12:25', '2026-06-12 06:12:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 32, '2026-06-24 09:10:43', '2026-06-24 11:10:43', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 33, '2026-06-17 11:21:20', '2026-06-17 13:21:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 33, '2026-06-12 23:09:50', '2026-06-13 01:09:50', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 34, '2026-05-18 12:22:13', '2026-05-18 14:22:13', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 34, '2026-06-18 00:30:39', '2026-06-18 02:30:39', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 35, '2026-05-26 16:06:45', '2026-05-26 18:06:45', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 35, '2026-05-29 17:21:12', '2026-05-29 19:21:12', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 36, '2026-06-14 03:49:19', '2026-06-14 05:49:19', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 36, '2026-06-03 02:47:41', '2026-06-03 04:47:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 37, '2026-06-29 01:18:42', '2026-06-29 03:18:42', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 37, '2026-05-24 19:28:16', '2026-05-24 21:28:16', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 38, '2026-06-11 20:20:00', '2026-06-11 22:20:00', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 38, '2026-06-01 07:22:23', '2026-06-01 09:22:23', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 39, '2026-06-21 19:33:16', '2026-06-21 21:33:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 39, '2026-05-18 00:04:26', '2026-05-18 02:04:26', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 40, '2026-06-07 10:28:41', '2026-06-07 12:28:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 40, '2026-06-16 15:28:28', '2026-06-16 17:28:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 41, '2026-06-01 21:03:18', '2026-06-01 23:03:18', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 41, '2026-06-08 12:43:04', '2026-06-08 14:43:04', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 42, '2026-06-12 07:33:30', '2026-06-12 09:33:30', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 42, '2026-05-22 02:50:44', '2026-05-22 04:50:44', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 43, '2026-06-23 08:54:44', '2026-06-23 10:54:44', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 43, '2026-06-05 00:03:54', '2026-06-05 02:03:54', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 44, '2026-05-30 02:12:03', '2026-05-30 04:12:03', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 44, '2026-06-23 21:55:44', '2026-06-23 23:55:44', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 45, '2026-06-18 09:36:19', '2026-06-18 11:36:19', 0, '2026-05-16 17:10:05', '2026-07-18 00:07:24'),
(90, 45, '2026-06-21 23:43:29', '2026-06-22 01:43:29', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 46, '2026-06-24 09:15:22', '2026-06-24 11:15:22', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 46, '2026-06-10 11:45:19', '2026-06-10 13:45:19', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 47, '2026-05-31 20:31:31', '2026-05-31 22:31:31', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 47, '2026-06-13 20:17:39', '2026-06-13 22:17:39', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 48, '2026-05-21 01:00:30', '2026-05-21 03:00:30', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 48, '2026-06-13 13:45:56', '2026-06-13 15:45:56', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 49, '2026-05-21 04:17:02', '2026-05-21 06:17:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 49, '2026-06-01 08:25:54', '2026-06-01 10:25:54', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 50, '2026-06-22 23:46:16', '2026-06-23 01:46:16', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 50, '2026-05-18 20:03:45', '2026-05-18 22:03:45', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 51, '2026-06-03 03:03:29', '2026-06-03 05:03:29', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 51, '2026-05-29 21:30:08', '2026-05-29 23:30:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 52, '2026-05-28 12:23:25', '2026-05-28 14:23:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 52, '2026-06-21 16:03:30', '2026-06-21 18:03:30', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 53, '2026-05-28 22:01:20', '2026-05-29 00:01:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(106, 53, '2026-06-10 14:53:14', '2026-06-10 16:53:14', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 54, '2026-06-28 00:26:49', '2026-06-28 02:26:49', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 54, '2026-05-18 07:25:04', '2026-05-18 09:25:04', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 55, '2026-05-24 19:15:33', '2026-05-24 21:15:33', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 55, '2026-06-15 22:06:57', '2026-06-16 00:06:57', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 56, '2026-06-10 23:28:26', '2026-06-11 01:28:26', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 56, '2026-06-13 06:46:42', '2026-06-13 08:46:42', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(113, 57, '2026-05-26 00:13:47', '2026-05-26 02:13:47', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(114, 57, '2026-05-20 18:10:08', '2026-05-20 20:10:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(115, 58, '2026-06-04 04:10:29', '2026-06-04 06:10:29', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(116, 58, '2026-06-07 23:24:12', '2026-06-08 01:24:12', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(117, 59, '2026-06-29 02:09:53', '2026-06-29 04:09:53', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(118, 59, '2026-06-06 16:58:00', '2026-06-06 18:58:00', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(119, 60, '2026-06-16 20:27:25', '2026-06-16 22:27:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(120, 60, '2026-06-01 19:36:28', '2026-06-01 21:36:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(121, 61, '2026-06-25 06:29:16', '2026-06-25 08:29:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(122, 61, '2026-06-25 00:49:28', '2026-06-25 02:49:28', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(123, 62, '2026-06-10 21:24:43', '2026-06-10 23:24:43', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(124, 62, '2026-05-20 05:50:23', '2026-05-20 07:50:23', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(125, 63, '2026-05-31 19:31:10', '2026-05-31 21:31:10', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(126, 63, '2026-06-13 00:57:25', '2026-06-13 02:57:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(127, 64, '2026-05-27 09:26:22', '2026-05-27 11:26:22', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(128, 64, '2026-06-14 05:31:41', '2026-06-14 07:31:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(129, 65, '2026-06-26 01:44:52', '2026-06-26 03:44:52', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(130, 65, '2026-06-08 00:54:44', '2026-06-08 02:54:44', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(131, 66, '2026-05-29 04:35:54', '2026-05-29 06:35:54', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(132, 66, '2026-06-20 17:27:35', '2026-06-20 19:27:35', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(133, 67, '2026-06-14 20:13:28', '2026-06-14 22:13:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(134, 67, '2026-06-25 23:40:34', '2026-06-26 01:40:34', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(135, 68, '2026-06-25 23:39:34', '2026-06-26 01:39:34', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(136, 68, '2026-06-29 19:10:13', '2026-06-29 21:10:13', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(137, 69, '2026-05-26 08:50:30', '2026-05-26 10:50:30', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(138, 69, '2026-05-25 19:27:10', '2026-05-25 21:27:10', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(139, 70, '2026-06-30 05:00:00', '2026-06-30 07:00:00', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(140, 70, '2026-06-25 14:33:29', '2026-06-25 16:33:29', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(141, 71, '2026-06-27 13:44:11', '2026-06-27 15:44:11', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(142, 71, '2026-06-03 20:18:40', '2026-06-03 22:18:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(143, 72, '2026-06-07 19:10:16', '2026-06-07 21:10:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(144, 72, '2026-06-24 12:25:50', '2026-06-24 14:25:50', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(145, 73, '2026-06-23 08:41:00', '2026-06-23 10:41:00', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(146, 73, '2026-06-24 19:51:04', '2026-06-24 21:51:04', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(147, 74, '2026-05-19 23:29:08', '2026-05-20 01:29:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(148, 74, '2026-06-29 05:27:10', '2026-06-29 07:27:10', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(149, 75, '2026-06-28 10:05:21', '2026-06-28 12:05:21', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(150, 75, '2026-05-18 12:53:20', '2026-05-18 14:53:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(151, 76, '2026-06-15 14:02:27', '2026-06-15 16:02:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(152, 76, '2026-06-30 17:05:02', '2026-06-30 19:05:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(153, 77, '2026-06-22 00:54:28', '2026-06-22 02:54:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(154, 77, '2026-06-22 00:22:51', '2026-06-22 02:22:51', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(155, 78, '2026-05-17 23:10:03', '2026-05-18 01:10:03', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(156, 78, '2026-05-29 04:30:40', '2026-05-29 06:30:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(157, 79, '2026-06-21 10:16:27', '2026-06-21 12:16:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(158, 79, '2026-06-28 14:12:24', '2026-06-28 16:12:24', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(159, 80, '2026-06-23 15:48:05', '2026-06-23 17:48:05', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(160, 80, '2026-06-15 21:15:27', '2026-06-15 23:15:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(161, 81, '2026-06-23 10:29:51', '2026-06-23 12:29:51', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(162, 81, '2026-05-20 12:38:16', '2026-05-20 14:38:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(163, 82, '2026-06-01 22:25:16', '2026-06-02 00:25:16', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(164, 82, '2026-05-27 07:05:02', '2026-05-27 09:05:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(165, 83, '2026-06-29 20:02:15', '2026-06-29 22:02:15', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(166, 83, '2026-05-25 01:46:57', '2026-05-25 03:46:57', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(167, 84, '2026-06-29 10:24:22', '2026-06-29 12:24:22', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(168, 84, '2026-05-23 06:26:01', '2026-05-23 08:26:01', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(169, 85, '2026-05-20 18:00:20', '2026-05-20 20:00:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(170, 85, '2026-05-19 10:02:23', '2026-05-19 12:02:23', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(171, 86, '2026-05-18 07:49:23', '2026-05-18 09:49:23', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(172, 86, '2026-05-26 01:59:37', '2026-05-26 03:59:37', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(173, 87, '2026-06-21 21:25:56', '2026-06-21 23:25:56', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(174, 87, '2026-06-10 11:48:36', '2026-06-10 13:48:36', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(175, 88, '2026-06-18 17:48:18', '2026-06-18 19:48:18', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(176, 88, '2026-06-01 13:21:11', '2026-06-01 15:21:11', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(177, 89, '2026-06-05 18:26:10', '2026-06-05 20:26:10', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(178, 89, '2026-06-17 17:26:53', '2026-06-17 19:26:53', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(179, 90, '2026-05-28 19:46:45', '2026-05-28 21:46:45', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(180, 90, '2026-05-20 17:38:41', '2026-05-20 19:38:41', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(181, 91, '2026-06-11 17:44:12', '2026-06-11 19:44:12', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(182, 91, '2026-06-12 13:54:40', '2026-06-12 15:54:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(183, 92, '2026-06-17 18:22:56', '2026-06-17 20:22:56', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(184, 92, '2026-06-20 18:46:47', '2026-06-20 20:46:47', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(185, 93, '2026-05-18 10:54:49', '2026-05-18 12:54:49', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(186, 93, '2026-06-08 03:10:33', '2026-06-08 05:10:33', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(187, 94, '2026-05-21 09:32:50', '2026-05-21 11:32:50', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(188, 94, '2026-06-09 14:22:51', '2026-06-09 16:22:51', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(189, 95, '2026-06-07 07:52:33', '2026-06-07 09:52:33', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(190, 95, '2026-05-19 15:39:43', '2026-05-19 17:39:43', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(191, 96, '2026-05-19 14:57:33', '2026-05-19 16:57:33', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(192, 96, '2026-06-11 13:03:12', '2026-06-11 15:03:12', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(193, 97, '2026-06-25 13:52:13', '2026-06-25 15:52:13', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(194, 97, '2026-06-21 11:45:14', '2026-06-21 13:45:14', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(195, 98, '2026-05-21 08:44:05', '2026-05-21 10:44:05', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(196, 98, '2026-05-25 13:10:22', '2026-05-25 15:10:22', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(197, 99, '2026-05-20 12:39:46', '2026-05-20 14:39:46', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(198, 99, '2026-06-05 02:37:32', '2026-06-05 04:37:32', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(199, 100, '2026-06-30 11:07:34', '2026-06-30 13:07:34', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(200, 100, '2026-05-31 16:51:02', '2026-05-31 18:51:02', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(201, 101, '2026-05-22 18:43:05', '2026-05-22 20:43:05', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(202, 101, '2026-06-27 02:58:27', '2026-06-27 04:58:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(203, 102, '2026-05-24 12:25:24', '2026-05-24 14:25:24', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(204, 102, '2026-06-16 19:57:08', '2026-06-16 21:57:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(205, 103, '2026-06-15 03:25:40', '2026-06-15 05:25:40', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(206, 103, '2026-06-18 23:33:06', '2026-06-19 01:33:06', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(207, 104, '2026-06-18 00:39:23', '2026-06-18 02:39:23', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(208, 104, '2026-05-28 21:57:32', '2026-05-28 23:57:32', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(209, 105, '2026-06-29 09:13:11', '2026-06-29 11:13:11', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(210, 105, '2026-06-14 05:14:30', '2026-06-14 07:14:30', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(211, 106, '2026-06-13 21:06:17', '2026-06-13 23:06:17', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(212, 106, '2026-06-26 00:19:36', '2026-06-26 02:19:36', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(213, 107, '2026-06-11 09:39:48', '2026-06-11 11:39:48', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(214, 107, '2026-06-20 07:55:09', '2026-06-20 09:55:09', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(215, 108, '2026-06-27 19:40:21', '2026-06-27 21:40:21', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(216, 108, '2026-06-25 13:34:27', '2026-06-25 15:34:27', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(217, 109, '2026-05-20 02:02:29', '2026-05-20 04:02:29', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(218, 109, '2026-05-25 11:34:30', '2026-05-25 13:34:30', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(219, 110, '2026-06-06 09:09:46', '2026-06-06 11:09:46', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(220, 110, '2026-06-09 07:26:00', '2026-06-09 09:26:00', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(221, 111, '2026-06-09 12:52:58', '2026-06-09 14:52:58', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(222, 111, '2026-06-12 04:53:14', '2026-06-12 06:53:14', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(223, 112, '2026-06-07 00:43:55', '2026-06-07 02:43:55', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(224, 112, '2026-06-09 03:45:18', '2026-06-09 05:45:18', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(225, 113, '2026-06-23 05:35:03', '2026-06-23 07:35:03', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(226, 113, '2026-05-29 06:42:59', '2026-05-29 08:42:59', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(227, 114, '2026-06-11 17:10:03', '2026-06-11 19:10:03', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(228, 114, '2026-05-29 19:42:45', '2026-05-29 21:42:45', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(229, 115, '2026-05-17 23:20:42', '2026-05-18 01:20:42', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(230, 115, '2026-05-26 13:20:54', '2026-05-26 15:20:54', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(231, 116, '2026-06-03 12:23:20', '2026-06-03 14:23:20', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(232, 116, '2026-05-18 08:01:28', '2026-05-18 10:01:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(233, 117, '2026-05-25 23:27:07', '2026-05-26 01:27:07', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(234, 117, '2026-06-23 20:22:28', '2026-06-23 22:22:28', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(235, 118, '2026-06-22 10:58:25', '2026-06-22 12:58:25', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(236, 118, '2026-06-05 07:33:39', '2026-06-05 09:33:39', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(237, 119, '2026-06-18 21:54:48', '2026-06-18 23:54:48', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(238, 119, '2026-06-01 04:28:08', '2026-06-01 06:28:08', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(239, 120, '2026-06-13 08:27:47', '2026-06-13 10:27:47', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(240, 120, '2026-05-27 10:42:55', '2026-05-27 12:42:55', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(242, 124, '2026-07-23 16:28:00', '2026-07-26 16:28:00', 0, '2026-07-22 12:28:54', '2026-07-22 15:29:16'),
(243, 123, '2026-07-24 17:24:00', '2026-07-24 23:28:00', 0, '2026-07-24 12:25:22', '2026-07-24 12:33:29'),
(244, 126, '2026-07-25 09:00:00', '2026-07-25 18:00:00', 1, '2026-07-24 12:48:46', '2026-07-24 19:57:07'),
(245, 126, '2026-07-27 11:00:00', '2026-07-27 17:49:00', 0, '2026-07-24 12:49:24', '2026-07-24 13:25:54'),
(246, 123, '2026-07-25 16:28:00', '2026-07-26 19:29:00', 1, '2026-07-24 20:29:10', '2026-07-24 20:31:37'),
(247, 123, '2026-07-28 11:32:00', '2026-07-29 15:30:00', 0, '2026-07-24 20:33:13', '2026-07-24 20:33:13');

-- --------------------------------------------------------

--
-- Structure de la table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `likes`
--

CREATE TABLE `likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `membre_id` bigint(20) UNSIGNED NOT NULL,
  `annonce_id` bigint(20) UNSIGNED DEFAULT NULL,
  `prestataire_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type_cible` enum('annonce','prestataire') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `likes`
--

INSERT INTO `likes` (`id`, `membre_id`, `annonce_id`, `prestataire_id`, `type_cible`, `created_at`, `updated_at`) VALUES
(1, 52, 10, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 35, 110, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 41, 70, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 47, 82, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 39, 110, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 64, 96, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 31, 13, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 15, 99, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 15, 91, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 56, 25, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 51, 67, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 30, 99, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 19, 11, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 6, 85, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 21, 20, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 12, 31, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 12, 113, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 6, 84, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 30, 81, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 8, 70, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 63, 6, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 26, 17, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 5, 110, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 58, 71, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 13, 38, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 42, 17, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 22, 18, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 17, 57, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 17, 75, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 63, 120, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 16, 114, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 35, 8, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 8, 23, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 15, 75, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 57, 47, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 38, 82, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 60, 60, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 66, 40, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 64, 57, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 31, 101, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 12, 101, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 71, 54, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 29, 118, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 23, 107, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 18, 58, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 44, 56, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 33, 53, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 14, 64, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 25, 71, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 30, 67, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 23, 22, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 31, 67, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 30, 96, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 43, 98, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 27, 62, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 3, 19, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 49, 28, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 23, 30, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 3, 9, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 17, 87, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 18, 112, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 41, 82, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 59, 77, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 48, 71, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 20, 6, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 56, 120, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 64, 70, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 63, 69, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 65, 54, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 15, 1, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 56, 92, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 51, 41, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 38, 68, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 58, 100, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 33, 84, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 69, 75, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 4, 67, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 42, 1, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 42, 23, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 37, 106, NULL, 'annonce', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 56, NULL, 75, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 7, NULL, 88, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 21, NULL, 85, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 69, NULL, 77, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 47, NULL, 103, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 21, NULL, 111, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 57, NULL, 77, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 64, NULL, 84, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 40, NULL, 106, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 23, NULL, 92, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 49, NULL, 80, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 19, NULL, 92, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 26, NULL, 100, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 45, NULL, 72, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 43, NULL, 82, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 63, NULL, 109, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 2, NULL, 83, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 59, NULL, 91, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 27, NULL, 90, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 18, NULL, 85, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 65, NULL, 84, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 3, NULL, 107, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 55, NULL, 108, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 27, NULL, 74, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 19, NULL, 94, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(106, 17, NULL, 101, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 10, NULL, 93, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 13, NULL, 74, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 7, NULL, 80, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 45, NULL, 81, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 41, NULL, 91, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 32, NULL, 94, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(113, 66, NULL, 108, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(114, 70, NULL, 74, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(115, 42, NULL, 107, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(116, 43, NULL, 109, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(117, 21, NULL, 105, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(118, 8, NULL, 86, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(119, 68, NULL, 109, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(120, 42, NULL, 74, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(121, 9, NULL, 85, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(122, 37, NULL, 82, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(123, 56, NULL, 94, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(124, 50, NULL, 73, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(125, 14, NULL, 91, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(126, 7, NULL, 87, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(127, 64, NULL, 94, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(128, 12, NULL, 73, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(129, 43, NULL, 72, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(130, 66, NULL, 90, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(131, 34, NULL, 85, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(132, 71, NULL, 82, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(133, 22, NULL, 88, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(134, 9, NULL, 75, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(135, 71, NULL, 111, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(136, 35, NULL, 107, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(137, 52, NULL, 73, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(138, 57, NULL, 88, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(139, 17, NULL, 80, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(140, 38, NULL, 88, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(141, 39, NULL, 73, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(142, 31, NULL, 82, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(143, 13, NULL, 76, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(144, 54, NULL, 102, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(145, 54, NULL, 85, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(146, 59, NULL, 104, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(147, 8, NULL, 97, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(148, 22, NULL, 75, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(149, 69, NULL, 92, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(150, 44, NULL, 81, 'prestataire', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(156, 112, NULL, 72, 'prestataire', '2026-07-22 15:29:38', '2026-07-22 15:29:38'),
(157, 112, 124, NULL, 'annonce', '2026-07-22 16:07:32', '2026-07-22 16:07:32');

-- --------------------------------------------------------

--
-- Structure de la table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expediteur_id` bigint(20) UNSIGNED NOT NULL,
  `destinataire_id` bigint(20) UNSIGNED NOT NULL,
  `reservation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `annonce_id` bigint(20) UNSIGNED DEFAULT NULL,
  `contenu` text NOT NULL,
  `lu` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `messages`
--

INSERT INTO `messages` (`id`, `expediteur_id`, `destinataire_id`, `reservation_id`, `annonce_id`, `contenu`, `lu`, `created_at`, `updated_at`) VALUES
(1, 89, 40, 71, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 7, 103, 23, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 66, 89, 18, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 27, 77, 38, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 89, 30, 105, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 83, 13, 106, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 17, 103, 32, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 86, 12, 88, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 6, 82, 39, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 96, 45, 110, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 72, 56, 93, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 98, 22, 34, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 38, 84, 10, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 102, 31, 20, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 91, 58, 119, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 15, 72, 111, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 57, 96, 35, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 38, 90, 84, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 19, 91, 79, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 69, 77, 51, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 91, 63, 1, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 53, 88, 70, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 56, 72, 93, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-07-22 12:20:38'),
(24, 93, 27, 101, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 89, 15, 63, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 82, 26, 28, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 89, 15, 63, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 8, 88, 78, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 57, 96, 35, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 59, 80, 102, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 89, 39, 87, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 9, 111, 19, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 56, 72, 93, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 34, 77, 95, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 102, 65, 4, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 13, 83, 106, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 70, 79, 85, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 59, 80, 102, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 37, 88, 44, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 89, 16, 2, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 20, 81, 99, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 102, 40, 15, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 30, 89, 105, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 72, 56, 93, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 37, 91, 29, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 91, 63, 1, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 74, 51, 55, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 4, 77, 26, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 29, 96, 9, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 82, 62, 45, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 16, 89, 2, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 68, 82, 46, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 91, 63, 1, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 40, 102, 15, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 93, 14, 68, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 72, 43, 117, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 79, 56, 86, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 72, 15, 111, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 46, 78, 74, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 3, 74, 94, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 91, 44, 115, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 91, 37, 29, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 43, 72, 117, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 72, 56, 73, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 91, 19, 79, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 45, 96, 110, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 58, 91, 119, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 107, 57, 21, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 79, 56, 86, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 77, 26, 27, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 40, 82, 59, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 22, 81, 8, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 59, 80, 102, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 82, 40, 59, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 99, 47, 30, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 82, 40, 59, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 58, 91, 119, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 47, 99, 30, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 17, 78, 14, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 77, 8, 42, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 52, 83, 109, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 35, 100, 89, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 83, 69, 37, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 89, 39, 87, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 56, 102, 61, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 84, 38, 10, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 89, 22, 118, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 81, 22, 8, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 88, 33, 24, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 89, 22, 118, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 26, 81, 48, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 37, 92, 13, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 99, 68, 33, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 72, 39, 69, NULL, 'Je vous propose un autre créneau si nécessaire.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 39, 89, 87, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 15, 89, 63, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 74, 3, 94, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 22, 81, 8, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 12, 81, 56, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 6, 82, 39, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 66, 89, 18, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 19, 91, 79, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 3, 74, 94, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 37, 91, 29, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 39, 72, 6, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-07-22 12:20:38'),
(106, 8, 77, 42, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 68, 99, 33, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 40, 89, 71, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 89, 13, 91, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 20, 81, 99, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 80, 59, 102, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 89, 13, 91, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(113, 29, 92, 49, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(114, 92, 45, 112, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(115, 89, 61, 67, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(116, 92, 52, 43, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(117, 89, 10, 64, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(118, 45, 92, 112, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(119, 58, 91, 119, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(120, 11, 80, 60, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(121, 51, 83, 66, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(122, 103, 17, 32, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(123, 82, 26, 28, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(124, 16, 89, 2, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(125, 15, 72, 111, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-07-22 12:20:38'),
(126, 73, 57, 47, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(127, 82, 61, 57, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(128, 102, 44, 81, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(129, 78, 46, 74, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(130, 37, 91, 29, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(131, 81, 22, 8, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(132, 81, 26, 48, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(133, 57, 77, 104, NULL, 'Je vous propose un autre créneau si nécessaire.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(134, 91, 8, 11, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(135, 12, 86, 88, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(136, 111, 9, 113, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(137, 83, 52, 109, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(138, 77, 57, 104, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(139, 111, 9, 19, NULL, 'Merci pour votre retour, cela me convient.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(140, 26, 111, 103, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(141, 31, 102, 20, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(142, 107, 57, 21, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(143, 89, 61, 67, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(144, 30, 82, 72, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(145, 44, 96, 31, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(146, 103, 54, 98, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(147, 44, 96, 31, NULL, 'Je vous confirme ma disponibilité pour cette intervention.', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(148, 102, 40, 15, NULL, 'Bonjour, pouvez-vous me confirmer le créneau prévu ?', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(149, 82, 55, 16, NULL, 'Merci pour votre retour, cela me convient.', 1, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(150, 82, 62, 45, NULL, 'Pouvez-vous préciser l’adresse exacte de l’intervention ?', 0, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(151, 2, 104, NULL, NULL, 'salut', 0, '2026-07-13 18:12:32', '2026-07-13 18:12:32'),
(152, 112, 72, NULL, NULL, 'est ce que vous etes disponible aujourd hui ?', 1, '2026-07-22 11:35:19', '2026-07-22 12:20:38'),
(153, 112, 72, NULL, NULL, 'est ce que vous etes disponible aujourd hui ?', 1, '2026-07-22 11:35:20', '2026-07-22 12:20:38'),
(154, 112, 72, NULL, NULL, 'merci de bien vouloir me repondre', 1, '2026-07-22 11:35:54', '2026-07-22 12:20:38'),
(155, 112, 72, NULL, NULL, 'salut je n ai tjrs pas reçu un retour de votre part ?', 1, '2026-07-22 12:23:32', '2026-07-22 12:25:35'),
(156, 112, 72, NULL, NULL, 'Alors !!', 1, '2026-07-22 13:09:49', '2026-07-22 13:21:53'),
(157, 112, 72, NULL, NULL, '???', 1, '2026-07-22 13:12:33', '2026-07-22 13:21:53'),
(158, 112, 72, NULL, NULL, '...', 1, '2026-07-22 13:21:22', '2026-07-22 13:21:53'),
(159, 112, 72, NULL, NULL, 'hey again', 1, '2026-07-22 17:11:42', '2026-07-22 19:31:42'),
(160, 112, 89, NULL, 1, 'Bonsoir , vous prévoyez ajouter un créneau pour ce Samedi ? Merci', 0, '2026-07-22 19:15:46', '2026-07-22 19:15:46'),
(161, 112, 89, NULL, 1, 'Ou meme Dimanche ?', 0, '2026-07-22 19:16:21', '2026-07-22 19:16:21'),
(162, 112, 72, NULL, 125, 'je n ai tjrs pas reçu un retour !', 1, '2026-07-22 19:31:05', '2026-07-22 19:31:42'),
(163, 1, 115, NULL, NULL, 'Bonjour Monsieur Zaaza,\nVous ete sle bienvenue', 1, '2026-07-23 23:02:12', '2026-07-23 23:03:16'),
(164, 116, 72, NULL, 123, 'je veux savoir vos disponibilités. Merci', 1, '2026-07-24 12:16:18', '2026-07-24 12:17:48'),
(165, 1, 116, NULL, NULL, 'Welcome!', 1, '2026-07-24 12:44:12', '2026-07-24 12:45:16'),
(166, 116, 72, NULL, 123, 'Les disponibiltés sont publiées, veuillez choisir une!\nBàv', 1, '2026-07-24 15:51:11', '2026-07-24 19:55:44');

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2026_05_16_184006_create_categories_table', 1),
(6, '2026_05_16_184040_create_annonces_table', 1),
(7, '2026_05_16_184054_create_disponibilites_table', 1),
(8, '2026_05_16_184108_create_reservations_table', 1),
(9, '2026_05_16_184118_create_messages_table', 1),
(10, '2026_05_16_184142_create_avis_table', 1),
(11, '2026_05_16_184153_create_likes_table', 1),
(12, '2026_05_16_184210_create_paiements_table', 1),
(13, '2026_07_17_222035_add_expires_at_to_personal_access_tokens_table', 2),
(14, '2026_07_19_234641_clean_duplicate_avis_and_add_unique_constraint', 3),
(15, '2026_07_22_144615_create_user_notifications_table', 4),
(16, '2026_07_22_210703_add_annonce_id_to_messages_table', 5),
(17, '2026_07_23_150749_add_photo_profil_to_users_table', 6),
(18, '2026_07_23_184011_add_demande_prestataire_fields_to_users_table', 7),
(19, '2026_07_24_191410_create_demande_categories_table', 8),
(20, '2026_07_24_221228_add_alternative_fields_to_reservations_table', 9);

-- --------------------------------------------------------

--
-- Structure de la table `paiements`
--

CREATE TABLE `paiements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reservation_id` bigint(20) UNSIGNED NOT NULL,
  `membre_id` bigint(20) UNSIGNED NOT NULL,
  `montant` decimal(10,2) NOT NULL,
  `devise` varchar(10) NOT NULL DEFAULT 'EUR',
  `methode` enum('stripe','paypal','virement_bancaire') NOT NULL,
  `statut` enum('en_attente','accepte','refuse','rembourse') NOT NULL DEFAULT 'en_attente',
  `transaction_externe_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `paiements`
--

INSERT INTO `paiements` (`id`, `reservation_id`, `membre_id`, `montant`, `devise`, `methode`, `statut`, `transaction_externe_id`, `created_at`, `updated_at`) VALUES
(1, 1, 63, 49.60, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-0686YU85', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 2, 16, 48.67, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-8053XK75', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 3, 43, 28.97, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-4462FT76', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 4, 65, 28.91, 'EUR', 'stripe', 'accepte', 'TX-SC-1339DD89', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 5, 13, 52.91, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-4494BW33', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 6, 39, 48.53, 'EUR', 'paypal', 'en_attente', 'TX-SC-9003KO46', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 7, 32, 32.59, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-0060HL27', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 8, 22, 22.02, 'EUR', 'stripe', 'rembourse', 'TX-SC-2463KD07', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 9, 29, 50.06, 'EUR', 'stripe', 'refuse', 'TX-SC-8796IV45', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 10, 38, 36.47, 'EUR', 'paypal', 'refuse', 'TX-SC-3300WR76', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 11, 8, 49.60, 'EUR', 'stripe', 'refuse', 'TX-SC-0470TB35', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 12, 16, 43.46, 'EUR', 'paypal', 'refuse', 'TX-SC-1244OS52', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 13, 37, 23.19, 'EUR', 'paypal', 'accepte', 'TX-SC-1551DQ05', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 14, 17, 39.03, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-0602QJ89', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 15, 40, 39.09, 'EUR', 'paypal', 'accepte', 'TX-SC-9877UU39', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 16, 55, 30.23, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-4296NL70', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 17, 14, 54.42, 'EUR', 'stripe', 'rembourse', 'TX-SC-6516LT07', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 18, 66, 46.91, 'EUR', 'stripe', 'en_attente', 'TX-SC-1271ML24', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 19, 9, 48.07, 'EUR', 'paypal', 'accepte', 'TX-SC-1930DI62', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 20, 31, 28.97, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-5947EO48', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 21, 57, 20.01, 'EUR', 'paypal', 'refuse', 'TX-SC-9917BR20', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 22, 14, 37.22, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-9878OK98', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 23, 7, 52.63, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-6568JT49', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 24, 33, 24.70, 'EUR', 'stripe', 'refuse', 'TX-SC-3201WF02', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 25, 67, 28.91, 'EUR', 'stripe', 'accepte', 'TX-SC-4789FY64', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 26, 4, 26.35, 'EUR', 'stripe', 'en_attente', 'TX-SC-2825ON49', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 27, 26, 37.22, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-8278MR92', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 28, 26, 36.01, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-1752LG14', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 29, 37, 49.60, 'EUR', 'stripe', 'rembourse', 'TX-SC-9161LL13', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 30, 47, 46.13, 'EUR', 'paypal', 'refuse', 'TX-SC-8903JS13', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 31, 44, 47.05, 'EUR', 'paypal', 'rembourse', 'TX-SC-3807HT05', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 32, 17, 52.63, 'EUR', 'stripe', 'refuse', 'TX-SC-6471LW11', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 33, 68, 46.13, 'EUR', 'paypal', 'en_attente', 'TX-SC-8553YI43', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 34, 22, 41.49, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-3135CJ76', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 35, 57, 50.06, 'EUR', 'stripe', 'accepte', 'TX-SC-6581NK16', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 36, 42, 34.57, 'EUR', 'stripe', 'accepte', 'TX-SC-6790WD19', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 37, 69, 34.57, 'EUR', 'stripe', 'refuse', 'TX-SC-3038ZF48', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 38, 27, 37.22, 'EUR', 'paypal', 'rembourse', 'TX-SC-9000EP63', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 39, 6, 49.50, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-6948PJ84', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 40, 19, 47.05, 'EUR', 'stripe', 'accepte', 'TX-SC-7325JS19', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 41, 65, 48.71, 'EUR', 'stripe', 'accepte', 'TX-SC-9781UY30', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 42, 8, 19.24, 'EUR', 'paypal', 'refuse', 'TX-SC-2133PG42', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 43, 52, 23.19, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-7710EO67', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 44, 37, 24.70, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-5256UL13', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 45, 62, 30.23, 'EUR', 'stripe', 'accepte', 'TX-SC-8055AO57', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 46, 68, 49.50, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-0881VH25', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 47, 57, 51.20, 'EUR', 'stripe', 'rembourse', 'TX-SC-1538BL11', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 48, 26, 22.02, 'EUR', 'stripe', 'accepte', 'TX-SC-0852KN98', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 49, 29, 41.87, 'EUR', 'stripe', 'en_attente', 'TX-SC-9407GR57', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 50, 42, 51.20, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-5820AE56', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 51, 69, 37.96, 'EUR', 'stripe', 'en_attente', 'TX-SC-0921JR97', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 52, 59, 35.86, 'EUR', 'paypal', 'refuse', 'TX-SC-8889WK02', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 53, 69, 19.10, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-5423UW00', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 54, 46, 36.74, 'EUR', 'paypal', 'refuse', 'TX-SC-7239OM56', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 55, 51, 33.06, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-4355NQ00', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 56, 12, 19.06, 'EUR', 'stripe', 'accepte', 'TX-SC-0363HM03', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 57, 61, 49.50, 'EUR', 'stripe', 'accepte', 'TX-SC-7953VP97', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 58, 27, 46.91, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-9089KV40', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 59, 40, 30.23, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-6022HF06', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 60, 11, 22.45, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-3570EN49', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 61, 56, 28.91, 'EUR', 'stripe', 'en_attente', 'TX-SC-4951MM56', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 62, 24, 54.42, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-6905RQ46', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 63, 15, 20.94, 'EUR', 'stripe', 'en_attente', 'TX-SC-7556UG21', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 64, 10, 51.81, 'EUR', 'stripe', 'en_attente', 'TX-SC-6234NN05', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 65, 57, 27.50, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-7161NR75', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 66, 51, 34.57, 'EUR', 'paypal', 'rembourse', 'TX-SC-7722CW36', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 67, 61, 20.94, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-3578SQ68', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 68, 14, 54.85, 'EUR', 'paypal', 'rembourse', 'TX-SC-3212AI56', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 69, 39, 48.53, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-4520YM88', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 70, 53, 24.70, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-7124RA22', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 71, 40, 27.50, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-2658SW19', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 72, 30, 30.23, 'EUR', 'paypal', 'accepte', 'TX-SC-9079FI09', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 73, 56, 25.16, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-0638FE54', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 74, 46, 39.03, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-8266IR28', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 75, 10, 38.36, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-6200DI06', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 76, 39, 25.16, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-3096NN57', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 77, 60, 19.28, 'EUR', 'paypal', 'accepte', 'TX-SC-5865FR52', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 78, 8, 24.70, 'EUR', 'paypal', 'accepte', 'TX-SC-3473NL00', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 79, 19, 49.60, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-9098MG22', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 80, 15, 46.91, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-5727AG58', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 81, 44, 26.07, 'EUR', 'paypal', 'refuse', 'TX-SC-0823OH55', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 82, 33, 54.72, 'EUR', 'paypal', 'refuse', 'TX-SC-2983HC68', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 83, 15, 51.81, 'EUR', 'paypal', 'accepte', 'TX-SC-7167TE05', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 84, 38, 19.06, 'EUR', 'paypal', 'rembourse', 'TX-SC-3735MQ61', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 85, 70, 26.21, 'EUR', 'paypal', 'rembourse', 'TX-SC-7542LM33', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 86, 56, 50.17, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-1669WP77', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 87, 39, 20.94, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-1906ZY56', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 88, 12, 52.91, 'EUR', 'stripe', 'accepte', 'TX-SC-7566VX27', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 89, 35, 53.79, 'EUR', 'virement_bancaire', 'accepte', 'TX-SC-9919WD67', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 90, 24, 35.86, 'EUR', 'stripe', 'refuse', 'TX-SC-0959QW61', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 91, 13, 20.94, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-4002AC80', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 92, 7, 41.39, 'EUR', 'virement_bancaire', 'rembourse', 'TX-SC-0458FM54', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 93, 56, 43.46, 'EUR', 'stripe', 'accepte', 'TX-SC-0476IV43', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 94, 3, 33.06, 'EUR', 'stripe', 'rembourse', 'TX-SC-3190NA13', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 95, 34, 19.24, 'EUR', 'paypal', 'refuse', 'TX-SC-9889UP65', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 96, 55, 18.64, 'EUR', 'virement_bancaire', 'refuse', 'TX-SC-4478TQ16', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 97, 5, 52.66, 'EUR', 'paypal', 'en_attente', 'TX-SC-8243BI70', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 98, 54, 52.63, 'EUR', 'paypal', 'refuse', 'TX-SC-4677AD81', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 99, 20, 22.02, 'EUR', 'virement_bancaire', 'en_attente', 'TX-SC-6890VT82', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 100, 53, 34.57, 'EUR', 'stripe', 'rembourse', 'TX-SC-6502QJ43', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 121, 2, 22.02, 'EUR', 'stripe', 'en_attente', 'cs_test_a10MqepBo1nLNf2U7ayC6StaE0cqdbBG2icQGi4yBDZJrKhhs0peH0x1KI', '2026-07-17 22:25:36', '2026-07-17 23:46:27'),
(102, 124, 2, 47.05, 'EUR', 'stripe', 'accepte', 'pi_3TuNjyRCed1bADo81OAHOcFP', '2026-07-18 00:12:16', '2026-07-19 22:23:45'),
(103, 125, 112, 33.00, 'EUR', 'stripe', 'accepte', 'pi_3Tw426RCed1bADo805FhocSL', '2026-07-22 15:33:07', '2026-07-22 15:34:18'),
(104, 126, 116, 158.00, 'EUR', 'stripe', 'accepte', 'pi_3TwkC3RCed1bADo81VFeON0I', '2026-07-24 12:34:25', '2026-07-24 12:35:23'),
(105, 128, 72, 50.00, 'EUR', 'stripe', 'accepte', 'pi_3Twl4PRCed1bADo81R1Cg12S', '2026-07-24 13:27:40', '2026-07-24 13:31:34');

-- --------------------------------------------------------

--
-- Structure de la table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `expires_at`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'serviceconnect_token', 'cbc91bdb6720f210cd954adf83753b6fa8707551c1e6bc681054171c8b736ef6', '[\"*\"]', NULL, NULL, '2026-07-11 16:46:22', '2026-07-11 16:46:22'),
(2, 'App\\Models\\User', 2, 'serviceconnect_token', '9e0e28e75d06ce76f466db1e2b1c43509541e522c166785dd428e70b7158bc84', '[\"*\"]', NULL, '2026-07-11 17:30:10', '2026-07-11 16:48:06', '2026-07-11 17:30:10'),
(3, 'App\\Models\\User', 2, 'serviceconnect_token', 'c0449bcb1d123cee5307a78d144de693596b44d89176806b52f947cb6aa533a1', '[\"*\"]', NULL, '2026-07-11 17:35:31', '2026-07-11 17:32:41', '2026-07-11 17:35:31'),
(4, 'App\\Models\\User', 2, 'serviceconnect_token', '0bb2c5420d4db2a4f1d0a7759f031326a8be102fd4a7ef4faf17ec030b1ccdde', '[\"*\"]', NULL, NULL, '2026-07-13 14:57:02', '2026-07-13 14:57:02'),
(6, 'App\\Models\\User', 2, 'serviceconnect_token', '6c162e949d9b0e0d99ca2cec21e7978891205fbccb73f8d31289e7efac2111c1', '[\"*\"]', NULL, '2026-07-13 19:45:52', '2026-07-13 16:12:22', '2026-07-13 19:45:52'),
(10, 'App\\Models\\User', 2, 'serviceconnect_token', '87e913f6696d849dd6f865361c1c97bafa9f392ffbeacb72f3cccf45b3a61f26', '[\"*\"]', NULL, '2026-07-17 21:26:35', '2026-07-17 20:22:18', '2026-07-17 21:26:35'),
(87, 'App\\Models\\User', 1, 'serviceconnect_token', '2527f6c04b0e33432d0750f816e6f07da80cabd803b67a92bd293f72d39cf6b9', '[\"*\"]', NULL, '2026-07-24 17:52:18', '2026-07-24 17:51:22', '2026-07-24 17:52:18'),
(88, 'App\\Models\\User', 1, 'serviceconnect_token', '85a4eb446c6482051bacf1c18aba1c607447673f98e738f5fe998b23a8d0aa84', '[\"*\"]', NULL, '2026-07-24 19:39:10', '2026-07-24 18:45:33', '2026-07-24 19:39:10'),
(94, 'App\\Models\\User', 116, 'serviceconnect_token', '8e479c6845618bc6b82e59b11170a0e9d1f51bf3b814eef4ae482b21daaea845', '[\"*\"]', NULL, '2026-07-25 03:03:36', '2026-07-24 19:56:40', '2026-07-25 03:03:36'),
(95, 'App\\Models\\User', 72, 'serviceconnect_token', 'd69a04e7ef09ad1f45d83bb301e84c4d73807d1c1a1ce7090d38eacb2693e7b3', '[\"*\"]', NULL, '2026-07-24 20:45:26', '2026-07-24 20:00:46', '2026-07-24 20:45:26'),
(97, 'App\\Models\\User', 72, 'serviceconnect_token', 'db3707da173001355a34796142598be8a8b880974b5f45051bde6a0c1fb9e620', '[\"*\"]', NULL, '2026-07-26 23:41:50', '2026-07-26 16:45:47', '2026-07-26 23:41:50');

-- --------------------------------------------------------

--
-- Structure de la table `reservations`
--

CREATE TABLE `reservations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `membre_id` bigint(20) UNSIGNED NOT NULL,
  `annonce_id` bigint(20) UNSIGNED NOT NULL,
  `prestataire_id` bigint(20) UNSIGNED NOT NULL,
  `disponibilite_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date_demande` datetime NOT NULL,
  `date_service` datetime DEFAULT NULL,
  `date_alternative_debut` datetime DEFAULT NULL,
  `date_alternative_fin` datetime DEFAULT NULL,
  `message_demande` text DEFAULT NULL,
  `message_alternative` text DEFAULT NULL,
  `statut` enum('en_attente','acceptee','refusee','alternative_proposee','annulee','terminee') NOT NULL DEFAULT 'en_attente',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `reservations`
--

INSERT INTO `reservations` (`id`, `membre_id`, `annonce_id`, `prestataire_id`, `disponibilite_id`, `date_demande`, `date_service`, `date_alternative_debut`, `date_alternative_fin`, `message_demande`, `message_alternative`, `statut`, `created_at`, `updated_at`) VALUES
(1, 63, 98, 91, 195, '2026-04-21 01:36:49', '2026-05-21 08:44:05', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(2, 16, 7, 89, 13, '2026-04-26 16:26:43', '2026-06-12 09:07:32', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(3, 43, 24, 102, 47, '2026-05-12 12:07:53', '2026-06-25 08:24:57', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(4, 65, 29, 102, 57, '2026-05-09 15:52:56', '2026-05-26 19:07:00', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(5, 13, 114, 86, 228, '2026-04-21 11:09:47', '2026-05-29 19:42:45', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 39, 5, 72, 10, '2026-05-15 11:44:59', '2026-05-18 08:00:16', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 32, 85, 91, 170, '2026-04-21 23:13:01', '2026-05-19 10:02:23', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 22, 3, 81, 5, '2026-04-28 00:04:02', '2026-06-25 11:15:34', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 29, 105, 96, 210, '2026-05-11 10:43:15', '2026-06-14 05:14:30', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 38, 119, 84, 237, '2026-04-22 11:24:49', '2026-06-18 21:54:48', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 8, 98, 91, 195, '2026-04-22 20:51:38', '2026-05-21 08:44:05', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 16, 65, 72, 130, '2026-04-21 15:02:10', '2026-06-08 00:54:44', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-07-13 23:12:50'),
(13, 37, 89, 92, 177, '2026-05-01 08:49:08', '2026-06-05 18:26:10', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 17, 33, 78, 65, '2026-05-15 09:00:23', '2026-06-17 11:21:20', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 40, 47, 102, 94, '2026-04-25 12:31:41', '2026-06-13 20:17:39', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 55, 43, 82, 85, '2026-04-21 07:41:48', '2026-06-23 08:54:44', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 14, 81, 96, 162, '2026-04-17 07:05:36', '2026-05-20 12:38:16', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 66, 69, 89, 137, '2026-04-22 08:22:02', '2026-05-26 08:50:30', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 9, 120, 111, 239, '2026-05-16 06:00:53', '2026-06-13 08:27:47', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 31, 24, 102, 48, '2026-05-01 19:25:43', '2026-06-29 13:24:40', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 57, 61, 107, 121, '2026-05-04 14:52:18', '2026-06-25 06:29:16', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 14, 113, 77, 225, '2026-05-11 14:38:10', '2026-06-23 05:35:03', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 7, 68, 103, 135, '2026-05-11 23:03:18', '2026-06-25 23:39:34', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 33, 49, 88, 98, '2026-05-15 07:54:59', '2026-06-01 08:25:54', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 67, 29, 102, 58, '2026-04-28 13:50:02', '2026-06-28 10:40:25', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 4, 39, 77, 77, '2026-05-04 17:04:29', '2026-06-21 19:33:16', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 26, 113, 77, 226, '2026-05-05 09:57:13', '2026-05-29 06:42:59', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 26, 50, 82, 100, '2026-04-19 00:18:49', '2026-05-18 20:03:45', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 37, 98, 91, 196, '2026-05-15 12:48:54', '2026-05-25 13:10:22', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 47, 15, 99, 29, '2026-04-17 05:16:59', '2026-06-02 05:06:52', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 44, 45, 96, 89, '2026-05-07 03:01:01', '2026-06-18 09:36:19', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 17, 68, 103, 136, '2026-04-23 07:22:01', '2026-06-29 19:10:13', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 68, 15, 99, 30, '2026-05-03 14:25:33', '2026-06-21 18:34:27', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 22, 74, 98, 147, '2026-05-08 05:23:37', '2026-05-19 23:29:08', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 57, 105, 96, 210, '2026-04-27 21:49:48', '2026-06-14 05:14:30', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 42, 83, 83, 165, '2026-05-06 23:51:26', '2026-06-29 20:02:15', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 69, 83, 83, 166, '2026-04-27 00:10:03', '2026-05-25 01:46:57', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 27, 113, 77, 226, '2026-05-13 01:48:38', '2026-05-29 06:42:59', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 6, 80, 82, 159, '2026-04-29 20:11:49', '2026-06-23 15:48:05', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 19, 45, 96, 90, '2026-04-23 06:33:45', '2026-06-21 23:43:29', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 65, 2, 104, 3, '2026-04-26 12:53:35', '2026-06-26 21:28:09', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 8, 60, 77, 120, '2026-04-28 11:51:26', '2026-06-01 19:36:28', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 52, 89, 92, 177, '2026-04-24 21:32:17', '2026-06-05 18:26:10', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 37, 49, 88, 98, '2026-05-05 16:32:17', '2026-06-01 08:25:54', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 62, 43, 82, 86, '2026-05-03 07:49:44', '2026-06-05 00:03:54', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 68, 80, 82, 160, '2026-04-21 17:33:23', '2026-06-15 21:15:27', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 57, 77, 73, 153, '2026-04-28 13:49:26', '2026-06-22 00:54:28', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 26, 3, 81, 5, '2026-04-17 02:28:27', '2026-06-25 11:15:34', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 29, 101, 92, 202, '2026-04-29 19:40:40', '2026-06-27 02:58:27', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 42, 77, 73, 153, '2026-05-02 23:50:48', '2026-06-22 00:54:28', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 69, 111, 77, 222, '2026-04-27 13:44:43', '2026-06-12 04:53:14', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 59, 51, 96, 102, '2026-05-15 13:20:06', '2026-05-29 21:30:08', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 69, 70, 109, 139, '2026-05-06 11:25:25', '2026-06-30 05:00:00', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 46, 117, 97, 233, '2026-04-26 06:31:49', '2026-05-25 23:27:07', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 51, 11, 74, 21, '2026-05-03 03:19:16', '2026-06-04 18:30:49', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 12, 27, 81, 53, '2026-05-14 17:42:52', '2026-05-28 17:36:29', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 61, 80, 82, 160, '2026-04-24 05:20:07', '2026-06-15 21:15:27', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 27, 69, 89, 137, '2026-04-22 16:42:20', '2026-05-26 08:50:30', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 40, 43, 82, 86, '2026-05-06 12:22:57', '2026-06-05 00:03:54', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 11, 71, 80, 141, '2026-05-04 16:54:32', '2026-06-27 13:44:11', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 56, 29, 102, 58, '2026-04-23 10:50:21', '2026-06-28 10:40:25', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 24, 81, 96, 161, '2026-05-10 05:10:31', '2026-06-23 10:29:51', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 15, 37, 89, 73, '2026-05-11 05:39:22', '2026-06-29 01:18:42', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 10, 1, 89, 2, '2026-05-05 07:14:47', '2026-06-26 01:07:02', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 57, 102, 89, 203, '2026-04-19 08:34:26', '2026-05-24 12:25:24', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 51, 83, 83, 165, '2026-04-18 21:36:42', '2026-06-29 20:02:15', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 61, 37, 89, 74, '2026-05-12 08:35:02', '2026-05-24 19:28:16', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 14, 62, 93, 123, '2026-04-17 09:23:21', '2026-06-10 21:24:43', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 39, 5, 72, 9, '2026-04-21 10:52:36', '2026-06-24 21:32:07', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 53, 49, 88, 97, '2026-05-11 02:39:19', '2026-05-21 04:17:02', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 40, 102, 89, 203, '2026-04-20 07:54:08', '2026-05-24 12:25:24', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 30, 43, 82, 86, '2026-05-07 11:00:21', '2026-06-05 00:03:54', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(73, 56, 86, 72, 171, '2026-04-18 19:50:47', '2026-05-18 07:49:23', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 46, 33, 78, 65, '2026-05-07 13:53:17', '2026-06-17 11:21:20', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 10, 104, 82, 207, '2026-05-11 23:09:47', '2026-06-18 00:39:23', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 39, 86, 72, 172, '2026-05-15 10:06:08', '2026-05-26 01:59:37', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 60, 92, 82, 184, '2026-05-03 03:52:14', '2026-06-20 18:46:47', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 8, 49, 88, 97, '2026-04-18 02:52:30', '2026-05-21 04:17:02', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 19, 98, 91, 195, '2026-04-25 04:41:20', '2026-05-21 08:44:05', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 15, 69, 89, 137, '2026-05-15 19:16:13', '2026-05-26 08:50:30', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 44, 36, 102, 71, '2026-05-02 01:20:33', '2026-06-14 03:49:19', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(82, 33, 97, 83, 194, '2026-04-29 20:51:18', '2026-06-21 11:45:14', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 15, 1, 89, 1, '2026-04-28 21:50:40', '2026-06-09 02:18:12', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 38, 48, 90, 95, '2026-05-10 11:27:34', '2026-05-21 01:00:30', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 70, 55, 79, 109, '2026-04-30 22:30:09', '2026-05-24 19:15:33', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 56, 75, 79, 150, '2026-04-22 20:55:21', '2026-05-18 12:53:20', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 39, 37, 89, 73, '2026-05-08 10:32:25', '2026-06-29 01:18:42', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 12, 114, 86, 228, '2026-04-27 03:54:26', '2026-05-29 19:42:45', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 35, 8, 100, 16, '2026-04-29 18:38:55', '2026-05-26 23:35:00', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 24, 51, 96, 101, '2026-05-10 02:11:12', '2026-06-03 03:03:29', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 13, 37, 89, 74, '2026-05-08 12:32:06', '2026-05-24 19:28:16', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 7, 78, 91, 156, '2026-05-01 14:46:23', '2026-05-29 04:30:40', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 56, 65, 72, 129, '2026-04-18 17:55:58', '2026-06-26 01:44:52', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 3, 11, 74, 21, '2026-05-13 18:20:50', '2026-06-04 18:30:49', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 34, 60, 77, 120, '2026-05-14 03:56:11', '2026-06-01 19:36:28', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 55, 10, 87, 19, '2026-05-14 13:18:37', '2026-06-05 02:50:01', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(97, 5, 103, 79, 205, '2026-05-13 04:03:45', '2026-06-15 03:25:40', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 54, 68, 103, 135, '2026-05-12 11:34:20', '2026-06-25 23:39:34', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 20, 3, 81, 5, '2026-05-05 05:47:49', '2026-06-25 11:15:34', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 53, 83, 83, 165, '2026-05-12 15:19:31', '2026-06-29 20:02:15', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 27, 62, 93, 123, '2026-04-29 08:13:44', '2026-06-10 21:24:43', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 59, 66, 80, 132, '2026-05-11 19:53:45', '2026-06-20 17:27:35', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 26, 120, 111, 240, '2026-04-19 13:23:09', '2026-05-27 10:42:55', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 57, 108, 77, 216, '2026-05-13 07:19:09', '2026-06-25 13:34:27', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'acceptee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 30, 38, 89, 76, '2026-04-25 23:37:48', '2026-06-01 07:22:23', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(106, 13, 94, 83, 188, '2026-05-05 03:52:10', '2026-06-09 14:22:51', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 64, 40, 96, 80, '2026-05-14 02:44:53', '2026-06-16 15:28:28', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 10, 119, 84, 238, '2026-05-07 20:16:39', '2026-06-01 04:28:08', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 52, 100, 83, 199, '2026-04-29 08:53:35', '2026-06-30 11:07:34', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 45, 45, 96, 90, '2026-05-14 22:29:36', '2026-06-21 23:43:29', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 15, 110, 72, 219, '2026-05-15 23:16:55', '2026-06-06 09:09:46', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 45, 89, 92, 177, '2026-05-12 04:07:26', '2026-06-05 18:26:10', NULL, NULL, 'La demande concerne une intervention simple à Bruxelles.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(113, 9, 120, 111, 240, '2026-05-16 14:32:13', '2026-05-27 10:42:55', NULL, NULL, 'Bonjour, je souhaite réserver ce service pour le créneau indiqué.', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(114, 37, 7, 89, 14, '2026-04-23 21:56:25', '2026-05-28 00:29:39', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'en_attente', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(115, 44, 107, 91, 213, '2026-05-14 03:07:36', '2026-06-11 09:39:48', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(116, 30, 39, 77, 77, '2026-05-13 18:12:47', '2026-06-21 19:33:16', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'refusee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(117, 43, 18, 72, 35, '2026-05-06 12:33:05', '2026-06-27 08:46:41', NULL, NULL, 'Pouvez-vous confirmer votre disponibilité pour cette intervention ?', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(118, 22, 38, 89, 76, '2026-04-18 14:45:27', '2026-06-01 07:22:23', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'terminee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(119, 58, 107, 91, 214, '2026-05-04 00:41:44', '2026-06-20 07:55:09', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'alternative_proposee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(120, 41, 82, 81, 164, '2026-05-05 19:17:27', '2026-05-27 07:05:02', NULL, NULL, 'J’aurais besoin de ce service à domicile. Merci d’avance.', NULL, 'annulee', '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(121, 2, 3, 81, 6, '2026-07-17 23:26:34', '2026-06-02 15:21:15', NULL, NULL, NULL, NULL, 'acceptee', '2026-07-17 21:26:34', '2026-07-17 22:22:39'),
(122, 2, 3, 81, 5, '2026-07-18 01:45:51', '2026-06-25 11:15:34', NULL, NULL, NULL, NULL, 'en_attente', '2026-07-17 23:45:51', '2026-07-17 23:45:51'),
(123, 2, 17, 111, 34, '2026-07-18 01:50:53', '2026-06-26 23:42:18', NULL, NULL, NULL, NULL, 'en_attente', '2026-07-17 23:50:53', '2026-07-17 23:50:53'),
(124, 2, 45, 96, 89, '2026-07-18 02:07:24', '2026-06-18 09:36:19', NULL, NULL, NULL, NULL, 'acceptee', '2026-07-18 00:07:24', '2026-07-18 00:11:40'),
(125, 112, 124, 72, 242, '2026-07-22 17:29:16', '2026-07-23 16:28:00', NULL, NULL, NULL, NULL, 'terminee', '2026-07-22 15:29:16', '2026-07-24 12:32:09'),
(126, 116, 123, 72, 243, '2026-07-24 14:33:29', '2026-07-24 17:24:00', NULL, NULL, NULL, NULL, 'acceptee', '2026-07-24 12:33:29', '2026-07-24 12:34:09'),
(127, 72, 10, 87, 19, '2026-07-24 14:42:09', '2026-06-05 02:50:01', NULL, NULL, NULL, NULL, 'en_attente', '2026-07-24 12:42:09', '2026-07-24 12:42:09'),
(128, 72, 126, 116, 245, '2026-07-24 15:25:54', '2026-07-27 11:00:00', NULL, NULL, NULL, NULL, 'acceptee', '2026-07-24 13:25:54', '2026-07-24 13:26:53'),
(129, 72, 126, 116, 244, '2026-07-24 21:56:08', '2026-07-25 09:00:00', NULL, NULL, NULL, NULL, 'refusee', '2026-07-24 19:56:08', '2026-07-24 19:57:07'),
(130, 116, 123, 72, 247, '2026-07-24 22:29:40', '2026-07-28 11:32:00', '2026-07-28 11:32:00', '2026-07-29 15:30:00', NULL, 'desole j ai oublié de supprimé ce créneau du coup je vous propose un nouveau si ça vous arrange ! merci pr votre comprehension', 'acceptee', '2026-07-24 20:29:40', '2026-07-24 20:33:13');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  `role` enum('membre','prestataire','administrateur') NOT NULL DEFAULT 'membre',
  `statut` enum('actif','desactive','suspendu') NOT NULL DEFAULT 'actif',
  `langue` varchar(10) NOT NULL DEFAULT 'fr',
  `description_profil` text DEFAULT NULL,
  `photo_profil` varchar(255) DEFAULT NULL,
  `localisation` varchar(255) DEFAULT NULL,
  `paiement_active` tinyint(1) NOT NULL DEFAULT 0,
  `demande_prestataire_statut` enum('aucune','en_attente','acceptee','refusee') NOT NULL DEFAULT 'aucune',
  `demande_prestataire_description` text DEFAULT NULL,
  `demande_prestataire_localisation` varchar(255) DEFAULT NULL,
  `demande_prestataire_telephone` varchar(30) DEFAULT NULL,
  `demande_prestataire_date` timestamp NULL DEFAULT NULL,
  `demande_prestataire_decision_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `nom`, `prenom`, `email`, `email_verified_at`, `password`, `telephone`, `role`, `statut`, `langue`, `description_profil`, `photo_profil`, `localisation`, `paiement_active`, `demande_prestataire_statut`, `demande_prestataire_description`, `demande_prestataire_localisation`, `demande_prestataire_telephone`, `demande_prestataire_date`, `demande_prestataire_decision_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'ServiceConnect', 'admin@serviceconnect.be', NULL, '$2y$10$Mc.en5DyynrVldUiXIDqEOrhJm1OlshU33vuQnJcAP9aL/8J/Ctzm', '+32 470 11 22 33', 'administrateur', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-19 12:17:31'),
(2, 'Bogaert', 'Hamza', 'membre1@serviceconnect.test', NULL, '$2y$10$/WeTydkuIvjaelEsyHM2UO4rJ9CL/ggQ0n6Rq.LcsRKDOHjCBanL.', '+32487205620', 'prestataire', 'actif', 'fr', 'Prestatire spécialisé en informatique', NULL, 'Gent', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-19 13:27:32'),
(3, 'De Coster', 'Mohammed', 'membre2@serviceconnect.test', NULL, '$2y$10$nPT3w1Zq/Di1wzOY//CTm.zOGpkQwrLkmcx0jwkc2/fkTqk0N5VNW', '+32 412 25 28 12', 'membre', 'suspendu', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-17 23:07:03'),
(4, 'De Groote', 'Mathys', 'membre3@serviceconnect.test', NULL, '$2y$10$4qkSXpRfmsnR7oxshamTwuiOMp9u31mJS7VQXSVVegId12rekAF76', '+32 429 18 20 90', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-18 00:19:07'),
(5, 'Benali', 'Lucas', 'membre4@serviceconnect.test', NULL, '$2y$10$O0zpJ3r1JSI7rszPPHRQPebDKrYJJ6XYTdaFABP3anhxoXmuukbkG', '+32 413 25 09 03', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(6, 'Robert', 'Louise', 'membre5@serviceconnect.test', NULL, '$2y$10$kBrnKLRyH/uAxBUL.knWqOPCroHAV2c3HhR3EdQhD/4TlwqLkSCbS', '+32 484 27 09 59', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(7, 'Nguyen', 'Lana', 'membre6@serviceconnect.test', NULL, '$2y$10$RH9hfKHGW6KqqxScJVOt8OEU7/qYgfE30GTCUpvFqJMvQogkfrHAq', '+32 493 50 13 22', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(8, 'Cornelis', 'Romain', 'membre7@serviceconnect.test', NULL, '$2y$10$ioK5tozXZbkBNeJLuGhHzOptMarUOC4YXliV8ZuIrFfKkZM6gi5xe', '+32 472 21 93 39', 'membre', 'suspendu', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(9, 'Poncelet', 'Simon', 'membre8@serviceconnect.test', NULL, '$2y$10$N2yOPNeXvHAohePVrW2C3uYJvPT7.a.QH30VbWVRJQJm9yy.igbWC', '+32 406 48 85 18', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(10, 'Hubert', 'Finn', 'membre9@serviceconnect.test', NULL, '$2y$10$D5MknXZ4gnmNlG.gNJc8xOLw4CpkMddNK.W0BuPEPBsuKRdgMHZzK', '+32 424 02 09 81', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(11, 'Verstraeten', 'Théo', 'membre10@serviceconnect.test', NULL, '$2y$10$/YWkksywJuRFmGp5g9Ljq.yHnXEFVJtTMksg0cQDiZHPI5T35LpCu', '+32 462 64 25 54', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(12, 'Antoine', 'Julie', 'membre11@serviceconnect.test', NULL, '$2y$10$aKz7YxoSAdd8gbL1Mx8JguVWrHyA5sRlfU7mvS4zcr9XN/.aa15/m', '+32 420 87 90 41', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(13, 'Lemaire', 'Malak', 'membre12@serviceconnect.test', NULL, '$2y$10$exntSXvMsAKDQO7bWbVB.OXpy88/QdH/ny573.Mh/ii7Z2U9jUXXG', '+32 434 91 60 53', 'membre', 'suspendu', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(14, 'Delfosse', 'Lotte', 'membre13@serviceconnect.test', NULL, '$2y$10$opJbYcvA96QNx/aSqKZgu.c.0rH/QQRABeUaJV8Xgrihr5GVZn2eq', '+32 407 93 77 21', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(15, 'Schmitz', 'Clément', 'membre14@serviceconnect.test', NULL, '$2y$10$9T4ciwY6Vq.we/FompPbVeogOs3WRanmpln3v0iTw9crK1h3H4iLa', '+32 458 44 67 35', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(16, 'Verstraete', 'Bo', 'membre15@serviceconnect.test', NULL, '$2y$10$IOlvdmGEHsIveJNacPbwgO2crQSZy32hgybehYvzIoURz.MpcDV92', '+32 484 42 42 95', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(17, 'Moens', 'Julien', 'membre16@serviceconnect.test', NULL, '$2y$10$xASpzJ4i2neqq074UhCQ6uF/GueB8HF4xiMm7jnsg.QqgkbI2TnaO', '+32 447 36 77 85', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(18, 'Hardy', 'Sander', 'membre17@serviceconnect.test', NULL, '$2y$10$ah0vyIlwBNQR.htTDxbZreapTh2rTF4rN/LSymadxfmFrPcaHbljq', '+32 471 87 45 07', 'membre', 'actif', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(19, 'Geerts', 'Robin', 'membre18@serviceconnect.test', NULL, '$2y$10$.B.JIo21QRH7LTTQh4H88.yfog9dwxBw493/7BkFXDPpFOne4QwIW', '+32 475 97 18 55', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(20, 'Vandenberghe', 'Alessio', 'membre19@serviceconnect.test', NULL, '$2y$10$BlyNRgXMJ/Z8TP9LILXNXuspZAohSJMt8a.sddovQ09/DYZh7418S', '+32 455 34 68 64', 'membre', 'suspendu', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(21, 'Renard', 'Pauline', 'membre20@serviceconnect.test', NULL, '$2y$10$jVorCTb12q4Fmqy4F/Pxl.TIOJ2qFF/zpPyW0jeetejwGvj5vKv0e', '+32 440 78 88 94', 'membre', 'suspendu', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(22, 'Louis', 'Lily', 'membre21@serviceconnect.test', NULL, '$2y$10$qt1BBYFVLJaqK8I4moJbEe80w.HRMUK0zeqdZ.5mYwHhbhEp.cJlm', '+32 435 94 46 06', 'membre', 'suspendu', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(23, 'Toussaint', 'Clémence', 'membre22@serviceconnect.test', NULL, '$2y$10$iA71dNiwjVQrHkNlEXHM2eYSwhEocPKMFJuivsKCQA.DzcMR9kTGK', '+32 432 01 80 37', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(24, 'De Smedt', 'Lien', 'membre23@serviceconnect.test', NULL, '$2y$10$LxYvVvdFZTNkNZtS72Yy/Oa/nJSalH1LVQ/ODlgXrcOxFgJx3gA2.', '+32 413 94 34 50', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(25, 'Claeys', 'Ines', 'membre24@serviceconnect.test', NULL, '$2y$10$2K9aS2bG6W9eUxe8zyIj5u5RcdlR83YhJ57pgxT/Db/2rfHudaseu', '+32 400 63 87 79', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(26, 'Noël', 'Alexia', 'membre25@serviceconnect.test', NULL, '$2y$10$QD5kaYKcDHxvZmIL17d.mOOZT9OvF6FIHO9PJ5Hb8qUKuw1NENUmW', '+32 474 84 55 11', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(27, 'Jacob', 'Gilles', 'membre26@serviceconnect.test', NULL, '$2y$10$YwJ8ipdNMLIp0//TpP4nnezXFqiOImOVfRbPUYqXtbaFem8YkCxIG', '+32 415 31 64 80', 'membre', 'actif', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(28, 'Simon', 'Ethan', 'membre27@serviceconnect.test', NULL, '$2y$10$ivCOoPzvLfa/GDgtns9NzOb3yOKUaMGimB/jePxoWI15AkCWA5Lfa', '+32 412 72 64 43', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(29, 'Lievens', 'Emma', 'membre28@serviceconnect.test', NULL, '$2y$10$JCm/hXg3DMxZgMEZ7RE8Z.3i4aAIb.3PRbCxSyc.JPQgddpL9Xccu', '+32 420 38 22 48', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(30, 'De Winter', 'Juliette', 'membre29@serviceconnect.test', NULL, '$2y$10$i/XjbN2qho/lILqgL7w9QeAr7I5YJh1AfA/U.8TDXqWowZduv6CVy', '+32 432 25 08 20', 'membre', 'suspendu', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(31, 'Vercammen', 'Xander', 'membre30@serviceconnect.test', NULL, '$2y$10$Er2wn83OrnbhtBE3leHA4udGLLEyG2Rn5vSjYs6hmHRu7ZaJacipC', '+32 429 51 59 09', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(32, 'Vermeiren', 'Thomas', 'membre31@serviceconnect.test', NULL, '$2y$10$.6/QnXrnKZzzWPoeKJYdM.TSyAJz6Tleg/LfV4pOnetScJoMdPJZy', '+32 471 25 18 81', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(33, 'Louis', 'Tristan', 'membre32@serviceconnect.test', NULL, '$2y$10$98DQ8fUybBnWZk5dedUy0.XH3uhVdWuFFUY4l.BfWf4aY4KRxg6hK', '+32 486 17 89 72', 'membre', 'suspendu', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(34, 'De Smet', 'Amy', 'membre33@serviceconnect.test', NULL, '$2y$10$urlhYlaTcjpeJaUFi43K.OCp5X.xE/0cLNJFGZ9jWbq00nuqnFYCa', '+32 460 69 54 20', 'membre', 'suspendu', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(35, 'De Clercq', 'Eloïse', 'membre34@serviceconnect.test', NULL, '$2y$10$9L7yJjpa3vT83DseqZ98TeSG.WbNTRSm.BDI84bvgQRaa5Vt0w9iO', '+32 483 80 57 18', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(36, 'Thomas', 'Hajar', 'membre35@serviceconnect.test', NULL, '$2y$10$Gwvx/fiMsJY9kEDzgJFUF.2hEmnI1cxSKPdFNGTeYggPNKhh0SNp2', '+32 499 78 29 52', 'membre', 'actif', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(37, 'Vervoort', 'Zoé', 'membre36@serviceconnect.test', NULL, '$2y$10$T1vtZtzsKOtquJculxkUwONmZ5z46LVGEYVpRppBkJKCmCbTRFJOC', '+32 413 67 82 05', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(38, 'Mertens', 'Jelle', 'membre37@serviceconnect.test', NULL, '$2y$10$nwbzR3tj5aa1lFebY69AguhIVEf2uZmYgIb4tGmTixcm.TYbdDENy', '+32 473 83 13 10', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(39, 'Claes', 'Mathys', 'membre38@serviceconnect.test', NULL, '$2y$10$DdrSJZ07HaNF/TwfrNiwSO3FC/qiPbzdHgOeGh7ioPZ7uv5SIiOdq', '+32 410 63 94 98', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(40, 'Legrand', 'Ayoub', 'membre39@serviceconnect.test', NULL, '$2y$10$gMqkfJEF9PTc9jQu/5ueUuM8tW6ueZfnoOLJpyaB5us4HQ2uqXsG2', '+32 417 47 72 40', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(41, 'Smet', 'Roos', 'membre40@serviceconnect.test', NULL, '$2y$10$MWxYNtRwhipw1EnbFVqCj.8Op8e5rdqCHc4zTTSd6bEjcBRmRpIl2', '+32 432 77 93 87', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(42, 'Demir', 'Jonas', 'membre41@serviceconnect.test', NULL, '$2y$10$UGzzb2Chw8klFPQzQ1gDgeruAm./0gTkEPq2NXJEu2HLJZAGb75j2', '+32 438 19 84 33', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(43, 'Michaux', 'Martin', 'membre42@serviceconnect.test', NULL, '$2y$10$UI9J63NEBsthvStijy6GMedM4xN2ZDJg3OSAPaypIEIzrkD.bR5yO', '+32 435 80 61 10', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(44, 'Descamps', 'Florian', 'membre43@serviceconnect.test', NULL, '$2y$10$E2I6DtA2kiesVvcCWigaNu7Y3QxIRca9O3uvlyDC8GC1hxWiZtsmu', '+32 469 47 81 49', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(45, 'Daems', 'Marie', 'membre44@serviceconnect.test', NULL, '$2y$10$XfDTruH1MazI.fzcmqFkY.L0F9Rc0kW5sDs.fJwq.zKXOmTtRWLU2', '+32 466 05 01 85', 'membre', 'suspendu', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(46, 'Smets', 'Alyssa', 'membre45@serviceconnect.test', NULL, '$2y$10$ceAlDmckdiSiCZV5oe24POZGIKP/iA45BSiP4fl4U.k51WnpN4/r.', '+32 460 44 19 47', 'membre', 'actif', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(47, 'Marchal', 'Clémence', 'membre46@serviceconnect.test', NULL, '$2y$10$iCDn31U2JgtP/eVRqaRAj.uNK3GaSBQ8gAAejVr0Uy2Pcj70Xhsq6', '+32 431 41 31 41', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(48, 'Tran', 'Kato', 'membre47@serviceconnect.test', NULL, '$2y$10$lEENDBhp7H1FxV7GAxdE7e6muJgxq4f09G5mgg9sJM8pnBL4WZTXe', '+32 438 43 87 17', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(49, 'De Backer', 'Nore', 'membre48@serviceconnect.test', NULL, '$2y$10$/P3IKUA2mNT.vrH05MQKIe9zqz9sTENKAYLwBZ9xcKngGmMncR3p2', '+32 449 02 95 10', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(50, 'De Clercq', 'Théo', 'membre49@serviceconnect.test', NULL, '$2y$10$pLZd7f8ej.UtxRZ4nhRDuO8BlqSHkJnwkqX8Dzr4MTiuiL0JkrcH.', '+32 431 49 16 07', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(51, 'Noël', 'Yana', 'membre50@serviceconnect.test', NULL, '$2y$10$djWvll8FzMFQJkNnf9Q/m.1BOiF3U5oMtwxErzgl/3OgKwrydykr.', '+32 429 24 13 55', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(52, 'Messaoudi', 'Alexia', 'membre51@serviceconnect.test', NULL, '$2y$10$l0F0cHw2QoZxPeQ2uVRiSOIvpYANCBekEZYlTGgwZCUxoJWrpP9.u', '+32 445 11 69 72', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(53, 'Van den Bossche', 'Célia', 'membre52@serviceconnect.test', NULL, '$2y$10$JXxYAeK308Qsf0FK/c/uFegJysRiSpjktOP7Poi0TufGCXiHdcoUO', '+32 472 57 56 12', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(54, 'Descamps', 'Ines', 'membre53@serviceconnect.test', NULL, '$2y$10$3Prs6enfBFIxy/yIUKzUc.NQA4u03TG7//k/Aqo1bvOstFMSZZWw2', '+32 431 55 04 80', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(55, 'Benali', 'Finn', 'membre54@serviceconnect.test', NULL, '$2y$10$Xwgjy0Uui4lxy6wcrI71Te2utqpOLgGXs7tl3010rln3rqXvG0zAO', '+32 464 78 95 19', 'membre', 'suspendu', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(56, 'Parmentier', 'Lara', 'membre55@serviceconnect.test', NULL, '$2y$10$nhT2YFWAmRWosC7bGTsRkeE8WJtTgFY/s.XYUoWCKPr/CFZPmJch6', '+32 494 57 16 32', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(57, 'Bodart', 'Ella', 'membre56@serviceconnect.test', NULL, '$2y$10$LxT1UaKHTXK514oeu/nfyeTUCpmMzL8cFA6sy.qrRZJtnJL0XjN3q', '+32 467 21 37 29', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(58, 'Verbeeck', 'Robin', 'membre57@serviceconnect.test', NULL, '$2y$10$awQhSpVjeIqLatIXpz6TTu3iOwq.Aq.IBEDpB69uOBTrkxnKdq9.K', '+32 480 29 73 21', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(59, 'Delvaux', 'Aaron', 'membre58@serviceconnect.test', NULL, '$2y$10$rj0nrIr2hYisUgWl7Qar4.7Suld5at/wgA0RAUzcv.Cy6wf0w.TdK', '+32 488 66 56 38', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(60, 'Hardy', 'Noémie', 'membre59@serviceconnect.test', NULL, '$2y$10$eCnazC/0HuZ.38IUvuZ3aOCDLX9EqQ9O04NlJ6dWxPrsaFQo3Daia', '+32 421 98 04 36', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(61, 'Evrard', 'Océane', 'membre60@serviceconnect.test', NULL, '$2y$10$Vr0DUp/aHYoAQ3vJYUhTDOcJP0VJxujjc.rmJ0bbrXuwmUQeNu7du', '+32 408 23 36 19', 'membre', 'suspendu', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(62, 'Cuvelier', 'Clémence', 'membre61@serviceconnect.test', NULL, '$2y$10$37ZvF.LXxc.2ZhNwGTu3/.Niu83PAFk203o03DgXB2txpZSRz.ytG', '+32 495 17 74 97', 'membre', 'actif', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(63, 'Grégoire', 'Jasper', 'membre62@serviceconnect.test', NULL, '$2y$10$V9DAOAC1tmfK6xE8YSlhou/1/tGs43kVHSmmvpD8iW5lb/gJshsOq', '+32 458 60 77 85', 'membre', 'actif', 'fr', NULL, NULL, 'Molenbeek-Saint-Jean', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(64, 'Ceulemans', 'Sara', 'membre63@serviceconnect.test', NULL, '$2y$10$kaUIl43GE8eW3evjQqFGou/jWhAYmt1Cby.3OhDii/AIsqHt8Ih0i', '+32 445 53 67 38', 'membre', 'actif', 'fr', NULL, NULL, 'Uccle', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(65, 'Van de Velde', 'Lander', 'membre64@serviceconnect.test', NULL, '$2y$10$PfDSa.rqfsI2i59YAGwcNOaMlEnUlQOPPqhYvWBbvV06so5nTGEA.', '+32 427 94 92 37', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(66, 'Jacob', 'Anna', 'membre65@serviceconnect.test', NULL, '$2y$10$e/FhHpy4VyH0TtGWc3/iA.PFROXjdApuO/GzWWg77g4JyJVPo0CKK', '+32 443 87 74 54', 'membre', 'actif', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(67, 'Louis', 'Alessio', 'membre66@serviceconnect.test', NULL, '$2y$10$P..rd/92tPa3lpJbCh/d6OUuO5Oryl/oVDl3x6f4DRJzchcON8Ebu', '+32 408 11 39 97', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(68, 'Herman', 'Benjamin', 'membre67@serviceconnect.test', NULL, '$2y$10$0zn/UZPHZ0vLP5KsjY1V2Ob60QyfBGFPwhv6LZAFtxy6NOtvUgpIS', '+32 495 47 27 86', 'membre', 'suspendu', 'fr', NULL, NULL, 'Bruxelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(69, 'Hajji', 'Sofia', 'membre68@serviceconnect.test', NULL, '$2y$10$IBwGJtavneEHUQJ2ew4QjOiyl3SjojExnaSfO0Hda50SfOVGQOZbC', '+32 444 64 80 90', 'membre', 'suspendu', 'fr', NULL, NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(70, 'Verheyen', 'Tristan', 'membre69@serviceconnect.test', NULL, '$2y$10$f/wCEhgIR267v7NwMMQuguOIXxzo1snM9JRKL.NNgCC5dkYfWIQpa', '+32 410 06 58 24', 'membre', 'actif', 'fr', NULL, NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(71, 'Charlier', 'Mauro', 'membre70@serviceconnect.test', NULL, '$2y$10$yveJ2XyxLf.Q4CrnCH/n/uUnWAXvjMpw/C2lBEy7m90L0EtsQgWPS', '+32 407 95 51 54', 'membre', 'actif', 'fr', NULL, NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(72, 'Cornelis', 'Milan', 'prestataire1@serviceconnect.test', NULL, '$2y$10$IDAdp0uxgYyYcy6NVRq1BOznG8QK1C929UugwJ4xDiD4Th11bjziK', '+32 473 99 22 41', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide ménagère, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, '40nyp1H9AQ9PtzS64HSfiLICbelVxoWN0GCzr0kUMmlxrKCH58EMHWW65iyp', '2026-05-16 17:10:05', '2026-07-24 13:20:42'),
(73, 'Thiry', 'Martin', 'prestataire2@serviceconnect.test', NULL, '$2y$10$SrZCgFeoe/Wwf55rUgoo2.LAa4UaJmEKHPzw0g5ug1rAx12HmTiHy', '+32 462 93 08 47', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide à domicile, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(74, 'Hubert', 'Aaron', 'prestataire3@serviceconnect.test', NULL, '$2y$10$cZxFYZuC3VWShDhp7mhnwOK10QLBeI7Zhu467oVV2v7jS6DKnABsa', '+32 467 64 14 88', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme électricien, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(75, 'Gielen', 'Hugo', 'prestataire4@serviceconnect.test', NULL, '$2y$10$eC6dGucalPd51sp.l3PKn.jafouiNrSCE1vlP6kziyMBKF8.3LJra', '+32 433 14 05 50', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Bruxelles', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(76, 'Willems', 'Pauline', 'prestataire5@serviceconnect.test', NULL, '$2y$10$aUO8PqzDUvXrtVyy.gEH8ePEJTVqVnxmM/NwpeHBZZlvnVr0zkgSS', '+32 486 34 85 68', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Bruxelles', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(77, 'Cornelis', 'Zoé', 'prestataire6@serviceconnect.test', NULL, '$2y$10$9f/H2ioqTxQ5yT074CFTy.gHTi03qqZpPyCs3zY//V47w.mWMQ5m6', '+32 407 70 74 86', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme jardinier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(78, 'Pirotte', 'Janne', 'prestataire7@serviceconnect.test', NULL, '$2y$10$3l8wpdvdsUQDErcfRm1C4.gFM8euHlEfWqK.q9sAeetArxPhMdPZG', '+32 428 94 85 51', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme plombier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(79, 'Barry', 'Maxime', 'prestataire8@serviceconnect.test', NULL, '$2y$10$.L0CWGygMoM4KwyIXGjceefT7BMInPyMN8tw9EFUAU7Fkv.eepWtC', '+32 428 30 06 24', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(80, 'De Meyer', 'Chiara', 'prestataire9@serviceconnect.test', NULL, '$2y$10$zieRkQ0u6vFizW2WixT5JuD9oGZT/JDx5znYUhcctdZ8ccE8fxUu6', '+32 418 22 19 97', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(81, 'Urbain', 'Yasmine', 'prestataire10@serviceconnect.test', NULL, '$2y$10$O.RmzMUB4u6Qo2C3EYjGVu4gGIeTcaRGjcxtwQ4zzmHJdpHYuo11.', '+32 472 94 45 95', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-17 21:40:01'),
(82, 'Evrard', 'Janne', 'prestataire11@serviceconnect.test', NULL, '$2y$10$bvILAydse0EcFeWT2/tSA.qWIyl2glOv3iOa5gb39N4Xj1rfpE.sy', '+32 441 71 07 94', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Forest', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(83, 'Charlier', 'David', 'prestataire12@serviceconnect.test', NULL, '$2y$10$wjersHXZ22wJubVQtmX.e.BIgwFikM.9nuZH4Js9g97RpsvLN0xnq', '+32 425 95 51 48', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(84, 'Simon', 'Gilles', 'prestataire13@serviceconnect.test', NULL, '$2y$10$cjCnGFmSEwHrbN9s6srpz.YsNngCgyZVxrrujsaQX2nchAz70Btim', '+32 469 15 49 75', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide à domicile, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(85, 'Messaoudi', 'Jonas', 'prestataire14@serviceconnect.test', NULL, '$2y$10$3y1HfZ8OEqmOq8kSlOynP.o.oNZUMHZLjFiMFe.62H4h4IkxKbfzq', '+32 427 30 07 71', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(86, 'Lacroix', 'Alexander', 'prestataire15@serviceconnect.test', NULL, '$2y$10$wZE7Ava4ycKegjHmtVjhDuUpabExEiVSfe3gQDUR3uJxznDIhF.Pq', '+32 446 09 47 99', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme électricien, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(87, 'Hermans', 'Emma', 'prestataire16@serviceconnect.test', NULL, '$2y$10$2p7J/zPg/KsUquQ7tHu.QesbwQnavp8fOoPEgSW0MH4c8MKBaSydK', '+32 426 59 23 06', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme technicien informatique, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(88, 'Adam', 'Victor', 'prestataire17@serviceconnect.test', NULL, '$2y$10$u6yNBYJIN6RrkDRYavQJ8udfalSHINijzx6J5ez5WKPCeXafhKfeK', '+32 449 34 51 63', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme électricien, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Schaerbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(89, 'Gillet', 'Rayan', 'prestataire18@serviceconnect.test', NULL, '$2y$10$0PvJQYFTtMCjFOsgo0Fva.hqd3MIBYIEWM9pEMI.LezfCqQrO2p9W', '+32 448 92 68 74', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Bruxelles', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(90, 'Claeys', 'Jeanne', 'prestataire19@serviceconnect.test', NULL, '$2y$10$soxp6f33P0LnVgXAIzUHtuuHWBgKI7GoIaqRUtf3Dl57sbRjmw2/G', '+32 454 83 07 99', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(91, 'Vermeersch', 'Chloé', 'prestataire20@serviceconnect.test', NULL, '$2y$10$.n.k8L01DhzdbW6yZloh9.97LDpFu9pUsE.md0QmgjHOmnJY6gnuW', '+32 452 93 07 50', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(92, 'Meunier', 'Roos', 'prestataire21@serviceconnect.test', NULL, '$2y$10$aO0oq7d51H0CpTHtbtllhuUKdZXw6pUPZMDw1Jj4qkBBqwPoBTpy2', '+32 415 97 74 79', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(93, 'Hubert', 'Aaron', 'prestataire22@serviceconnect.test', NULL, '$2y$10$IwLDJFeOteqezx7LdEjp3Ow/Hil/hwws/iz5m5zBki/uIYk0qvH.u', '+32 497 29 99 43', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme plombier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(94, 'Gilson', 'Roos', 'prestataire23@serviceconnect.test', NULL, '$2y$10$MLzeH0KNBEXX1DQEfCLONuWoNfa/btHn2kHb3uyrEzZFTGcYhGqtS', '+32 465 94 42 13', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme technicien informatique, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Forest', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(95, 'Bodart', 'Lore', 'prestataire24@serviceconnect.test', NULL, '$2y$10$5ZTJUe5SIKDmt/hJDKI2Eeh1YnCABn3FR0N9FjFjj1ECr21pb2oSK', '+32 422 68 59 33', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme plombier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(96, 'Desmedt', 'Clara', 'prestataire25@serviceconnect.test', NULL, '$2y$10$A3h05RnPQiFEX48ex7QRS.yKWv6I2aj.TMsQoRvOooNo8GYpgPfti', '+32 434 46 88 13', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme jardinier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-07-18 00:10:06'),
(97, 'Poncelet', 'Victor', 'prestataire26@serviceconnect.test', NULL, '$2y$10$Jesl4.SxDPzt5tBvA/ydhupk5quem0t0fkUYS2jtOJPg1u7qcHPRa', '+32 485 20 30 42', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide ménagère, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(98, 'Moens', 'Laura', 'prestataire27@serviceconnect.test', NULL, '$2y$10$Nn9hzYBOya9bC8YI4Ni.Vuyy.3txseU0ITT4HvXuVvMtvlfZ7yHG.', '+32 492 95 98 52', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(99, 'Lemmens', 'Enzo', 'prestataire28@serviceconnect.test', NULL, '$2y$10$2FXVePz4QHp/4OXbCMEHA.Bk3scQPWCnPL80MEgCf6FZwXydg7lmq', '+32 447 52 45 63', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme jardinier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Schaerbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(100, 'Claes', 'Emma', 'prestataire29@serviceconnect.test', NULL, '$2y$10$fnYIZVzf42Np/O4i4CeHnu3NympkFjJPa6nNWmegWaYWnQf0680fa', '+32 428 16 21 46', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide à domicile, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(101, 'Gilson', 'Alice', 'prestataire30@serviceconnect.test', NULL, '$2y$10$ouhcwu.99q1lQNijCGDWT.SRuudZeLw6S62.va.dq4n5/nEozF9ty', '+32 416 53 58 94', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme technicien informatique, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(102, 'Van de Velde', 'Elisa', 'prestataire31@serviceconnect.test', NULL, '$2y$10$35WeLOKRjLwj6TpVvLqbQe9Xgr1fxVPGw5oNQz6EXmO.L3hp2qrmC', '+32 466 09 83 65', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme plombier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Uccle', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(103, 'Martens', 'Maya', 'prestataire32@serviceconnect.test', NULL, '$2y$10$O2FviBAayHP9zxS2focqE.i.MeUharuuJWIxTrMLJad1b39XvdIfm', '+32 461 58 52 91', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme jardinier, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(104, 'Van Hoof', 'Tibo', 'prestataire33@serviceconnect.test', NULL, '$2y$10$iE/wovIOpJVUCBEu5xo3Z.v9LI4k3J7Q5pSH375G2qWH.uh6myfby', '+32 401 91 55 52', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Schaerbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(105, 'Verhelst', 'Finn', 'prestataire34@serviceconnect.test', NULL, '$2y$10$TVy2eOzfsB03sN/TiDmTKeOP6EVuNu/zp/7O05PHrpr.t07VmKN9O', '+32 409 69 13 46', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme bricoleur polyvalent, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Ixelles', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(106, 'Dupont', 'Ella', 'prestataire35@serviceconnect.test', NULL, '$2y$10$geR4C7QeZ4BcR17k3TXMXO2Nx8i3N2RtufrH1z3KdSMdRm55n62d2', '+32 487 74 25 43', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme électricien, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(107, 'Deprez', 'Janne', 'prestataire36@serviceconnect.test', NULL, '$2y$10$Bll1GCdgz9ygUeFWSIA1ke0KXPDoZDfWZtSW9jKi99RdyqyAiYqPO', '+32 446 75 97 47', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Etterbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(108, 'De Smet', 'Arthur', 'prestataire37@serviceconnect.test', NULL, '$2y$10$aoE/ypqPfQOmFqhUMNxm..BJl5IusNgEzJBahXhwALcEFbnNdZrci', '+32 419 85 69 75', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme électricien, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Forest', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(109, 'Verstraeten', 'Mila', 'prestataire38@serviceconnect.test', NULL, '$2y$10$sRZtSxG26HU2QU9t4CyRUeN5SDzWL1HptLhY1KZou4eJbnmwUvhHy', '+32 434 59 52 32', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide ménagère, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(110, 'Antoine', 'Jasper', 'prestataire39@serviceconnect.test', NULL, '$2y$10$1jw/cBvXIuEj9iUd/UXfaeHkkNxAc0ocEip30ywp6baAI9wltk18S', '+32 430 28 08 63', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme baby-sitter, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Anderlecht', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(111, 'Gilles', 'Lowie', 'prestataire40@serviceconnect.test', NULL, '$2y$10$34Vys3gJnzglMqSpHmBKp.uM37ChCHqTs3UBFpk/MkMxU5WK1j17.', '+32 459 57 77 64', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé comme aide à domicile, disponible pour des interventions locales à Bruxelles et dans les communes voisines.', NULL, 'Schaerbeek', 1, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-16 17:10:05', '2026-05-16 17:10:05'),
(112, 'cherifi', 'haytam', 'cherhaytam@gmail.com', NULL, '$2y$10$3Do3C5EDWnxOKuW4fZdnzeBAqbQKUnelueTfCYl48HHCnqaoKMIMq', '0032487205610', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé en Informatique sur Bruxelles et les alentours', 'profile_photos/FlUqFmVRfDVyfZ60klnragdqBLyyxO3HHwrM34XK.png', 'herzele', 0, 'aucune', NULL, NULL, NULL, NULL, NULL, NULL, '2026-07-22 11:34:18', '2026-07-23 14:59:57'),
(113, 'Dubois', 'Frederic', 'duboisfrederic@gmail.com', NULL, '$2y$10$eS.1kWuS5Sr2caPJwZDayujbCSKYzzYZjUcNjmujmmzRFS2PgHPkO', '00487205611', 'membre', 'actif', 'fr', NULL, NULL, 'Zottegem', 0, 'refusee', 'Entraîneur personnel', 'Zottegem', '00487205611', '2026-07-23 17:04:12', '2026-07-23 17:07:35', NULL, '2026-07-23 17:02:36', '2026-07-23 17:07:35'),
(114, 'mehdi', 'ben', 'mehdiben@gmail.com', NULL, '$2y$10$tcJRVbzSO6u.aWM6lrjAVe8/7XAyFfA9eGJfxCrPeVmn5qNQYsf4i', NULL, 'prestataire', 'actif', 'fr', 'Specialisé en bricolage comme montage...', NULL, 'Bruxelles', 0, 'acceptee', 'Specialisé en bricolage comme montage...', 'Bruxelles', NULL, '2026-07-23 18:20:06', '2026-07-23 18:21:09', NULL, '2026-07-23 18:16:22', '2026-07-23 18:21:09'),
(115, 'geoffery', 'zaaza', 'geofferyzaaza@gmail.com', NULL, '$2y$10$wUEl25XkepKQg3mB.If.ee/5yaRT8UUreWiAfc8TO34oaHRTHxV1q', '+32487205213', 'prestataire', 'actif', 'fr', 'Prestatire spécialisé dans les gros travaux', NULL, 'Anvers', 0, 'acceptee', 'Prestatire spécialisé dans les gros travaux', 'Anvers', '+32487205213', '2026-07-23 22:56:51', '2026-07-23 22:58:38', NULL, '2026-07-23 22:56:51', '2026-07-23 22:58:38'),
(116, 'Shelby', 'Thomas', 'Thomasshelby@gmail.com', NULL, '$2y$10$t.1Bnjtp2ZQFZomAW.uwze9XPvVev6L.SKSELoBonO9nsKRB15jwW', '00324582045', 'prestataire', 'actif', 'fr', 'Prestataire spécialisé dans l\'installation des panneaux solaire, disponible dans les alentours de Bruxelles.', NULL, 'Bruxelles', 0, 'acceptee', 'Prestataire spécialisé dans l\'installation des panneaux solaire, disponible dans les alentours de Bruxelles.', 'Bruxelles', '00324582045', '2026-07-24 12:40:12', '2026-07-24 12:44:27', NULL, '2026-07-24 12:12:14', '2026-07-24 19:33:00');

-- --------------------------------------------------------

--
-- Structure de la table `user_notifications`
--

CREATE TABLE `user_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(100) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `lien` varchar(255) DEFAULT NULL,
  `related_type` varchar(100) DEFAULT NULL,
  `related_id` bigint(20) UNSIGNED DEFAULT NULL,
  `lu` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user_notifications`
--

INSERT INTO `user_notifications` (`id`, `user_id`, `type`, `titre`, `message`, `lien`, `related_type`, `related_id`, `lu`, `read_at`, `data`, `created_at`, `updated_at`) VALUES
(1, 72, 'message', 'Nouveau message', 'CHER HAYTAM vous a envoyé un message.', '/mes-messages', 'message', 158, 1, '2026-07-22 13:21:54', NULL, '2026-07-22 13:21:22', '2026-07-22 13:21:54'),
(2, 72, 'reservation_recue', 'Nouvelle réservation', 'CHER HAYTAM a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 125, 1, '2026-07-22 15:30:49', NULL, '2026-07-22 15:29:16', '2026-07-22 15:30:49'),
(3, 112, 'reservation_acceptee', 'Réservation acceptée', 'Votre demande de réservation a été acceptée.', '/mes-reservations', 'reservation', 125, 1, '2026-07-22 15:32:59', NULL, '2026-07-22 15:30:51', '2026-07-22 15:32:59'),
(4, 112, 'paiement_accepte', 'Paiement confirmé', 'Votre paiement a été confirmé avec succès.', '/mes-paiements', 'paiement', 103, 1, '2026-07-22 15:34:22', NULL, '2026-07-22 15:34:18', '2026-07-22 15:34:22'),
(5, 72, 'paiement_recu', 'Paiement reçu', 'Un paiement a été confirmé pour une réservation.', '/prestataire/paiements', 'paiement', 103, 1, '2026-07-22 16:02:29', NULL, '2026-07-22 15:34:18', '2026-07-22 16:02:29'),
(6, 1, 'admin_annonce_en_attente', 'Nouvelle annonce à valider', 'Une nouvelle annonce a été créée par Milan Cornelis.', '/admin/annonces', 'annonce', 125, 1, '2026-07-22 18:55:55', NULL, '2026-07-22 17:04:58', '2026-07-22 18:55:55'),
(7, 72, 'message', 'Nouveau message', 'CHER HAYTAM vous a envoyé un message.', '/mes-messages', 'message', 159, 1, '2026-07-22 19:31:43', NULL, '2026-07-22 17:11:42', '2026-07-22 19:31:43'),
(8, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/dashboard', 'message', 159, 1, '2026-07-22 18:55:20', NULL, '2026-07-22 17:11:42', '2026-07-22 18:55:20'),
(9, 89, 'message', 'Nouveau message', 'CHER HAYTAM vous a envoyé un message.', '/mes-messages', 'message', 160, 0, NULL, NULL, '2026-07-22 19:15:46', '2026-07-22 19:15:46'),
(10, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/messages', 'message', 160, 1, '2026-07-22 19:34:14', NULL, '2026-07-22 19:15:46', '2026-07-22 19:34:14'),
(11, 89, 'message', 'Nouveau message', 'CHER HAYTAM vous a envoyé un message.', '/mes-messages', 'message', 161, 0, NULL, NULL, '2026-07-22 19:16:21', '2026-07-22 19:16:21'),
(12, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/messages', 'message', 161, 1, '2026-07-22 19:34:14', NULL, '2026-07-22 19:16:21', '2026-07-22 19:34:14'),
(13, 72, 'message', 'Nouveau message', 'CHER HAYTAM vous a envoyé un message.', '/mes-messages', 'message', 162, 1, '2026-07-22 19:31:43', NULL, '2026-07-22 19:31:05', '2026-07-22 19:31:43'),
(14, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/messages', 'message', 162, 1, '2026-07-22 19:34:14', NULL, '2026-07-22 19:31:05', '2026-07-22 19:34:14'),
(15, 1, 'admin_avis_publie', 'Nouvel avis publié', 'Un nouvel avis a été laissé par CHER HAYTAM.', '/admin/avis', 'avis', 101, 1, '2026-07-23 17:05:47', NULL, '2026-07-22 22:39:44', '2026-07-23 17:05:47'),
(16, 113, 'demande_prestataire_refusee', 'Demande prestataire refusée', 'Votre demande pour devenir prestataire a été refusée.', '/devenir-prestataire', 'user', 113, 0, NULL, NULL, '2026-07-23 17:07:35', '2026-07-23 17:07:35'),
(17, 1, 'admin_demande_prestataire', 'Nouvelle demande prestataire', 'ben mehdi souhaite devenir prestataire.', '/admin/users', 'user', 114, 1, '2026-07-23 18:21:03', NULL, '2026-07-23 18:20:06', '2026-07-23 18:21:03'),
(18, 114, 'demande_prestataire_acceptee', 'Demande prestataire acceptée', 'Votre demande pour devenir prestataire a été acceptée.', '/prestataire/dashboard', 'user', 114, 0, NULL, NULL, '2026-07-23 18:21:09', '2026-07-23 18:21:09'),
(19, 1, 'admin_demande_prestataire', 'Nouvelle demande prestataire', 'zaaza geoffery souhaite créer un compte prestataire.', '/admin/users', 'user', 115, 1, '2026-07-23 22:58:29', NULL, '2026-07-23 22:56:51', '2026-07-23 22:58:29'),
(20, 115, 'demande_prestataire_acceptee', 'Demande prestataire acceptée', 'Votre demande pour devenir prestataire a été acceptée.', '/prestataire/dashboard', 'user', 115, 1, '2026-07-23 23:17:08', NULL, '2026-07-23 22:58:38', '2026-07-23 23:17:08'),
(21, 115, 'message', 'Nouveau message', 'ServiceConnect Admin vous a envoyé un message.', '/mes-messages', 'message', 163, 1, '2026-07-23 23:03:17', NULL, '2026-07-23 23:02:12', '2026-07-23 23:03:17'),
(22, 72, 'message', 'Nouveau message', 'Thomas Shelby vous a envoyé un message.', '/mes-messages', 'message', 164, 1, '2026-07-24 12:17:49', NULL, '2026-07-24 12:16:18', '2026-07-24 12:17:49'),
(23, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/messages', 'message', 164, 1, '2026-07-24 12:50:31', NULL, '2026-07-24 12:16:18', '2026-07-24 12:50:31'),
(24, 112, 'reservation_terminee', 'Réservation terminée', 'Votre réservation a été marquée comme terminée.', '/mes-reservations', 'reservation', 125, 0, NULL, NULL, '2026-07-24 12:32:09', '2026-07-24 12:32:09'),
(25, 72, 'reservation_recue', 'Nouvelle réservation', 'Thomas Shelby a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 126, 1, '2026-07-24 12:33:46', NULL, '2026-07-24 12:33:29', '2026-07-24 12:33:46'),
(26, 116, 'reservation_acceptee', 'Réservation acceptée', 'Votre demande de réservation a été acceptée.', '/mes-reservations', 'reservation', 126, 1, '2026-07-24 12:34:15', NULL, '2026-07-24 12:34:09', '2026-07-24 12:34:15'),
(27, 116, 'paiement_accepte', 'Paiement confirmé', 'Votre paiement a été confirmé avec succès.', '/mes-paiements', 'paiement', 104, 1, '2026-07-24 12:35:26', NULL, '2026-07-24 12:35:23', '2026-07-24 12:35:26'),
(28, 72, 'paiement_recu', 'Paiement reçu', 'Un paiement a été confirmé pour une réservation.', '/prestataire/paiements', 'paiement', 104, 1, '2026-07-24 12:36:03', NULL, '2026-07-24 12:35:23', '2026-07-24 12:36:03'),
(29, 1, 'admin_avis_publie', 'Nouvel avis publié', 'Un nouvel avis a été laissé par Thomas Shelby.', '/admin/avis', 'avis', 102, 1, '2026-07-24 12:50:25', NULL, '2026-07-24 12:37:01', '2026-07-24 12:50:25'),
(30, 72, 'avis_recu', 'Nouvel avis reçu', 'Thomas Shelby vous a laissé un avis de 5/5.', '/prestataire/avis', 'avis', 102, 1, '2026-07-24 12:37:17', NULL, '2026-07-24 12:37:01', '2026-07-24 12:37:17'),
(31, 1, 'admin_demande_prestataire', 'Nouvelle demande prestataire', 'Thomas Shelby souhaite devenir prestataire.', '/admin/users', 'user', 116, 1, '2026-07-24 12:43:37', NULL, '2026-07-24 12:40:12', '2026-07-24 12:43:37'),
(32, 87, 'reservation_recue', 'Nouvelle réservation', 'Milan Cornelis a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 127, 0, NULL, NULL, '2026-07-24 12:42:09', '2026-07-24 12:42:09'),
(33, 116, 'message', 'Nouveau message', 'ServiceConnect Admin vous a envoyé un message.', '/mes-messages', 'message', 165, 1, '2026-07-24 12:45:17', NULL, '2026-07-24 12:44:12', '2026-07-24 12:45:17'),
(34, 116, 'demande_prestataire_acceptee', 'Demande prestataire acceptée', 'Votre demande pour devenir prestataire a été acceptée.', '/prestataire/dashboard', 'user', 116, 1, '2026-07-24 12:45:26', NULL, '2026-07-24 12:44:27', '2026-07-24 12:45:26'),
(35, 1, 'admin_annonce_en_attente', 'Nouvelle annonce à valider', 'Une nouvelle annonce a été créée par Thomas Shelby.', '/admin/annonces', 'annonce', 126, 1, '2026-07-24 12:49:58', NULL, '2026-07-24 12:48:04', '2026-07-24 12:49:58'),
(36, 116, 'reservation_recue', 'Nouvelle réservation', 'Milan Cornelis a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 128, 1, '2026-07-24 13:26:49', NULL, '2026-07-24 13:25:54', '2026-07-24 13:26:49'),
(37, 72, 'reservation_acceptee', 'Réservation acceptée', 'Votre demande de réservation a été acceptée.', '/mes-reservations', 'reservation', 128, 1, '2026-07-24 13:27:32', NULL, '2026-07-24 13:26:53', '2026-07-24 13:27:32'),
(38, 72, 'paiement_accepte', 'Paiement confirmé', 'Votre paiement a été confirmé avec succès.', '/mes-paiements', 'paiement', 105, 1, '2026-07-24 13:31:37', NULL, '2026-07-24 13:31:34', '2026-07-24 13:31:37'),
(39, 116, 'paiement_recu', 'Paiement reçu', 'Un paiement a été confirmé pour une réservation.', '/prestataire/paiements', 'paiement', 105, 1, '2026-07-24 19:33:27', NULL, '2026-07-24 13:31:34', '2026-07-24 19:33:27'),
(40, 72, 'message', 'Nouveau message', 'Thomas Shelby vous a envoyé un message.', '/mes-messages', 'message', 166, 1, '2026-07-24 19:55:44', NULL, '2026-07-24 15:51:11', '2026-07-24 19:55:44'),
(41, 1, 'admin_message_echange', 'Nouveau message échangé', 'Un nouveau message a été échangé entre deux utilisateurs.', '/admin/messages', 'message', 166, 1, '2026-07-24 18:45:40', NULL, '2026-07-24 15:51:11', '2026-07-24 18:45:40'),
(42, 1, 'admin_demande_categorie', 'Nouvelle demande de catégorie', 'Un prestataire a proposé une nouvelle catégorie : Danse.', '/admin/categories', 'demande_categorie', 1, 1, '2026-07-24 17:51:32', NULL, '2026-07-24 17:50:21', '2026-07-24 17:51:32'),
(43, 116, 'demande_categorie_acceptee', 'Catégorie acceptée', 'Votre demande de catégorie \"Danse\" a été acceptée. Vous pouvez maintenant l’utiliser pour publier une annonce.', '/prestataire/annonces/nouvelle', 'demande_categorie', 1, 1, '2026-07-24 17:51:58', NULL, '2026-07-24 17:51:47', '2026-07-24 17:51:58'),
(44, 116, 'compte_desactive', 'Compte désactivé', 'Votre compte a été désactivé. Veuillez contacter le service client ou l’administrateur pour plus d’informations.', '/login', 'user', 116, 1, '2026-07-24 19:51:48', NULL, '2026-07-24 18:46:53', '2026-07-24 19:51:48'),
(45, 116, 'compte_desactive', 'Compte désactivé', 'Votre compte a été désactivé. Veuillez contacter le service client ou l’administrateur pour plus d’informations.', '/login', 'user', 116, 1, '2026-07-24 19:51:48', NULL, '2026-07-24 18:47:22', '2026-07-24 19:51:48'),
(46, 116, 'reservation_recue', 'Nouvelle réservation', 'Milan Cornelis a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 129, 1, '2026-07-24 19:56:47', NULL, '2026-07-24 19:56:08', '2026-07-24 19:56:47'),
(47, 72, 'reservation_refusee', 'Réservation refusée', 'Votre demande de réservation a été refusée.', '/mes-reservations', 'reservation', 129, 1, '2026-07-24 20:01:25', NULL, '2026-07-24 19:57:07', '2026-07-24 20:01:25'),
(48, 72, 'reservation_recue', 'Nouvelle réservation', 'Thomas Shelby a envoyé une demande de réservation.', '/prestataire/reservations', 'reservation', 130, 1, '2026-07-24 20:29:54', NULL, '2026-07-24 20:29:40', '2026-07-24 20:29:54'),
(49, 116, 'reservation_alternative', 'Nouveau créneau proposé', 'Le prestataire ne peut pas assurer le créneau initial et vous propose un nouveau créneau.', '/mes-reservations', 'reservation', 130, 1, '2026-07-24 20:31:46', NULL, '2026-07-24 20:31:37', '2026-07-24 20:31:46'),
(50, 72, 'reservation_alternative_acceptee', 'Alternative acceptée', 'Thomas Shelby a accepté le nouveau créneau proposé.', '/prestataire/reservations', 'reservation', 130, 1, '2026-07-24 20:44:12', NULL, '2026-07-24 20:33:13', '2026-07-24 20:44:12');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `annonces`
--
ALTER TABLE `annonces`
  ADD PRIMARY KEY (`id`),
  ADD KEY `annonces_prestataire_id_index` (`prestataire_id`),
  ADD KEY `annonces_categorie_id_index` (`categorie_id`),
  ADD KEY `annonces_statut_index` (`statut`);

--
-- Index pour la table `avis`
--
ALTER TABLE `avis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `avis_membre_reservation_unique` (`membre_id`,`reservation_id`),
  ADD KEY `avis_membre_id_index` (`membre_id`),
  ADD KEY `avis_prestataire_id_index` (`prestataire_id`),
  ADD KEY `avis_annonce_id_index` (`annonce_id`),
  ADD KEY `avis_reservation_id_index` (`reservation_id`),
  ADD KEY `avis_visible_index` (`visible`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `demande_categories`
--
ALTER TABLE `demande_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `demande_categories_prestataire_id_index` (`prestataire_id`),
  ADD KEY `demande_categories_statut_index` (`statut`),
  ADD KEY `demande_categories_categorie_id_index` (`categorie_id`);

--
-- Index pour la table `disponibilites`
--
ALTER TABLE `disponibilites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `disponibilites_annonce_id_index` (`annonce_id`),
  ADD KEY `disponibilites_date_debut_index` (`date_debut`),
  ADD KEY `disponibilites_date_fin_index` (`date_fin`);

--
-- Index pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Index pour la table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `likes_membre_id_annonce_id_unique` (`membre_id`,`annonce_id`),
  ADD UNIQUE KEY `likes_membre_id_prestataire_id_unique` (`membre_id`,`prestataire_id`),
  ADD KEY `likes_membre_id_index` (`membre_id`),
  ADD KEY `likes_annonce_id_index` (`annonce_id`),
  ADD KEY `likes_prestataire_id_index` (`prestataire_id`),
  ADD KEY `likes_type_cible_index` (`type_cible`);

--
-- Index pour la table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_expediteur_id_index` (`expediteur_id`),
  ADD KEY `messages_destinataire_id_index` (`destinataire_id`),
  ADD KEY `messages_reservation_id_index` (`reservation_id`),
  ADD KEY `messages_lu_index` (`lu`),
  ADD KEY `messages_annonce_id_index` (`annonce_id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `paiements`
--
ALTER TABLE `paiements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `paiements_reservation_id_unique` (`reservation_id`),
  ADD KEY `paiements_membre_id_index` (`membre_id`),
  ADD KEY `paiements_methode_index` (`methode`),
  ADD KEY `paiements_statut_index` (`statut`);

--
-- Index pour la table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Index pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Index pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservations_disponibilite_id_foreign` (`disponibilite_id`),
  ADD KEY `reservations_membre_id_index` (`membre_id`),
  ADD KEY `reservations_prestataire_id_index` (`prestataire_id`),
  ADD KEY `reservations_annonce_id_index` (`annonce_id`),
  ADD KEY `reservations_statut_index` (`statut`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Index pour la table `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_notifications_user_id_lu_index` (`user_id`,`lu`),
  ADD KEY `user_notifications_user_id_type_index` (`user_id`,`type`),
  ADD KEY `user_notifications_related_type_related_id_index` (`related_type`,`related_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `annonces`
--
ALTER TABLE `annonces`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT pour la table `avis`
--
ALTER TABLE `avis`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `demande_categories`
--
ALTER TABLE `demande_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `disponibilites`
--
ALTER TABLE `disponibilites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=248;

--
-- AUTO_INCREMENT pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT pour la table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `paiements`
--
ALTER TABLE `paiements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT pour la table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT pour la table `user_notifications`
--
ALTER TABLE `user_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `annonces`
--
ALTER TABLE `annonces`
  ADD CONSTRAINT `annonces_categorie_id_foreign` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `annonces_prestataire_id_foreign` FOREIGN KEY (`prestataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `avis`
--
ALTER TABLE `avis`
  ADD CONSTRAINT `avis_annonce_id_foreign` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `avis_membre_id_foreign` FOREIGN KEY (`membre_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `avis_prestataire_id_foreign` FOREIGN KEY (`prestataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `avis_reservation_id_foreign` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `demande_categories`
--
ALTER TABLE `demande_categories`
  ADD CONSTRAINT `demande_categories_categorie_id_foreign` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `demande_categories_prestataire_id_foreign` FOREIGN KEY (`prestataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `disponibilites`
--
ALTER TABLE `disponibilites`
  ADD CONSTRAINT `disponibilites_annonce_id_foreign` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_annonce_id_foreign` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_membre_id_foreign` FOREIGN KEY (`membre_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_prestataire_id_foreign` FOREIGN KEY (`prestataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_annonce_id_foreign` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `messages_destinataire_id_foreign` FOREIGN KEY (`destinataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_expediteur_id_foreign` FOREIGN KEY (`expediteur_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_reservation_id_foreign` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE SET NULL;

--
-- Contraintes pour la table `paiements`
--
ALTER TABLE `paiements`
  ADD CONSTRAINT `paiements_membre_id_foreign` FOREIGN KEY (`membre_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `paiements_reservation_id_foreign` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_annonce_id_foreign` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_disponibilite_id_foreign` FOREIGN KEY (`disponibilite_id`) REFERENCES `disponibilites` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `reservations_membre_id_foreign` FOREIGN KEY (`membre_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_prestataire_id_foreign` FOREIGN KEY (`prestataire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_notifications`
--
ALTER TABLE `user_notifications`
  ADD CONSTRAINT `user_notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
