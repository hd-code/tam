FROM mcr.microsoft.com/mssql/server:2017-latest
 
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=1234abCD
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433

WORKDIR /src
COPY ./src/ .

RUN (/opt/mssql/bin/sqlservr &) | grep -q 'Service Broker manager has started.' && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i tables.sql && \
    cd data && \
    for i in *; do /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d tam \
    -Q "BULK INSERT "${i%.csv}" FROM '/src/data/"${i}"' WITH (FORMAT='CSV', FIELDTERMINATOR=';', ROWTERMINATOR='\n', FIRSTROW=2);"; done

EXPOSE 1433