<?php
$db = mysqli_connect('localhost','flutter','flutter','fluttertestlogin');
if (!$db) {
    echo "Database connection fail";
}

$username = $_POST['username'];
$password = $_POST['password'];
$email = $_POST['email'];

$sql = "SELECT username FROM userdata WHERE username = '".$username."'";

$result = mysqli_query($db,$sql);

$count = mysqli_num_rows($result);

if ($count == 1) {
    $array = array(
        "result" => "Error",
    );
    echo json_encode($array);
}else{
    $insert = "INSERT INTO userdata(username,password,email)VALUES('".$username."','".$password."','".$email."')";
    //$insert = "INSERT INTO userdata(username,password,email)VALUES('antoine','1234','allogmail')";
    $query = mysqli_query($db,$insert);
    mysqli_commit($db);
    if ($query) {
        $array = array(
            "result" => "Success",
        );
        echo json_encode($array);
    }
}
