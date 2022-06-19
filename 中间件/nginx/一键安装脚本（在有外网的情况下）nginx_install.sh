#!/bin/sh
function caidan() {
cat << EOF
+------------------------------------------------------+
|  一键安装Nginx脚本
+------------------------------------------------------+
EOF
}
caidan
if [  ! -d /usr/local/src ]
then
   mkdir /usr/local/src
fi
LOG_DIR=/usr/local/src
###########################################
function NGINX_INSTALL() {
yum install -y wget gcc gcc-c++ pcre-devel  zlib-devel openssl-devel  &>/dev/null
if [ $? -eq 0 ];then
  cd $LOG_DIR && wget  http://nginx.org/download/nginx-1.4.2.tar.gz &>/dev/null  && useradd -M -s /sbin/nologin nginx && tar -xf nginx-1.4.2.tar.gz && cd nginx-1.4.2/ && ./configure --prefix=/usr/local/nginx --user=nginx &>/dev/null && make &>/dev/null && make install &>/dev/null
fi
if [ -e /usr/local/nginx/sbin/nginx ];then
   /usr/local/nginx/sbin/nginx && echo "Nginx安装并启动成功！！！"
fi
}
echo "开始安装Nginx请稍等..." && NGINX_INSTALL
####################################################################################
####################################################################################
####################################################################################
#[root@centos7 opt]# ln -s  /usr/local/nginx/sbin/nginx /usr/sbin  #将nginx命令做个软连接到/usr/sbin下面去，方便去使用
#[root@centos7 opt]# nginx -t
#nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
#nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
#[root@centos7 opt]# nginx -s stop    #直接使用nginx命令停止
#[root@centos7 opt]# ps -ef |grep nginx
#root      10992   4535  0 11:02 pts/1    00:00:00 grep --color=auto nginx
#[root@centos7 opt]# nginx  #直接使用nginx命令启动
#[root@centos7 opt]# ps -ef |grep nginx
#root      11042      1  0 11:02 ?        00:00:00 nginx: master process nginx
#nginx     11043  11042  0 11:02 ?        00:00:00 nginx: worker process
#root      11075   4535  0 11:02 pts/1    00:00:00 grep --color=auto nginx
#[root@centos7 opt]# nginx -s stop
#[root@centos7 opt]# nginx -t
#nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
#nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
#[root@centos7 opt]# ps -ef|grep nginx
#root      11355   4535  0 11:03 pts/1    00:00:00 grep --color=auto nginx
#[root@centos7 opt]# nginx
#[root@centos7 opt]# ps -ef|grep nginx
#root      11387      1  0 11:03 ?        00:00:00 nginx: master process nginx
#nginx     11388  11387  0 11:03 ?        00:00:00 nginx: worker process
#root      11408   4535  0 11:03 pts/1    00:00:00 grep --color=auto nginx
#
