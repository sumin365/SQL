----------
-- JOIN
----------

DESC employees;
DESC departments;


-- 두 테이블로부터 모든 데이터를 불러올 경우
-- CROSS JOIN : 카티전 프로덕트
-- 두 테이블의 조합 가능한 모든 레코드의 쌍
SELECT employees.employee_id, employees.department_id,
    departments.department_id, departments.department_name
FROM employees, departments
ORDER BY employees.employee_id;

-- 일반적으로는 이런 결과를 원하지 않을 것
-- 첫 번째 테이블의 department_id 정보와 두 번째 테이블의 department_id를 일치
SELECT employees.employee_id, employees.first_name, employees.department_id,
    departments.department_id, departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id; -- 두 테이블의 연결 정보 조건을 부여
-- INNER JOIN, Equi JOIN

-- 컬럼명의 모호성을 피하기 위해 테이블명.컬럼명
--  테이블에 별명(alias)를 붙여주면 편리
SELECT employee_id, first_name, --  컬럼 명이 소속이 명확하면 테이블 명은 명시하지 않아도 된다
    emp.department_id,
    dept.department_id, 
    department_name
FROM employees emp, departments dept    -- 별칭을 부여한 테이블의 목록
WHERE emp.department_id = dept.department_id;

----------
-- INNER JOIN: Simple Join
----------
SELECT * FROM employees; -- 107

SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept -- 테이블 별칭
WHERE emp.department_id = dept.department_id;  -- 106

-- JOIN되지 않은 사원은 누구인가?
-- 부서에 배속되지 않은 사원
SELECT first_name, department_id
FROM employees
WHERE department_id is null;

SELECT first_name,
    department_id,
    department_name
FROM employees JOIN departments
                USING (department_id);  -- JOIN할 컬럼을 명시
                
-- JOIN ON
SELECT first_name,
    emp.department_id,
    department_name
FROM employees emp JOIN departments dept
                ON (emp.department_id = dept.department_id); -- ON -> JOIN문의 WHERE 절

-- Natural Join
-- 두 테이블에 조인을 할 수 있는 공통 필드가 있을 경우(공통 필드가 명확할 때)
SELECT first_name, department_id, department_name
FROM employees NATURAL JOIN departments;

----------
-- Theta JOIN
----------
-- 임의의 조건을 사용하되 JOIN 조건이 = 조건이 아닌 경우의 조인
SELECT * FROM jobs WHERE job_id='AD_ASST';  -- min: 3000, max: 6000
SELECT first_name, salary FROM employees emp, jobs j
WHERE j.job_id='AD_ASST' AND
    salary BETWEEN j.min_salary AND j.max_salary;

----------
-- OUTER JOIN
----------
/*
조건 만족하는 짝이 없는 튜플도 NULL을 포함해서 출력에 참여시키는 JOIN
모든 레코드를 출력할 테이블의 위치에 따라서 LEFT, RIGHT, FULL OUTER JOIN으로 구분
ORACLE의 경우, null이 출력되는 조건쪽에 (+)
*/
-- INNER JOIN 참고 - 106
-- LEFT OUTER JOIN: ORACLE ver
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+); -- LEFT OUTER JOIN

-- LEFT OUTER JOIN: ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp LEFT OUTER JOIN departments dept --  emp 테이블의 모든 레코드는 출력에 참여
                    ON emp.department_id = dept.department_id;
                    
-- RIGHT OUTER JOIN: Oracle
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id; -- departments 테이블의 모든 결과를 출력

-- RIGHT OUTER JOIN: ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp RIGHT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- FULL OUTER JOIN: 양쪽 테이블 모두 출력에 참여
/*
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id (+);  -- FULL OUTER JOIN은 불가
*/

SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- SELF JOIN: 자신의 FK가 자신의 PK를 참조하는 방식의 JOIN
--  자신을 두 번 호출하므로 alias 사용할 수밖에 없는 JOIN
SELECT emp.employee_id, emp.first_name, --  사원정보
    emp.manager_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id;

-- ANSI SQL
SELECT emp.employee_id, emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp JOIN employees man
                    ON emp.manager_id = man.employee_id;
                    
----------
-- Aggregation (집계)
----------
-- 여러 개의 값을 집계하여 하나의 결과값을 산출

-- count: 갯수 세기 함수
-- employees 테이블은 몇 개의 레코드를 가지고 있는가?
SELECT COUNT(*) FROM employees; -- *는 전체 레코드 카운트를 집계 (내부 값이 null이 있어도 집계)
SELECT COUNT(commission_pct) FROM employees; -- 특정 컬럼을 명시하면 null인 것은 집계에서 제외
SELECT COUNT(*) FROM employees WHERE commission_pct is not null; -- 위의 것과 같은 의미

-- 합계 함수: SUM
-- 급여의 총 합?
SELECT SUM(salary) FROM employees;

