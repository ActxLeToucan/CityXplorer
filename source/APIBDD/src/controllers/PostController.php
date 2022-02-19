<?php

namespace cityXplorer\controllers;

use cityXplorer\models\Authenticate;
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
        $startTime=strtotime($content['date']);
        $posX=$content['posX'];
        $posY=$content['posY'];
        $descr=$content['description'];
        $titre=$content['titre'];
        $datePost=date("Y-m-d H:i:s",$startTime);
        $photo=$content['photo'];


        $tab=[];

        $user=Authenticate::where("token","=",$content['token'])->first();
        if($user!=[]){
            $PostToAdd =new Post();
            $PostToAdd->emplacementX=$posX;
            $PostToAdd->emplacementY=$posY;
            $PostToAdd->description=$descr;
            $PostToAdd->titre=$titre;
            $PostToAdd->datePost=$datePost;
            $PostToAdd->etat='Invalide';
            $PostToAdd->photo=$photo;
            $PostToAdd->idUser=$user->id;
            $PostToAdd->save();

            $Retrieve=Post::where(["titre"=>$titre,"idUser"=>$user->id])->first();



            $tab =[
                "result" => 1,
                "message" => "Insertion effectuée",
                "post" => [
                    "titre" => $titre,
                    "posX"=>$posX,
                    "posY" => $posY,
                    "descr" => $descr,
                    "date" => $datePost
                ]
            ];
        }else{
            $tab =[
                "result" => 0,
                "message" => "Erreur lors de l'insertion",
                "post" => [
                    "titre" => $titre,
                    "posX"=>$posX,
                    "posY" => $posY,
                    "descr" => $descr,
                    "date" => $datePost
                ]
            ];
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