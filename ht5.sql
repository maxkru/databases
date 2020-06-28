use employees;


BEGIN;
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
	VALUES (10000001, '2000-01-01', 'John', 'Smith', 'M', '2020-06-28');
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
	VALUES (10000001, 
			(SELECT dept_no FROM departments WHERE dept_name='Marketing'),
            '2020-06-28',
            '9999-01-01');
INSERT INTO salaries (emp_no, salary, from_date, to_date)
	VALUES (10000001, 135222, '2020-06-28', '9999-01-01');
INSERT INTO titles (emp_no, title, from_date, to_date)
	VALUES (10000001, 'Assistant', '2020-06-28', '9999-01-01');
COMMIT;

BEGIN;
SET @emp_no = 10004;
SET @dismissal_date = '2020-06-28';
UPDATE titles
	SET to_date=@dismissal_date WHERE emp_no=@emp_no AND to_date='9999-01-01';
UPDATE salaries
	SET to_date=@dismissal_date WHERE emp_no=@emp_no AND to_date='9999-01-01';
UPDATE dept_emp
	SET to_date=@dismissal_date WHERE emp_no=@emp_no AND to_date='9999-01-01';
COMMIT;

