<?php


namespace cityXplorer\controllers;

use cityXplorer\models\User;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class UserController {
    const TAILLE_PSEUDO_MIN = 4;
    const TAILLE_PSEUDO_MAX = 50;
    const REGEX_PSEUDO = '/^[\w\-]*$/';
    const TAILLE_NAME_MIN = 4;
    const TAILLE_NAME_MAX = 50;
    const TAILLE_MDP_MIN = 8;
    const TAILLE_MDP_MAX = 256;


    /**
     * @var object container
     */
    private object $c;

    /**
     * Constructeur d'ItemController
     * @param object $c container
     */
    public function __construct(object $c) {
        $this->c=$c;
    }

    /**
     * Traitement de l'inscription d'un utilisateur
     * @param Request $rq requête
     * @param Response $rs réponse
     * @param array $args arguments de la requête
     * @return array
     */
    public function register(Request $rq, Response $rs, array $args): array {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('register');
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $pseudo = filter_var($content['pseudo'], FILTER_SANITIZE_STRING);
        $password = $content['password'];
        $name = $content['name'];
        $options = ['cost' => 12];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if (strlen($pseudo) < self::TAILLE_PSEUDO_MIN) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop court. Réessayez.",
                "user" => null
            ];
        } else if (strlen($pseudo) > self::TAILLE_PSEUDO_MAX) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop long. Réessayez.",
                "user" => null
            ];
        } else if (preg_match(self::REGEX_PSEUDO, $pseudo) == 0) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est invalide. Réessayez.",
                "user" => null
            ];
        } else if ($userNameExist != 0) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est déjà pris. Réessayez.",
                "user" => null
            ];
        } else if (strlen($name) < self::TAILLE_NAME_MIN) {
            return [
                "result" => 0,
                "message" => "Ce nom est trop court. Réessayez.",
                "user" => null
            ];
        } else if (strlen($name) > self::TAILLE_NAME_MAX) {
            return [
                "result" => 0,
                "message" => "Ce nom est trop long. Réessayez.",
                "user" => null
            ];
        } else if (strlen($password) < self::TAILLE_MDP_MIN) {
            return [
                "result" => 0,
                "message" => "Ce mot de passe est trop court. Réessayez.",
                "user" => null
            ];
        } else if (strlen($password) > self::TAILLE_MDP_MAX) {
            return [
                "result" => 0,
                "message" => "Ce mot de passe est trop long. Réessayez.",
                "user" => null
            ];
        } else {
            $password = password_hash($password, PASSWORD_DEFAULT, $options);
            $newUser = new User();
            $newUser->pseudo = $pseudo;
            $newUser->password = $password;
            $newUser->name = $name;
            $newUser->niveauAcces = 1;
            $newUser->token = time().bin2hex(openssl_random_pseudo_bytes(64));
            $newUser->save();

            $user = User::where('pseudo', '=', $pseudo)->first();

            return [
                "result" => 1,
                "message" => "Vous êtes connecté en tant que $user->pseudo.",
                "user" => $user->toArray(true)
            ];
        }
    }

    /**
     * Traitement de la connexion d'un utilisateur
     * @param Request $rq requête
     * @param Response $rs réponse
     * @param array $args arguments de la requête
     * @return array
     */
    public function login(Request $rq, Response $rs, array $args): array {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('login');
        $url = $base . $route_uri;
        $content = $rq->getParsedBody();

        $pseudo = $content['pseudo'];
        $password = $content['password'];
        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $getUser=User::where("pseudo","=",$pseudo)->first();
            $hashedPassword=$getUser->password;
            if (password_verify($password,$hashedPassword)) {
                $user = User::where('pseudo', '=', $pseudo)->first();

                return [
                    "result" => 1,
                    "message" => "Vous êtes connecté en tant que $user->pseudo.",
                    "user" => $user->toArray(true)
                ];
            }
        }

        return [
            "result" => 0,
            "message" => "Nom d'utilisateur ou mot de passe incorrect.",
            "user" => null
        ];
    }

    /**
     * Méthode servant à récupérer tout les utilisateurs dont le pseudo ressemble à celui donné
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return array Contenant toutes les caractéristiques des personnes trouvées
     */
    public function searchUsers(Request $rq, Response $rs, array $args): array{
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('users');
        $url = $base . $route_uri;

        if (isset($_GET['q']) && $_GET['q'] !== "") {
            $usernameToSearch = '%'.$_GET["q"].'%';
            $users = User::where("pseudo","like",strtolower($usernameToSearch))->get();
            $tab=[];
            foreach ($users as $user) {
                $tab[] = $user->toArray();
            }
        } else {
            $tab = [];
        }
        return $tab;
    }

    public function user(Request $rq, Response $rs, array $args): array {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('user');
        $url = $base . $route_uri;
        $pseudo=$_GET['pseudo'];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $user = User::where("pseudo","=",$pseudo)->first();
                return [
                    "result" => 1,
                    "user" => $user->toArray()
                ];
        }

        return [
            "result" => 0,
            "user" => null
        ];

    }

    // TODO
    public function editUser(Request $rq, Response $rs, array $args): array {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('edit_user');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody(); // marche pas
        echo $content ?? "\nnull\n";

        $token = $content['token'];
        $name = filter_var($content['name'], FILTER_SANITIZE_STRING);
        $description = filter_var($content['description'], FILTER_SANITIZE_STRING);

        $userNameExist = User::where("token", "=", $token)->count();

        if ($userNameExist != 1) {
            return [
                "result" => 0,
                "message" => "Token invalide",
                "user" => null
            ];
        } else if (strlen($name) < self::TAILLE_NAME_MIN) {
            return [
                "result" => 0,
                "message" => "Ce nom est trop court. Réessayez.",
                "user" => null
            ];
        } else {
            $user = User::where('token', '=', $token)->first();
            $user->name = $name;
            $user->description = $description;
            $user->save();

            return [
                "result" => 1,
                "message" => "Modifications enregistrées.",
                "user" => $user->toArray(true)
            ];
        }
    }

    public function deleteUser(Request $rq, Response $rs, array $args): array {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('del_user');
        $url = $base . $route_uri;

        if (!isset($rq->getQueryParams()['token'])) {
            return [
                "result" => 0,
                "message" => "Token invalide."
            ];
        }
        if (!isset($rq->getQueryParams()['pseudo'])) {
            return [
                "result" => 0,
                "message" => "Pseudo invalide."
            ];
        }
        $user = User::where([
            "pseudo" => $rq->getQueryParams()['pseudo'],
            "token" => $rq->getQueryParams()['token']
        ])->first();
        if (is_null($user)) {
            return [
                "result" => 0,
                "message" => "Aucun utilisateur correspondant."
            ];
        }

        $user->delete();
        return [
            "result" => 1,
            "message" => "Votre compte à été supprimé."
        ];
    }
}