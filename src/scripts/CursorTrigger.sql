-- 
-- Datenbank: TAM und SW
-- erstellt am 02.07.2019
-- durch Übungsgruppe DB2
-- Prozeduren mit Cursor
-- Trigger

USE TAM;
-- Überwachungstabelle für die Tabelle ACCOUNT
-- hier werden Passwort-Änderungen protokolliert

DROP TABLE IF EXISTS t_auditAccount;
CREATE TABLE IF NOT EXISTS t_auditAccount
(
aid int not null auto_increment primary key,
accname varchar(100) not null,
oldPW varchar(30) null,
newPW varchar(30) null,
created datetime not null default now()
);

DELIMITER $$
drop PROCEDURE IF EXISTS p_ChangePassword $$
create procedure p_ChangePassword (inAccName varchar(100), inPassword varchar(20))
begin
	declare vChanged date;
	set vChanged = curdate();
	
	UPDATE account 
	SET PASSWORD = inPassword, changed=vChanged
	WHERE ACCNAME = inAccName;
	
end $$
DELIMITER ;	

-- 
-- Testen
-- Setze neues Passwort für Stephen King auf 12345
-- Erwartet wird, dass das neue Passwort und das Änderungsdatum in die Tabelle eingetragen wurden

call p_ChangePassword('s.king@tam.com','12345');  -- > ok

-- 2. TRIGGER
-- Trigger tr_AuditChangeAccount
-- einfacher DML - Trigger, der das Ändern der Passwörter überwacht
-- Trigger protokolliert das alte und das neue Passwort sowie das Datum der Änderung in die Tabelle t_auditAccount
-- Trigger sollte das Änderungsdatum in die Tabelle ACCOUNT eintragen --> geht nicht, wird nicht unterstützt (Aktion in der gleichen Tabelle)

drop trigger IF EXISTS tr_AuditChangePassword;
DELIMITER $$
create trigger tr_AuditChangePassword
BEFORE
UPDATE
on account for each row
begin
	-- Audit-Tabelle füllen
    insert into t_auditAccount (accname,oldPW,newPW)
    values (OLD.accname,OLD.Password, NEW.Password);
	
end $$
DELIMITER ;	


-- 
-- Testen
-- Setze neues Passwort für Stephen King auf 54321 mittels der Prozedur
-- Erwartet wird, 
-- dass das neue Passwort und das Änderungsdatum in die Tabelle eingetragen wurden
-- dass in der Überwachungstabelle altes und neues Passwort und Änderungsdatum stehen

call p_ChangePassword('s.king@tam.com','54321');  -- > ok


USE SW;

-- Prozedur zum Einfügen einer neuen Bestellung
-- Trigger berechnet Gesamtbestellsumme

-- 1. neue Spalte TOTAL decimal(10,2) null zu orders hinzufügen
ALTER TABLE orders 
ADD TOTAL decimal(10,2) null;

-- Prozedur p_NewOrder
-- erwartet als Argumente: Kundennummer, Produktbezeichnung, bestellte Menge, Verkaufspreis)
-- Aktionen: 1. Eintrag in orders (ORDID wird durch Inkrementieren der höchsten Bestellnummer generiert, ORDERDATE ist aktuelles Datum, 
--									SHIPDATE wird erst bei Versand aktualisiert, TOTAL wird durch Trigger berechnet und aktualisiert)
--			 2. Eintrag in orderitems (ITEMID beginnt bei jeder neuen Bestellung mit 1 und wird für jede weitere Bestellposition  um 1 hochgezählt, 
-- 									   ITEMTOT wird berechnet aus Menge*Preis)

DELIMITER $$
create procedure p_NewOrder (inCUSTID int(11), inDescrip varchar (30), inQTY int(11), inActualprice decimal(8,2))
begin
	declare vORDID, vITEMID, vPRODID int(11);
	declare vITEMTOT decimal(8,2);
	
	
	-- Aktion 1: Tabelle orders füllen
	-- vorher prüfen, ob es für diesen Kunden an diesem Tag schon eine Bestellung gibt (alle Bestellungen des Tages werden zusammengefasst unter einer Bestellnummer)
		
	select ORDID into vORDID from orders where CUSTID = inCUSTID and ORDERDATE =CURDATE();
	if vOrdID is null
	then
		-- für INSERT in orders benötigte Variablen initialisieren	
		select max(ORDID)+1 into vORDID from orders;
		insert into orders (ORDID, ORDERDATE, CUSTID)
		values (vORDID, CURDATE(), inCUSTID);
	end if;
	
	-- Aktion 2: Tabelle orderitems füllen
	-- für INSERT in orderitems benötigte Variablen initialisieren
	-- überprüfen, ob es für diese Bestellnummer schon eine Bestellposition gibt, wenn nein ITEMID auf 1 setzen, ansonsten inkrementieren
	select max(ITEMID) into vITEMID from orderitems where ORDID = vORDID;
	if vITEMID is null
		then
		set vITEMID =1;
	else
		set vITEMID =vITEMID+1;
	end if;
	
	select PRODID into vPRODID from products where DESCRIP = inDescrip;
	set vITEMTOT = inActualprice*inQTY;
	
	insert into orderitems (ORDID,ITEMID,PRODID,ACTUALPRICE,QTY, ITEMTOT)
	values (vORDID, vITEMID,vPRODID,inActualprice, inQTY, vITEMTOT);

end $$
DELIMITER ;

-- Testen
call p_NewOrder (100, 'ACE TENNIS NET',20, 52.00);
call p_NewOrder (100, 'ACE TENNIS RACKET I',40, 56.00);
call p_NewOrder (100, 'ACE TENNIS BALLS-6 PACK',40, 5.60);

-- > ok

-- 2. Trigger tr_setTotal der Gesamtpreis berechnet und einträgt
-- wird in orderitems durch insert ausgelöst
-- summiert die Positionssummen und trägt diesen Wert in orders ein

drop trigger IF EXISTS tr_setTotal;
DELIMITER $$
create trigger tr_setTotal
AFTER
INSERT
on orderitems for each row
begin
	declare vTOTAL decimal(10,2);
	select SUM(ITEMTOT) into vTOTAL from orderitems where ORDID = NEW.ORDID;
	update orders
	set TOTAL = vTOTAL
	where ORDID = NEW.ORDID;	
end $$
DELIMITER ;	


-- Testen
-- erwartet wird 3504.00 als Eintrag in orders bei ORDID mit Kunde 103 und aktuellem Datum
call p_NewOrder (103, 'ACE TENNIS NET',20, 52.00);
call p_NewOrder (103, 'ACE TENNIS RACKET I',40, 56.00);
call p_NewOrder (103, 'ACE TENNIS BALLS-6 PACK',40, 5.60);  -- > ok

























