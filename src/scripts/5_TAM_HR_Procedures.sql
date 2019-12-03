-- 
-- Datenbank: TAM
-- erstellt am 18.06.2019
-- durch Übungsgruppe DB2
-- Prozeduren für Personalverwaltung (Beschreibung im Pflichtenheft)


-- Prozedur p_NewAddress
-- fügt eine neue Adresse in die Tabelle Address ein
-- erwartet als Übergabewerte Postleitzahl, Ort, StrHnr sowie Bundesland

USE TAM;

DELIMITER $$
drop procedure if exists p_NewAddress $$
create procedure p_NewAddress ( IN inZip char(5), IN inCity varchar(50)
										 , IN inStrNo varchar(50), IN inUsstate char(2))
begin
	declare getAddrID int(11);
	set getAddrID = fn_GetAddrID (inZip, inCity, inStrNo, inUsstate);
	if getAddrID is null
		then
		insert into Address (zip, city, strno, usstate)
		values (inZip, inCity , inStrNo , inUsstate);
	end if;
END$$
DELIMITER ;

-- Test mit 99085 Erfurt Altonaer Str. 25 in TH (Thüringen)
-- bei Erfolg steht Datensatz in Tabelle Address
-- call p_NewAddress ('99085', 'Erfurt', 'Altonaer Str. 25', 'TH');  -- >ok


-- Prozedur p_NewEmp
-- fügt einen neuen Datensatz in die Tabelle Employee ein
-- erwartet als Übergabewerte Personalnummer, Vorname, Familienname, Geburtsdatum, Einstellungsdatum und Adresse
-- ermittelt über Aufruf von fn_GetAddrID die zugehörige Adressnummer
-- generiert über Aufruf von fn_SetMail die neue Mailadresse

DELIMITER $$
drop procedure if exists p_NewEmp $$
create procedure p_NewEmp ( IN inEmpid int(4)    ,  IN inFname varchar(30), IN inLname varchar(50)
									 , IN inDob date        ,  IN inHiredate date    , IN inZip char(5)
									 , IN inCity varchar(50), IN inStrNo varchar(50) , IN inUsstate char(2))
begin
	declare setAddrID int(11);
	declare setMail varchar(80);
	
	set setMail = fn_SetMail(inFname, inLname);	
	set setAddrID = fn_GetAddrID(inZip, inCity , inStrNo , inUsstate);
	
	insert into Employee (Empid, Fname, Lname, Dob, Hiredate, Mail, Addrid)
	values (inEmpid, inFname, inLname, inDob, inHiredate, setMail, setAddrid);
END$$
DELIMITER ;

-- Testen -- >ok

-- call p_NewEmp (9999,'Otto', 'Musterman', '1970-01-01', '1990-10-01', '99085','Erfurt','Altonaer Str. 25', 'TH');
-- call p_NewEmp (9998,'Anna', 'Musterwomen', '1970-01-02', '1990-10-01', '99085','Erfurt','Altonaer Str. 25', 'TH');
-- call p_NewEmp (9997,'Frank', 'Musterperson', '1970-01-03', '1990-10-01', '99085','Erfurt','Altonaer Str. 27', 'TH');

-- Prozedur p_NewEmpHistory
-- fügt einen neuen Datensatz in Tabelle Emphistory ein
-- erwartet als Übergabewerte Personalnummer, Abteilung, Job, Startdatum
-- generiert über Aufruf von fn_SetVac den zum Job gehörenden Urlaubsanspruch sowie über Aufruf von fn_GetSal das Anfangsgehalt
-- generiert über Aufruf von fn_SetMgr den zum Job und zur Abteilung gehörende ManagerID

