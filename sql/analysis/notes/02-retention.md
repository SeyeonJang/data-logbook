## Retention

### 1️⃣ Retention 분석이란?

**특정 기간 이후에도 사용자가 서비스를 계속 사용하는지를 측정하는 분석**이다.
- **N일차 리텐션** (Day N Retention): 첫 방문일로부터 N일 뒤에 재방문한 사용자 비율
- **주차 리텐션** (Weekly Retention): 첫 주 이후 몇 주 차에 돌아왔는지 측정
- **코호트 분석** (Cohort Analysis): 유입 시점을 기준으로 동일 그룹(cohort)의 리텐션 분석

### 2️⃣ 필요한 SQL 개념

| 개념                               | 설명             | 예시                                         |
| -------------------------------- | -------------- | ------------------------------------------ |
| `DATE_TRUNC`                     | 날짜를 원하는 단위로 자름 | `DATE_TRUNC('day', event_time)`            |
| `DATEDIFF` 또는 `TIMESTAMPDIFF`    | 날짜 차이 계산       | `DATEDIFF(day, signup_date, revisit_date)` |
| `GROUP BY` + `HAVING`            | 코호트별 리텐션 그룹화   | `GROUP BY signup_date`                     |
| `COUNT(DISTINCT user_id)`        | 유저 수 계산        | 재방문 유저 수 계산                                |
| **윈도우 함수** (`ROW_NUMBER`, `MIN`) | 첫 방문일 계산       | `MIN(event_time)` OVER ...                 |


🖥️ `ROW_NUMBER` 문법 예시

ROW_NUMBER는 각 PARTITION 내에서 ORDER BY절에 의해 정렬된 순서를 기준으로 고유한 값을 반환하는 함수이다.<br>
ROW_NUMBER 함수는 분석 함수이기 때문에 OVER 절과 함께 사용해야한다. OVER 절 내부에 ORDER BY 절을 작성하지 않으면 아래와 같은 오류가 발생한다.

```sql
SELECT 
    ename, 
    job,
    sal,
    ROW_NUMBER() OVER(ORDER BY sal DESC) AS rownum
FROM emp
WHERE job IN ('MANAGER', 'SALESMAN');
```


### 3️⃣ 리텐션 분석 기본 흐름

1. _가입일_ 계산 : 각 사용자별 첫 이벤트 발생일
2. _리텐션 기간_ 계산 : 가입일 기준 N일 후 이벤트 발생 여부
3. _코호트별 유저 수_ 집계 : 각 코호트에 속한 유저 수 대비 재방문 유저 수
4. _리텐션율_ 계산 : 재방문 유저 수 / 전체 유저 수