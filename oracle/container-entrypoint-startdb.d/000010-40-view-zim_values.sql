-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

create or replace force view v_zim$values(
    id,
    code,
    value_varchar2,
    value_number,
    value_integer,
    value_date,
    value_timestamp,
    value_timestamp_zoned,
    value_timestamp_lzoned,
    value_clob,
    value_blob,
    value_bool
)
as
select
    id,
    code,
    value_varchar2,
    value_number,
    value_integer,
    value_date,
    value_timestamp,
    value_timestamp_zoned,
    value_timestamp_lzoned,
    value_clob,
    value_blob,
    value_bool
from zim$values;

comment on table v_zim$values is 'Список значений';
comment on column v_zim$values.id is 'Первичный ключ';
comment on column v_zim$values.code is 'Код параметра';

prompt ***** SUCCESS view v_zim$values
