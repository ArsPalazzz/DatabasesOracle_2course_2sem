
-- 1. Получите список всех табличных пространств (перманентных, временных и UNDO).
SELECT tablespace_name, contents 
FROM dba_tablespaces;

-- 2. Получите список всех файлов табличных пространств (перманентных, временных и UNDO).
SELECT  file_name
FROM dba_data_files 
UNION ALL 
SELECT  file_name 
FROM dba_temp_files;


-- 3. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.
SELECT group#, status
FROM v$log;

-- 4. Получите перечень файлов всех журналов повтора
SELECT member 
FROM v$logfile;


-- 5. С помощью переключения журналов повтора пройдите полный цикл переключений. Проследите последовательность SCN.
-- нужно запустить нижние две строчки трижды (если у нас 3 журнала повторения)
select * from v$log;

ALTER SYSTEM SWITCH LOGFILE;

-- 6. Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и 
-- файлов, а также в работоспособности группы (переключением). Проследите последовательность SCN. 

ALTER DATABASE ADD LOGFILE GROUP 4 'E:\Apps\Oracle\oradata\DB13\REDO04.LOG'
SIZE 50M BLOCKSIZE 512;

ALTER DATABASE ADD LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO041.LOG' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO042.LOG' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO043.LOG' TO GROUP 4;


-- 7. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.

ALTER DATABASE DROP LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO041.LOG';
ALTER DATABASE DROP LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO042.LOG';
ALTER DATABASE DROP LOGFILE MEMBER 'E:\Apps\Oracle\oradata\DB13\REDO043.LOG';

ALTER DATABASE DROP LOGFILE GROUP 4;

-- 8
SELECT NAME, LOG_MODE FROM V$DATABASE;

--11 - нужно переключиться на ту БД, где включены архивы
ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$ARCHIVED_LOG;

-- 13
SELECT * FROM V$CONTROLFILE;
-- 14
Show PARAMETER CONTROL;