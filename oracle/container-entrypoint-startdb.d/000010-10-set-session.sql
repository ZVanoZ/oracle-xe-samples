-- @DIALECT: Oracle SQL*Plus
set serveroutput on;
SET ECHO ON;
SET FEEDBACK ON;
whenever sqlerror exit;
alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';