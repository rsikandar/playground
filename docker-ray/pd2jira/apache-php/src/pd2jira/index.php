<!DOCTYPE html>
<html>
<body>

<p>Click the button to display webhook for the PagerDuty to JIRA Integration.</p>

<button onclick="myFunction()">Show Webhook</button>

<p id="demo"></p>

<script>
function myFunction() {
    var x = "https://" + location.host + "/pd2jira.php";
    document.getElementById("demo").innerHTML = x;
}
</script>

</body>
</html>