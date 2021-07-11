#!/bin/bash
#前提要产生公私钥
#前提要下载expect这个Linux软件包，好产生expect模块
#批量传公私钥，实现无密码登录
#产生密钥对验证
ssh-keygen -t rsa
#ssh协议免交互代理
ssh-agent bash
ssh-add

#shell脚本批量发送公钥
yum install expect -y
#cd ~/.ssh
#vim ~/.ssh/pushssh.sh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
host1=`cat /etc/ansible/hosts | awk -F: ""'{print $1}' | grep '^192'`
for i in $host1
do
  scp ~/.ssh/authorized_keys root@$i:~/.ssh/authorized_keys
  password="123"
  /usr/bin/expect -c"
    spawn ssh-copy-id root@$i
    expect {
    \"*password\"{send\"$password\r\";exp_continue}
    }
  expect eof"
done

