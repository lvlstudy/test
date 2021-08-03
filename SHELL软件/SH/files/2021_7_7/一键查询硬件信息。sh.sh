#!/bin/bash
#一键查询硬件信息

echo "===================================================================================================="
echo "                                   硬件信息查询                                                     "
echo "====================================================================================================="

echo  "产品型号：$(dmidecode -s  system-product-name)"

echo -e "产品序列号: $(dmidecode -s  system-serial-number)\n"

echo -e "-------------- ------------CPU信息------------------------------------------\n"
echo "CPU物理数量:$(cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l)"

echo -e "CPU核心及版本信息：$(cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c) \n"

echo "-------------------------------内存信息-------------------------------------------"
echo "内存条插槽数：$(dmidecode |  grep "Memory Device" | wc -l)"

echo -e "可最大安装内存容量为$(dmidecode -t memory | grep -i Capacity) \n"

echo -e "已安装内存条数目：$(dmidecode -t memory | grep -i size | grep -v "No Module Installed" | wc -l)根 \n"

echo "已安装内存详细信息："
lshw -short -C memory | grep GiB
echo -e "\n"

echo "-----------------------------硬盘信息---------------------------------------------"
echo -e  "硬盘数量：$(ls /dev/sd* | grep -v [1-9] | wc -l) \n"

echo "硬盘详细信息"
lshw -short -C disk

echo " Raid卡信息"
lspci -v | grep -i Infiniband
echo -e "\n"

echo "-----------------------------网卡信息----------------------------------------------"
echo -e "网卡数量:$(lspci | grep Ethernet | wc -l)个\n"
echo "网卡详细信息"
lspci | grep Ethernet
echo -e "\n"

echo "IB卡信息"
lspci -v | grep Infiniband

