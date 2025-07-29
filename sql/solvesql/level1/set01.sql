/* 문제1 - 모든 데이터 조회하기
  https://solvesql.com/problems/select-all/
*/
SELECT * FROM POINTS;

/* 문제2 - 일부 데이터 조회하기
  https://solvesql.com/problems/select-where/
*/
SELECT *
FROM POINTS
WHERE QUARTET = 'I';

/* 문제3 - 데이터 정렬하기
  https://solvesql.com/problems/order-by/
*/
SELECT *
FROM POINTS
WHERE QUARTET = 'I'
ORDER BY Y;

/* 문제4 - 데이터 그룹으로 묶기
  https://solvesql.com/problems/group-by/
*/
SELECT
    QUARTET,
    ROUND(AVG(X),2) AS 'x_mean',
    ROUND(VARIANCE(X),2) AS 'x_var',
    ROUND(AVG(Y),2) AS 'y_mean',
    ROUND(VARIANCE(Y),2) AS 'y_var'
FROM POINTS
GROUP BY QUARTET;

/* 문제5 - 특정 컬럼만 조회하기
  https://solvesql.com/problems/select-column/
*/
SELECT X, Y FROM POINTS;

/* 문제6 - 몇 분이서 오셨어요?
  https://solvesql.com/problems/size-of-table/
*/
SELECT *
FROM TIPS
WHERE SIZE%2=1;

/* 문제7 - 최근 올림픽이 개최된 도시
  https://solvesql.com/problems/olympic-cities/
*/
SELECT
    YEAR,
    UPPER(SUBSTRING(CITY,1,3)) AS 'city'
FROM GAMES
WHERE YEAR >= 2000
ORDER BY YEAR DESC;

/* 문제8 - 우리 플랫폼에 정착한 판매자 1
  https://solvesql.com/problems/settled-sellers-1/
*/
-- ORDERS >= 100 을 WHERE 절에 썼는데, WHERE절이 SELECT절보다 먼저 실행돼서 ORDERS를 이해하지 못했다. HAVING 잊지 않기
-- ORDER_ID에 DISTINCT 걸어야하는 것도 잊지 않기
SELECT
    SELLER_ID,
    COUNT(DISTINCT(ORDER_ID)) AS 'orders'
FROM OLIST_ORDER_ITEMS_DATASET
GROUP BY SELLER_ID
HAVING ORDERS >= 100;

/* 문제9 - 최고의 근무일을 찾아라
  https://solvesql.com/problems/best-working-day/
*/
SELECT
    DAY,
    ROUND(SUM(TIP),3) AS 'tip_daily'
FROM TIPS
GROUP BY DAY
ORDER BY tip_daily DESC LIMIT 1;

/* 문제10 - 첫 주문과 마지막 주문
  https://solvesql.com/problems/first-and-last-orders/
*/
SELECT
    MIN(DATE(ORDER_PURCHASE_TIMESTAMP)) AS 'first_order_date',
    MAX(DATE(ORDER_PURCHASE_TIMESTAMP)) AS 'last_order_date'
FROM OLIST_ORDERS_DATASET;