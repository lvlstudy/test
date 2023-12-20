#!/bin/bash
##下载yum的ali源
 echo "=================安装常用工具及修改yum源==================="
 yum install wget -y &> /dev/null
 if [ $? -eq 0 ];then
  cd /etc/yum.repos.d/
  \cp CentOS-Base.repo CentOS-Base.repo.$(date +%F)
   wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
   yum clean all &> /dev/null
   yum makecache &> /dev/null
 yum -y install ntpdate lsof net-tools telnet vim lrzsz tree nmap nc sysstat &> /dev/null
 echo  "完成安装常用工具及修改yum源"
 echo "==========================================================="
 sleep 2
fi


