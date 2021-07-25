
#!/bin/bash

# 巡检脚本，用于巡检服务器磁盘，CPU负载，内存，登录用户，运行服务、日志等
echo "#########################巡检开始#########################"
echo ""
echo -e "\033[34m巡检项目：系统信息，网络信息，硬件信息，用户信息，服务信息\033[0m"
echo ""
echo "#######################检查巡检环境#######################"

# 检查系统yum源

yum_total=$(yum repolist | grep repolist | awk '{print $2}' | sed -n "s/,//p")
if [ "${yum_total}" -eq "0" ];then
echo -e "\033[31myum源异常,巡检中断，请检查\033[0m"
exit 1
else
echo -e "\033[32m巡检yum源正常\033[0m"
fi

# 检查巡检时需要的工具

for i in sysstat net-tools 
do
rpm -q $i >/dev/null 2>&1
if [ $? -ne 0 ];then
echo "$i 巡检工具未安装"
echo "$i 巡检工具正在安装"
yum -y install $i  >/dev/null
else
echo -e "\033[32m巡检工具$i正常\033[0m"
fi
done 

# 定义存放错误日志路径

[ -d /var/log/monitor ]
if [ $? -ne 0 ];then
sudo mkdir /var/log/monitor &>/dev/null
fi


OS_SYSTEM_TIME () {
echo "#########################巡检系统信息#########################"

# 系统信息

# 定义系统时间

local_time=$(date +%F-%T)

# 定义主机名

OS_name=`hostname`

# 本机公网IP地址

local_wip=$(curl -s cip.cc | awk '/IP/{print $3}')

# 本机私网IP地址

local_sip=$(ifconfig eth0 | grep netmask | awk {'print $2'})

# 服务器所在位置

ip_place=$(curl -s cip.cc | awk '/数据二/{print $3,$5}')

# 定义系统类型

OS_type=`uname`

# 定义系统版本

OS_version=`cat /etc/redhat-release`

# 定义系统内核

OS_ker=`uname -r`

# 定义系统运行时间

OS_run_time=$(uptime |awk '{print $3,$4}' | awk -F, '{print $1}')

# 定义系统最后运行时间

OS_last_reboot_time=$(who -b | awk '{print $3,$4}')

echo "当前时间：${local_time}"
echo "本机名称：${OS_name}"
echo "本机公网IP: ${local_wip}"
echo "本机私网IP: ${local_sip}"
echo "服务器所在位置: ${ip_place}"
echo "系统版本类型：${OS_type}"
echo "系统版本：${OS_version}"
echo "系统内核：${OS_ker}"
echo "系统运行时间：${OS_run_time}"
echo "系统最后运行时间：${OS_last_reboot_time}"

}
OS_SYSTEM_TIME

