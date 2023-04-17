-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

whenever sqlerror exit;
--whenever sqlerror continue;

create or replace trigger tg_zim$values_bi
    before insert
    on     zim$values
    for    each row
begin
    if :new.id is null then
        :new.id := sq_zim$values_id.nextval;
    end if;
end;
/

prompt ***** SUCCESS trigger-zim_values.sql