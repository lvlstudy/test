数据库的增删改查

--中文
--先告诉服务器，客户端是什么编码,如果编码不对，会出现一堆乱码
--连接断开之前，服务器可以记住这个编码
set names gbk
set names utf8
-- 插入数据   如果不指定字段，会默认所有字段
insert into db1.stu
values(6,'张三','男','1996-8-4')
--  查询stu表数据  是否创建成功    select * from stu
--插入ID，name的值
insert into db1.stu(name,id) values('lisi',5);
insert into db1.stu(id,name) values(8,"王五")
insert into db1.stu(id,name) values(9,"haha"),(10,"xixi");



--update修改数据
--把张三的信息进行更改
update db1.stu set gender="女",birthday="1998-8-4" where id=6;


--delete删除数据       删除如果不指定条件，会删空表，一般要加一定的条件
1删除id>8的数据
delete from stu
where id >8;



select  查询所有stu表数据 select * from db1.stu
        查询指定的表数据，不是所有数据   select name,gender from db1.stu
 举例： select id,fname,lname,sal,dept_id
 from emps;从员工表中去查询相应的表数据id,员工名字，工资，部门编号等
 
 
 where 子句 设置过滤条件   <>不等于：有点像shell脚本里的！的用法           =等于：就是等于的用法
 select id,fname,lname,sal,dept_id from emps where id=122; 员工id是122的那一条人员相应信息
 select id,fname,lname,sal,dept_id from emps where dept_id=30; 部门编号是30的相应信息
 select id,fname,lname,sal,dept_id from emps where job_id='IT_PROG'工作岗位代码是程序员工作的相应信息
 select id,fname,lname,sal,dept_id from emps where dept_id<>50; 部门编号不是50的相应信息