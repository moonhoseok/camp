package controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.hibernate.validator.internal.util.privilegedactions.GetInstancesFromServiceLoader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import logic.CampService;
import logic.User;

@Controller
@RequestMapping("admin")
public class AdminController {

	@Autowired
	private CampService service;
	
	@RequestMapping("list")
	public ModelAndView adminChecklist(@RequestParam Map<String, String> param, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		Integer pageNum = null;
		if(param.get("pageNum") != null) { // 값이 있는 경우
			pageNum = Integer.parseInt(param.get("pageNum"));
		}
		// 휴면 계정 - admin이 등록, 해제
		String id = param.get("userid");
		Integer rest = null;
		if(param.get("rest") != null) {	
			rest = Integer.parseInt(param.get("rest"));
			if(rest == 2) { // 휴면 등록
				service.userRest(id, rest);
			} else if (rest == 1) {	// 해제
				service.userRest(id, rest);
			}
		}
		
		// 검색
		String searchcontent = param.get("searchcontent"); // 검색값
		String searchtype = param.get("searchtype"); // 검색 항목
			
		if(pageNum == null || pageNum.toString().equals("")) pageNum = 1;
			
		// 검색 부분 설정
		if(searchcontent == null || searchtype == null 
				|| searchcontent.trim().equals("") || searchtype.trim().equals("")) {
			// 검색 항목이나 값 둘 중에 하나라도 없으면 다 없는 걸로 처리
			searchcontent = null;
			searchtype = null;
		}
				
		// 한 페이지 당 보여줄 회원 목록
		int limit = 10;
		int listcount = service.usercount(searchtype, searchcontent);
		List<User> userlist = service.userlist(pageNum, limit, searchtype, searchcontent); 
			
		// 페이지 처리를 위한 값 설정
		int maxpage = (int) ((double)listcount/limit + 0.95);
		int startpage = (int) ((pageNum/10.0+0.9)-1) * 10+1;
		int endpage = startpage+9;
		if(endpage > maxpage) endpage = maxpage;
		int userno = listcount - (pageNum-1)*limit;
		mav.addObject("pageNum",pageNum);
		mav.addObject("maxpage",maxpage);
		mav.addObject("startpage",startpage);
		mav.addObject("endpage",endpage);
		mav.addObject("listcount",listcount);
		mav.addObject("userno",userno);
		mav.addObject("list", userlist);
		
		return mav;
	}
}
