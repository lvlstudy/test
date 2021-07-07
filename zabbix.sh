#!/bin/bash
systemctl disable firewalld --now
sed -i "/SELINUX/s/enforcing/disabled/" /etc/selinux/config
hostnamectl set-hostname nanjing1
ip=`ifconfig  | awk '/inet 192/{print $2}'` 
name=`hostname`
#安装软件包及依赖包!
yum -y install gcc pcre-devel  openssl-devel
yum -y install php php-mysql php-fpm openldap openldap-devel php-ldap
yum -y install mariadb mariadb-devel mariadb-server
yum -y install  net-snmp-devel curl-devel php-gd php-xml php-bcmath  php-mbstring
systemctl enable --now mariadb
systemctl enable --now php-fpm
#部署web服务 (请先把要用到的服务包拷贝到目标主机)
cd 
yum -y install  libevent-devel
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --with-http_ssl_module
 make && make install
#修改配置文件
nginx=/usr/local/nginx/conf/nginx.conf
sed -i '65,71s/#//' $nginx                   			#67-71行删除注释
sed -i '/SCRIPT_FILENAME/d'  $nginx			 			#删除SCRIPT_FILENAME开头的行
sed -i 's/fastcgi_params/fastcgi.conf/' $nginx			#把fastcgi_params改为fastcgi.conf
sed -i 's/index  index.html index.htm;/index  index.php index.html index.htm;/' $nginx
sed -i '/http {/a \fastcgi_buffers 8 16k;'  $nginx		#缓存php生成的页面内容，8个16k
sed -i '/fastcgi_buffers 8 16k;/a \fastcgi_buffer_size 32k;'  $nginx		#缓存php生产的头部信息，32k
sed -i '/fastcgi_buffer_size 32k;/a \fastcgi_connect_timeout 300;'  $nginx	#连接PHP的超时时间，300秒
sed -i '/fastcgi_connect_timeout 300;/a \fastcgi_send_timeout 300;'  $nginx	#发送请求的超时时间，300秒
sed -i '/fastcgi_send_timeout 300;/a \fastcgi_read_timeout 300;'  $nginx	#读取请求的超时时间，300秒
/usr/local/nginx/sbin/nginx
echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.d/rc.local
chmod +x /etc/rc.local
#部署监控服务
cd
tar -xf zabbix-3.4.4.tar.gz
cd zabbix-3.4.4/
./configure --enable-server --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl
make && make install
#部署数据库服务
mysql -e "create database zabbix character set utf8;"		#创建数据库zabbix，utf8支持中文字符集
mysql -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';"	#创建数据库访问用户名zabbix密码zabbix
cd /root/zabbix-3.4.4/database/mysql/
# 使用mysql导入数据（注意导入顺序）
mysql -uzabbix -pzabbix zabbix < schema.sql
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql
cd /root/zabbix-3.4.4/frontends/php/
cp -r * /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*
#修改zabbix-server配置文件
zabbix=/usr/local/etc/zabbix_server.conf
sed -i '85s/#//' $zabbix								#去掉85行的注释
sed -i 's/# DBPassword=/DBPassword=zabbix/' $zabbix		#设置数据库密码
useradd -s /sbin/nologin zabbix
zabbix_server
#修改zabbix-agent配置文件
zabb=/usr/local/etc/zabbix_agentd.conf
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,$ip/" $zabb					#允许哪些主机监控本机
sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,$ip/"  $zabb	#允许哪些主机通过主动模式监控本机
sed -i "s/Hostname=Zabbix server/Hostname=$name/"  $zabb				#设置本机主机名（名称可以任意）
sed -i "s/# UnsafeUserParameters=0/UnsafeUserParameters=1/" $zabb		#是否允许自定义监控传参
zabbix_agentd
#修改php配置文件
php=/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' $php		#设置时区
sed -i 's/max_execution_time = 30/max_execution_time = 300/' $php		#最大执行时间，单位为秒
sed -i 's/max_input_time = 60/max_input_time = 300/' $php				#POST数据最大容量
sed -i 's/post_max_size = 8M/post_max_size = 32M/' $php					#服务器接收数据的时间限制
systemctl restart php-fpm
/usr/local/nginx/sbin/nginx -s reload
echo -e "\033[33m配置完成,请在浏览器输入 http://${ip}进行初始化配置\033[0m"

