CREATE TABLE PAV_t
(
    column1 number(3),
    column2 varchar2(50),
    CONSTRAINT column1_pk PRIMARY KEY (column1)
);


INSERT INTO PAV_t (column1, column2) 
    VALUES (10, 'TEN');
    
INSERT INTO PAV_t (column1, column2)
    VALUES (11, 'ELEVEN');
    
INSERT INTO PAV_t (column1, column2) 
    VALUES (12, 'TWELVE');

UPDATE PAV_t
    SET column2 = 'TEN2'
    WHERE column1 = 10;
    
UPDATE PAV_t
    SET column2 = 'ELEVEN2'
    WHERE column1 = 11;
    
SELECT * FROM PAV_t;

SELECT * FROM PAV_t
    WHERE column1 = 10;
    
SELECT MAX(Column1), AVG(Column1) FROM PAV_t;

DELETE FROM PAV_t
    WHERE Column1 = 10;
    
    
    
CREATE TABLE PAV_t_child(
    column1 number(3),
    column2 varchar2(50),
    foreign key(column1) references PAV_t(column1)
);

INSERT INTO PAV_t_child  
    values (1, 'ONE');
INSERT INTO PAV_t_child 
    values (2, 'TWO');    
    

SELECT PAV_t.column1, PAV_t.column2, PAV_t_child.column2 FROM PAV_t
    INNER JOIN PAV_t_child
    ON PAV_t.column1 = PAV_t_child.column1;
    
SELECT PAV_t.column1, PAV_t.column2, PAV_t_child.column2 FROM PAV_t
    LEFT OUTER JOIN PAV_t_child
    ON PAV_t.column1 = PAV_t_child.column1;
    
DROP TABLE PAV_t;
DROP TABLE PAV_t_child;
    

