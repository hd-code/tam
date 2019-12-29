# Datenbanken 2 – Tennis and More

Dieses Projekt enthält das Dockerfile sowie alle nötigen SQL-Skripte, um die Datenbank 'Tennis and More' für das Modul Datenbanken 2 aufzusetzen.

## Nutzung mit Docker

Docker muss installiert und aktiv sein. Ansonsten gibt es keine weiteren Voraussetzungen.

Im Terminal dann folgendes ausführen:

```bash
# 1. das Repo clonen
git clone https://source.ai.fh-erfurt.de/ha9384dr/tam-mssql.git

# 2. in den Ordner wechseln
cd tam-mssql

# 3. Docker Image 'tam' bauen, mittels:
docker build -t tam .

# 4. gebautes Docker Image auf Port 1433 starten:
docker run -p 1433:1433 tam
```

Nun kann auf die Datenbank mit einem Database Management Tool (z.B. MS-SQL Management Studio oder DBeaver) zugegriffen werden.

## Nutzung mit SQL-Server und MS-SQL Management Studio

Auf einem Windows Rechner kann die Datenbank auch ohne Docker verwendet werden.
Benötigte Software dazu sind:

- MS-SQL Server (2017er Version)
- MS-SQL Management Studio (>= v18)

Um nun die Datenbank zu installieren muss im MS-SQL Management Studio das SQL-Skript 'tables.sql' im Ordner `src/` ausgeführt werden.

Danach können die Daten der Tabellen eingefügt werden. Die befinden sich alle im Ordner `src/data`. Für jede Tabelle gibt es eine zugehörige `.csv`-Datei.