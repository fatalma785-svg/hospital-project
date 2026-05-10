<?php
header("Content-Type: application/json; charset=utf-8");
include 'db.php';

$sql = "SELECT mrn, patient_name, department
        FROM patients
        WHERE status='Admitted'
        ORDER BY patient_name ASC";

$res = $conn->query($sql);
$data = [];

while ($row = $res->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>