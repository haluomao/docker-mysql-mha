#!/bin/bash
# usage: 在MHA manager上运行, 重启监控进程

#set -x
set -eo pipefail
shopt -s nullglob
dir_cnf=/mha_share
file_cnf="$dir_cnf"/application.cnf
log_file=/var/log/masterha/mha.log

echo "**********************************************"
echo "checking mha ssh..."
masterha_check_ssh --conf="$file_cnf"
echo "**********************************************"
echo "checking mha repl to mysql..."
masterha_check_repl --conf="$file_cnf"

if [ "$(ps aux | pgrep '/usr/local/bin/masterha_manager' || echo $?)" == 1 ]; then
    echo "**********************************************"
    echo "starting mha manager with file \"$file_cnf\"..."
    nohup masterha_manager --conf="$file_cnf" >>$log_file &
    sleep 1
else
    echo "**********************************************"
    echo "mha manager process has been running already..."
fi
exit 0
