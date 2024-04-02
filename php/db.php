<?php
$servername = "localhost";
$username = "dev";
$password = "Password1!";
$database = "event_management_system";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
