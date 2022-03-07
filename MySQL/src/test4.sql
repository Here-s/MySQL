


-- 聚合查询：行和行之间的数据的加工
-- 聚合函数：count  sum  avg.....
-- group by 进行分组，指定列的值，相同的记录合并到一个组，每个组又可以进行聚合查询
--      分组还可以指定筛选条件，如果分组之前指定条件，使用 where 如果是分组之后使用条件，使用 having
-- 联合查询（多表查询）：和前面的单表查询相对应
-- 关键操作：笛卡尔积
-- 左外连接，右外连接


-- 自连接：自己和自己笛卡尔积，处理特殊场景的问题。
-- 自连接：把行转化为列。因为也是笛卡尔积，所以还是并不高效的方法
select * from score as s1, score as s2;-- 指定别名，不然自连接会重名
-- 筛选一些：按照 student_id 来筛选笛卡尔积。这样的话同一列的两行就变成同一行了。
select * from score as s1, score as s2 where s1.student_id = s2.student_id;
-- 再加一些筛选条件，就会让结果越来越精确
select * from score as s1, score as s2 where s1.student_id = s2.student_id and s1.course_id=3 and s2.course_id=1;


-- 子查询：套娃。把多个 select 合并成一个。应该废除掉。
-- 子查询就是把拆分好的代码合并成一个
-- 封装：是顺着人脑的特点来展开。只关注一个点，不考虑太多细节

-- 单行子查询：返回一条记录：例如查询”不想毕业“同学的同班同学
-- 要先知道班级，然后才能知道同班同学。正常是两个语句来查询
select classes_id from student where name = '不想毕业';
select name from student where classes_id = 1;

-- 子查询就是把两个 SQL 合并为一个
select name from student where classes_id = (select classes_id from student where name = '不想毕业');

-- 写代码要写到易读性高
-- 有时候子查询肯会查询出多条记录，不能用 = 用 in 这样的操作
-- 多行子查询：返回多行记录的子查询
-- 先查询语文和英语的课程，然后再查询课程的成绩

select id from course where name = '语文' or name = '英文';
select * from score where course_id in (4,6);

-- 使用子查询，写成一条语句
select * from score where course_id in (select id from course where name = '语文' or name = '英文');


-- 合并查询：把多个查询语句的结果合并到一起了
-- union：表示联合的意思，把查询的结果放到一起。对两个查询结果取并集。可以自动去重
--      把两个 SQL 的查询结果合并起来，前提是列相同
-- union all   不能自动去重
-- C语言是校招硬通货
select * from course where name = '英文' union select * from course where id < 3;

-- 也可以这样写。使用 or 的时候必须保证是针对同一个表来进行操作的
select * from course where name = '英文' or id < 3;

-- 找实习和找到实习是两回事
-- 找到实习和入职，也是两回事。只有百分之十的学生能找到靠谱的实习（找实习可能得消耗三个月）
-- 投简历和面试的过程就是巨大的提升了。鼓励找实习
-- 实习对秋招影响很大。有实习经历的人，对其他人绝对是碾压。哪怕是 985 211
-- 有实习经历的话，拿个 30w 基本没问题

