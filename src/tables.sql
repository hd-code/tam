-- 
-- Datenbank: TAM
-- erstellt am 04.06.2019
-- durch Übungsgruppe DB2
-- Datenbank mit Tabellen für Personalverwaltung
USE master;
GO

DROP DATABASE IF EXISTS tam;
CREATE DATABASE tam;
GO

USE tam;
GO

CREATE TABLE account (
  id        int             PRIMARY KEY IDENTITY(1,1),
  name      varchar(100)    NOT NULL,
  role      varchar(50)     NOT NULL,
  password  varchar(20)     NOT NULL,
  createdAt date            NOT NULL,
  updatedAt date,
);

CREATE TABLE address (
    id      int         NOT NULL    PRIMARY KEY     IDENTITY(1,1),
    zip     char(5)     NOT NULL,
    city    varchar(50) NOT NULL,
    strNo   varchar(50) NOT NULL,
    state   char(2)     NOT NULL,
);

CREATE TABLE department (
    id      int         PRIMARY KEY,
    name    varchar(30) NOT NULL,
    city    varchar(50) NOT NULL
);

CREATE TABLE empHistory (
    id          int             NOT NULL    PRIMARY KEY     IDENTITY(1,1),
    employee    int             NOT NULL,
    department  int             NOT NULL,
    job         int             NOT NULL,
    mgr         int,
    startdate   date            NOT NULL,
    enddate     date,
    sal         decimal(7,2)    NOT NULL,
    comm        decimal(7,2),
    vacation    int             NOT NULL,
);

CREATE TABLE employee (
    id          int             NOT NULL    PRIMARY KEY,
    fname       varchar(30)     NOT NULL,
    lname       varchar(50)     NOT NULL,
    email       varchar(100)    NOT NULL    UNIQUE  DEFAULT 'f.lname@tam.com',
    hiredate    date            NOT NULL,
    dob         date            NOT NULL,
    address     int             NOT NULL,
);

CREATE TABLE job (
    id          int         PRIMARY KEY   IDENTITY(1,1),
    descrip     varchar(30) NOT NULL      UNIQUE,
    salgrade    tinyint,
);

CREATE TABLE leavetime (
    id          int     PRIMARY KEY   IDENTITY(1,1),
    employee    int     NOT NULL,
    startdate   date    NOT NULL,
    enddate     date,
    reason      char    NOT NULL      CHECK(reason IN ('I','V')),
);

CREATE TABLE salgrade (
    id      tinyint         PRIMARY KEY     IDENTITY(1,1),
    losal   decimal(7,2)    NOT NULL,
    hisal   decimal(7,2)
);

GO

ALTER TABLE account     ADD FOREIGN KEY (name)       REFERENCES employee(email);

ALTER TABLE empHistory  ADD FOREIGN KEY (employee)   REFERENCES employee(id);
ALTER TABLE empHistory  ADD FOREIGN KEY (department) REFERENCES department(id);
ALTER TABLE empHistory  ADD FOREIGN KEY (job)        REFERENCES job(id);
ALTER TABLE empHistory  ADD FOREIGN KEY (mgr)        REFERENCES employee(id);

ALTER TABLE employee    ADD FOREIGN KEY (address)    REFERENCES address(id);

ALTER TABLE job         ADD FOREIGN KEY (salgrade)   REFERENCES salgrade(id);

ALTER TABLE leavetime   ADD FOREIGN KEY (employee)   REFERENCES employee(id);

GO



--  
-- Daten für Tabelle DEPARTMENTS
INSERT INTO department (id, name, city) VALUES
(10, 'HEADQUARTER', 'NEW YORK'),
(20, 'SALES', 'NEW YORK'),
(30, 'WAREHOUSING', 'NEW YORK'),
(40, 'ANALYTICS', 'NEW YORK');

-- --------------------------------------------------------

-- 
-- Tabellenstruktur für Tabelle SALGRADE
-- 


INSERT INTO salgrade (losal, hisal) VALUES
(1000.00, 1999.99),
(2000.00, 2999.99),
(3000.00, 3999.99),
(4000.00, NULL);




-- 
-- Daten für Tabelle JOBS
-- 

INSERT INTO JOB (descrip, salgrade) VALUES
('CLERK',1),
('SALES REP',1),
('ANALYST',2),
('MANAGER_SALES',2),
('VP Sales',3),
('VP WH',3),
('VP HR',3),
('PRESIDENT',4);

-- --------------------------------------------------------










