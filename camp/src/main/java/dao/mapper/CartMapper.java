package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import logic.Cart;
import logic.Item;

public interface CartMapper {
	
	@Insert("insert into cart (itemid, userid, name, price, pictureUrl, quantity) "
			+ "value(#{itemid},#{userid},#{name},#{price},#{pictureUrl},#{quantity})")
	void insert(Map<String, Object> param);

	@Select({"<script>",
			"select * from cart where userid = #{userid} ",
			"<if test='itemid != 0'> and itemid = #{itemid}</if>",
			"</script>"})
	List<Cart> select(Map<String, Object> param);

	@Update("update cart set quantity = #{quantity} where userid=#{userid} and itemid=#{itemid}")
	void update(Map<String, Object> param);

	@Delete({"<script>"
			+ "delete from cart where userid = #{userid}"
			+ "<if test='itemid != 0'> and itemid=#{itemid} </if>"
			+ "</script>"})
	void delete(Map<String, Object> param);

	@Select("select if(CHAR_LENGTH(NAME) > 4,substr(NAME,-5), name) as item, COUNT(*)*quantity cnt from sale group by name order by date_format(saledate,'%Y-%m-%d') desc limit 0,7")
	List<Map<String, Object>> graph();
}
