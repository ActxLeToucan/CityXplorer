<?php

namespace cityXplorer\controllers;
use cityXplorer\models\Contient;
use cityXplorer\models\CreateurList;
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
                $newList->creator()->associate($user);
                $tab = [
                    "result" => 1,
                    "message" => "Insertion effectuée",
                    "list" => $newList->toArray(),
                ];

            }
        }

        return $rs->withJSON($tab, 200);
    }
    //Vérifier que ça existe
    //Vérifier l'utilisateur de la list
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
                    $list=Liste::where("idListe","=",$idList);
                    $post=Post::find($idPost);
                    $list->posts()->save($post);
                    //Tab retour
                    $tab = [
                        "result" => 1,
                        "message" => "Insertion effectuée",
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








    public function supprimerPostList(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('deletePostToList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();

        $idPost=$content['idPost'];



        $idList=$content['idList'];



        $list=Liste::where("idListe","=",$idList)->first();
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "list/post" => null
        ];
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token" => $content['token'],
            ];
            if(!is_null($user)){
                $doesItExist=Contient::where(["idListe" => $idList,"idPost"=>$idPost])->count();
                $tab = [
                    "result" => 0,
                    "message" => "Erreur :le post n'est pas dans la list",
                ];
                if ($doesItExist==1){
                    $postToDelete=Contient::where(["idListe" => $idList,"idPost"=>$idPost])->first();
                    echo ("\n\n\n");
                    echo($postToDelete->toArray());
                    echo ("\n\n\n\n Id du Post à supprimer" .$postToDelete->idPost." \n Combien de poste à supprimer :$doesItExist");
                    $postToDelete->delete();
                    $nomList=$list->nomListe;
                    $tab = [
                        "result" => 1,
                        "message" => "Post {$idPost} supprimé de la liste {$nomList}",
                    ];
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }








    public function supprimerList(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('deleteList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        $idList=$content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la suppression",
            "list/post" => null
        ];
        if(isset($content['token'])){
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token" => $content['token'],
            ];
            if(!is_null($user)){
                $doesItExist= Liste::where("idListe","=",$idList)->count();
                $tab = [
                    "result" => 0,
                    "message" => "La liste n'existe pas",
                    "Post" => null ,
                ];
                if($doesItExist==1){
                    $listToDelete=Liste::where("idListe","=",$idList)->first();
                    $suppLink=$this->supprimerTouteLiaisonListPost($rq, $rs, $args, $listToDelete);
                    $suppEnr= $this->supprimerListEnregistrees($rq,$rs,$args,$listToDelete);
                    $listToDelete->delete();
                    $tab = [
                        "result" => 1,
                        "message" => "La liste à été supprimée",
                        "Post" => null ,
                        "Suppression Liaison" => $suppLink,
                        "Suppression Enregistrement " =>$suppEnr
                    ];
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    private function supprimerTouteLiaisonListPost(Request $rq, Response $rs, array $args, Liste $temp){
        $AllPostFromList=Contient::where("idListe","=",$temp->id)->get();
        $res="La liste ne contiens aucun post";
        if(!is_null($AllPostFromList)){
            foreach ($AllPostFromList as $postToUnlink){
                $postToUnlink->delete();
                echo("\n Suppression");
            }
            $res= "Tout les éléments on étés supprimés";
        }
        return $res;
    }

    private function supprimerListEnregistrees(Request $rq, Response $rs, array $args, Liste $temp){
        $AllPostFromList=EnregistreListe::where("idListe","=",$temp->id)->get();
        $res="Personne n'a enregistré la list";
        if(!is_null($AllPostFromList)){
            foreach ($AllPostFromList as $listToUnlink){
                $listToUnlink->delete();
                echo("\n Suppression");
            }
            $res= "La liste a été suppriméed de chez tout le monde";
        }
        return $res;
    }
    //DoesItExist
    public function likeList(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('likeList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        $idList=$content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la suppression",
            "list/post" => null
        ];
        if(isset($content['token'])){
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token" => $content['token'],
            ];
            if(!is_null($user)){
                $newEnregistrementList=new EnregistreListe();
                $newEnregistrementList->idListe=$idList;
                $newEnregistrementList->idUtilisateur=$user->id;
                $newEnregistrementList->save();
                $tab = [
                    "result" => 1,
                    "message" => "Insertion effectuée",
                    "sauvegarde"=> $newEnregistrementList->toArray()
                ];
            }
        }
        return $rs->withJSON($tab, 200);
    }
    //Does it exist
    public function dislikeList(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('dislikeList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        $idList=$content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la suppression",
            "list/post" => null
        ];
        if(isset($content['token'])){
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token" => $content['token'],
            ];
            if(!is_null($user)){
                $EnregistrementList=EnregistreListe::where(["idListe" => $idList,"idUtilisateur"=>$user->id]);
                $EnregistrementList->delete();
                $tab = [
                    "result" => 1,
                    "message" => "Suppression effectuée",
                    "sauvegarde"=> null
                ];
            }
        }
        return $rs->withJSON($tab, 200);
    }
}