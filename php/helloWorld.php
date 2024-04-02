<?php

require 'db.php';

// api.php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Simulate data retrieval
    $data = ['message' => 'Hello, World!'];
    echo json_encode($data);
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Method Not Allowed']);
}
?>
