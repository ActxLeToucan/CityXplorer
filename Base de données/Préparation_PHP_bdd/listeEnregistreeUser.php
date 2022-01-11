<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$idListe = $_POST['idListe'];
$loginUser=$_POST['loginUtilisateur'];


$select="SELECT * FROM utilisateur INNER JOIN listeenregistrées ON utilisateur.login=listeenregistrées.loginutilisateur WHERE utilisateur.login = '".$loginUser."'";
$query = mysqli_query($db,$select);
mysqli_commit($db);
if ($query) {
    $array = array(
        "result" => "Success",
    );
    echo json_encode($array);
}
