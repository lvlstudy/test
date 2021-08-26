mysql 数据库查询顺序
select  字段
from  表
where
order by
1  where 过滤
2 选取字段
3 order by 排序




--单引号
字符串内容中的单引号，用两个单引号进行转义
'I''m Abc'
use db1;
insert into db1.stu(id,name) values(6433,'I''m Xxx');   #两个单引号转义成一个单引号，否则的话会造成误会
select * from db1.stu



sql注入攻击
--通过在sql语句中注入单引号，来改变sql语句结构
user
id        username     password
1         abc           123
2        def            456
3        ghi            789
用户名：def
密码：456
   1’ or '1'='1'
select * from user
where username='def'
and password='1' or '1'='1'
防止注入攻击
用户填写的内容，所有单引号，都变成两个单引号
select * from user
where username='def'
and password='1'' or ''1''=''1'




--函数
字符串函数   char_length(字符串）字符数
             length(字符串）字节数
			 left(字符串，length）获得左侧字符
			  substring(字符串，start，length)截取字符串
			  instr(字符串，子串）查找子窜位置
			  concat(s1,s2,s3...)拼接函数，将字符串连接起来
			  lpad(字符窜，3，’*’）左侧填充
			  rpad..................右侧填充
--fname 和 lname 首字母相同
select id,fname,lname,sal,dept_id
from emps
where left(fname,1)=left(lname,1)
--#第二种写法
select id,fname,lname,sal,dept_id
from emps
where substring（fname,1,1)=substring(lname,1,1);



--fname和lname连接起来，再对齐中间的空格
select concat(lpad(fname,20,''),'',lname)
from emps
  sd fd
    hgedfdsdf
df    dfg fsd
fs   dfg
   sd dfgdfg

			  
			  
			  
数字函数  
ceil()   向上取整     天花板
floor()  向下取整      地下板
round（数字，2）四舍五入到小数点2位
truncate(数字，2)舍弃到小数点2位
rand（）随机数【0，1）
--工资上涨11.31%，向上取整到10位
select id,fname,sal,ceil(sal*1.1131/10)*10
from emps

--所有员工随机排序(没有规律的排序)
select id,fname,sal,dept_id
from emps
order by rand();



日期函数   
now()当前日期时间
currdate()当前日期
currtime()当前时间
extract(year from 日期)
date_add(日期，interval值)    在指定字段上加一个值
datediff(日期1，日期2)相差多少天

--  查询系统当前时间
select now()
--查询1997年入职的所有员工
select id,fname,hdate
from emps
--where hdate between '1997-01-01'
--and '1997-12-31';
where extract(year from hdate)=1997;

--员工已入职多少年

select id,fname,hdate,datediff(now(),hdate)/365 #两个日期之间相差多少天再除以365得到年数
y #起了一个别名y
from emps
order by y;



null值函数 
 
ifnull(a,b)
a不是null,返回a
a是null,返回b



--年薪*提成
select id,fname,sal,sal*12*(1+ifnull(com_pct，0) ) t#起了一个别名t,有提成加上去，没提成按0算 
from emps
order by t desc;









