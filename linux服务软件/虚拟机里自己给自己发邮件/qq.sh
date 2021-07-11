#!/bin/bash
#收件箱
EMAIL_RECIVER="1654312316@qq.com"
#发送者邮箱
EMAIL_SENDER="1654312316@qq.com"
#邮箱用户名
EMAIL_USERNAME=1654312316
#邮箱授权码，注意不是qq的登录密码，这个是要开启smtp服务
EMAIL_PASSWORD=qlncdlschsgdbbfd
#附件路径（所发文件的路径）
FILE1_PATH="/root/sh/sendEmail-v1.56.tar.gz"

#smtp服务器的地址
EMAIL_SMTPHOST=smtp.qq.com

#邮件主题
EMAIL_TITLE="test"
#邮件正文
EMAIL_CONTENT="您好"
#最后要加tls=no;否则会报perl版本不兼容的就报错提示，发不了邮件！！！
sendEmail -f ${EMAIL_SENDER} -t ${EMAIL_RECIVER} -s ${EMAIL_SMTPHOST} -u ${EMAIL_TITLE} -xu ${EMAIL_USERNAME} -xp ${EMAIL_PASSWORD} -m ${EMAIL_CONTENT} -a ${FILE1_PATH} -o message-charset=utf-8 -o tls=no
