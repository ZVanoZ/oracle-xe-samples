<?php
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

//$host = getenv('TESTS_DB_ORACLE_HOSTNAME');
$host ='oracle';
//$port = getenv('TESTS_DB_ORACLE_PORT');
$port = '1521';
$username = getenv('APP_USER');
$password = getenv('APP_USER_PASSWORD');
$serviceName = getenv('ORACLE_DATABASE');
//$characterSet = getenv('TESTS_DB_ORACLE_CHARSET');
$characterSet='UTF8';
$connectionString = <<<TEXT
( DESCRIPTION =
    (
        ADDRESS=(PROTOCOL=TCP)(HOST=$host)(PORT=$port)
    )
    (
        CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=$serviceName))
    )
TEXT;
$sessionMode = OCI_DEFAULT;

$connection = oci_connect($username, $password, $connectionString, $characterSet, $sessionMode);
if (!is_resource($connection)){
    throw new \Exception('Can\'t create connection');
}
return $connection;