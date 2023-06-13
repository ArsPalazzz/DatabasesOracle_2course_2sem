ALTER DATABASE OPEN;
--1
--drop table t_range
CREATE TABLE T_RANGE
(
    id NUMBER,
    value VARCHAR2(100)
)
PARTITION BY RANGE (id)
(
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (200),
    PARTITION p3 VALUES LESS THAN (MAXVALUE)
);

--2
CREATE TABLE T_INTERVAL
(
  id NUMBER,
  start_date DATE,
  end_date DATE,
  value VARCHAR2(255)
)
PARTITION BY RANGE (start_date)
(
  PARTITION p1 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
  PARTITION p2 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
  PARTITION p3 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

--вторая версия 
CREATE TABLE T_INTERVAL 
(
  DateKey date
)
PARTITION BY RANGE (DateKey)
INTERVAL (INTERVAL '1' MONTH)
(
  PARTITION before_2023 VALUES LESS THAN (TO_DATE('01-01-2023','dd-mm-yyyy'))
);

--3
CREATE TABLE T_HASH
(
    id NUMBER,
    value VARCHAR2(100),
    hash_key VARCHAR2(100)
)
PARTITION BY HASH (hash_key) PARTITIONS 3;

--4
CREATE TABLE T_LIST
(
    id NUMBER,
    value VARCHAR2(100),
    list_key CHAR(1)
)
PARTITION BY LIST (list_key)
(
    PARTITION p1 VALUES ('A'),
    PARTITION p2 VALUES ('B'),
    PARTITION p3 VALUES ('C')
);

--5
select * from T_Range;
-- Для таблицы T_RANGE
INSERT INTO T_RANGE (ID, value) VALUES (50, 'John');
INSERT INTO T_RANGE (ID, value) VALUES (150, 'Alice');
INSERT INTO T_RANGE (ID, value) VALUES (250, 'Bob');

-- Для таблицы T_INTERVAL
INSERT INTO T_INTERVAL (id, start_date, end_date, value)
VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 'Value 1');

INSERT INTO T_INTERVAL (id, start_date, end_date, value)
VALUES (2, TO_DATE('2023-02-15', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'), 'Value 2');

INSERT INTO T_INTERVAL (id, start_date, end_date, value)
VALUES (3, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'), 'Value 3');

-- Для таблицы T_HASH
INSERT INTO T_HASH (id, value, hash_key) VALUES (101, 'John', 'A');
INSERT INTO T_HASH (id, value, hash_key) VALUES (102, 'Alice', 'B');
INSERT INTO T_HASH (id, value, hash_key) VALUES (103, 'Bob', 'C');

-- Для таблицы T_LIST
INSERT INTO T_LIST (ID, value, list_key) VALUES (201, 'John', 'A');
INSERT INTO T_LIST (ID, value, list_key) VALUES (202, 'Alice', 'B');
INSERT INTO T_LIST (ID, value, list_key) VALUES (203, 'Bob', 'C');

-- Проверка размещения данных в секциях

-- Для таблицы T_RANGE
SELECT * FROM T_RANGE PARTITION (P1); -- Выведет данные с ID=50

SELECT * FROM T_RANGE PARTITION (P2); -- Выведет данные с ID=150

SELECT * FROM T_RANGE PARTITION (P3); -- Выведет данные с ID=250

-- Для таблицы T_INTERVAL
SELECT * FROM T_INTERVAL PARTITION (P1); -- Выведет данные с DATE_CREATED=2021-01-01

SELECT * FROM T_INTERVAL PARTITION (P2); -- Выведет данные с DATE_CREATED=2022-02-02

SELECT * FROM T_INTERVAL PARTITION (P3); -- Выведет данные с DATE_CREATED=2023-03-03

-- Для таблицы T_HASH
SELECT * FROM T_HASH PARTITION FOR ('A'); -- Выведет данные с CATEGORY='A'

SELECT * FROM T_HASH PARTITION FOR ('B'); -- Выведет данные с CATEGORY='B'

SELECT * FROM T_HASH PARTITION FOR ('C'); -- Выведет данные с CATEGORY='C'

-- Для таблицы T_LIST
SELECT * FROM T_LIST PARTITION (P1); -- Выведет данные с GRADE='A'

SELECT * FROM T_LIST PARTITION (P2); -- Выведет данные с GRADE='B'

SELECT * FROM T_LIST PARTITION (P3); -- Выведет данные с GRADE='C'


--6
ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
ALTER TABLE T_LIST ENABLE ROW MOVEMENT;

UPDATE T_RANGE SET ID = 102 WHERE ID = 55;

UPDATE T_INTERVAL SET start_date = TO_DATE('2022-02-02', 'YYYY-MM-DD') WHERE start_date = TO_DATE('2022-01-01', 'YYYY-MM-DD');

UPDATE T_HASH SET hash_key = 'B' WHERE hash_key = 'A';

UPDATE T_LIST SET list_key = 'C' WHERE list_key = 'A';

--7
ALTER TABLE T_RANGE MERGE PARTITIONS p1,p2
  INTO PARTITION p2;
  select * from user_tab_partitions where table_name = 'T_RANGE';
  
--8
alter table t_range SPLIT PARTITION p2 INTO
(
  PARTITION p1 values less than (100),
  PARTITION p2 
);

--9 
CREATE TABLE T_RANGE__
(
    id NUMBER,
    value VARCHAR2(100)
)
insert into t_range__ values (0,'qwe');

alter table t_range EXCHANGE PARTITION p1 WITH TABLE t_range__ WITHOUT VALIDATION;
select * from t_range partition (p1);

--10 
SELECT table_name
FROM all_tab_partitions

SELECT partition_name
FROM all_tab_partitions
WHERE table_name = 'T_RANGE';

SELECT *
FROM T_RANGE PARTITION (p1);

SELECT *
FROM T_RANGE PARTITION FOR(0);