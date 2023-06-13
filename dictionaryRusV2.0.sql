	--Располагается в системном табличном пространстве SYSTEM
	--	USER	Объекты, принадлежащие пользователю
	--	ALL	Объекты, к которым пользователь имеет доступ 
	--	DBA	Все объекты базы данных (для администратора БД)
	--	V$	 Производительность сервера
	-- для доступа к словарю GRANT SELECT ANY DICTIONARY


--Вывод структуры представления USER_OBJECTS
DESCRIBE user_objects;

--Вывод всех таблиц пользователя
select object_name from user_objects where object_name = 'TABLE';

--Получение перечня всех пользователей
select * from dba_users;
select * from dba_users where usrname like 'C##%';

--Получение перечня всех ролей
select * from dba_roles;

--Получение перечня привелегий
select * from dba_sys_privs;

select * from dba_sys_privs where grantee = 'имя_роли';

--Вывод списка объектов БД
selct object_name, owner, status from dba_objects;

--Вывод списка пользовательских констрейнтов
select constraint_name where table_name = '...';

--Найти синонимы в представлениях словаря Oracle
select * from dba_synonyms where table_owner = 'SYS';

--Получение списка управляющих файлов
select * from v$controlfile;
select * from dba_data_files; ---------------????????????????????????????????

--Получить список действительных сервисов / точек подключений
select * from v@services;

--Получить список параметров экземпляра
select instance_name from v$instanse;
show PARAMETR instance;

---------------------------------------dba_pdbs / v$sga------------------------------
--Вывести информацию содержит информацию, о размерах каждого компонента ГСО (глоб. сис-ая область) - кэше журнала регистрации транзакций, кэш буфере данных и разделяемом пуле
select * from v$sga;

-- Второе представление содержит более подробную информацию о размерах всех компонентов, даже самых мелких, включая размеры стековых областей различного назначения. Например, для получения сведений о размере свободной памяти в ГСО дадим следующий запрос
select * from v$sgastat

--Получить информацию параметров sga
select * from v$sgainfo; --можно посмотреть размеры пулов, гранул

--
select * from v$sga_dynamic_components;

--Просмотр сведений о подключаемых БД
select name, open_mode, total_sixe from v$pdbs;
select PDB_NAME from dba_pdbs; --------------????????????????????????????????

-----------------------------------------logfile / log-------------------------------
--Получение перечня всех групп журналов повтора
select * from v$logfile;

--Определение текущей группы журнала повтора
select * from v$logfile where status = 'CURRENT';

--Получение перечня файлов всех журналов повтора
select * from v$log;

--Выведите, производится ли архивирование журналов повтора	---!!!!
select * from v$archive_dest_status;

-----------------------------------------tablespaces---------------------------

--Получение списка перманентных табличных протстранств 
select tablespace_name, status, contents logging from sys.DBA_TABLESPACES;

--Получение списка временных табличных прострнств
select file_name, tablespace_name, status, maxbytes, user_bytes from dba_data_files
UNION
select file_name, tablespace_name, status, maxbytes, user_bytes from dba_temp_files;

----------------------------------------------dba_segments--------------------------
--Получить список сегментов табличного пространства
select * from dba_segments where tablespace_name = 'имя_табличного пространства';

--Получить (вычислить) размер данных в таблице
select sum(bytes) from dba_segments where tablespase_name = 'PPPCORE';

--Вычислить количество блоков, занятых талицей
select sum(blocks) from dba_segments where tablespace_name = 'PPPCORE';

----------------------------------------------user_segments-------------------------
--Получение перечня сегментов юзера
select * from user_segments;
select bytes, blocks from user_segments;

--Создать таблицу из двух столбцов, один из которых первичный ключ.
--Получить перечень всех сегментов. Вставьте данные в таблицу. Опрделите, сколько
--в сегменте таблицы экстентов, их размер в блоках и байтах.
create table TEST 
(
	ID number(10) primary key,
	NAMEE varchar2(20)
);
insert into TEST values (1, 'TEST');
select segment_name, segment_type, EXTENTS, blocks, bytes from user_segments;

-------------------------------------------dictionary---------------------------
--Вывод списка всех представлений словаря данных, доступных пользователю
select * from dictionary;

--Поиск таблиц словаря данных по заданным темам в столбце COMMENTS таблицы DICTIONARY
select * from dictionary where lower(comments) like '%grant%';

--------------------------------------------session-----------------------------
--Выводит список всех сессий
select * from v$session;

--
select * from v$session where TYPE!='BACKGROUND';

--Получить перечень всех процессов СУБД Oracle. 
--Для серверных процессов укажите подключения. 
--Для фоновых укажите работающие в настоящий момент.
select sid, serial#, username, status, process, machine, program, type, loggon_time from v$session;
select sid, serial#, username, status, process, machine, program, type, loggon_time from v$session where type = 'BACKGROUND' and status = 'ACTIVE';

--Просмотр подключений к серверу
select * from v$session where username is not null;

-----------------------------------------------dba_profiles-----------------------
--Получение перечня всех профилей безопасностей
select * from DBA_PROFILES;

--Получение перечня всех свойств (параметров) какого-л. профиля безопасности
select * from dba_profiles where profile = 'имя_профиля_безопасности' --либо 'DEFAULT'

