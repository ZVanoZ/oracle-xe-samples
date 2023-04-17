-- @DIALECT: Oracle SQL*Plus

set serveroutput on;

prompt ***** drop table zim_initdb

CREATE TABLE zim_initdb
(
    id                     number(10).
    code                   varchar2(100)
);

comment on table zim_initdb       is 'Список значений';
comment on column zim_initdb.id   is 'Первичный ключ';
comment on column zim_initdb.code is 'Код параметра';

prompt ***SUCCESS***

COMMIT;