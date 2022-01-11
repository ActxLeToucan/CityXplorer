<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$emplacementX = $_POST['emplacementX'];
$emplacementY = $_POST['emplacementY'];
$description=$_POST['description'];
$titre=$_POST['titre'];
$datePoste=$_POST['datePoste'];
$etat = $_POST['etat'];


    $insert = "INSERT INTO poste(emplacementX,emplacementY,description,titre,datePoste,etat)VALUES('".$emplacementX."','".$emplacementY."','".$description."','".$datePoste."','".$etat."')";
    $query = mysqli_query($db,$insert);
    mysqli_commit($db);
    if ($query) {
        $array = array(
            "result" => "Success",
        );
        echo json_encode($array);
    }
