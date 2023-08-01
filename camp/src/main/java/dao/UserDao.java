package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.mapper.UserMapper;
import logic.User;

@Repository
public class UserDao {
	 @Autowired
	    private SqlSessionTemplate template;
	    private Map<String, Object> param = new HashMap();
	    private Class<UserMapper> cls = UserMapper.class;
		public void insert(User user) {
			template.getMapper(cls).insert(user);			
		}
		
		public User selectUserOne(String id) {
			param.clear();
			param.put("id", id);
			return template.getMapper(cls).selectUserOne(id);
		}

		public void update(User user) {
			template.getMapper(cls).update(user);
		}

		public void chgpass(String id, String chgpass){
			param.clear();
			param.put("id", id);
			param.put("pass", chgpass);
			template.getMapper(cls).chgpass(param);
		}

		public void logupdate(String id) {
			template.getMapper(cls).logupdate(id);
		}

		public void delete(String id) {
			param.clear();
			param.put("id", id);
			template.getMapper(cls).delete(param);
		}

		public String search(User user) {
			String col = "id";
			if(user.getId() != null) {	// 아이디 값이 있으면 => 비밀번호 찾기
				col = "pass";
			}
			param.clear();
			param.put("col", col);
			param.put("id", user.getId());
			param.put("email", user.getEmail());
			param.put("tel", user.getTel());
			return template.getMapper(cls).search(param);
		}

		public int count(String searchtype, String searchcontent) {
			param.clear();
			param.put("searchcontent", searchcontent);
			param.put("searchtype", searchtype);
			return template.getMapper(cls).count(param);
		}

		public List<User> userlist(Integer pageNum, int limit, String searchtype, String searchcontent) {
			param.clear();
			param.put("startrow", (pageNum-1)*limit);
			param.put("limit", limit);
			param.put("searchtype", searchtype);
			param.put("searchcontent", searchcontent);
			return template.getMapper(cls).userlist(param);
		}

		public void rest(String id, Integer restNum) {
			param.clear();
			param.put("id", id);
			param.put("rest", restNum);
			template.getMapper(cls).rest(param);
		}

		public List<User> loglist() {
			return template.getMapper(cls).loglist();
		}

		public List<User> idsearch(String email, String tel) {
			return template.getMapper(cls).idsearch(email, tel);
		}

		public void insertUser(String id, String passwordHash, String name, Integer gender, String tel, String email,
				String lastlog, String birth, Integer rest) {
			param.clear();
			param.put("id", id);
			param.put("pass", passwordHash);
			param.put("name", name);
			param.put("gender", gender);
			param.put("tel", tel);
			param.put("email", email);
			param.put("lastlog", lastlog);
			param.put("birth", birth);
			param.put("rest", rest);
			template.getMapper(cls).insertUser(param);
		}

		public String selectUser(String paramid) {
			param.clear();
			param.put("id", paramid);
			return template.getMapper(cls).userinto(param);
		}

		public String selectTel(String telCheck) {
			param.clear();
			param.put("tel", telCheck);
			return template.getMapper(cls).usertel(param);
		}


}
