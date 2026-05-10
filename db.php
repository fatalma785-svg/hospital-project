<?php
$servername = "mysql.railway.internal";
$username = "root";
$password = "xyeLrNzhIZfDhCPALeysdEUPhzMtQVVa"; // Default XAMPP password is empty
$dbname = "railway"; // This must match the name in phpMyAdmin
$port       = "3306"; // 

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>