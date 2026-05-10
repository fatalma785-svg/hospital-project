// --- 1. HANDLE LOGOUT ---
function logout() {
    localStorage.clear();
    window.location = "index.php";
}

// --- 2. DYNAMIC FETCH FROM MODEL OUTPUT ---
fetch("outputs/finaloccupancy.json")
    .then(response => {
        if (!response.ok) throw new Error("JSON not found");
        return response.json();
    })
    .then(data => {

        console.log("Data loaded successfully:", data);

        // 🔹 A. Hospital Risk
        const riskBox = document.getElementById("patientPrediction");

        if (riskBox && data.hospital_shortage_risk) {
            const hRisk = data.hospital_shortage_risk;

            const riskStyle = hRisk === "CRITICAL"
                ? "color:#E74C3C; font-weight:bold;"
                : "color:#16A085;";

            riskBox.innerHTML =
                `<strong>Overall Hospital Bed Shortage Risk:</strong>
                 <span style="${riskStyle}">${hRisk}</span>`;
        }

        // 🔹 B. Occupancy Table
        const occupancyBox = document.getElementById("occupancyResults");

        if (occupancyBox && data.forecast) {

            let tableHtml =
                `<strong>Next Week's Bed Occupancy:</strong>
                 <table style="width:100%; margin-top:10px; border-collapse:collapse;">
                 <tr style="border-bottom:2px solid #eee;">
                     <th style="text-align:left; padding:5px;">Date</th>
                     <th style="text-align:right; padding:5px;">Occupancy</th>
                 </tr>`;

            data.forecast.forEach(row => {

                const val = Math.round(Number(row.Occupancy) || 0);

                tableHtml += `
                    <tr style="border-bottom:1px solid #f9f9f9;">
                        <td style="padding:5px;">${row.Date}</td>
                        <td style="padding:5px; text-align:right; font-weight:bold;">
                            ${val} Beds
                        </td>
                    </tr>`;
            });

            tableHtml += `</table>`;
            occupancyBox.innerHTML = tableHtml;
        }

        // 🔹 C. First day value
        if (data.forecast?.length > 0) {

            const first = Math.round(Number(data.forecast[0].Occupancy) || 0);

            const predEl = document.getElementById("predOccupancy");

            if (predEl) {
                predEl.innerText = first + " Beds";
            }
        }

// 🔹 D. Department Cards
const deptList = document.getElementById("deptResultsList");

if (deptList && data.dept_predictions) {
    deptList.innerHTML = "";

    Object.keys(data.dept_predictions).forEach(dept => {
        const stats = data.dept_predictions[dept];
        
        // --- NEW RISK CALCULATION LOGIC ---
        // Calculate the ratio (e.g., 11.4 / 15 = 0.76)
        const occupancyRate = stats.beds / stats.capacity;
        
        let riskLevel = "";
        let color = "";
        let border = "";

        if (occupancyRate >= 0.75) {
            riskLevel = "HIGH";
            color = "#E74C3C"; // Red
            border = "#E74C3C";
        } else if (occupancyRate >= 0.50) {
            riskLevel = "MEDIUM";
            color = "#F39C12"; // Orange
            border = "#F39C12";
        } else {
            riskLevel = "LOW";
            color = "#2ECC71"; // Safe Green
            border = "#2ECC71";
        }
        // ----------------------------------

        deptList.innerHTML += `
            <div style="background:#fff; border:2px solid ${border};
                        padding:15px; border-radius:8px; text-align:center;
                        box-shadow:0 2px 4px rgba(0,0,0,0.05); transition: 0.3s;">

                <h4 style="color:#1F3A5F; margin-bottom:10px;">${dept}</h4>

                <div style="font-size:1.2em; font-weight:bold;">
                    ${Math.round(stats.beds)} / ${stats.capacity} Beds
                </div>

                <div style="margin-top:5px; font-weight:bold; color:${color};">
                    Risk: ${riskLevel}
                </div>

                <div style="font-size:0.8em; color:#888; margin-top:5px;">
                    Share: ${stats.weight}%
                </div>
            </div>`;
    });
}
        // 🔥 🔥 🔥 SECTION E — HOSPITAL CONTROL HEATMAP TABLE (FINAL VERSION)

        const deptTimeline = document.getElementById("deptTimeline");

        if (deptTimeline && data.forecast && data.dept_predictions) {

            const base = data.forecast[0].Occupancy;

            function getColor(val, capacity) {
                const ratio = val / capacity;

                if (ratio >= 0.85) return "#E74C3C"; // CRITICAL
                if (ratio >= 0.65) return "#F39C12"; // HIGH
                if (ratio >= 0.40) return "#F1C40F"; // MODERATE
                return "#2ECC71"; // SAFE
            }

            let html = `
                <strong>Next Week Bed Occupancy Heatmap</strong>
                <div style="overflow-x:auto; margin-top:10px;">
                <table style="width:100%; border-collapse:collapse; font-size:0.85em;">

                    <thead>
                        <tr style="background:#1F3A5F; color:white;">
                            <th style="padding:10px; text-align:left;">Date</th>`;

            Object.keys(data.dept_predictions).forEach(dept => {
                html += `<th style="padding:10px; text-align:right;">${dept}</th>`;
            });

            // 🔥 TOTAL MOVED TO RIGHT END
            html += `<th style="padding:10px; text-align:right;">TOTAL</th>`;

            html += `</tr></thead><tbody>`;

            data.forecast.forEach(day => {

                const total = Math.round(day.Occupancy);

                html += `
                    <tr>
                        <td style="padding:10px; font-weight:bold; border-bottom:1px solid #eee;">
                            ${day.Date}
                        </td>`;

                Object.keys(data.dept_predictions).forEach(dept => {

                    const d = data.dept_predictions[dept];

                    const val = Math.round(d.beds * (day.Occupancy / base));

                    const bg = getColor(val, d.capacity);
                    const text = (bg === "#F1C40F") ? "#000" : "#fff";

                    html += `
                        <td style="
                            padding:10px;
                            text-align:right;
                            font-weight:bold;
                            background:${bg};
                            color:${text};
                            border-bottom:1px solid #fff;
                        ">
                            ${val}
                        </td>`;
                });

                // 🔥 TOTAL CELL (RIGHT SIDE)
                html += `
                    <td style="
                        padding:10px;
                        text-align:right;
                        font-weight:bold;
                        background:#ECF0F1;
                        border-bottom:1px solid #eee;
                    ">
                        ${total}
                    </td>`;

                html += `</tr>`;
            });

            html += `</tbody></table></div>`;

            // LEGEND
            html += `
                <div style="margin-top:10px; font-size:0.8em; display:flex; gap:10px; flex-wrap:wrap;">
                    <span style="background:#2ECC71; color:#fff; padding:4px 8px; border-radius:4px;">LOW</span>
                    <span style="background:#F1C40F; padding:4px 8px; border-radius:4px;">MODERATE</span>
                    <span style="background:#F39C12; color:#fff; padding:4px 8px; border-radius:4px;">HIGH</span>
                    <span style="background:#E74C3C; color:#fff; padding:4px 8px; border-radius:4px;">CRITICAL</span>
                </div>
            `;

            deptTimeline.innerHTML = html;
        }

    })
    .catch(err => {
        console.error("Error loading forecast data:", err);

        const statusEl = document.getElementById("forecastStatus");

        if (statusEl) {
            statusEl.innerText = "Model Status: Error loading data";
        }
    });
	
// --- 3. SCROLL FUNCTIONS ---

function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

function scrollToPredictions() {
    const element = document.getElementById("prediction-section");
    if (element) {
        const offset = 20; 
        const bodyRect = document.body.getBoundingClientRect().top;
        const elementRect = element.getBoundingClientRect().top;
        const elementPosition = elementRect - bodyRect;
        const offsetPosition = elementPosition - offset;

        window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
        });
    } else {
        console.error("Scroll target 'prediction-section' not found in HTML.");
    }
}