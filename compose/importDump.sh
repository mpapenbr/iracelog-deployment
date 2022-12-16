#!/bin/bash


function usage {
  echo "Usage: $0 -d dbSchema -f dumpFile"
  echo "This will drop the dbSchema, create it again and import the dumpFile into it."
  exit 1
} 

if [[ -z "$1" ]] ; then
 	usage
fi

 
DB_EXEC_USER=postgres
DB_SCHEMA_USER=docker


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--dbschema)
    DB_SCHEMA="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--file)
    DUMP_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    
    --debug)
    DEBUG=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -z "$DB_SCHEMA" ]]; then
   echo "Need a db schema"   
   usage 
fi

if [[ -z "$DUMP_FILE" ]]; then
   echo "Need a dump file to import"   
   usage
fi

if [[ $DEBUG = YES ]]; then
echo "DB_SCHEMA = $DB_SCHEMA"
echo "DUMP_FILE = $DUMP_FILE"
fi

docker compose exec db dropdb --if-exists -h localhost -w -U $DB_EXEC_USER $DB_SCHEMA
docker compose exec db createdb -h localhost -w -U $DB_EXEC_USER -O $DB_SCHEMA_USER $DB_SCHEMA 
docker compose exec db pg_restore -h localhost -j 2 -x -w -U $DB_EXEC_USER --role=$DB_SCHEMA_USER -d $DB_SCHEMA $DUMP_FILE