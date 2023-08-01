package dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.FetchProfile.Item;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.SaleMapper;
import logic.Sale;

@Repository
public class SaleDao {
	
	@Autowired
	private SqlSessionTemplate template;
	private Map<String, Object> param = new HashMap<String, Object>();
	private Class<SaleMapper> cls = SaleMapper.class;
	
	public int maxId() {
		return template.getMapper(cls).maxid();
	}

	public void insert(Integer saleid, String userid, Integer itemid, String name, Integer quantity, String pictureUrl, Integer price,
			Integer postcode, String address, String detailaddress) {
		param.clear();
		param.put("saleid", saleid);
		param.put("userid",	userid);
		param.put("itemid", itemid);
		param.put("name", name);
		param.put("quantity", quantity);
		param.put("pictureUrl", pictureUrl);
		param.put("price", price);
		param.put("postcode", postcode);
		param.put("address", address);
		param.put("detailAddress", detailaddress);
		template.getMapper(cls).insert(param);
	}

	public List<Sale> select(String userid) {
		param.clear();
		param.put("userid", userid);
		return template.getMapper(cls).select(param);
	}

	public List<Sale> salecheck(String userid, Date saledate) {
		param.clear();
		param.put("userid", userid);
		param.put("saledate", saledate);
		return template.getMapper(cls).salecheck(param);
	}

	public List<Sale> saleitemList(String userid, Integer saleid) {
		param.clear();
		param.put("userid", userid);
		param.put("saleid", saleid);
		return template.getMapper(cls).saleitemList(param);
	}

	public List<Sale> selectSaleid(String userid) {
		param.clear();
		param.put("userid", userid);
		return template.getMapper(cls).selectid(param);
	}

	public void saledelete(String userid, Integer saleid) {
		param.clear();
		param.put("userid", userid);
		param.put("saleid", saleid);
		template.getMapper(cls).saledelete(param);
	}

	public List<Sale> salelist() {
		return template.getMapper(cls).salelist();
	}

}
