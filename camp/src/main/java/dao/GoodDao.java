package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.GoodMapper;
import logic.Board;
import logic.Good;
import logic.User;

@Repository
public class GoodDao {
	@Autowired
	private SqlSessionTemplate template;
	private Map<String, Object> param = new HashMap<String, Object>();
	private Class<GoodMapper> cls = GoodMapper.class;
	
	public void insert(Good good) {
		template.getMapper(cls).insert(good);
	}

	public int select(Good good) {
		return template.getMapper(cls).select(good);
	}

	public void delete(Good good) {
		template.getMapper(cls).delete(good);
	}

	public int count(Good good) {
		return template.getMapper(cls).count(good);
	}

	public List<Good> goodlist(String id, int i) {
		return template.getMapper(cls).goodlist(id,i);
	}
}
