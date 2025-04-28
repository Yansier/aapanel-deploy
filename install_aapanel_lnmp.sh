#!/bin/bash
# 超强化版：自动安装aaPanel，固定端口20852，放行防火墙，自动安装LNMP，最终输出登录信息

# 1. 系统基础准备
echo "开始更新系统..."
sudo apt update -y && sudo apt upgrade -y

echo "安装必要工具..."
sudo apt install -y wget curl unzip lsof net-tools -y

echo "修复Python软链..."
sudo ln -sf /usr/bin/python3 /usr/bin/python

echo "关闭UFW防火墙（如果开启）..."
sudo ufw disable || true

# 2. 安装aaPanel
echo "开始下载安装aaPanel..."
wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh

# 等待面板启动
sleep 8

# 3. 固定面板端口到20852
echo "固定面板端口到20852..."
echo "20852" | sudo tee /www/server/panel/data/port.pl > /dev/null
sudo /etc/init.d/bt restart

# 再次确保防火墙打开20852端口（如果服务器有UFW）
echo "放行本地防火墙20852端口..."
sudo ufw allow 20852/tcp || true
sudo ufw reload || true

# 4. 自动安装LNMP环境（nginx、mysql、php）
echo "开始自动安装LNMP环境..."
sudo bt install nginx
sudo bt install mysql
sudo bt install php

# 5. 输出面板登录信息
echo "------------------------------------------"
echo "🎉 aaPanel 安装成功！下面是你的登录信息："
PANEL_IP=$(curl -s http://checkip.amazonaws.com)
PANEL_PORT="20852"
echo "👉 面板地址: http://${PANEL_IP}:${PANEL_PORT}"
echo "👉 用户名密码请查看你的SSH终端安装时输出信息，或登录服务器查看 /www/server/panel/default.pl 文件"
echo "------------------------------------------"

echo "🎯 完整部署完毕，可以通过浏览器访问aaPanel后台了！"
