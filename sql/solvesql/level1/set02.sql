/* 문제11 - 많이 주문한 테이블 찾기
  https://solvesql.com/problems/find-tables-with-high-bill/
*/
-- Group by를 못 쓰는 상황에서 Where 절에 AVG를 어떻게 고민할까 많이 고민했는데 서브쿼리가 있었다..!
SELECT *
FROM TIPS
WHERE TOTAL_BILL > (
    SELECT AVG(TOTAL_BILL) FROM TIPS
);

/* 문제12 - 레스토랑의 일일 평균 매출액 계산하기
  https://solvesql.com/problems/sales-summary/
*/
SELECT
    ROUND(AVG(sales),2) as avg_sales
FROM (
     SELECT
         SUM(TOTAL_BILL) as sales
     FROM TIPS
     GROUP BY DAY
     );

/* 문제13 - 레스토랑의 영업일
  https://solvesql.com/problems/restaurant-business-day/
*/
SELECT
    DISTINCT DAY as day_of_week
FROM TIPS;

/* 문제14 - 크리스마스 게임 찾기
  https://solvesql.com/problems/restaurant-business-day/
*/
SELECT
    GAME_ID,
    NAME,
    YEAR
FROM GAMES
WHERE NAME LIKE '%Christmas%' or NAME LIKE '%Santa%';

/* 문제15 - 펭귄 조사하기
  https://solvesql.com/problems/inspect-penguins/
*/
SELECT
    DISTINCT SPECIES,
    ISLAND
FROM PENGUINS
ORDER BY ISLAND;

/* 문제16 - 지자체별 따릉이 정류소 개수 세기
  https://solvesql.com/problems/count-stations/
*/
SELECT
    LOCAL,
    COUNT(*) as num_stations
FROM STATION
GROUP BY LOCAL
ORDER BY NUM_STATIONS;

/* 문제17 - 메리 크리스마스 2024
  https://solvesql.com/problems/merry-christmas-2024/
*/
SELECT 'Merry Christmas!';