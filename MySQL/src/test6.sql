


-- JDBC 编程：实际开发程序非常必要的过程
-- 黑框框是 MySQL 官方提供的客户端，官方也允许程序员自己实现 MySQL 客户端。MySQL 提供了一组 API 来支持实习这样的客户端
-- 自己实现客户端就可以根据需要来完成一些具体的增删查改功能。
-- API ：应用程序编程接口
-- 不同的数据库提供了不同的 API 。不同的数据库的 API 也不一样。没有同意的标准。
-- Java 诞生就是为了跨平台，于是就高了一个大一统的方案 JDBC
-- Java 约定了一组 API 称为 JDBC 这组 API 里面就包含了一些类和一些方法，通过这些类和方法来实现数据库的基本操作
-- 再有各个厂商，提供各自的：数据库驱动包 来和 JDBC 的 API 对接。
-- 会了 JDBC 就可以操作各种数据库了

-- 在学校可能会遇到“统计学生信息”的情况，班主任约定好固定的格式，让各个班长去按照统一的格式

-- JDBC 编程要引入依赖（第三方库）。1、下载驱动包：MySQL 官方网站，MySQL 被 Oracle 收购了。所以不方便下载
--      因为不方便下载，所以就去 maven 中央仓库去下载。于是就把 第三方库 汇总起来放到 maven 中央仓库 里面
--      2、导入项目
--          a、创建一个目标，随便起名字
--          b、把 jar 文件拷贝到创建的目录当中
--          c、右键创建的目录，有一个选项 “Add as Library”
--      3、编写代码
-- 中央仓库就是手机的 应用商店

select dep.name, sum(sal.salary) from salary sal join staff sta on sal.staff_id = sta.staff_id
 join depart depth on sta.depart_id = dep.depart_id where year(sal.month) = 2016 and
 month(sal.month) = 9 group by dep.depart_id;

select dep.name, connt(sta.staff_id) from staff sta join depart dep on
    dep.depart_id = sta.depart_id group by sta.depart_id;

select dep.name,sum.month,sum(sal.salary) from depart dep join staff sta on dep.depart_id =
    sta.depart_id join salary sal on sta.staff_id = sal.staff_id group by
    dep.depart_id,sal.month;

select max(salary) as sacondhighestsalary from employee where salary <
    (select max(salary) from employee);