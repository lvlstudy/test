#!/bin/bash
cat << EOF
1.安装docker
2.启动docker
3.退出
EOF
read -p "请选择一个变量来定位：" Select
case $Select in
1)
  echo "安装docker软件开始-----------------------"
  curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
  wget -O /etc/yum.repos.d/docker-ce.repo  https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo
  sed -i "s#download.docker.com#mirrors.tuna.tsinghua.edu.cn/docker-ce#g" /etc/yum.repos.d/docker-ce.repo
  yum -y install docker-ce
  sleep  10
  echo "安装docker软件结束-----------------------"
;;
2)
  echo "启动docker服务端----------------------------------------------------------------"
  systemctl enable docker --now
  sleep 10
  echo "启动docker完毕！！！！！！！！！"
;;
3)
   echo "退出---------------------------------------------------------------------------"
   sleep  10
   exit 1
esac
