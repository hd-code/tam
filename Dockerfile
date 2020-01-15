FROM mcr.microsoft.com/mssql/server:2017-latest

# accept ms sql conditions
ENV ACCEPT_EULA=Y
# set password for user 'sa'
ENV SA_PASSWORD=1234abCD
# set mode to developer
ENV MSSQL_PID=Developer
# set tcp port for sql server
ENV MSSQL_TCP_PORT=1433

WORKDIR /src
COPY ./src/ .

# start sql server
# run sql script 'tables.sql'
# go to dir 'data'
# loop through csv-files in 'data' and bulk insert them into the tables
# Attention: The filename of the csv-file has to be exactly the same as the
#            table name in the database.
RUN (/opt/mssql/bin/sqlservr &) | grep -q 'Service Broker manager has started.' && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i tables.sql && \
    cd data && \
    for i in *; do /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d tam \
    -Q "BULK INSERT "${i%.csv}" FROM '/src/data/"${i}"' " \
       "WITH (FORMAT='CSV', FIELDTERMINATOR=';', ROWTERMINATOR='\n', FIRSTROW=2);"; done

EXPOSE 1433