OS_SYSTEM_NETWORK () {
echo "#########################巡检网络信息#########################"

# 定义本机eth0网卡入站的流量

net_in=$(ifconfig eth0 | awk '/RX p/{print $6,$7}' | sed -n "s/(//p" | sed -n "s/)//p")

# 定义本机eh0网卡出站的流量

net_out=$(ifconfig eth0 | awk '/TX p/{print $6,$7}' | sed -n "s/(//p" | sed -n "s/)//p")

echo "入站网卡流量：${net_in}"
echo "出站网卡流量：${net_out}"

# 使用curl来判断网络是否能联网

curl_http=$(curl -I -s https://www.baidu.com | awk '/^HTTP/{print $2}')
if [ ${curl_http} -eq 200 ];then 
echo -e "\033[32m巡检联网状态：正常\033[0m"
else 
echo -e "\033[31m巡检联网状态：异常\033[0m"
fi
}
OS_SYSTEM_NETWORK

OS_SYSTEM_HARDWARE () {
echo "#########################巡检硬件信息#########################"

# CPU 基本信息

# 定义CPU型号

local_model=$(lscpu | grep 'Model name' | awk '{print $3,$4,$5,$6,$7,$8,$9}')

# 定义CPU个数

loca_cpu=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)

# 定义CPU核数

local_core=$(lscpu | grep -w  "^CPU(s)" | awk '{print $2}')

# 定义CPU架构

local_arch=$(lscpu | grep -w Architecture | awk '{print $2}')

# 定义CPU操作模式

local_opmode=$(lscpu | grep -w op-mode | awk '{print $3,$4}')

# 定义CPU 空闲时间%分比

local_idle=$(iostat -c |  awk 'NR==4{print $6}')

# 定义CPU 等待I/O线程所占%分比

local_steal=$(iostat -c |  awk 'NR==4{print $4}') 

# 定义系统级别(kernel)运行所使用CPU的百分比

local_system_kernel=$(iostat -c |  awk 'NR==4{print $3}')

# 定义用户级别运行所使用CPU的百分比

local_cpu_user=$(iostat -c |  awk 'NR==4{print $1}')

# 定义系统CPU平均1分钟负载

OS_system_1=$(uptime | awk -F[:,] '{print $8}')

# 定义系统CPU平均5分钟负载

OS_system_5=$(uptime | awk -F[:,] '{print $9}')

# 定义系统CPU平均15分钟负载

OS_system_15=$(uptime | awk  '{print $NF}')

echo "CPU个数：${loca_cpu}"
echo "CPU核数：${local_core}"
echo "CPU架构：${local_arch}"
echo "CPU操作模式：${local_opmode}"
echo "CPU型号：${local_model}"

echo "CPU空闲时间百分比：${local_idle}%"
echo "CPU 等待I/O线程所占百分比：${local_steal}%"
echo "CPU 系统级别(kernel)运行所使用CPU的百分比：${local_system_kernel}%"
echo "CPU 用户级别运行所使用CPU的百分比：${local_cpu_user}%"

echo "系统CPU平均1分钟负载：${OS_system_1}"
echo "系统CPU平均5分钟负载：${OS_system_5}"
echo "系统CPU平均15分钟负载：${OS_system_15}"

if [[ "${OS_system_15}"  >  3  ]];then
echo -e "\033[31m巡检CPU平均15分钟异常，请检查CPU负载\033[0m"
else
echo -e "\033[32m巡检CPU平均负载正常\033[0m"
echo ""
fi

#------------------------------------------------------------------------------

# 磁盘信息

# 系统盘总容量

xt_system_rl=$(lsblk | grep -w vda | awk '{print $4}' | awk -FG '{print $1}')

# 业务盘总容量

yw_system_rl=$(lsblk | grep -w vdb | awk '{print $4}' | awk -FG '{print $1}')

# 定义磁盘总容量=系统盘+业务盘


# 系统盘占用空间大小

xt_system=$(`which df` -h | grep -w "/" | awk '{print $5}' | awk -F% '{print $1}')

# 定义/dev/vda磁盘设备每秒I/O请求数

vda_device_xt=$(iostat -d | awk 'NR==4{print $2}')

# 定义/dev/vda磁盘每秒读取block数

vda_device_read=$(iostat -d | awk 'NR==4{print $3}')

# 定义/dev/vda磁盘每秒写入block数

vda_device_writn=$(iostat -d | awk 'NR==4{print $4}')

# 定义读入的block总数/M

vda_read=$(iostat -d -m | awk 'NR==4{print $5}')

# 定义写入的block总数/M

vda_writn=$(iostat -d -m | awk 'NR==4{print $6}')

# 业务盘占用空间大小

yw_system=$(`which df` -h | grep -w "/www" | awk '{print $5}' | awk -F% '{print $1}')

# 定义/dev/vdb磁盘设备每秒I/O请求数

vdb_device_xt=$(iostat -d | awk 'NR==5{print $2}')

# 定义/dev/vdb磁盘每秒读取block数

vdb_device_read=$(iostat -d | awk 'NR==5{print $3}')

# 定义/dev/vdb磁盘每秒写入block数

vdb_device_writn=$(iostat -d | awk 'NR==5{print $4}')

# 定义读入的block总数/M

vdb_read=$(iostat -d -m | awk 'NR==5{print $5}')

# 定义写入的block总数/M

vdb_writn=$(iostat -d -m | awk 'NR==5{print $6}')

echo "磁盘总容量：${OS_system_df_total}G"
echo ""
echo "系统盘的总容量：${xt_system_rl}G"
echo "系统盘磁盘空间占用百分比：${xt_system}%"
echo "vda磁盘设备每秒I/O请求数：${vda_device_xt}/s"
echo "vda磁盘每秒读取block数：${vda_device_read}/s"
echo "vda磁盘每秒写入block数：${vda_device_writn}/s"
echo "vda磁盘读入的block总数/M：${vda_read}/M"
echo "vda磁盘写入的block总数/M：${vda_writn}/M"

if [ "${xt_system}" -gt "80" ];then
echo -e "\033[31m系统磁盘巡检异常，超出80%请尽快清理磁盘空间或者扩容磁盘容量\033[0m"
else
echo -e "\033[32m巡检系统磁盘正常\033[0m"
fi
echo "                                                          "

echo "业务盘的总容量：${yw_system_rl}G"
echo "业务磁盘空间占用百分比：${yw_system}%"
echo "vdb磁盘设备每秒I/O请求数：${vdb_device_xt}/s"
echo "vdb磁盘每秒读取block数：${vdb_device_read}/s"
echo "vdb磁盘每秒写入block数：${vdb_device_writn}/s"
echo "vdb磁盘读入的block总数/M：${vdb_read}/M"
echo "vdb磁盘写入的block总数/M：${vdb_writn}/M"

if [ "${yw_system}" -gt "80" ];then
echo -e "\033[31m业务磁盘巡检异常，超出80%请尽快清理磁盘空间或者扩容磁盘容量\033[0m"
else
echo -e "\033[32m巡检业务磁盘正常\033[0m"
fi
echo "                                                          "
#--------------------------------------------------------

# 内存信息

# 定义内存总数/M

Mem_tolal=$(free -m | awk '/Mem/{print $2}')

# 定义已使用内存数/M

Mem_used=$(free -m | awk '/Mem/{print $3}')

# 定义空闲内存数/M

Mem_free=$(free -m | awk '/Mem/{print $4}')

# 定义多个进程共享的内存总额

Mem_shared=$(free -m | awk '/Mem/{print $5}')

# 定义缓存内存数

Mem_cache=$(free -m | awk '/Mem/{print $6}')

# 定义可用内存

Mem_free_kb=$(cat /proc/meminfo | grep Avai | awk {'print $2'})

echo "内存总数：${Mem_tolal}MB"
echo "已使用内存：${Mem_used}MB"
echo "多个进程共享内存总额：${Mem_shared}MB"
echo "空闲内存：${Mem_cache}MB"
echo "可用内存：$(( ${Mem_free_kb}/1024 ))MB"

if [ "${Mem_free_kb}" -le "3145728" ];then
echo -e "\033[31m巡检内存异常发出警告，请注意内存空闲空间低于内存总量30%\033[0m"
else
echo -e "\033[32m巡检内存正常\033[0m"
fi

}
OS_SYSTEM_HARDWARE

