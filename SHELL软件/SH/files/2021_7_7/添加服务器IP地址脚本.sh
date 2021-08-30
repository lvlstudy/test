#!/bin/bash
#有个前提是8虚拟端口，走nat模式，修改网卡配置文件，共6处地方，见以下两行
#添加IP地址，子网掩码，网关（路由），域名解析dns
#修改IP地址协议，性质，是静态ip还是动态iP，  并且设置开机自启即onboot=no变为onboot=yes
ip=`grep IPADDR /etc/sysconfig/network-scripts/ifcfg-eth0`
yema=`grep NETMASK /etc/sysconfig/network-scripts/ifcfg-eth0`
gate=`grep GATEWAY /etc/sysconfig/network-scripts/ifcfg-eth0`
dns=`grep DNS1 /etc/sysconfig/network-scripts/ifcfg-eth0`
if [ -z "$ip" ]
then
    echo " IPADDR=192.168.8.11 "  >>/etc/sysconfig/network-scripts/ifcfg-eth0
fi


if [ -z "$yema" ]
then
    echo " NETMASK=255.255.255.0 " >>/etc/sysconfig/network-scripts/ifcfg-eth0
fi

if [ -z "$gate" ]
then 
    echo " GATEWAY=192.168.8.254 " >>/etc/sysconfig/network-scripts/ifcfg-eth0
fi


if [ -z "$dns" ]
then
    echo "DNS1=114.114.114.114" >>/etc/sysconfig/network-scripts/ifcfg-eth0
fi



sed -i "s/dhcp/static/" /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0
