进入命令行
一：连接本机服务器，登录服务器
mysql -uroot -p  不要明文登录，这样安全些
查看数据库show databases;           查看当前数据库是谁select database();
进入数据库use test;       use mysql;
查看数据表 show tables
查看数据表结构（表头）      desc user;


二：建库
-- 删除db1库
drop database if exists db1;
-- 重新创建db1库
create database db1 
charset utf8; #制定字符编码


三：建表
--删除 stu学生表
 drop table if exists stu;
-- 创建学生stu表
create table stu (
id int,
name varchar(20),
gender char(1),
birthday date
);



四：数据类型
数字：tinyint smallint int bigint float double decimal
字符串：  
char  最长255个字符(举例：身份证号，手机号，不管之前设置的几位加密过后的用户密码32位)   
varchar      最长65535个字符（不确定长度的时候，先指定最大长度）
text 长文本类型
日期时间:
date
time
datetime
timestamp时间戳  与datetime存储相同的数据         最大2038年  在插入数据与修改数据，可以自动更新成系统当前时间