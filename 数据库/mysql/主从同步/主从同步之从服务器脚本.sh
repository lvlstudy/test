#!/bin/bash
#时间：2021/08/23
#设置数据库mysql从服务器
server_id=`grep "server-id=2" /etc/my.cnf`
relay_log=`grep "relay_log=slave-relay-bin" /etc/my.cnf`
relay_log_index=`grep "relay_log_index=slave-relay-bin.index" /etc/my.cnf`
if [ -z "$server_id" ]
then
   echo "server-id=2" >>/etc/my.cnf
fi
if [ -z "$relay_log" ]
then
   echo "relay_log=slave-relay-bin" >>/etc/my.cnf
fi
if [ -z "$relay_log_index" ]
then
   echo "relay_log_index=slave-relay-bin.index" >>/etc/my.cnf
fi
systemctl restart mysqld
mysql --connect-expired-password -uroot -p123456 -e "change master to master_host='192.168.8.12',master_port=3306,master_user='backup',master_password='Zjq?123456',master_log_file='master-bin.000003',master_log_pos=154"
mysql --connect-expired-password -uroot -p123456 -e "start slave"
mysql --connect-expired-password -uroot -p123456 -e "show slave status \G"


