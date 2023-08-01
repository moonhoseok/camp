package controller;

import java.lang.annotation.Repeatable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import exception.ItemException;
import logic.CampService;
import logic.Cart;
import logic.Item;
import logic.User;

@Controller
@RequestMapping("shop")
public class ItemController {

	@Autowired
	private CampService service;
	
	@GetMapping("*")
	public ModelAndView item() {
		ModelAndView mav = new ModelAndView();
		mav.addObject(new Item());
		return mav;
	}
	@GetMapping("additem")
	public ModelAndView adminCheckAdditem(@Valid Item item, BindingResult bresult, HttpServletRequest request, HttpSession session) {				
		ModelAndView mav = new ModelAndView();
		mav.addObject(new Item());
		return mav;
	}
	
	// 판매 상품 추가
	@PostMapping("additem")	
	public ModelAndView additem(@Valid Item item, BindingResult bresult, HttpServletRequest request, HttpSession session) {				
		ModelAndView mav = new ModelAndView();
		if(bresult.hasErrors()) {
			mav.getModel().putAll(bresult.getModel());
			return mav;	
		}
		service.itemadd(item, request);
		mav.setViewName("redirect:list");
		return mav;
	}
	
	@RequestMapping("list")
	public ModelAndView list(@RequestParam Map<String, String> param, User user, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User loginUser = service.selectUserOne(user.getId());
		List<Item> list = service.itemlist();
		
		// 페이징 처리
		Integer pageNum = null;
		if(param.get(pageNum) == null || pageNum.toString().trim().equals("")) {
			pageNum = 1;
		}
		// 페이지 처리를 위한 값 설정
		int limit = 10;
		int listcount = service.itemcount(); 
		int maxpage = (int) ((double)listcount/limit + 0.95);		// 등록 된 게시물에 따른 최대 페이지 
		int startpage = (int) ((pageNum/10.0+0.9) -1) * 10 +1;		// 각 페이지의 게시물 시작 번호 
		int endpage = startpage+9;									// 각 페이지의 게시물 마지막 번호
		if(endpage > maxpage) endpage = maxpage;					// 마지막 페이지 = 최대 페이지
		int itemno = listcount - (pageNum-1) * limit;				// 화면에 보여지는 게시물 번호 
		mav.addObject("pageNum", pageNum);
		mav.addObject("startpage", startpage);
		mav.addObject("endpage", endpage);
		mav.addObject("maxpage", maxpage);
		mav.addObject("listcount", listcount);
		mav.addObject("itemno", itemno);
		mav.addObject("list", list);
		mav.addObject("loignUser",loginUser);
		return mav;
	}
	
	@RequestMapping("detail")
	public ModelAndView detail(Integer id) {
		ModelAndView mav = new ModelAndView();
		Item list = service.itemOne(id);
		mav.addObject("item", list);
		return mav;
	}
	
	@GetMapping({"update","delete"})
	public ModelAndView adminCheckupdate(Integer id, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		Item item = service.itemOne(id);
		mav.addObject("item", item);
		return mav;
	}
	
	@PostMapping("update")
	public ModelAndView update(@Valid Item item, BindingResult bresult, Integer id, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		if(bresult.hasErrors()) {
			mav.getModel().putAll(bresult.getModel());
			return mav;
		}
		service.itemUpdate(item, request);
		mav.setViewName("redirect:list");
		return mav;
	}
	
	@PostMapping("delete")
	public String delete(Integer id) {
		service.itemDelete(id);
		return "redirect:list";
	}
	
}
