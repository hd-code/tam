-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 02. Jun 2019 um 08:49
-- Server-Version: 10.1.37-MariaDB
-- PHP-Version: 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `sw`
--
CREATE DATABASE IF NOT EXISTS `sw` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `sw`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `CUSTID` int(11) NOT NULL,
  `NAME` varchar(45) NOT NULL,
  `ADDRESS` varchar(40) DEFAULT NULL,
  `CITY` varchar(30) NOT NULL,
  `STATE` varchar(2) DEFAULT NULL,
  `ZIP` varchar(9) NOT NULL,
  `AREA` int(11) DEFAULT NULL,
  `PHONE` varchar(9) DEFAULT NULL,
  `REPID` int(11) NOT NULL,
  `CREDITLIMIT` decimal(9,2) DEFAULT NULL,
  `COMMENTS` text,
  PRIMARY KEY (`CUSTID`),
  KEY `CUSTOMER_REPID_FK` (`REPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `customer`:
--   `REPID`
--       `employee` -> `EMPNO`
--

--
-- Daten für Tabelle `customer`
--

INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(100, 'JOCKSPORTS', '345 VIEWRIDGE', 'BELMONT', 'CA', '96711', 415, '598-6609', 7844, '5000.00', 'Very friendly people to work with -- sales rep likes to be called Mike.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(101, 'TKB SPORT SHOP', '490 BOLI RD.', 'REDWOOD CITY', 'CA', '94061', 415, '368-1223', 7521, '10000.00', 'Rep called 5/8 about change in order - contact shipping.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(102, 'VOLLYRITE', '9722 HAMILTON', 'BURLINGAME', 'CA', '95133', 415, '644-3341', 7654, '7000.00', 'Company doing heavy promotion beginning 10/89. Prepare for large orders during winter.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(103, 'JUST TENNIS', 'HILLVIEW MALL', 'BURLINGAME', 'CA', '97544', 415, '677-9312', 7521, '3000.00', 'Contact rep about new line of tennis rackets.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(104, 'EVERY MOUNTAIN', '574 SURRY RD.', 'CUPERTINO', 'CA', '93301', 408, '996-2323', 7499, '10000.00', 'Customer with high market share (23%) due to aggressive advertising.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(105, 'K + T SPORTS', '3476 EL PASEO', 'SANTA CLARA', 'CA', '91003', 408, '376-9966', 7844, '5000.00', 'Tends to order large amounts of merchandise at once. Accounting is considering raising their credit limit. Usually pays on time.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(106, 'SHAPE UP', '908 SEQUOIA', 'PALO ALTO', 'CA', '94301', 415, '364-9777', 7521, '6000.00', 'Support intensive. Orders small amounts (< 800) of merchandise at a time.');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(107, 'WOMENS SPORTS', 'VALCO VILLAGE', 'SUNNYVALE', 'CA', '93301', 408, '967-4398', 7499, '10000.00', 'First sporting goods store geared exclusively towards women. Unusual promotion al style and very willing to take chances towards new products!');
INSERT INTO `customer` (`CUSTID`, `NAME`, `ADDRESS`, `CITY`, `STATE`, `ZIP`, `AREA`, `PHONE`, `REPID`, `CREDITLIMIT`, `COMMENTS`) VALUES(108, 'NORTH WOODS HEALTH AND FITNESS SUPPLY CENTER', '98 LONE PINE WAY', 'HIBBING', 'MN', '55649', 612, '566-9123', 7844, '8000.00', NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `departments`
--

DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments` (
  `DEPTNO` int(11) NOT NULL,
  `DNAME` varchar(20) DEFAULT NULL,
  `LOC` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`DEPTNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `departments`:
--

--
-- Daten für Tabelle `departments`
--

INSERT INTO `departments` (`DEPTNO`, `DNAME`, `LOC`) VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO `departments` (`DEPTNO`, `DNAME`, `LOC`) VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO `departments` (`DEPTNO`, `DNAME`, `LOC`) VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO `departments` (`DEPTNO`, `DNAME`, `LOC`) VALUES(40, 'OPERATIONS', 'BOSTON');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `EMPNO` int(11) NOT NULL,
  `ENAME` varchar(10) DEFAULT NULL,
  `JOB` varchar(9) DEFAULT NULL,
  `MGR` int(11) DEFAULT NULL,
  `HIREDATE` date DEFAULT NULL,
  `SAL` decimal(7,2) DEFAULT NULL,
  `COMM` decimal(7,2) DEFAULT NULL,
  `DEPTNO` int(11) NOT NULL,
  PRIMARY KEY (`EMPNO`),
  KEY `EMP_DEPTNO_FK` (`DEPTNO`),
  KEY `EMP_MGR_FK` (`MGR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `employee`:
--   `DEPTNO`
--       `departments` -> `DEPTNO`
--   `MGR`
--       `employee` -> `EMPNO`
--

--
-- Daten für Tabelle `employee`
--

INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7369, 'SMITH', 'CLERK', 7902, '1981-01-01', '800.00', NULL, 20);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7499, 'ALLEN', 'SALESMAN', 7698, '1980-01-01', '1600.00', '300.00', 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7521, 'WARD', 'SALESMAN', 7698, '1980-02-01', '1250.00', '500.00', 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7566, 'JONES', 'MANAGER', 7839, '1981-01-01', '2975.00', NULL, 20);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7654, 'MARTIN', 'SALESMAN', 7698, '1980-01-02', '1250.00', '1400.00', 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7698, 'BLAKE', 'MANAGER', 7839, '1980-06-01', '2850.00', NULL, 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7782, 'CLARK', 'MANAGER', 7839, '1980-01-01', '2450.00', NULL, 10);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7788, 'SCOTT', 'ANALYST', 7566, '1981-06-01', '3000.00', NULL, 20);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7839, 'KING', 'PRESIDENT', NULL, '1980-01-01', '5000.00', NULL, 10);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7844, 'TURNER', 'SALESMAN', 7698, '1980-01-01', '1500.00', '0.00', 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7876, 'ADAMS', 'CLERK', 7788, '1981-01-01', '1100.00', NULL, 20);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7900, 'JAMES', 'CLERK', 7698, '1981-06-01', '950.00', NULL, 30);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7902, 'FORD', 'ANALYST', 7566, '1981-12-01', '3000.00', NULL, 20);
INSERT INTO `employee` (`EMPNO`, `ENAME`, `JOB`, `MGR`, `HIREDATE`, `SAL`, `COMM`, `DEPTNO`) VALUES(7934, 'MILLER', 'CLERK', 7782, '1980-01-01', '1300.00', NULL, 10);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `orderitems`
--

