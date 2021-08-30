#!/bin/bash
#./utils/install_serer.sh初始化配置脚本

#redis的配置文件
#端口 6379     主配置文件 /etc/redis/6379.conf
#日志文件 /var/log/redis_6379.log
#数据库目录 /var/lib/redis/6379
#服务启动程序/usr/local/bin/redis-server
#命令行连接命令/usr/local/bin/redis-cli
#启动/etc/init.d/redis_6379 start
#停止 /etc/init.d/redis_6379 stop
#查询状态 /etc/init.d/redis_6379 status
#查询redis进程ps -ef |grep 6379|grep -v grep
#redis-cli默认连接本地服务器
#基本命令set 变量名  值
#获得变量名 get 变量名
#查询所有变量名 keys *
#exit退出
#/var/lib/redis/6379/*.rdb存储在硬盘里的数据~~~

#源码编译redis的tar包
#ls /redis || mkdir /redis
#rpm -q gcc ||yum -y install gcc
#tar -zxf /redis/redis-4.0.8.tar.gz -C /redis
#cd /redis/redis-4.0.8
#make  &&  make install
#初始化配置
cd /redis/redis-4.0.8
sh -x utils/install_server.sh
