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