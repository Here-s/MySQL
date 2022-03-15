import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

public class TestJDBCDelete {

    public static void main(String[] args) throws SQLException {
        //删除数据库当中的记录
        //用户输入一个 id 根据 id 来删除。把所有 id 为 1 的人都删掉了。

        //1、创建数据源
        DataSource dataSource = new MysqlDataSource();
        ((MysqlDataSource)dataSource).setURL("jdbc:mysql://127.0.0.1:3306/user?characterEncoding=utf8&useSSL=false");
        ((MysqlDataSource)dataSource).setUser("root");
        ((MysqlDataSource)dataSource).setPassword("sjp151");

        //2、建立连接
        Connection connection = dataSource.getConnection();

        //3、用户输入 id
        Scanner scanner = new Scanner(System.in);
        int id = scanner.nextInt();

        //4、拼装 sql 语句
        String sql = "delete from student where id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, id);

        //5、执行 sql
        int line = statement.executeUpdate();

        //6、回收资源
        statement.close();
        connection.close();

        //JDBC 翻来覆去也就这点东西，固定的代码写来写去。 工作当中，很少会直接使用 JDBC 。用起来繁琐
        //实际当中，用 ORM 框架，就是把数据库当中的记录 和 Java 代码中的对象给对上号。
    }
}
