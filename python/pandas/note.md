## Pandas 문법 정리

### 1️⃣ 기본 문법
```pyhon
def createDataframe(student_data: List[List[int]]) -> pd.DataFrame:
```
- `List[List[int]]`: 입력 데이터의 타입 힌트로, 정수형 값들의 리스트로 이루어진 리스트
- `-> pd.DataFrame`: pandas.DataFrame 객체 반환 (pandas에서 데이터프레임을 생성하는 클래스)

### 2️⃣ DataFrame
- `pd.DataFrame(data, columns=column_names)`: 데이터프레임 생성 함수
  - `data`: 리스트, 딕셔너리, 배열 등 다양한 형태로 입력 가능
  - `columns`: 열 이름 리스트를 지정하여 각 열에 이름을 부여
- `df.head()`: 데이터프레임 상위 5개 행 출력 (괄호안에 숫자를 넣어서 N개 행 출력 가능)
- `df.info()`: 데이터프레임 요약 정보 출력
- `return df`: 함수가 생성한 데이터프레임 객체를 반환
- `df.shape`: 데이터프레임의 행(row), 열(column) 수 튜플로 반환
- `df.dtypes`: 각 열의 데이터 타입 확인

### 3️⃣ loc
| 문법                           | 설명            |
| ---------------------------- | ------------- |
| `df.loc[row]`                | 행 라벨로 선택      |
| `df.loc[row, col]`           | 행, 열 라벨로 선택   |
| `df.loc[row_list, col_list]` | 여러 행과 열 선택    |
| `df.loc[조건식]`                | 조건 필터링        |
| `df.loc[:, 'col']`           | 모든 행의 특정 열 선택 |

### 4️⃣ 제거
`df.dropna()`: null 값 포함되면 해당 행 제거
- `subset = ['컬럼명'])` : 서브셋에 있는 열이 null값이면 해당 행 제거 


`drop_duplicates()` : 중복된 행을 제거하는 메서드
- `subset` : **중복을 확인할 특정 컬럼을 지정**
  - None : 모든 컬럼을 기준으로 중복 확인
  - 단일 컬럼 : subset=['column_name']
  - 여러 컬럼 : subset=['col1', 'col2', 'col3']
- `keep`
  - 'first' : 첫 번째 중복 행을 유지, 나머지 제거
  - 'last' : 마지막 중복 행을 유지, 나머지 제거
  - False : 모든 중복 행을 제거 (중복된 모든 행이 삭제됨)
- `inplace`
  - False : 새로운 DataFrame 반환 (원본 유지)
  - True : 원본 DataFrame을 직접 수정
- `ignore_index` 
  - False: 기존 인덱스 유지
  - True: 새로운 연속적인 인덱스로 재설정

### 5️⃣ 