-- 평균 함수: AVG
-- 평균 급여 산정
SELECT AVG(salary) FROM employees;

-- 사원들이 받는 평균 커미션 비율
SELECT AVG(commission_pct) FROM employees; -- null 데이터는 집계에서 배제
SELECT AVG(nvl(commission_pct, 0)) FROM employees;

-- null이 포함된 집계는 null 값을 포함할 것인지 아닌지를 결정하고 집계

-- salary의 최솟값, 최댓값, 평균값, 중앙값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

-- 흔히 범하는 오류
-- 부서의 아이디, 급여 평균을 출력하고자
SELECT department_id, AVG(salary) FROM employees; -- Error

-- 만약에 부서별 평균 연봉을 구하려면?
-- 부서별 Group을 지어준 데이터를 대상으로 집계 함수 수행
SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 SELECT 컬럼 목록에는
-- 집계에 참여한 필드, 집계함수만 올 수 있다

-- 부서별 평균 급여를 내림차순으로 출력
SELECT department_id, ROUND(AVG(salary), 2) sal_avg  -- 별칭 사용
FROM employees
GROUP BY department_id
ORDER BY sal_avg DESC;

-- 부서별 평균 급여를 산출 평균 급여가 2000이상인 부서를 출력
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 20000  --  이 시점에서는 AVG(salary)가 수행되지 않은 상태 -> 없다
GROUP BY department_id;
--  Error: 집계 작업이 일어나기 전에 WHERE 절이 실행되기 때문

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id   -- 그룹핑
    HAVING AVG(salary) >= 7000  --  HAVING :  Group by에 조건을 부여할 때 사용
ORDER BY department_id;

--3/18
-- ROLLUP
-- GROUP BY 절과 함께 사용
-- GROUP BY의 결과에 좀더 상세한 요약을 제공하는 기능 수행 (Item Subtotal)
-- 부서별 급여의 합계 추출(부서 아이디, job_id)
SELECT department_id,
    job_id,
    SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;

SELECT department_id,
    job_id,
    SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);


-- CUBE 함수
-- CrossTable에 대한 Summary를 함께 제공
-- Rollup 함수로 추출된 Subtotal에 
-- Column Total 값을 추출할 수 있다
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;





----------
-- Subquery
----------
/* 
하나의 SQL이 다른 SQL 질의의 일부에 포함되는 경우
*/
-- 단일행 서브쿼리
--  서브쿼리의 결과과 단일행인 경우, 단일행 비교 연산자를 사용(=, >, >=, <, <=, <>)

-- 'Den' 보다 급여를 많이 받는 사원의 이름과 급여는?
-- 1. Den이 얼마나 급여를 받는지 - A
-- 2. A보다 많은 급여를 받는 사람은?
SELECT salary FROM employees WHERE first_name='Den';    --  11000 : 1
SELECT first_name, salary FROM employees WHERE salary > 11000;  -- : 2
-- 합친다
SELECT first_name, salary FROM employees
WHERE salary > (SELECT salary FROM employees WHERE first_name='Den');

-- 연습: 
-- 급여의 중앙값보다 많이 받는 직원
-- 1. 급여의 중앙값?
-- 2. 급여를 중앙값보다 많이 받는 직원
SELECT MEDIAN(salary) FROM employees;   --  6200 : 1
SELECT first_name, salary FROM employees WHERE salary > 6200;
-- 쿼리 합치기
SELECT first_name, salary FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- 급여를 가장 적게 받는 사람의 이름, 급여, 사원 번호를 출력하시오
SELECT MIN(salary) FROM employees;  --  2100
SELECT first_name, salary, employee_id
FROM employees
WHERE salary = 2100;
-- 쿼리 합치기
SELECT first_name, salary, employee_id
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 다중행 서브쿼리
-- 서브쿼리 결과 레코드가 둘 이상인 경우, 단순 비교 불가능
-- 집합 연산에 관련된 IN, ANY, ALL, EXSIST 등을 이용해야 한다

-- 110번 부서의 직원이 받는 급여는?
SELECT salary FROM employees WHERE department_id = 110; -- 레코드 갯수 2
SELECT first_name, salary FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department_id = 110);
-- Error: 서브쿼리의 결과 레코드는 2개 
--  2개의 결과와 단일행 salary의 값을 비교할 수 없다

-- Fix
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE department_id = 110); -- IN
SELECT first_name, salary FROM employees
WHERE salary = ANY (SELECT salary FROM employees WHERE department_id = 110); -- ANY

-- IN, =ANY -> OR와 비슷

SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 110); -- ALL
-- ALL: AND와 비슷

SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 110);
-- salary > 12008 OR salary > 8300 -> 동일

