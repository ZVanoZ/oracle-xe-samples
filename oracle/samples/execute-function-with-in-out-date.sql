set serveroutput on;
declare
    p_out date;
    result date;
begin
    result := zim$test.test_bind_in_out_date(
            p_val         => to_date('2023-04-17_20:16:59', 'YYYY-MM-DD_HH24:MI:SS'),
            p_out => p_out
        );
    dbms_output.put_line('result: '||to_char(result, 'YYYY-MM-DD_HH24:MI:SS'));
    dbms_output.put_line('p_out: '||to_char(p_out, 'YYYY-MM-DD_HH24:MI:SS'));
end;
/


/* OUTPUT:
result: 2023-04-17_20:16:59
p_out: 2023-04-17_20:16:59

PL/SQL procedure successfully completed.
*/
