#!/bin/bash


function usage {
  echo "Usage: $0 -f dumpFile"
  echo "This will replace (via dropdb+createdb) the iracelog data with the data provided by the dump."
  exit 1
} 

if [[ -z "$1" ]] ; then
 	usage
fi

DB_SCHEMA=postgres 
DB_EXEC_USER=postgres
DB_SCHEMA_USER=postgres


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
kubectl cp $DUMP_FILE iracelog/iracelogapp-postgresql-0:/tmp/db.dump -c postgresql
kubectl exec iracelogapp-postgresql-0 -c postgresql -- dropdb -f $DB_SCHEMA
kubectl exec iracelogapp-postgresql-0 -c postgresql -- createdb $DB_SCHEMA
kubectl exec iracelogapp-postgresql-0 -c postgresql -- pg_restore -x -O -d $DB_SCHEMA /tmp/db.dump
kubectl exec iracelogapp-postgresql-0 -c postgresql -- rm -rf /tmp/db.dump

