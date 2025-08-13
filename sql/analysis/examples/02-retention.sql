/* Google Gemini로 생성했습니다.
--------------------------------------------------------------------------------
-- 문제 1: 신규 유저의 1일차 재방문율(Day-1 Retention) 계산
--------------------------------------------------------------------------------
--
-- 시나리오:
-- 당신은 모바일 게임 회사 '제미니 게임즈'의 데이터 분석가입니다.
-- 최근 마케팅 팀에서 2024년 5월에 가입한 신규 유저들이 얼마나 게임에 다시 접속하는지 궁금해하고 있습니다.
-- 이들의 1일차 재방문율을 계산하여 마케팅 성과 분석에 필요한 데이터를 제공해야 합니다.
--
-- 데이터베이스 스키마:
-- 1. users - 유저 정보 테이블
--    - user_id (INT): 유저 고유 ID (Primary Key)
--    - signup_date (DATE): 가입일
--
-- 2. game_access - 게임 접속 기록 테이블
--    - log_id (INT): 로그 고유 ID (Primary Key)
--    - user_id (INT): 유저 고유 ID (Foreign Key)
--    - access_date (DATE): 접속일
--
-- 요구사항:
-- 1. 분석 대상: 2024년 5월에 가입한 유저들(Cohort)을 대상으로 합니다.
-- 2. 재방문(Retention)의 정의: 가입일 바로 다음 날(signup_date + 1일)에 접속한 경우를 '1일차 재방문'으로 정의합니다.
-- 3. 결과: 1일차 재방문율을 백분율(%)로 계산하여 소수점 둘째 자리까지 반올림하여 보여주세요.
--    * 계산식: (1일차에 재방문한 유저 수 / 2024년 5월 총 가입 유저 수) * 100
--
--------------------------------------------------------------------------------
*/
-- 첫번째 답변
WITH total AS (
    SELECT COUNT(DISTINCT user_id) -- 여기서 COUNT 뽑아도 테이블이기에 아래에서 연산이 제대로 안 될 수 있다고 함
    FROM USERS
    WHERE DATE_FORMAT(signup_date, '%Y-%m') = '2024-05' -- 원래 like를 썼는데 DATE_FORMAT 이나 BETWEEN을 쓰는게 날짜 관련 함수에서 에러를 덜 불러일으킨다고 함 (BETWEEN이 format보다 훨씬 좋다고함)
)

SELECT
    ROUND((COUNT(DISTINCT user_id)/total)*100,2)
FROM
    USERS u
JOIN
    GAME_ACCESS g
ON
    u.user_id = g.user_id
WHERE g.ACCESS_DATE = DATEADD(DAY, 1, u.SIGNUP_DATE)
    AND DATE_FORMAT(u.signup_date, '%Y-%m') = '2024-05'; -- DATEADD는 SQL Server, DATE_FORMAT은 MySQL에서 사용하는 함수라서 한 쿼리에서 다른 데이터베이스 함수 섞어쓰면 에러 난다고 함.


-- 고친 답변
WITH cohort AS (
    SELECT
        user_id,
        signup_date
    FROM USERS
    WHERE signup_datetime >= '2024-05-01' AND signup_datetime < '2024-06-01'
), retained_users AS (
    SELECT
        DISTINCT c.user_id
    FROM
        cohort c
    JOIN
        GAME_ACCESS g ON c.user_id = g.user_id
    WHERE g.ACCESS_DATE = DATEADD(DAY, 1, c.SIGNUP_DATE);
)

SELECT
    ROUND(
        (SELECT COUNT(*) FROM retained_users) * 100.0 / (SELECT COUNT(*) FROM cohort), 2
    ) AS day_1_retention_rate;