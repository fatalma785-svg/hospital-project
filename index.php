<?php
include 'db.php';

$error = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    $sql = "SELECT * FROM login WHERE username='$username' AND password='$password'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {

        $row = $result->fetch_assoc();
        $user = $row['username'];
// Inside the if ($result && $result->num_rows > 0) block:
	echo "<script>
        localStorage.setItem('NGH_AUTH','true');
        localStorage.setItem('NGH_USER','$user');
        window.location='NGH_dashboard.html'; // Ensure this matches your dashboard filename
      </script>";
        exit();

    } else {
        $error = "Invalid credentials. Please try again.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NGH Login</title>

<style>
*{
    box-sizing: border-box;
}

body{
    margin:0;
    font-family:'Segoe UI', sans-serif;
    background:url('./SANG Hospitals.jpeg') no-repeat center center/cover;
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
}

.login-box{
    background:#fff;
    padding:40px;
    border-radius:18px; /* Matched to your 18px dashboard style */
    width:380px; /* Slightly wider for a more professional feel */
    text-align:center;
    box-shadow: 0 18px 40px rgba(0,0,0,0.20); /* Matched to your modal shadow */
    border: 1px solid #eef2f7;
}

.login-logo{
    width:80px;
    margin-bottom:15px;
}

h1{
    margin:10px 0;
    font-size: 24px;
    color: #1f2937;
}

/* Updated Inputs to match your "NGH_main.css" style */
input{
    width:100%;
    padding:12px 14px;
    margin:12px 0;
    border:1px solid #d7e0dc;
    border-radius:12px; /* Matches your dashboard input radius */
    font-size:14px;
    background:#fff;
    outline:none;
    display: block; /* Ensures it takes its own line */
}

input:focus{
    border-color:#167A4A;
    box-shadow:0 0 0 3px rgba(22,122,74,0.12);
}

/* Primary Sign In Button */
button{
    width:100%;
    padding:12px;
    background:#167A4A; /* Exact match to your primary green */
    color:#fff;
    border:none;
    border-radius:12px;
    cursor:pointer;
    font-weight: 700;
    font-size: 15px;
    transition: 0.2s;
    display: block;
}

button:hover{
    opacity: 0.9;
    transform: translateY(-1px);
}

/* Register Button */
.register-btn{
    margin-top:10px;
    background:#ffffff;
    color:#167A4A;
    border:1px solid #167A4A;
}

.register-btn:hover{
    background: #f0fdf4;
}

/* Register Link */
.register-link{
    margin-top:16px;
    font-size:14px;
    color: #64748b;
}

.register-link a{
    color:#167A4A;
    text-decoration:none;
    font-weight:700;
}

.error{
    color:#d92d20;
    margin-top:10px;
    font-size: 14px;
    font-weight: 600;
}
</style>

</head>

<body>

<div class="login-box">

    <img src="./logo.png" class="login-logo">

    <h1>National Guard Hospital</h1>
    <p>Bed Management Decision Support System</p>

    <form method="POST">

        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Sign in</button>

    </form>


<div class="register-link">
    Don’t have an account? 
    <a href="#" onclick="alert('Registration coming soon'); return false;">
        Register here
    </a>
</div>

</body>
</html>