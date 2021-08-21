#!/bin/bash
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
