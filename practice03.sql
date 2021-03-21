/*
문제1.
직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name) 을 조회하여 
부서이름(department_name) 오름차순, 사번(employee_id) 내림차순으로 정렬하세요(106건)
*/
SELECT emp.employee_id, emp.first_name, emp.last_name, 
    dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id
ORDER BY dept.department_name,  -- 오름차순
    emp.employee_id DESC;
--  NATURAL JOIN으로는 불가하다 -> 주의 
--  employees, departments 테이블은 department_id와 manager_id 공통 필드를 가지고 있다
SELECT employee_id, first_name, last_name, department_name
FROM employees NATURAL JOIN departments;    --  Natural JOIN
--NATURAL JOIN으로 쓴건  아래 쿼리와 동일
SELECT employee_id, first_name, last_name, dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id AND
    emp.manager_id = dept.manager_id;

/*
문제2.
employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다
직원들의 사번(employee_id), 이름(first_name), 급여(salary), 부서명(department_name), 현재업무 (job_title)를 
사번 (employee_id) 오름차순 으로 정렬하세요
부서가 없는 Kimberely( 사번 178) 은 표시하지 않습니다(106건)
*/
SELECT emp.employee_id 사번,
    emp.first_name 이름,
    emp.salary 급여,
    dept.department_name 부서명,
    jobs.job_title 업무명
FROM employees emp, departments dept, jobs
WHERE emp.department_id = dept.department_id AND
    emp.job_id = jobs.job_id;
    

/*
문제2-1.
문제2에서 부서가 없는 Kimberely(사번 178) 까지 표시해 보세요(107건) /--그림을 보니 2개의 조인 조건이 필요하다. 
*/
SELECT emp.employee_id 사번,
    emp.first_name 이름,
    emp.salary 급여,
    dept.department_name 부서명,
    jobs.job_title 업무명
FROM employees emp, departments dept, jobs
WHERE emp.department_id = dept.department_id(+) AND --  왼쪽 테이블은 모두 출력에 참여
    emp.job_id = jobs.job_id;
    
-- ANSI SQL
SELECT emp.employee_id 사번,
    emp.first_name 이름,
    emp.salary 급여,
    dept.department_name 부서명,
    jobs.job_title 업무명
FROM employees emp LEFT OUTER JOIN departments dept
                                ON emp.department_id = dept.department_id,
    jobs
WHERE emp.job_id=jobs.job_id;

/*
문제3.
도시별로 위치한 부서들을 파악하려고 합니다
도시아이디, 도시명, 부서명, 부서아이디를 도시아이디 오름차순으로 정렬하여 출력하세요
부서가 없는 도시는 표시하지 않습니다(27건)
*/
SELECT loc.location_id, city,
    department_name,
    dept.department_id
FROM locations loc, departments dept
WHERE loc.location_id = dept.location_id
ORDER BY loc.location_id;   --  ASC 생략

/*
문제3-1
문제3에서 부서가 없는 도시도 표시합니다(43건)
*/
SELECT loc.location_id, city,
    department_name,
    dept.department_id
FROM locations loc, departments dept
WHERE loc.location_id = dept.location_id(+)    -- loc의 모든 레코드를 출력에 참여 LEFT OUTER JOIN
ORDER BY loc.location_id;

-- ANSI
SELECT loc.location_id, city,
    department_name,
    dept.department_id
FROM locations loc LEFT OUTER JOIN departments dept
                                ON loc.location_id = dept.location_id
ORDER BY loc.location_id;

/*
문제4
지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름 (country_name)으로 출력하되                   join  on  /join  using
지역이름(오름차순), 나라이름(내림차순)으로 정렬하세요(25건)
*/
SELECT reg.region_name 지역이름,
    c.country_name 나라이름
FROM regions reg JOIN countries c ON (reg.region_id = c.region_id)
ORDER BY reg.region_name, c.country_name DESC;


/*
문제5
자신의 매니저보다 채용일(hire_date)이 빠른 사원의
사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입사일 (hire_date)을 조회하세요
(37건)
*/
SELECT emp.employee_id, emp.first_name, emp.hire_date,
    man.first_name, man.hire_date
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id AND  -- JOIN 조건
    emp.hire_date < man.hire_date;  --  날짜 비교
    
/*
문제6
나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다
나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 
나라명 오름차순 로 정렬하여 출력하세요
값이 없는 경우 표시하지 않습니다
(27건)
*/
SELECT c.country_name, 
    c.country_id,
    loc.city,
    loc.location_id,
    dept.department_name,
    dept.department_id
FROM countries c, locations loc, departments dept
WHERE c.country_id = loc.country_id AND
    loc.location_id = dept.location_id
ORDER BY c.country_name;

/*
문제7
job_history테이블은 과거의 담당업무의 데이터를 가지고 있다
과거의 업무아이디 (job_id)가 'AC_ACCOUNT'로 근무한 사원의 
사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력하세요
이름은 first_name 과 last_name 을 합쳐 출력합니다
(2건)*/

--SELECT * FROM job_history WHERE job_id='AC_ACCOUNT';
SELECT emp.employee_id 사번,
    emp.first_name || ' ' || emp.last_name 이름,
    emp.job_id 업무아이디,
    jh.start_date 시작일,
    jh.end_date 종료일
FROM employees emp, job_history jh
WHERE emp.employee_id = jh.employee_id AND
    jh.job_id = 'AC_ACCOUNT';
    
/*
문제8
각 부서 (department)에 대해서 부서번호(department_id), 부서이름(department_name),
매니저(manager)의 이름 (first_name), 위치(locations)한 도시(city), 
나라(countries)의 이름(countries_name) 그리고 지역구분 (regions)의 이름 (resion_name)까지 전부 출력해 보세요 -5개 연관 4개의 조인필요
(11건)
*/
SELECT dept.department_id, dept.department_name,
    man.first_name,
    loc.city,
    c.country_name,
    reg.region_name
FROM departments dept,
    employees man,
    locations loc,
    countries c,
    regions reg
WHERE dept.manager_id = man.employee_id AND
    dept.location_id = loc.location_id AND
    loc.country_id = c.country_id AND
    c.region_id = reg.region_id;

/*
문제9
각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명(department_name), ---  셀프 조인이랑 네추럴 조인 다시보기 
매니저(manager)의 이름(first_name)을 조회하세요
부서가 없는 직원 Kimberely) 도 표시합니다
(106명)
*/
SELECT emp.employee_id 사번,
    emp.first_name 이름,
    dept.department_name 부서명,
    man.first_name "매니저 이름"
FROM employees emp, employees man, departments dept
WHERE emp.department_id = dept.department_id(+) AND -- LEFT OUTER
    emp.manager_id = man.employee_id;