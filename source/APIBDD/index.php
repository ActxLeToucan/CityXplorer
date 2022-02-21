<?php

ini_set('display_errors', 1);

use cityXplorer\controllers\PostController;
use cityXplorer\controllers\RegisterController;
use cityXplorer\dbInit;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\App;


require_once __DIR__ . '/vendor/autoload.php';



$app = new App(dbInit::init());

$app->get('/help', function (Request $rq, Response $rs, array $args): Response {
    return $rs->withRedirect('https://documenter.getpostman.com/view/18314767/UVkgxyyz');
});
$app->get('/doc', function (Request $rq, Response $rs, array $args): Response {
    return $rs->withRedirect('https://documenter.getpostman.com/view/18314767/UVkgxyyz');
});
/**
 * Sert à créer le post
 */

$app->post('/createPost',
    function (Request $rq, Response $rs, array $args): Response {
    $controller =new PostController($this);
    return $rs->withJson($controller->addPost($rq,$rs,$args),200);
})->setName("createPost");

$app->get('/getPost',
    function (Request $rq, Response $rs, array $args): Response {
        $controller =new PostController($this);
        //return $controller->getPost($rq,$rs,$args);
        return $rs->withJson($controller->getPost($rq,$rs,$args),200);
    })->setName("getPost");
/**
 * Sert se connecter
 */
$app->post('/login',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->login($rq,$rs,$args),200);

    })->setName("login");
/**
 * Sert à s'inscrire
 */
$app->post('/register',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->register($rq,$rs,$args),200);
    })->setName("register");
/**
 * Sert à récupérer les utilisateurs dont le nom s'approche de ce qui est donné en paramètre de l'URL
 */
$app->get('/users',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->searchUsers($rq,$rs,$args),200);
    })->setName("users");
/**
 * Sert à récupérer les post d'un utilisateurs
 */
$app->get('/postUser',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->getUserPost($rq,$rs,$args),200);
    })->setName("postUser");
/**
 * Sert à récupérer un utilisateur en get
 */

$app->get('/user',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->user($rq,$rs,$args),200);
    })->setName("user");
//Test
$app->get('/hello/{name}', function ($rq,$rs,$args) {
    echo $args['name'] ;
});
try {
    $app->run();
} catch (Throwable $e) {
}
