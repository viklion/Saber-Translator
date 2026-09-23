#!/bin/sh
set -e

Green="\033[32m"
Red="\033[31m"
Yellow='\033[33m'
Font="\033[0m"

INFO_TAG="[${Green}INFO${Font}]"
ERROR_TAG="[${Red}ERROR${Font}]"
WARN_TAG="[${Yellow}WARN${Font}]"

INFO() {
    echo -e "${INFO_TAG} $1"
}
ERROR() {
    echo -e "${ERROR_TAG} $1"
}
WARN() {
    echo -e "${WARN_TAG} $1"
}

: "${PUID:=0}"
: "${PGID:=0}"
: "${TZ:=Asia/Shanghai}"

# 时区设置
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# 修改 UID/GID
groupmod -o -g "${PGID}" translator
usermod -o -u "${PUID}" translator

# 权限修正
chown -R translator:translator /app

INFO "Starting as UID=${PUID}, GID=${PGID}"

# 用 gosu 切换用户执行
exec gosu translator "$@"