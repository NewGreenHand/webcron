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


echo -e "启动容器...\n"
webcron




