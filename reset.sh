#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob

echo "$(tput setaf 2)" "Shutting down..." "$(tput sgr0)"
docker-compose down
echo "$(tput setaf 2)" "Deleting libs and logs..." "$(tput sgr0)"
echo "$(tput setaf 2)" "Done!" "$(tput sgr0)"
exit 0
# 跳过下面删除数据库的操作
for dir in ./mha_*; do
    if [[ "$dir" =~ mha_(master|slave_.*) ]]; then
        read -r -p "Are u sure to delete \"$dir/log\" and \"$dir/lib\" ? (y/n): " choice
        if [[ "$choice" == "y" ]]; then
            rm -rf "./$dir/log"
            rm -rf "./$dir/lib"
        fi
    fi
done

