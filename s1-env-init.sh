#!/bin/bash

# 环境初始化
# 定义变量，用于标识是否需要配置docker代理
USE_ALIYUN_MIRROR="true"
USE_DOCKER_PROXY="false"
USE_DOCKER_MIRROR="false"
DOCKER_PROXY="http://192.168.124.7:7890/"
DOCKER_MIRROR="https://docker.m.daocloud.io"
echo "Docker proxy is set to $DOCKER_PROXY"

echo "========== 安装git =========="
# 1. 安装git
apt install -y git


echo "========== 卸载旧docker =========="
for pkg in docker \
           docker-engine \
           docker.io \
           docker-doc \
           docker-compose \
           podman-docker \
           containerd \
           runc;
do
    sudo apt remove $pkg;
done


echo "========== 安装docker =========="
# 2. 安装docker
sudo apt upgrade -y
sudo apt update -y
# 直接使用官方脚本比较稳定
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# 3. 如果需要配置docker代理地址
# 判断是否需要docker代理
if [ "$USE_DOCKER_PROXY" = "true" ]; then
  echo "========== 配置docker代理 =========="
  # 设置docker代理
  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<-EOF
[Service]
Environment="HTTP_PROXY=${DOCKER_PROXY}" "HTTPS_PROXY=${DOCKER_PROXY}" "NO_PROXY=localhost,127.0.0.1,::1,/var/run/docker.sock"
EOF
fi



# 4. 如果需要配置docker镜像源
if [ "$USE_DOCKER_PROXY" = "true" ]; then
sudo tee /etc/docker/daemon.json <<-EOF
{
  "registry-mirrors": [
   ${DOCKER_MIRROR}
  ]
}
EOF
docker system prune -a
fi



# 启动docker服务
echo "========== 启动docker =========="
sudo systemctl enable docker
sudo systemctl start docker

echo "========== 配置docker开机自启 =========="
# 设置docker开机自启
# sudo systemctl enable docker.service
sudo systemctl enable containerd.service


echo "========== deploy依赖初始环境完成 =========="