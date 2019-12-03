-- 
-- Datenbank: TAM
-- erstellt am 25.06.2019
-- durch Übungsgruppe DB2
-- Prozeduren mit Cursor für Personalverwaltung
-- Trigger für Personalverwaltung

-- ab hier folgen weitere Prozeduren wie im Pflichtenheft ausgewiesen
-- Prozeduren für die Beschäftigungshistorie --> p_ChangeJobDept und p_ChangeSal mit Trigger tr_CheckSal
-- Datenimport für die Abwesenheitshistorie und Trigger tr_ReportLeavetimes



-- 1. Prozedur p_ChangeJobDept							 
-- erwartet als Übergabewerte: Personalnummer, Job, Abteilung, Startdatum
-- ermittelt aktuelle Werte von JOBID, DEPTID, VAC, SAL, MGRID in EMPHISTORY
-- vergleicht, um eventuelle Unterschiede zu finden bisherige DEPTID und neue DEPTID sowie bisherige JOBID und neue JOBID
-- setzt bisheriges Enddatum auf Startdatum-1	
-- trägt Datensatz mit den geänderten (bzw. gleichen) Werten ein


DELIMITER $$
create procedure p_ChangeJobDept(IN inEmpid int(4), IN inDname varchar(30), IN inDescrip varchar(30), IN inStartDate date)
begin	
	declare oldVac, newVac int(2);
	declare oldSal, newSal decimal(7,2);
	declare oldMgrID, newMgrID int(4);
	declare oldJobID, newJobID int(2);
	declare oldDeptID, newDeptID int(2);
	declare setEndDate date;
	
	-- Enddatum für den bisherigen Eintrag setzen
	set setEndDate =date_sub(inStartDate, INTERVAL 1 DAY);
	
	-- aktuelle Werte aus emphistory auslesen
	select DEPTID, JOBID, MGRID, SAL, VAC
	INTO oldDeptID, oldJobID, oldMgrID, oldSal,oldVac
	FROM emphistory
	where empid= inEmpid and enddate is null;
	
	-- Fall 1 der Übergabewert für Job entspricht dem bereits eingetragenen Job --> Sal und Vac bleiben gleich, Abteilung ist neu
		 -- > alle Werte für JOBID, MGRID, SAL, VAC können wieder genauso eingetragen werden, DEPTID muss ermittelt werden
    	
	if oldJobID = (select JOBID from jobs where DESCRIP = inDescrip)
	then 		
		if oldDeptID != (select DEPTID from departments where DNAME = inDname)
		then 
			-- Werte für neuen Eintrag in EMPHISTORY festlegen
			-- DEPTID ermitteln
			select DEPTID INTO newDeptID from departments where DNAME = inDname;
			-- restliche Werte werden wieder übernommen
			set newJobID=oldJobID;
			set newMgrID =oldMgrID;
			set newSal =oldSal;
			set newVac=oldVac;
		end if;
	else
		-- Fall 2 falls die in emphistory stehende Jobnummer eine andere ist als die des eingegebenen Jobs, dann wurde der Job gewechselt
		-- in dem Fall ändern sich auch der Urlaubsanspruch, das Gehalt und der Manager
		-- eventuell ändert sich auch die Abteilungsnummer
		
		-- neue Werte für VAC, SAL und MGRID ermitteln
		set newVac 		= fn_SetVac (inDescrip);	
		set newSal 		= fn_GetSal (inDescrip);
		set newMgrID 	= fn_SetMgr (inDescrip);
		
		-- neue JOBID ermitteln
		select JOBID INTO newJOBID from jobs where DESCRIP = inDescrip;
		
		-- Prüfen, ob auch Abteilung neu ist
		-- > falls ja, alten Wert übernehmen
		if oldDeptID = (select DEPTID from departments where DNAME = inDname)
		then 
			set newDeptID=oldDeptID;
		else
			-- falls nein, neue DEPTID ermitteln
			select DEPTID INTO newDeptID from departments where DNAME = inDname;
		end if;
	end if;	
		
	-- neuen Eintrag erzeugen
	insert into EmpHistory (Empid, DeptId, JobID, MgrID,Startdate, Sal, Vac)
	values (inEmpid, newDeptId, newJobID, newMgrID, inStartdate, newSal, newVac); 
	
	-- alten Eintrag abschließen
	update emphistory
	set ENDDATE = setEndDate
	where EMPID = inEmpid and ENDDATE is null and STARTDATE < inStartDate;
	
end $$
DELIMITER ;

-- Testen
-- JOHN JAMES (EMPID 1011) wird als Clerk in die Abteilung WAREHOUSING versetzt ab 01.07.2019
-- erwartet wird ein neuer Eintrag in EMPHISTORY mit Änderungen nur bei DEPTID, alle anderen Werte bleiben gleich und der bisherige Eintrag bekommt ein Enddatum 30.06.2019

