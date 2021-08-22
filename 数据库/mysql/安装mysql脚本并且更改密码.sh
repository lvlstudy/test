#!/bin/bash
tar -xf mysql-5.7.17.tar -C /usr/local/src
cd /usr/local/src
yum -y install *.rpm
systemctl start mysqld
mkdir /bak
cp /etc/my.cnf /bak/my.cnf_bak
#  $NF 是截取最后一列
#  --connect-expired-password 能够实现非交互式的执行mysql命令
init_passwd=`grep password /var/log/mysqld.log |head -1 |awk '{print $NF}'`
mysql --connect-expired-password  -uroot  -p$init_passwd -e "alter user root@localhost identified by 'Zjq?1234'"
length=`grep "validate_password_length" /etc/my.cnf`
policy=`grep "validate_password_policy" /etc/my.cnf`
if [ -z "$length" ]
then
  echo " validate_password_length=6 " >>/etc/my.cnf
fi
if [ -z "$policy" ]
then
  echo " validate_password_policy=0 " >>/etc/my.cnf
fi
systemctl restart mysqld
mysql --connect-expired-password -uroot -p'Zjq?1234' -e "alter user root@localhost identified by '123456'"
mysql --connect-expired-password -uroot -p'123456' -e "show databases"
