


-- 设计一张图书表，包含以下字段：图书名称，图书作者、图书价格、图书分类
create table book (name varchar(50), author varchar(20), price int, classify varchar(50));
-- 在图书表中新增一条记录：Java核心技术、作者“Cay S. Horstman”，价格56.43，分类为“计算机技术”
insert book values ('Java核心技术','Cay SHorstman',63 ,'计算机技术');
-- 删除商品表中，价格大于60，或者是库存小于200的记录
delete from book where price > 60 or classify < 200;

-- 设计一张老师表，包含以下字段：姓名、年龄、身高、体重、性别、学历、生日、身份证号
create table teacher (name varchar(20), age int, height double,
weight double, sex bit, Degree varchar(20), birthday timestamp, id_num varchar(18));

-- 设计一张商品表，包含以下字段：商品名称、商品价格、商品库存、商品描述
create table goods (name varchar(50), price decimal(11,2), inventory int, details varchar(100));


-- 进阶的增删查改
-- 数据库的约束：就是数据库在使用的时候，对于里面能够的数据提出要求和限制。可以借助约束来完成更好的体验。
-- 这里的约束，都是针对列来操作的
-- NOT NULL 某列不能插入空值。如果插入空值，就会报错
create table student (id int not null, name varchar(20) not null);-- 这俩就都不能是 null 了

-- UNIQUE  保证某列的每行必须有唯一的值，插入重复的值，就会报错。
-- MySQL 是如何发现：新的数据和之前的是重复的呢，类似于 二叉搜索树 的插入一样。和后面的索引相关。
create table student (id int unique, name varchar(20));

-- DEFAULT  规定没有给列赋值的时候约定一个默认值
create table student(id int, name varchar(20) default '匿名');

-- PRIMARY KEY：有主键约束，相当于数据的唯一身份标识，类似于身份证。
-- 日常开发当作最重常使用的约束！！！ 最重要的约束。 创建表的时候，很多时候都需要指定主键。
-- 对于一个表来说，只能有一个列被列为主键。 设为主键之后，不能为 null 不能重复
create table student (id int primary key, name varchar(20));

-- 主键：典型的用法，就是直接使用 1，2，3，4 整数递增的方式来表示
-- MySQL 里面对于这种递增的主键，是有内置支持的，称为”自增主键“
-- 设置好自增主键的之后，此时插入记录，就可以不指定自增主键的值了（直接使用 null），交给 MySQL 自行分配即可。
-- 每次新增一个新的记录，都会产生一个自增的 id
-- 如果在 自增主键 当中输入一个 id 之后，那么原来自增的 id 到输入的 id 之间的值就不能用了。
create table student (id int primary key auto_increment, name varchar(20));

-- FOREIGN KEY：描述两个表之间的关联关系，表1 里的数据，必须在 表2 中存在
-- CHECK：指定一个条件，通过这个条件来对值进行判定。

-- 只插入一列，直插入了 id 没有插入 name
insert into student (id) values (1);



-- 进入公司之后，需要操作线上数据库，自己害怕整出事来，就拉上一个人，一起看看。降低问题出现概率

-- 删除操作：使用 delete 语句
-- delete from 表名 where 条件;
delete from exam_result where id = 6;-- 一旦条件写错了，可能影响范围就会很大。
-- 删掉表所有的数据   得到的是一个 空表     drop 的话，表也没有了
delete from exam_result;


-- update 面试的时候 有一半的人写不对。


-- 修改 update 表名 set 列名 = 值，列名 = 值 where 条件; where 后面的条件，是针对哪些进行修改。
-- 符合 where 条件的就会修改，不符合就不修改。如果 where 省略了，就是修改所有记录。

-- insert 和 表名 之间，有个 into
-- select 和 表名 之间，有个 from
-- update 和 表名 之间，啥都没有
-- delete 和 表名 之间，有个 from

