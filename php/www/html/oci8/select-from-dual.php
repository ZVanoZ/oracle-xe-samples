<?php
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$connection = include 'create-connection.php';

$stid = oci_parse($connection, 'SELECT * FROM dual');
oci_execute($stid);

oci_fetch_all($stid, $rows);
//var_dump($rows);

header('Content-Type: text/json,utf-8');
$json = json_encode($rows, JSON_PRETTY_PRINT|JSON_UNESCAPED_LINE_TERMINATORS|JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
echo  $json;