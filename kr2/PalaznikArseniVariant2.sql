--1
--найти работодателей у которых цена больше 2000
CREATE OR REPLACE PROCEDURE FIND_EMP_WITH_HIGH_ORDERS
IS
BEGIN
  FOR emp IN (SELECT s.NAME
              FROM SALESREPS s
              INNER JOIN ORDERS o ON s.EMPL_NUM = o.REP
              WHERE o.AMOUNT > 2000
              ORDER BY o.AMOUNT DESC)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp.NAME);
  END LOOP;
END;

BEGIN
  FIND_EMP_WITH_HIGH_ORDERS;
END;









--2
--найти работодателей у которых больше 10 заказов и посчитать общую стоимость заказов
CREATE OR REPLACE PROCEDURE COUNT_PRODUCTS_SOLD
IS
  emp_name SALESREPS.NAME%TYPE;
  total_sold NUMBER;
BEGIN
  FOR emp IN (SELECT s.NAME, COUNT(*) AS TOTAL_SOLD
              FROM SALESREPS s
              INNER JOIN ORDERS o ON s.EMPL_NUM = o.REP
              GROUP BY s.NAME
              HAVING COUNT(*) > 10)
  LOOP
    emp_name := emp.NAME;
    total_sold := emp.TOTAL_SOLD;
    
    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_name || ', Total sold: ' || total_sold);
  END LOOP;
END;

BEGIN
  COUNT_PRODUCTS_SOLD;
END;
