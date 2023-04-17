-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

prompt ***** insert into zim$values;



-- Вставка в анонимном блоке т.к. в среде SQLPLUS нельзя использовать TO_TIMESTAMP_TZ.
-- Выводит такую ошибку.
-- local.zvanoz.samples.oracle  |     -- SELECT TO_TIMESTAMP_TZ ('2022-10-18_23:58:59.123000', 'YYYY-MM-DD_HH24:MI:SS.FF') FROM DUAL
-- local.zvanoz.samples.oracle  |                                                                                                         *
-- local.zvanoz.samples.oracle  | ERROR at line 20:
-- local.zvanoz.samples.oracle  | ORA-00936: missing expression
begin
    dbms_output.put_line('Вставка в анонимном блоке т.к. в среде SQLPLUS нельзя использовать TO_TIMESTAMP_TZ');
    INSERT
    INTO zim$values
    (
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
    ) VALUES (
                 'TEST_VALUES',
                 'varchar2-русский-українська',
                 -123.45,
                 -321,
                 TO_DATE('31.01.2022-23:58:59', 'DD.MM.YYYY-hh24:MI:SS'),
                 TO_TIMESTAMP('2022-10-18_23:58:59.123000', 'YYYY-MM-DD_HH24:MI:SS.FF'),
                 -- SELECT TO_TIMESTAMP_TZ ('2022-10-18_23:58:59.123000', 'YYYY-MM-DD_HH24:MI:SS.FF') FROM DUAL;
                 -- SELECT TO_TIMESTAMP_TZ ('2022-10-18_23:58:59.123000_+02:00', 'YYYY-MM-DD_HH24:MI:SS.FF_TZH:TZM') FROM DUAL;
                 TO_TIMESTAMP_TZ('2022-10-18_23:58:59.123000_-3:00', 'YYYY-MM-DD_HH24:MI:SS.FF_TZH:TZM'),
                 TO_TIMESTAMP_TZ('2022-10-18_23:58:59.123000_-3:00', 'YYYY-MM-DD_HH24:MI:SS.FF_TZH:TZM'),
                 TO_CLOB('clob-русский-українська'),
                 TO_BLOB(utl_encode.BASE64_DECODE(UTL_RAW.CAST_TO_RAW('/9j/4AAQSkZJRgABAQEBLAEsAAD//gATQ3JlYXRlZCB3aXRoIEdJTVD/4gKwSUNDX1BST0ZJTEUAAQEAAAKgbGNtcwQwAABtbnRyUkdCIFhZWiAH5gAKABIACwANADZhY3NwQVBQTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9tYAAQAAAADTLWxjbXMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1kZXNjAAABIAAAAEBjcHJ0AAABYAAAADZ3dHB0AAABmAAAABRjaGFkAAABrAAAACxyWFlaAAAB2AAAABRiWFlaAAAB7AAAABRnWFlaAAACAAAAABRyVFJDAAACFAAAACBnVFJDAAACFAAAACBiVFJDAAACFAAAACBjaHJtAAACNAAAACRkbW5kAAACWAAAACRkbWRkAAACfAAAACRtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACQAAAAcAEcASQBNAFAAIABiAHUAaQBsAHQALQBpAG4AIABzAFIARwBCbWx1YwAAAAAAAAABAAAADGVuVVMAAAAaAAAAHABQAHUAYgBsAGkAYwAgAEQAbwBtAGEAaQBuAABYWVogAAAAAAAA9tYAAQAAAADTLXNmMzIAAAAAAAEMQgAABd7///MlAAAHkwAA/ZD///uh///9ogAAA9wAAMBuWFlaIAAAAAAAAG+gAAA49QAAA5BYWVogAAAAAAAAJJ8AAA+EAAC2xFhZWiAAAAAAAABilwAAt4cAABjZcGFyYQAAAAAAAwAAAAJmZgAA8qcAAA1ZAAAT0AAACltjaHJtAAAAAAADAAAAAKPXAABUfAAATM0AAJmaAAAmZwAAD1xtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAEcASQBNAFBtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEL/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wgARCAAIAAgDAREAAhEBAxEB/8QAFAABAAAAAAAAAAAAAAAAAAAACP/EABUBAQEAAAAAAAAAAAAAAAAAAAgJ/9oADAMBAAIQAxAAAAEdle+H/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABBQJ//8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAwEBPwF//8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAgEBPwF//8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQAGPwJ//8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPyF//9oADAMBAAIAAwAAABAf/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAwEBPxB//8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAgEBPxB//8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxB//9k='))),
                 'T'
             );
    commit;
exception
    when OTHERS then
        dbms_output.put_line('***FAIL*** :' || SQLCODE || ' - ' || SQLERRM);
        return;
end;
/

merge into zim$values d
    using (
        select
        'LAST_FILL' as code,
        sysdate     as nowDate
        from dual
    ) s
        on (d.code = s.code)
when matched then
update
    set
    d.value_date             = s.nowDate,
    d.value_timestamp        = s.nowDate,
    d.value_timestamp_zoned  = s.nowDate,
    d.value_timestamp_lzoned = s.nowDate
    when not matched then
insert (
    d.code,
    d.value_date,
    d.value_timestamp,
    d.value_timestamp_zoned,
    d.value_timestamp_lzoned
) values (
     s.code,
     s.nowDate,
     s.nowDate,
     s.nowDate,
     s.nowDate
);

INSERT
    INTO zim$values
    (code, value_varchar2)
VALUES ('SERVICE_CONVERTER_URL', 'http://converter.service.local');

INSERT
INTO zim$values
    (code, value_varchar2)
VALUES ('SERVICE_CONVERTER_USER', 'userConverter');

INSERT
INTO zim$values
    (code, value_varchar2)
VALUES ('SERVICE_CONVERTER_PASS', 'passConverter');

commit;

prompt ***** SUCCESS table-zim_values-fill.sql
