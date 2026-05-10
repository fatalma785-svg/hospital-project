<?php
// This PHP script simply triggers a JavaScript cleanup
echo "<script>
    localStorage.clear();
    window.location.href = 'index.php';
</script>";
exit();
?>