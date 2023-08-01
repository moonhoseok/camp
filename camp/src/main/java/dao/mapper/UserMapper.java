package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import logic.User;

public interface UserMapper {

	@Insert("insert into user(id,pass,name,gender,tel,email,lastlog, birth, rest)"
			+ " values(#{id},#{pass},#{name},#{gender},#{tel},#{email}, now(), #{birth}, 1)")
	void insert(User user);

	@Select("select * from user where id = #{value}")
	User selectUserOne(String id);

	@Update("update user set name=#{name}, pass=#{pass}, birth=#{birth}, "
			+ "tel=#{tel}, email=#{email} where id=#{id}")
	void update(User user);

	@Update("update user set pass=#{pass} where id=#{id}")
	void chgpass(Map<String, Object> param);

	@Update("update user set lastlog=now() where id=#{value}")
	void logupdate(String id);

	@Delete("delete from user where id=#{id}")
	void delete(Map<String, Object> param);

	@Select({"<script>",
		"select ${col} from user where email=#{email} and tel=#{tel} ",
		"<if test='id !=null'> and id=#{id}</if> ",
		"</script>"
	})
	String search(Map<String, Object> param);

	@Select("select * from user")
	List<User> select(Map<String, Object> param);

	@Select({"<script>",
			"select count(*) from user",
			"<if test ='searchtype != null'> where ${searchtype} like '%${searchcontent}%' </if>",
			"</script>"})
	int count(Map<String, Object> param);

	@Select({"<script>",
			"select * from user",
			"<if test='searchtype != null'> where ${searchtype} like '%${searchcontent}%'</if>",
			"<if test='limit != null'> order by id desc, name asc limit #{startrow}, #{limit} </if>",
			"</script>"})
	List<User> userlist(Map<String, Object> param);

	@Update("update user set rest=#{rest} where id=#{id}")
	void rest(Map<String, Object> param);

	@Select("select id, lastlog from user")
	List<User> loglist();

	@Select("select id from user where tel=#{tel} and email=#{email}")
	List<User> idsearch(@Param("tel") String tel, @Param("email") String email);

	@Insert("insert into user(id,pass,name,gender,tel,email,lastlog, birth, rest)"
			+ " values(#{id},#{pass},#{name},#{gender},#{tel},#{email}, #{lastlog}, #{birth}, #{rest})")
	void insertUser(Map<String, Object> param);

	@Select("select id from user where id=#{id}")
	String userinto(Map<String, Object> param);

	@Select("select tel from user where tel=#{tel}")
	String usertel(Map<String, Object> param);
	
}
