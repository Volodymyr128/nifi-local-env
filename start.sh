#!/bin/bash
set -e

echo 'Launching containers'
docker-compose -f stack.yml up -d

echo 'Wait 10 seconds for SQL Server to initilize (may be removed)'
sleep 10

echo 'Start executing sql script'
docker exec -i sql-server  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Qweqwe123 <setup.sql
echo 'Done'
