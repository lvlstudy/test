#!/bin/bash
#时间: 2021/08/23
#设置数据库主服务器
server_id=`grep "server-id=1" /etc/my.cnf`
log_bin=`grep "log_bin=master-bin" /etc/my.cnf`
log_bin_index=`grep "log_bin_index=master-bin.index" /etc/my.cnf`
binlog_do_db=`grep "binlog_do_db=test" /etc/my.cnf`
if [ -z "$server_id" ]
then
   echo "server-id=1"  >>/etc/my.cnf
fi
if [ -z "$log_bin" ]
then
   echo "log_bin=master-bin"  >>/etc/my.cnf
fi
if [ -z "$log_bin_index" ]
then
   echo "log_bin_index=master-bin.index" >>/etc/my.cnf
fi
if [ -z "$binlog_do_db" ]
then
   echo "binlog_do_db=test" >>/etc/my.cnf
fi
mysql --connect-expired-password -uroot -p'123456' -e "grant replication slave on *.* to backup@'192.168.8.%' identified by 'Zjq?123456'"
systemctl restart mysqld
mysql --connect-expired-password -uroot -p123456 -e "show master status"

