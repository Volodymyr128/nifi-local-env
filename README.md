In order to test/develop your Nifi pipeline locally, do the following steps
1. Make sure that setup.sql script has all mock date you need during your ingestion flow
2. Run SQL Server & Nifi with `start.sh`
3. Go to local Nifi UI (localhost:8080/nifi) inside your favorite browser 
4. Import the Nifi Flow you want to test
5. Switch to local DBCPConnectionPool in all ExecuteSQL and ExecuteSQLRecord processors, enter password for local DBCPCOnnectionPool (Qweqwe123) because password is not part of a template
6. Run, test, develop Nifi Flow
  6.1. To trigger Nifi Flow ListenHTTP - type `./trigger_http.sh`
7. In case you need to do some SQL queries on SQL Server without restarting it, you can type `docker exec -it sql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Qweqwe123`
8. When you're done, run `stop.sh`
