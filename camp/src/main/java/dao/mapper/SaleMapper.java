package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import logic.Sale;

public interface SaleMapper {

	@Select("select ifnull(max(saleid),0) from sale")
	int maxid();

	@Insert("insert into sale (saleid, userid, itemid, name, quantity, pictureUrl, price, postcode, address, detailAddress, saledate) "
			+ "value (#{saleid}, #{userid}, #{itemid}, #{name}, #{quantity}, #{pictureUrl}, #{price}, #{postcode}, #{address}, #{detailAddress}, now())")
	void insert(Map<String, Object> param);

	@Select("select * from sale where userid=#{userid} order by saledate desc")
	List<Sale> select(Map<String, Object> param);

	@Select("select * from sale where userid=#{userid} and saledate=#{saledate}")
	List<Sale> salecheck(Map<String, Object> param);

	@Select("select saleid from sale where userid=#{userid} order by saledate desc")
	List<Sale> selectid(Map<String, Object> param);

	@Select("select * from sale where userid=#{userid} and saleid=#{saleid} order by saledate desc")
	List<Sale> saleitemList(Map<String, Object> param);
	
	@Select("delete from sale where userid=#{userid} and saleid=#{saleid}")
	void saledelete(Map<String, Object> param);

	@Select("SELECT *, COUNT(*)*quantity cnt from sale GROUP BY itemid ORDER BY cnt DESC")
	List<Sale> salelist();


}
