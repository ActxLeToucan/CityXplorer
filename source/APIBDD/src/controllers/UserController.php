<?php


namespace cityXplorer\controllers;

use cityXplorer\Conf;
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
     * @return Response
     */
    public function register(Request $rq, Response $rs, array $args): Response {
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
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop court. Réessayez.",
                "user" => null
            ], 200);
        } else if (strlen($pseudo) > self::TAILLE_PSEUDO_MAX) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom d'utilisateur est trop long. Réessayez.",
                "user" => null
            ], 200);
        } else if (preg_match(self::REGEX_PSEUDO, $pseudo) == 0) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom d'utilisateur est invalide. Réessayez.",
                "user" => null
            ], 200);
        } else if ($userNameExist != 0) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom d'utilisateur est déjà pris. Réessayez.",
                "user" => null
            ], 200);
        } else if (strlen($name) < self::TAILLE_NAME_MIN) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom est trop court. Réessayez.",
                "user" => null
            ], 200);
        } else if (strlen($name) > self::TAILLE_NAME_MAX) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom est trop long. Réessayez.",
                "user" => null
            ], 200);
        } else if (strlen($password) < self::TAILLE_MDP_MIN) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce mot de passe est trop court. Réessayez.",
                "user" => null
            ], 200);
        } else if (strlen($password) > self::TAILLE_MDP_MAX) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce mot de passe est trop long. Réessayez.",
                "user" => null
            ], 200);
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

            return $rs->withJSON([
                "result" => 1,
                "message" => "Vous êtes connecté en tant que $user->pseudo.",
                "user" => $user->toArray(true)
            ], 200);
        }
    }

    /**
     * Traitement de la connexion d'un utilisateur
     * @param Request $rq requête
     * @param Response $rs réponse
     * @param array $args arguments de la requête
     * @return Response
     */
    public function login(Request $rq, Response $rs, array $args): Response {
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

                return $rs->withJSON([
                    "result" => 1,
                    "message" => "Vous êtes connecté en tant que $user->pseudo.",
                    "user" => $user->toArray(true)
                ], 200);
            }
        }

        return $rs->withJSON([
            "result" => 0,
            "message" => "Nom d'utilisateur ou mot de passe incorrect.",
            "user" => null
        ], 200);
    }

    /**
     * Méthode servant à récupérer tout les utilisateurs dont le pseudo ressemble à celui donné
     * @param Request $rq
     * @param Response $rs
     * @param array $args
     * @return Response
     */
    public function searchUsers(Request $rq, Response $rs, array $args): Response {
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
        return $rs->withJSON($tab, 200);
    }

    public function user(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('user');
        $url = $base . $route_uri;
        $pseudo=$_GET['pseudo'];

        $userNameExist = User::where("pseudo", "=", $pseudo)->count();

        if ($userNameExist == 1) {
            $user = User::where("pseudo","=",$pseudo)->first();
                return $rs->withJSON([
                    "result" => 1,
                    "user" => $user->toArray()
                ], 200);
        }

        return $rs->withJSON([
            "result" => 0,
            "user" => null
        ], 200);

    }

    public function editUser(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('edit_user');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $name = filter_var($content['name'] ?? "name", FILTER_SANITIZE_STRING);
        $description = filter_var($content['description'] ?? "", FILTER_SANITIZE_STRING);

        if (!isset($content['token']) || is_null($user = User::where("token", "=", $content['token'])->first())) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide",
                "user" => null
            ], 200);
        } else if (strlen($name) < self::TAILLE_NAME_MIN) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce nom est trop court. Réessayez.",
                "user" => null
            ], 200);
        } else {
            $user->name = $name;
            $user->description = $description;
            $user->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Modifications enregistrées.",
                "user" => $user->toArray(true)
            ], 200);
        }
    }

    public function deleteUser(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('del_user');
        $url = $base . $route_uri;

        if (!isset($rq->getQueryParams()['token'])) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide."
            ], 200);
        }
        if (!isset($rq->getQueryParams()['pseudo'])) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Pseudo invalide."
            ], 200);
        }
        $user = User::where([
            "pseudo" => $rq->getQueryParams()['pseudo'],
            "token" => $rq->getQueryParams()['token']
        ])->first();
        if (is_null($user)) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Aucun utilisateur correspondant."
            ], 200);
        }

        foreach ($user->posts as $post) {
            foreach ($post->photos as $photo) {
                $photo->deleteFile();
                $photo->delete();
            }
            $post->delete();
        }
        foreach ($user->likes as $like) {
            $like->likedByUsers()->detach($user->id);
        }
        $user->delete();

        return $rs->withJSON([
            "result" => 1,
            "message" => "Votre compte à été supprimé."
        ], 200);
    }

    public function avatar(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('avatar');
        $url = $base . $route_uri;

        $tab = [
            "result" => 0,
            "message" => "Erreur : Modification impossible"
        ];
        $content = $rq->getParsedBody();
        if (isset($content['token'])) {
            $user = User::where("token", "=", $content['token'])->first();
            $tab = [
                "result" => 0,
                "message" => "Erreur : Token invalide"
            ];
            if (!is_null($user)) {
                if (sizeof($_FILES) == 1 && $_FILES['avatar']['error'] == 0) {
                    // upload image
                    $cheminServeur = $_FILES['avatar']['tmp_name'];
                    $extension = pathinfo($_FILES['avatar']['name'], PATHINFO_EXTENSION);
                    $fileName = time() . bin2hex(openssl_random_pseudo_bytes(20)) . '.' . $extension;
                    $uploadFile = Conf::PATH_IMAGE_AVATAR . "/$fileName";
                    move_uploaded_file($cheminServeur, $uploadFile);

                    if ($user->avatar != "" && $user->avatar != 'avatar.png' && file_exists(Conf::PATH_IMAGE_AVATAR . "/$user->avatar")) unlink(Conf::PATH_IMAGE_AVATAR . "/$user->avatar");

                    $user->avatar = $fileName;
                    $user->save();

                    // résultats
                    $tab = [
                        "result" => 1,
                        "message" => "Avatar modifié"
                    ];
                } else {
                    $tab = [
                        "result" => 0,
                        "message" => "Fichier invalide"
                    ];
                }
            }
        }

        return $rs->withJSON($tab, 200);
    }

    public function changePass(Request $rq, Response $rs, array $args): Response {
        $container = $this->c;
        $base = $rq->getUri()->getBasePath();
        $route_uri = $container->router->pathFor('change_pass');
        $url = $base . $route_uri;

        $content = $rq->getParsedBody();

        $token = $content['token'];
        $oldPassword = $content['oldPassword'];
        $newPassword = $content['newPassword'];
        $options = ['cost' => 12];

        if (!isset($content['token']) || $token == '') {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide"
            ], 200);
        }

        $user = User::where('token', '=', $token)->first();
        if (!isset($user)) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Token invalide"
            ], 200);
        }
        if (!password_verify($oldPassword, $user->password)) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Mot de passe invalide"
            ], 200);
        }


        if (strlen($newPassword) < self::TAILLE_MDP_MIN) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce mot de passe est trop court. Réessayez."
            ], 200);
        } else if (strlen($newPassword) > self::TAILLE_MDP_MAX) {
            return $rs->withJSON([
                "result" => 0,
                "message" => "Ce mot de passe est trop long. Réessayez."
            ], 200);
        } else {
            $password = password_hash($newPassword, PASSWORD_DEFAULT, $options);
            $user->password = $password;
            $user->save();

            return $rs->withJSON([
                "result" => 1,
                "message" => "Votre mot de passe été modifié."
            ], 200);
        }
    }
}