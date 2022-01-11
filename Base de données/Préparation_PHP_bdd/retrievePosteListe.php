<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$idListe = $_POST['idListe'];



$select="SELECT * FROM poste INNER JOIN contient ON poste.idposte=contient.idposte WHERE idListe = '".$idListe."'";
$query = mysqli_query($db,$select);
mysqli_commit($db);
if ($query) {
    $array = array(
        "result" => "Success",
    );
    echo json_encode($array);
}
