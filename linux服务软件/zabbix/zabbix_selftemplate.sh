#!/bin/bash
#利用zabbix创建自定义监控,在zabbix客户端上执行
sed -i "264c Include=/usr/local/etc/zabbix_agentd.conf.d/" /usr/local/etc/zabbix_agentd.conf
cd /usr/local/etc/zabbix_agentd.conf.d
##自定义key语法格式:
##UserParameter=自定义key名称,命令
if [ ! -f count.line.passwd ];then
  echo "UserParameter=count.line.passwd,sed -n '$=' /etc/passwd" > ./count.line.passwd
else
  echo "count.line.passwd已经存在"
fi



#测试自定义key是否正常工作
killall zabbix_agentd
zabbix_agentd
zabbix_get -s 127.0.0.1 -k count.line.passwd


