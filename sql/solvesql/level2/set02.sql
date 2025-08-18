/* 문제11 - 다음날도 서울숲의 미세먼지 농도는 나쁨 😢
  https://solvesql.com/problems/bad-finedust-measure/
*/
-- 틀린 코드
SELECT
    DATE(measured_at) as today,
    DATE(measured_at, '+1 day') as next_day,
    pm10,
    LEAD(pm10) OVER (ORDER BY DATE(measured_at)) as next_pm10
FROM measurements;
-- 수정 코드
SELECT
    m1.measured_at AS today,
    m2.measured_at AS next_day,
    m1.pm10,
    m2.pm10 AS next_pm10
FROM
    measurements AS m1
        JOIN
    measurements AS m2
    ON
        m1.measured_at = DATE(m2.measured_at, '-1 day')
WHERE
    m2.pm10 > m1.pm10;

/* 문제12 - 제목이 모음으로 끝나지 않는 영화
  https://solvesql.com/problems/film-ending-with-consonant/
  정규표현식으로 '%[AEIOU]' 써서 LIKE 비교하려고 했는데 실패.. LIKE 하려면 모두 따로 써야한다ㅠ
*/
SELECT title
FROM film
WHERE
    rating IN ('R', 'NC-17')
  AND
    title NOT REGEXP ('A$|E$|I$|O$|U$');

/* 문제13 - 언더스코어(_)가 포함되지 않은 데이터 찾기
  https://solvesql.com/problems/data-without-underscore/
*/
SELECT DISTINCT page_location
FROM ga
WHERE page_location not REGEXP('_')
ORDER BY page_location;

/* 문제14 - 게임을 10개 이상 발매한 게임 배급사 찾기
  https://solvesql.com/problems/publisher-with-many-games/
*/
SELECT c.name
FROM games g
JOIN companies c ON g.publisher_id=c.company_id
GROUP BY g.publisher_id
HAVING COUNT(g.publisher_id) >= 10;

/* 문제15 - 기증품 비율 계산하기
  https://solvesql.com/problems/ratio-of-gifts/
*/
WITH gifts AS (
    SELECT *
    FROM artworks
    WHERE credit like '%gift%'
)
SELECT
    ROUND(((SELECT COUNT(*) FROM gifts) * 100.0 / COUNT(*)),3) as ratio
FROM artworks;

/* 문제16 - 최대값을 가진 행 찾기
  https://solvesql.com/problems/max-row/
  WITH 2개 써야하나 했는데 쉽게 where절에서 or로 풀 수 있었다! 다시 풀어보기 위해 다른 분의 답 한 번 보고 다른 날에 다시 처음부터 풀어서 맞췄다.
*/
SELECT
    id
FROM points
WHERE x = (SELECT MAX(x) FROM points) or y = (SELECT MAX(y) FROM points)
ORDER BY id;

/* 문제17 - 3년간 들어온 소장품 집계하기
  https://solvesql.com/problems/summary-of-artworks-in-3-years/
  case when 써서 조건 판별하는 게 어려웠다 ... 이건 나중에 다시 풀어봐야겠다.
*/
SELECT
    classification,
    COUNT(CASE WHEN STRFTIME('%Y', acquisition_date) = '2014' THEN 1 END) AS '2014',
    COUNT(CASE WHEN STRFTIME('%Y', acquisition_date) = '2015' THEN 1 END) AS '2015',
    COUNT(CASE WHEN STRFTIME('%Y', acquisition_date) = '2016' THEN 1 END) AS '2016'
FROM artworks
GROUP BY 1
ORDER BY 1;