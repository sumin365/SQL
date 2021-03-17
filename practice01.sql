/*
����
1 .
��ü������
���� ������ ��ȸ�ϼ��� . 
������ �Ի��� (hire_date) �� �ø����� (ASC) ���� ���� ���Ӻ��� ����� �ǵ��� �ϼ��� 
- �̸� (first_name last_name) 
- ���� (salary) 
- ��ȭ��ȣ(phone_ number), 
- �Ի��� hire_date) �����̰� 
��Ī �̸� ����, ���� ����, ��ȭ��ȣ ��, �Ի��� �� �÷��̸��� ��ü�� ������
*/
SELECT first_name || ' ' || last_name �̸�,
    salary as ����,
    phone_number "��ȭ��ȣ",
    hire_date �Ի���
FROM employees
ORDER BY hire_date ASC; -- ASC�� ���� ����

/*
����
2.
����(jobs) ���� �����̸� job_title �� �ְ���� (max_salary)�� 
�ְ���� �� �������� (DESC) �� �����ϼ���
*/
SELECT job_title, max_salary
FROM jobs
ORDER BY max_salary DESC;

/*
���� 3.
��� �Ŵ����� �����Ǿ������� Ŀ�̼Ǻ����� ���� 
������ 3000 �ʰ��� ������ 
    �̸� , �Ŵ��� ���̵� Ŀ�̼� ���� ���� �� ����ϼ���
*/
DESC employees;
SELECT first_name,
    manager_id,
    commission_pct,
    salary
FROM employees
WHERE salary > 3000 AND
    manager_id is not null AND -- = null�� üũ�ϸ� �ȵ�
    commission_pct is null
ORDER BY salary DESC;

/*
���� 4.
�ְ����(max_salary) �� 10000 �̻��� 
������ �̸� job_title �� �ְ���� (max_salary) �� 
�ְ����(max_salary) �������� (DESC) �� �����Ͽ� ����ϼ��� .
*/
SELECT job_title, max_salary
FROM jobs
WHERE max_salary > 10000
ORDER BY max_salary DESC;

/*
���� 5
������ 14000 �̸� 10000 �̻��� 
������ �̸� (first_name) ����, Ŀ�̼��ۼ�Ʈ�� 
���޼� �������� ����ϼ��� 
�� Ŀ�̼��ۼ�Ʈ�� null �̸� 0 ���� ��Ÿ���ÿ�
*/
SELECT first_name, 
    salary,
    nvl(commission_pct, 0) -- commission_pct�� null�̸� 0�� ���Ѵ�
FROM employees
WHERE salary < 14000 AND
    salary >= 10000
ORDER BY salary DESC;

/*
���� 6
�μ���ȣ�� 10 90 100 �� ������ 
�̸�, ����, �Ի���, �μ���ȣ�� ��Ÿ���ÿ�
�Ի����� 1977-12 �� ���� ǥ���Ͻÿ�
*/
SELECT first_name,
    salary,
    TO_CHAR(hire_date, 'YYYY-MM') hire_date,
    department_id
FROM employees
WHERE department_id = 10 OR
    department_id = 90 OR
    department_id = 100;
    
SELECT first_name,
    salary,
    TO_CHAR(hire_date, 'YYYY-MM') hire_date,
    department_id
FROM employees
WHERE department_id IN (10, 90, 100);


--����7.
--�̸�(first_name)�� S �Ǵ� s �� ���� ������ �̸�, ������ ��Ÿ���ÿ�
SELECT upper(first_name),
      salary
FROM employees
WHERE first_name LIKE '%S%';

SELECT first_name,
      salary
FROM employees
WHERE upper(first_name)LIKE '%S%';                                                 

--����8.
--��ü �μ��� ����Ϸ��� �մϴ�. ������ �μ��̸��� �� ������� ����� ������SELECT department_name
FROM departments
ORDER BY length(department_name) DESC;

/*
���� 9
��Ȯ���� ������, ���簡 ���� ������ ����Ǵ� ������� 
�����̸��� �빮�ڷ� ����ϰ�
�ø�����(ASC) ���� ������ ������
*/
SELECT UPPER(country_name) country_name
FROM countries
ORDER by UPPER(country_name) ASC;

/*
���� 10
�Ի����� 03/12/31 �� ���� �Ի��� 
������ �̸�, ����, ��ȭ ��ȣ, �Ի��� �� ����ϼ���
��ȭ��ȣ�� 545-343-3433 �� ���� ���·� ��� �Ͻÿ�
*/
SELECT first_name, salary,
    replace(phone_number, '.', '-') phone_number, -- . -> -�� ġȯ
    hire_date
FROM employees
WHERE hire_date <= '03/12/31';