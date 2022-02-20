-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : Dim 20 fév. 2022 à 15:26
-- Version du serveur :  10.3.32-MariaDB-0ubuntu0.20.04.1
-- Version de PHP : 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cityxplorer`
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
(1, 2),
(1, 5);

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
(3, 1, 'zqg mkjzlkdgjz'),
(7, 21, '16453704226e4daef1c8c0a9bcf3778b9a2ad750c361bec0ec.png'),
(8, 22, '164537065693ae3b3951220e4733350eb0d5921e3139230a8b.png');

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
  `datePost` datetime DEFAULT current_timestamp(),
  `etat` varchar(10) DEFAULT NULL,
  `idUser` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `post`
--

INSERT INTO `post` (`idPost`, `emplacementX`, `emplacementY`, `description`, `titre`, `datePost`, `etat`, `idUser`) VALUES
(1, '10', '10', 'Photo de la tour de pise', 'Tour de Pise', '2021-12-28 00:00:00', 'Invalide', 0),
(2, '87', '32', 'Gare MontParnasse', 'Gare MontParnasse', '2021-12-28 00:00:00', 'Valide', 1),
(5, '10', '10', 'Voici un chateau', 'Le chateau très beau', NULL, 'Invalide', 1),
(6, NULL, NULL, NULL, 'blabla', NULL, 'Invalide', 5),
(7, NULL, NULL, NULL, 'blabla', NULL, 'Invalide', 5),
(8, '11', '11', NULL, 'blabla', NULL, 'Invalide', 5),
(9, '11', '11', 'blabla', 'blabla', NULL, 'Invalide', 5),
(10, '11', '11', 'blabla', 'blabla', '0000-00-00 00:00:00', 'Invalide', 5),
(11, '11', '11', 'blabla', 'blabla', '0000-00-00 00:00:00', 'Invalide', 5),
(12, '11', '11', 'blabla', 'blabla', '0000-00-00 00:00:00', 'Invalide', 5),
(13, '11', '11', 'blabla', 'blabla', '0000-00-00 00:00:00', 'Invalide', 5),
(14, '11', '11', 'blabla', 'blabla', '0000-00-00 00:00:00', 'Invalide', 5),
(15, '11', '11', 'blabla', 'blabla', '2011-06-10 00:00:00', 'Invalide', 5),
(21, '10', '12', 'la description', 'Un titre', '2002-12-23 23:54:09', 'Invalide', 1),
(22, '10', '12', 'la description', 'Un titre', '2002-12-23 23:54:09', 'Invalide', 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(50) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `avatar` varchar(250) NOT NULL DEFAULT 'avatar.png',
  `niveauAcces` int(5) NOT NULL DEFAULT 1,
  `token` varchar(256) NOT NULL,
  `description` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `pseudo`, `name`, `password`, `avatar`, `niveauAcces`, `token`, `description`) VALUES
(1, 'antoine54', 'Antoine CONTOUX', '$2y$12$eKIPYSrDDdmop8a7sOWIAu5EKNJdZLvdKY33kyIQd/QfGCg6l8ZIa', 'antoine.jpg', 1, '1645012186aeb999b417f2802b8341d8df60e6f303daf5b9c875a84b803eb145d8e3d8e2b649e54102141d1c8835bc8a7f0bfa3eb54189a08a4240ca1aaf8e99f9c89d0bce', ''),
(5, 'anthony', 'Anthony Nigro', 'aakjfskakf', 'avatar.png', 2, '1234', ''),
(7, 'azertyuiop', 'azertyuiop', '$2y$12$oSykPSMz83aIlH4V8aGxCe8yRJKRU5rxdXhv14Z3EicqYHirlnW1W', 'avatar.png', 1, '164535247133428dcfeb6da92fe7c92303979fe82f6a6870ba6593fce1ad7dc289dca2aba99bb3d5dd66552ad2cf4223063b84af208eb3423a7090a2517207421d5d9ee66f', ''),
(8, '150150150', '150150150', '$2y$12$1/S4I10Qte5vSbnWqvt2UOC8B.Rq2LP35cyG7L.NEVi7QZPGIFlXC', 'avatar.png', 1, '1645358530fcef283451e455fd12831692587e42ace8af7699b2f33d429ae7662011737cac6383ae2e4400e7e3ace8846bbad5c93cf5966ce48f3a211573228b4c12b1e238', ''),
(9, 'jppjppjpp', 'jppjppjpp', '$2y$12$Hnjvul3fJG.07lYARHFn5OqdmBN6dS56.ApPyb2ZW2/zCZpf.P5xu', 'avatar.png', 1, '16453591888c2fa899c96109dd4bbca3ae400411e62c0639476f1a52ce4b2df372c38b9372899d08623df413a68c811a274967b477f23f1b19302174c695a1303e072fa003', '');

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
  ADD PRIMARY KEY (`idUtilisateur`,`idPost`),
  ADD KEY `idpostvote_Foreign_key` (`idPost`);

--
-- Index pour la table `contient`
--
ALTER TABLE `contient`
  ADD PRIMARY KEY (`idListe`,`idPost`),
  ADD KEY `idpostContient_Foreign_key` (`idPost`);

--
-- Index pour la table `listeaffichable`
--
ALTER TABLE `listeaffichable`
  ADD PRIMARY KEY (`idliste`);

--
-- Index pour la table `partage`
--
ALTER TABLE `partage`
  ADD PRIMARY KEY (`idUtilisateur`,`idPost`),
  ADD KEY `idPost_Foreign_key` (`idPost`);

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
  MODIFY `idPhoto` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
-- Contraintes pour la table `partage`
--
ALTER TABLE `partage`
  ADD CONSTRAINT `idPost_Foreign_key` FOREIGN KEY (`idPost`) REFERENCES `post` (`idPost`),
  ADD CONSTRAINT `login_utilisateur_foreign_key` FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
