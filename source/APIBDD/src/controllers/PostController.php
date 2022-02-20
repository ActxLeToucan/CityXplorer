<?php

namespace cityXplorer\controllers;

use cityXplorer\models\Authenticate;
use cityXplorer\models\Partage;
use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Illuminate\Support\Facades\Date;
use function MongoDB\BSON\toJSON;

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
    
    public function addPost(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('createPost');
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $startTime = strtotime($content['date']);
        $posX = filter_var($content['posX'], FILTER_SANITIZE_NUMBER_FLOAT);
        $posY = filter_var($content['posY'], FILTER_SANITIZE_NUMBER_FLOAT);
        $descr = filter_var($content['description'], FILTER_SANITIZE_STRING);
        $titre = filter_var($content['titre'], FILTER_SANITIZE_STRING);
        $datePost = date("Y-m-d H:i:s", $startTime);

        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "post" => null
        ];

        if (isset($content['token'])) {
            $user = Authenticate::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "post" => null
            ];
            if(!is_null($user)){
                // upload image
                $extension = $_FILES['photo']['type'];
                $cheminServeur = $_FILES['photo']['tmp_name'];
                $fileName = str_replace('image/', time().bin2hex(openssl_random_pseudo_bytes(20)).'.', $extension);
                $uploadFile = "/var/www/cityxplorer/img/posts/$fileName";
                move_uploaded_file($cheminServeur, $uploadFile);

                // creation post
                $newPost = new Post();
                $newPost->emplacementX=$posX;
                $newPost->emplacementY=$posY;
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

                // récupérations de toutes les photos
                $tabPhotos = [];
                foreach ($newPost->photos as $photo) {
                    $tabPhotos[] = $photo->url;
                }

                // résultats
                $tab =[
                    "result" => 1,
                    "message" => "Insertion effectuée",
                    "post" => [
                        "titre" => $titre,
                        "posX"=>$posX,
                        "posY" => $posY,
                        "descr" => $descr,
                        "date" => $datePost,
                        "photos" => $tabPhotos
                    ]
                ];
            }
        }

        return $tab;
    }

    public function getPost(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('getPost');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $id = 1;

        $postTestBDD=Post::where("idPost","=",$id)->first();
        $imagesTestBDD=Photo::where("idPost","=",$id)->get();
        $titre=$postTestBDD->titre;
        $tab=["titre"=>$postTestBDD->titre,
            "emplacement-x"=>$postTestBDD->emplacementX,
            "emplacement-y"=>$postTestBDD->emplacementY,
            "description"=>$postTestBDD->description,
            "datePost"=>$postTestBDD->datePost,
            "etat"=>$postTestBDD->etat,
        "photos"=>$imagesTestBDD];

        return $tab;
    }
    public function getUserWhoCreatedPostById(Request $rq, Response $rs, array $args,int $id){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('getPost');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $PostPartage=Partage::where("idPost","=",$id)->first();
        $Userid=$PostPartage->idUtilisateur;
        $Utilisateur=Authenticate::where("id","=",$Userid)->first();
        $Username=$Utilisateur->pseudo;
        return $Username;
    }
    public function getPostById(Request $rq, Response $rs, array $args,int $id): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('getPost');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();


        $postTestBDD=Post::where("idPost","=",$id)->first();
        $imagesTestBDD=Photo::where("idPost","=",$id)->get();
        $tab=[];
        foreach ($imagesTestBDD as $value){
            array_push($tab,$value->url);
        }
        $titre=$postTestBDD->titre;
        $tab=[
            "titre"=>$postTestBDD->titre,
            "idPost"=>$postTestBDD->idPost,
            "photos"=>$tab,
            "datePost"=>$postTestBDD->datePost,
            "emplacement-x"=>$postTestBDD->emplacementX,
            "emplacement-y"=>$postTestBDD->emplacementY,
            "description"=>$postTestBDD->description,
            "user-pseudo"=>$this->getUserWhoCreatedPostById($rq,$rs,$args,$id),
            "etat"=>$postTestBDD->etat,
            "iduser"=>$postTestBDD->idUser
            ];

        return $tab;
    }
    public function getUserPost(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postUser');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $usernameToGetPost=$_GET['pseudo'];

        $user=Authenticate::where("pseudo","=",$usernameToGetPost)->first();
        $id=$user->id;
        $PostFromUser=Post::where("idUser","=",$id)->get();
        $tab=[];
        foreach ($PostFromUser as $value){
            array_push($tab,$this->getPostById($rq,$rs,$args,$value->idPost));
        }
        return $tab;
    }
}
//