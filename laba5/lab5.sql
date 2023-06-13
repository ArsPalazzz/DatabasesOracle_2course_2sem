--1. Получите список всех табличных пространств.
select * from dba_tablespaces;

--2
create tablespace VVS_QDATA_L5
  datafile 'E:\Apps\Oracle\labs\lab5\VVS_QDATA_L5.dbf'
  size 10 m
  autoextend on next 5 m
  maxsize 30 m
  extent management local
  offline;

alter tablespace VVS_QDATA_L5 online;

alter user SYS
  default tablespace VVS_QDATA_L5 quota 2m on VVS_QDATA_L5;
    
create table VVS_T1(num int primary key, text varchar(150)) tablespace VVS_QDATA_L5;

insert into VVS_T1 values (1, 'one');
insert into VVS_T1 values (2, 'two');
insert into VVS_T1 values (3, 'three');

select * from VVS_T1;
  
--3. Список сегментов VVS_QDATA
select * from user_segments where tablespace_name = 'VVS_QDATA_L5';

--6
drop table VVS_T1;

--7
select * from user_segments where tablespace_name = 'VVS_QDATA_L5';
select * from USER_RECYCLEBIN;

--8. Восстановите (FLASHBACK) удаленную таблицу. 
flashback table VVS_T1 to before drop;

--9. Заполнение на 10000 сторок
declare i int:= 4;
begin loop i:=i+1;
  insert into VVS_T1 values (i,'number');
  exit when (i = 10000);
end loop;
end;

select * from VVS_T1;

--10
--how many extents
select * from user_segments where tablespace_name = 'VVS_QDATA_L5';
select * from user_extents where segment_name = 'VVS_T1';

--11. Список всех сегментов в БД
select * from user_extents;

--12
select rowid from VVS_T1;

--13
select ora_rowscn from VVS_T1;

--16.
drop tablespace VVS_QDATA_L5 including contents and datafiles;

-- теория - отображение всех типов сегментов
select distinct segment_type from dba_segments;
-- отображение занимаемых байтов и блоков сегментов нашей таблицы
select bytes, blocks from user_segments where tablespace_name = 'VVS_QDATA_L5';
