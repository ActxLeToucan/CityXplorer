<?php

namespace cityXplorer\controllers;

use cityXplorer\models\User;
use cityXplorer\models\Partage;
use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Illuminate\Support\Facades\Date;

class PostController{
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
    public function addToPartageById(Request $rq,Response $rs,array $args,int $idUser,int $idPost){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor();
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $PartageToAdd=new Partage();
        $PartageToAdd->idUtilisateur=$idUser;
        $PartageToAdd->idPost=$idPost;
        $PartageToAdd->save();
    }

    /**
     * Méthode servant à ajouter un post
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return array L'état du post, ajouté ou non
     */
    public function addPost(Request $rq, Response $rs, array $args): array{
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
            if(!is_null($user)){
                // upload image
                $cheminServeur = $_FILES['photo']['tmp_name'];
                $extension = pathinfo($_FILES['photo']['name'], PATHINFO_EXTENSION);
                $fileName = time().bin2hex(openssl_random_pseudo_bytes(20)).'.'.$extension;
                $uploadFile = "/var/www/cityxplorer/img/posts/$fileName";
                move_uploaded_file($cheminServeur, $uploadFile);

                // creation post
                $newPost = new Post();
                $newPost->latitude=$latitude;
                $newPost->longitude=$longitude;
                $newPost->description=$descr;
                $newPost->titre=$titre;
                $newPost->datePost=$datePost;
                $newPost->etat='Invalide';
                $newPost->idUser=$user->id;
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
            }
        }

        return $tab;
    }

    /**
     * Méthode servant à récupérer un post avec son id
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return array Contenant les valeurs d'un post et son créateur
     */
    public function getPostById(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postId');
        $url = $base . $route_uri;

        $id = $_GET['id'];

        $postExist = Post::where("idPost","=",$id)->count();
        if ($postExist == 1) {
            $post = Post::where("idPost","=",$id)->first();
            return $post->toArray();
        } else {
            return [];
        }
    }

    /**
     * Méthode servant à récupérer les posts d'un utilisateur en particulier
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return array Contenant tous les posts de l'utilisateur
     */
    public function getUserPosts(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postsUser');
        $url = $base . $route_uri;

        $pseudo = $_GET['pseudo'];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $user = User::where("pseudo","=",$pseudo)->first();
            $tabPosts = [];
            foreach ($user->posts as $post) {
                $tabPosts[] = $post->toArray();
            }

            return $tabPosts;
        }

        return [];
    }
}