OS_SYSTEM_USER () {
echo "############################巡检用户信息###############################"

# 登录用户

login_user=$(last | grep "still logged in" | awk '{print $1}' | sort | uniq)

# 本机授权用户数量

user_total=$(cat /etc/passwd | grep "/bin/bash" | wc -l)

# 本机授权的用户

username_total=$(cat /etc/passwd | grep "/bin/bash$" | awk -F:  '{print $1}' | xargs)

# 当前登录本机的用户数量

user_name_total=$(who | wc -l)

echo "当前登录系统用户：${login_user}"
echo "本机授权用户数量为：${user_total}"
echo "本机授权的用户为：${username_total}"
echo "当前登录本机的用户数量：${user_name_total}"

if [[ ${user_name_total} -gt 3 ]];then
echo -e "\033[31m巡检警告！当前登录用户数量超过3个，请检查登录用户是否正常\033[0m"
else
echo -e "\033[32m巡检登录用户正常\033[0m"
fi

}
OS_SYSTEM_USER

OS_SYSTEM_SERVICE () {
echo "############################巡检服务信息###############################"

# 定义小程序的端口

dk_wnxcx=$(ss -utnlp | grep 18087 | awk -F: '{print $2}' | awk '{print $1}')

# 定义小程序后台的端口

dk_wnht=$(ss -utnlp | grep 18081 | awk -F: '{print $2}' | awk '{print $1}')

# 定义物农食堂的端口

dk_wnst=$(ss -utnlp | grep 8008 | awk '{print $5}' | awk -F: '{print $2}')

# 检测ssh登录日志，如果远程登陆账号名错误3次，则统计数量

ssh_mon=$(sudo awk '/Failed password/{print $11}' /var/log/secure  | awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' | awk '$1>3{print $2}' | wc -l)

# 检测ssh登录日志，如果远程登陆密码错误3次，则统计数量

ssh_passwd=$(sudo awk '/Invalid user/{print $10}' /var/log/secure  | awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' | awk '$1>3{print $2}' | wc -l)

echo "远程登录账号名错误3次以上统计：${ssh_mon}"
echo "远程登录密码错误3次以上统计：${ssh_passwd}"

# 定义日志路径目录权限

ml_qx=$(ls -ld /var/log/monitor/ | awk '{print $3}')
if [ "${ml_qx}"  ==  "root" ];then
sudo chown admin.admin /var/log/monitor
fi

# 小程序服务巡检 

wnxcx () {
if [ ${dk_wnxcx} == "" ];then
echo -e "\033[31m巡检小程序异常，请检查服务是否启动\033[0m"
else
echo -e "\033[32m巡检小程序服务正常\033[0m"
fi
}

# 后台服务巡检

wnht () {
if [ "${dk_wnht}" == "" ];then
echo -e "\033[31m巡检后台异常，请检查服务是否启动\033[0m"
else
echo -e "\033[32m巡检后台服务正常\033[0m"
fi
}

# 食堂服务巡检

wnst () {
if [ "${dk_wnst}" == "" ];then
echo -e "\033[31m巡检物农食堂异常，请检查服务是否启动\033[0m"
else
echo -e "\033[32m巡检物农食堂服务正常\033[0m"
fi
}


# 定义小程序日志路径

xcx_app_log () {
log_app_xcx=$(sudo find /www/service -name 18087* -type d)/webapps/ROOT/WEB-INF/logs/
cd ${log_app_xcx}
xcx_log=$(sudo egrep "有误|error"  info)
if [ "${xcx_log}"  !=  "" ];then
sudo egrep "有误|error"  info  >>/var/log/monitor/error87-`date +%F-%T` 
echo -e "\033[031m巡检小程序日志有错误日志，已保存到/var/log/monitor\033[0m"
else
echo -e "\033[32m巡检小程序日志正常\033[0m"
fi
}

# 定义后台日志路径

ht_app_log () {
log_app_ht=$(sudo find /www/service -name 18081* -type d)/webapps/ROOT/WEB-INF/logs/
cd ${log_app_ht}
ht_log=$(sudo egrep "有误|error"  info 2>&1)
if [ "${ht_log}" !=  "" ];then
sudo egrep "有误|error"  info >>/var/log/monitor/error81-`date +%F-%T`
echo -e "\033[31m巡检后台日志有错误日志，已保存到/var/log/monitor\033[0m"
else
echo -e "\033[32m巡检后台日志正常\033[0m"
fi
}

# 定义物农食堂的日志

wnst_app_log () {
wnst_log=$(sudo egrep  "error|ERROR|错误" /root/nohup.out | grep `date +%F` 2>&1)
if [ "${wnst_log}" != "" ];then
sudo egrep  "error|ERROR|错误" /root/nohup.out | grep `date +%F` >>/var/log/monitor/error-`date +%F-%T` 
echo -e "\033[31m巡检物农食堂日志有错误日志，已保存到/var/log/monitor\033[0m"
else
echo -e "\033[32m巡检后台日志正常\033[0m"
fi
}

SYSTEM_LOG() {

# 因执行脚本就会产生一个新的错误日志，为了节约空间脚本当天只能有一个错误日志

log_ql=$(ls /var/log/monitor/ | grep `date +%F` | wc -l)
if [ "${log_ql}" -ne "0" ];then
find /var/log/monitor/ -name "*-`date +%F`-*" -exec rm "{}" \;
fi
}

if [ "`echo $HOSTNAME`" == "wnkj-test" ];then

# 定义小程序的进程

xcx_jc=$(sudo netstat -utnlp | grep 18087 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义小程序服务占用CPU百分比

xcx_cpu=$(top -b -n 1 | grep ${xcx_jc} | awk '{print $9}' | xargs | awk '{print $1}')

# 定义后台的进程

xcx_ht=$(sudo netstat -utnlp | grep 18081 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义后台服务占用CPU百分比

ht_cpu=$(top -b -n 1 | grep ${xcx_ht} | awk '{print $9}' | xargs | awk '{print $1}')

# 定义小程序服务占用内存的百分比

xcx_mem_tj=$(top -bn1 | grep ${xcx_jc} | awk '{print $10}')

# 定义后台服务占用内存的百分比

xcx_mem_ht=$(top -bn1 | grep ${xcx_ht} | awk '{print $10}')

echo "小程序的端口：${dk_wnxcx}"
echo "后台的端口：${dk_wnht}"
echo "小程序的CPU占用率：${xcx_cpu}%"
echo "后台的CPU占用率：${ht_cpu}%"
echo "小程序的内存占用率：${xcx_mem_tj}%"
echo "后台的内存占用率：${xcx_mem_ht}%"
wnxcx
wnht
SYSTEM_LOG
xcx_app_log
ht_app_log
elif [ "`echo $HOSTNAME`" == "wnkj-service" ];then

# 定义小程序的进程

xcx_jc=$(sudo netstat -utnlp | grep 18087 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义小程序服务占用CPU百分比

xcx_cpu=$(top -b -n 1 | grep ${xcx_jc} | awk '{print $9}' | xargs | awk '{print $1}')

# 定义小程序服务占用内存的百分比

xcx_mem_tj=$(top -bn1 | grep ${xcx_jc} | awk '{print $10}')
echo "小程序的端口：${dk_wnxcx}"
echo "小程序的CPU占用率：${xcx_cpu}%"
echo "小程序的内存占用率：${xcx_mem_tj}%"
wnxcx
SYSTEM_LOG
xcx_app_log
elif [ "`echo $HOSTNAME`" == "wnkj-web1" ];then

# 定义小程序的进程

xcx_ht=$(sudo netstat -utnlp | grep 18081 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义小程序服务占用CPU百分比

ht_cpu=$(top -b -n 1 | grep ${xcx_ht} | awk '{print $9}' | xargs | awk '{print $1}')

# 定义小程序服务占用内存的百分比

xcx_mem_ht=$(top -bn1 | grep ${xcx_ht} | awk '{print $10}')
echo "小程序的端口：${dk_wnht}"
echo "小程序的CPU占用率：${ht_cpu}%"
echo "小程序的内存占用率：${xcx_mem_ht}%"
wnht
SYSTEM_LOG
ht_app_log
elif [ "`echo $HOSTNAME`" == "wnkj-web2" ];then

# 定义小程序的进程

xcx_ht=$(sudo netstat -utnlp | grep 18081 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义小程序服务占用CPU百分比

ht_cpu=$(top -b -n 1 | grep ${xcx_ht} | awk '{print $9}' | xargs | awk '{print $1}')

# 定义小程序服务占用内存的百分比

xcx_mem_ht=$(top -bn1 | grep ${xcx_ht} | awk '{print $10}')
echo "小程序的端口：${dk_wnht}"
echo "小程序的CPU占用率：${ht_cpu}%"
echo "小程序的内存占用率：${xcx_mem_ht}%"
wnht
SYSTEM_LOG
ht_app_log
elif [ "`echo $HOSTNAME`" == "wnst" ];then

# 定义物农食堂的进程

wnst_jc=$(sudo netstat -utnlp | grep 8008 | awk '{print $7}' | awk -F/ '{print $1}')

# 定义物农食堂服务占用CPU百分比

wnst_cpu=$(top -b -n 1 | grep ${wnst_jc} | awk '{print $9}' | xargs | awk '{print $1}')
wnst_mem_tj=$(top -bn1 | grep ${wnst_jc} | awk '{print $10}')
echo "物农食堂的端口：${dk_wnst}"
echo "物农食堂的CPU占用率：${wnst_cpu}%"
echo "物农食堂的内存占用率：${wnst_mem_tj}%"
wnst
SYSTEM_LOG
wnst_app_log
else
echo -e "\033[31m巡检不到这台主机的服务\033[0m"
fi

}
OS_SYSTEM_SERVICE

echo ""
echo "##############################巡检结束############################"

