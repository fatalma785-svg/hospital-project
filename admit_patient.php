<?php
header("Content-Type: application/json; charset=utf-8");
include "db.php";

$mrn  = isset($_POST['mrn']) ? trim($_POST['mrn']) : '';
$dept = isset($_POST['dept']) ? trim($_POST['dept']) : '';

if ($mrn === '' || $dept === '') {
    echo json_encode([
        "ok" => false,
        "message" => "Patient MRN and department are required."
    ]);
    exit;
}

/* تحقق من وجود المريض */
$stmtPatient = $conn->prepare("SELECT mrn, status, department FROM patients WHERE mrn = ?");
$stmtPatient->bind_param("s", $mrn);
$stmtPatient->execute();
$resPatient = $stmtPatient->get_result();

if (!$resPatient || $resPatient->num_rows === 0) {
    echo json_encode([
        "ok" => false,
        "message" => "Patient not found."
    ]);
    exit;
}

$patient = $resPatient->fetch_assoc();

/* إذا المريض admitted بالفعل */
if ($patient['status'] === 'Admitted') {
    echo json_encode([
        "ok" => false,
        "message" => "Patient is already admitted."
    ]);
    exit;
}

/* تحقق من القسم والسعة */
$stmtDept = $conn->prepare("SELECT department_name, total_beds, current_occupancy FROM departments WHERE department_name = ?");
$stmtDept->bind_param("s", $dept);
$stmtDept->execute();
$resDept = $stmtDept->get_result();

if (!$resDept || $resDept->num_rows === 0) {
    echo json_encode([
        "ok" => false,
        "message" => "Department not found."
    ]);
    exit;
}

$department = $resDept->fetch_assoc();
$totalBeds = (int)$department['total_beds'];
$currentOccupancy = (int)$department['current_occupancy'];

/* إذا القسم ممتلئ */
if ($currentOccupancy >= $totalBeds) {
    echo json_encode([
        "ok" => false,
        "full" => true,
        "department" => $dept,
        "message" => "This department is full. Please go to the Department page to transfer or review another department."
    ]);
    exit;
}

/* تنفيذ عملية الإدخال */
$conn->begin_transaction();

try {
    $stmtUpdatePatient = $conn->prepare("
        UPDATE patients
        SET status = 'Admitted', department = ?
        WHERE mrn = ?
    ");
    $stmtUpdatePatient->bind_param("ss", $dept, $mrn);
    $stmtUpdatePatient->execute();

    $stmtUpdateDept = $conn->prepare("
        UPDATE departments
        SET current_occupancy = current_occupancy + 1
        WHERE department_name = ?
    ");
    $stmtUpdateDept->bind_param("s", $dept);
    $stmtUpdateDept->execute();

    $conn->commit();

    echo json_encode([
        "ok" => true,
        "message" => "Patient admitted successfully."
    ]);
} catch (Exception $e) {
    $conn->rollback();

    echo json_encode([
        "ok" => false,
        "message" => "Admit failed."
    ]);
}
?>