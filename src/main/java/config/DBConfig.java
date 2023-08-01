package config;

import java.beans.PropertyVetoException;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.mchange.v2.c3p0.ComboPooledDataSource;


@Configuration
@EnableTransactionManagement        // 트렌젝션 적용
public class DBConfig {

    @Bean(destroyMethod = "close")    // 제일 마지막엔 close 해라. 객체 제거 시 호출되는 메소드
    public DataSource dataSource() {
        ComboPooledDataSource ds = new ComboPooledDataSource();    // Connection Pool 객체 생성
        try {
            ds.setDriverClass("org.mariadb.jdbc.Driver");
            ds.setJdbcUrl("jdbc:mariadb://127.0.0.1:3306/gdudb");
            ds.setUser("gdu");
            ds.setPassword("1234");
            ds.setMaxPoolSize(20);
            ds.setMinPoolSize(3);
            ds.setInitialPoolSize(5);
            ds.setAcquireIncrement(5);
        } catch (PropertyVetoException e) {
            e.printStackTrace();
        }
        return ds;
    }

    @Bean
    public TransactionManager transactionManager() {    // 트랜젝션 처리를 위한 객체
        return new DataSourceTransactionManager(dataSource());
    }

    // mybatis 관련 설정
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource());
        bean.setConfigLocation(new ClassPathResource("mybatis-config.xml"));
        return bean.getObject();
    }

    // mybatis 관련 설정
    @Bean
    public SqlSessionTemplate sqlSessionTemplate() throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory());
    }


}
