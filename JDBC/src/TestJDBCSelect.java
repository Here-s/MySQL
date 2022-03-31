import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class TestJDBCSelect {

    public static void main(String[] args) throws SQLException {
        //1、创建数据源
        DataSource dataSource = new MysqlDataSource();
        ((MysqlDataSource)dataSource).setURL("jdbc:mysql://127.0.0.1:3306/user?characterEncoding=utf8&useSSL=false");
        ((MysqlDataSource)dataSource).setUser("root");
        ((MysqlDataSource)dataSource).setPassword("sjp151");

        //2、建立连接
        Connection connection = dataSource.getConnection();

        //3、拼装 sql 语句
        String sql = "select * from student";
        PreparedStatement statement = connection.prepareStatement(sql);

        //4、执行 sql
        ResultSet resultSet = statement.executeQuery();

        //5、遍历结果    类似于迭代器
        while (resultSet.next()) {
            //先针对一行来获取列
            int id = resultSet.getInt("id");
            String name = resultSet.getString("name");
            System.out.println("id= " + id + " ,name= " + name);
        }

        //6、关闭资源
        resultSet.close();
        statement.close();
        connection.close();
    }
}
