import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

public class TestJDBC {


    public static void main(String[] args) throws SQLException {

        Scanner scanner = new Scanner(System.in);
        //1、创建数据源

        //DataSource 就是 JDBC 带的接口，数据源    MysqlDataSource 来自于下载好的 MySQL 的 jar 包
        // 这里提供了一个：实现了 Datasource 接口的类。
        // 这里的写法是常见的习惯写法，代码中持有的是 DataSource 类型，
        //  后面一些其它代码如果需要用到 DataSource，参数也是 DataSource
        //  未来如果数据库进行了切换，代码几乎不用改动
        // 这个是低耦合
        DataSource dataSource = new MysqlDataSource();
        // 设置数据库所在的地址
        // MySQL 作为一个服务器，也是以 url 这样的风格来提供资源的。
        //  外面要想访问 MySQL 上的数据库，也是通过 url 来进行描述。
        ((MysqlDataSource) dataSource).setURL("jdbc:mysql://127.0.0.1:3306/user?characterEncoding=utf8&useSSL=false");
        //端口号：对应到具体的应用程序
        //useSSL  加密传输

        //root 是 mysql 自带的管理员用户，也可以手动创建一些用户
        // 设置登录数据库的用户名
        ((MysqlDataSource) dataSource).setUser("root");
        // 设置登录数据库的密码  向下转型
        //安装 MySQL 的时候创建的密码
        ((MysqlDataSource) dataSource).setPassword("sjp151");


        //2、让 代码 和 数据库服务器 建立连接
        // 使用的 Connection 是 java.sql 包的
        Connection connection = dataSource.getConnection();

        //让用户输入待插入的数据
        int id = scanner.nextInt();
        String name = scanner.next();

        //3、操作数据库，以插入数据库为例。 关键是构造一个插入语句
        String sql = "insert into student values(1,'张三')";
        //只有一个 String 类型的 sql 还不行，需要把这个 String 包装成一个：语句对象
        //通过 Connection 里面的方法，把 字符串 风格的语句转化为 sql 对象
        PreparedStatement statement = connection.prepareStatement(sql);


        //4、执行 SQL 语句
        //  SQL 里面如果是 insert update delete 就使用 executeUpdate 方法
        //  SQL 里面如果是 select 就使用 executeQuery 方法
        int line = statement.executeUpdate();//就是执行一个更新操作，返回值是一个数值，表示多少行收到了影响
        System.out.println(line);


        //SQL 执行完毕，就需要释放资源。先创建的后释放，后创建的先释放
        statement.close();
        connection.close();

        //在上面写入的时候，插入的数据都是直接写死的。写死并不好，需要灵活处理要输入的数据。
        // 让用户在控制台是输入 学号 和 姓名。 通过 Scanner 类来输入，然后再转化

        //不建议进行拼接，很麻烦，很容易拼错，也容易引起：SQL 注入攻击，黑客攻击服务器的一种方法。
        //  使用一个代替的写法，避免直接拼接字符串。通过两个问号来告诉 Java 程序，这两个字段的值还不确定
        //      先占个位置，然后使用 statement 的 set 方法来进行替换。

        //如果要插入多条数据，就多加几个括号
        String sql1 = "insert into student values(?,?)";
        PreparedStatement statement1 = connection.prepareStatement(sql1);
        //这里就是具体的替换，下标是从 1 开始替换的
        statement1.setInt(1,id);//把第一个 问号 替换为 id 的值。
        statement1.setString(2,name);//把第二个 问号 替换为 name 的值。

        //就是简单版的打印日志。
        System.out.println("statement1" + statement1);
        //很多时候如果 JDBC 中执行的 SQL 出错了，看到错误的时候，往往需要先把这个拼好的 SQL 先打印出来，
        //  大概率是拼接出问题

        // 也可以写成下面这种
        //这种写法就会导致代码中处处散播着  MysqlDataSource 这样的类型，
        // 万一要切换数据库了，那么就凉凉，就不知道要改多少代码了。
        // 这个是高耦合
//        MysqlDataSource dataSource1 = new MysqlDataSource();
//        dataSource1.setURL();
//        dataSource1.setUser();
//        dataSource1.setPassword();
    }

    //JDBC 的基本编程流程：
    // 1、创建 DataSource 对象，这个对象就描述了数据库服务器在哪里

//-- JDBC 编程：实际开发程序非常必要的过程
//-- 黑框框是 MySQL 官方提供的客户端，官方也允许程序员自己实现 MySQL 客户端。MySQL 提供了一组 API 来支持实习这样的客户端
//-- 自己实现客户端就可以根据需要来完成一些具体的增删查改功能。
//            -- API ：应用程序编程接口
//-- 不同的数据库提供了不同的 API 。不同的数据库的 API 也不一样。没有同意的标准。
//            -- Java 诞生就是为了跨平台，于是就高了一个大一统的方案 JDBC
//-- Java 约定了一组 API 称为 JDBC 这组 API 里面就包含了一些类和一些方法，通过这些类和方法来实现数据库的基本操作
//-- 再有各个厂商，提供各自的：数据库驱动包 来和 JDBC 的 API 对接。
//            -- 会了 JDBC 就可以操作各种数据库了
//
//-- 在学校可能会遇到“统计学生信息”的情况，班主任约定好固定的格式，让各个班长去按照统一的格式
//
//-- JDBC 编程要引入依赖（第三方库）。1、下载驱动包：MySQL 官方网站，MySQL 被 Oracle 收购了。所以不方便下载
//--      因为不方便下载，所以就去 maven 中央仓库去下载。于是就把 第三方库 汇总起来放到 maven 中央仓库 里面
//--      2、导入项目
//--          a、创建一个目标，随便起名字
//--          b、把 jar 文件拷贝到创建的目录当中
//--          c、右键创建的目录，有一个选项 “Add as Library”
//            --      3、编写代码
//-- 中央仓库就是手机的 应用商店

    //索引和事务
    // 索引的意义：提高了查找的效率
    // 索引付出的代价：空间代价，时间代价（针对增删改），
    // 索引仍然会广泛的使用，实际工作中是：一写多读
    // 索引背后的数据结构：B+ 树。
    // 面试的时候建议画图

    //事务：面试：谈谈对于事务的理解
    // 把多个事务打包成一个，要么全部执行，要么全部不执行
    // 应用场景，典型的就是转账。
    // 事务实现转账机制，核心机制就是：回归 rollback

    //事务的基本特性：
    // 原子性：核心
    // 一致性
    // 永久性
    // 隔离性：a 脏读：给写操作加锁   b 不可重复读：给读操作加锁    c：幻读：串行化
    //  read uncommitted      read committed     repeatable read    serializable

}
