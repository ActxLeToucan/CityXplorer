<?php

namespace cityXplorer\controllers;
use cityXplorer\models\User;
use cityXplorer\models\Post;
use cityXplorer\models\Liste;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class ListController{
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

    public function createList(Request $rq, Response $rs, array $args): Response {
        $content = $rq->getParsedBody();


        $titre = filter_var($content['titre'], FILTER_SANITIZE_STRING);
        $desc= filter_var($content['descr']??"", FILTER_SANITIZE_STRING);
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "listPost" =>[]
        ];

        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "token"=>$content['token'],
                "listPost" => []
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
    public function enregistrerPostList(Request $rq, Response $rs, array $args): Response {
        $content = $rq->getQueryParams();

        $idPost=$content['idPost'];
        $idList=$content['idList'];

        $tab = [
            "result" => 0,
            "message" => "Erreur lors de l'insertion",
            "listPost" => []
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
                if($user->id===$list->idCreateur){
                    if($nb==0){
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
                }else{
                    $tab = [
                        "result" => 0,
                        "message" => "Vous ne pouvez pas ajouter de post à une liste likée !"
                    ];
                }

            }
        }
        return $rs->withJSON($tab, 200);
    }




    public function supprimerPostList(Request $rq, Response $rs, array $args): Response {
        $idPost = $rq->getQueryParam('idPost', -1);
        $idList = $rq->getQueryParam('idList', -1);
        $token = $rq->getQueryParam('token', '_');


        if (is_null($user = User::where("token", "=", $token)->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : token invalide",
            ], 200);
        }

        if (is_null($list = Liste::find($idList))) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Liste invalide"
            ], 200);
        }

        if (is_null($post = Post::find($idPost))) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Post invalide"
            ], 200);
        }

        if ($user != $list->creator) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : Vous n'êtes pas le créateur de cette liste, vous ne pouvez pas en supprimer le post",
            ], 200);
        }

        $nb = $list->posts->where('idPost', '=', $post->idPost)->count();

        if ($nb != 0) {
            $list->posts()->detach($post->idPost);
        }
        $nomList=$list->nomListe;


        return $rs->withJSON([
            "result" => 1,
            "message" => "Post $idPost supprimé de la liste $nomList",
        ], 200);
    }

    public function editList(Request $rq, Response $rs, array $args): Response {
        $content = $rq->getParsedBody();

        $titre = filter_var($content['titre'] ?? "Sans titre", FILTER_SANITIZE_STRING);
        $description = filter_var($content['description'] ?? "", FILTER_SANITIZE_STRING);

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide",
                "post" => null
            ], 200);
        } else if (!isset($content['id']) || is_null($list = Liste::find($content['id']))) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Id de la liste invalide",
                "post" => null
            ], 200);
        } else if ($list->idCreateur != $user->id) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Vous devez être le propriétaire de la list pour le modifier.",
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
            $list->nomListe = $titre;
            $list->descrListe = $description;
            $list->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Modifications enregistrées.",
                "post" => $list->toArray(true)
            ], 200);
        }
    }


    public function supprimerList(Request $rq, Response $rs, array $args): Response {
        $content = $rq->getQueryParams();
        $idList=$content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la suppression",
            "listPost" => []
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
                    "Post" => [] ,
                ];
                if($doesItExist==1){
                    $listToDelete=Liste::where("idListe","=",$idList)->first();

                    $listToDelete->deleteAssociations();
                    $listToDelete->delete();
                    $tab = [
                        "result" => 1,
                        "message" => "La liste à été supprimée",
                    ];
                }
            }
        }
        return $rs->withJSON($tab, 200);
    }

    // enregistrement d'une liste (= like)
    public function likeList(Request $rq,Response $rs, array $args): Response {
        $content = $rq->getParsedBody();

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : token invalide",
            ], 200);
        }

        if (!isset($content['id']) || is_null($list = Liste::where("idliste", "=", $content['id'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Liste invalide"
            ], 200);
        }

        $nb = $user->listLikes->where('idListe',"=",$list->idListe)->count();

        if($nb == 0) {
            $list->likers()->save($user);
        }

        return $rs->withJSON([
            "result" => 1,
            "message" => "Liste enregistrée"
        ], 200);
    }

    public function dislikeList(Request $rq,Response $rs, array $args): Response {
        $content = $rq->getParsedBody();

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : token invalide",
            ], 200);
        }

        if (!isset($content['id']) || is_null($list = Liste::where("idliste", "=", $content['id'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Liste invalide"
            ], 200);
        }

        $nb = $user->listLikes->where('idListe',"=",$list->idListe)->count();

        if($nb != 0) {
            $list->likers()->detach($user->id);
        }

        return $rs->withJSON([
            "result" => 1,
            "message" => "Liste retirée"
        ], 200);
    }

    public function getPostList(Request $rq,Response $rs, array $args): Response {
        $content = $rq->getQueryParams();
        $idList = $content["idList"];
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la récupération des posts de la list",
            "listPost" => []
        ];
        $list=Liste::where("idliste","=",$idList)->first();
        $t = [];
        foreach ($list->posts as $Post){
            //echo $Post;
            $t[] = $Post->toArray();
        }
        $tab =["result" => 1,
            "message" => "Récupération des posts de la list $idList",
            "listPost" => $t];
        return $rs->withJSON($tab, 200);
    }

    public function getLikedListUser(Request $rq,Response $rs, array $args): Response {
        $content = $rq->getQueryParams();
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la récupération des listes likées",
            "listPost" => []
        ];
        if(isset($content['pseudo'])){
            $user = User::where("pseudo", "=", $content['pseudo'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "listPost" => [],
            ];
            if(!is_null($user)){
                $t=[];
                foreach ($user->listLikes as $list){
                    $t[]=$list->toArray();
                }
                $tab = [
                    "result" => 1,
                    "message" => "Listes likées obtenues",
                    "listPost" => $t
                ];
            }
        }
        return $rs->withJSON($tab, 200);
    }

    public function getCreatedListUser(Request $rq,Response $rs, array $args): Response {
        $content = $rq->getQueryParams();
        $tab = [
            "result" => 0,
            "message" => "Erreur lors de la récupération des listes crées",
            "listPost" => []
        ];
        if(isset($content['pseudo'])){
            $user = User::where("pseudo", "=", $content['pseudo'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : token invalide",
                "listPost" => [],
            ];
            if(!is_null($user)){
                $t=[];
                foreach ($user->createdLists as $list){
                    $t[]=$list->toArray();
                }
                $tab = [
                    "result" => 1,
                    "message" => "Listes créées obtenues",
                    "listPost" => $t
                ];
            }
        }
        return $rs->withJSON($tab, 200);
    }

    public function getListById(Request $rq, Response $rs, array $args): Response {
        $id = $rq->getQueryParam('id', -1);
        if (is_null($list = Liste::find($id))) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Erreur : id invalide",
                "list" => null,
            ], 200);
        }
        return $rs->withJSON([
            "result" => 1,
            "message" => "Liste trouvée",
            "list" => $list->toArray(),
        ], 200);
    }
}