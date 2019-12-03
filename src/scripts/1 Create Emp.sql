-- 
-- Datenbank: TAM
-- erstellt am 04.06.2019
-- durch Übungsgruppe DB2
-- Datenbank mit Tabellen für Personalverwaltung

DROP DATABASE IF EXISTS TAM;
CREATE DATABASE IF NOT EXISTS TAM DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE TAM;

-- --------------------------------------------------------
-- Tabellenstruktur für Tabelle DEPARTMENTS
-- 

DROP TABLE IF EXISTS DEPARTMENTS;
CREATE TABLE IF NOT EXISTS DEPARTMENTS (
  DEPTID int(2) NOT NULL,
  DNAME varchar(30) NOT NULL,
  DCITY varchar(50) NOT NULL,
  CONSTRAINT departments_pk PRIMARY KEY (DEPTID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--  
-- Daten für Tabelle DEPARTMENTS
INSERT INTO DEPARTMENTS (DEPTID, DNAME, DCITY) VALUES
(10, 'HEADQUARTER', 'NEW YORK'),
(20, 'SALES', 'NEW YORK'),
(30, 'WAREHOUSING', 'NEW YORK'),
(40, 'ANALYTICS', 'NEW YORK');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle SALGRADE
-- 

DROP TABLE IF EXISTS SALGRADE;
CREATE TABLE IF NOT EXISTS SALGRADE (
  GRADEID int(1) NOT NULL,
  LOSAL  decimal(7,2) NOT NULL,
  HISAL  decimal(7,2) NULL,
  CONSTRAINT salgrade_pk PRIMARY KEY (GRADEID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle SALGRADE
-- 

INSERT INTO SALGRADE (GRADEID, LOSAL, HISAL)VALUES
(1, 1000.00, 1999.99),
(2, 2000.00, 2999.99),
(3, 3000.00, 3999.99),
(4, 4000.00, null);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle JOBS

DROP TABLE IF EXISTS JOBS;
CREATE TABLE IF NOT EXISTS JOBS (
  JOBID int(2) NOT NULL,
  DESCRIP varchar(30) NOT NULL,
  GRADEID int(1) NULL,
  CONSTRAINT jobs_pk PRIMARY KEY (JOBID),
  CONSTRAINT descrip_uq UNIQUE (DESCRIP),
  CONSTRAINT jobs_salgrade_fk FOREIGN KEY (GRADEID) REFERENCES SALGRADE(GRADEID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle JOBS
-- 

INSERT INTO JOBS (JOBID, DESCRIP, GRADEID)VALUES
(1, 'CLERK',1),
(2, 'SALES REP',1),
(3, 'ANALYST',2),
(4, 'MANAGER_SALES',2),
(5, 'VP Sales',3),
(6, 'VP WH',3),
(7, 'VP HR',3),
(8, 'PRESIDENT',4);

-- --------------------------------------------------------

DROP TABLE IF EXISTS ADDRESS;
CREATE TABLE IF NOT EXISTS ADDRESS (
  ADDRID int(11) NOT NULL AUTO_INCREMENT,
  ZIP char(5) NOT NULL,
  CITY varchar(50) NOT NULL,
  STRNO varchar(50) NOT NULL,
  USSTATE char(2) NOT NULL,
  CONSTRAINT address_pk PRIMARY KEY (ADDRID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Daten für Tabelle ADDRESS über Prozedur einfügen
-- Testdatensatz

INSERT INTO ADDRESS (ZIP, CITY, STRNO, USSTATE)
VALUES ('99085', 'Erfurt', 'Altonaer Str. 25', 'TH');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle EMPLOYEE
-- FOREIGN KEY (ADDRID) wird über ALTER TABLE hinzugefügt

DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE IF NOT EXISTS EMPLOYEE (
  EMPID int(4) NOT NULL,
  FNAME varchar(30) NOT NULL,
  LNAME varchar(50) NOT NULL,
  MAIL varchar(100) DEFAULT 'f.lname@tam.com' NOT NULL,
  HIREDATE date NOT NULL,
  DOB date NOT NULL,
  ADDRID int(11) NOT NULL,
  CONSTRAINT employee_pk PRIMARY KEY (EMPID),
  CONSTRAINT mail_uq UNIQUE (MAIL)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  

--
-- initiale Daten für Tabelle EMPLOYEE über Prozeduren einfügen
--


-- --------------------------------------------------------

-- Tabellenstruktur für Tabelle EMPHISTORY
-- FOREIGN KEY (EMPID) wird über ALTER TABLE hinzugefügt
-- FOREIGN KEY (DEPTID) wird über ALTER TABLE hinzugefügt
-- FOREIGN KEY (JOBID) wird über ALTER TABLE hinzugefügt
-- FOREIGN KEY (MGRID) wird über ALTER TABLE hinzugefügt

DROP TABLE IF EXISTS EMPHISTORY;
CREATE TABLE IF NOT EXISTS EMPHISTORY (
  HISTID int (11) NOT NULL AUTO_INCREMENT,
  EMPID int(4) NOT NULL,
  DEPTID int(2) NOT NULL,
  JOBID int(2) NOT NULL,
  MGRID int(4) NULL,
  STARTDATE date NOT NULL,
  ENDDATE date NULL,
  SAL decimal(7,2) NOT NULL,
  COMM decimal(7,2) NULL,
  VAC int(2) NOT NULL,
  CONSTRAINT emphist_pk PRIMARY KEY (HISTID)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
  
--
-- initiale Daten für Tabelle EMPHISTORY über Prozeduren einfügen
--  
-- --------------------------------------------------------

-- Tabellenstruktur für Tabelle LEAVETIME
-- FOREIGN KEY (EMPID) wird über ALTER TABLE hinzugefügt


DROP TABLE IF EXISTS LEAVETIME;
CREATE TABLE IF NOT EXISTS LEAVETIME(
  LID int (11) NOT NULL AUTO_INCREMENT,
  EMPID int(4) NOT NULL,
  STARTDATE date NOT NULL,
  ENDDATE date NULL,
  REASON char(1) NOT NULL,
  CONSTRAINT leavetime_pk PRIMARY KEY (LID),
  CONSTRAINT reason_ck CHECK (REASON IN ('I','V'))
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;  

-- CHECK-Constraint zeigt Fehler an, wird aber trotzdem akzeptiert
-- wird nicht überprüft --> falsche Eingaben sind möglich--> Trigger stattdessen!	
  

-- --------------------------------------------------------

-- Tabellenstruktur für Tabelle ACCOUNT
-- FOREIGN KEY (MAIL) wird über ALTER TABLE hinzugefügt


DROP TABLE IF EXISTS ACCOUNT;
CREATE TABLE IF NOT EXISTS ACCOUNT(
  ACCID int (11) NOT NULL AUTO_INCREMENT,
  ACCNAME varchar(100) NOT NULL,
  ROLE varchar(50) NOT NULL,
  PASSWORD varchar(20) NOT NULL,
  CREATED date NOT NULL,
  CHANGED date NULL,  
  CONSTRAINT account_pk PRIMARY KEY (ACCID)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;   
  
--
-- initiale Daten für Tabelle ACCOUNT über Prozeduren einfügen
--  



-- -------------------------------------------------------------------------

-- FOREIGN KEYS hinzufügen

-- für EMPLOYEE
-- FOREIGN KEY (ADDRID) mit Referenz auf ADDRESS(ADDRID)
ALTER TABLE EMPLOYEE ADD CONSTRAINT employee_address_fk FOREIGN KEY (ADDRID) REFERENCES ADDRESS(ADDRID);

-- -------------------------------------------------------------------------

-- für EMPHISTORY
-- FOREIGN KEY (EMPID) mit Referenz auf EMPLOYEE(EMPID)
ALTER TABLE EMPHISTORY 
ADD CONSTRAINT emphist_employee_fk1 FOREIGN KEY (EMPID) REFERENCES EMPLOYEE(EMPID);

-- FOREIGN KEY (DEPTID) mit Referenz auf DEPARTMENTS (DEPTID)
ALTER TABLE EMPHISTORY 
ADD CONSTRAINT emphist_departments_fk FOREIGN KEY (DEPTID) REFERENCES DEPARTMENTS(DEPTID);

-- FOREIGN KEY (JOBID) mit Referenz auf JOBS(JOBID)
ALTER TABLE EMPHISTORY 
ADD CONSTRAINT emphist_jobs_fk FOREIGN KEY (JOBID) REFERENCES JOBS(JOBID);

-- FOREIGN KEY (MGRID) mit Referenz auf EMPLOYEE(EMPID)
ALTER TABLE EMPHISTORY 
ADD CONSTRAINT emphist_employee_fk2 FOREIGN KEY (MGRID) REFERENCES EMPLOYEE(EMPID);

-- -------------------------------------------------------------------------







-- für LEAVETIME
-- FOREIGN KEY (EMPID) mit Referenz auf EMPLOYEE(EMPID)
ALTER TABLE LEAVETIME 
ADD CONSTRAINT leavetime_employee_fk FOREIGN KEY (EMPID) REFERENCES EMPLOYEE(EMPID);

-- -------------------------------------------------------------------------

-- für ACCOUNT
-- FOREIGN KEY (MAIL) mit Referenz auf EMPLOYEE(MAIL)
ALTER TABLE ACCOUNT 
ADD CONSTRAINT account_employee_fk FOREIGN KEY (ACCNAME) REFERENCES EMPLOYEE(MAIL);