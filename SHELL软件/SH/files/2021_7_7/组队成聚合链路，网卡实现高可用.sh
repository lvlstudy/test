#!/bin/bash
#准备环境：在原有的虚拟机上新添加两个网卡，然后将他们配置成team,接着测试虚拟设备team网卡是否真的高可用？@@@
#发现：在一开始eth1和eth2址为192.168.202.9和192.168.202.10,接着配了team0之后两地址就消失了，地址也只有改完的team0的ip地址；这说明两物理网卡都被加到了虚拟设备虚拟网卡team0中
#man teamd.conf              #查看帮助信息，找到EXAMPLE下，有备份方式，复制
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
