-- @DIALECT: Oracle SQL*Plus
-- connect MYUSERNAME/myUserPass@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=zimdbt)))"
-- connect $APP_USER/$APP_USER_PASSWORD@$ORACLE_DATABASE;
-- connect MYUSERNAME/myUserPass@$xepdb1;

@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql



whenever sqlerror continue;
prompt ***** drop table zim$values
drop table zim$values  cascade constraints;
prompt ***** SUCCESS

whenever sqlerror exit;
prompt ***** create table zim$values
CREATE TABLE zim$values
(
    id                     number(10)
        constraint pk_zim$values PRIMARY KEY,
    code                   varchar2(100)
        constraint nn_zim$values_code NOT NULL
        constraint u_zim$values_code unique,
    value_varchar2         varchar2(100),
    value_number           number(10, 2),
    value_integer          integer,
    value_date             date,
    value_timestamp        timestamp,
    value_timestamp_zoned  timestamp with time zone,
    value_timestamp_lzoned timestamp with local time zone,
    value_clob             clob,
    value_blob             blob,
    value_bool         char(1),
    constraint c_zim$values_value_bool CHECK (value_bool in ('T', 'F')) ENABLE
);
prompt ***** SUCCESS

---- Публичный синоним можно создать только если подключились под sysdba
---- local.zvanoz.samples.oracle  | ORA-01031: insufficient privileges
-- create or replace public synonym zim$values for zim$values ;

prompt ***** comment table zim$values
comment on table zim$values       is 'Список значений';
comment on column zim$values.id   is 'Первичный ключ';
comment on column zim$values.code is 'Код параметра';

-- -- Ограничение:  id - первичный ключ
-- alter table zim$values
--     add constraint pk_zim$values_id primary key (id)
-- -- using index tablespace &&tbs_index
-- ;

-- -- Ограничение:  code - уникален
-- alter table zim$values
--     add constraint u_zim$values_code unique (code)
-- --    using index tablespace &&tbs_index
-- ;

-- -- Ограничение:  code - обязателен
-- alter table zim$values
--     add constraint nn_zim$values_code
--         check ("code" IS NOT NULL);

-- -- Ограничение:  value_bool - либо 'T', либо 'F'
-- alter table zim$values
--     add constraint c_zim$values_value_bool
--         check (value_bool in ('T','F'));

prompt ***** SUCCESS table-zim_values.sql

--spool  OFF
