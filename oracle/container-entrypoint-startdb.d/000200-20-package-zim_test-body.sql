-- @DIALECT: Oracle SQL*Plus
@/container-entrypoint-startdb.d/connect.sql
@/container-entrypoint-startdb.d/000010-10-set-session.sql

create or replace package body zim$test is
    function test_bind_in_number(
        p_val number default null
    ) return number
        is
    begin
        return p_val;
    end test_bind_in_number;

    -- Тест биндинга дробных значений
    function test_bind_in_out_number_12_4(
        p_val NUMBER_12_4 default null,
        p_out out NUMBER_12_4
    ) return NUMBER_12_4
        is
    begin
        p_out := p_val;
        return p_val;
    end test_bind_in_out_number_12_4;

    function test_bind_in_out_varchar2(
        p_val varchar2      default null,
        p_out out varchar2
    ) return varchar2
        is
    begin
        p_out := p_val;
        return p_val;
    end test_bind_in_out_varchar2;

    function test_bind_in_out_date(
        p_val date default null,
        p_out out date
    ) return date
        is
    begin
        p_out := p_val;
        return p_val;
    end test_bind_in_out_date;

    -- Тестируем CLOB на вход и на выход
    function test_bind_in_out_clob(
        p_val clob default null,
        p_out out clob
    ) return clob
        is
    begin
        p_out := p_val;
        return p_val;
    end test_bind_in_out_clob;


    -- Тестируем BLOB на вход и на выход
    function test_bind_in_out_blob(
        p_val blob default null,
        p_out out blob
    ) return blob
        is
    begin
        p_out := p_val;
        return p_val;
    end test_bind_in_out_blob;

    procedure incOutProcedure(
        p_val            number,           -- value for inccrement
        p_inc_factor     number default 1, -- increment step
        p_out_result out number            -- result
    )
    is
    begin
        p_out_result := p_val + p_inc_factor;
    end incOutProcedure;

    function incOutFunction(
        p_val            number,           -- value for inccrement
        p_inc_factor     number default 1, -- increment step
        p_out_result out number            -- result
    ) return number
    is
    begin
        p_out_result := p_val + p_inc_factor;
        return  p_out_result;
    end incOutFunction;

    function zim_values_search(
        p_id zim$values.id%type default null, -- Search by "id"
        p_code zim$values.code%type default null, -- Search by "code"
        p_value_varchar2 zim$values.value_varchar2%type default null -- Search by "value"
    ) return type_zim_values_row parallel_enable pipelined
        is
        result_record type_zim_values_row;
    begin
        select unique * bulk collect
        into result_record
        from zim$values t
        where (p_id is null or t.id = p_id)
          and (p_code is null or t.code like p_code)
          and (p_value_varchar2 is null or t.value_varchar2 like p_value_varchar2);

        for i in 1..sql%rowcount
            loop
                pipe row(result_record(i));
            end loop;
    end zim_values_search;

--     function zim$values_add(
--         p_name zim$values.name%type default null,
--         p_value zim$values.value%type default null
--     ) return number
--         is
--         result number := null;
--     begin
--         insert into zim$values(name, value) values (p_name, p_value) returning id into result;
--         return result;
--     exception
--         when others then
--             return SQLCODE;
--     end zim$values_add;
--
--     function zim$values_edit(
--         p_id zim$values.id%type default null,
--         p_name zim$values.name%type default null,
--         p_value zim$values.value%type default null
--     ) return number
--         is
--     begin
--         return null;
--     exception
--         when others then
--             return SQLCODE;
--     end zim$values_edit;
--
--
--     function zim$values_del(
--         p_id zim$values.id%type default null
--     ) return number
--         is
--     begin
--         return null;
--     exception
--         when others then
--             return SQLCODE;
--     end zim$values_del;

end zim$test;
/

prompt ***** SUCCESS package-zim_test-body.sql;
