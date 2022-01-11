<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$loginUser=$_POST['loginUtilisateur'];


$select="SELECT * FROM utilisateur INNER JOIN AVotePour ON utilisateur.login=AVotePour.loginutilisateur WHERE utilisateur.login = '".$loginUser."'";
$query = mysqli_query($db,$select);
mysqli_commit($db);
if ($query) {
    $array = array(
        "result" => "Success",
    );
    echo json_encode($array);
}
