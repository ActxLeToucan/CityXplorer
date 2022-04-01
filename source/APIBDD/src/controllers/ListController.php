<?php

namespace cityXplorer\controllers;
use cityXplorer\models\Contient;
use cityXplorer\models\EnregistreListe;
use cityXplorer\models\Like;
use cityXplorer\models\User;
use cityXplorer\models\Partage;
use cityXplorer\models\Photo;
use cityXplorer\models\Post;
use cityXplorer\models\Liste;
use cityXplorer\Conf;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class ListController{
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

    public function createList(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('createList');
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();


        $titre = filter_var($content['titre'], FILTER_SANITIZE_STRING);
        if(isset($content['decr'])){
            $desc= filter_var($content['decr'], FILTER_SANITIZE_STRING);
        }else{
            $desc="";
        }
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "list" => null
        ];
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token"=>$content['token'],
                "list" => null
            ];
            if (!is_null($user)) {
                // creation list
                $newList = new Liste();
                $newList->nomListe=$titre;
                $newList->descrListe=$desc;
                $newList->save();
                // creation pivot (pas comme le cours mais pas grave)
                $newEnregistrementList=new EnregistreListe();
                $newEnregistrementList->idListe=$newList->idListe;
                $newEnregistrementList->idUtilisateur=$user->id;
                $newEnregistrementList->save();
                //Tab retour
                $tab = [
                    "result" => 1,
                    "message" => "Insertion effectuée",
                    "list" => $newList->toArray(),
                    "sauvegarde"=> $newEnregistrementList->toArray()
                ];

            }
        }

        return $rs->withJSON($tab, 200);
    }

    public function enregistrerPostList(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('insertPostToList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();

        $idPost=$content['idPost'];
        $idList=$content['idList'];

        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "list" => null
        ];
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token" => $content['token'],
            ];
            if (!is_null($user) && isset($content['idPost']) && isset($content['idList'])) {
                $checkPost= Contient::where(["idListe" => $idList,"idPost"=>$idPost])->first();
                if(is_null($checkPost)){
                    // creation list
                    $newPostToList = new Contient();
                    $newPostToList->idListe = $idList;
                    $newPostToList->idPost = $idPost;
                    $newPostToList->tokenUser=$content['token'];
                    $newPostToList->save();

                    //Tab retour
                    $tab = [
                        "result" => 1,
                        "message" => "Insertion effectuée",
                        "post"=>$newPostToList->toArray()
                    ];
                }else{
                    $tab = [
                        "result" => 1,
                        "message" => "Post déja présent dans la liste",
                        "post"=>$checkPost->toArray()
                    ];
                }

            }
        }
        return $rs->withJSON($tab, 200);
    }
    

}