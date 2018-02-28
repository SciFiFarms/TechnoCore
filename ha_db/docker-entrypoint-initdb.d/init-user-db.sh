#!/bin/bash
set -e
createuser homeassistant
#psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
#    CREATE USER docker;
#    CREATE DATABASE docker;
#    GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
#EOSQL