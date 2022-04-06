<?php

namespace cityXplorer\controllers;

use cityXplorer\models\User;
use cityXplorer\models\Partage;
use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use cityXplorer\Conf;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class PostController {
    const TAILLE_TITRE_MAX = 100;

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

        if (strlen($titre) > self::TAILLE_TITRE_MAX) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce titre est trop long. Réessayez.",
                "post" => null
            ], 200);
        }
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "post" => null
            ];
            if (!is_null($user)) {
                if (sizeof($_FILES) >= 1) {
                    // creation post
                    $newPost = new Post();
                    $newPost->latitude = $latitude;
                    $newPost->longitude = $longitude;
                    $newPost->description = $descr;
                    $newPost->titre = $titre;
                    $newPost->datePost = $datePost;
                    $newPost->etat = Post::ETAT_EN_ATTENTE;
                    $newPost->idUser = $user->id;
                    $newPost->adresse_courte = $adresse_courte;
                    $newPost->adresse_longue = $adresse_longue;
                    $newPost->save();

                    // creation photo
                    foreach ($_FILES as $file) {
                        if ($file['error'] != 0) {
                            return $rs->withJSON([
                                "result" => 0,
                                "message" => "Fichier invalide",
                                "post" => null
                            ], 200);
                        }

                        // upload image
                        $cheminServeur = $file['tmp_name'];
                        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
                        $fileName = time() . bin2hex(openssl_random_pseudo_bytes(20)) . '.' . $extension;
                        $uploadFile = Conf::PATH_IMAGE_POSTS . "/$fileName";
                        move_uploaded_file($cheminServeur, $uploadFile);

                        $newPhoto = new Photo();
                        $newPhoto->idPost = $newPost->idPost;
                        $newPhoto->url = $fileName;
                        $newPhoto->save();
                    }

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

        $id=$rq->getQueryParam("id", -1);

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

        if (!isset($rq->getQueryParams()['token']) || is_null($user = User::where("token", "=", $rq->getQueryParam('token'))->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide."
            ], 200);
        }
        if (!isset($rq->getQueryParams()['id']) || is_null($post = Post::where("idPost", "=", $rq->getQueryParam('id'))->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Id du post invalide."
            ], 200);
        }

        $post->deleteAssociations();
        $post->delete();

        return $rs->withJSON([
            "result" => 1,
            "message" => "Post supprimé"
        ], 200);
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
            if (strlen($titre) > self::TAILLE_TITRE_MAX) {
                return $rs->withJSON([
                    "result" => 0,
                    "message" => "Ce titre est trop long. Réessayez.",
                    "post" => null
                ], 200);
            }
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

    public function setEtat(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('set_etat_post');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $etat = filter_var($content['etat'] ?? Post::ETAT_EN_ATTENTE, FILTER_SANITIZE_NUMBER_INT);

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
        } else if ($user->niveauAcces < 2) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Permissions insuffisantes",
                "post" => null
            ], 200);
        } else {
            if ($etat != Post::ETAT_VALIDE && $etat != Post::ETAT_BLOQUE && $etat != Post::ETAT_EN_ATTENTE) {
                return $rs->withJSON([
                    "result" => 0,
                    "message" => "Etat invalide",
                    "post" => null
                ], 200);
            }
            $post->etat = $etat;
            $post->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Etat modifié",
                "post" => $post->toArray(true)
            ], 200);
        }
    }

    public function getPendingPosts(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('pending_posts');
        $url = $base . $route_uri;

        $token = $rq->getQueryParam('token', '_');
        if (is_null($user = User::where('token', '=', $token)->first())) {
            return $rs->withJSON([
                'result' => 0,
                'message' => 'Token invalide',
                'posts' => []
            ], 200);
        } else if ($user->niveauAcces < 2) {
            return $rs->withJSON([
                'result' => 0,
                'message' => 'Permissions insuffisantes',
                'posts' => []
            ], 200);
        }

        $posts = Post::where('etat', '=', Post::ETAT_EN_ATTENTE)->get();

        return $rs->withJSON([
            'result' => 1,
            'message' => sizeof($posts) . " posts en attente",
            'posts' => $posts
        ], 200);
    }

    public function setPostPending(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('set_post_pending');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

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
            if ($post->etat != Post::ETAT_BLOQUE) {
                return $rs->withJSON([
                    "result" => 0,
                    "message" => "Etat invalide",
                    "post" => null
                ], 200);
            }
            $post->etat = Post::ETAT_EN_ATTENTE;
            $post->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Etat modifié",
                "post" => $post->toArray(true)
            ], 200);
        }
    }

    public function getLikedPosts(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('liked_posts');
        $url = $base . $route_uri;

        $content = $rq->getQueryParams();
        $pseudo = $content['pseudo'];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $user = User::where("pseudo", "=", $pseudo)->first();
            $tabPosts = [];
            foreach ($user->likes as $post) {
                $tabPosts[] = $post->toArray();
            }

            return $rs->withJSON($tabPosts, 200);
        }

        return $rs->withJSON([], 200);
    }
}
