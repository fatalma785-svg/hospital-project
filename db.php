<?php
// جلب البيانات من إعدادات السيرفر تلقائياً (أكثر أماناً)
$servername = getenv('MYSQLHOST') ?: "localhost";
$username   = getenv('MYSQLUSER') ?: "root";
$password   = getenv('MYSQLPASSWORD') ?: "";
$dbname     = getenv('MYSQLDATABASE') ?: "hospital_db"; 
$port       = getenv('MYSQLPORT') ?: "3306";

// محاولة الاتصال
$conn = @new mysqli($servername, $username, $password, $dbname, $port);

// التحقق من الاتصال بدون "قتل" الصفحة
if ($conn->connect_error) {
    // إذا فشل الاتصال، الموقع بيستمر بالعمل بس بيعطي رسالة مخفية
    echo "";
}
?>