CALL p_ChangeJobDept (1011, 'WAREHOUSING', 'CLERK', '2019-07-01' );  -- > ok

-- AMANDA SCOTT (EMPID 2011) wird als Analyst in die Abteilung ANALYTICS versetzt ab 15.07.2019
-- erwartet wird ein neuer Eintrag in EMPHISTORY mit Änderungen bei DEPTID, MGRID, SAL, VAC und der bisherige Eintrag bekommt ein Enddatum 14.7.2019

CALL p_ChangeJobDept (2011, 'ANALYTICS', 'ANALYST', '2019-07-15' ); -- > ok

-- ---------------------------------------------------------------------------------------------------------------------------

-- Prozedur p_NewSal
-- Prozedur erwartet als Eingabe eine Personalnummer,den Betrag, um den das Gehalt erhöht wird und das Datum, ab dem das neue Gehalt gelten soll
-- überprüft, ob das Gehalt innerhalb der erlaubten Grenzen liegt
--    wenn nein, wird das übergeben Gehalt abgeändert in das zulässige Höchstgehalt im jeweiligen Job

-- ursprüngliche Idee: Trigger übernimmt Prüfung --> nicht realisierbar, Aktionen innerhalb des Triggers, die sich auf die aufrufende Tabelle beziehen, sind nicht erlaubt


DELIMITER $$
create procedure p_ChangeSal(IN inEmpid int(4), IN inMoney decimal(7,2),IN inStartDate date)
begin
	declare oldVac int(2);
	declare oldMgrID int(4);
	declare oldJobID int(2);
	declare oldDeptID  int(2);
	declare vEndDate date;
	declare oldSal decimal(7,2);
	declare newSal decimal(7,2);
	declare vHisal decimal(7,2);
	
	
	-- aktuelle Werte aus emphistory auslesen
	select DEPTID, JOBID, MGRID, SAL, VAC
	INTO oldDeptID, oldJobID, oldMgrID, oldSal, oldVac
	FROM emphistory
	where empid= inEmpid and enddate is null;
	
	-- neues Gehalt festlegen
	set newSal = oldSal+inMoney;
	
	-- Enddatum für den bisherigen Eintrag festlegen
	set vEndDate = date_sub(inStartDate, INTERVAL 1 DAY);	
	
	-- Gehalt prüfen
	-- da höchste zulässige Gehalt im aktuellen Job des Mitarbeiters ermitteln
	select hisal into vHisal
	from salgrade s
	join jobs j on j.gradeid=s.gradeid
	where JOBID = oldJOBID;
	
	-- Überprüfen, ob Gehalt im zulässigen Bereich liegt
	-- übersteigt das neue Gehalt die Obergrenze, soll es auf den höchsten zulässigen Wert gesetzt werden
	if newSAL > vHisal 
	then set newSAL = vHisal;
	end if;	
	
	-- neuen Eintrag erzeugen
	insert into EmpHistory (Empid, DeptId, JobID, MgrID,Startdate, Sal, Vac)
	values (inEmpid, oldDeptId, oldJobID, oldMgrID, inStartdate, newSal, oldVac); 
	
	-- alten Eintrag abschließen
	update emphistory
	set ENDDATE = vEndDate
	where EMPID = inEmpid and ENDDATE is null and STARTDATE < inStartDate;

end $$
DELIMITER ;	

-- Testfall 1
-- AMANDA SCOTT (EMPID 2011) bekommt ab 01.08.2019 eine Gehaltserhöhung von 500$
-- Erwartet wird, dass ein neuer Eintrag in EMPHISTORY erzeugt wird mit Gehalt 2500, der bisherige abgeschlossen wird mit ENDDATE 31.07.2019
call p_ChangeSal(2011,500.00,'2019-08-01');  -- > ok


-- Testfall 2
-- AMANDA SCOTT (EMPID 2011) bekommt am 01.09.2019 eine Gehaltserhöhung von 600$. 
-- Erwartet wird, dass der Verstoß gegen die Geschäftsregel entdeckt und die Gehaltserhöhung angepasst wird
-- ein neuer Eintrag wird in EMPHISTORY erzeugt mit Gehalt 2999.99, der bisherige Eintrag wird abgeschlossen mit ENDDATE 31.08.2019
call p_ChangeSal(2011,600.00,'2019-09-01');  -- > ok

-- ---------------------------------------------------------------------------------------------------------------------------

-- Datenimport aus ImportEmpLeavetime.csv
-- Trigger tr_ReportLeavetimes --> kann nicht realisiert werden, da Funktionalität nicht zur Verfügung steht (select aus Trigger nicht erlaubt)








































