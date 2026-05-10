// NGH_capacity.js  (full file — replaces your existing one)

let isFirstLoad = true;
let previousFullDepartments = {};

// ─────────────────────────────────────────────
// Department table + summary cards
// ─────────────────────────────────────────────
function loadDepartments() {
    fetch("get_departments.php")
        .then(res => res.json())
        .then(data => {
            let table = "";
            let totalBeds = 0;
            let totalAvailable = 0;
            let criticalCount = 0;
            let options = '<option value="">Select target department</option>';
            let currentFullDepartments = {};

            data.forEach(d => {
                totalBeds      += Number(d.total);
                totalAvailable += Number(d.available);

                if (String(d.status).toUpperCase() === "CRITICAL") criticalCount++;

                table += `
                    <tr>
                        <td>${d.department}</td>
                        <td>${d.total}</td>
                        <td>${d.occupied}</td>
                        <td>${d.available}</td>
                        <td>${d.occupancy}%</td>
                        <td><span class="chip chip-${String(d.status).toLowerCase()}">${d.status}</span></td>
                        <td>
                            <button class="btn btn-light small-btn"
                                onclick="selectDept('${d.department}')">Select</button>
                        </td>
                    </tr>
                `;

                if (Number(d.available) > 0) {
                    options += `<option value="${d.department}">${d.department}</option>`;
                }

                if (Number(d.occupancy) >= 100) {
                    currentFullDepartments[d.department] = Number(d.occupancy);
                }
            });

            document.getElementById("deptTable").innerHTML    = table;
            document.getElementById("totalDept").innerText    = data.length;
            document.getElementById("totalBeds").innerText    = totalBeds;
            document.getElementById("totalAvailable").innerText = totalAvailable;
            document.getElementById("targetDept").innerHTML   = options;

            // Critical card colour
            const countElem = document.getElementById("criticalCount");
            const cardElem  = document.getElementById("criticalCard");
            if (countElem) countElem.innerText = criticalCount;
            if (cardElem) {
                const palette = [
                    { bg: "#ffffff", text: "#000000" },
                    { bg: "#d4edda", text: "#155724" },
                    { bg: "#fff3cd", text: "#856404" },
                    { bg: "#ffe0b2", text: "#8a4b00" },
                    { bg: "#f8d7da", text: "#721c24" },
                ];
                const idx = Math.min(criticalCount, 4);
                cardElem.style.backgroundColor = palette[idx].bg;
                cardElem.style.color           = palette[idx].text;
                const h3 = cardElem.querySelector('h3');
                const p  = cardElem.querySelector('p');
                if (h3) h3.style.color = palette[idx].text;
                if (p)  p.style.color  = palette[idx].text;
            }

            // Full-dept alert (unchanged logic)
            if (isFirstLoad) {
                previousFullDepartments = { ...currentFullDepartments };
                isFirstLoad = false;
                return;
            }
            for (const deptName in currentFullDepartments) {
                if (!previousFullDepartments[deptName]) {
                    showCriticalModal(deptName, currentFullDepartments[deptName]);
                    break;
                }
            }
            previousFullDepartments = { ...currentFullDepartments };
        })
        .catch(err => console.error("Error loading departments:", err));
}

function selectDept(name) {
    document.getElementById("selectedDept").innerText = name;
    document.getElementById("targetDept").value = name;
}

function showCriticalModal(departmentName, occupancy) {
    const modal = document.getElementById("criticalModal");
    const text  = document.getElementById("criticalModalText");
    if (!modal || !text) return;
    text.innerText = `${departmentName} is full (${occupancy}% occupied). Please transfer the patient to another department.`;
    modal.classList.remove("hidden");
}

function closeCriticalModal() {
    const modal = document.getElementById("criticalModal");
    if (modal) modal.classList.add("hidden");
}

// ─────────────────────────────────────────────
// Transfer
// ─────────────────────────────────────────────
function transferPatient() {
    const mrn  = document.getElementById("transferMrn").value.trim();
    const dept = document.getElementById("targetDept").value;

    if (!mrn || !dept) {
        setTransferMessage("Please fill all fields.", false);
        return;
    }

    Swal.fire({ title: 'Processing...', didOpen: () => Swal.showLoading() });

    fetch("transfer_patient.php", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "mrn=" + encodeURIComponent(mrn) + "&department=" + encodeURIComponent(dept)
    })
    .then(res => res.json())
    .then(data => {
        setTransferMessage(data.message, data.ok);
        if (data.ok) {
            document.getElementById("transferMrn").value = "";
            document.getElementById("selectedDept").innerText = "None";
            document.getElementById("transferPatientInfo").classList.add("hidden");
            clearRecommendations();
            loadDepartments();
        }
    })
    .catch(() => setTransferMessage("Connection error.", false));
}

function setTransferMessage(text, ok) {
    Swal.fire({
        icon:  ok ? 'success' : 'error',
        title: ok ? 'Success'  : 'Attention',
        text,
        timer: ok ? 3000 : undefined
    });
}

