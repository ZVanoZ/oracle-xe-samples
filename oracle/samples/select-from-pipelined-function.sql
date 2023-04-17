SELECT
    *
FROM table(zim$test.zim_values_search(
        p_code => 'SERVICE%'
    )) t
;