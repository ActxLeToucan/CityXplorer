<?php

ini_set('display_errors', 1);

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
$app->post('/login', 'cityXplorer\controllers\UserController:login')->setName("login");
// inscription
$app->post('/register', 'cityXplorer\controllers\UserController:register')->setName("register");
// obtention d'un utilisateur
$app->get('/user', 'cityXplorer\controllers\UserController:user')->setName("user");
// recherche d'utilisateurs
$app->get('/users', 'cityXplorer\controllers\UserController:searchUsers')->setName("users");

// modification utilisateur
$app->put('/user', 'cityXplorer\controllers\UserController:editUser')->setName("edit_user");

// suppression utilisateur
$app->delete('/user', 'cityXplorer\controllers\UserController:deleteUser')->setName("del_user");

// ajout avatar
$app->post('/avatar', 'cityXplorer\controllers\UserController:avatar')->setName("avatar");


/**
 * POST
 */
// création d'un post
$app->post('/post', 'cityXplorer\controllers\PostController:addPost')->setName("createPost");
// obtention d'un post par son id
$app->get('/post', 'cityXplorer\controllers\PostController:getPostById')->setName("postId");

$app->delete('/post', 'cityXplorer\controllers\PostController:delete')->setName("delete");
// obtention de tous les posts d'un user
$app->get('/postsUser', 'cityXplorer\controllers\PostController:getUserPosts')->setName("postsUser");
//Like d'un post
$app->post('/like', 'cityXplorer\controllers\PostController:like')->setName("likeUser");

$app->delete('/like', 'cityXplorer\controllers\PostController:dislike')->setName("dislike");;


//Test
$app->get('/hello/{name}', function ($rq,$rs,$args) {
    echo $args['name'] ;
});


try {
    $app->run();
} catch (Throwable $e) {
}
