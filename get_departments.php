<?php
header("Content-Type: application/json; charset=utf-8");
include "db.php";

$result = mysqli_query($conn, "SELECT * FROM departments ORDER BY department_name ASC");
$data = [];

while ($row = mysqli_fetch_assoc($result)) {
    $total = (int)$row['total_beds'];
    $occupied = (int)$row['current_occupancy'];
    $available = $total - $occupied;
    if ($available < 0) $available = 0;

    $percent = $total > 0 ? ($occupied / $total) * 100 : 0;

    if ($percent >= 90) {
        $status = "CRITICAL";
    } elseif ($percent >= (int)$row['threshold_percent']) {
        $status = "HIGH";
    } elseif ($percent >= 50) {
        $status = "MODERATE";
    } else {
        $status = "LOW";
    }

    $data[] = [
        "department" => $row['department_name'],
        "total" => $total,
        "occupied" => $occupied,
        "available" => $available,
        "occupancy" => round($percent),
        "status" => $status
    ];
}

echo json_encode($data);
?>