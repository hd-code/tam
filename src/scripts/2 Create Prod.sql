/*
 * Datenbank: TAM
 * erstellt am:   04.06.2019
 * bearbeitet am: 06.06.2019
 * von: Hannes Dröse
 * Datenbank-Tabellen rund um die Products
 */


-- Hinweis: Ein Foreign Key kann nur dann hinzugefügt werden, wenn die
-- referenzierte Tabelle bereits existiert!
-- Daher gibt es 2 Möglichkeiten:
--   1. zunächste alle Tabelle erstellen ohne FK, mit den Daten füllen und FK
--      ganz zum Schluss hinzufügen
--   2. genau auf die Reihenfolge der Tabellen und Daten achten! Zuerst alle
--      Tabellen ohne FK und dann die Tabellen mit FK



-- löscht die gesamte DB, Reset auf Status quo
-- DROP DATABASE TAM;  

-- DB anlegen, falls nicht existent
CREATE DATABASE IF NOT EXISTS TAM DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE TAM;



-- ----------------- TABLE PRODGROUP -------------------------------------------
DROP   TABLE IF     EXISTS PRODGROUP;
CREATE TABLE IF NOT EXISTS PRODGROUP (
    PGID        int(1)      NOT NULL   AUTO_INCREMENT   -- PK
,   DESCRIP     varchar(20) NOT NULL                -- aktuelle Werte und Regln siehe PH
,   TAX         int(2)      NOT NULL                -- aktuelle Werte und Regln siehe PH
    -- Keys:
,   PRIMARY KEY (PGID)
);

INSERT INTO PRODGROUP (DESCRIP,TAX) VALUES
('FOOD',     7),
('NONFOOD', 14);



-- ----------------- TABLE PRODCAT ---------------------------------------------
DROP   TABLE IF     EXISTS PRODCAT;
CREATE TABLE IF NOT EXISTS PRODCAT (
    CATID       int(2)      NOT NULL    AUTO_INCREMENT  -- PK
,   PGID        int(1)      NOT NULL                    -- FK mit Referenz auf PRODGROUP(PGID)
,   DESCRIP     varchar(30) NOT NULL
,   CREATED     timestamp   NOT NULL    DEFAULT CURRENT_TIMESTAMP   -- default now
    -- Keys:
,   PRIMARY KEY (CATID)
-- ,   FOREIGN KEY (PGID)  REFERENCES PRODGROUP (PGID)
);

INSERT INTO PRODCAT (PGID,DESCRIP) VALUES
(1, 'Snacks'      ),
(1, 'Energydrinks'),
(2, 'Balls'       ),
(2, 'Nets'        ),
(2, 'Rackets'     ),
(2, 'Clothes'     ),
(2, 'Books'       );



-- ----------------- TABLE VENDOR ----------------------------------------------
DROP   TABLE IF     EXISTS VENDOR;
CREATE TABLE IF NOT EXISTS VENDOR (
    VENDORID    int(3)          NOT NULL     --    PK  
,   VNAME       varchar(30)     NOT NULL        
,   VPHONE      varchar(20)     NOT NULL        
,   VMAIL       varchar(100)    NOT NULL        
,   VCITY       varchar(50)     NOT NULL        
,   CREATED     timestamp       NOT NULL    DEFAULT CURRENT_TIMESTAMP -- default now
    -- Keys:
,   PRIMARY KEY (VENDORID)
);



-- ----------------- TABLE PRODUCT ---------------------------------------------
DROP   TABLE IF     EXISTS PRODUCT;
CREATE TABLE IF NOT EXISTS PRODUCT (
    PRODID      int(6)          NOT NULL   -- PK
,   CATID       int(2)          NOT NULL   -- FK mit Referenz auf PRODCAT(CATID)
,   VENDORID    int(3)          NOT NULL   -- FK mit REFERENZ auf VENDOR(VENDORID)
,   DESCRIP     varchar(50)     NOT NULL        
,   STDPRICE    decimal(6,2)    NOT NULL        
,   NVALUE      int(4)              NULL   --   Nährwert in kJ, nur für FOOD-Produkte  
,   FLAG        varchar(2)      NOT NULL    CHECK (FLAG IN ('F','NF')) -- check   erlaubte Werte: F (FOOD) und NF(NONFOOD)
,   CREATED     timestamp       NOT NULL    DEFAULT CURRENT_TIMESTAMP  --   default now
    -- Keys:
,   PRIMARY KEY (PRODID)
-- ,   FOREIGN KEY (CATID)    REFERENCES PRODCAT (CATID)
-- ,   FOREIGN KEY (VENDORID) REFERENCES VENDOR  (VENDORID)
);



-- ----------------- TABLE WAREHOUSE -------------------------------------------
DROP   TABLE IF     EXISTS WAREHOUSE;
CREATE TABLE IF NOT EXISTS WAREHOUSE (
    WID         int(2)  NOT NULL  --  PK  
,   PRODID      int(6)  NOT NULL  --  FK mit Referenz auf PRODUCT(PRODID)    
,   ACTSTOCK    int(5)  NOT NULL      
,   BBD         date        NULL  --   Verbrauchsdatum, nur für FOOD-Produkte
    -- Keys:
,   PRIMARY KEY (WID)
-- ,   FOREIGN KEY (PRODID) REFERENCES PRODUCT (PRODID)
);



