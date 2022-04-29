

-- 约束
-- not null
-- unique
-- default
-- primary key
-- foreign key

-- 数据库设计
-- 先找实体，再找实体间的关系。

-- 造句
-- 一对一
-- 一对多：给学生表加一列，表示班级 id
-- 多对多：使用一个关联表，来表示两个实体之间的关系

-- 插入语句增强版
-- 把插入和查询结合起来，查询的结果，作为插入语句要插入的数据（列要对应）

-- SQL 当中最复杂的就是查询：
-- 1、聚合查重：把多行之间的数据，给进行聚合了，把多个行的数据进行了关联。
--          之前带表达式的查询是（列和列之间的关联运算）

--      MySQL 提供了内置的聚合函数，可以直接来使用，在使用的时候加一个 distinct 达到去重效果
--          count   查询结果有多少行，参数是列名或者表达式
--          sum     同一列的若干行加在一起
--          avg     平均值
--          max     最大值
--          min     最小值
-- 使用之前的 exam_result 来测试
select count(*) from exam_result;
-- * 也可以换成别的

select count(chinese) from exam_result;-- 这里的值是不算 null 的

-- sum 把这一列的若干行相加   也不算 null 只能针对数字进行运算，不能对字符串进行运算
select sum(chinese) from exam_result;

-- sum 也可以表达式相加
select sum(chinese+english) from exam_result;

-- sum 求和字符串的时候就报错了，就是不正确的截断。
-- 聚合函数是可以搭配 where 来使用的。先执行筛选，后执行求和
select sum(english) from exam_result where english > 70;


-- 聚合查询：分组操作：group by 对数据进行分组，把值相同的行都分为一组    查询的是列
-- 分组之后根据每个角色的最高，最低，平均工资
create table emp(
                    id int primary key auto_increment,
                    name varchar(20) not null,
                    role varchar(20) not null,
                    salary numeric(11,2)
);
insert into emp(name, role, salary) values
                                        ('马云','服务员', 1000.20),
                                        ('马化腾','游戏陪玩', 2000.99),
                                        ('孙悟空','游戏角色', 999.11),
                                        ('猪无能','游戏角色', 333.5),
                                        ('沙和尚','游戏角色', 700.33),
                                        ('隔壁老王','董事长', 12000.66);
-- 按照岗位去进行分组，通过 group by 根据 role 来分组。 分组之后就可以针对每个组来使用聚合函数
-- 先根据 role 来分组，然后再根据分的组来选出值，然后输出
select role,max(salary),min(salary),avg(salary) from emp group by role;
-- sql 执行的时候，并不会根据写的顺序去执行
-- 也可以起别名。  有 null 的时候，求平均值的时候不计算 null
select role,max(salary) as max,min(salary) as min,avg(salary) as avg from emp group by role;

-- group by 是可以使用 where 的，因为 where 是在分组之前执行，要对分组之后操作的话，就要用 having
-- 分组的时候还可以搭配条件来使用，得到的结果通过 having 来指定条件
-- 求每种角色的平均薪资，去掉马云。（先去掉马云，在分组 所以用 where）
select role, avg(salary) from emp group by role;
select role, avg(salary) from emp where name != '马云' group by role;-- 去掉之后分组结果就没有 马云 了

-- 分组之后再筛选，求每种角色的平均工资，只保留 1w 以下的。
-- 得先知道平均工资，才能筛选，就是先分组聚合，再指定条件，就要使用 having
select role, avg(salary) from emp group by role;
select role, avg(salary) from emp group by role having avg(salary < 10000);

-- 要清楚条件是分组之前还是分组之后


-- 联合查询：把多个表的记录往一起合并，一起查询，多表查询。
-- 多表查询：sql 中最复杂的，笔试最常考的。但是实际开发当中一般禁止使用多表查询
-- 笛卡尔积：多表查询的核心操作。  笛卡尔积的计算很简单，就类似于排列组合
-- 笛卡尔积是针对任意两张表之间的运算
-- 学生表（studentId，name，classId）  1  张三  1 ，  2  李四  1 ， 3  王五  2 ， 4  赵六  2
-- 班级表（classId，name） 1  计算机100， 2  计算机101， 3 计算机102
-- 笛卡尔积计算过程：先拿第一张表的第一条记录，和第二张表的每个记录，分别组合，得到一组新的记录
-- 然后再拿第一张表的第二条记录，和第二张表的每条记录，分别组合，又得到新的记录。
-- 最终得到的记录就是笛卡尔积
-- 针对两张表计算笛卡尔积，笛卡尔积的列数，就是 A 的列数 + B 的列数
-- 笛卡尔积的行数，就是 A 的行数 * B 的行数。
-- 使用笛卡尔积的时候，数据量很大，就可能导致数据库挂掉。
-- 数据库表的行数，不是一成不变的，会持续增加
-- 如何使用笛卡尔积：最简单的做法，直接 select * from 后面跟上多个表名，表名之间用逗号隔开

