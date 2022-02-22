-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mar. 22 fév. 2022 à 19:28
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
(1, 2, '1.jpg'),
(2, 2, '2.jpg'),
(3, 1, '3.jpg'),
(7, 21, '16453704226e4daef1c8c0a9bcf3778b9a2ad750c361bec0ec.png'),
(80, 94, '16455466221bba4f05cc37d76d5b456e8ac0248c0a7fe4cc49.jpg'),
(81, 95, '16455466244474480d63ba77c6ac13e0b0bc4af3e884d879ba.jpg'),
(82, 96, '164554662690d88fdac4e176b6c938ae88ee5bd660f8c4f2cf.jpg'),
(83, 97, '1645546627925964503e31709e63a3a8c816261d79a52f7d43.jpg'),
(84, 98, '164554662711d1d46905b2b9a14c91c47570e76ca105f779b0.jpg'),
(85, 99, '16455466290ca812ff83d12fc8d02f3c46c4ba5308d7464daa.jpg'),
(86, 100, '1645546633ebfea7e3ddc46e0ae8e72401778a79978552ed70.jpg'),
(87, 101, '16455466394fb6d847c7764e0446efb8a628ee90a19b3d638c.jpg'),
(88, 102, '16455466446f9b0c7260e06b3bab40299a809d440bf052a033.jpg'),
(89, 103, '16455466456f1aa251e6b16582bfe3226af9a689627d437fc3.jpg'),
(90, 104, '1645546646244ec3fa5dc283b62030240ec7288dcab813de53.jpg'),
(91, 105, '1645546647e7fee1a252580fe32b441b050c8d78f7df0d5bbc.jpg'),
(92, 106, '1645546648e4a4aab810d9d710efb297b0da12bcf066b36575.jpg'),
(93, 107, '1645546648bf069e49b1c4303a4afc9b8cae99b9064289da29.jpg'),
(94, 108, '164554664920b24736d6885e62abc101570670b56c6b841a04.jpg'),
(95, 109, '164554665085f7b03b15b04f66e710fb8ea7e7c407ced06429.jpg'),
(96, 110, '1645546650d0da3843ef06e3023720eebe51068fc4f436fa8f.jpg'),
(97, 111, '1645546650b772a779a65eb185711a08b0b6e1f906b8257025.jpg'),
(98, 112, '16455466505681941fb2b466cf6127c238f2c1bb6707fc9a92.jpg'),
(99, 113, '1645546650145b09edda822a22c4485d3645000718e0ae0df9.jpg'),
(100, 114, '1645546652eeb6da246507a26f4475c8143bee7e5f10f428bc.jpg'),
(101, 115, '16455466531685197f7c284fd6f60079af2b6dd63178b450e1.jpg'),
(102, 116, '1645546654b297002f7c15f72f628740a594ac16f4a0f9dfde.jpg'),
(103, 117, '1645546654537d6f6434e605580bfd6befb8852e6619d53ac9.jpg'),
(104, 118, '16455466557f926103b5313a5389a6c9dbe889bc5f3f75c3b6.jpg'),
(105, 119, '1645546655635522777d8aadfc1a373380879c7f311eb98086.jpg'),
(106, 120, '16455466553a67011e8b72363a321a26e9be5cb6abdf1c1c7f.jpg'),
(107, 121, '16455466554526fe942a8f3cb9ed6b6e6b688f3312019afa51.jpg'),
(108, 122, '1645547668e1abb2cf6ea84889b07cc216fada04799ceb73a1.jpg'),
(109, 123, '1645547932bf04cee783e935c315ca9e26a614562c1a470ef1.jpg'),
(110, 124, '16455480979da3bf560881b01c712f4b2a666d6a9a031e9242.jpg'),
(111, 125, '16455482044049655e19e8d38788364e2722a5a13989520878.jpg'),
(112, 126, '164555755374f2157588de57cbe63eba95cd60b2ae54dfd286.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `post`
--

CREATE TABLE `post` (
  `idPost` int(5) NOT NULL,
  `latitude` double NOT NULL DEFAULT 0,
  `longitude` double NOT NULL DEFAULT 0,
  `description` varchar(200) NOT NULL DEFAULT '',
  `titre` varchar(100) NOT NULL DEFAULT '',
  `datePost` datetime NOT NULL DEFAULT current_timestamp(),
  `etat` varchar(10) NOT NULL DEFAULT '',
  `idUser` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `post`
--

INSERT INTO `post` (`idPost`, `latitude`, `longitude`, `description`, `titre`, `datePost`, `etat`, `idUser`) VALUES
(1, 10, 10, 'Photo de la tour de pise', 'Tour de Pise', '2021-12-28 00:00:00', 'Invalide', 0),
(2, 87, 32, 'Gare MontParnasse', 'Gare MontParnasse', '2021-12-28 00:00:00', 'Valide', 1),
(5, 10, 10, 'Voici un chateau', 'Le chateau très beau', '2011-06-10 00:00:00', 'Invalide', 1),
(15, 11, 11, 'blabla', 'blabla', '2011-06-10 00:00:00', 'Invalide', 5),
(21, 10, 12, 'la description', 'Un titre', '2002-12-23 23:54:09', 'Invalide', 1),
(59, 48.85715103149414, 2.288132905960083, 'Célèbre tour en fer de Gustave Eiffel (1889), terrasses panoramiques accessibles par escaliers et ascenseurs.', 'Tour Eiffel', '2011-06-10 00:00:00', 'Invalide', 1),
(126, 48.6842585, 6.1743528, 'Cette app finalement... ', 'flutter', '2022-02-22 20:19:13', 'Invalide', 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(50) NOT NULL,
  `name` varchar(256) NOT NULL DEFAULT '',
  `password` varchar(256) NOT NULL DEFAULT '',
  `avatar` varchar(250) DEFAULT 'avatar.png',
  `niveauAcces` int(5) NOT NULL DEFAULT 1,
  `token` varchar(256) NOT NULL,
  `description` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `pseudo`, `name`, `password`, `avatar`, `niveauAcces`, `token`, `description`) VALUES
(1, 'antoine54', 'Antoine CONTOUX', '$2y$12$eKIPYSrDDdmop8a7sOWIAu5EKNJdZLvdKY33kyIQd/QfGCg6l8ZIa', 'antoine.jpg', 1, '1645012186aeb999b417f2802b8341d8df60e6f303daf5b9c875a84b803eb145d8e3d8e2b649e54102141d1c8835bc8a7f0bfa3eb54189a08a4240ca1aaf8e99f9c89d0bce', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nisi odio, ullamcorper ac metus vel, hendrerit varius dolor. Nullam lacinia eleifend sapien, quis dignissim leo tempor eu. Integer egestas ipsum eu dolor rhoncus, sit amet dapibus enim consectetur. Nam scelerisque a tortor sodales iaculis. Nulla ut quam in augue iaculis laoreet eget vehicula justo. In augue arcu, dapibus quis magna sed, faucibus scelerisque nibh. Etiam accumsan id libero facilisis accumsan. Nam malesuada at nisl nec convallis. Nunc maximus dui ut justo sodales malesuada. '),
(5, 'anthony', 'Anthony Nigro', 'aakjfskakf', 'avatar.png', 2, '1234', ''),
(7, 'azertyuiop', 'azertyuiop', '$2y$12$oSykPSMz83aIlH4V8aGxCe8yRJKRU5rxdXhv14Z3EicqYHirlnW1W', 'avatar.png', 1, '164535247133428dcfeb6da92fe7c92303979fe82f6a6870ba6593fce1ad7dc289dca2aba99bb3d5dd66552ad2cf4223063b84af208eb3423a7090a2517207421d5d9ee66f', '');

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
  MODIFY `idPhoto` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
