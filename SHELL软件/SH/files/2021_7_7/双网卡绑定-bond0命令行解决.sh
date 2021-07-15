#!/bin/bash
nmcli connection add type bond con-name bond0 ifname bond0 mode active-backup ipv4.addresses 192.168.10.100/24 ipv4.gateway 192.168.10.254
nmcli con add type ethernet con-name eth1 ifname eth1 master bond0
nmcli con add type ethernet con-name eth2 ifname eth2 master bond0
nmcli con mod bond0 ipv4.method manual connection.autoconnect yes
nmcli con up bond0
#远程测试是否高可用
#nmcli dev disconnect eth1(断开指定网卡)
#nmcli dev connect eth2（连接指定网卡）