-- 笛卡尔积 效率不高，但是可以借助来完成发复杂的操作。

-- 使用笛卡尔积来查询 同学姓名 和 对应的班级名字
-- 笛卡尔积 是两张表中数据军垦的排列组合得到的，在这些排列组合中，看看哪些数据是有效的，哪些是无效的。
-- 笛卡尔积是无脑的排列组合，有些数据是有意义的，有些是无意义的
-- 两张表中都有 classId 这一列，classId 的值。classId 就是连接条件。
-- 通过 连接条件就可以完成对有意义的数据的筛选
-- 通过 where 来查询
select * from student, class where student.classId = class.classId;

-- 如果笛卡尔积的两个列名相同，在写条件的时候，就可以通过 表名.列名 的方式来访问。
-- 如果列不会混淆，就可以省略表名

-- 通过筛选，得到只有两个参数的查询结果
select student.name, class.name from student, class where student.classId = class.classId;
-- 也可以起别名
select student.name, class.name as '班级' from student, class where student.classId = class.classId;

-- 多表查询很复杂，上面是一个简单情况。
drop table if exists classes;
drop table if exists student;
drop table if exists course;
drop table if exists score;

create table classes (id int primary key auto_increment, name varchar(20), `desc` varchar(100));

create table student (id int primary key auto_increment, sn varchar(20),  name varchar(20), qq_mail varchar(20) ,
                      classes_id int);

create table course(id int primary key auto_increment, name varchar(20));

create table score(score decimal(3, 1), student_id int, course_id int);

insert into classes(name, `desc`) values
                                      ('计算机系2020级1班', '学习了计算机原理、C和Java语言、数据结构和算法'),
                                      ('中文系2020级3班','学习了中国传统文学'),
                                      ('自动化2020级5班','学习了机械自动化');

insert into student(sn, name, qq_mail, classes_id) values
                                                       ('09982','黑旋风李逵','xuanfeng@qq.com',1),
                                                       ('00835','菩提老祖',null,1),
                                                       ('00391','白素贞',null,1),
                                                       ('00031','许仙','xuxian@qq.com',1),
                                                       ('00054','不想毕业',null,1),
                                                       ('51234','好好说话','say@qq.com',2),
                                                       ('83223','小菜鸡',null,2),
                                                       ('09527','老外学中文','foreigner@qq.com',2);

insert into course(name) values
                             ('Java'),('中国传统文化'),('计算机原理'),('语文'),('高阶数学'),('英文');

insert into score(score, student_id, course_id) values
-- 黑旋风李逵
(70.5, 1, 1),(98.5, 1, 3),(33, 1, 5),(98, 1, 6),
-- 菩提老祖
(60, 2, 1),(59.5, 2, 5),
-- 白素贞
(33, 3, 1),(68, 3, 3),(99, 3, 5),
-- 许仙
(67, 4, 1),(23, 4, 3),(56, 4, 5),(72, 4, 6),
-- 不想毕业
(81, 5, 1),(37, 5, 5),
-- 好好说话
(56, 6, 2),(43, 6, 4),(79, 6, 6),
-- tellme
(80, 7, 2),(92, 7, 6);
-- 上面场景中涉及到的实体有三个：学生，班级，课程
-- 学生和班级是一对多的关系
-- 学生和课程是多对多的关系
-- 分数表其实就是学生和课程之间的关联表。

select * from student;
select * from classes;
select * from course;
select * from score;