// ─────────────────────────────────────────────
// MRN live lookup — shows patient info + triggers smart recommendation
// ─────────────────────────────────────────────
document.getElementById("transferMrn").addEventListener("input", function () {
    const mrn    = this.value.trim();
    const infoBox = document.getElementById("transferPatientInfo");

    if (!mrn) {
        infoBox.classList.add("hidden");
        clearRecommendations();
        return;
    }

    fetch("get_patient.php?mrn=" + encodeURIComponent(mrn))
        .then(res => res.json())
        .then(data => {
            if (data.ok) {
                infoBox.classList.remove("hidden");
                document.getElementById("tpName").innerText  = data.name;
                document.getElementById("tpDept").innerText  = data.department;
                document.getElementById("tpDiag").innerText  = data.diagnosis;
                document.getElementById("tpAge").innerText   = data.age   || "N/A";
                document.getElementById("tpStatus").innerText = data.status || "N/A";

                // Fire smart recommendation
                loadRecommendations(mrn);
            } else {
                infoBox.classList.add("hidden");
                clearRecommendations();
            }
        })
        .catch(() => {
            infoBox.classList.add("hidden");
            clearRecommendations();
        });
});

// ─────────────────────────────────────────────
// Smart recommendation
// ─────────────────────────────────────────────
function loadRecommendations(mrn) {
    const list = document.getElementById("recommendList");
    list.innerHTML = '<div class="rec-item rec-loading">Analyzing departments…</div>';

    fetch("get_recommendation.php?mrn=" + encodeURIComponent(mrn))
        .then(res => res.json())
        .then(data => {
            if (!data.ok || !data.recommendations.length) {
                list.innerHTML = '<div class="rec-item">No suitable departments found.</div>';
                return;
            }
            renderRecommendations(data.recommendations);
        })
        .catch(() => {
            list.innerHTML = '<div class="rec-item">Could not load recommendations.</div>';
        });
}

function renderRecommendations(recs) {
    const list = document.getElementById("recommendList");

    const rankColors = ["#1a4d2e", "#2d7a4f", "#7ab89a"];

    list.innerHTML = recs.map((r, i) => {
        const color       = rankColors[i] || rankColors[2];
        const scoreColor  = r.score >= 75 ? "#155724" : r.score >= 50 ? "#856404" : "#666";
        const scoreBg     = r.score >= 75 ? "#d4edda"  : r.score >= 50 ? "#fff3cd"  : "#f0f0f0";
        const scoreBorder = r.score >= 75 ? "#b2d8bb"  : r.score >= 50 ? "#e6d87b"  : "#ddd";

        const bars = [
            { label: "Capacity",  val: r.capacity_score  },
            { label: "Specialty", val: r.specialty_score },
            { label: "Stability", val: r.stability_score },
            { label: "Urgency",   val: r.urgency_score   },
        ].map(b => `
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
                <span style="font-size:11px; color:#777; width:62px; flex-shrink:0;">${b.label}</span>
                <div style="flex:1; height:5px; background:#ececec; border-radius:3px; overflow:hidden;">
                    <div style="width:${b.val}%; height:100%; background:${color}; border-radius:3px;"></div>
                </div>
                <span style="font-size:11px; color:#888; width:26px; text-align:right;">${b.val}</span>
            </div>
        `).join("");

        const tags = r.reasons.map(reason => `
            <span style="display:inline-block; font-size:11px; padding:2px 9px;
                         border-radius:99px; background:#f1f3f5; color:#555;
                         margin:2px 3px 2px 0; border:1px solid #e4e4e4;">
                ${reason}
            </span>
        `).join("");

        return `
        <div style="background:#fff; border:1px solid #e4e4e4; border-left:3px solid ${color};
                    border-radius:10px; padding:14px; margin-bottom:10px;">

            <!-- Top row -->
            <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:10px;">
                <div style="display:flex; align-items:center; gap:10px;">
                    <span style="width:26px; height:26px; border-radius:50%; background:${color};
                                 color:#fff; font-size:12px; font-weight:700;
                                 display:flex; align-items:center; justify-content:center;
                                 flex-shrink:0;">${i + 1}</span>
                    <div>
                        <div style="font-size:14px; font-weight:700; color:#1a1a1a;">${r.department}</div>
                        <div style="font-size:11px; color:#888; margin-top:1px;">
                            ${r.available} beds free &nbsp;·&nbsp; ${r.occupancy}% occupied
                        </div>
                    </div>
                </div>
                <span style="font-size:12px; font-weight:700; padding:4px 11px; border-radius:99px;
                             background:${scoreBg}; color:${scoreColor}; border:1px solid ${scoreBorder};">
                    ${r.score}/100
                </span>
            </div>

            <!-- Score bars -->
            <div style="margin-bottom:8px;">${bars}</div>

            <!-- Reason tags -->
            <div style="margin-bottom:10px;">${tags}</div>

            <!-- Action button -->
            <button onclick="selectDept('${r.department}')"
                style="font-size:12px; padding:6px 14px; border-radius:6px; cursor:pointer;
                       background:#fff; border:1.5px solid ${color}; color:${color};
                       font-weight:600; transition:all 0.15s;"
                onmouseover="this.style.background='${color}'; this.style.color='#fff';"
                onmouseout="this.style.background='#fff'; this.style.color='${color}';">
                ✓ Select ${r.department}
            </button>
        </div>
        `;
    }).join("");
}

function clearRecommendations() {
    document.getElementById("recommendList").innerHTML =
        '<div class="rec-item">Enter a patient MRN above to see smart recommendations.</div>';
}

// ─────────────────────────────────────────────
// Poll every 5 s
// ─────────────────────────────────────────────
setInterval(loadDepartments, 5000);
loadDepartments();
clearRecommendations();