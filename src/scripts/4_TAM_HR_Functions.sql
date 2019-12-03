-- Datenbank: TAM
-- erstellt am 11.06.2019
-- durch Übungsgruppe DB2
-- Funktionen für Personalverwaltung (Beschreibung im Pflichtenheft)

USE TAM;

-- 1. Funktion fn_SetMail
/* Diese Funktion erzeugt aus der Eingabe (Vorname und Familienname des Mitarbeiters) eine Mailadresse nach der Vorschrift: 
Initial des Vornamens.Familienname@tam.com und gibt diese zurück.*/

DELIMITER $$
drop function if exists fn_SetMail $$
create function fn_SetMail ( fname varchar(30), lname varchar(50))
returns varchar(100) 
begin
	declare mail varchar(100);
	set mail=lower(concat(substring(fname,1,1),'.',lname,'@tam.com'));
	return (mail);
END$$
DELIMITER ;

-- Testen mit Amanda Scott --> erwarteter Wert: a.scott@tam.com 
select fn_SetMail ('Amanda', 'Scott'); -- > a.scott@tam.com  --> ok
-- Testen mit den Daten aus emp_old
select fn_SetMail (fname, lname) from emp_old; -- > ok



-- 2. Funktion fn_GetAddrID
/*Diese Funktion sucht mittels der Eingabe (PLZ, Stadt, Straße und Hausnummer sowie Bundesstaat) den passenden Eintrag in die Adress-Tabelle und gibt die AddressID zurück.*/

DELIMITER $$
drop function if exists fn_GetAddrID $$
create function fn_GetAddrID ( inZip char(5),inCity varchar(50), inStrNo varchar(50), inUsstate char(2) )
returns int
begin
	declare OutaddrID int;
	set OutaddrID=(select AddrID 
	from address 
	where zip= inZip
	and city= inCity 
	and strno = inStrNo
	and usstate=inUsstate);
	return (OutaddrID);
END$$
DELIMITER ;

-- Testen mit Testdatensatz: 
select fn_getAddrID ('99085', 'Erfurt', 'Altonaer Str. 25','TH'); -- > 1 ok
-- Testen mit den Daten aus emp_old
select fn_getAddrID (zip, city, strno, usstate) from emp_old;  --> ok


-- 3. Funktion fn_GetSal
/*Diese Funktion sucht mittels der Eingabe (Job) das Anfangsgehalt des Mitarbeiters 
nach der Vorschrift: Neue Mitarbeiter bekommen als Anfangsgehalt das Einstiegsgehalt (untere Grenze) in der Gehaltsstufe des Jobs.*/

DELIMITER $$
drop function if exists fn_GetSal $$
create function fn_GetSal ( InJob char(30))
returns decimal(7,2)
begin
	declare OutSal decimal(7,2);

	SELECT LOSAL INTO OutSal
	FROM jobs 
	JOIN salgrade ON jobs.GRADEID=salgrade.GRADEID
	WHERE DESCRIP = InJob;

	return (OutSal);
   
END $$
DELIMITER ;

-- Testen mit Clerks --> erwartet 1000,00
select fn_GetSal ('Clerk'); -- >ok
-- Testen mit Analyst --> erwartet 2000,00
select fn_GetSal ('Analyst'); -- > ok


-- 4. Funktion fn_SetVac
/*Diese Funktion erzeugt aus der Eingabe (Job) den Urlaubsanspruch des Mitarbeiters 
nach der Vorschrift: 
President und Vice Presidents haben einen Urlaubsanspruch von 40 Tagen, 
Manager und Analysten von 35 Tagen, 
Clerks und Sales Representatives von 30 Tagen. 

*/

DELIMITER $$
drop function if exists fn_SetVac $$
create function fn_SetVac ( InJob char(30))
returns int
begin
	declare  OutVac int;
	
	if InJob = 'President' or InJob like 'VP%'
		then set OutVac=40;
    ELSEIF InJob like 'Manager%' or InJob = 'Analyst'
    	then set OutVac=35;
    ELSEIF InJob ='Clerk' or InJob = 'Sales Rep'
    	then set OutVac=30;
    ELSE
    	set OutVac=0;
    end if;
	return (OutVac);
   
END $$
DELIMITER ;

-- Testen für alle Jobs und Kontrolle der Einhaltung der Regeln
select descrip, fn_SetVac(descrip) from jobs; -- > alle Ergebnisse ok

-- 5. Funktion fn_SetMgr
/*Diese Funktion erzeugt aus der Eingabe (Job und Abteilung) die ID des Vorgesetzten des Mitarbeiters 
nach der Vorschrift wie im Pflichtenheft dokumetiert
Da derzeit einige Stellen nicht besetzt sind, ist aktuell folgende Geschäftsregel umzusetzen:
Vorgesetzter aller Sales Representatives ist die Person mit dem Job Manager_Sales. 
Vorgesetzter von Manager_Sales und aller anderen Jobs ist die Person mit dem Job President.
*/

DELIMITER $$
drop function if exists fn_SetMgr $$
create function fn_SetMgr ( inJob char(30))
returns int
begin
	declare  OutMgrID int;
	
	if inJob ='President'
	then
	set OutMgrID = null;
	
	elseif inJob ='Sales Rep'
	then
    	select e.EMPID into outMgrID 
		from employee e 
		join emphistory eh on e.empid = eh.empid
		join jobs j on eh.jobid=j.jobid
		where descrip = 'Manager_Sales' and enddate is null;
		
	else
		select e.EMPID into outMgrID 
		from employee e
		join emphistory eh on e.EMPID=eh.EMPID
		join jobs j on eh.jobid=j.jobid
		where descrip = 'President' and enddate is null;
	
	end if;
	
	return (OutMgrID);
   
END $$
DELIMITER ;


-- Testen (macht erst Sinn, wenn Daten in Employee sind)
select fn_SetMgr('SALES REP');


-- 6. Funktion fn_SetPW
/* Diese Funktion erzeugt aus der Eingabe (Vorname, Familienname, Geburtsdatum) 
das initiale Passwort des Mitarbeiters nach der Vorschrift: 
Das initiale Passwort wird gebildet aus den Initialen des Namens (Großbuchstaben), der Länge des Namens, Tag und Monat des Geburtstages.*/

DELIMITER $$
drop function if exists fn_SetPW $$
create function fn_SetPW( fname varchar(30), lname varchar(50), DOB date)
returns varchar(20) 
begin
	declare OutPW varchar(20);
	set OutPW= concat(upper(substring(fname,1,1)),upper(substring(lname,1,1)),length(concat(fname,lname)),DAY(DOB),MONTH(DOB));
	return (OutPW);
END$$
DELIMITER ;

-- Testen mit Max Mustermann, geboren am 31.12.1990 -- > erwartet wird: MM133112

select fn_SetPW ('Max','Mustermann', '1990-12-31'); -- > MM133112 -- ok
-- Testen mit den Daten emp_old
select fn_SetPW (fname, lname, birthdate) from emp_old;