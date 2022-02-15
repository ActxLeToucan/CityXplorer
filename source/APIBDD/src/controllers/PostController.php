<?php

namespace cityXplorer\controllers;

use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use cityXplorer\models\Authenticate;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Illuminate\Support\Facades\Date;

class PostController{
    const CREATE_POST ='create_post';
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
    public function addPost(Request $rq, Response $rs, array $args): Response{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('createPost');
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $posX=$content['$posX'];
        $posY=$content['$posY'];
        $descr=$content['$description'];
        $titre=$content['titre'];
        $datePoste= new date();
        $photo=$content['photo'];



        $PostToAdd =new Post();
        $PostToAdd->emplacementX=$posX;
        $PostToAdd->emplacementY=$posY;
        $PostToAdd->description=$descr;
        $PostToAdd->titre=$titre;
        $PostToAdd->datePoste=$datePoste;
        $PostToAdd->etat='Invalide';
        $PostToAdd->photo=$photo;
        $PostToAdd->save();
        $rs->getBody()->write("Insertion effectuée !");
        return $rs;
    }
    public function getPost(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('getPost');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $id = 1;

        $posteTestBDD=Post::where("idPoste","=",$id)->first();
        $imagesTestBDD=Photo::where("idPost","=",$id)->get();
        $titre=$posteTestBDD->titre;
        $tab=["titre"=>$posteTestBDD->titre,
            "emplacement-x"=>$posteTestBDD->emplacementX,
            "emplacement-y"=>$posteTestBDD->emplacementY,
            "description"=>$posteTestBDD->description,
            "datePoste"=>$posteTestBDD->datePoste,
            "etat"=>$posteTestBDD->etat,
        "photos"=>$imagesTestBDD];

        return $tab;
    }
}