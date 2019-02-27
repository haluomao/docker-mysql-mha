#!/bin/bash
# usage: 在容器外运行, 在failover后运行，重启manager上的监控脚本和haproxy

#set -x
set -eo pipefail
shopt -s nullglob

echo "Initializing MHA configuration..."
docker-compose exec manager /preparation/monitor.sh

echo "Done!"