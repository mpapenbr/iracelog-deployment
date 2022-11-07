#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" template1 <<-EOSQL
    CREATE EXTENSION "uuid-ossp"; 
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $DB_USER_NAME superuser login  encrypted password '$DB_USER_PASSWORD';
    CREATE DATABASE iracelog with owner $DB_USER_NAME;    
    GRANT ALL PRIVILEGES ON DATABASE iracelog TO $DB_USER_NAME;
    GRANT ALL PRIVILEGES ON ALL TABLES in SCHEMA public TO $DB_USER_NAME;
EOSQL