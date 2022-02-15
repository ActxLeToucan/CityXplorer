-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 15 fév. 2022 à 18:02
-- Version du serveur : 10.4.21-MariaDB
-- Version de PHP : 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cityxplorertest`
--

-- --------------------------------------------------------

--
-- Structure de la table `administrateur`
--

CREATE TABLE `administrateur` (
  `login` varchar(50) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `motDePasse` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `avotepour`
--

CREATE TABLE `avotepour` (
  `idUtilisateur` int(5) NOT NULL,
  `idPost` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `avotepour`
--

INSERT INTO `avotepour` (`idUtilisateur`, `idPost`) VALUES
(3, 2);

-- --------------------------------------------------------

--
-- Structure de la table `contient`
--

CREATE TABLE `contient` (
  `idListe` int(5) NOT NULL,
  `idPost` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `contient`
--

INSERT INTO `contient` (`idListe`, `idPost`) VALUES
(1, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `listeaffichable`
--

CREATE TABLE `listeaffichable` (
  `idliste` int(5) NOT NULL,
  `nomListe` varchar(50) DEFAULT NULL,
  `descriptionListe` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `listeaffichable`
--

INSERT INTO `listeaffichable` (`idliste`, `nomListe`, `descriptionListe`) VALUES
(1, 'Les beaux monuments', 'Liste contenant de beaux monuments');

-- --------------------------------------------------------

--
-- Structure de la table `listeenregistrées`
--

CREATE TABLE `listeenregistrées` (
  `idListe` int(5) NOT NULL,
  `idUtilisateur` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `listeenregistrées`
--

INSERT INTO `listeenregistrées` (`idListe`, `idUtilisateur`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `partage`
--

CREATE TABLE `partage` (
  `idUtilisateur` int(5) NOT NULL,
  `idPost` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `partage`
--

INSERT INTO `partage` (`idUtilisateur`, `idPost`) VALUES
(3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `photo`
--

CREATE TABLE `photo` (
  `idPhoto` int(5) NOT NULL,
  `idPost` int(5) NOT NULL,
  `url` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `photo`
--

INSERT INTO `photo` (`idPhoto`, `idPost`, `url`) VALUES
(1, 1, 'Lien image tour de pise'),
(2, 2, 'Lien imageGare MontParnasse'),
(3, 1, 'zqg mkjzlkdgjz');

-- --------------------------------------------------------

--
-- Structure de la table `post`
--

CREATE TABLE `post` (
  `idPost` int(5) NOT NULL,
  `emplacementX` varchar(100) DEFAULT NULL,
  `emplacementY` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `titre` varchar(100) DEFAULT NULL,
  `datePost` date DEFAULT NULL,
  `etat` varchar(10) DEFAULT NULL,
  `photo` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `post`
--

INSERT INTO `post` (`idPost`, `emplacementX`, `emplacementY`, `description`, `titre`, `datePost`, `etat`, `photo`) VALUES
(1, '10', '10', 'Photo de la tour de pise', 'Tour de Pise', '2021-12-28', 'Invalide', ''),
(2, '87', '32', 'Gare MontParnasse', 'Gare MontParnasse', '2021-12-28', 'Valide', ''),
(5, '10', '10', 'Voici un chateau', 'Le chateau très beau', NULL, 'Invalide', '');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `login` varchar(50) NOT NULL,
  `email` varchar(256) DEFAULT NULL,
  `motDePasse` varchar(256) DEFAULT NULL,
  `photoDeProfil` varchar(250) DEFAULT NULL,
  `niveauAcces` int(5) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `login`, `email`, `motDePasse`, `photoDeProfil`, `niveauAcces`) VALUES
(1, 'antoine', 'a@a.a', '$2y$12$eKIPYSrDDdmop8a7sOWIAu5EKNJdZLvdKY33kyIQd/QfGCg6l8ZIa', NULL, 1),
(2, 'JacobFromTheStreet', 'JacobFromTheStreet@gmail.com', '$2y$12$eKIPYSrDDdmop8a7sOWIAu5EKNJdZLvdKY33kyIQd/QfGCg6l8ZIa', 'Lien photo de profil', 1),
(3, 'PierreDu78000', 'pierre@gmail.com', '1234', 'Lien photo de profil', 1);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD PRIMARY KEY (`login`);

--
-- Index pour la table `avotepour`
--
ALTER TABLE `avotepour`
  ADD PRIMARY KEY (`idUtilisateur`,`idPost`);

--
-- Index pour la table `contient`
--
ALTER TABLE `contient`
  ADD PRIMARY KEY (`idListe`,`idPost`);

--
-- Index pour la table `listeaffichable`
--
ALTER TABLE `listeaffichable`
  ADD PRIMARY KEY (`idliste`);

--
-- Index pour la table `listeenregistrées`
--
ALTER TABLE `listeenregistrées`
  ADD PRIMARY KEY (`idListe`,`idUtilisateur`);

--
-- Index pour la table `partage`
--
ALTER TABLE `partage`
  ADD PRIMARY KEY (`idUtilisateur`,`idPost`);

--
-- Index pour la table `photo`
--
ALTER TABLE `photo`
  ADD PRIMARY KEY (`idPhoto`);

--
-- Index pour la table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`idPost`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `listeaffichable`
--
ALTER TABLE `listeaffichable`
  MODIFY `idliste` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `photo`
--
ALTER TABLE `photo`
  MODIFY `idPhoto` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `avotepour`
--
ALTER TABLE `avotepour`
  ADD CONSTRAINT `idpostvote_Foreign_key` FOREIGN KEY (`idPost`) REFERENCES `post` (`idPost`),
  ADD CONSTRAINT `loginuser_vote_foreign_key` FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateur` (`id`);

--
-- Contraintes pour la table `contient`
--
ALTER TABLE `contient`
  ADD CONSTRAINT `idListContient_foreign_key` FOREIGN KEY (`idListe`) REFERENCES `listeaffichable` (`idliste`),
  ADD CONSTRAINT `idpostContient_Foreign_key` FOREIGN KEY (`idPost`) REFERENCES `post` (`idPost`);

--
-- Contraintes pour la table `listeenregistrées`
--
ALTER TABLE `listeenregistrées`
  ADD CONSTRAINT `idListSave_foreign_key` FOREIGN KEY (`idListe`) REFERENCES `listeaffichable` (`idliste`),
  ADD CONSTRAINT `loginuserListSave_foreign_key` FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateur` (`id`);

--
-- Contraintes pour la table `partage`
--
ALTER TABLE `partage`
  ADD CONSTRAINT `idPost_Foreign_key` FOREIGN KEY (`idPost`) REFERENCES `post` (`idPost`),
  ADD CONSTRAINT `login_utilisateur_foreign_key` FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
