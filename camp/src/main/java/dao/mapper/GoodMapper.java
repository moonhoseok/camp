package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import logic.Good;

public interface GoodMapper {

	@Insert("insert into good"
			+ "(goodno,userId ,goodtype)"
			+ "values(#{goodno},#{userId},#{goodtype})")
	void insert(Good good);

	@Select("select ifnull(count(*),0) from good"
			+ " where goodno=#{goodno} and userId=#{userId} and goodtype=#{goodtype}")
	int select(Good good);

	@Delete("delete from good"
			+ " where goodno=#{goodno} and userId=#{userId} and goodtype=#{goodtype}")
	void delete(Good good);
	@Select("select ifnull(count(*),0) from good"
			+ "	where goodno=#{goodno} and goodtype=#{goodtype}")
	int count(Good good);

	@Select("select * from good where userId = #{id} and goodtype=#{type}")
	List<Good> goodlist(@Param("id") String id, @Param("type") int i);

	
}
