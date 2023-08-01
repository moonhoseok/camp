package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.CartMapper;
import dao.mapper.ItemMapper;
import logic.Cart;
import logic.Item;

@Repository
public class CartDao {
	
	@Autowired
	private SqlSessionTemplate template;
	private Map<String, Object> param = new HashMap<String, Object>();
	private Class<CartMapper> cls = CartMapper.class;
	
	public void insert(Integer itemid, Item item, String userid, Integer quantity) {
		param.clear();
		param.put("itemid", itemid);
		param.put("name", item.getName());
		param.put("price", item.getPrice());
		param.put("pictureUrl", item.getPictureUrl());
		param.put("userid", userid);
		param.put("quantity", quantity);
		template.getMapper(cls).insert(param);
	}

	public List<Cart> select(String id) {
		param.clear();
		param.put("userid", id);
		return template.getMapper(cls).select(param);
	}

	public List<Cart> select(String userid, Integer itemid) {
		param.clear();
		param.put("userid", userid);
		param.put("itemid", itemid);
		return template.getMapper(cls).select(param);
	}

	public void update(Integer itemid, String id, Integer quan) {
		param.clear();
		param.put("userid", id);
		param.put("itemid", itemid);
		param.put("quantity", quan);
		template.getMapper(cls).update(param);
	}

	public void delete(Integer itemid, String userid) {
		param.clear();
		param.put("itemid", itemid);
		param.put("userid", userid);
		template.getMapper(cls).delete(param);
	}

	public List<Map<String, Object>> graph() {
		return template.getMapper(cls).graph();
	}
}
