GRANT CREATE TABLE TO PAVCORE;
GRANT INSERT ON TBL_LAB14 TO PAVCORE;
GRANT INSERT ON MY_AUDIT TO PAVCORE;
GRANT CREATE TRIGGER TO PAVCORE_14;

GRANT ALTER ON TBL_LAB14 TO PAVCORE_14;

--1. Create table with some atributes (primary key)
drop table TBL_LAB14;

CREATE TABLE TBL_LAB14
(
    PK int,
    str1 varchar(20) NOT NULL,
    str2 int NULL,
    PRIMARY KEY (PK),
    CONSTRAINT CHECK_str2 CHECK (str2 between 0 and 100)
);
    
--2. fill table with rows (10 items)
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (1, 'one', 10);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (2, 'two', 9);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (3, 'three', 8);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (4, 'four', 7);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (5, 'five',6);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (6, 'six', 5);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (7, 'seven', 4);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (8, 'eight', 3);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (9, 'nine', 2);
INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (10, 'ten', 1);

SELECT * FROM TBL_LAB14; 

--3. create BEFORE trigger INSERT, DELETE, UPDATE (operator-level)
--select * from auditorium;

create or replace trigger auditorium_before_insert                                                --before insert
before insert on auditorium
begin
  dbms_output.put_line('Attention! Auditorium_before_insert_trigger is active');
end;

insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type)
  values ('300-1', '300-1', 180, 'LK');

--drop trigger auditorium_before_insert;

create or replace trigger auditorium_before_update                                                --before update
before update on auditorium
begin
  dbms_output.put_line('Attention! Auditorium_before_UPDATE_trigger is active');
end;

update auditorium set auditorium_capacity = 100 where auditorium_name = '300-1';

--drop trigger auditorium_before_update;

create or replace trigger auditorium_before_delete
before delete on auditorium
begin
  dbms_output.put_line('Attention! Auditorium_before_DELETE_trigger is active');
end;

delete auditorium where auditorium_name = '300-1';
--drop trigger auditorium_before_delete;

--4. create before-trigger (stroke level) insert, update, delete
create or replace trigger TBL_LAB14_bfr_foreachrow_upd
before update on TBL_LAB14
for each row
begin
  dbms_output.put_line('TBL_LAB14_bfr_foreachrow_upd is active');
end;

update TBL_LAB14 set str1 = 'TEN' where str2 = '10';
--drop trigger TBL_LAB14_bfr_foreachrow_upd;

--5. predicates INSERTING, UPDATING, DELETING
create or replace trigger auditorium_before_1
before insert or update or delete on auditorium
begin
  if inserting then
    dbms_output.put_line('auditorium_after_insert_1');
  elsif updating then
    dbms_output.put_line('auditorium_after_update_1');
  elsif deleting then
    dbms_output.put_line('auditorium_after_delete_1');
  end if;
end;

insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type) values ('300-1', '300-1', 180, 'LK');
update auditorium set auditorium_capacity = 100 where auditorium_name = '300-1';
delete auditorium where auditorium_name = '300-1';

--drop trigger auditorium_before_1;

--6. after-trigger insert, update, delete
create or replace trigger TBL_LAB14_after_insert
after insert on TBL_LAB14
begin 
  dbms_output.put_line('TBL_LAB14: after insert');
end;

create or replace trigger TBL_LAB14_after_update
after update on TBL_LAB14
begin
  dbms_output.put_line('TBL_LAB14: after update');
end;

create or replace trigger TBL_LAB14_after_delete
after delete on TBL_LAB14
begin
  dbms_output.put_line('TBL_LAB14: after delete');
end;

INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (11, 'eleven', 19);
UPDATE TBL_LAB14 set str1 = 'NINE' where str2 = 9;
delete TBL_LAB14 where str2 = 9;                             

--drop trigger TBL_LAB14_after_insert;
--drop trigger TBL_LAB14_after_update;
--drop trigger TBL_LAB14_after_delete;

--7. after trigger for eache row
create or replace trigger TBL_LAB14_after_foreachrow
after insert or update or delete on TBL_LAB14
for each row
begin
  if inserting then
    DBMS_OUTPUT.PUT_LINE(' TBL_LAB14: after insert (for each row)');
  elsif updating then
      DBMS_OUTPUT.PUT_LINE(' TBL_LAB14: update insert (for each row)');
  elsif deleting then
    DBMS_OUTPUT.PUT_LINE(' TBL_LAB14: delete insert (for each row)');
  end if;
end;


INSERT INTO TBL_LAB14(str1, str2)  VALUES ('nine', 9);
UPDATE TBL_LAB14 set str1 = 'NINE' where str2 = 9;
delete TBL_LAB14 where str2 = 9;

select * from TBL_LAB14;

--drop trigger TBL_LAB14_after_foreachrow;

--8. create table AUDIT
CREATE TABLE MY_AUDIT
(
    ID int,
    OperationDate date NOT NULL,
    OperationType varchar(6) NOT NULL,
    TriggerName varchar(30) NOT NULL,
    OldData varchar(200) NULL,
    NewData varchar(200) NULL,
    PRIMARY KEY (ID)
);

