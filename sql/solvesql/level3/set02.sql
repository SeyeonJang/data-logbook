/* 문제11 - 폐쇄할 따릉이 정류소 찾기 2
  https://solvesql.com/problems/find-unnecessary-station-2/
   어렵다 .. ㅠㅠ 1시간 고민했는데 못 풀었다 .. UNION ALL 공부해야겠다
*/

-- 1차 시도 : 2019년도 내용이 나오지 않아 실패 ..
WITH rental AS (
    SELECT
        bike_id,
        rent_station_id,
        return_at,
        rent_at
    FROM rental_history
    WHERE
        rent_at like '2018-10%' OR rent_at like '2019-10%'
       OR return_at like '2018-10%' OR return_at like '2019-10%'
)

SELECT
    s.station_id,
    s.name,
    s.local,
    -- 그리고 CASE문 앞에 COUNT()나 SUM()을 써서 증가되게 했어야 하는데 이거도 문법도 틀림
    ROUND(((CASE WHEN r.return_at like '2019-10%' OR r.rent_at like '2019-10%' THEN COUNT(bike_id) END) * 100.0) / (CASE WHEN r.return_at like '2018-10%' OR r.rent_at like '2018-10%' THEN COUNT(bike_id) END),2) as usage_pct
FROM station s
JOIN rental r ON s.station_id = r.rent_station_id
GROUP BY 1
HAVING COUNT(r.bike_id) != 0

-- 2차 시도 :  Gemini, 블로그와 함께 푼 2차 정답
WITH station_usage AS (
    SELECT
        station_id,
        SUM(CASE WHEN event_time LIKE '2018-10%' THEN 1 ELSE 0 END) AS usage_2018,
        SUM(CASE WHEN event_time LIKE '2019-10%' THEN 1 ELSE 0 END) AS usage_2019
    FROM (
        SELECT
            rent_station_id AS station_id,
            rent_at AS event_time
        FROM rental_history
        WHERE rent_at LIKE '2018-10%' OR rent_at LIKE '2019-10%'
        UNION ALL -- 중복 제거 없이 모두 합치기 위해 UNION ALL 사용
        SELECT
            return_station_id AS station_id,
            return_at AS event_time
        FROM rental_history
        WHERE return_at LIKE '2018-10%' OR return_at LIKE '2019-10%'
    )
    GROUP BY station_id
)
SELECT
    s.station_id,
    s.name,
    s.local,
    ROUND(u.usage_2019 * 100.0 / u.usage_2018, 2) AS usage_pct
FROM station s
JOIN station_usage u ON s.station_id = u.station_id
WHERE
    u.usage_2018 > 0
  AND u.usage_2019 > 0
  AND u.usage_2019 <= u.usage_2018 * 0.5;