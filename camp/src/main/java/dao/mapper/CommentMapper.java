package dao.mapper;

import java.util.List;

import javax.validation.Valid;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import logic.Comment;

public interface CommentMapper {

	@Select("select ifnull(max(seq),0) from comment where num = #{num}")
	int maxseq(int num);
	
	@Insert("insert into comment"
			+" (num, seq, writer,  content, regdate, secret) "
			+ "values (#{num}, #{seq}, #{writer}, #{content}, now() ,#{secret})")
	void insert(Comment comm);

	@Select("select * from comment where num=#{num} order by seq desc" )
	List<Comment> list(Integer num);

	@Delete("delete from comment where num=#{num} and seq=#{seq}")
	void delete(@Param("num")int num,@Param("seq")int seq);

	@Select("select * from comment where num=#{num} and seq=#{seq}")
	Comment selectOne(@Param("num")int num,@Param("seq")int seq);
	
	@Update("update comment set content = #{text} where num=#{num} and seq=#{seq}")
	void update(@Param("num")int num,@Param("seq")int seq,@Param("text") String text);

	

}
