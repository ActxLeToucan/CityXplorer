-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 25 fév. 2022 à 22:20
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

-- --------------------------------------------------------

--
-- Structure de la table `listeaffichable`
--

CREATE TABLE `listeaffichable` (
  `idliste` int(5) NOT NULL,
  `nomListe` varchar(50) DEFAULT NULL,
  `descriptionListe` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(1, 1, 'exemples/stan1.jpg'),
(2, 1, 'exemples/stan2.jpg'),
(3, 2, 'exemples/musee-ecole.jpg'),
(4, 3, 'exemples/pep.jpg'),
(5, 4, 'exemples/craffe.jpg'),
(6, 5, 'exemples/eiffel.jpg'),
(7, 6, 'exemples/resto.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `post`
--

CREATE TABLE `post` (
  `idPost` int(5) NOT NULL,
  `latitude` double NOT NULL DEFAULT 0,
  `longitude` double NOT NULL DEFAULT 0,
  `description` text NOT NULL DEFAULT '',
  `titre` varchar(100) NOT NULL DEFAULT '',
  `datePost` datetime NOT NULL DEFAULT current_timestamp(),
  `etat` varchar(10) NOT NULL DEFAULT '',
  `idUser` int(5) NOT NULL,
  `adresse_courte` text DEFAULT '',
  `adresse_longue` text DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `post`
--

INSERT INTO `post` (`idPost`, `latitude`, `longitude`, `description`, `titre`, `datePost`, `etat`, `idUser`, `adresse_courte`, `adresse_longue`) VALUES
(1, 48.693618, 6.183241, 'La place Stanislas est une place appartenant à un ensemble urbain classique situé à Nancy, dans la région historique de la Lorraine, en France, qui est inscrit au patrimoine mondial de l\'UNESCO. Voulue par le duc de Lorraine Stanislas Leszczyński.', 'Place Stan', '2021-07-15 22:30:22', 'Valide', 1, 'Nancy, France', 'Pl. Stanislas, 54000 Nancy, France'),
(2, 48.68053, 6.166169, 'Le musée de l\'École de Nancy est un musée situé à Nancy et consacré au courant artistique de l\'Art nouveau nancéien connu sous le nom d\'École de Nancy. Aménagé dans l\'ancienne propriété d\'Eugène Corbin, grand mécène du mouvement, il a été officiellement ouvert au public, sous sa forme actuelle en 1964. Dans le jardin du musée se trouve un aquarium, classé monument historique, une porte réalisée pour les usines d\'Émile Gallé ainsi qu\'un monument funéraire.', 'Musée de l\'École de Nancy', '2022-02-25 11:39:18', 'Valide', 1, 'Nancy, France', '38 Rue Sergent Blandan, 54000 Nancy, France'),
(3, 48.697786, 6.18461, 'Le parc de la Pépinière est un jardin public de Nancy.', 'Parc de la Pépinière', '2022-02-26 07:44:40', 'Valide', 1, 'Nancy, France', 'Parc de la Pépinière, Parc de la pepinière, 54000 Nancy, France'),
(4, 48.698872, 6.177816, 'La porte de la Craffe est une porte de Nancy, imposant vestige des fortifications médiévales, érigée au XIVe siècle au nord de la ville-vieille.', 'Porte de la Craffe', '2022-02-08 13:53:14', 'Valide', 2, 'Nancy, France', '54000 Nancy, France'),
(5, 48.85837, 2.294481, 'La tour Eiffel est une tour de fer puddlé de 324 mètres de hauteur (avec antennes)o 1 située à Paris, à l’extrémité nord-ouest du parc du Champ-de-Mars en bordure de la Seine dans le 7e arrondissement. Son adresse officielle est 5, avenue Anatole-France. ', 'Tour Eiffel', '2022-02-26 08:57:37', 'Valide', 2, 'Paris, France', 'Champ de Mars, 5 Av. Anatole France, 75007 Paris, France'),
(6, 48.696938, 6.179149, 'Super restaurant à Nancy', 'Resto', '2022-02-26 09:03:09', 'Valide', 1, 'Nancy, France', '2 rue Saint Michel, 54000 Nancy France');

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
(2, 'L_ipsum', 'L. Ipsum', '$2y$12$Va1y9BKWkoj3nbUxFUCituJe/I1eZQ2hjj50Qcf1wjBfJgKheksHm', 'avatar.png', 2, '164582581805eab74e442667887a95dc9bb23b8a549f4a8fa78dd45e4df7154f9e9ed6d388d9486f14d3277ed08523ca90987047db53ef4ce28ce17be535506395a04b4133', '');

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
  ADD PRIMARY KEY (`idListe`,`idPost`);

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
  MODIFY `idliste` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `photo`
--
ALTER TABLE `photo`
  MODIFY `idPhoto` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
-- Contraintes pour la table `partage`
--
ALTER TABLE `partage`
  ADD CONSTRAINT `idPost_Foreign_key` FOREIGN KEY (`idPost`) REFERENCES `post` (`idPost`),
  ADD CONSTRAINT `login_utilisateur_foreign_key` FOREIGN KEY (`idUtilisateur`) REFERENCES `utilisateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
