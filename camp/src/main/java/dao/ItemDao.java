package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.ItemMapper;
import logic.Item;

@Repository
public class ItemDao {

	@Autowired
	private SqlSessionTemplate template;
	private Map<String, Object> param = new HashMap<String, Object>();
	private Class<ItemMapper> cls = ItemMapper.class;
	
	public int maxId() { 					
		return template.getMapper(cls).maxId();
	}
	
	public void insert(Item item) {
		template.getMapper(cls).insert(item);
	}

	public List<Item> list() {
		param.clear();
		return template.getMapper(cls).select(param);
	}

	public Item getItem(Integer id) {
		param.clear();
		param.put("id", id);
		return template.getMapper(cls).selectOne(id);
	}

	public void update(Item item) {
		template.getMapper(cls).update(item);
	}

	public void delete(Integer id) {
		param.clear();
		param.put("id", id);
		template.getMapper(cls).delete(param);
	}

	public int itemcount() {
		param.clear();
		return template.getMapper(cls).itemcount(param);
	}

}
