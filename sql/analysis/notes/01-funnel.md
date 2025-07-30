## Funnel

### 1️⃣ Funnel 분석이란?
**퍼널 분석(Funnel Analysis)** 은 사용자가 목표 행동(전환)에 도달하기까지의 **단계별 이탈률을 분석**하는 기법이다.
- `예시` 앱 설치 → 회원가입 → 핵심 기능 사용
- `예시` 광고 클릭 → 랜딩 페이지 방문 → 회원가입 → 장바구니 담기 → 구매

### 2️⃣ Funnel 분석에 자주 사용하는 SQL 기법
| 기능             | SQL 문법                                       |
|----------------| -------------------------------------------- |
| 특정 행동 추출       | `WHERE event_name = '...'`                   |
| 사용자별 첫 이벤트 시간  | `MIN(event_time)` + `GROUP BY user_id`       |
| 사용자별 여러 이벤트 조합 | `CASE WHEN`, `MAX(CASE WHEN ...) THEN 1 END` |
| 퍼널 단계별 전환율 계산  | `COUNT(DISTINCT user_id)` or `WITH` 문 활용     |
| 세션 단위 분석 (심화)  | `LAG()`, `LEAD()`, `SESSION_ID` 생성 등         |

🖥️ `WITH` 문법 예시
```sql
WITH user_events AS (
  SELECT user_id, event_name, event_time
  FROM user_event_log
  WHERE event_time >= NOW() - INTERVAL '7 days'
)
SELECT user_id, COUNT(*) FROM user_events GROUP BY user_id;
```

🖥️ `LAG() & LEAD()` 문법 예시
- `LAG(col)` : 바로 이전 행의 값
- `LEAD(col)` : 바로 다음 행의 값
- `PARTITION BY` : 이 그룹 안에서만 윈도우 함수를 적용
```sql
SELECT
  user_id,
  event_name,
  event_time,
  LAG(event_name) OVER (PARTITION BY user_id ORDER BY event_time) AS previous_event,
  LEAD(event_name) OVER (PARTITION BY user_id ORDER BY event_time) AS next_event
FROM user_event_log;
```

### 3️⃣ 알게된 점

- Product Analysis 툴 (Amplitude, Firebase) 만을 사용해보고, SQL로는 이벤트 로그를 분석해본 적이 없어서 SQL로 퍼널 분석을 할 수 있음에 조금 놀랐다. SQL로 분석하는 것은 테이블에 있는 기본 정보들만으로 추출해내는 줄 알았는데, event_name과도 연관이 있어서 Funnel 분석을 위한 SQL 연습도 필요함을 느꼈다.
- `WITH` 문법을 처음 배웠다. 복잡한 쿼리를 간결하게 만들기 위해 임시 테이블처럼 사용하는 문법이어서 실무에서도 유용하게 사용할 것 같다.
- 윈도우 함수인 `LAG()`, `LEAD()`를 처음 배웠다. 사용자 행동 흐름, 이탈 위치 분석할 때 유용하겠다고 생각했다.