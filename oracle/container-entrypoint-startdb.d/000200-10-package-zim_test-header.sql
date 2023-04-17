-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

set serveroutput on;
SET ECHO ON;
SET FEEDBACK ON;
WHENEVER SQLERROR EXIT SQL.SQLCODE

/* Это не нужно т.к. пакет отлично пересоздается.
BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE zim$test';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -04043 THEN
            RAISE;
        END IF;
END;
/
*/
-- RUS: Это кирилица
-- UKR: Це є кирілиця (ї)

create or replace package zim$test is
    function test_bind_in_number(
        p_val number default null
    ) return number;

    function test_bind_in_out_varchar2(
        p_val varchar2      default null,
        p_out out varchar2
    ) return varchar2;

    -- Тест биндинга дробных значений
    SUBTYPE NUMBER_12_4 IS NUMBER(12, 4);
    function test_bind_in_out_number_12_4(
        p_val NUMBER_12_4 default null,
        p_out out NUMBER_12_4
    ) return NUMBER_12_4;

        function test_bind_in_out_date(
        p_val date default null,
        p_out out date
    ) return date;

    -- Тестируем CLOB на вход и на выход
    function test_bind_in_out_clob(
        p_val clob default null,
        p_out out clob
    ) return clob;

    -- Тестируем BLOB на вход и на выход
    function test_bind_in_out_blob(
        p_val blob default null,
        p_out out blob
    ) return blob;

    /**
     Increment value p_val and return result across out parameter
     */
    procedure incOutProcedure(
        p_val            number,           -- value for inccrement
        p_inc_factor     number default 1, -- increment step
        p_out_result out number            -- result
    );

    /**
      1. Increment value p_val and return result across out parameter
      2. Return p_val as result
     */
    function incOutFunction(
        p_val            number,           -- value for inccrement
        p_inc_factor     number default 1, -- increment step
        p_out_result out number            -- result
    ) return number;

-------------------------------------------------------------------------------
    /**
     *
     */
    type type_zim_values_record is record
                                   (
                                       id             zim$values.id%type,            -- field "id" - PK of record
                                       code           zim$values.code%type,          -- field "code"
                                       value_varchar2 zim$values.value_varchar2%type -- field "value"
                                   );
    type type_table_test1 is table of type_zim_values_record;
    type type_zim_values_row is table of zim$values%rowtype;

    /**
      * Выполнят поиск в таблице zim$values.
      * Возвращает множество строк.
      */
    function zim_values_search(
        p_id zim$values.id%type default null, -- Search by "id"
        p_code zim$values.code%type default null, -- Search by "code"
        p_value_varchar2 zim$values.value_varchar2%type default null -- Search by "value"
    ) return type_zim_values_row parallel_enable pipelined;

-------------------------------------------------------------------------------

--     function zim$values_add(
--         p_code zim$values.code%type default null,
--         p_value_varchar2 zim$values.value_varchar2%type default null
--     ) return number;
--
--     function zim$values_edit(
--         p_id zim$values.id%type default null,
--         p_code zim$values.code%type default null,
--         p_value_varchar2 zim$values.value_varchar2%type default null
--     ) return number;
--
--     function zim$values_del(
--         p_id zim$values.id%type default null
--     ) return number;

end zim$test;
/

prompt ***** SUCCESS package-zim_test-header.sql