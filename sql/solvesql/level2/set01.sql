/* 문제1 - 두 테이블 결합하기
  https://solvesql.com/problems/join/
*/
SELECT
    DISTINCT r.athlete_id
FROM RECORDS r
JOIN EVENTS e
    ON r.event_id = e.id
WHERE e.SPORT = 'Golf';

/* 문제2 - 레스토랑 웨이터의 팁 분석
  https://solvesql.com/problems/tip-analysis/
*/
SELECT
    DAY,
    TIME,
    ROUND(AVG(TIP),2) as avg_tip,
    ROUND(AVG(SIZE),2) as avg_size
FROM TIPS
GROUP BY DAY, TIME
ORDER BY DAY, TIME;

/* 문제3 - 일별 블로그 방문자 수 집계
  https://solvesql.com/problems/blog-counter/
*/
SELECT
    DATE(EVENT_DATE_KST) as dt,
    COUNT(DISTINCT user_pseudo_id) as users
FROM GA
WHERE DT
    BETWEEN '2021-08-02' AND '2021-08-09'
GROUP BY DT
ORDER BY DT;

/* 문제4 - 우리 플랫폼에 정착한 판매자 2
  https://solvesql.com/problems/settled-sellers-2/
  주문당 금액이 50이 넘는 판매 건수가 100건이 넘는 판매자를 찾는 문제 ,, where과 having을 동시에 써야하는 게 헷갈렸다. 시간을 많이 썼다.
*/
SELECT
    SELLER_ID,
    COUNT(DISTINCT ORDER_ID) as orders
FROM
    OLIST_ORDER_ITEMS_DATASET
WHERE
    PRICE >= 50
GROUP BY
    SELLER_ID
HAVING
    COUNT(DISTINCT ORDER_ID) >= 100
ORDER BY orders DESC;

/* 문제5 - 레스토랑의 일일 매출
  https://solvesql.com/problems/daily-revenue/
*/
SELECT
    DAY,
    SUM(TOTAL_BILL) as 'revenue_daily'
FROM TIPS
GROUP BY DAY
HAVING revenue_daily >= 1000
ORDER BY revenue_daily DESC;

/* 문제6 - 버뮤다 삼각지대에 들어가버린 택배
  https://solvesql.com/problems/shipment-in-bermuda/
  DATE 함수를 SELECT절에 쓰고 alias로 Group by에서도 함께 쓸 수 있었는데 이걸 인지하지 못해서 틀렸다. DATE 빼고는 잘 작동했다.
*/
SELECT
    DATE(ORDER_DELIVERED_CARRIER_DATE) as delivered_carrier_date,
    COUNT(DISTINCT ORDER_ID) as orders
FROM
    OLIST_ORDERS_DATASET
WHERE
    ORDER_DELIVERED_CUSTOMER_DATE is NULL
  AND
    delivered_carrier_date like '2017-01%'
GROUP BY
    delivered_carrier_date
ORDER BY
    delivered_carrier_date;