DELIMITER $$
drop procedure if exists p_NewEmpHistory $$
create procedure p_NewEmpHistory ( IN inEmpid int(4), IN inDname varchar(30), IN inDescrip varchar(30), IN inStartDate date)
begin
	declare setVac int(2);
	declare setSal decimal(7,2);
	declare setMgrID int(4);
	declare setJobID int(2);
	declare setDeptID int(2);
	
	set setVac 		= fn_SetVac(inDescrip);	
	set setSal 		= fn_GetSal (inDescrip);
	set setMgrID 	= fn_SetMgr (inDescrip);
	
	select DEPTID into setDeptID from departments where dname = inDname;
	select JOBID into setJobID from jobs where descrip = inDescrip;
	
	insert into EmpHistory (Empid, DeptId, JobID, MgrID,Startdate, Sal, Vac)
	values (inEmpid, setDeptId, setJobID, setMgrID, inStartdate, setSal, setVac);
END$$
DELIMITER ;

-- Testen -- > ok

-- call p_NewEmpHistory (9999, 'Headquarter', 'President', '1990-10-01');
-- call p_NewEmpHistory (9998, 'Sales', 'Manager Sales', '1990-10-01');
-- call p_NewEmpHistory (9997, 'Sales', 'Sales Rep', '1990-10-01');

-- Prozedur p_NewAccount
-- Prozedur p_NewEmpHistory
-- fügt einen neuen Datensatz in Tabelle Account ein
-- erwartet als Übergabewert die Personalnummer
-- generiert über Aufruf von fn_SetPW das initiale Passwort

DELIMITER $$
drop procedure if exists p_NewEmpAccount $$
create procedure p_NewEmpAccount (IN inEmpid int(4))
begin
	declare setAccName varchar(80);
	declare setRole varchar(30);
	declare setPW varchar(20);
	declare varFname, varLname varchar(50);
	declare varDob date;

	
	select descrip into setRole 
	from jobs j 
	join emphistory eh on j.jobid =eh.jobid
	where empid= inEmpid;
	
	select  mail, fname, lname, dob into setAccName, varFname, varLname, varDob
	from employee
	where empid= inEmpid;
	
	
	set setPW = fn_SetPW(varFname,varLname, varDob);
	
	insert into Account(Accname, Role, Password, Created)
	values (setAccName, setRole, setPW, now());
END$$
DELIMITER ;

-- Testen -- > ok

-- call p_NewEmpAccount(9999);
-- call p_NewEmpAccount(9998);
-- call p_NewEmpAccount(9997);


-- Prozedur p_CreateNewEmployee
-- erwartet als Übergabewerte: Personalnummer, Vorname, Familienname, Geburtsdatum, Adresse, Einstellungsdatum, Job, Abteilung
-- trägt Daten ein in: 
-- 1. ADDRESS --> Aufruf p_NewAddress
-- 2. EMPLOYEE --> Aufruf p_NewEmp
-- 3. EMPHISTORY --> Aufruf p_NewEmpHistory
-- 4. ACCOUNT --> Aufruf p_NewAccount

DELIMITER $$
drop procedure if exists p_CreateNewEmployee $$
create procedure p_CreateNewEmployee ( IN inEmpid int(4)    ,  IN inFname varchar(30)	, IN inLname varchar(50) , IN inDob date 
												, IN inZip char(5)	   ,  IN inCity varchar(50)		, IN inStrNo varchar(50) , IN inUsstate char(2)
											    , IN inHiredate date   ,  IN inDescrip varchar(30)	, IN inDname varchar(30))
begin
	call p_NewAddress (inZip, inCity, inStrNo, inUsstate);
	call p_NewEmp (inEmpid,inFname, inLname, inDob, inHiredate, inZip, inCity, inStrNo, inUsstate);
	call p_NewEmpHistory (inEmpid, inDname, inDescrip, inHiredate);								
    call p_NewEmpAccount(inEmpid);		
end $$
DELIMITER ;	

