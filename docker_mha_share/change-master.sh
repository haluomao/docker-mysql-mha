#!/bin/bash
# usage: 在从库上执行, 自动执行CHANGE MASTER使其形成主从链路

#set -x
set -eo pipefail
shopt -s nullglob

if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
    echo "$HOSTNAME please set the environment variable MYSQL_ROOT_PASSWORD first!"
    exit 1
fi

mysql_cmd=( mysql -p"$MYSQL_ROOT_PASSWORD" )

for i in {10..0}; do
	echo "$HOSTNAME MySQL init process in progress..."
	if echo 'SELECT 1' | "${mysql_cmd[@]}" &> /dev/null; then
		echo "$HOSTNAME MySQL init process done!"
		break
	fi
	sleep 1
done
if [ "$i" = 0 ]; then
	echo >&2 "$HOSTNAME MySQL init process failed."
	exit 1
fi

"${mysql_cmd[@]}" <<-EOSQL
	GRANT ALL PRIVILEGES ON *.* TO "$MYSQL_MHA_NAME"@"172.%" IDENTIFIED BY "${MYSQL_MHA_PASSWORD:-}";
	GRANT ALL PRIVILEGES ON *.* TO "$MYSQL_MHA_NAME"@"198.%" IDENTIFIED BY "${MYSQL_MHA_PASSWORD:-}";
	GRANT REPLICATION SLAVE ON *.* TO "$MYSQL_REPL_NAME"@"172.%" IDENTIFIED BY "${MYSQL_REPL_PASSWORD:-}";
	GRANT REPLICATION SLAVE ON *.* TO "$MYSQL_REPL_NAME"@"198.%" IDENTIFIED BY "${MYSQL_REPL_PASSWORD:-}";
	STOP SLAVE;
	CHANGE MASTER TO MASTER_HOST="master", MASTER_USER="${MYSQL_REPL_NAME}", MASTER_PASSWORD="${MYSQL_REPL_PASSWORD:-}", MASTER_AUTO_POSITION=1;
	START SLAVE;
EOSQL

exit 0