-- Correlated Query
-- 포함한 쿼리(Outer Query), 포함된 쿼리(Inner Query)가 서로 연관관계를 맺는 쿼리
SELECT first_name, salary, department_id
FROM employees outer -- Outer
WHERE salary > (SELECT AVG(salary) FROM employees
                WHERE department_id = outer.department_id);
-- 의미
-- 사원 목록을 추출하되
--  자신이 속한 부서의 평균 급여보다 많이 받는 직원을 추출하자는 의미
--   서브쿼리(INNER)가 수행되기 위해 OUTER의 컬럼값이 필요하고
--      OUTER 쿼리 수행이 완료되기 위해서는 서브쿼리(INNERT)의 결과 값이 필요한 쿼리

-- 서브쿼리 연습
-- 각 부서별로 최고 급여를 받는 사원을 출력
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id;

-- 1. 조건절에서 비교
SELECT department_id, employee_id, first_name, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MAX(salary) 
                                    FROM employees
                                    GROUP BY department_id)
ORDER BY department_id;

--48/54
-- SUBQUERY: 임시테이블을 생성      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!연습하기 1.2.3.!!주의
-- 2. 부서별 최고 급여 테이블을 임시로 생성해서 테이블과 조인하는 방법
SELECT emp.department_id, employee_id, first_name, emp.salary
FROM employees emp, (SELECT department_id, MAX(salary) salary
                        FROM employees
                        GROUP BY department_id) sal -- 임시테이블을 만들어서 sal 별칭의 부여
WHERE emp.department_id = sal.department_id AND
    emp.salary = sal.salary
ORDER BY emp.department_id;

-- 3. Correlated Query 활용
SELECT emp.department_id, employee_id, first_name, emp.salary
FROM employees emp
WHERE emp.salary = (SELECT MAX(salary) FROM employees
                    WHERE department_id = emp.department_id)
ORDER BY department_id;                    

----------
-- TOP K Query
----------
-- Oracle은 질의 수행 결과의 행번호를 확인할 수 있는 가상 컬럼 rownum을 제공

-- 2007년 입사자 중에서 급여 순위 5위까지 뽑아봅시다
SELECT rownum, first_name, salary
FROM employees; -- 여기까진OK

SELECT rownum, first_name, salary
FROM employees
WHERE hire_date LIKE '07%' AND rownum <= 5; --이것도 엉터리다 이건 아니다.


SELECT rownum, first_name, salary 
FROM employees
WHERE hire_date LIKE '07%' AND rownum <= 5
ORDER BY salary DESC; --  rownum이 정해진 이후 정렬을 수행 엉터리다 이건 아니다

-- TOP K 쿼리                                          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT rownum, first_name, salary 
FROM (SELECT * FROM employees
        WHERE hire_date LIKE '07%'
        ORDER BY salary DESC)
WHERE rownum <= 5;

-- SET (집합)
-- UNION(합집합: 중복제거), UNION ALL(합집합: 중복제거 안함)
-- INTERSECT(교집합), MINUS(차집합)
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01';   -- 24
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 8

-- 교집합
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
INTERSECT
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

-- 위의 것과 같은 의미
SELECT first_name, salary, hire_date FROM employees
WHERE hire_date < '05/01/01' AND
    salary > 12000;

-- 합집합: UNION
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;  -- 26

-- 위의 것은 아래와 같은 의미
SELECT first_name, salary, hire_date 
FROM employees 
WHERE hire_date < '05/01/01' OR salary > 12000;

-- 차집합: MINUS
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
MINUS
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;

-- 입사일이 05/01/01 이전인 사람들 중, 급여가 12000이하인 직원들
SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date < '05/01/01' AND
    NOT (salary > 12000);
    
-- RANK 함수
SELECT salary, first_name,
    RANK() OVER (ORDER BY salary DESC) as rank, --  중복된 순위를 건너뛰고 순위 부여
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank, -- 중복순위 상관 없이 다음 순위 부여
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_number, -- 중복 여부 관계없이 차례대로 순위 부여
    rownum  --  정렬되기 이전의 레코드 순서
FROM employees;

-- Hierarchical Query : 트리 형태의 구조를 추출
--  ROOT 노드: 조건 START WITH로 설정
--  가지: 연결하기 위한 조건을 CONNECT BY PROIR 로 설정
-- employees 테이블로 조직도 그려봅시다.
--  level(깊이)이라는 가상 컬럼을 사용할수 있다
SELECT level, first_name, manager_id, employee_id
FROM employees
START WITH manager_id IS NULL   -- ROOT 노드의 조건
CONNECT BY PRIOR employee_id = manager_id
ORDER BY level;

-- 연습문제: 위 트리 구조에 매니저의 이름도 출력해 주세요


select * from JOB_HISTORY  where job_id='AC_ACOUNT';

SELECT MEDIAN (salary) FROM employees;

SELECT first_name, salary FROM  employees
where salary> ANY (SELECT salary FROM employees WHERE 