--9. change triggers to allow rigistrate all operations from first version table
-- мен€ем какждый раз как запускаем ID в трех местах
create or replace trigger TBL_LAB14_before_foreachrow
before insert or delete or update on TBL_LAB14
for each row
begin
  if inserting then
    begin
      insert into MY_AUDIT(ID, OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, OLDDATA, NEWDATA) VALUES
      (13, SYSDATE, 'INSERT', 'TBL_LAB14_before_foreachrow', 
                      NULL,
                     'PK: ' || :NEW.PK || ', str1: ' || :NEW.str1 || ', str2: ' || :NEW.str2);
    end;
  elsif deleting then
    begin
      insert into MY_AUDIT(ID, OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, OLDDATA, NEWDATA) VALUES
      (13, SYSDATE, 'DELETE', 'TBL_LAB14_before_foreachrow',
                     'PK: ' || :OLD.PK || ', str1: ' || :OLD.str1 || ', str2: ' || :OLD.str2,
                     NULL);
    end;
  elsif updating then
    begin
      insert into MY_AUDIT(ID, OPERATIONDATE, OPERATIONTYPE, TRIGGERNAME, OLDDATA, NEWDATA) VALUES
      (13, SYSDATE, 'DELETE', 'TBL_LAB14_before_foreachrow',
                     'PK: ' || :OLD.PK || ', str1: ' || :OLD.str1 || ', str2: ' || :OLD.str2,
                     'PK: ' || :NEW.PK || ', str1: ' || :NEW.str1 || ', str2: ' || :NEW.str2);
    end;
  end if;
end;

--drop trigger TBL_LAB14_before_foreachrow

INSERT INTO TBL_LAB14(PK, str1, str2)  VALUES (14, 'forteen', 45);
UPDATE TBL_LAB14 set str1 = 'FoRteeN' where str2 = 5;
delete TBL_LAB14 where str2 = 45;

select * from MY_AUDIT;


--10. ¬ыполните операцию, нарушающую целостность таблицы по первичному ключу. 
--¬ы€сните, зарегистрировал ли триггер это событие.
select * from auditorium;

create or replace trigger auditorium_after_insert    --before execute, after no                                           
before insert on auditorium
begin
  dbms_output.put_line('Attention! Auditorium_after_insert_trigger is active');
end;

insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type)
  values ('206-1', '206-1', 18, 'LB-K');
  
  --drop trigger auditorium_after_insert
  
  
--11. drop table, check triggers
drop table TBL_LAB14;

create or replace trigger TBL_LAB14_CANNOT_BE_DELETED
  before drop on SCHEMA
  begin
    if ora_dict_obj_name = 'TBL_LAB14'
      then raise_application_error(-20000, 'Unable to delete TBL_LAB14');
    end if;
  end;
drop table TBL_LAB14;
--drop trigger TBL_LAB14_CANNOT_BE_DELETED;

--12.
drop table MY_AUDIT;

SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS;


--13.
CREATE VIEW TBL_LAB14_VIEW AS SELECT * FROM TBL_LAB14;
drop view TBL_LAB14_VIEW;

CREATE OR REPLACE TRIGGER trg_update_lab14
INSTEAD OF UPDATE ON TBL_LAB14_VIEW
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
BEGIN
    -- добавл€ем новую строку в таблицу
    INSERT INTO TBL_LAB14 (PK, str1, str2) VALUES (:NEW.PK+10, :NEW.str1, :NEW.str2);
    -- помечаем старую строку как недействительную
    UPDATE TBL_LAB14 SET str2 = NULL WHERE PK = :OLD.PK;
END;


UPDATE TBL_LAB14_VIEW
SET str1 = 'newNumber', str2 = '15'
WHERE PK = '5';

select * from TBL_LAB14;

drop trigger trg_update_lab14;
drop trigger trg_instead_of_update;


--15. show order of execution of triggers

-- 
CREATE OR REPLACE TRIGGER trg_insert_1
AFTER INSERT ON TBL_LAB14
FOR EACH ROW
BEGIN
    dbms_output.put_line('Trigger 1 fired');
END;

-- 
CREATE OR REPLACE TRIGGER trg_insert_2
AFTER INSERT ON TBL_LAB14
FOR EACH ROW
BEGIN
    dbms_output.put_line('Trigger 2 fired');
END;

-- 
CREATE OR REPLACE TRIGGER trg_insert_3
AFTER INSERT ON TBL_LAB14
FOR EACH ROW
BEGIN
    dbms_output.put_line('Trigger 3 fired');
END;

select * from TBL_LAB14;

 DELETE FROM TBL_LAB14
  WHERE PK = '16';

INSERT INTO TBL_LAB14 (PK, str1, str2) VALUES (16, 'test', 50);

-- в более новых верси€х, но не в моей
ALTER TRIGGER trg_insert_2 FOLLOWS trg_insert_1;
ALTER TRIGGER trg_insert_2 PRECEDES trg_insert_1;
--INSERT INTO TBL_LAB14 (str1, str2) VALUES ('test', 50);






--sp_settriggerorder [@trg_insert_2 =] 'trg_insert_2'
--, [@order =] '1'
--, [@stmttype =] '1'
