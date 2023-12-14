#!/bin/bash
read -p "请给个用户：" user
if [ -z $user ]
then
   echo "没有输入参数" && exit 2
fi


stty -echo 
read -p "请输入密码：" pass
stty echo 
pass=${pass:-123456}


useradd $user
echo $pass |passwd --stdin $user
