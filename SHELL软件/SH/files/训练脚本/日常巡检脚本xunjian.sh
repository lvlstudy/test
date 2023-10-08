#!/bin/bash
basedir=/home/weihu1/xunjian
if [ ! -d "${basedir}" ];then
  mkdir -p ${basedir}
fi
localIP=172.18.136.11
user_sum=`cat /etc/passwd |wc -l`
filename=${basedir}/$localIP-$(date +"%Y%m%d%H")
file=${filename}.txt
echo "本次巡检开始########################################" >> ${file}
echo "本次检查的IP是：$localIP" >> ${file}
echo "本次检查开始的时间是：$(date +%Y_%m_%d-%H:%M:%S)"   >> ${file}



  usercheck(){
    echo "1.账号检测开始：" >>${file}
    echo "一.检查账号安全,,," >> ${file}
    if [ "${user_sum}" -eq  33 ];then
       echo "$localIP 的系统账号总数是33，正常" >> ${file} 
    else
       echo "可能有新增用户newuser,请check检查！！" >> ${file}
    fi
   echo "二.查询超级管理员uid为0为的用户：" >> ${file}
   sudo awk -F: '$3==0{print $1}' /etc/passwd  >> ${file}
   echo "三.查询远程登陆的账号信息，是否有未知账户：" >> ${file}
   sudo awk '/\$1|\$6/{print $1}' /etc/shadow   >> ${file}
   echo "四.查询是否有异常用户存在sudo权限的用户：" >> ${file}
  sudo  more /etc/sudoers | grep -v "^#\|^$" | grep "ALL=(ALL)" >> ${file}
  echo "-----------------------------------------" >> ${file}
}
    
  logincheck(){
    echo "登陆信息查看开始,,,"   >> ${file}
    echo "登陆成功的用户："  >> ${file}
    last |tail -30   >> ${file}
    echo "登陆失败的用户："   >> ${file}
    sudo  lastb    >> ${file}
     echo "-----------------------------------------" >> ${file}
   }

    netcheck(){
   echo "端口及网络连接情况检查开始,,,"  >> ${file}
    netstat -nuptl  >> ${file}
    echo "-----------------------------------------" >> ${file}
   }
 processcheck(){
echo "进程及CPU内存查看开始,,,"  >> ${file}
  echo "以CPU使用量进行10个进程排序："  >> ${file}
  ps -aux |head -1 >> ${file};ps -aux |sort -rnk 3 |head   >> ${file}
  echo "以内存使用量进行10个进程进行排序："  >> ${file}
  ps -aux |head  -1 >> ${file}; ps -aux |sort -rnk 4 |head    >> ${file}
  echo "-----------------------------------------" >> ${file}
   }
croncheck(){

echo  "查看任务计划开始,,,"   >> ${file}
echo "定时任务查看："  >> ${file}
sudo crontab -u root -l  >> ${file}
echo "定时任务文件查看："  >> ${file}
cat /etc/crontab  >> ${file}
echo "定时目录有哪些文件："  >> ${file}
ls /etc/cron.d/   >> ${file}
sudo ls /var/spool/cron/   >> ${file}
echo "-----------------------------------------" >> ${file}
}

startcheck(){
  echo "查看启动项开始,,,"    >> ${file}
 ls -alt /etc/init.d/  >> ${file}
cat /etc/rc.d/rc.local   >> ${file}
ls /etc/rc.d   >> ${file}
ls /etc/rc3.d    >> ${file}
cat /etc/inittab     >> ${file} 
chkconfig –list    >> ${file}
echo "-----------------------------------------" >> ${file}
}


##调用函数
usercheck
 logincheck
 netcheck
processcheck
 croncheck
 startcheck
echo "本次检查结束的时间是：$(date +%Y_%m_%d-%H:%M:%S)"   >> ${file}
echo "本次巡检结束########################################" >> ${file}
