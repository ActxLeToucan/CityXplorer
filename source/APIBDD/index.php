<?php

ini_set('display_errors', 1);

use cityXplorer\controllers\PostController;
use cityXplorer\controllers\UserController;
use cityXplorer\dbInit;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\App;


require_once __DIR__ . '/vendor/autoload.php';



$app = new App(dbInit::init());

/**
 * DOCUMENTATION
 */
$app->get('/help', function (Request $rq, Response $rs, array $args): Response {
    return $rs->withRedirect('https://documenter.getpostman.com/view/18314767/UVkgxyyz');
});
$app->get('/doc', function (Request $rq, Response $rs, array $args): Response {
    return $rs->withRedirect('https://documenter.getpostman.com/view/18314767/UVkgxyyz');
});


/**
 * USER
 */
// connexion
$app->post('/login',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new UserController($this);
        return $rs->withJson($controller->login($rq,$rs,$args),200);
    })->setName("login");
// inscription
$app->post('/register',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new UserController($this);
        return $rs->withJson($controller->register($rq,$rs,$args),200);
    })->setName("register");
// obtention d'un utilisateur
$app->get('/user',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new UserController($this);
        return $rs->withJson($controller->user($rq,$rs,$args),200);
    })->setName("user");
// recherche d'utilisateurs
$app->get('/users',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new UserController($this);
        return $rs->withJson($controller->searchUsers($rq,$rs,$args),200);
    })->setName("users");

// modification utilisateur
$app->put('/user',
    function (Request $rq, Response $rs, array $args): Response {
        $controller = new UserController($this);
        return $rs->withJson($controller->editUser($rq, $rs, $args), 200);
    })->setName("edit_user");

// suppression utilisateur
$app->delete('/user',
    function (Request $rq, Response $rs, array $args): Response {
        $controller = new UserController($this);
        return $rs->withJson($controller->deleteUser($rq, $rs, $args), 200);
    })->setName("edit_user");


/**
 * POST
 */
// création d'un post
$app->post('/post',
    function (Request $rq, Response $rs, array $args): Response {
        $controller = new PostController($this);
        return $rs->withJson($controller->addPost($rq,$rs,$args),200);
    })->setName("createPost");
// obtention d'un post par son id
$app->get('/post',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->getPostById($rq,$rs,$args),200);
    })->setName("postId");
$app->delete('/post',
    //Suppression d'un post
    function (Request $rq, Response $rs,array $args):Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->delete($rq,$rs,$args),200);
    })->setName("delete");
// obtention de tous les posts d'un user
$app->get('/postsUser',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->getUserPosts($rq,$rs,$args),200);
    })->setName("postsUser");
//Like d'un post
$app->post('/like',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->like($rq,$rs,$args),200);
    })->setName("likeUser");;
$app->delete('/like',
    function (Request $rq, Response $rs, array $args): Response{
        $controller=new PostController($this);
        return $rs->withJson($controller->dislike($rq,$rs,$args),200);
    })->setName("dislike");;


//Test
$app->get('/hello/{name}', function ($rq,$rs,$args) {
    echo $args['name'] ;
});


try {
    $app->run();
} catch (Throwable $e) {
}
