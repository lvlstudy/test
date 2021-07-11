#!/bin/bash
nmcli connection add type team con-name team0 ifname team0 autoconnect yes config '{"runner": {"name": "activebackup"}}'
#添加team成员即奴隶
nmcli connection add type team-slave con-name team0-1 ifname eth1 master team0
nmcli connection add type team-slave con-name team0-2 ifname eth2 master team0
#配置team0的ip地址
nmcli connection modify team0  ipv4.method manual ipv4.addresses 192.168.202.200/24 connection.autoconnect yes
#激活所有配置
nmcli connection up team0
nmcli connection up team0-1
nmcli connection up team0-2
##验证
##teamdctl team0 state#查看team0的详细信息
##ifconfig eth1 down禁用网卡
##teamdctl team0 state#查看team0的详细信息
