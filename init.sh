#!/bin/bash
# init docker images

set -eo pipefail
shopt -s nullglob

echo "Docker Compose starting..."
docker-compose up -d
echo "Done!"
