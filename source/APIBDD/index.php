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

// changer mdp
$app->post('/change_password', 'cityXplorer\controllers\UserController:changePass')->setName("change_pass");


/**
 * POST
 */
// création d'un post
$app->post('/post', 'cityXplorer\controllers\PostController:addPost')->setName("createPost");

// obtention d'un post par son id
$app->get('/post', 'cityXplorer\controllers\PostController:getPostById')->setName("postId");

// suppression d'un post
$app->delete('/post', 'cityXplorer\controllers\PostController:delete')->setName("delete");

// obtention de tous les posts d'un user
$app->get('/postsUser', 'cityXplorer\controllers\PostController:getUserPosts')->setName("postsUser");

//Like d'un post
$app->post('/like', 'cityXplorer\controllers\PostController:like')->setName("like");

// dislike d'un post
$app->delete('/like', 'cityXplorer\controllers\PostController:dislike')->setName("dislike");

// modification d'un post
$app->put('/post', 'cityXplorer\controllers\PostController:editPost')->setName("edit_post");

// changement etat post
$app->patch('/post', 'cityXplorer\controllers\PostController:setEtat')->setName("set_etat_post");

// posts en attente
$app->get('/pending_posts', 'cityXplorer\controllers\PostController:getPendingPosts')->setName("pending_posts");

// passer un post en attente
$app->patch('/post_pending', 'cityXplorer\controllers\PostController:setPostPending')->setName("set_post_pending");

$app->get('/liked_posts', 'cityXplorer\controllers\PostController:getLikedPosts')->setName("liked_posts");


/**
 * LIST
 */

$app->get('/list', 'cityXplorer\controllers\ListController:getListById')->setName("get_list_id");
//Testé
$app->post('/list', 'cityXplorer\controllers\ListController:createList')->setName("createList");
//Non testé
$app->delete('/list', 'cityXplorer\controllers\ListController:supprimerList')->setName("deleteList");
//Testé
$app->post('/postList', 'cityXplorer\controllers\ListController:enregistrerPostList')->setName("insertPostToList");
//Testé
$app->delete('/postList', 'cityXplorer\controllers\ListController:supprimerPostList')->setName("deletePostToList");
//Non testé
$app->post('/saved_list', 'cityXplorer\controllers\ListController:likeList')->setName("likeList");
//Non testé
$app->delete('/saved_list', 'cityXplorer\controllers\ListController:dislikeList')->setName("dislikeList");

/**
 * Post from a list
 */
$app->get('/postFromList', 'cityXplorer\controllers\ListController:getPostList')->setName("postFromList");

/**
 * List of a user
 */
$app->get('/listLikedUser', 'cityXplorer\controllers\ListController:getLikedListUser')->setName("ListLikedFromUser");

$app->get('/listCreatedUser', 'cityXplorer\controllers\ListController:getCreatedListUser')->setName("ListCreatedByUser");
//Test
$app->get('/hello/{name}', function ($rq,$rs,$args) {
    echo $args['name'] ;
});


try {
    $app->run();
} catch (Throwable $e) {
}