-- 另外，除了 where 之外，想 order by 和 limit 也是可以使用的。
-- update 是会修改服务器上的原始数据的。
update exam_result set math = 98 where name = 'qqq';-- 如果条件写错了，修改的范围可能会更大或者更小
-- 没有直接的撤销操作，只能再一次改回去。
-- 修改如果出现误操作，危害可能比 删库 还来的严重。
-- 对于删库，一般公司都有预案，可以快速还原回去。
-- 对于误修改，最麻烦的是有些修改了，有些没修改。就导致还原的时候得仔细校对，哪些要改，哪些不能改。很难进行修改。
-- 数据往往就是一个公司的命脉。
-- 一次改两个列
update exam_result set math = 60, chinese = 70 where name = 'uuu';
-- 给总成绩倒数前三的数学成绩加上 30
select name,chinese + math + english from exam_result order by chinese + math + english limit 3;
-- 因为这里是 4 位有效数字，所有就会报错。之前约定的数据是 三位有效数字
update exam_result set math = math + 30 order by chinese + math + english limit 3;
-- 所以改为 + 10
update exam_result set math = math + 10 order by chinese + math + english limit 3;
-- 如果要修改表里的所有数据，只要不加 where 就可以了。
-- 修改所有语文成绩，修改为原来的 一半
update exam_result set chinese = chinese / 2;
-- 可以通过重新建表 alter table 来修改表结构
-- 查看警告：show warnings



-- select * from 表名; 对于生产环境的数据库来说，非常危险。危险不危险，看的是返回的数据量多还是少
-- 返回的数据量少，其实就还好，返回的数据量大，就比较危险。可以通过下面两种方法让线程更安全。
-- 1、通过 where 限制
-- 2、通过 limit 来进行更危险的限制。


-- 分页查询：就可以约定好，每页可以显示多少个结果。在查找的时候就按照页来返回。假设一页返回 20 条记录。
-- 在 SQL 当中 通过 limit 来实现分页查询
-- 一页显示三条记录
select * from exam_result limit 3;
-- 获取到下三条。就是从下标为 3 的地方开始查询。
select * from exam_result limit 3 offset 3;
-- limit 也可以搭配 条件，以及 order by 等操作来组合使用
select name,chinese + math + english as total from exam_result order  by total desc limit 3;


-- 对于 SQL 的学习，没有什么难点。多多练习，熟练就好


-- MySQL 中的 select
-- 1、全列查找：select * from 表名;
-- 2、指定列查找：select 列名，列名 from 表名;
-- 3、带表达式的查找：select 表达式 from 表名;
-- 4、带别名的查找：select 表达式 as 别名 from 表名;    给查询结果的临时表的列起别名
-- 5、查找结果去重：select distinct 别名 from 表名;
-- 6、排序：select 列名 from 表名 order by 列名 asc/desc,列名 asc/desc    表示升序或降序
-- 7、条件查询：select 列名 from 表名 where 条件;   写了条件之后 MySQL 在执行的时候就会根据条件筛选



-- select 中的条件查询
-- 在 select 的后面加上一个 where 语句，后面跟上一个具体的筛选条件
-- select 列名 from 表名 where 条件;   查询结果会把不满足的内容过滤掉
-- 比较运算符：>,>=,<,<=     = 表示相等，不是赋值。
-- NULL = NULL 这个结果的判断还是 NULL         NULL 会视为假，就是条件不成立
-- <=> 也是比较相等，语法和 = 基本一样   用 <=> 比较 NULL 结果就是真
-- BETWEEN a0 AND a1   如果 a0 <= value <= a1 就返回从 true
-- IN(option)  通过后面这个括号给出的几个固定的值，判定当前结果是否在这几个值当中
-- IS NULL 专门用来和 NULL 比较
-- IS NOT NULL  也是专门用来和 NULL 比较
-- LIKE  对结果进行模糊匹配
-- AND  OR  NOT   就是：并且，或者，取反的意思
-- 查询英语小于 60 的
select name,english from exam_result where english < 60;-- where 后面的条件，就会针对查询结果进行筛选
-- 服务器会遍历表中的每一条记录，记录符合条件，就返回给客户端，不符合就跳过。
-- 查询语文成绩大于英语成绩的内容，指的是同一行的语文和英语之间进行比较
select name,english,chinese from exam_result where chinese > english;
-- 后面的条件和前面查询的列之间是没有关系的，前面的列是显示的内容。
select name,english from exam_result where chinese > english;
-- 查询总分在 200 以下的
select name,chinese + english + math from exam_result where chinese + math + english < 200;
-- 通过别名  这里报错，where 字句不能使用别名，会报错：不认识别名。如果要做到的话，也可以实现，但是 MySQL 没实现这个功能
select name,chinese + english + math as total from exam_result where total < 200;
-- 查询语文大于 80  并且英语大于 80
select name,chinese,english from exam_result where chinese > 80 and english > 80;
-- 查询语文大于 80  或者英语大于 80
select name,chinese,english from exam_result where chinese > 80 or english > 80;
-- and 的优先级比 or 的优先级大，如果想打破优先级，就需要加括号。
select * from exam_result where chinese > 80 or math > 70 and english > 70;
-- 加上括号之后，就是先算 or 再算 and
select * from exam_result where (chinese > 80 or math > 70) and english > 70;
-- 编程领域 大部分区间都是 前闭后开       SQL 语句中是前闭后闭
select * from exam_result where chinese between 80 and 90;
-- 两种没有区别，可以看为 between 是简化的写法
select * from exam_result where chinese >= 80 and chinese <= 90;
-- IN
select * from exam_result where math in (58,59,98,99);
-- 也可以通过 or 来实现功能
select * from exam_result where math = 58 or math = 59 or math = 98 or math = 99;
-- LIKE 要搭配通配符来使用。只要对方字符串符合你此处描述的形式就可以  % 代表任意字符，包含 0 个字符
-- _ 下划线，代表任意一个字符
-- 模糊匹配，就相当于描述了一个规则，符合这个规则的字符串都会被筛选出来
select * from exam_result where name like 'q%'; -- 匹配到以 q 开头的。
-- 如果是 ‘%q%'  意思就是：只要名字里面包含 q 就能被选出来。
-- 一个下划线只能匹配到一个字符
select * from exam_result where name like 'q__';

