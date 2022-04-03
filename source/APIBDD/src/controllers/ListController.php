<?php

namespace cityXplorer\controllers;
use cityXplorer\models\Contient;
use cityXplorer\models\EnregistreListe;
use cityXplorer\models\Like;
use cityXplorer\models\User;
use cityXplorer\models\Post;
use cityXplorer\models\Liste;
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
                $newList->creator()->associate($user);
                $newList->save();
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
                $list=Liste::where("idliste","=",$idList)->first();
                $post=Post::where("idPost","=",$idPost)->first();
                $nb = $list->posts->where('idPost', '=', $post->idPost)->count();
                if($nb == 0){
                    $list->posts()->save($post);
                    $tab = [
                        "result" => 1,
                        "message" => "Insertion effectuée"
                    ];
                }else{
                    $tab = [
                        "result" => 1,
                        "message" => "Post déja présent dans la liste"
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
                $list=Liste::where("idliste","=",$idList)->first();
                $post=Post::where("idPost","=",$idPost)->first();
                $nb = $list->posts->where('idPost', '=', $post->idPost)->count();
                $tab = [
                    "result" => 0,
                    "message" => "Erreur :le post n'est pas dans la list",
                ];
                if ($nb != 0){
                    $list->posts()->detach($post->idPost);
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
        $AllPostFromList=$temp->posts()->get();
        $res="La liste ne contiens aucun post";
        if(!is_null($AllPostFromList)){
            foreach ($AllPostFromList as $postToUnlink){
                echo $postToUnlink."\n\n";
                $temp->posts()->detach($postToUnlink->idPost);
                echo("\n Suppression");
            }
            $res= "Tout les éléments on étés supprimés";
        }
        return $res;
    }

    private function supprimerListEnregistrees(Request $rq, Response $rs, array $args, Liste $temp){
        $AllUserThatLikedList=$temp->likers()->get();
        $res="Personne n'a enregistré la list";
        if(!is_null($AllUserThatLikedList)){
            foreach ($AllUserThatLikedList as $User){
                echo $User."\n\n";
                $temp->likers()->detach($User->id);
                echo("\n Suppression");
            }
            $res= "La liste a été supprimées de chez tout le monde";
        }
        return $res;
    }
    public function likeList(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('likeList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        $idList=$content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors du like de la list",
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
                $list=Liste::where("idliste","=",$idList)->first();
                $nb = $list->likers->where('idUtilisateur', '=', $user->idUtilisateur)->count();
                $nb2=$user->listLikes->where('idListe',"=",$list->id)->count();
                if($nb == 0){ //Rentre quand même
                    $list->likers()->save($user);
                    $tab = [
                        "result" => 1,
                        "message" => "Insertion effectuée"
                    ];
                }else{
                    $tab = [
                        "result" => 1,
                        "message" => "List Déjà likée"
                    ];
                }
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
                $list=Liste::where("idliste","=",$idList)->first();
                $nb = $list->likers->where('idUtilisateur', '=', $user->idUtilisateur)->count();
                if($nb != 0){ //nb==0
                    $list->likers()->detach($user->id);
                    $tab = [
                        "result" => 1,
                        "message" => "Suppression effectuées"
                    ];
                }else{ //rentre toujours ici
                    $tab = [
                        "result" => 1,
                        "message" => "List Déjà disliké"
                    ];
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    public function getPostList(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('postFromList');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        $idList = $content["idList"];
        if(isset($content['pseudo'])){
            $user = User::where("pseudo", "=", $content['pseudo'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "pseudo" => $content['pseudo'],
            ];
            if(!is_null($user)){
                $list=Liste::where("idliste","=",$idList)->first();
                $tab =[];
                $tab["List"] = $list->nomListe;

                foreach ($list->posts as $Post){
                    //echo $Post;
                    $tab[] = $Post->toArray();
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    public function getLikedListUser(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('ListLikedFromUser');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        if(isset($content['pseudo'])){
            $user = User::where("pseudo", "=", $content['pseudo'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "user" => $content['pseudo'],
            ];
            if(!is_null($user)){
                $tab=[];

                foreach ($user->listLikes as $list){
                    $tab=$list->toArray();
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    public function getCreatedListUser(Request $rq,Response $rs, array $args){
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('ListCreatedByUser');
        $url = $base . $route_uri;
        $content = $rq->getQueryParams();
        if(isset($content['pseudo'])){
            $user = User::where("pseudo", "=", $content['pseudo'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "user" => $content['pseudo'],
            ];
            if(!is_null($user)){
                $tab=[];
                foreach ($user->createdLists as $list){
                    $tab[]=$list->toArray();
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    
    public function getAllPostList(Request $rq,Response $rs, array $args)
    {
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
                $list=Liste::where("idliste","=",$idList)->first();
                $AllPost=$list->posts()->get();
                $tab=[];
                foreach ($AllPost as $Post){
                    $tab[] = $Post->toArray();
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }
}