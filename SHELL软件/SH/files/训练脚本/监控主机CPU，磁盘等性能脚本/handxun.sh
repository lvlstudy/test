#!/bin/bash
localIP=$(ifconfig eth0 |awk '/\<inet\>/{print $2}')
user_sum=`cat /etc/passwd |wc -l`
echo "本次检查的IP是：$(ifconfig eth0 |awk '/\<inet\>/{print $2}')"
echo "本次检查的时间是：$(date +%Y_%m_%d-%H:%M:%S)"
cat << EOF
1.检查账号安全
2.登陆信息查看
3.端口及网络连接情况
4.进程及CPU内存查看
5.查看任务计划
6.查看启动项
7.退出
EOF
read -p "请给个检查变量：" check
case $check in
1)
    echo "一.检查账号安全开始,,,"
    if [ "${user_sum}" -eq  33 ];then
       echo "$localIP 的系统账号总数是33，正常"
    else
       echo "可能有新增用户newuser,请check检查！！"
    fi
   echo "二.查询超级管理员uid为0为的用户："
   sudo awk -F: '$3==0{print $1}' /etc/passwd
   echo "三.查询远程登陆的账号信息，是否有未知账户："
   sudo awk '/\$1|\$6/{print $1}' /etc/shadow
   echo "四.查询是否有异常用户存在sudo权限的用户："
  sudo  more /etc/sudoers | grep -v "^#\|^$" | grep "ALL=(ALL)"
    
    ;;
2)
    echo "登陆信息查看开始,,,"
    echo "登陆成功的用户："
    last |tail -30
    echo "登陆失败的用户："
    sudo  lastb 
   ;;
3)
   echo "端口及网络连接情况检查开始,,,"
    netstat -nuptl 
   ;;
4)
echo "进程及CPU内存查看开始,,,"
  echo "以CPU使用量进行10个进程排序："
  ps -aux |head -1;ps -aux |sort -rnk 3 |head
  echo "以内存使用量进行10个进程进行排序："
  ps -aux |head -1;ps -aux |sort -rnk 4 |head 
   ;;
5)

echo  "查看任务计划开始,,,"
echo "定时任务查看："
sudo crontab -u root -l
echo "定时任务文件查看："
cat /etc/crontab
echo "定时目录有哪些文件："
ls /etc/cron.d/
sudo ls /var/spool/cron/
;;
6)
  echo "查看启动项开始,,,"
 ls -alt /etc/init.d/
cat /etc/rc.d/rc.local
ls /etc/rc.d
ls /etc/rc3.d
cat /etc/inittab
chkconfig –list
;;
7)
  echo "退出！！"
  exit 0
esac
