<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$idPoste = $_POST['idPoste'];


$update="UPDATE poste SET poste.etat='Valide' WHERE idPoste ='".$idPoste."'";
$query = mysqli_query($db,$update);
mysqli_commit($db);
if ($query) {
    $array = array(
        "result" => "Success",
    );
    echo json_encode($array);
}
