#!/bin/bash
set -e
export PGPASSWORD='secret'
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=template1<<-EOSQL
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL