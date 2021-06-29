#!/bin/sh
set -e

# 初始化 Python 环境
function initPythonEnv() {
  echo "开始安装 python 环境 ..."
  apk add --update python3-dev py3-pip py3-cryptography py3-numpy py-pillow
  echo " python 环境依赖安装完成"
}

# 初始化 nodejs 环境
function initNodejsEnv() {
  echo "开始安装 nodejs 环境及依赖..."
  apk add --update nodejs npm
  echo " nodejs 环境依赖安装完成"

}

# 获取环境相关环境变量
#set INIT_PYTHON = ${INIT_PYTHON: "false"}
#set INIT_NODEJS = ${INIT_NODEJS: "false"}

# 检测是否需要安装 python 环境依赖
if [ "$INIT_PYTHON" == "True" || "$INIT_PYTHON" == "true" ]; then
  initPythonEnv
fi

# 检测是否需要安装 nodejs 环境依赖
if [ $INIT_NODEJS == "True" || $INIT_NODEJS == "true" ]; then
    initNodejsEnv
fi

echo -e "开始生成配置文件...\n"
# 数据库信息
sed -i "s/\.\/conf\/webcron.db/${DB_URL:-\.\/conf\/webcron\.db}/g" /app/conf/app.conf
sed -i "s/db\.prefix = t_/db.prefix = ${DB_PREFIX:-t_}/g" /app/conf/app.conf

# 管理员信息
sed -i "s/admin\.user = admin/admin\.user = ${ADMIN_USER:-admin}/g" /app/conf/app.conf
sed -i "s/admin\.pwd = admin123/admin\.pwd = ${ADMIN_PWD:-admin123}/g" /app/conf/app.conf
sed -i "s/admin\.email = admin@example\.com/admin\.email = ${ADMIN_EMAIL:-admin@example.com}/g" /app/conf/app.conf

# 邮箱服务器部分
sed -i "s/mail\.queue_size = 100/mail\.queue_size = ${MAIL_QUEUE_SIZE:-100}/g" /app/conf/app.conf
sed -i "s/mail\.from = no-reply@example\.com/mail\.from = ${MAIL_FROM:-no-reply@example\.comm}/g" /app/conf/app.conf
sed -i "s/mail\.host = smtp\.example\.com/mail\.host = ${MAIL_HOST:-smtp\.example\.com}/g" /app/conf/app.conf
sed -i "s/mail\.port = 25/mail\.port = ${MAIL_PORT:-25}/g" /app/conf/app.conf
sed -i "s/mail\.user = username/mail\.user = ${MAIL_USER:-username}/g" /app/conf/app.conf
sed -i "s/mail\.password = you password/mail\.password = ${MAIL_PWD:-you password}/g" /app/conf/app.conf

echo -e "配置文件生成完毕...\n"

echo -e "启动容器...\n"
webcron




