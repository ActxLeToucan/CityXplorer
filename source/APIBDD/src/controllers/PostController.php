<?php

namespace cityXplorer\controllers;

use cityXplorer\models\Like;
use cityXplorer\models\User;
use cityXplorer\models\Partage;
use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use cityXplorer\Conf;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class PostController {
    /**
     * @var object container
     */
    private object $c;

    /**
     * Constructeur d'ItemController
     * @param object $c container
     */
    public function __construct(object $c) {
        $this->c = $c;
    }

    /**
     * Méthode servant à ajouter des valeurs à la table partage
     * @param Request $rq Requete
     * @param Response $rs Reponse
     * @param array $args Array
     * @param int $idUser Id de l'utilisateur à associer au post
     * @param int $idPost Id du post associé à l'utilisateur
     */
    public function addToPartageById(Request $rq, Response $rs, array $args, int $idUser, int $idPost) {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor();
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $PartageToAdd = new Partage();
        $PartageToAdd->idUtilisateur = $idUser;
        $PartageToAdd->idPost = $idPost;
        $PartageToAdd->save();
    }

    /**
     * Méthode servant à ajouter un post
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return Response
     */
    public function addPost(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('createPost');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $startTime = strtotime($content['date']);
        $latitude = filter_var($content['latitude'], FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
        $longitude = filter_var($content['longitude'], FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_FRACTION);
        $descr = filter_var($content['description'], FILTER_SANITIZE_STRING);
        $titre = filter_var($content['titre'], FILTER_SANITIZE_STRING);
        $adresse_courte = filter_var($content['adresse-courte'], FILTER_SANITIZE_STRING);
        $adresse_longue = filter_var($content['adresse-longue'], FILTER_SANITIZE_STRING);
        $datePost = date("Y-m-d H:i:s", $startTime);

        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "post" => null
        ];
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "post" => null
            ];
            if (!is_null($user)) {
                if (sizeof($_FILES) == 1 && $_FILES['photo']['error'] == 0) {
                    // upload image
                    $cheminServeur = $_FILES['photo']['tmp_name'];
                    $extension = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
                    $fileName = time() . bin2hex(openssl_random_pseudo_bytes(20)) . '.' . $extension;
                    $uploadFile = Conf::PATH_IMAGE_POSTS . "/$fileName";
                    move_uploaded_file($cheminServeur, $uploadFile);

                    // creation post
                    $newPost = new Post();
                    $newPost->latitude = $latitude;
                    $newPost->longitude = $longitude;
                    $newPost->description = $descr;
                    $newPost->titre = $titre;
                    $newPost->datePost = $datePost;
                    $newPost->etat = 'Invalide';
                    $newPost->idUser = $user->id;
                    $newPost->adresse_courte = $adresse_courte;
                    $newPost->adresse_longue = $adresse_longue;
                    $newPost->save();

                    // creation photo
                    $newPhoto = new Photo();
                    $newPhoto->idPost = $newPost->idPost;
                    $newPhoto->url = $fileName;
                    $newPhoto->save();

                    // résultats
                    $tab = [
                        "result" => 1,
                        "message" => "Insertion effectuée",
                        "post" => $newPost->toArray()
                    ];
                } else {
                    $tab = [
                        "result" => 0,
                        "message" => "Fichier invalide",
                        "post" => null
                    ];
                }
            }
        }

        return $rs->withJSON($tab, 200);
    }

    /**
     * Méthode servant à récupérer un post avec son id
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return Response
     */
    public function getPostById(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postId');
        $url = $base . $route_uri;

        $content=$rq->getQueryParams();
        $id = $content['id'];

        $postExist = Post::where("idPost", "=", $id)->count();
        if ($postExist == 1) {
            $post = Post::where("idPost","=",$id)->first();
            return $rs->withJSON([
                'result' => 1,
                'post' => $post->toArray()
            ], 200);
        } else {
            return $rs->withJSON([
                'result' => 0,
                'post' => null
            ], 200);
        }
    }

    /**
     * Méthode servant à récupérer les posts d'un utilisateur en particulier
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return Response
     */
    public function getUserPosts(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postsUser');
        $url = $base . $route_uri;

        $content = $rq->getQueryParams();
        $pseudo = $content['pseudo'];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $user = User::where("pseudo", "=", $pseudo)->first();
            $tabPosts = [];
            foreach ($user->posts as $post) {
                $tabPosts[] = $post->toArray();
            }

            return $rs->withJSON($tabPosts, 200);
        }

        return $rs->withJSON([], 200);
    }

    public function delete(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('delete');
        $url = $base . $route_uri;

        $content= $rq->getQueryParams();
        $token = $content["token"];
        $idPost = $content["id"];
        $userExist = User::where("token", "=", $token)->count();
        $post = Post::where("idPost", "=", $idPost)->first();

        if (!isset($rq->getQueryParams()['token']) || is_null($post) || !isset($rq->getQueryParams()['id']) || $userExist != 1) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : id ou token invalide",
                "1" => $rq->getQueryParams()['token'],
                "2" => is_null($post),
                "3" => !isset($rq->getQueryParams()['id'])
            ], 200);
        } else {
            $photos = Photo::where("idPost", "=", $idPost)->get();
            foreach ($photos as $image) {
                $image->deleteFile();
                $image->delete();
            }
            $post->delete();
            return $rs->withJSON([
                "result" => 1,
                "message" => "Post Supprimé"
            ], 200);
        }
    }


    public function like(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('like');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide"
            ], 200);
        }

        if (!isset($content['id']) || is_null($post = Post::where("idPost", "=", $content['id'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Post invalide"
            ], 200);
        }

        $nb = $user->likes->where('idPost', '=', $post->idPost)->count();

        if ($nb == 0) {
            $user->likes()->save($post);
        }

        return $rs->withJSON([
            "result" => 1,
            "message" => "Post liké"
        ], 200);
    }

    public function dislike(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('dislike');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide"
            ], 200);
        }

        if (!isset($content['id']) || is_null($post = Post::where("idPost", "=", $content['id'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Post invalide"
            ], 200);
        }

        $nb = $user->likes->where('idPost', '=', $post->idPost)->count();

        if ($nb != 0) {
            $user->likes()->detach($post->idPost);
        }

        return $rs->withJSON([
            "result" => 1,
            "message" => "Post disliké"
        ], 200);
    }

    public function editPost(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('edit_post');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $titre = filter_var($content['titre'] ?? "Sans titre", FILTER_SANITIZE_STRING);
        $description = filter_var($content['description'] ?? "", FILTER_SANITIZE_STRING);

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide",
                "post" => null
            ], 200);
        } else if (!isset($content['id']) || is_null($post = Post::find($content['id']))) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Id du post invalide",
                "post" => null
            ], 200);
        } else if ($post->user != $user) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Vous devez être le propriétaire de post pour le modifier.",
                "post" => null
            ], 200);
        } else {
            $post->titre = $titre;
            $post->description = $description;
            $post->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Modifications enregistrées.",
                "post" => $post->toArray(true)
            ], 200);
        }
    }
}
