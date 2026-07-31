-- Exercise 2: SQL
-- ======================
-- This exercise has three levels. Complete as far as you can.
--
-- To test your queries, run:
--   python exercises/run_sql.py
--
-- This will execute each query against an in-memory SQLite database
-- loaded with the sample data from data/schema.sql.


-- ============================================================
-- BASE LEVEL — Simple queries
-- ============================================================

-- Query 1: List all employees sorted by name alphabetically.
-- Expected columns: name, salary, hire_date

select name, salary, hire_date 
from employees
order by name asc;

-- Query 2: List all employees with their department name.
-- (Hint: you need to JOIN two tables)
-- Expected columns: employee_name, department_name

select e.name as employee_name, d.name as department_name
from employees e
join departments d on e.department_id = d.id;


-- Query 3: Count how many employees are in each department.
-- Expected columns: department_name, employee_count

select d.name as department_name,
count(e.id) as employee_count
from departments d
left join employees e
on d.id = e.department_id
group by d.name;

-- ============================================================
-- STANDARD LEVEL — JOINs, aggregations, filtering
-- ============================================================

-- Query 4: Find the top 3 departments by average salary.
-- Expected columns: department_name, avg_salary

select d.name as department_name,
avg(e.salary) as avg_salary
from departments d
join employees e on d.id = e.department_id
group by d.name
order by avg_salary desc
limit 3;


-- Query 5: Find departments where the total employee salary exceeds the department budget.
-- Expected columns: department_name, total_salary, budget
select d.name as department_name,
sum(e.salary) as total_salary,
d.budget from departments d
join employees e on e.department_id = d.id
group by d.name, d.budget
having total_salary > d.budget;


-- Query 6: Count the number of active projects per department,
--          including departments with zero active projects.
-- Expected columns: department_name, active_project_count

select d.name as department_name, count(p.status) as active_project_count
from departments d
left join projects p on d.id = p.department_id and p.status = 'active'
group by d.name;

-- ============================================================
-- ADVANCED LEVEL — Subqueries, complex logic
-- ============================================================

-- Query 7: Find employees who were hired in the last 12 months and work in departments
--          with at least one completed project.
-- Expected columns: employee_name, department_name, hire_date

select e.name as employee_name, d.name as department_name, e.hire_date
from employees e
join departments d on e.department_id = d.id
where e.hire_date >= date('now', '-12 months')
and d.id in (
    select distinct p.department_id
    from projects p
    where p.status = 'completed'
);

-- Query 8: Rank departments by their "project success rate"
--          (completed projects / total projects). Exclude departments with no projects.
-- Expected columns: department_name, total_projects, completed_projects, success_rate


-- Query 9: For each department, find the employee with the highest salary.
--          If multiple employees tie, show all of them.
-- Expected columns: department_name, employee_name, salary


