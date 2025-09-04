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

/* 문제8 - 온라인 쇼핑몰의 월 별 매출액 집계
  https://solvesql.com/problems/shoppingmall-monthly-summary/
*/
SELECT
    STRFTIME('%Y-%m', a.order_date) as order_month,
    SUM(CASE WHEN b.order_id not like 'C%' THEN b.price*b.quantity END) as ordered_amount,
    SUM(CASE WHEN b.order_id like 'C%' THEN b.price*b.quantity END) as canceled_amount,
    SUM(b.price*b.quantity) as total_amount
FROM orders a
JOIN order_items b ON a.order_id = b.order_id
GROUP BY 1;

/* 문제9 - 게임 평점 예측하기 1
  https://solvesql.com/problems/predict-game-scores-1/
   진짜 역대급 문제 ... 너무 어려웠다 CASE 쓰는 게 어려운 게 아니라 머리 쓰는 과정이 너무나도 어려웠고, CASE문이 너무 길어져서 이게 맞나..했다
   다른 방법도 같이 남겨놓고 블로그 올리면서 다시 공부!
*/
SELECT
    game_id,
    name,
    CASE WHEN critic_score IS NULL
         THEN (SELECT ROUND(AVG(critic_score), 3) FROM games WHERE genre_id = a.genre_id)
         ELSE critic_score
        END critic_score,
    CASE WHEN critic_count IS NULL
         THEN (SELECT CEIL(AVG(critic_count)) FROM games WHERE genre_id = a.genre_id)
         ELSE critic_count
        END critic_count,
    CASE WHEN user_score IS NULL
         THEN (SELECT ROUND(AVG(user_score), 3) FROM games WHERE genre_id = a.genre_id)
         ELSE user_score
        END user_score,
    CASE WHEN user_count IS NULL
         THEN (SELECT CEIL(AVG(user_count)) FROM games WHERE genre_id = a.genre_id)
         ELSE user_count
        END user_count
FROM games a
WHERE
    year >= 2015
  AND (critic_score IS NULL OR user_score IS NULL);

/* 다른 분이 올린 코드 */
WITH genre_avg AS (
    SELECT
        genre_id,
        ROUND(AVG(critic_score), 3) AS avg_critic_score,
        CEIL(AVG(critic_count))     AS avg_critic_count,
        ROUND(AVG(user_score), 3)   AS avg_user_score,
        CEIL(AVG(user_count))       AS avg_user_count
    FROM
        games
    GROUP BY
        genre_id
)
SELECT
    g.game_id,
    g.name,
    COALESCE(g.critic_score, ga.avg_critic_score) AS critic_score,
    COALESCE(g.critic_count, ga.avg_critic_count) AS critic_count,
    COALESCE(g.user_score,   ga.avg_user_score)   AS user_score,
    COALESCE(g.user_count,   ga.avg_user_count)   AS user_count
FROM
    games g
        LEFT JOIN
    genre_avg ga ON g.genre_id = ga.genre_id
WHERE
    g.year >= 2015
  AND (g.critic_score IS NULL OR g.user_score IS NULL);