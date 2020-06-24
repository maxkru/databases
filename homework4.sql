-- представление "число сотрудников по отделам"

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `employees`.`department_employees_number` AS
    SELECT 
        `d`.`dept_name` AS `dept_name`,
        COUNT(0) AS `number_of_employees`
    FROM
        (`employees`.`dept_emp` `d_e`
        JOIN `employees`.`departments` `d` ON ((`d_e`.`dept_no` = `d`.`dept_no`)))
    WHERE
        (`d_e`.`to_date` = '9999-01-01')
    GROUP BY `d`.`dept_name`
    ORDER BY `number_of_employees` DESC;
    
-- найти (идентификатор) менеджера по имени и фамилии

CREATE DEFINER=`root`@`localhost` FUNCTION `find_manager`(first_name VARCHAR(255), last_name VARCHAR(255)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN

RETURN (SELECT 
    d_m.emp_no
FROM
    dept_manager AS d_m
        INNER JOIN
    employees AS e ON d_m.emp_no = e.emp_no
WHERE
    e.first_name = first_name
        AND e.last_name = last_name);
END

-- добавление триггера

CREATE DEFINER=`root`@`localhost` TRIGGER `employees_AFTER_INSERT` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
	INSERT INTO salaries (emp_no, from_date, to_date, salary) VALUES (NEW.emp_no, NEW.hire_date, NEW.hire_date, 500);
END