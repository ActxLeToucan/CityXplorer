<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$etat=$_POST['etat'];


$select="SELECT * FROM poste WHERE etat = '".$etat."'";
$query = mysqli_query($db,$select);
mysqli_commit($db);
if ($query) {
    $array = array(
        "result" => "Success",
    );
    echo json_encode($array);
}
