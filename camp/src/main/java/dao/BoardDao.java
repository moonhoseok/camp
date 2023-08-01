package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import javax.validation.Valid;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import dao.mapper.BoardMapper;
import logic.Board;
import logic.Comment;


@Repository
public class BoardDao {
	@Autowired
	private SqlSessionTemplate template;
	private Map<String, Object> param = new HashMap<String, Object>();
	private Class<BoardMapper> cls = BoardMapper.class;

	public int maxNum() {
		return template.getMapper(cls).maxNum();
	}
	
	public void insert(@Valid Board board) {
		template.getMapper(cls).insert(board);
		
	}
	public int count(String boardid,String column, String find, String cate) {
		param.clear();
		param.put("boardid", boardid);
		param.put("column", column);
		param.put("find", find);
		param.put("cate", cate);
		return template.getMapper(cls).count(param);
	}
	
	
	public List<Board> list(Integer pageNum, int limit, String boardid
			,String column, String find, String cnt,String cate) {
		param.clear();
		param.put("startrow", (pageNum-1)*limit); //1페이지 :0 , 2페이지 :10
		param.put("limit", limit);
		param.put("boardid", boardid);
		param.put("column", column);
		param.put("find", find);
		param.put("cnt", cnt);
		param.put("cate", cate);
		System.out.println(param);
		return template.getMapper(cls).select(param);
	}
	public Board selectOne(Integer num) {
		param.clear();
		param.put("num",num);
		return template.selectOne("dao.mapper.BoardMapper.select",param);
	}
	public void addReadcnt(Integer num) {
		param.clear();
		param.put("num", num);
		template.getMapper(cls).addReadCnt(param);
	}
	
	// 답변글 등록시 기존게시물에 grpstep값을 +1 
	public void updateGrpStep(Board board) {
		param.clear();
		param.put("grp", board.getGrp());
		param.put("grpstep", board.getGrpstep());
		template.getMapper(cls).updateGrpstep(param);
	}
	public void update(Board board) {
		template.getMapper(cls).update(board);
	}
	public void delete(Integer num) {
		template.getMapper(cls).delete(num);
	}

	public List<Map<String, Object>> graph1(String id) {
		return template.getMapper(cls).graph1(id);
	}

	public List<Map<String, Object>> graph2(String id) {
		return template.getMapper(cls).graph2(id);
	}

	public void likecntUp(Integer boardNum) {
		template.getMapper(cls).likecntUp(boardNum);
	}

	public Integer likecount(Integer boardNum) {
		return template.getMapper(cls).likecount(boardNum);
	}

	public void likecntDown(Integer boardNum) {
		template.getMapper(cls).likecntDown(boardNum);
		
	}

	public List<Board> mainlist(int i) {
		return template.getMapper(cls).mainlist(i);
	}

	public List<Board> mpblist(String id) {
		return template.getMapper(cls).mpblist(id);
	}

	public List<Comment> mpclist(String id) {
		return template.getMapper(cls).mpclist(id);
	}

	public Board mpglist(int goodno) {
		return template.getMapper(cls).mpglist(goodno);
	}

	
}
