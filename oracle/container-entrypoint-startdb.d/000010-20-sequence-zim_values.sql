-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

set serveroutput on;

whenever sqlerror continue;
drop sequence sq_zim$values_id;

whenever sqlerror exit;
create sequence sq_zim$values_id start with 1 increment by 1 nomaxvalue nocache;

prompt ***** SUCCESS sequence-zim_values.sql