#!/bin/bash
#前提要产生公私钥
#前提要下载expect这个Linux软件包，好产生expect模块
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

