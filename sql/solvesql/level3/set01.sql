/* 문제1 - 복수 국적 메달 수상한 선수 찾기
  https://solvesql.com/problems/multiple-medalist/
   '2000년 이후' 키워드를 못 봐서 조금 헤맸다..ㅎ 조인 개수 줄이려고 WITH로 나눠봤다!
*/
WITH record AS (
    SELECT r.athlete_id
    FROM records r
    JOIN games g ON r.game_id = g.id
    WHERE
        r.medal is not NULL
      AND g.year >= 2000
    GROUP BY r.athlete_id
    HAVING COUNT(DISTINCT r.team_id) >= 2
)
SELECT
    name
FROM athletes
WHERE id IN record
ORDER BY 1;

/* 문제2 - 할부는 몇 개월로 해드릴까요
  https://solvesql.com/problems/installment-month/
*/
SELECT
    payment_installments,
    COUNT(DISTINCT order_id) as order_count,
    MIN(payment_value) as min_value,
    MAX(payment_value) as max_value,
    AVG(payment_value) as avg_value
FROM
    olist_order_payments_dataset
WHERE payment_type = 'credit_card'
GROUP BY payment_installments;

/* 문제3 - 지역별 주문의 특징
  https://solvesql.com/problems/characteristics-of-orders/
   컬럼별로 나와야하는 숫자가 달라서 DISTINCT를 걸어줘야겠다고 고민했는데 어디에 넣을 지 몰라서 헤맸던.. COUNT() 안에 CASE문에 DISTINCT를 걸어주면 된다.
*/
SELECT
    region as 'Region',
    COUNT(DISTINCT(CASE WHEN category = 'Furniture' THEN order_id END)) AS 'Furniture',
    COUNT(DISTINCT(CASE WHEN category = 'Office Supplies' THEN order_id END)) AS 'Office Supplies',
    COUNT(DISTINCT(CASE WHEN category = 'Technology' THEN order_id END)) AS 'Technology'
FROM records
WHERE country = 'United States'
GROUP BY 1
ORDER BY 1;

/* 문제4 - 배송 예정일 예측 성공과 실패
  https://solvesql.com/problems/estimated-delivery-date/
*/
SELECT
    STRFTIME('%Y-%m-%d', order_purchase_timestamp) as 'purchase_date',
    COUNT(DISTINCT(CASE WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN order_id END)) as 'success',
    COUNT(DISTINCT(CASE WHEN order_estimated_delivery_date < order_delivered_customer_date THEN order_id END)) as 'fail'
FROM
    olist_orders_dataset
WHERE order_purchase_timestamp >= '2017-01' and order_purchase_timestamp < '2017-02'
GROUP BY 1
ORDER BY 1;

/* 문제5 - 배송 예정일 예측 성공과 실패
  https://solvesql.com/problems/daily-arppu/
   ARPPU는 기본이라 잘 하고 싶었다 !
*/
SELECT
    DATE(o.order_purchase_timestamp) AS dt,
    COUNT(distinct o.customer_id) AS pu,
    ROUND(SUM(p.payment_value),2) AS revenue_daily,
    ROUND(SUM(p.payment_value)/COUNT(distinct o.customer_id),2) AS arppu
FROM olist_orders_dataset o
INNER JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
WHERE dt >= '2018-01-01'
GROUP BY 1;

/* 문제6 - 멘토링 짝꿍 리스트
  https://solvesql.com/problems/mentor-mentee-list/
*/
SELECT
    e.employee_id as mentee_id,
    e.name as mentee_name,
    m.employee_id as mentor_id,
    m.name as mentor_name
FROM employees e, employees m
WHERE e.department != m.department
  AND e.join_date >= '2021-10-31' and e.join_date <= '2021-12-31'
  AND m.join_date <= '2019-12-31'
ORDER BY 1,3;

/* 문제7 - 작품이 없는 작가 찾기
  https://solvesql.com/problems/artists-without-artworks/
*/
SELECT
    a.artist_id,
    a.name
FROM artists a
LEFT JOIN artworks_artists z ON a.artist_id = z.artist_id
WHERE z.artist_id is NULL
  AND a.death_year is NOT NULL;