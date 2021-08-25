--where 子句   设置过滤条件
=      等值过滤                 相当于shell脚本里的eq的用法
<>     不等过滤，相当于取非     相当于shell脚本里的！的用法
> >= < <=                       相当于shell脚本里的 le lt ge gt的用法 
between 小 and 大     >= 小  并且  <= 大
in(1,4,5,6)          在指定的一组值中取值
is null  is not null        是null  不是null
like   字符串模糊查询
       %通配多个字符
	   _通配单个字符
	   \%
	   \_
	   \\
模糊查查询示义  a 中有abc_def         ab_cdef
a like  'ab%'  结果两个数据都出来  
a like  'ab\_%'  结果只有ab_cdef数据出来 因为\对下划线进行了转义，
下滑线只是普通的下滑线字符，不再是特殊的通配符
a like  'ab\%'  下滑线对百分号进行了转义，他不再是通配符百分号，而是简单的
百分号字符而已
---- not   not between  and
           not in()
		   is not null
		   not like
------and      并且
------or       或者
and 和 or 比较多的时候加小括号来指明他的优先级，不要依赖于谁的优先级高



--distinct    去除重复值
select distinct a from ...
去除a字段的重复值
select distinct a,b from ...  
去除a,b字段组合的重复值



排序 order by a
按a字段升序排列
order by a,b按a字段升序排列,a相同，再按b来升序排列
order by a asc(asc可以省略，因为是默认的）
order by a desc 按降序排列
order by a desc,b (asc可以省略，因为是默认的）
order by a desc,b desc


--举例：



-- 工资sal >5000
select id,fname,sal,dept_id 
from emps
where sal>5000
--工资范围【5000，8000】
select id,fname,sal,dept_id
from emps
where sal>=5000 and sal<=8000;
--
select id,fname,sal,dept_id
from emps
where sal between 5000 and 8000;



--id是120，122，100，150
select id,fname,sal,dept_id
from emps
where id in(120,122,100,150);
--
select id，fname,sal,dept_id
from emps
where id=120 or id=122 or id=100 or id=150

select id，fname,sal,dept_id
from emps
where dept_id is null;    #此处不能够使用=过滤

select id，fname,sal,dept_id
from emps
where com_pct is not null;    #此处不能使用<>来过滤

--fname中包含en
select id,fname,sal,dept_id
from emps
where fname like '%en%';
--fname 第三，四个字符是en
select id,fname,sal,dept_id
from emps
where fname like '__en%';



--查询所有部门id
select distinct dept_id from emps
where dept_id is not null;

--查询50部门员工，按工资降序

select id,fname,sal,dept_id
from emps
where dept_id=50            #先过滤再排序
order by sal desc;

--所有员工，按部门升序，相同部门按工资降序
select id,fname,sal,dept_id
from emps
order by dept_id,sal desc

