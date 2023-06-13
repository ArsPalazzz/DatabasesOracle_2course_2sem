SELECT SUM(VALUE) FROM V$SGA;

SELECT * FROM V$SGA;

select component,
    current_size,
    max_size,
    last_oper_mode,
    last_oper_time,
    granule_size,
    current_size/granule_size as Ratio
    from v$sga_dynamic_components
where current_size > 0;

select current_size from v$sga_dynamic_free_memory;

select 
sum(min_size),
sum(max_size),
sum(current_size)
from v$sga_dynamic_components;

select 
component,
min_size,
current_size
from v$sga_dynamic_components;

create table XXX (k int) storage(buffer_pool keep);

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name  = 'XXX';

create table YYY (k int) storage(buffer_pool default);

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name  = 'YYY';

SELECT VALUE AS "REDO LOG BUFFER"
FROM V$PARAMETER
WHERE NAME = 'log_buffer';

select *
FROM V$sgastat
WHERE pool = 'large pool' and  name = 'free memory';

select username, sid, serial#, server, paddr, status from v$session where username is not null;

select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

SELECT spid, pname, username, program
FROM v$process
WHERE background = 0;

SELECT COUNT(*) AS "Number of DBWn processes"
FROM v$process
WHERE pname LIKE 'DBW%';

SELECT DISTINCT name
FROM v$active_services;

SELECT name, value
FROM v$parameter
WHERE name LIKE '%dispatch%';

--"C:\OracleDataBase2\bin\lsnrctl.exe"

--lsnrctl status