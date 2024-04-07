<?php
session_start(); // Start the session

// Include db.php for database connection
require_once 'db.php';

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $conn->real_escape_string($_POST['email']);
    $password = $_POST['password'];

    if (!empty($email) && !empty($password)) {
        // Look for the user by email
        $query = "SELECT user_id FROM Users WHERE email = '$email'";
        $result = $conn->query($query);

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            $user_id = $user['user_id'];

            // Get hashed password from UserAuth
            $authQuery = "SELECT password_hash FROM UserAuth WHERE user_id = '$user_id'";
            $authResult = $conn->query($authQuery);

            if ($authResult->num_rows > 0) {
                $auth = $authResult->fetch_assoc();
                if (password_verify($password, $auth['password_hash'])) {
                    // Password is correct
                    $_SESSION['user_id'] = $user_id; // Set session variable
                    header("Location: welcome.php"); // Redirect to a logged-in page
                } else {
                    echo "Incorrect password!";
                }
            } else {
                echo "Authentication failed!";
            }
        } else {
            echo "User not found!";
        }
    } else {
        echo "Email and password are required!";
    }
}
?>
