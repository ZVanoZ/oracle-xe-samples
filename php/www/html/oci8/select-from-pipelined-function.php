<?php
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$connection = include 'create-connection.php';

$stid = oci_parse($connection, <<<'SQL'
SELECT
    *
FROM table(zim$test.zim_values_search(
        p_code => :p_code_bind 
    )) t
SQL
);
$p_code_bind = 'SERVICE%';
oci_bind_by_name($stid, 'p_code_bind', $p_code_bind, strlen($p_code_bind), SQLT_CHR);

oci_execute($stid);

$rows = [];
while ($row = oci_fetch_assoc($stid)) {
    $rows[] = $row;
}

//var_dump($rows);

header('Content-Type: text/json,utf-8');
$json = json_encode($rows, JSON_PRETTY_PRINT | JSON_UNESCAPED_LINE_TERMINATORS | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
echo $json;