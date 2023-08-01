package logic;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.CampDao;

@Service
public class CampingService {
	@Autowired
	private CampDao campDao;
	
	public List<Camp> camplist(Map<String, Object> param) {
		return campDao.list(param);
	}

	public int campcount(Map<String, Object> param) {
		return campDao.count(param);
	}

	public int campcount2(String themelist, String pet, String aroundlist) {
		return campDao.count2(themelist,pet,aroundlist);
	}

	public List<Camp> camplist2(String themelist, String pet, String aroundlist, Integer pageNum, int limit,
			int startrow, Object object) {
		return campDao.list2(themelist,pet,aroundlist,pageNum,limit,startrow,object);
	}

	public Camp selectOne(int contentId) {
		return campDao.selectOne(contentId);
	}

	public void addcnt(int contentId) {
		campDao.addcnt(contentId);
		
	}

	public List<Camp> lovelist(Map<String, Object> param) {
		return campDao.lovelist(param);
	}

	public List<Camp> lovelist2(String themelist, String pet, String aroundlist, Integer pageNum, int limit,
			int startrow, Object object) {
		return campDao.lovelist2(themelist,pet,aroundlist,pageNum,limit,startrow,object);
	}

	public List<Camp> maincamp() {
		return campDao.maincamp();
	}

	public void campupdate(Camp camp) {
		campDao.update(camp);
		
	}

}
