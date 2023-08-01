package dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.UserMapper;

@Repository
public class UserDao {
	 @Autowired
	    private SqlSessionTemplate template;
	    private Map<String, Object> param = new HashMap<>();
	    private Class<UserMapper> cls = UserMapper.class;
}
