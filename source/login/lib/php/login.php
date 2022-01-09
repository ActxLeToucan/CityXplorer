<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM userdata WHERE username = '".$username."' AND password = '".$password."'";


//echo json_encode($password);


$result = mysqli_query($db,$sql);


$count = mysqli_num_rows($result);

if ($count == 1) {
    $array = array(
        "result" => "1",
    );
    echo json_encode($array);
}else{
    $array = array(
        "result" => "0",
    );
    echo json_encode($array);
}


