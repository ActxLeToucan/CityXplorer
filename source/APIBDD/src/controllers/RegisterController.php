<?php


namespace cityXplorer\controllers;

use cityXplorer\models\Authenticate;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

class RegisterController {
    const TAILLE_USERNAME_MIN = 4;
    const TAILLE_USERNAME_MAX = 50;
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

        $username = filter_var($content['username'], FILTER_SANITIZE_STRING);
        $password = $content['password'];
        $options = ['cost' => 12];
        $email = filter_var($content['email'], FILTER_SANITIZE_EMAIL);

        $userNameExist = Authenticate::where("login", "=", $username)->count();

        if (strlen($username) < self::TAILLE_USERNAME_MIN) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop court. Réessayez.",
                "user" => null
            ];
        } else if (strlen($username) > self::TAILLE_USERNAME_MAX) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop long. Réessayez.",
                "user" => null
            ];
        } else if ($userNameExist != 0) {
            return [
                "result" => 0,
                "message" => "Ce nom d'utilisateur est déjà pris. Réessayez.",
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
            $newUser = new Authenticate();
            $newUser->login=$username;
            $newUser->motDePasse=$password;
            $newUser->email=$email;
            $newUser->niveauAcces=1;
            $newUser->save();

            $user = Authenticate::where('login', '=', $username)->first();

            return [
                "result" => 1,
                "message" => "Vous êtes connecté en tant que $user->login.",
                "user" => [
                    "pseudo" => $user->login,
                    "email" => $user->email,
                    "photo" => $user->photoDeProfil,
                    "niveauAcces" => $user->niveauAcces
                ]
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

        $username =$content['username'];
        $password =$content['password'];
        $userNameExist = Authenticate::where("login", "=", $username)->count();

        if ($userNameExist == 1) {
            $getUser=Authenticate::where("login","=",$username)->first();
            $hashedPassword=$getUser->motDePasse;
            if (password_verify($password,$hashedPassword)) {
                $user = Authenticate::where('login', '=', $username)->first();

                return [
                    "result" => 1,
                    "message" => "Vous êtes connecté en tant que $user->login.",
                    "user" => [
                        "pseudo" => $user->login,
                        "email" => $user->email,
                        "photo" => $user->photoDeProfil,
                        "niveauAcces" => $user->niveauAcces
                    ]
                ];
            }
        }

        return [
            "result" => 0,
            "message" => "Nom d'utilisateur ou mot de passe incorrect.",
            "user" => null
        ];
    }
}