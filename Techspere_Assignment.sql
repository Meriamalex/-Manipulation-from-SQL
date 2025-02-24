-- 1.Identify employees with the highest total hours worked and least absenteeism.
SELECT 
e.employeeid,
e.employeename,
SUM(a.total_hours) AS total_hours_worked,
SUM(a.days_absent) AS total_days_absent,
(SUM(a.total_hours) * SUM(a.days_present)) AS productivity_score
FROM employee_details e
JOIN attendance_records a ON e.employeeid = a.employeeid
GROUP BY e.employeeid, e.employeename
ORDER BY productivity_score DESC;

-- 2. Analyze how training programs improve departmental performance.
select e.department_id,
avg(CASE 
WHEN e.performance_score = 'Excellent' THEN 5
WHEN e.performance_score = 'Good' THEN 4
WHEN e.performance_score = 'Average' THEN 3
ELSE 0 
END
) as avg_performance_score_before_training,
avg(t.feedback_score) as avg_performance_after_training
from employee_details e join  training_programs t
on e.employeeid = t.employeeid 
group by e.department_id;

-- 3.Evaluate the efficiency of project budgets by calculating costs per hour worked.
SELECT p.project_name,
sum(p.budget) AS total_budget,
sum(hours_worked) AS total_hours,
(sum(p.budget)/sum(hours_worked)) AS cost_per_hour_worked
FROM project_assignments_1 p
group by project_name;

-- 4. Measure attendance trends and identify departments with significant deviations.
select e.department_id,
avg(a.days_present) as average_days_present,
avg(a.days_absent) AS avg_days_absent,
stddev(a.days_present) as deviation_days_present
from employee_details e join  attendance_records a
on e.employeeid = a.employeeid 
group by
e.department_id;

-- 5. Link training technologies with project milestones to assess the real-world impact of training.
SELECT e.employeeid, e.employeename,
t.program_name AS training_program,
t.technologies_covered,
p.project_name,
p.technologies_used,
p.milestones_achieved
FROM training_programs t
JOIN project_assignments_1 p ON t.employeeid = p.employeeid
JOIN employee_details e ON e.employeeid = t.employeeid
ORDER BY p.milestones_achieved DESC;

-- 6. Identify employees who significantly contribute to high-budget projects while maintaining excellent performance scores.
select e.employeeid,
e.employeename,
p.project_name,
p.budget,
e.performance_score
from employee_details e join project_assignments_1 p 
on e.employeeid=p.employeeid
where p.budget > 400000 and e.performance_score="Excellent" 
order by p.budget desc,e.performance_score;

-- 7. Identify employees who have undergone training in specific technologies and contributed to high-performing projects using those technologies.
SELECT 
e.employeeid,
e.employeename,
e.performance_score,
t.program_name,
t.technologies_covered,
p.project_name
FROM employee_details e
JOIN training_programs t ON e.employeeid = t.employeeid
JOIN project_assignments_1 p ON e.employeeid = p.employeeid AND (p.technologies_used LIKE '%' || t.technologies_covered || '%')
WHERE e.performance_score IN ('Excellent','Good')
ORDER BY e.performance_score,e.employeeid DESC;
