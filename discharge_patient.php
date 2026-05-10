<?php
header("Content-Type: application/json; charset=utf-8");
include "db.php";

$mrn = $_POST['mrn'];

// نجيب القسم
$result = $conn->query("SELECT department FROM patients WHERE mrn='$mrn'");
$row = $result->fetch_assoc();

if (!$row) {
    echo json_encode(["ok"=>false,"message"=>"Patient not found"]);
    exit;
}

$dept = $row['department'];

// تحديث المريض
$updatePatient = $conn->query("
UPDATE patients 
SET status='Discharged', department=NULL 
WHERE mrn='$mrn'
");

// تحديث القسم
$updateDept = $conn->query("
UPDATE departments 
SET current_occupancy = current_occupancy - 1 
WHERE department_name='$dept'
");

if ($updatePatient && $updateDept) {
    echo json_encode(["ok"=>true,"message"=>"Patient discharged"]);
} else {
    echo json_encode(["ok"=>false,"message"=>"Discharge failed"]);
}
?>