-- 如果抛开 SQL 站在更广的角度来看 通配符体系的话，
-- 还有一个 ’正则表达式‘ 提供了更多的特殊符号，来描述一个字符串的规则
-- 正则表达式里面特殊符号太多，可读性很差

-- 查找 NULL 的成绩
select * from exam_result where chinese <=> null;
-- 通过 is null 来查询
select * from exam_result where chinese is null;
-- 对每个类别进行重命名
select name,chinese as c ,english as e from exam_result;



-- 排序的时候还可以通过 order by 来指定多个列进行排序
-- 先根据第一个列进行排序，如果第一列结果相同，相同结果之间在通过第二个列排序
-- 先按照数学排序，数学相同之后，再按照语文来排，多个列排序的时候是有明确优先级的。
-- null 是不能做运算的，null 的运算还是 null。
-- 如果排序都是 null 的话，算作结果相同
-- 如果不指定多个列的话，只指定一个列，此时如果结果相同，彼此之间的顺序都是不可预期的
-- offer 筛选：1.薪资：优先高的    2.工作地点：优先北京 == 深圳 > 上海 > 其他城市
--            3.公司规模：优先大厂     4.根据家属来配合
select name,math,chinese from exam_result order by math,chinese;


-- COLLATE：指定数据库字符集的校验规则
-- 创建数据库的时候的指定的校验规则，其实就是在描述字符之间的比较关系
-- 可以指定不同的校验规则，字典序只对英文有意义


-- 按照总成绩排序
select name,chinese + math + english from exam_result order  by chinese + math + english;
-- 下面是按照别名来排序
select name,chinese + math + english as total from exam_result order  by total;

-- 有的数据库当中是带有 NULL 值的，按照升序是最前面，按照降序是最后面，也就是说：空值是最小值
insert into exam_result values (8,'酷酷酷',null ,null ,null );

-- 对查询结果排序，不会影响到原始数据的顺序。 select 列名 from 表名 order by 列名 asc/desc 升序和降序。
select * from exam_result order  by math asc; -- 针对数学成绩进行升序排序，如果省略不写，默认是升序排序
-- 不确定是不是稳定的排序，像数据库的查询结果，如果不指定排序，此时查询结果的顺序是不可预期的。
-- 写代码的时候不能依赖默认的顺序。


-- 针对查询结果去重：distinct 针对查询的结果，将相同的结果去掉
select distinct math from exam_result;
-- 如果是针对多个列来去重，就得这多个列的值都相同的时候才能去重
select distinct math,english from exam_result;


-- 查询字段指定别名，就是给查询结果的临时表指定新的列名。通过指定别名的方式，来避免临时表的名字太过混乱
select name,chinese + math + english as total from exam_result;
-- total 就是别名，as 可以省略。但建议还是不要省略，省略之后可读性较低


-- 下面的操作，都是针对一个或多个列来进行运算，也就是针对指定的列中的每一行数据都进行同样的操作。
-- 而且操作的时候行与行之间互不影响

-- 查询每个同学的总分
-- 临时表中的结果的数据类型编译的和原始的表的数据类型完全一致。临时表的类型会自动适应，保证计算结果是正确的。
select name,chinese + math + english from exam_result;


-- 指定查询字段为表达式，查询的时候，同时进行一些运算操作（列和列之间）
-- 例如：期望查询结果中的语文成绩比实际多 10 分
-- select 操作的结果是 “临时表” 原来数据库上的数据并没有发生改变。
select name,chinese + 10 from exam_result;


