--1. Получите список всех существующих PDB в рамках экземпляра ORA12W. 
--Определите их текущее состояние.
select name, open_mode, con_id from v$pdbs; 
select pdb_name, pdb_id, status from SYS.dba_pdbs;

--3. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров.
select * from v$instance;

--4. Подключитесь к XXX_PDB c помощью SQL Developer создайте инфраструктурные объекты (табличные пространства, роль, 
--профиль безопасности, пользователя с именем U1_XXX_PDB).

ALTER SESSION SET "_ORACLE_SCRIPT"=true

CREATE TABLESPACE TS_VVS
    DATAFILE 'TS_vvs_pdb.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
CREATE TEMPORARY TABLESPACE  TS_VVS_TEMP
    TEMPFILE 'C:\БД\3\TS_vvs_temp_pdb.dbf'
    SIZE 5 m
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 30M
    EXTENT MANAGEMENT LOCAL;
    
CREATE ROLE RL_VVSCORE;

--drop role RL_HANCORE

grant create session,
      create table,
      create view,
      create procedure,
      drop any table,
      drop any view,
      drop any procedure 
to RL_VVSCORE;
commit;

grant create session to RL_VVSCORE;
select * from dba_sys_privs where grantee = 'RL_VVSCORE';

CREATE PROFILE PF_VVSCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;

--select * from v$pdbs;


create user U1_VVS_PDB identified by 12345
default tablespace TS_VVS quota unlimited on TS_VVS
temporary tablespace TS_VVS_TEMP
account unlock;


grant create session to U1_VVS_PDB
grant create table to U1_VVS_PDB


--5. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.

create table VVS_table ( x int , y varchar(5))

insert into VVS_table values (1, 'frst');
insert into VVS_table values (3, 'thrd');

select * from VVS_table


--6.
select * from DBA_TABLESPACES; 
select * from DBA_ROLES;
select * from DBA_PROFILES;  
select * from ALL_USERS;

select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS; 

--7. 
create user CCVVS identified by 12345
account unlock;
grant create session to CCVVS;
grant create table to CCVVS;

-- from VVS_pdb
grant create session to CCVVS;

--9. Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных и XXX_PDB – базе данных.

--10. Подключитесь пользователем C##XXX, создайте таблицу и добавьте в нее данные.
create table CVVSC ( x int , y varchar(5))

insert into CVVSC values (1, 'frst');
insert into CVVSC values (2, 'scnd');

select * from CVVSC

--11. Просмотрите все объекты, доступные пользователям C##XXX и U1_XXX_PD.
select * from dba_data_files;
select * from user_objects;


alter pluggable database VVS_pdb close immediate;
drop pluggable database VVS_pdb;


drop user CVVSC cascade;