import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;

public class TestJDBC {

    public static void main(String[] args) {
        //DataSource 就是 JDBC 带的接口    MysqlDataSource 来自于下载好的 MySQL 的 jar 包
        // 这里提供了一个：实现了 Datasource 接口的类。
        // 这里的写法是常见的习惯写法，代码中持有的是 DataSource 类型，
        //  后面一些其它代码如果需要用到 DataSource，参数也是 DataSource
        //  未来如果数据库进行了切换，代码几乎不用改动
        // 这个是低耦合
        DataSource dataSource = new MysqlDataSource();
        // 设置数据库所在的地址
        // MySQL 作为一个服务器，也是以 url 这样的风格来提供资源的。
        //  外面要想访问 MySQL 上的数据库，也是通过 url 来进行描述。
        ((MysqlDataSource) dataSource).setURL("jdbc:msql://127.0.0.1:3306/user?characterEncoding= stf8&useSSL=false");
        // 设置登录数据库的用户名
        ((MysqlDataSource) dataSource).setUser();
        // 设置登录数据库的密码  向下转型
        ((MysqlDataSource) dataSource).setPassword();


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

}
