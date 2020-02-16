-- sqlchallenge
-- EmployeeSQL
-- Code by Henry Greyner

-- Create Tables (imported from QuickDBD)
CREATE TABLE "departments" (
    "dept_no" VARCHAR(255)   NOT NULL,
    "dept_name" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(255)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(255)   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(255)   NOT NULL,
    "last_name" VARCHAR(255)   NOT NULL,
    "gender" VARCHAR(255)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "title" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR(255)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "title" ADD CONSTRAINT "fk_title_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Import Data into tables using Postgres table import function
-- Verify that tables are correct
SELECT * FROM departments LIMIT(5);
SELECT * FROM dept_emp LIMIT(5);
SELECT * FROM dept_manager LIMIT(5);
SELECT * FROM employees LIMIT(5);
SELECT * FROM salaries LIMIT(5);
SELECT * FROM title LIMIT(5);

----------------------------------------------------------------------------------------
-- 1. List the following details of each employee: employee number, last name, 
-- first name, gender, and salary.
----------------------------------------------------------------------------------------
-- Inner join on employees and salaies table.
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM salaries s
INNER JOIN employees e ON
e.emp_no=s.emp_no;

---------------------------------------------------------------------------------------
-- 2. List employees who were hired in 1986
---------------------------------------------------------------------------------------
-- Select employees from hire_date column where the year is equal 1986. 
SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
WHERE date_part('year', hire_date) = 1986;

---------------------------------------------------------------------------------------
-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, 
-- first name, and start and end employment dates.
---------------------------------------------------------------------------------------
-- -- Inner join on dept_manager, departments and employees table. 
SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name, m.from_date, m.to_date
FROM departments d INNER JOIN dept_manager m ON 
d.dept_no=m.dept_no
INNER JOIN employees e ON
e.emp_no=m.emp_no;

---------------------------------------------------------------------------------------
-- 4. List the department of each employee with the following information:
-- employee number, last name, first name, and department name.
---------------------------------------------------------------------------------------
-- Inner join on emplopyees, dept_emp, and departments table.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
d.dept_no=de.dept_no;

---------------------------------------------------------------------------------------
-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
---------------------------------------------------------------------------------------
-- Select employees by filtering using WHERE, the operator AND and the %wildcard.
SELECT emp_no, first_name, last_name
FROM employees
WHERE first_name = 'Hercules' 
AND last_name LIKE 'B%';

---------------------------------------------------------------------------------------
-- 6. List all employees in the Sales department, including their employee number, 
-- last name, first name, and department name.
---------------------------------------------------------------------------------------
-- Inner join on emplopyees, dept_emp, and departments table.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
d.dept_no=de.dept_no
-- Select employees by filtering using WHERE
WHERE d.dept_name = 'Sales';

---------------------------------------------------------------------------------------
-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
---------------------------------------------------------------------------------------
-- Inner join on emplopyees, dept_emp, and departments table.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e INNER JOIN dept_emp de ON
e.emp_no=de.emp_no
INNER JOIN departments d ON
d.dept_no=de.dept_no
-- Select employees by filtering using WHERE and the operator OR
WHERE d.dept_name = 'Sales'
OR d.dept_name = 'Development';

---------------------------------------------------------------------------------------
-- 8. In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
---------------------------------------------------------------------------------------
-- Select from employees their last name and count of last names grouped by their 
-- last name and sorted in descending order.
SELECT last_name, COUNT(last_name) AS "Frequency"
FROM employees
GROUP BY last_name
ORDER BY "Frequency" DESC;

---------------------------------------------------------------------------------------
-- BONUS QUESTION (for rest of investigation please see jupyter notebook)
---------------------------------------------------------------------------------------
SELECT * FROM employees
WHERE emp_no = 499942;