-- Testen -- > ok
-- call p_CreateNewEmployee (9999, 'Otto', 'Musterman', '1970-01-01','99085', 'Erfurt', 'Altonaer Str. 25', 'TH', '1990-10-01', 'President','Headquarter');	
-- call p_CreateNewEmployee (9998, 'Anna', 'Musterwomen', '1970-02-01','99999', 'Teststadt', 'Teststr. 1', 'TH', '1990-10-01', 'Manager_Sales', 'Sales' );		
-- call p_CreateNewEmployee (9997, 'Frank', 'Musterperson', '1970-03-01','99999', 'Teststadt', 'Teststr. 1', 'TH', '1990-10-01', 'Sales Rep','Sales' );									
-- call p_CreateNewEmployee (9996, 'Claire', 'Grube', '1970-01-01','99999', 'Teststadt', 'Teststr. 1', 'TH', '2019-06-18', 'Clerk','Warehousing' );	 
						
										 

										 
-- Prozedur p_MigrateEmpOld
-- Aufruf von p_CreateNewEmployee
-- erwartet als Übergabewerte: Personalnummer, Vorname, Familienname, Geburtsdatum, Adresse, Einstellungsdatum, Abteilung, Job
-- werden mittels Cursor aus emp_old gelesen und per Prozeduren in die jeweiligen Tabellen eingetragen
-- 1. ADDRESS --> Aufruf p_NewAddress
-- 2. EMPLOYEE --> Aufruf p_NewEmp
-- 3. EMPHISTORY --> Aufruf p_NewEmpHistory
-- 4. ACCOUNT --> Aufruf p_NewAccount		

DELIMITER $$
drop procedure if exists p_MigrateEmpOld $$
create procedure p_MigrateEmpOld()
begin

 declare done int DEFAULT 0;
 declare vEMPNO int(4);
 declare vFNAME,vJOB, vDEPARTMENT  varchar(30);
 declare vLNAME,  vCITY, vSTRNO varchar(50);
 declare vBIRTHDATE,vHIREDATE date;
 declare vZIP char(5);
 declare vUSSTATE char(2);
 
 -- declare cursor for employee 
 declare empOldCur CURSOR 
 FOR 
 SELECT EMPNO, FNAME,LNAME, BIRTHDATE, ZIP, CITY, STRNO, USSTATE, HIREDATE, JOB, DEPARTMENT 
 FROM tam.emp_old;

 declare CONTINUE HANDLER 
 FOR NOT FOUND SET done = 1;

open empOldCur;

	fetch empOldCur 
	into vEMPNO, vFNAME,vLNAME, vBIRTHDATE, vZIP, vCITY, vSTRNO, vUSSTATE, vHIREDATE, vJOB, vDEPARTMENT ;
	
	while not done do
		call p_CreateNewEmployee(vEMPNO, vFNAME, vLNAME, vBIRTHDATE, vZIP, vCITY, vSTRNO, vUSSTATE, vHIREDATE, vJOB, vDEPARTMENT);	
		-- call p_NewAddress (vZip, vCity, vStrNo, vUsstate);
		-- call p_NewEmp (vEMPNO,vFname, vLname, vBIRTHDATE, vHiredate, vZip, vCity, vStrNo, vUsstate);
		-- call p_NewEmpHistory (vEMPNO, vDEPARTMENT, vJOB, vHiredate);								
		-- call p_NewEmpAccount(vEMPNO);
		
		fetch empOldCur 
		into vEMPNO, vFNAME,vLNAME, vBIRTHDATE, vZIP, vCITY, vSTRNO, vUSSTATE, vHIREDATE, vJOB, vDEPARTMENT ;
	end while;

 CLOSE empOldCur; 
end $$ 
DELIMITER ;

-- Testen
-- vorher Dummy-Daten aus den vorherigen Tests entfernen
-- Achtung: Reihenfolge beachten und einzeln ausführen
-- delete from account;
-- delete from emphistory;
-- delete from address;
-- delete from employee;
-- TRUNCATE TABLE geht nur für account und emphistory
-- TRUNCATE TABLE für employee und account scheitert am Foreign Key, SET FOREIGN_KEY_CHECK =0 funktioniert nicht (phpMyAdmin-Problem?)


CALL p_MigrateEmpOld();

-- bei Erfolg 10 DS in employee, account, emphistory und address

-- damit ist die Migration der Altdaten abgeschlossen. Die Tabelle emp_old kann gelöscht werden
DROP TABLE emp_old;

/* ****************************************************************************************************************************** */