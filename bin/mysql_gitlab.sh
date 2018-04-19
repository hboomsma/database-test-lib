#!/usr/bin/env bash

# Configure data locations
LOG="$HOME/database_test.log"
MYSQL="mysql -h localhost -P 3306 -u root -p ${MYSQL_ROOT_PASSWORD}"
exec 3>> "$LOG"

finish() {
    echo "### Cleaning Database $DBNAME" >&3
    echo "DROP DATABASE \`$DBNAME\`;" | $MYSQL >&3
}

# Create the database
DBNAME="$(date +%s%N)"
echo "CREATE DATABASE \`$DBNAME\`;" | $MYSQL >&3

echo "### Trap Set" >&3
trap finish EXIT

echo "driver: pdo_mysql, host: localhost, dbname: ${DBNAME}, user: root, password: ${MYSQL_ROOT_PASSWORD}"
echo "### Connection params sent" >&3

# Wait on parent process before cleaning up the database
while read -r _; do
    sleep .1
done

cat "$LOG"
