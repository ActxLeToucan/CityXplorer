-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : lun. 21 fév. 2022 à 23:51
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
(1, 1, '1.jpg'),
(2, 2, '2.jpg'),
(3, 1, '3.jpg'),
(7, 21, '16453704226e4daef1c8c0a9bcf3778b9a2ad750c361bec0ec.png'),
(9, 23, '164542972228f2dfcfa06995e3fff25355065d1e93cbd46a26.jpeg'),
(11, 25, '1645430934f5c3e69013d262277c6f80c4c75416b77074524e.jpeg'),
(14, 28, '16454618845d8a55f451570498a8cb399a9840fc7ae0899b73.jpg'),
(15, 29, '16454620838706d2ef030c6970e62ddb76dc8f6a67b00b3ddc.jpg'),
(16, 30, '164546218771667aaa918e2110530138d234cfe7538c3e548d.jpg'),
(17, 31, '164546238474dadc4147ea5d1e9324a39418d854c204ec10ea.jpg'),
(18, 32, '16454624174e7553ce2088d8050f9bcab9c1ad7091cfe6bf95.jpg'),
(19, 33, '164546266787a2f4461776f12a0b02207b569ee017afdbbee8.jpg'),
(20, 34, '1645464223b2b8711e011f2b553d5d60b94b3046a53463417e.jpg'),
(21, 35, '1645464617624efee4e9b3a060aed103927d58ebddb7bb2eae.jpg'),
(22, 36, '16454666469966461ed8badb968cb29eb1c3acd079a4faf746.jpg'),
(23, 37, '1645466860d5f06c94b190c83e766ee4d05f636f09bc26d0da.jpg'),
(24, 38, '1645466932cee1559feebb1fea326f116a9066c0aa1f20a15a.jpg'),
(25, 39, '16454686166f9011e4b6120efca4ca0699f38ddc1913133427.jpg'),
(26, 40, '1645469556e2cd6fdf5bedb860c7bf3cbc8e45b3b2cc043855.jpg'),
(27, 41, '1645469725607f97f58fda261e29fb07b0cc56c6468b2beb32.jpg'),
(28, 42, '164547426277a50dda47021a153b24912ddc946c57b9aa0c0a.jpg'),
(29, 43, '1645474301390bf0c1566ff2305a31c0ab665f58c926c91807.jpg'),
(30, 44, '1645474652e5ad704fcffb84c80a325ab3f06d6c52567f34b5.jpg'),
(31, 45, '1645474861db4d4b3ded6834623b4f67f75cd672215b1db467.jpg'),
(32, 46, '164547547313d06b4dfeaf8202eb052680968592c4554d499d.jpg'),
(33, 47, '1645476017b62ac90fa73ce85bb00cc1524927eb41374c6a58.jpg'),
(34, 48, '1645476888624a7edd760913c8c23edf0fb8f8db40f2965b1e.jpg'),
(35, 49, '1645476993e8090586ba41f0d61c8bbe7e6a920f3d15c7c0c5.jpg'),
(36, 50, '164547715895547d99b972f8458832921a94cdb531bdb8eecc.jpg'),
(37, 51, '1645477188cc0b47b51ce8998e2db554deeda84230ee3bb9ef.jpg'),
(38, 52, '16454772225c3cabd7e4fcf3c85afe973caea2ce67fc8e13aa.jpg'),
(39, 53, '1645477621c0e0b1c3bb63cd6767e9ceabe2862ad1b5616aea.jpg'),
(40, 54, '1645477676d378ad21e160f90194afe2a50fc4677b47dc355f.jpg'),
(41, 55, '1645477676c391035904380e6822c3c2e25b6f184f17830e09.jpg'),
(42, 56, '1645477676e03ee08bc91b359e79f38c8b99f1945e0d4404cd.jpg'),
(43, 57, '1645478439df11850bb9c9b73d1abf3a16e9a069e3be350cde.jpg'),
(44, 58, '164547910744e21bd9d9c0819adb1a3e9e86d7816822a0865b.jpg'),
(45, 59, '16454821593396118c4ccda5a0d80a93e54f4fb21fb7f5749a.png');

-- --------------------------------------------------------

--
-- Structure de la table `post`
--

