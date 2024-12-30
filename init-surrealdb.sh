#!/bin/bash
# init-surrealdb.sh

SURREALCMD="docker compose run -T --rm -v "$(pwd)/init.surql:/init.surql" surrealdb"

# .envファイルの読み込み
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo ".env file not found"
    exit 1
fi

echo "SurrealDB is ready! Executing initialization script..."
$SURREALCMD import \
    --conn http://surrealdb:8000 \
    --username $DB_USER \
    --password $DB_PASSWORD \
    --namespace $DB_NAMESPACE \
    --database $DB_DATABASE \
    /init.surql

echo "Database initialization completed!"
