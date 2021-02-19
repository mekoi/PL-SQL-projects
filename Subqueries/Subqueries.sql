--==========================================================================================================================
---1. List the numbers of all employees who do not work for the training department.

select empno Employee_Number from employees 
where deptno IN (select deptno from departments where dname <> 'TRAINING');

--==========================================================================================================================
--2. Which employees don’t have subordinates?

select empno Employee_Number, ename Employee_Name from employees 
where empno not  in (select DISTINCT mgr from employees where mgr is not NULL)

--==========================================================================================================================
--3. Produce an overview of all general course offerings (course category GEN) in 1999.

select distinct c.description General_Courses_Offered_1999
from courses c inner join 
(select * from OFFERINGS where begindate BETWEEN TO_DATE('19990101', 'yyyymmdd') and  TO_DATE('19991231', 'yyyymmdd')) o 
on c.code=o.course
where c.category='GEN';

--==========================================================================================================================
--4. Provide the name and initials of all employees who have ever attended a course taught by N. Smith.

select distinct e.ename Employee_Name,e.init Employee_Initials from employees e join registrations r on e.empno=r.attendee
where r.course in (select distinct course from OFFERINGS where trainer = (select empno from employees where ename='SMITH'))

--==========================================================================================================================