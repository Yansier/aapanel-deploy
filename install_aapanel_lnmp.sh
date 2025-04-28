#!/bin/bash
# 自动初始化系统 + 安装aaPanel + 固定20852端口 + 安装LNMP环境

echo "开始更新系统..."
sudo apt update -y && sudo apt upgrade -y

echo "安装必要工具..."
sudo apt install -y wget curl unzip lsof

echo "修复Python软链..."
sudo ln -sf /usr/bin/python3 /usr/bin/python

echo "关闭UFW防火墙..."
sudo ufw disable

echo "开始下载安装aaPanel..."
wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh

echo "安装完成，正在固定面板端口为20852..."
echo "20852" | sudo tee /www/server/panel/data/port.pl > /dev/null
sudo /etc/init.d/bt restart

echo "✅ aaPanel已安装并固定端口为20852，下面开始自动安装LNMP环境..."

# 安装LNMP套件（使用aaPanel的命令行工具bt）
# 注意：要稍等几秒，等bt服务彻底启动

sleep 8

# 自动选择安装软件
sudo bt install nginx
sudo bt install mysql
sudo bt install php

echo "✅ LNMP环境安装命令已提交，稍等面板完成自动安装！"

echo "🎉 全部完成！现在可以通过 http://你的服务器IP:20852 登录aaPanel后台管理了！"
