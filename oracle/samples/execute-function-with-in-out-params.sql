set serveroutput on;

declare
    p_out_result number;
    result number;
begin
    result := zim$test.incOutFunction(
        p_val         => 10,
        p_inc_factor  => 3,
        p_out_result => p_out_result
    );
    dbms_output.put_line('result: '||result);
    dbms_output.put_line('p_out_result: '||p_out_result);
end;
/

/* OUTPUT:
result: 13
p_out_result: 13

PL/SQL procedure successfully completed.
*/