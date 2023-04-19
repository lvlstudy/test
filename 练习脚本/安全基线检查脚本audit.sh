#!/bin/bash

# 定义变量
DATE=`date +%Y-%m-%d_%H:%M:%S`
LOG_FILE="/var/log/security_audit_${DATE}.log"

# 记录系统基本信息
echo -e "===================== SYSTEM INFO =====================" >> ${LOG_FILE}
echo -e "Hostname: `hostname`" >> ${LOG_FILE}
echo -e "Kernel version: `uname -r`" >> ${LOG_FILE}
echo -e "OS version: `cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2`" >> ${LOG_FILE}
echo -e "========================================================" >> ${LOG_FILE}

# 检查用户管理
echo -e "==================== USER MANAGEMENT ===================" >> ${LOG_FILE}
# 检查root用户是否被锁定
if [[ `passwd -S root | awk '{print $2}'` == "L" ]]; then
    echo -e "root account is locked." >> ${LOG_FILE}
else
    echo -e "root account is not locked." >> ${LOG_FILE}
fi
# 检查是否存在非法用户
if [[ `grep "^+" /etc/passwd` != "" ]]; then
    echo -e "Found invalid user account(s):" >> ${LOG_FILE}
    grep "^+" /etc/passwd >> ${LOG_FILE}
else
    echo -e "No invalid user account found." >> ${LOG_FILE}
fi
echo -e "========================================================" >> ${LOG_FILE}

# 检查文件权限
echo -e "====================== FILE PERMISSION ==================" >> ${LOG_FILE}
# 检查是否存在权限过大的文件
echo -e "Files with permission greater than 644:" >> ${LOG_FILE}
find / -type f -perm /022 -print >> ${LOG_FILE}
# 检查敏感文件权限
echo -e "Sensitive files permission status:" >> ${LOG_FILE}
ls -l /etc/passwd /etc/shadow /etc/group >> ${LOG_FILE}
echo -e "========================================================" >> ${LOG_FILE}

# 检查网络连接
echo -e "====================== NETWORK INFO ====================" >> ${LOG_FILE}
# 检查开放的端口
echo -e "Open ports:" >> ${LOG_FILE}
netstat -tunlp | grep LISTEN >> ${LOG_FILE}
# 检查连接情况
echo -e "Active connections:" >> ${LOG_FILE}
netstat -an | grep ESTABLISHED >> ${LOG_FILE}
echo -e "========================================================" >> ${LOG_FILE}

echo -e "Security audit completed." >> ${LOG_FILE}
