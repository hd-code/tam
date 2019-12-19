# Datenbanken 2 – Tennis and More

Dieses Projekt enthält das Dockerfile sowie alle nötigen SQL-Skripte, um die Datenbank 'Tennis and More' für das Modul Datenbanken 2 aufzusetzen.

## Nutzung mit Docker

Docker muss installiert und aktiv sein. Ansonsten gibt es keine weiteren Voraussetzungen.

1. Dieses Repo auf den Rechner herunterladen
2. Terminal in diesem Ordner öffnen
3. Docker Image 'tam' bauen, mittels:

```bash
docker build -t tam .
```

4. gebautes Docker Image auf Port 1433 starten:

```bash
docker run -p 1433:1433 tam
```

Nun kann auf die Datenbank mit einem Database Management Tool (z.B. MS-SQL Management Studio oder DBeaver) zugegriffen werden.

## Nutzung mit SQL-Server und MS-SQL Management Studio

Auf einem Windows Rechner kann die Datenbank auch ohne Docker verwendet werden.
Benötigte Software dazu sind:

- MS-SQL Server (2017er Version)
- MS-SQL Management Studio (>= v18)

Um nun die Datenbank zu installieren muss lediglich im MS-SQL Management Studio das SQL-Skript 'tables.sql' im Ordner `src/` ausgeführt werden.