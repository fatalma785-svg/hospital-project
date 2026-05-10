<?php
// get_recommendation.php
header("Content-Type: application/json; charset=utf-8");
include 'db.php';

$mrn = isset($_GET['mrn']) ? trim($_GET['mrn']) : '';

if (!$mrn) {
    echo json_encode(["ok" => false, "message" => "MRN is required."]);
    exit;
}

// ── 1. Fetch the patient being transferred ──────────────────────────────────
$stmt = $conn->prepare("
    SELECT mrn, patient_name, age, diagnosis, dx_full,
           department, patient_status, status, adm_route, num_of_adm, los
    FROM patients
    WHERE mrn = ? AND status = 'Admitted'
    LIMIT 1
");
$stmt->bind_param("s", $mrn);
$stmt->execute();
$patient = $stmt->get_result()->fetch_assoc();

if (!$patient) {
    echo json_encode(["ok" => false, "message" => "No admitted patient found with this MRN."]);
    exit;
}

$sourceDept    = $patient['department'];
$diagnosis     = strtolower($patient['dx_full'] ?: $patient['diagnosis']);
$patientStatus = strtolower($patient['patient_status'] ?: 'stable');  // stable / critical / null
$admRoute      = strtolower($patient['adm_route'] ?: '');             // er / referral / clinic
$numAdm        = (int)($patient['num_of_adm'] ?? 1);                  // number of previous admissions
$patientLos    = (int)($patient['los'] ?? 0);                         // length of stay so far

// ── 2. Fetch departments with live occupancy ────────────────────────────────
$depts = [];
$res = $conn->query("
    SELECT
        department_name,
        total_beds,
        current_occupancy                              AS occupied,
        (total_beds - current_occupancy)               AS available,
        ROUND((current_occupancy / total_beds)*100, 1) AS occupancy_pct,
        threshold_percent
    FROM departments
");
while ($row = $res->fetch_assoc()) {
    $depts[] = $row;
}

// ── 3. Fetch per-department patient stats from the patients table ───────────
// critical_count : how many currently admitted patients are in critical status
// avg_los        : average length of stay of current patients (proxy for turnover speed)
// repeat_count   : how many patients with num_of_adm > 1 (complex cases = higher dept load)
$deptStats = [];
$statsRes = $conn->query("
    SELECT
        department,
        COUNT(*)                                        AS total_admitted,
        SUM(patient_status = 'Critical')                AS critical_count,
        ROUND(AVG(los), 1)                              AS avg_los,
        SUM(num_of_adm > 1)                             AS repeat_count
    FROM patients
    WHERE status = 'Admitted'
      AND department IS NOT NULL
    GROUP BY department
");
while ($row = $statsRes->fetch_assoc()) {
    $deptStats[$row['department']] = $row;
}

// ── 4. Specialty keyword map ────────────────────────────────────────────────
$specialtyMap = [
    'ER'  => ['fracture','trauma','emergency','injury','kidney stones','asthma','stroke','chest pain','bleeding'],
    'ICU' => ['critical','icu','ventilat','sepsis','cardiac arrest','coma'],
    'D1'  => ['pneumonia','respiratory','covid','lung','pulmonary','oxygen'],
    'D2'  => ['diabetes','hypertension','endocrin','metabolic','thyroid'],
    'D3'  => ['anemia','blood','hematol','migraine','neurol','headache','seizure'],
];

function specialtyScore($deptName, $diagnosis, $map) {
    if (!isset($map[$deptName])) return 40;
    foreach ($map[$deptName] as $keyword) {
        if (str_contains($diagnosis, $keyword)) return 100;
    }
    foreach ($map as $dept => $keywords) {
        if ($dept === $deptName) continue;
        foreach ($keywords as $keyword) {
            if (str_contains($diagnosis, $keyword)) return 20;
        }
    }
    return 50;
}

// ── 5. Score every candidate department ────────────────────────────────────
$scored = [];

foreach ($depts as $d) {
    $name      = $d['department_name'];
    $total     = (int)$d['total_beds'];
    $occupied  = (int)$d['occupied'];
    $available = (int)$d['available'];
    $occ       = (float)$d['occupancy_pct'];
    $threshold = (int)$d['threshold_percent'];

    if ($name === $sourceDept) continue;
    if ($available <= 0)       continue;

    $availRatio = $available / $total;

    // Pull live stats for this department from patients table
    $stats        = $deptStats[$name] ?? [];
    $criticalCount = (int)($stats['critical_count'] ?? 0);   // # of critical patients currently admitted
    $avgLos        = (float)($stats['avg_los']       ?? 0);  // avg LOS of current patients
    $repeatCount   = (int)($stats['repeat_count']    ?? 0);  // # of complex/repeat patients
    $totalAdmitted = (int)($stats['total_admitted']  ?? 0);  // total admitted in this dept

    // ── METRIC 1: Capacity (35%) ──────────────────────────────────────────
    // Straightforward: ratio of free beds to total beds
    $capacityScore = (int)round($availRatio * 100);

    // ── METRIC 2: Specialty match (30%) ──────────────────────────────────
    $specScore = specialtyScore($name, $diagnosis, $specialtyMap);

    // ── METRIC 3: Stability (20%) ─────────────────────────────────────────
    // Based on REAL patient data in this department:
    // - How far is occupancy from the dept's own threshold?
    // - How many critical patients are already admitted? (each one strains staff)
    // - Are patients staying long? (high avg LOS = slower bed turnover)
    $headroom = $threshold - $occ;

    $stabilityBase =
        $headroom >= 40 ? 100 :
        ($headroom >= 25 ? 82 :
        ($headroom >= 10 ? 60 :
        ($headroom >= 0  ? 30 : 5)));

    // Penalise for critical patients already in the dept (each one = -8 points, max -24)
    $criticalPenalty = min(24, $criticalCount * 8);

    // Penalise for long avg LOS — beds aren't freeing up quickly (>7 days = slow turnover)
    $losPenalty = $avgLos > 7 ? 10 : ($avgLos > 4 ? 5 : 0);

    $stabilityScore = max(5, $stabilityBase - $criticalPenalty - $losPenalty);

    // ── METRIC 4: Urgency fit (15%) ───────────────────────────────────────
    // Based on REAL patient admission data:
    // - Patient's adm_route: ER admissions are highest urgency
    // - Patient's num_of_adm: repeat admissions are complex, need careful placement
    // - Patient's patient_status: Critical/Stable
    // - Dept's current critical load: a dept already handling many critical patients
    //   is less suitable for another urgent case

    // Base urgency need from patient data
    $urgencyNeed = 0;
    if ($patientStatus === 'critical')        $urgencyNeed += 40;
    elseif ($patientStatus === 'moderate')    $urgencyNeed += 20;
    if ($admRoute === 'er')                   $urgencyNeed += 30;
    elseif ($admRoute === 'referral')         $urgencyNeed += 15;
    if ($numAdm >= 3)                         $urgencyNeed += 20; // complex repeat patient
    elseif ($numAdm === 2)                    $urgencyNeed += 10;
    // $urgencyNeed is now 0–90; higher = patient needs more careful placement

    // Dept's ability to handle an urgent patient:
    // Penalise if dept already has critical patients (staff already stretched)
    $deptUrgencyCapacity = $availRatio * 100;                      // 0–100 base
    $deptUrgencyCapacity -= min(30, $criticalCount * 10);          // -10 per critical patient already there
    $deptUrgencyCapacity -= ($repeatCount > 2 ? 10 : 0);          // complex caseload penalty
    $deptUrgencyCapacity  = max(0, $deptUrgencyCapacity);

    // High urgency need → dept capacity matters more; low urgency → any dept is fine
    $urgencyScore = (int)round(
        ($urgencyNeed / 90) * $deptUrgencyCapacity        // scales dept capacity by how urgent the patient is
        + (1 - $urgencyNeed / 90) * 85                   // stable patients get a baseline high score
    );
    $urgencyScore = min(100, max(5, $urgencyScore));

    // ── Total weighted score ──────────────────────────────────────────────
    $total_score = (int)round(
        $capacityScore  * 0.35 +
        $specScore      * 0.30 +
        $stabilityScore * 0.20 +
        $urgencyScore   * 0.15
    );

    // ── Reason tags ───────────────────────────────────────────────────────
    $reasons = [];
    if ($specScore === 100)        $reasons[] = "Specialty match";
    if ($availRatio >= 0.5)        $reasons[] = "High capacity";
    elseif ($availRatio >= 0.25)   $reasons[] = "Moderate capacity";
    if ($criticalCount === 0)      $reasons[] = "No critical patients";
    elseif ($criticalCount <= 1)   $reasons[] = "Low critical load";
    if ($headroom >= 25)           $reasons[] = "Well under threshold";
    if ($avgLos <= 4 && $avgLos > 0) $reasons[] = "Fast bed turnover";

    // ── Status label ──────────────────────────────────────────────────────
    if      ($occ >= 90) $status = "CRITICAL";
    elseif  ($occ >= 75) $status = "HIGH";
    elseif  ($occ >= 50) $status = "MODERATE";
    else                 $status = "LOW";

    $scored[] = [
        "department"      => $name,
        "total"           => $total,
        "occupied"        => $occupied,
        "available"       => $available,
        "occupancy"       => $occ,
        "status"          => $status,
        "score"           => $total_score,
        "capacity_score"  => $capacityScore,
        "specialty_score" => $specScore,
        "stability_score" => $stabilityScore,
        "urgency_score"   => $urgencyScore,
        // expose for transparency
        "critical_in_dept" => $criticalCount,
        "avg_los"          => $avgLos,
        "reasons"          => $reasons,
    ];
}

// ── 6. Sort by score descending, return top 3 ──────────────────────────────
usort($scored, fn($a, $b) => $b['score'] - $a['score']);
$top3 = array_slice($scored, 0, 3);

echo json_encode([
    "ok"      => true,
    "patient" => [
        "mrn"       => $patient['mrn'],
        "name"      => $patient['patient_name'],
        "diagnosis" => $patient['dx_full'] ?: $patient['diagnosis'],
        "status"    => $patient['patient_status'],
        "route"     => $patient['adm_route'],
        "num_adm"   => $numAdm,
        "dept"      => $sourceDept,
    ],
    "recommendations" => $top3,
]);
?>