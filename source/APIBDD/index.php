<?php

use cityXplorer\controllers\PostController;
use cityXplorer\controllers\RegisterController;
use cityXplorer\dbInit;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\App;


require_once __DIR__ . '/vendor/autoload.php';



$app = new App(dbInit::init());

$app->post('/createPost',
    function (Request $rq, Response $rs, array $args): Response {
    $controller =new PostController($this);
    return $controller->addPost($rq,$rs,$args);
})->setName("createItem");

$app->get('/getPost',
    function (Request $rq, Response $rs, array $args): Response {
        $controller =new PostController($this);
        //return $controller->getPost($rq,$rs,$args);
        return $rs->withJson($controller->getPost($rq,$rs,$args),200);
    })->setName("getPost");

$app->post('/login',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->login($rq,$rs,$args),200);

    })->setName("login");
$app->post('/register',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->register($rq,$rs,$args),200);
    })->setName("register");

try {
    $app->run();
} catch (Throwable $e) {
}
