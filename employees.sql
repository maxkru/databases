use employees;

-- задание 1

SELECT
	d.dept_name, AVG(s.salary) as average_salary
FROM
	salaries AS s
    INNER JOIN dept_emp ON s.emp_no = dept_emp.emp_no
    INNER JOIN departments AS d ON dept_emp.dept_no=d.dept_no
WHERE
	s.to_date = '9999-01-01' -- если хотим получить среднюю зарплату для текущих сотрудников
group by d.dept_name;

select * from dept_emp;

-- задание 2

SELECT
	e.emp_no AS id, CONCAT(e.first_name, ' ', e.last_name) AS name, MAX(salary) AS max_salary
FROM
	salaries AS s
    INNER JOIN employees AS e ON e.emp_no = s.emp_no
GROUP BY id, name
ORDER BY max_salary DESC;

-- задание 3

select * from titles;

SELECT temp.emp_no FROM (
SELECT	
	emp_no, MAX(salary) AS max_salary
FROM salaries
GROUP BY emp_no
ORDER BY max_salary DESC
LIMIT 1) AS temp;

DELETE 
	e.* FROM employees AS e
WHERE
	e.emp_no IN (
		SELECT temp.emp_no FROM (
			SELECT	
				emp_no, MAX(salary) AS max_salary
			FROM salaries
			GROUP BY emp_no
			ORDER BY max_salary DESC
			LIMIT 1) AS temp
		);
        
-- задание 4

SELECT * FROM dept_emp;

-- выполняется примерно за 0.70 с (в среднем)
SELECT
	d.dept_name, t.number_of_employees
FROM
	departments AS d
    INNER JOIN (
		SELECT
			d_e.dept_no, COUNT(*) AS number_of_employees
		FROM
			dept_emp AS d_e
		WHERE
			d_e.to_date = '9999-01-01' -- только текущие сотрудники
		GROUP BY
			d_e.dept_no
	) AS t 
    ON t.dept_no = d.dept_no
ORDER BY
	t.number_of_employees DESC;


-- выполняется примерно за 0.75 с (в среднем)
SELECT
	d.dept_name, COUNT(*) AS number_of_employees
FROM
	dept_emp AS d_e
    INNER JOIN departments AS d ON d_e.dept_no = d.dept_no
WHERE
	d_e.to_date = '9999-01-01' -- только текущие сотрудники
GROUP BY
	d.dept_name
ORDER BY
	number_of_employees DESC;

-- задание 5

SELECT
	d.dept_name, COUNT(*) AS number_of_employees, SUM(salary) AS money_received_by_department
FROM
	dept_emp AS d_e
    INNER JOIN departments AS d ON d_e.dept_no = d.dept_no
    INNER JOIN salaries AS s ON s.emp_no = d_e.emp_no
WHERE
	s.to_date = '9999-01-01' -- только текущие сотрудники
GROUP BY
	d.dept_name
ORDER BY
	number_of_employees DESC;
