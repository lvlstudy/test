#!/bin/bash
#安装sendMail命令
#下载安装包
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
#创建目录
mkdir -p /usr/local/bin
#解压缩包
tar -zxf sendEmail-v1.56.tar.gz -C /usr/src
#进入解压目录
cd /usr/src/sendEmail-v1.56/
#复制程序到指定目录
cp -a sendEmail /usr/local/bin
#给执行权限
chmod +x /usr/local/bin/sendEmail
#安装组件
yum install perl-Net-SSLeay perl-IO-Socket-SSL -y

