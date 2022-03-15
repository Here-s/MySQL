import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

public class TestJDBCUpdate {

    public static void main(String[] args) throws SQLException {
        //根据 id 来修改学生姓名。

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
        String name = scanner.next();

        //4、拼装 sql 语句
        String sql = "update student set name = ? where id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, name);
        statement.setInt(2, id);
        System.out.println("statement" + statement);

        //5、执行 sql
        int line = statement.executeUpdate();
        System.out.println("line" + line);

        //6、回收资源
        statement.close();
        connection.close();
    }
}
