#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION "uuid-ossp"; 
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" template1 <<-EOSQL
    CREATE EXTENSION "uuid-ossp"; 
EOSQL
