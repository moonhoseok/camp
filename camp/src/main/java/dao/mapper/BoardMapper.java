package dao.mapper;

import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import logic.Board;
import logic.Comment;

public interface BoardMapper {
	String select =" select num,writer,pass,"
			+ "title,content,file1 fileurl,"
			+ "regdate,readcnt,grp, grplevel, "
			+ "grpstep,boardid,secret,likecnt,cate from board";

	@Select("select ifnull(max(num),0) from board")
	int maxNum();

	@Insert("insert into board"
			+ " (num, writer,pass,title,content,file1,regdate,"
			+ " readcnt, grp,grplevel,grpstep,boardid,secret,cate)"
			+ " values (#{num}, #{writer},#{pass},#{title},#{content},#{fileurl},now(),"
			+ "	#{readcnt}, #{grp},#{grplevel},#{grpstep},#{boardid},#{secret},#{cate})")
	void insert( Board board);

	@Select({"<script>",
			" select count(*) from board where boardid=#{boardid} ",
			" <if test='column != null'> and ${column} like '%${find}%' </if> "
			+ "<if test='cate != null'> and cate = #{cate} </if>",
			"</script>"})
	int count(Map<String, Object> param);

	@Select({"<script>",
	select ,
	" <if test='num !=null '> where num = #{num}</if>",
	" <if test='boardid != null'> where boardid =#{boardid} </if>",
	" <if test='column != null'> and ${column} like '%${find}%' </if> ",
	" <if test='cate != null '> and cate =#{cate}</if>",
	//"<if test ='limit !=null'> grpstep asc limit #{startrow}, #{limit}</if>",
	//" <if test ='cnt == null'> order by regdate desc </if>",
	" <if test ='cnt != null '> order by ${cnt} desc </if>",
	" <if test ='cnt == null '> order by regdate desc </if>",
	" <if test ='limit !=null'> limit #{startrow}, #{limit} </if>",
	" </script>"})
	List<Board> select(Map<String, Object> param);

	@Update("update board set readcnt=readcnt+1 where num =#{num}")
	void addReadCnt(Map<String, Object> param);

	@Update("update board set grpstep=grpstep+1"
				+ " where grp =#{grp} and grpstep >#{grpstep}")
	void updateGrpstep(Map<String, Object> param);

	@Update("update board set writer=#{writer}, title=#{title},"
				+ " content=#{content}, file1=#{fileurl}, secret=#{secret} where num=#{num}")
	void update(Board board);

	@Delete("delete from board where num=#{num}")
	void delete(Integer num);
	
	/*리스트 형태
	 * [{writer = 홍길동, cnt = 10},{writer = 김삿갓, cnt = 7}...]
	 */
	@Select("select writer,count(*) cnt from board where boardid=#{value} "
    		+ " group by writer order by 2 desc limit 0,7")
	List<Map<String, Object>> graph1(String id);
	/*
	 * date_format(날짜,패턴) : 날짜형식의 데이터를 패턴에 맞는 문자열로 리턴 sql함수
	 * 			day 컬럼 : 2023-06-01 형식의 문자열 컬럼
	 * [
	 * 	{day : 2023-06-07, cnt:10}
	 * 	{day : 2023-06-06, cnt:3}
	 * 	{day : 2023-06-05, cnt:20}
	 * 	....
	 * ]
	 */
	@Select("select date_format(regdate,'%Y-%m-%d') day, count(*) cnt from board "
    		+ " where boardid=${value} group by date_format(regdate,'%Y-%m-%d')"
    		+ " order by day desc limit 0,7")
	List<Map<String, Object>> graph2(String id);
	
	@Update("update board set likecnt = ifnull(likecnt,0)+1 where num = #{value}")
	void likecntUp(Integer boardNum);
	
	@Select("select likecnt from board where num = #{value} ")
	Integer likecount(Integer boardNum);
	
	@Update("update board set likecnt = ifnull(likecnt,0)-1 where num = #{value}")
	void likecntDown(Integer boardNum);

	@Select("select * from board where boardid = #{value} order by readcnt desc limit 0,5")
	List<Board> mainlist(int i);

	@Select("select * from board where writer = #{value} order by regdate desc")
	List<Board> mpblist(String id);

	@Select("select * from comment where writer =#{value} order by regdate desc")
	List<Comment> mpclist(String id);

	@Select("select * from board where num =#{value}")
	Board mpglist(int goodno);

}
