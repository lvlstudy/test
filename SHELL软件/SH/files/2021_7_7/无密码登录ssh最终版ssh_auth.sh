#!/bin/bash
#批量实现ssh免密登录
#没有则装expect
if ! rpm -q expect > /dev/null
then
  echo "####expect未安装，现在安装###"
  yum -y install expect &> /dev/null
  if [ $? -ne 0 ]
  then
     echo "####expect 安装失败###"
     exit 1
  fi
fi


#本机没有ssh密钥则生成
if [ ! -f ~/.ssh/id_rsa ]
then
    echo "###请按3次enter键###"
    ssh-keygen -t rsa
fi


ssh_expect(){
   expect -c "set timeout -1;
   spawn ssh-copy-id -f $1
 
   expect {
       "yes/no" { send -- yes\r;exp_continue;}
       "password:" { send -- $2\r;exp_continue;}
       eof
    }"
}

[ -f hosts.txt ] && rm -rf hosts.txt
#定义hosts.txt
cat > hosts.txt << EOF
192.168.8.111
192.168.8.112
192.168.8.113
192.168.8.114
192.168.8.115
EOF
 
passwd=123
for ip in `cat hosts.txt |awk '{print $1}'`
do
  ssh_expect $ip $passwd
done
