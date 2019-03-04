#!/bin/bash
# usage: 重新配置并启动haproxy

#set -x
set -eo pipefail
shopt -s nullglob
dir_cnf=/preparation
haproxy_file_cnf="$dir_cnf"/haproxy.cfg
bak_haproxy_file_cnf="$dir_cnf"/bak.haproxy.cfg
generated_flag="# generated"

init_haproxy_conf() {
    cp "$bak_haproxy_file_cnf" "$haproxy_file_cnf"
    echo "    $generated_flag" >> "$haproxy_file_cnf"

    echo "    server server1 $1:$2" >> "$haproxy_file_cnf"
    echo "added host \"$1:$2\" to mha haproxy configuration file."
}

start_haproxy() {
    if [ -f "/var/run/haproxy.pid" ]; then
        haproxy -f "$haproxy_file_cnf" -p /var/run/haproxy.pid -sf `cat /var/run/haproxy.pid`
    else
        haproxy -f "$haproxy_file_cnf" -p /var/run/haproxy.pid
    fi
}

echo "**********************************************"
echo "restart haproxy..."
init_haproxy_conf $@
start_haproxy
echo "restart haproxy done!"

exit 0
