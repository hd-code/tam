# Datenbanken 2 – Tennis and More

Dieses Projekt enthält die Datenbank 'Tennis and More' für das Modul Datenbanken 2 an der FH Erfurt.

## Nutzung mit Docker

Die Nutzung mit Docker ist zu empfehlen, da die Installation und Handhabung denkbar einfach ist. Ebenso, läuft die Datenbank mit Docker auf allen Systemen (Windows, Mac, Linux).

Docker erstellt sog. Container. In diesen Containern läuft genau die Software in genau den Versionen, die im `Dockerfile` spezifiziert sind. Dadurch ist gewährleistet, dass immer die gleiche Software in der gleichen Version innerhalb des Containers verwendet wird. Der Container läuft isoliert vom Betriebssystem des Hosts. Der Effekt ist vergleichbar mit dem einer virtuellen Maschine.

Der Ablauf gestaltet sich wie folgt:

Zunächst wird mittels eines Dockerfiles ein sog. Image erstellt. Dieses Image ist der Bauplan für einen Container. Heißt: mit einem Image können beliebig viele Container-Instanzen erzeugt werden. Ein Image ist also vergleichbar mit einer Klasse in OOP.

Sobald das Image erstellt ist, kann ein Container mit der TAM-Datenbank gestartet werden. Die TAM-Datenbank ist nun über den Port 1433 (kann geändert werden) erreichbar.

Über eine geeignete Software z.B. MS-SQL Management Studio oder DBeaver kann nun auf die Datenbank zugegriffen werden.

Der genaue Ablauf wird nun beschrieben.

### Anfoderungen

Es muss lediglich Docker installiert und aktiv sein. Ansonsten gibt es keine weiteren Voraussetzungen.

Docker for Desktop (Windows, Mac) kann hier heruntergeladen und installiert werden:
https://www.docker.com/products/docker-desktop

*Hinweis:* Bei der Installation wird man von Docker aufgefordert, sich zu registrieren. Dieses Fenster kann man aber getrost wegklicken, wenn man das nicht möchte. Es funktioniert auch ohne Docker-Konto.

### Vorbereitung

Nun muss das Dockerfile mit den SQL-Skripten heruntergeladen werden. Anschließend lassen wir daraus das Image erstellen.

Dazu bitte die Konsole öffnen und folgendes ausführen:

```bash
# 1. dieses Repo clonen
git clone https://source.ai.fh-erfurt.de/ha9384dr/tam-mssql.git

# 2. in den Ordner des Projektes wechseln
cd tam-mssql

# 3. Docker Image mit dem Namen 'tam' bauen, mittels:
docker build -t tam .
```

### Verwendung

Nun kann man immer, wenn man mit der TAM-Datenbank arbeiten möchte, den entsprechenden Container starten.

Dazu bitte die Konsole öffnen und folgendes ausführen:

```bash
# gebautes Docker Image auf Port 1433 starten:
docker run -p 1433:1433 tam
```

Sobald der Container gestartet ist, kann man auf die Datenbank mit einem Database Management Tool (z.B. MS-SQL Management Studio oder DBeaver) zugreifen – mit folgenden Zugriffsdaten:

   Host   | Port | user | password
----------|------|------|----------
localhost | 1433 |  sa  | 1234abCD

Wenn man fertig ist, kann der Container in der Konsole mit `STRG`+`C` gestoppt werden.

## Nutzung mit SQL-Server und MS-SQL Management Studio

Auf einem Windows Rechner kann die Datenbank auch ohne Docker verwendet werden.
Benötigte Software dazu sind:

- MS-SQL Server (2017er Version)
- MS-SQL Management Studio (>= v18)

Um nun die Datenbank zu installieren muss im MS-SQL Management Studio das SQL-Skript 'tables.sql' im Ordner `src/` ausgeführt werden.

Danach können die Daten der Tabellen eingefügt werden. Diese befinden sich alle im Ordner `src/data`. Für jede Tabelle gibt es eine zugehörige `.csv`-Datei.