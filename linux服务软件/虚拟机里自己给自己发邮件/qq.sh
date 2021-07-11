#!/bin/bash
EMAIL_RECIVER="1654312316@qq.com"
EMAIL_SENDER="1654312316@qq.com"
EMAIL_USERNAME=1654312316
EMAIL_PASSWORD=qlncdlschsgdbbfd
FILE1_PATH="/root/sh/sendEmail-v1.56.tar.gz"


EMAIL_SMTPHOST=smtp.qq.com


EMAIL_TITLE="test"
EMAIL_CONTENT="您好"
sendEmail -f ${EMAIL_SENDER} -t ${EMAIL_RECIVER} -s ${EMAIL_SMTPHOST} -u ${EMAIL_TITLE} -xu ${EMAIL_USERNAME} -xp ${EMAIL_PASSWORD} -m ${EMAIL_CONTENT} -a ${FILE1_PATH} -o message-charset=utf-8 -o tls=no
