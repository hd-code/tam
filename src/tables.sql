-- 
-- Datenbank: TAM
-- erstellt am 04.06.2019
-- durch Übungsgruppe DB2
-- Datenbank mit Tabellen für Personalverwaltung
USE master;
DROP DATABASE IF EXISTS TAM;
CREATE DATABASE TAM;
USE TAM;


-- --------------------------------------------------------
-- Tabellenstruktur für Tabelle DEPARTMENTS
-- 

DROP TABLE IF EXISTS DEPARTMENTS;
CREATE TABLE DEPARTMENTS (
    DEPTID  int         PRIMARY KEY,
    DNAME   varchar(30) NOT NULL,
    DCITY   varchar(50) NOT NULL
);

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
CREATE TABLE SALGRADE (
    GRADEID tinyint         PRIMARY KEY     IDENTITY(1,1),
    LOSAL   decimal(7,2)    NOT NULL,
    HISAL   decimal(7,2)
);

-- 
-- Daten für Tabelle SALGRADE
-- 

INSERT INTO SALGRADE (LOSAL, HISAL)VALUES
(1000.00, 1999.99),
(2000.00, 2999.99),
(3000.00, 3999.99),
(4000.00, null);

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle JOBS

DROP TABLE IF EXISTS JOBS;
CREATE TABLE JOBS (
    JOBID   int         PRIMARY KEY   IDENTITY(1,1),
    DESCRIP varchar(30) NOT NULL      UNIQUE,
    GRADEID tinyint     FOREIGN KEY REFERENCES SALGRADE(GRADEID),
);

-- 
-- Daten für Tabelle JOBS
-- 

INSERT INTO JOBS (DESCRIP, GRADEID)VALUES
('CLERK',1),
('SALES REP',1),
('ANALYST',2),
('MANAGER_SALES',2),
('VP Sales',3),
('VP WH',3),
('VP HR',3),
('PRESIDENT',4);

-- --------------------------------------------------------

DROP TABLE IF EXISTS ADDRESS;
CREATE TABLE ADDRESS (
    ADDRID  int         NOT NULL    PRIMARY KEY     IDENTITY(1,1),
    ZIP     char(5)     NOT NULL,
    CITY    varchar(50) NOT NULL,
    STRNO   varchar(50) NOT NULL,
    USSTATE char(2)     NOT NULL,
);

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
CREATE TABLE EMPLOYEE (
    EMPID       int             NOT NULL    PRIMARY KEY,
    FNAME       varchar(30)     NOT NULL,
    LNAME       varchar(50)     NOT NULL,
    MAIL        varchar(100)    NOT NULL    UNIQUE  DEFAULT 'f.lname@tam.com',
    HIREDATE    date            NOT NULL,
    DOB         date            NOT NULL,
    ADDRID      int             NOT NULL    FOREIGN KEY REFERENCES ADDRESS(ADDRID),
);
  

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
CREATE TABLE EMPHISTORY (
    HISTID      int             NOT NULL    PRIMARY KEY     IDENTITY(1,1),
    EMPID       int             NOT NULL    FOREIGN KEY REFERENCES EMPLOYEE(EMPID),
    DEPTID      int             NOT NULL    FOREIGN KEY REFERENCES DEPARTMENTS(DEPTID),
    JOBID       int             NOT NULL    FOREIGN KEY REFERENCES JOBS(JOBID),
    MGRID       int                         FOREIGN KEY REFERENCES EMPLOYEE(EMPID),
    STARTDATE   date            NOT NULL,
    ENDDATE     date,
    SAL         decimal(7,2)    NOT NULL,
    COMM        decimal(7,2),
    VAC         int             NOT NULL,
);


  
--
-- initiale Daten für Tabelle EMPHISTORY über Prozeduren einfügen
--  
-- --------------------------------------------------------

-- Tabellenstruktur für Tabelle LEAVETIME
-- FOREIGN KEY (EMPID) wird über ALTER TABLE hinzugefügt


DROP TABLE IF EXISTS LEAVETIME;
CREATE TABLE LEAVETIME(
    LID       int     PRIMARY KEY   IDENTITY(1,1),
    EMPID     int     NOT NULL      FOREIGN KEY REFERENCES EMPLOYEE(EMPID),
    STARTDATE date    NOT NULL,
    ENDDATE   date,
    REASON    char    NOT NULL      CHECK(REASON IN ('I','V')),
);

-- CHECK-Constraint zeigt Fehler an, wird aber trotzdem akzeptiert
-- wird nicht überprüft --> falsche Eingaben sind möglich--> Trigger stattdessen!	
  

-- --------------------------------------------------------

-- Tabellenstruktur für Tabelle ACCOUNT
-- FOREIGN KEY (MAIL) wird über ALTER TABLE hinzugefügt


DROP TABLE IF EXISTS ACCOUNT;
CREATE TABLE ACCOUNT(
  ACCID     int             PRIMARY KEY IDENTITY(1,1),
  ACCNAME   varchar(100)    NOT NULL    FOREIGN KEY REFERENCES EMPLOYEE(MAIL),
  ROLE      varchar(50)     NOT NULL,
  PASSWORD  varchar(20)     NOT NULL,
  CREATED   date            NOT NULL,
  CHANGED   date,
);