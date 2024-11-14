create database sale;
use sale;

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10, 2)
);

CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE
);

CREATE TABLE Employee_Department (
    employee_id INT,
    department_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    PRIMARY KEY (employee_id, department_id)
);
-- a
SELECT e.employee_id, e.name
FROM Employee e
JOIN Employee_Department ed ON e.employee_id = ed.employee_id
JOIN Department d ON ed.department_id = d.department_id
WHERE d.department_name = 'Kế toán';
-- b
SELECT e.employee_id, e.name, e.salary
FROM Employee e
WHERE e.salary > 50000;
-- c
SELECT d.department_name, COUNT(ed.employee_id) AS employee_count
FROM Department d
LEFT JOIN Employee_Department ed ON d.department_id = ed.department_id
GROUP BY d.department_name;
-- d
SELECT e.employee_id, e.name, e.salary, d.department_name
FROM Employee e
JOIN Employee_Department ed ON e.employee_id = ed.employee_id
JOIN Department d ON ed.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM Employee e2
    JOIN Employee_Department ed2 ON e2.employee_id = ed2.employee_id
    WHERE ed2.department_id = d.department_id
);
-- e
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM Department d
JOIN Employee_Department ed ON d.department_id = ed.department_id
JOIN Employee e ON ed.employee_id = e.employee_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;
-- f
SELECT e.employee_id, e.name, COUNT(ed.department_id) AS department_count
FROM Employee e
JOIN Employee_Department ed ON e.employee_id = ed.employee_id
GROUP BY e.employee_id
HAVING COUNT(ed.department_id) > 2;

