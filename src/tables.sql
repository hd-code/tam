USE master;

GO -----------------------------------------------------------------------------

DROP DATABASE IF EXISTS tam;
CREATE DATABASE tam;

GO -----------------------------------------------------------------------------

USE tam;

GO -----------------------------------------------------------------------------

CREATE TABLE account (
    id        int             PRIMARY KEY   IDENTITY(1,1)
,   name      varchar(100)    NOT NULL      -- FOREIGN KEY REFERENCES employee(email)
,   role      varchar(50)     NOT NULL
,   password  varchar(20)     NOT NULL
,   createdAt date            NOT NULL
,   updatedAt date
);

CREATE TABLE address (
    id      int         NOT NULL    PRIMARY KEY     IDENTITY(1,1)
,   zip     char(5)     NOT NULL
,   city    varchar(50) NOT NULL
,   strNo   varchar(50) NOT NULL
,   state   char(2)     NOT NULL    -- CHECK(state IN ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'))
);
--> states auslagern in separate Tabelle ???

CREATE TABLE allergen (
    id      int         NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   descrip varchar(30) NOT NULL
,   abbr    varchar(5)  NOT NULL
);

CREATE TABLE contact (
    id      int             NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   name    varchar(50)     NOT NULL
,   phone   varchar(20)     NOT NULL
,   mail    varchar(100)    NOT NULL
);

CREATE TABLE customer (
    id              int             NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   name            varchar(50)     NOT NULL
,   creditlimit     decimal(6,2)    NOT NULL    DEFAULT 500
,   rating          int             NOT NULL    DEFAULT 3   -- FOREIGN KEY REFERENCES rating(id)
,   yearlyDiscount  int             NOT NULL    DEFAULT 0   CHECK(yearlyDiscount <= 100)
,   contact         int             NOT NULL                -- FOREIGN KEY REFERENCES contact(id)
,   billAddress     int             NOT NULL                -- FOREIGN KEY REFERENCES address(id)
,   shipAddress     int                                     -- FOREIGN KEY REFERENCES address(id)
);

-- > yearly discount!
-- Kunden mit einem Jahresumsatz ab 20.000 $ (immer gerechnet vom
-- 1.1. -31.12. eines Jahres) erhalten für das gesamte Folgejahr einen
-- Zusatzrabatt von 1%, oder 2% ab einem Jahresumsatz von 50.000$.

CREATE TABLE department (
    id      int         PRIMARY KEY
,   name    varchar(30) NOT NULL
,   city    varchar(50) NOT NULL
);

CREATE TABLE empHistory (
    id          int             NOT NULL    PRIMARY KEY     IDENTITY(1,1)
,   employee    int             NOT NULL    -- FOREIGN KEY REFERENCES employee(id)
,   department  int             NOT NULL    -- FOREIGN KEY REFERENCES departments(id)
,   job         int             NOT NULL    -- FOREIGN KEY REFERENCES job(id)
,   mgr         int                         -- FOREIGN KEY REFERENCES employee(id)
,   startdate   date            NOT NULL
,   enddate     date
,   sal         decimal(7,2)    NOT NULL
,   comm        decimal(7,2)
,   vacation    int             NOT NULL
);

CREATE TABLE employee (
    id          int             NOT NULL    PRIMARY KEY
,   fname       varchar(30)     NOT NULL
,   lname       varchar(50)     NOT NULL
,   email       varchar(100)    NOT NULL    UNIQUE  DEFAULT 'f.lname@tam.com'
,   hiredate    date            NOT NULL
,   dob         date            NOT NULL
,   address     int             NOT NULL    -- FOREIGN KEY REFERENCES address(id)
);

CREATE TABLE job (
    id          int         PRIMARY KEY   IDENTITY(1,1)
,   descrip     varchar(30) NOT NULL      UNIQUE
,   salgrade    tinyint
);

CREATE TABLE leavetime (
    id          int     PRIMARY KEY     IDENTITY(1,1)
,   employee    int     NOT NULL        -- FOREIGN KEY REFERENCES employee(id)
,   startdate   date    NOT NULL
,   enddate     date
,   reason      char    NOT NULL        CHECK(reason IN ('I','V'))
);

-- TODO: PH checken nach Attributen --------------------------------------------
CREATE TABLE "order" (
    id      int         NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   date    datetime    NOT NULL    DEFAULT CURRENT_TIMESTAMP
,   billAddress int     NOT NULL    -- FOREIGN KEY REFERENCES address(id)
,   shipAddress int                 -- FOREIGN KEY REFERENCES address(id)
);
--------------------------------------------------------------------------------

CREATE TABLE orderItems (
    "order"     int             NOT NULL    -- FOREIGN KEY REFERENCES "order"(id)
,   product     int             NOT NULL    -- FOREIGN KEY REFERENCES product(id)
,   itemNo      int             NOT NULL    -- Bestellposition
,   qty         int             NOT NULL        
,   actPrice    decimal(6,2)    NOT NULL    -- tatsächliche genommener Preis
--,   discount  TODO: Check PH

,   PRIMARY KEY ("order",product)
);

CREATE TABLE payment (
    id      int NOT NULL    PRIMARY KEY IDENTITY(1,1)
);

CREATE TABLE prodCat (
    id          int         NOT NULL    PRIMARY KEY     IDENTITY(1,1)
,   prodGroup   int         NOT NULL    -- FOREIGN KEY REFERENCES prodGroup(id)
,   descrip     varchar(30) NOT NULL
,   createdAt   datetime    NOT NULL    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prodGroup (
    id      int         NOT NULL    PRIMARY KEY     IDENTITY(1,1)
,   descrip varchar(20) NOT NULL
,   tax     int         NOT NULL
);

CREATE TABLE product (
    id          int             NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   prodCat     int             NOT NULL    -- FOREIGN KEY REFERENCES prodCat(id)
,   vendor      int             NOT NULL    -- FOREIGN KEY REFERENCES vendor(id)
,   descrip     varchar(50)     NOT NULL        
,   stdPrice    decimal(6,2)    NOT NULL        
,   nValue      int             --   Nährwert in kJ, nur für FOOD-Produkte  
--,   type        varchar(2)      NOT NULL    CHECK (type IN ('F','NF')) 
                                            -- F: FOOD, NF: NONFOOD
--> Redundant!! Kann über prodCat in prodGroup ermittelt werden!!!!! 
,   createdAt   datetime        NOT NULL    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productAllergen (
    allergen    int NOT NULL    -- FOREIGN KEY REFERENCES allergen(id)
,   product     int NOT NULL    -- FOREIGN KEY REFERENCES product(id)

,   PRIMARY KEY (allergen,product)
);

CREATE TABLE purchase (
    id      int     NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   date    date    NOT NULL    -- Bestelldatum
,   ingoing date                -- Wareneingangsdatum
);

CREATE TABLE purchItems (
    purchase    int             NOT NULL    -- FOREIGN KEY REFERENCES purchase(id)
,   product     int             NOT NULL    -- FOREIGN KEY REFERENCES product(id)
,   itemNo      int             NOT NULL    -- Bestellposition
,   qty         int             NOT NULL        
,   price       decimal(6,2)    NOT NULL    -- Einkaufspreis

,   PRIMARY KEY (purchase,product)
);

CREATE TABLE ranking (
    id      int NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   product int NOT NULL    -- FOREIGN KEY REFERENCES product(id) 
,   year    int NOT NULL    CHECK( year BETWEEN 1000 AND 9999)  -- vierstellige Jahreszahl
,   month   int NOT NULL    CHECK( month BETWEEN 1 AND 12 )     -- 1..12
,   rank    int NOT NULL
);

CREATE TABLE rating (
    id      int         NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   descrip varchar(10) NOT NULL
);

CREATE TABLE salgrade (
    id      tinyint         PRIMARY KEY     IDENTITY(1,1)
,   losal   decimal(7,2)    NOT NULL
,   hisal   decimal(7,2)
);

CREATE TABLE shipping (
    id      int     NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   date    date
,
);

CREATE TABLE vendor (
    id          int             NOT NULL    PRIMARY KEY     IDENTITY(1,1)
,   name        varchar(50)     NOT NULL
,   contact     int             NOT NULL    -- FOREIGN KEY REFERENCES contact(id)       
,   city        varchar(50)     NOT NULL        
,   createdAt   datetime        NOT NULL    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouse (
    id          int     NOT NULL    PRIMARY KEY IDENTITY(1,1)
,   product     int     NOT NULL    -- FOREIGN KEY REFERENCES product(id)    
,   stock       int     NOT NULL      
,   bestBefore  date    --   Verbrauchsdatum, nur für FOOD-Produkte
);
--> minStock ???

GO -----------------------------------------------------------------------------

ALTER TABLE account         ADD FOREIGN KEY (name)        REFERENCES employee(email);

ALTER TABLE customer        ADD FOREIGN KEY (rating)      REFERENCES rating(id);
ALTER TABLE customer        ADD FOREIGN KEY (contact)     REFERENCES contact(id);
ALTER TABLE customer        ADD FOREIGN KEY (billAddress) REFERENCES address(id);
ALTER TABLE customer        ADD FOREIGN KEY (shipAddress) REFERENCES address(id);

ALTER TABLE empHistory      ADD FOREIGN KEY (employee)    REFERENCES employee(id);
ALTER TABLE empHistory      ADD FOREIGN KEY (department)  REFERENCES department(id);
ALTER TABLE empHistory      ADD FOREIGN KEY (job)         REFERENCES job(id);
ALTER TABLE empHistory      ADD FOREIGN KEY (mgr)         REFERENCES employee(id);

ALTER TABLE employee        ADD FOREIGN KEY (address)     REFERENCES address(id);

ALTER TABLE job             ADD FOREIGN KEY (salgrade)    REFERENCES salgrade(id);

ALTER TABLE leavetime       ADD FOREIGN KEY (employee)    REFERENCES employee(id);

ALTER TABLE "order"         ADD FOREIGN KEY (billAddress) REFERENCES address(id);
ALTER TABLE "order"         ADD FOREIGN KEY (shipAddress) REFERENCES address(id);

ALTER TABLE orderItems      ADD FOREIGN KEY ("order")     REFERENCES "order"(id);
ALTER TABLE orderItems      ADD FOREIGN KEY (product)     REFERENCES product(id);

ALTER TABLE prodCat         ADD FOREIGN KEY (prodGroup)   REFERENCES prodGroup(id);

ALTER TABLE product         ADD FOREIGN KEY (prodCat)     REFERENCES prodCat(id);
ALTER TABLE product         ADD FOREIGN KEY (vendor)      REFERENCES vendor(id);

ALTER TABLE productAllergen ADD FOREIGN KEY (allergen)    REFERENCES allergen(id);
ALTER TABLE productAllergen ADD FOREIGN KEY (product)     REFERENCES product(id);

ALTER TABLE purchItems      ADD FOREIGN KEY (purchase)    REFERENCES purchase(id);
ALTER TABLE purchItems      ADD FOREIGN KEY (product)     REFERENCES product(id);

ALTER TABLE ranking         ADD FOREIGN KEY (product)     REFERENCES product(id);

ALTER TABLE vendor          ADD FOREIGN KEY (contact)     REFERENCES contact(id);

ALTER TABLE warehouse       ADD FOREIGN KEY (product)     REFERENCES product(id);

GO -----------------------------------------------------------------------------







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

INSERT INTO job (descrip, salgrade) VALUES
('CLERK',1),
('SALES REP',1),
('ANALYST',2),
('MANAGER_SALES',2),
('VP Sales',3),
('VP WH',3),
('VP HR',3),
('PRESIDENT',4);

INSERT INTO prodGroup (descrip,tax) VALUES
('FOOD',     7),
('NONFOOD', 14);

INSERT INTO prodCat (prodGroup, descrip) VALUES
(1, 'Snacks'      ),
(1, 'Energydrinks'),
(2, 'Balls'       ),
(2, 'Nets'        ),
(2, 'Rackets'     ),
(2, 'Clothes'     ),
(2, 'Books'       );

INSERT INTO allergen (descrip,abbr) VALUES
('Cereals containing gluten',   'glut'),
('Crustaceans',                 'crust'),
('Eggs',                        'eggs'),
('Fish',                        'fish'),
('Peanuts',                     'pean'),
('Soybeans',                    'soy'),
('Milk',                        'milk'),
('Nuts',                        'nuts'),
('Celery',                      'cel'),
('Mustard',                     'must'),
('Sesame seeds',                'sesam'),
('Sulphur dioxide and sulphites','sulph'),
('Lupin',                       'lupin'),
('Molluscs',                    'moll');


INSERT INTO rating VALUES ('excellent'),('good'),('poor');

-- */



/*

Customer Rating: DEFAULT poor

Zahlung pünktlich -> excellent
vor der ersten Mahnung -> good
danach -> poor




Kreditlimit (25% des Vorjahresumsatzes, mindestens 500$, gültig für
ein Jahr) mit Höhe und Gültigkeitszeitraum, Standardwert 500$ wird
auch für Neukunden gesetzt
o Kunden mit einem Jahresumsatz ab 20.000 $ (immer gerechnet vom
1.1. -31.12. eines Jahres) erhalten für das gesamte Folgejahr einen
Zusatzrabatt von 1%, oder 2% ab einem Jahresumsatz von 50.000$.

Bildungsvorschrift für die Bestellnummer: Bestelldatum-fortlaufende
Nummer für die Bestellungen des Kunden im laufenden Jahr-
Kundennummer  JJJJMMTT-XXX-Kundennummer

Für Bestellungen gilt folgende Staffelung beim Mengenrabatt: ab
1001%, ab 5002%, ab 10005%

Zahlweise: erlaubte Werte Rechnung, Vorkasse,
o abhängig vom aktuellen Kundenrating  poor (Vorkasse), good/excellent (Rechnung) und
o vom KreditlimitRechnungssumme > Kreditlimit (Vorkasse), ansonsten Rechnung, wenn Rating es erlaubt. Rating wiegt schwerer als Kreditlimit.

Sonderrabatte können nur die Kundenbetreuer (bzw. deren Vertreter) gewähren, falls sich durch Lieferengpässe der Versand der Bestellung verzögert (1% Rabatt möglich)

Datum des Zahlungseingangs sowie Zahl- bzw. Mahnstatus wird vom Kundenbetreuer (bzw. dessen Vertreter) später ergänzt, sobald die Information vom externen Dienstleister eingegangen ist.

Für Zahl- bzw. Mahnstatus sollen folgende Informationen kodiert werden: 1-open (direkt nach Versand), 2-paid on time (Zahlungseingang vor Erreichen des Zahlungsziels), 3-delayed (Zahlungseingang nach Zahlungsziel), 4-reminded (Zahlungseingang erst nach Mahnung)

Zahlungsziel beträgt 14 Tage ab Versanddatum

*/