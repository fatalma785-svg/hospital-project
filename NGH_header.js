// CHECK LOGIN
if (localStorage.getItem("NGH_AUTH") !== "true") {
    window.location.replace("login.php");
}

document.addEventListener("DOMContentLoaded", function () {

    const user = localStorage.getItem("NGH_USER") || "User";

    const header = document.createElement("div");
    header.className = "dash-header";

    header.innerHTML = `
        <div class="brand">
            <img src="./logo.png" class="dash-logo">
            <div>
                <h2>National Guard Hospital</h2>
                <span>Welcome, ${user} 👋</span>
            </div>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn btn-light" onclick="goDashboard()">Dashboard</button>
            <button class="btn btn-light" onclick="goCapacity()">Department</button>
            <button class="btn btn-danger" onclick="logout()">Logout</button>
        </div>
    `;

    document.body.prepend(header);
});

function goDashboard() {
    window.location.href = "NGH_dashboard.html";
}

function goCapacity() {
    window.location.href = "NGH_capacity.html";
}

function logout() {
    localStorage.clear();
    window.location.replace("index.php");
}