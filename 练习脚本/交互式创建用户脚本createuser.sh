#!/bin/bash
if [ $UID -ne 0 ]
then
  echo "you have no privileges,you are not superroot"
  exit 1
fi

read -p "给个用户user:" user
if [ -z $user ];then
  echo "没有输入任何变量"
  exit 2
fi

id "$user" &>/dev/null
if [ $? -eq 0 ];then
  echo "用户已存在"
  exit 3
else
  stty -echo
  read -p "给个密码pass" pass
  stty echo
  pass=${pass:-123456}
  useradd $user
  echo $pass |passwd --stdin $user
  echo "创建用户密码成功！！！"
fi
