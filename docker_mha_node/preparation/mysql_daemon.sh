#!/bin/bash

/entrypoint.sh mysqld &
tail -f /dev/null