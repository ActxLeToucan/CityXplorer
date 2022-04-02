-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : sam. 02 avr. 2022 à 18:13
-- Version du serveur : 10.3.34-MariaDB-0ubuntu0.20.04.1
-- Version de PHP : 8.1.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
-- Structure de la table `avotepour`
--

CREATE TABLE `avotepour` (
  `idUtilisateur` int(11) NOT NULL,
  `idPost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `avotepour`
--

INSERT INTO `avotepour` (`idUtilisateur`, `idPost`) VALUES
(1, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `contient`
--

CREATE TABLE `contient` (
  `idListe` int(11) NOT NULL,
  `idPost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `liste`
--

CREATE TABLE `liste` (
  `idListe` int(11) NOT NULL,
  `nomListe` varchar(100) NOT NULL,
  `descrList` text NOT NULL,
  `idCreateur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `listeEnregistrees`
--

CREATE TABLE `listeEnregistrees` (
  `idListe` int(11) NOT NULL,
  `idUtilisateur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `photo`
--

CREATE TABLE `photo` (
  `idPhoto` int(11) NOT NULL,
  `idPost` int(11) NOT NULL,
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
  `idPost` int(11) NOT NULL,
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
(1, 'antoine54', 'Antoine CONTOUX ', '$2y$12$..kCLAsL72YnrhzEX8s3w.1U82HpOTGZ5ByXVXPkGzIxApv1JwFn6', '1648737607e86f882fc9d9a218aa8269aaf51c0d24d6bfe7fd.jpg', 1, '1645012186aeb999b417f2802b8341d8df60e6f303daf5b9c875a84b803eb145d8e3d8e2b649e54102141d1c8835bc8a7f0bfa3eb54189a08a4240ca1aaf8e99f9c89d0bce', '@L_ipsum Lorem ipsum @antoine54 dolor sit amet, consectetur adipiscing elit. Phasellus venenatis, sem a bibendum imperdiet, neque est maximus mi, ac cursus orci risus vel libero. Etiam sit amet tortor bibendum, volutpat diam ac, cursus purus. Nam ut sem rutrum, auctor dui vitae, facilisis leo. Pellentesque congue lorem gravida, consectetur sem id. '),
(2, 'L_ipsum', 'L. Ipsum', '$2y$12$Va1y9BKWkoj3nbUxFUCituJe/I1eZQ2hjj50Qcf1wjBfJgKheksHm', 'avatar.png', 2, '164582581805eab74e442667887a95dc9bb23b8a549f4a8fa78dd45e4df7154f9e9ed6d388d9486f14d3277ed08523ca90987047db53ef4ce28ce17be535506395a04b4133', ''),
(3, 'nepasoublier', 'Alexis', '$2y$12$sHXSt3Wdt8KtKVJPFMXfE.Lm9AZSmyOa4hA2uNzAU/6QOiS4auQPK', 'avatar.png', 2, '1647089887991b172a3d8e1393ea82454fb6b7643e38b07a339d94bab04d63d11586a5747bb8688553c5f3bee457a8362d065706d82498b30bb713d3a3f6cc1a1a4d2cefe7', '');

--
-- Index pour les tables déchargées
--

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
-- Index pour la table `liste`
--
ALTER TABLE `liste`
  ADD PRIMARY KEY (`idListe`);

--
-- Index pour la table `listeEnregistrees`
--
ALTER TABLE `listeEnregistrees`
  ADD PRIMARY KEY (`idListe`,`idUtilisateur`);

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
-- AUTO_INCREMENT pour la table `liste`
--
ALTER TABLE `liste`
  MODIFY `idListe` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `photo`
--
ALTER TABLE `photo`
  MODIFY `idPhoto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `post`
--
ALTER TABLE `post`
  MODIFY `idPost` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