-- 查询许仙的成绩
--  许仙选了好多课，就需要在学生表当中获得姓名，然后在分数表当中，获取到分数信息。
--  就需要结合学生表和分数表进行笛卡尔积。然后查询
select * from student,score;
-- 发现笛卡尔积里面的东西太多了，当前的两张表列名，都存在学生 id 这个列
--  按照前面的规律，指定这两个 id 匹配,这样就不会生成无效信息了
select * from student,score where student.id = score.student_id;
-- 上面的查询之后，就体现了每个学生的每门课程，分数分别是多少
-- 接下来只保留许仙就好了，再加一个条件
select * from student,score where student.id = score.student_id and student.name = '许仙';
-- 最后是要 许仙的成绩，所以只保留名字和分数就好了
select student.name,score.score from student,score where student.id = score.student_id and student.name = '许仙';

-- having 是搭配 group by 使用的，group by 和 多对多也无关。
-- 刚开始不要试图一步就把 sql 语句写出来
-- 先分析数据来自于哪些表，然后笛卡尔积，观察笛卡尔积的结果，筛选合法的数据，在逐步根据要求，添加条件，让结果一步一步接近预期


-- 实现多表查询，还有另外一种写法，基于 join 这样的关键字也能实现多表查询
select student.name, score.score from student join score on student.id = score.student_id
        and student.name = '许仙';
select score.score from student stu inner join score sco on stu.id=sco.student_idand stu.name='许仙';

-- join 相比之下，还有 from 多尔表实现不了的功能。

-- join 后面多张表就是 from 表1 join 表2 on 条件 join 表3 on 条件


-- 查询所以同学的成绩，及同学的个人信息：在多表查询的基础上，再加一个聚合查询
-- 查询到每个同学的成绩，成绩是按照行来排列的
select * from student, score where student.id = score.student_id;
-- 然后分组，加上 group by 之后，记录的行数明显变少了，每个同学只剩下每个分组的第一条数据了。
select * from student, score where student.id = score.student_id group by student.id;
-- 要想得到总成绩，就要进行 sum 操作。
select student.name,sum(score.score) from student, score where student.id = score.student_id group by student.id;

-- 实际写 sql 的时候，会结合很多东西一起来写。 多表查询的时候，只是刚开始的时候难，多写几个案例，就容易找到规律

-- SQL 刷题比算法简单很多

-- 查询所有同学的成绩，及同学的个人信息
-- 这里不光要查询出同学的名字，还有课程的名字，以及分数。这个时候就涉及到三张表的联合查询了。
-- 同学名字=》学生表    课程名字=》课程表    分数=》分数表
-- 中间步揍都用 * 方便看结果，最后一行换成棘突的列
select * from student,score,course;
-- 按照前面的规律，加上链接条件,减少数据量。就得到了每个同学的每个课程的分数，而且还有课程分数
select * from student,score,course where student.id = score.student_id and course.id = score.course_id;
-- 去掉不必要的列，只留下关键的。
select student.name,course.name, score.score from student,score,course where student.id = score.student_id and course.id = score.course_id;


-- join 写多个表
select student.name, course.name, score.score from student join score on student.id = score.student_id
   join course on score.course_id = course.id;
-- 就是 from 表1 join 表2 on 条件 join 表3 on 条件

-- 既然都推荐使用 from 多个表 where 那么 join on 还有啥用
-- join on 可以做到 from where 做不到的事情。
-- 上面说的 from 多个表 where 写法叫做 “内连接”
-- 使用 join on 的写法，既可以表示内连接，还可以表示 外连接

-- 内连接
-- select 列 from 表1 inner join 表2 on 条件。   inner 表示内连接，其中 inner 可以省略
-- 外连接
-- select 列 from 表1 left join 表2 on 条件;   左外连接
-- select 列 from 表1 right join 表2 on 条件;   右外连接

-- 虽然说使用多表查询的时候，内连接用的最多，但是外连接也会用到
create table student(id int, name varchar(20), classId int);
create table class(id int,name varchar(20));

insert into student values (1, '张三', 1);
insert into student values (2, '李四', 1);
insert into student values (3, '王五', 2);
insert into student values (4, '赵六', 3);

insert into class values (1, '计算机一班');
insert into class values (2, '计算机二班');

-- 按照之前的笛卡尔积操作，少了 赵六 ，这个例子就是内连接  inner join  要求的是两个表里面都要有的数据
select * from student, class where student.classId = class.id;

-- 这个就是左外连接，就是 left join   会尽量以左边表的记录为主，尽可能的吧记录都列出来，大不了右边改成 null
select * from student left join class on student.classId = class.id;

-- 右外连接 right join   会尽量以右边表的记录为主，尽可能的吧记录都列出来，大不了左边改成 null


