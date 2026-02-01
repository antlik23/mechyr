#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ovladni_mechyr_test WITH PASSWORD 'ovladni_mechyr_test' CREATEDB;
EOSQL
