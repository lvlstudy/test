#!/bin/bash
#模块(如有需要在导出来)
function_all()
{

#登陆用户信息
echo "现在登陆的用户是：`whoami`"

#中文en_US.UTF-8
echo "语言/编码：`echo $LANG`"

#本机的名称
echo "主机名：`hostname`"

#查询网关
echo "网关：`ip route | awk 'NR==1'| awk '{print $3}'`"

#查看本机ip :ip addr|grep inet|egrep -v 'inet6|127.0.0.1'|awk '{ print $2 }'|awk -F/ '{ print $1 }'
echo "本机ip:`ifconfig | grep broadcast | awk '{print $2}'`"

#查看本机的DNS
echo "本机的DNS如下: "
echo "`cat /etc/resolv.conf | grep -v '^#'`" 

#把md5sum /etc/passwd码 生成到/opt.passwd.md5下
md5sum /etc/passwd > /opt/passwd.md5

#显示OK证明passwd里没有被修改过，如果显示FAILED证明改动过
echo "显示OK文件没有被串改 `md5sum -c /opt/passwd.md5`"

#系统时间
echo "当前时间：`date +%F_%T`"

#系统最后启动时间
echo "最后启动：`who -b | awk '{print $2,$3,$4}'`"

#系统运行时间：uptime |awk '{print $1,$3}'|awk -F ',' '{print $1}'
echo "运行时间2：`uptime | awk '{print $1,$3}' | sed 's/,//g'`"

#查看属于什么系统
echo "当前系统：`uname -a | awk '{print $NF}'`"

#系统的类型
echo "系统类型为：`uname -r`"

#系统内核信息
echo "系统内核信息为：`uname  -a|awk '{print $3}'`"

#显示计算机硬件架构
echo "CPU架构: `uname -m`"

#系统的版本号
echo "发行版本：`cat /etc/redhat-release`"

#查看SELinux状态
echo "查看SELinux状态：`/usr/sbin/sestatus | grep 'SELinux status:' | awk '{print $3}'`"

#查看物理CPU个数
echo "物理CPU个数: `cat /proc/cpuinfo | grep "physical id" | awk '{print $4}' | sort | uniq | wc -l`"

#查看逻辑CPU个数
echo "逻辑CPU个数: `cat /proc/cpuinfo | grep "processor" | awk '{print $3}' | sort | uniq | wc -l`"

#CPU的型号信息
echo "CPU型号: `cat /proc/cpuinfo | grep "model name" | sort | uniq | awk -F":" '{print $2}'`"

#查询安装内核信息
echo "已经安装的内核包：`rpm -qa|grep -i ^kernel-[1-9]`"

#查看普通用户
echo "以下是普通用户"
echo `grep -v nobody /etc/passwd|awk -F: '$3>=500 {print $1}'`

#内存总量以下
echo "内存总量为：`free  -m|awk '/Mem/ {print $2}'`"

#内存的剩余总量
echo "内存剩余总量为：`free  -m|awk '/Mem/ {print $4}'`"

#内存的使用量
echo "使用内存：`free -mh | awk "NR==2"| awk '{print $3}'` "

#磁盘系统信息
echo "系统磁盘信息:`fdisk -l 2> /dev/null|grep '^Disk /dev/'|awk -F, '{ print $1 }'`"

#磁盘总量:lsblk |awk '/disk/{print $4}'  也可以如下:
echo "磁盘总量为：`lsblk |awk '/disk/{print $4}'`"

#磁盘总共的大小
echo "总共磁盘大小：`df -hT | awk "NR==2"|awk '{print $3}'`"

#磁盘剩余的总量
sum=(`df -T|grep -v "tmpfs"|sed '1d'|awk '{print $5}'`)
int=0
for ((i=0;i<`echo ${#sum[@]}`;i++))
do
        int=`expr  $int + ${sum[$i]}`
done
echo "磁盘剩余总量为：$int"

# 设置检测环境变量。
source /etc/profile
export LC_ALL=C
TMP_FILE=/tmp/check_tmp_file
CHECK_ID=$(id|sed -e 's/(.*$//' -e 's/^uid=//')
if [ $CHECK_ID -ne 0 ]
then
    echo -e "你不是root用户"
exit 0
fi

#网络是否可以ping通
ping -c 4 www.baidu.com > /dev/null
if [ $? -eq 0 ];then
    echo "网络连接：正常"
else
    echo "网络连接：失败"
fi


}
function_all
#fs.sh
ip=`ifconfig | grep broadcast | awk '{print $2}'`
# 文件系统
df=`df -h | grep -v '文件系统' | tr -s ' ' | tr ' ' :`

for i in $df
do
j=`echo $i | awk -F: '{print $5}' | awk -F% '{print $1}'`
k=`echo $i | awk -F: '{print $1}'`
        if [ $j -gt 80 ];then
          echo "文件系统：$k 使用量已达$j" | mail -s "报警：服务器$ip文件系统使用量超过阈值" ********@163.com
          echo "该文件系统使用量超量；不正常；请查看"
        else
          echo "文件系统：已使用量未超过正常值；一切正常！！"
        fi
done

