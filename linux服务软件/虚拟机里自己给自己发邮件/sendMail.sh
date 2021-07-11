#!/bin/bash
wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
mkdir -p /usr/local/bin
tar -zxf sendEmail-v1.56.tar.gz -C /usr/src
cd /usr/src/sendEmail-v1.56/
cp -a sendEmail /usr/local/bin
chmod +x /usr/local/bin/sendEmail
yum install perl-Net-SSLeay perl-IO-Socket-SSL -y