-- ----------------- TABLE RANKING ---------------------------------------------
DROP   TABLE IF     EXISTS RANKING;
CREATE TABLE IF NOT EXISTS RANKING (
    RID     int     NOT NULL    AUTO_INCREMENT   -- PK  Autoincrement
,   PRODID  int(6)  NOT NULL                     --  FK mit Referenz auf PRODUCT(PRODID)  
,   RYEAR   int(4)  NOT NULL                     --     vierstellige Jahreszahl
,   RMONTH  int(2)  NOT NULL    CHECK( RMONTH BETWEEN 1 AND 12 )     -- check   erlaubte Werte: 1..12
,   PRANK   int(3)  NOT NULL        
    -- Keys:
,   PRIMARY KEY (RID)
-- ,   FOREIGN KEY (PRODID) REFERENCES PRODUCT (PRODID)
);



-- ----------------- TABLE ALLERGENS -------------------------------------------
DROP   TABLE IF     EXISTS ALLERGENS;
CREATE TABLE IF NOT EXISTS ALLERGENS (
    AID         int         NOT NULL    AUTO_INCREMENT  --  PK  Autoincrement
,   DESCRIP     varchar(30) NOT NULL                    --      Liste siehe PH
,   SHORTCUT    varchar(5)  NOT NULL                    --      Kodierung siehe PH
    -- Keys:
,   PRIMARY KEY (AID)
);

INSERT INTO ALLERGENS (DESCRIP,SHORTCUT) VALUES
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



-- ----------------- TABLE PRODUCTALLERGENS ------------------------------------
DROP   TABLE IF     EXISTS PRODUCTALLERGENS;
CREATE TABLE IF NOT EXISTS PRODUCTALLERGENS (
    AID     int     NOT NULL   -- PK, FK mit Referenz auf ALLERGENS(AID)
,   PRODID  int(6)  NOT NULL   -- PK, FK mit Referenz auf PRODUCTS (PRODID)
    -- Keys:
,   PRIMARY KEY (AID,PRODID)
-- ,   FOREIGN KEY (AID)       REFERENCES  ALLERGENS (AID)
-- ,   FOREIGN KEY (PRODID)    REFERENCES  PRODUCT   (PRODID)
);



-- ----------------- TABLE PURCHASE --------------------------------------------
DROP   TABLE IF     EXISTS PURCHASE;
CREATE TABLE IF NOT EXISTS PURCHASE (
    PID     int     NOT NULL    AUTO_INCREMENT   -- PK  Autoincrement
,   PDATE   date    NOT NULL                     --     Bestelldatum
,   INGOING date        NULL                     --   Wareneingangsdatum
    -- Keys:
,   PRIMARY KEY (PID)
);



-- ----------------- TABLE PURCHITEMS ------------------------------------------
DROP   TABLE IF     EXISTS PURCHITEMS;
CREATE TABLE IF NOT EXISTS PURCHITEMS (
    PID     int             NOT NULL   -- PK,  FK mit Referenz auf PURCHASE (PID)
,   PRODID  int(6)          NOT NULL   -- PK,  FK mit Referenz auf PRODUCTS (PRODID)
,   ITEMID  int(3)          NOT NULL   --     Bestellposition
,   QTY     int(5)          NOT NULL        
,   PRICE   decimal(6,2)    NOT NULL   --     Einkaufspreis
    -- Keys:
,   PRIMARY KEY (PID,PRODID)
-- ,   FOREIGN KEY (PID)       REFERENCES  PURCHASE (PID)
-- ,   FOREIGN KEY (PRODID)    REFERENCES  PRODUCT  (PRODID)
);







-- ------------------- FOREIGN KEYS --------------------------------------------
ALTER TABLE PRODCAT     ADD FOREIGN KEY (PGID)      REFERENCES PRODGROUP (PGID);
ALTER TABLE PRODUCT     ADD FOREIGN KEY (CATID)     REFERENCES PRODCAT  (CATID)
                    ,   ADD FOREIGN KEY (VENDORID)  REFERENCES VENDOR(VENDORID);
ALTER TABLE WAREHOUSE   ADD FOREIGN KEY (PRODID)    REFERENCES PRODUCT (PRODID);
ALTER TABLE RANKING     ADD FOREIGN KEY (PRODID)    REFERENCES PRODUCT (PRODID);
ALTER TABLE PRODUCTALLERGENS ADD FOREIGN KEY (AID)   REFERENCES ALLERGENS(AID)
                         ,   ADD FOREIGN KEY(PRODID) REFERENCES PRODUCT(PRODID);
ALTER TABLE PURCHITEMS  ADD FOREIGN KEY (PID)       REFERENCES PURCHASE   (PID)
                    ,   ADD FOREIGN KEY(PRODID)     REFERENCES PRODUCT (PRODID);
-- */