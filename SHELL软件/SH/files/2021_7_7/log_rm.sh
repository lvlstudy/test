#!/bin/bash
#指定文件变量
catalina_size=$(du -b /home/web/tomcat/logs/catalina.out |awk '{print $1}')
#指定文件最多不能超过10G
max_size=$((1024*1024*10))
if [ $catalina_size -gt $max_size ];then
  cat /dev/null >/home/web/tomcat/logs/catalina.out
fi
#查找相应目录下的文件进行删除，保留十天之内的文件
find /home/web/tomcat/logs/ ! -name "catalina.out" -type f  -ctime +10 -exec rm {} \;
#查找GWS的相关日志去进行删除，并保留三天之内的日志文件
find /opt/runGWS/ -name "*.log*" -type f -ctime +3 -exec rm {} \;
#查找master的日志去进行删除，并保留3天的日志文件
find /opt/WebConfig/mastercontrolserver/logs/mastercontrolserver -name "*.gz*" -type f -ctime +3 -exec rm {} \;
