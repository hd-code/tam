FROM mcr.microsoft.com/mssql/server:2017-latest
 
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=1234abCD
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433

ENV BACKUP=SW1920.bak

WORKDIR /src

COPY ${BACKUP} .

RUN (/opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" && \
    /opt/mssql-tools/bin/sqlcmd -S127.0.0.1 -Usa -P1234abCD \
    -Q"CREATE DATABASE sw";
#    -Q"RESTORE DATABASE sw FROM DISK=${BACKUP};" 


EXPOSE 1433