CREATE TABLE `post` (
  `idPost` int(5) NOT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `titre` varchar(100) DEFAULT NULL,
  `datePost` datetime DEFAULT current_timestamp(),
  `etat` varchar(10) DEFAULT NULL,
  `idUser` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `post`
--

INSERT INTO `post` (`idPost`, `latitude`, `longitude`, `description`, `titre`, `datePost`, `etat`, `idUser`) VALUES
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
(23, '486685508', '61651552', 'ladescription\n', 'letitre', '2022-02-21 08:48:37', 'Invalide', 8),
(25, '486676775', '61651302', 'si il te plait', 'dieu vas y', '2022-02-21 09:08:49', 'Invalide', 8),
(28, '486676735', '61652276', 'au test\n', 'test', '2022-02-21 17:44:37', 'Invalide', 8),
(29, '486676687', '61650795', 'au test\n', 'test2', '2022-02-21 17:47:56', 'Invalide', 8),
(30, '486685508', '61651552', 'au test\n', 'test3', '2022-02-21 17:49:41', 'Invalide', 8),
(31, '486676732', '61651093', 'au test\n', 'test4 ou5 jsp', '2022-02-21 17:53:01', 'Invalide', 8),
(32, '486685508', '61651552', 'au test\n', 'test6', '2022-02-21 17:53:33', 'Invalide', 8),
(33, '48667687', '61650502', '', 'test sans description', '2022-02-21 17:57:44', 'Invalide', 8),
(34, '486677', '61650211', '', 'test 8', '2022-02-21 18:23:39', 'Invalide', 8),
(35, '486677053', '61650137', '', 'test 9', '2022-02-21 18:30:13', 'Invalide', 8),
(36, '486677132', '61649846', 'codecode', 'code', '2022-02-21 19:04:03', 'Invalide', 8),
(37, '486677228', '61649686', 'codecode', 'code', '2022-02-21 19:07:36', 'Invalide', 8),
(38, '486677228', '61649686', 'codecode', 'code', '2022-02-21 19:08:48', 'Invalide', 8),
(39, '486677165', '61649942', 'codecode', 'genial', '2022-02-21 19:36:52', 'Invalide', 8),
(40, '486677141', '61649654', '00', '160', '2022-02-21 19:52:33', 'Invalide', 8),
(41, '486677176', '61649803', 'flute', 'ça avance l interface', '2022-02-21 19:55:22', 'Invalide', 8),
(42, '486677162', '6164989', 'flute', 'ça avance de fou', '2022-02-21 21:10:59', 'Invalide', 8),
(43, '486677182', '61649845', 'flute', 'ça avance de fou', '2022-02-21 21:11:37', 'Invalide', 8),
(44, '486687707', '61610502', 'flute', 'ça avance de fou', '2022-02-21 21:17:28', 'Invalide', 8),
(45, '486677119', '61650152', 'flute', 'ça avance de fou genre vraiment', '2022-02-21 21:20:59', 'Invalide', 8),
(46, '486677153', '61649629', 'testetestetste', 'un autre test', '2022-02-21 21:31:08', 'Invalide', 8),
(47, '486677129', '61649887', '09\n', '000', '2022-02-21 21:40:13', 'Invalide', 8),
(48, '486677161', '61649808', '09\n', '000', '2022-02-21 21:54:39', 'Invalide', 8),
(49, '486687707', '61610502', '09\n', '000', '2022-02-21 21:56:16', 'Invalide', 8),
(50, '486677155', '61649746', '666\n', '777', '2022-02-21 21:59:14', 'Invalide', 8),
(51, '486687707', '61610502', '666\n', '777', '2022-02-21 21:59:44', 'Invalide', 8),
(52, '486687707', '61610502', '666\n', '777', '2022-02-21 22:00:18', 'Invalide', 8),
(53, '486677175', '61649919', '666\n', '777', '2022-02-21 22:06:57', 'Invalide', 8),
(54, '486687707', '61610502', '666\n', '777', '2022-02-21 22:07:44', 'Invalide', 8),
(55, '486687707', '61610502', '666\n', '777', '2022-02-21 22:07:44', 'Invalide', 8),
(56, '486687707', '61610502', '666\n', '777', '2022-02-21 22:07:44', 'Invalide', 8),
(57, '486677139', '61649798', '99', '888', '2022-02-21 22:20:35', 'Invalide', 8),
(58, '486677149', '61649778', 'ii', 'test localisation', '2022-02-21 22:31:43', 'Invalide', 8),
(59, '48.8571506', '2.288133', 'Célèbre tour en fer de Gustave Eiffel (1889), terrasses panoramiques accessibles par escaliers et ascenseurs.', 'Tour Eiffel', '2011-06-10 00:00:00', 'Invalide', 1);

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
  MODIFY `idPhoto` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

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
