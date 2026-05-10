function doLogin() {
    const u = document.getElementById("username").value.trim();
    const p = document.getElementById("password").value.trim();

    if (u === "admin" && p === "1234") {
        localStorage.setItem("NGH_AUTH", "true");
        window.location.href = "./NGH_dashboard.html";
    } else {
        document.getElementById("loginError").textContent =
            "Invalid credentials. Please try again.";
    }
}