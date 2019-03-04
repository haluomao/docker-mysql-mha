#!/bin/bash
# usage: 在容器外运行, 在failover后运行，重新配置各容器的ssh

#set -x
set -eo pipefail
shopt -s nullglob

declare -a container_id;
#declare -a container_ip;
declare -a service_name;

# 无参函数
# 用于获取当前Docker compose下的所有container id和ip地址, 执行容器内的SSH免密登录脚本
ssh-interconnect() {
    local ssh_init_path=/preparation/ssh-init.sh
    local ssh_pass_path=/preparation/ssh-pass.sh
    # 将该project下的container name置于数组
    for con in $(docker-compose ps | sed -n '3,$p' | sed -n '/Up/p' | awk '{print $1}'); do
        # 获取正在运行的container id
        cid=$(docker ps | grep "$con" | awk '{print $1}')
        container_id+=( "$cid" )
        # 获取容器ip
        #container_ip+=("$(docker inspect "$cid" | grep -o -E '\"IPAddress": ".+"' \
        #    | grep -o -E '(\d+[.]*)+\"' | sed "s/\"//g")")
        # 获取docker compose的service名, 限制一个service对应一个container
        service_name+=("$(docker inspect "$cid" | sed -n 's/\"com\.docker\.compose\.service\": \"//gp' \
            | sed -n 's/\",//gp')")
    done

    for c_id in ${container_id[*]}; do
        echo "$c_id initializing SSH..."
        docker exec "$c_id" "$ssh_init_path"
    done

    for c_id in ${container_id[*]}; do
        for c_name in ${service_name[*]}; do
            docker exec "$c_id" "$ssh_pass_path" "$c_name"
        done
    done
}

# 将接收到的参数使用ANSI颜色打印到控制台
aprint() {
    echo "$(tput setaf 2)>>> $1 $(tput sgr0)"
}

aprint "Repair ssh..."
ssh-interconnect

aprint "Done!"