---------------------------------------------CREATE-----------------------------------
--Создайте таблицу и вставьте в нее 100 записей. Найдите таблицу и её свойства в представлениях словаря.
CREATE table TEST 
(
	ID number(10) primary key,
	NAMEE varchar2(20)
);
begin for i..100
	loop 
		insert into TEST values (i, 'TEST');
	end loop;
end;
select * from dba_tables where table_name = 'TEST';

--Сформируйте PFILE
CREATE PFILE = 'my_init.ora' from memory;  --в sqlplus от sysdba

--Создайте роль
CREATE ROLE TEAT_ROLE;

--Создайте профиль безопасности
CREATE profile PPPCORE limit 
	PASSWORD_LIFE_TIME 180
	SESSIONS_PER_USER 3
	FAILED_LOGIN_ATTEMPTS 7
	PASSWORD_LOCK_TIME 1
	PASSWORD_REUSE_TIME 10
	PASSWORD_GRACE_TIME DEFAULT
	CONNECT_TIME 180
	IDLE_TIME 30

--Создать табличного пространства
CREATE TABLESPACES tablespase_name
	DATAFILE 'ПУТЬ'						--TEMPFILE 'ПУТЬ'
	SIZE 10 m
	AUTOEXTEND ON NEXT 500K
	MAXSIZE 100M
	EXTENT MANAGEMENT LOCAL;

--Создание пользователя 
CREATE USER #PPPCORE IDENTIFIED BY 12345
DEFAULT TABLESPACES tablespace_name QUOTA UNLIMITED ON tablespace_name
TEMPORARY TABLESPACES temp_tablespace_name
PROFILE PPPCORE
ACCOUNT UNLOCK
PASSWORD EXPIRE
------------------------------------------------------------------------------
Вариант 1
--1. Получить список всех временных табличных пространств
 select * from dba_tablespaces where contents='TEMPORARY'
--2. Получить список привилегий для роли sys
 select * from dba_sys_privs where grantee='SYS' 
 select * from USER_sys_privs//если войти по sys 
--3. Получить список всех объектов, принадлежащих пользователю
 select * from user_OBJECTS
--4. Получить список файлов текущих журналов повтора
select * from v$log where status = 'CURRENT';
--5. Получить последний архив журналов повтора
select * from v$archived_log;
--6. Получить месторасположение файла параметров
select * from v$patameter(?)
show parameter pfile; --если нет pfile(текстовый), то найдется spfile(бинарный)
--7. Для всех таблиц. пользователя найти, в каком пуле буферного кэша
select segment_name, segment_type, tablespace_name, buffer_pool 
from dba_segments 
--8. Получить список пользователей, имеющих привилегию sysdba из файла паролей
select * from v$pwfile_users where sysdba='TRUE'
--9. Получить размер гранулы в буферном кэше
select * from v$sgainfo where name = 'Granule Size'
select component,
      current_size,
      max_size,
      granule_size from v$sga_dynamic_components where current_size>0 and component like '%buffer%';
--10. Получить список работающих в настоящее время фоновых процедур
SELECT * FROM v$BGPROCESS where paddr != hextoraw('00');

Вариант 2
--1. Показать все представления словаря, относящиеся к процессам
SELECT * FROM dict where table_name like '%PROCESS%';
--2. Получить список файлов табличных пространств отката
select * from dba_tablespaces where contents='UNDO'
--3. Получить список всех ролей
select * from DBA_ROLES ;
--4. Получить размер данных в наибольшей таблице пользователя
select pool, name, bytes 
from v$sgastat 
order by bytes desc fetch first 1 rows only;
--5. Получить размер блока данных двумя способами
show parameter db_block_size;
select distinct bytes/blocks from user_segments;
--6. Получить список параметров экземпляра
select * from v$instance;
--7. Получить месторасположение файла журнала
select * from v$logfile;
--8. Получить объем памяти, выделенный под объекты пользовательской корзины
select component, current_size 
from v$sga_dynamic_components 
where component like '%RECYCLE%'
--9. Получить список действительных сервисов
SELECT * FROM V$SERVICES;
--10. Получить список работающих в настоящее время серверных процессов.
select * from v$process;






-Вариант 1
--1. Получить список всех временных табличных пространств

--2. Получить список привилегий для роли sys

--3. Получить список всех объектов, принадлежащих пользователю

--4. Получить список файлов текущих журналов повтора

--5. Получить последний архив журналов повтора

--6. Получить месторасположение файла параметров

--7. Для всех таблиц. пользователя найти, в каком пуле буферного кэша
?
--8. Получить список пользователей, имеющих привилегию sysdba из файла паролей

--9. Получить размер гранулы в буферном кэше

--10. Получить список работающих в настоящее время фоновых процедур


--Вариант 2
--1. Показать все представления словаря, относящиеся к процессам

--2. Получить список файлов табличных пространств отката

--3. Получить список всех ролей

--4. Получить размер данных в наибольшей таблице пользователя

--5. Получить размер блока данных двумя способами

--6. Получить список параметров экземпляра

--7. Получить месторасположение файла журнала

--8. Получить объем памяти, выделенный под объекты пользовательской корзины

--9. Получить список действительных сервисов

--10. Получить список работающих в настоящее время серверных процессов.