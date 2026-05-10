<?php
header("Content-Type: application/json; charset=utf-8");
include "db.php";

$mrn = isset($_POST['mrn']) ? trim($_POST['mrn']) : '';
$newDept = isset($_POST['department']) ? trim($_POST['department']) : '';

if ($mrn === '' || $newDept === '') {
    echo json_encode([
        "ok" => false,
        "message" => "MRN and target department are required"
    ]);
    exit;
}

// نجيب بيانات المريض الحالية
$stmt = $conn->prepare("SELECT department, status FROM patients WHERE mrn = ?");
$stmt->bind_param("s", $mrn);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "ok" => false,
        "message" => "Patient not found"
    ]);
    exit;
}

$row = $result->fetch_assoc();
$oldDept = $row['department'];
$patientStatus = $row['status'];

// لازم يكون المريض admitted
if ($patientStatus !== 'Admitted') {
    echo json_encode([
        "ok" => false,
        "message" => "Only admitted patients can be transferred"
    ]);
    exit;
}

// إذا نفس القسم
if ($oldDept === $newDept) {
    echo json_encode([
        "ok" => false,
        "message" => "Patient is already in this department"
    ]);
    exit;
}

// نتأكد أن القسم الجديد موجود وفيه سرير متاح
$stmt = $conn->prepare("SELECT total_beds, current_occupancy FROM departments WHERE department_name = ?");
$stmt->bind_param("s", $newDept);
$stmt->execute();
$deptResult = $stmt->get_result();

if ($deptResult->num_rows === 0) {
    echo json_encode([
        "ok" => false,
        "message" => "Target department not found"
    ]);
    exit;
}

$deptRow = $deptResult->fetch_assoc();
$totalBeds = (int)$deptRow['total_beds'];
$currentOccupancy = (int)$deptRow['current_occupancy'];

if ($currentOccupancy >= $totalBeds) {
    echo json_encode([
        "ok" => false,
        "message" => "Target department is full"
    ]);
    exit;
}

// نبدأ transaction
$conn->begin_transaction();

try {
    // تحديث قسم المريض
    $stmt = $conn->prepare("UPDATE patients SET department = ? WHERE mrn = ?");
    $stmt->bind_param("ss", $newDept, $mrn);
    $stmt->execute();

    // ننقص القديم لكن بدون ما يصير سالب
    $stmt = $conn->prepare("
        UPDATE departments
        SET current_occupancy = GREATEST(current_occupancy - 1, 0)
        WHERE department_name = ?
    ");
    $stmt->bind_param("s", $oldDept);
    $stmt->execute();

    // نزيد الجديد لكن بدون ما يتعدى total_beds
    $stmt = $conn->prepare("
        UPDATE departments
        SET current_occupancy = LEAST(current_occupancy + 1, total_beds)
        WHERE department_name = ?
    ");
    $stmt->bind_param("s", $newDept);
    $stmt->execute();

    $conn->commit();

    echo json_encode([
        "ok" => true,
        "message" => "Transfer successful"
    ]);
} catch (Exception $e) {
    $conn->rollback();

    echo json_encode([
        "ok" => false,
        "message" => "Transfer failed"
    ]);
}
?>