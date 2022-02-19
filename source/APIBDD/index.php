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
$app->get('/users',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new RegisterController($this);
        return $rs->withJson($controller->searchUsers($rq,$rs,$args),200);
    })->setName("users");
$app->get('/postUser',
    function (Request $rq,Response $rs, array $args):Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->getUserPost($rq,$rs,$args),200);
    })->setName("postUser");


$app->get('/hello/{name}', function ($rq,$rs,$args) {
    echo $args['name'] ;
});
try {
    $app->run();
} catch (Throwable $e) {
}
