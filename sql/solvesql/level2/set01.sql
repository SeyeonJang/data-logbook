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