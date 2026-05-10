<?php
header("Content-Type: application/json; charset=utf-8");
include 'db.php';

$totalBeds = 80;

$sql = "SELECT COUNT(*) as occupied FROM patients WHERE status='Admitted'";
$res = $conn->query($sql);
$row = $res->fetch_assoc();

$occupied = (int)$row['occupied'];
$available = $totalBeds - $occupied;
if ($available < 0) $available = 0;

$rate = $totalBeds > 0 ? round(($occupied / $totalBeds) * 100) : 0;

echo json_encode([
    "totalBeds" => $totalBeds,
    "occupied" => $occupied,
    "available" => $available,
    "rate" => $rate
]);
?>