DROP TABLE IF EXISTS `orderitems`;
CREATE TABLE IF NOT EXISTS `orderitems` (
  `ORDID` int(11) NOT NULL,
  `ITEMID` int(11) NOT NULL,
  `PRODID` int(11) NOT NULL,
  `ACTUALPRICE` decimal(8,2) NOT NULL,
  `QTY` int(11) NOT NULL,
  `ITEMTOT` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`ORDID`,`ITEMID`),
  KEY `ITEM_PRODID_FK` (`PRODID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `orderitems`:
--   `ORDID`
--       `orders` -> `ORDID`
--   `PRODID`
--       `products` -> `PRODID`
--

--
-- Daten für Tabelle `orderitems`
--

INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(601, 1, 200376, '2.40', 1, '2.40');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(602, 1, 100870, '2.80', 20, '56.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(603, 2, 100860, '56.00', 4, '224.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(604, 1, 100890, '58.00', 3, '174.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(604, 2, 100861, '42.00', 2, '84.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(604, 3, 100860, '44.00', 10, '440.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 1, 100861, '45.00', 100, '4500.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 2, 100870, '2.80', 500, '1400.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 3, 100890, '58.00', 5, '290.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 4, 101860, '24.00', 50, '1200.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 5, 101863, '9.00', 100, '900.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(605, 6, 102130, '3.40', 10, '34.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(606, 1, 102130, '3.40', 1, '3.40');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(607, 1, 100871, '5.60', 1, '5.60');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(608, 1, 101860, '24.00', 1, '24.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(608, 2, 100871, '5.60', 2, '11.20');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(609, 1, 100861, '35.00', 1, '35.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(609, 2, 100870, '2.50', 5, '12.50');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(609, 3, 100890, '50.00', 1, '50.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(610, 1, 100860, '35.00', 1, '35.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(610, 2, 100870, '2.80', 3, '8.40');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(610, 3, 100890, '58.00', 1, '58.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(611, 1, 100861, '45.00', 1, '45.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(612, 1, 100860, '30.00', 100, '3000.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(612, 2, 100861, '40.50', 20, '810.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(612, 3, 101863, '10.00', 150, '1500.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(612, 4, 100871, '5.50', 100, '550.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(613, 1, 100871, '5.60', 100, '560.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(613, 2, 101860, '24.00', 200, '4800.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(613, 3, 200380, '4.00', 150, '600.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(613, 4, 200376, '2.20', 200, '440.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(614, 1, 100860, '35.00', 444, '15540.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(614, 2, 100870, '2.80', 1000, '2800.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(614, 3, 100871, '5.60', 1000, '5600.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(615, 1, 100861, '45.00', 4, '180.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(615, 2, 100870, '2.80', 100, '280.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(615, 3, 100871, '5.00', 50, '250.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(616, 1, 100861, '45.00', 10, '450.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(616, 2, 100870, '2.80', 50, '140.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(616, 3, 100890, '58.00', 2, '116.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(616, 4, 102130, '3.40', 10, '34.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(616, 5, 200376, '2.40', 10, '24.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 1, 100860, '35.00', 50, '1750.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 2, 100861, '45.00', 100, '4500.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 3, 100870, '2.80', 500, '1400.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 4, 100871, '5.60', 500, '2800.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 5, 100890, '58.00', 500, '29000.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 6, 101860, '24.00', 100, '2400.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 7, 101863, '12.50', 200, '2500.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 8, 102130, '3.40', 100, '340.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 9, 200376, '2.40', 200, '480.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(617, 10, 200380, '4.00', 300, '1200.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(618, 1, 100860, '35.00', 23, '805.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(618, 2, 100861, '45.11', 50, '2255.50');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(618, 3, 100870, '45.00', 10, '450.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(619, 1, 200380, '4.00', 100, '400.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(619, 2, 200376, '2.40', 100, '240.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(619, 3, 102130, '3.40', 100, '340.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(619, 4, 100871, '5.60', 50, '280.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(620, 1, 100860, '35.00', 10, '350.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(620, 2, 200376, '2.40', 1000, '2400.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(620, 3, 102130, '3.40', 500, '1700.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(621, 1, 100861, '45.00', 10, '450.00');
INSERT INTO `orderitems` (`ORDID`, `ITEMID`, `PRODID`, `ACTUALPRICE`, `QTY`, `ITEMTOT`) VALUES(621, 2, 100870, '2.80', 100, '280.00');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `ORDID` int(11) NOT NULL,
  `ORDERDATE` date NOT NULL,
  `CUSTID` int(11) NOT NULL,
  `SHIPDATE` date DEFAULT NULL,
  PRIMARY KEY (`ORDID`),
  KEY `ORDERS_CUSTID_FK` (`CUSTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `orders`:
--   `CUSTID`
--       `customer` -> `CUSTID`
--

--
-- Daten für Tabelle `orders`
--

INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(601, '1982-01-07', 106, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(602, '1982-01-08', 102, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(603, '1982-01-10', 102, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(604, '1982-02-01', 106, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(605, '1982-02-05', 106, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(606, '1982-02-27', 100, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(607, '1982-03-03', 104, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(608, '1982-03-07', 104, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(609, '1982-04-11', 100, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(610, '1982-04-23', 101, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(611, '1982-04-30', 102, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(612, '1982-04-30', 104, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(613, '1982-05-02', 108, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(614, '1982-05-02', 102, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(615, '1982-06-06', 107, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(616, '1982-06-08', 103, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(617, '1982-06-14', 105, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(618, '1982-06-17', 102, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(619, '1982-07-21', 104, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(620, '1982-07-23', 100, NULL);
INSERT INTO `orders` (`ORDID`, `ORDERDATE`,  `CUSTID`, `SHIPDATE`) VALUES(621, '1982-07-31', 100, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `PRODID` int(11) NOT NULL,
  `DESCRIP` varchar(30) DEFAULT NULL,
  `CAT` varchar(30) DEFAULT NULL,
  `VENDORID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PRODID`),
  KEY `PRODUCTS_VENDORID_FK` (`VENDORID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `products`:
--   `VENDORID`
--       `vendor` -> `VENDORID`
--

--
-- Daten für Tabelle `products`
--

INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(100860, 'ACE TENNIS RACKET I', 'Rackets', 1);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(100861, 'ACE TENNIS RACKET II', 'Rackets', 1);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(100870, 'ACE TENNIS BALLS-3 PACK', 'Balls', 2);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(100871, 'ACE TENNIS BALLS-6 PACK', 'Balls', 2);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(100890, 'ACE TENNIS NET', 'Nets', 4);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(101860, 'SP TENNIS RACKET', 'Rackets', 4);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(101863, 'SP JUNIOR RACKET', 'Rackets', 4);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(102130, 'RH: \"GUIDE TO TENNIS\"', 'Accessories', 4);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(200376, 'SB ENERGY BAR-6 PACK', 'Snacks', 3);
INSERT INTO `products` (`PRODID`, `DESCRIP`, `CAT`, `VENDORID`) VALUES(200380, 'SB VITA SNACK-6 PACK', 'Snacks', 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `salgrade`
--

DROP TABLE IF EXISTS `salgrade`;
CREATE TABLE IF NOT EXISTS `salgrade` (
  `GRADE` int(11) NOT NULL,
  `LOSAL` decimal(10,0) NOT NULL,
  `HISAL` int(11) DEFAULT NULL,
  PRIMARY KEY (`GRADE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `salgrade`:
--

--
-- Daten für Tabelle `salgrade`
--

INSERT INTO `salgrade` (`GRADE`, `LOSAL`, `HISAL`) VALUES(1, '700', 1200);
INSERT INTO `salgrade` (`GRADE`, `LOSAL`, `HISAL`) VALUES(2, '1201', 1400);
INSERT INTO `salgrade` (`GRADE`, `LOSAL`, `HISAL`) VALUES(3, '1401', 2000);
INSERT INTO `salgrade` (`GRADE`, `LOSAL`, `HISAL`) VALUES(4, '2001', 3000);
INSERT INTO `salgrade` (`GRADE`, `LOSAL`, `HISAL`) VALUES(5, '3001', 9999);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vendor`
--

DROP TABLE IF EXISTS `vendor`;
CREATE TABLE IF NOT EXISTS `vendor` (
  `VENDORID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) NOT NULL,
  `CITY` varchar(50) NOT NULL,
  `RATING` tinyint(4) NOT NULL,
  `ACTIVEFLAG` char(1) NOT NULL,
  PRIMARY KEY (`VENDORID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- RELATIONEN DER TABELLE `vendor`:
--

--
-- Daten für Tabelle `vendor`
--

INSERT INTO `vendor` (`VENDORID`, `NAME`, `CITY`, `RATING`, `ACTIVEFLAG`) VALUES(1, 'SUPERSALES INC.', 'Boston', 1, '1');
INSERT INTO `vendor` (`VENDORID`, `NAME`, `CITY`, `RATING`, `ACTIVEFLAG`) VALUES(2, 'Federal Sport', 'Los Angeles', 2, '1');
INSERT INTO `vendor` (`VENDORID`, `NAME`, `CITY`, `RATING`, `ACTIVEFLAG`) VALUES(3, 'Mitchell Sports', 'Berkeley', 1, '1');
INSERT INTO `vendor` (`VENDORID`, `NAME`, `CITY`, `RATING`, `ACTIVEFLAG`) VALUES(4, 'Victory Tennis Club', 'New York', 3, '1');

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `CUSTOMER_REPID_FK` FOREIGN KEY (`REPID`) REFERENCES `employee` (`EMPNO`);

--
-- Constraints der Tabelle `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `EMP_DEPTNO_FK` FOREIGN KEY (`DEPTNO`) REFERENCES `departments` (`DEPTNO`),
  ADD CONSTRAINT `EMP_MGR_FK` FOREIGN KEY (`MGR`) REFERENCES `employee` (`EMPNO`);

--
-- Constraints der Tabelle `orderitems`
--
ALTER TABLE `orderitems`
  ADD CONSTRAINT `ITEM_ORDID_FK` FOREIGN KEY (`ORDID`) REFERENCES `orders` (`ORDID`),
  ADD CONSTRAINT `ITEM_PRODID_FK` FOREIGN KEY (`PRODID`) REFERENCES `products` (`PRODID`);

--
-- Constraints der Tabelle `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `ORDERS_CUSTID_FK` FOREIGN KEY (`CUSTID`) REFERENCES `customer` (`CUSTID`);


--
-- Constraints der Tabelle `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `PRODUCTS_VENDORID_FK` FOREIGN KEY (`VENDORID`) REFERENCES `vendor` (`VENDORID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;