-- select 列名，列名，from 表名;   可以有多个列。显示的告诉数据库要查的是哪些列，数据库就会针对性的进行返回数据了
-- 这种指定列查询就会高效很多。 在开发中，指定列查询比全列查询使用频率很高。指定列查询也是临时表
-- 指定列查询也对原始数据没影响

select name,chinese from exam_result;

-- 查找语句：最基础的查找，全列查找（把一个表的所有的列，所有的行都查询出来）
-- select * from 表名;     * 是通配符，表示一个表的所有列
-- 查找到的结果是一个“临时表” 并不在硬盘上，而是在内存中，随着进行输出之后，数据也就被释放了。
-- select 操作，不会影响到服务器这边硬盘上保存的数据。
-- select * from 表名; 是一个危险操作，如果在生产环境的服务器上操作的话，会带来灾难
-- 因为生产环境保存的数据量可能是非常大的，很可能把服务器挤爆。
-- 因为此时 MySQL 服务器就会疯狂来读取硬盘的数据，瞬间就能把硬盘的 IO 带宽吃满，硬盘的读取速度存在上限
-- 由于返回的数据很大也很多，也会把网卡的 IO 带宽吃满。吃满之后服务器就很难响应其它客户端的操作了
-- 生产环境的服务器无时无刻都要给普通用户提供响应操作。
-- 一般公司都会对 SQL 的执行时间做出监控，一旦发现了这种长时间执行的 “慢SQL” 就强制把这个 SQL 语句杀死
create table exam_result(id int, name varchar(50),chinese decimal(3,1),math decimal(3,1),english decimal(3,1));
INSERT INTO exam_result (id,name, chinese, math, english) VALUES
                                                              (1,'qqq', 67, 98, 56),
                                                              (2,'www', 87.5, 78, 77),
                                                              (3,'eee', 88, 98.5, 90),
                                                              (4,'rrr', 82, 84, 67),
                                                              (5,'ttt', 55.5, 85, 45),
                                                              (6,'yyy', 70, 73, 78.5),
                                                              (7,'uuu', 75, 65, 30);


-- insert 可以插入多条记录，使用多个括号，用逗号分开。也可以分为多个 insert 语句来插入。
-- 每次插入的时候，会从客户端发送请求到服务器，数据库就要解析一次，如果插入次数多的话，就要解析很多次
insert into student values(1,'Here',19,90.0),(2,'lisi',20,78.5);

-- 可以随时通过 use 来切换数据库，重复执行 use 没啥副作用
-- insert 在插入的时候，可以直插入其中的某一列或某几列，此时其它的列将采用默认值。
insert into student (id,name) values (10,'Lockey');-- 这样的话，后两列就是 null
insert into student (id,name) values (15,'张三');-- 插入汉字可能会失败，因为 MySQL 的编码方式是拉丁文
-- 配置编码方式

-- 如果某一列是 datetime，如何运行插入
-- 1、通过指定格式的字符串来插入一个指定的时间。
-- 2、通过 now() 函数来插入。就是插入当前系统的时间。
create table test(id int,time datetime);
insert into test values (1,'2022-03-03');
insert into test values (1,'2022-03-03 22:22:22');-- 推荐这种
insert into test values (1,now());



--  select * from 表名;  显示表的内容
select * from student2;
-- SQL 当中表示字符串，可以使用单引号，也可以使用双引号。因为 SQL 当中没有单独的字符类型。

-- SQL 的增删查改 CURD  C：创建  U：修改  R：查询  D：删除：drop table 表名;
-- 新增：insert 往表里插入数据：insert into 表名 values (列的值....)一个括号对应一条记录
insert into student2 values (1,'张三',19,98.5);
-- values 后面（）中的字段的个数和表头的约定的列数以及每个列的类型，要匹配。如果不匹配的话， SQL 会完成强制转换，
-- 有时候强制转换不成功就会出错。
insert into student values (
                            1,
                            'zhangsan',
                            19,
                            98.5
);

create table customer2(
    customer_id int,
    name varchar(50)
);
-- 括号里面的 50 其实可以随便写的，但是以后在实际工作中，就不能乱写了
-- 一般情况下，这种字符串的长度都会有明确的规定。最长多少，最短多少。
-- 是产品经理规定的

create table purchase(
    order_id int,
    customer_id int,
    goods_id int,
    num int
);
-- 在 cmd 当中 ctrl+c 表示中断当前的输入。想复制，需要西安选中，然后 enter 复制。

create table student(
    id int,
    name varchar(50),
    age int,
    score double(3,1)
);
