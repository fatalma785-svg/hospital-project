<?php
header("Content-Type: application/json; charset=utf-8");
include 'db.php';

$mrn = isset($_GET['mrn']) ? trim($_GET['mrn']) : '';

if ($mrn === '') {
    echo json_encode(["ok" => false]);
    exit;
}

$stmt = $conn->prepare("SELECT patient_name, diagnosis, age, status, department FROM patients WHERE mrn = ?");
$stmt->bind_param("s", $mrn);
$stmt->execute();
$res = $stmt->get_result();

if ($res && $res->num_rows > 0) {
    $row = $res->fetch_assoc();
    echo json_encode([
        "ok" => true,
        "name" => $row['patient_name'],
        "diagnosis" => $row['diagnosis'],
        "age" => $row['age'],
        "status" => $row['status'],
        "department" => $row['department']
    ]);
} else {
    echo json_encode(["ok" => false]);
}
?>