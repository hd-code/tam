-- 
-- Datenbank: TAM
-- erstellt am 25.06.2019
-- durch Übungsgruppe DB2
-- Sichten für Personalverwaltung
-- 

-- Anzeige aller Mitarbeiter eines bestimmten Jobs (hier Sales Rep) mit Einstellungsdatum, Gehalt und Gehaltsbereich
drop view if exists v_SalesRepInfo;
create view v_SalesRepInfo (Employee, Hiredate, Salary, SalRange )
as
select concat(fname,' ', lname), hiredate,  sal, concat('your Salary is between ',losal,'$ and ', hisal, '$')
from employee e
join emphistory eh on e.empid=eh.empid
join jobs j on eh.jobid = j.jobid
join salgrade s on j.gradeid=s.gradeid
where descrip = 'SALES REP';


-- Test
select * from v_SalesRepInfo

-- Erwartet werden folgende Informationen: