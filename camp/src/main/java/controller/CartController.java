package controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;

import aop.CartAspect;
import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;
import exception.ItemException;
import logic.CampService;
import logic.Cart;
import logic.Item;
import logic.Sale;
import logic.User;

@Controller
@RequestMapping("cart")
public class CartController {
	
	@Autowired
	private CampService service;
	
	@GetMapping("*")
	public ModelAndView cart(Integer id) {
		ModelAndView mav = new ModelAndView();
		mav.addObject(new Cart());
		return mav;
	}
	
	// 장바구니 추가
	@RequestMapping("addcart")
	public ModelAndView addcart(Integer id, Integer quantity, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		// 로그인 유저
		User loginUser = (User)session.getAttribute("loginUser");
		if(loginUser == null) {		// 장바구니 기능 일반 로그인 사용자만 가능.
			throw new ItemException("로그인이 필요한 서비스입니다.", "../user/login");
		} else if (loginUser.getId().equals("admin")) {
			throw new ItemException("관리자는 주문하실 수 없습니다.", "../shop/list");
		}
		
		System.out.println("itemid: "+id);
		// 장바구니에 넣을 아이템 정보
		Item item = service.itemOne(id);
		List<Cart> cartlist = service.getuserCart(loginUser.getId(), 0);
		
		Map<Integer, Integer> map = new HashMap<>();
		for(Cart cart : cartlist) {
			map.put(cart.getItemid(), cart.getQuantity());
		}
		// 장바구니에 정보 있을 때
		if(cartlist.size() > 0) {
			if(map.containsKey(id) == true) {	// 기존에 있는 상품이면
				if(quantity == null || quantity == 0) {	// list에서 추가할 때
					Integer quan = map.get(id)+1;
					service.cartupdate(id, quan, loginUser.getId());
					throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/list");
				} else {	// detail 에서 추가할 때
					Integer quan = map.get(id) + quantity;
					service.cartupdate(id, quan, loginUser.getId());
					throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/detail?id="+item.getId());
				}
			} else if (map.containsKey(id) == false){	// 없는 상품이면
				if(quantity == null || quantity == 0) {	// list에서 추가할 때
					quantity = 1;
					service.cartadd(id, item, loginUser.getId(), quantity);
					throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/list");
				} else {	// detail에서 추가할 때
					service.cartadd(id, item, loginUser.getId(), quantity);
					throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/detail?id="+item.getId());
				}
			}
		}
		// 장바구니에 정보 없을 때
		if(cartlist.size() == 0) {
			if(quantity == null || quantity == 0) {	// list에서 추가할 때
				quantity = 1;
				service.cartadd(id, item, loginUser.getId(), quantity);
				throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/list");
			} else {	// detail 에서 추가할 때
				service.cartadd(id, item, loginUser.getId(), quantity);
				throw new ItemException("장바구니에 상품이 추가됐습니다.", "../shop/detail?id="+item.getId());
			}
		}
		return mav;
	}

	@GetMapping("delete")
	public String delete(Integer id, HttpSession session) {
		User loginUser = (User)session.getAttribute("loginUser");
		service.cartdelete(id, loginUser.getId());
		return "redirect:/user/mypage?id="+loginUser.getId();
	}
	// 주문 
	@RequestMapping("saleitem")
	public ModelAndView loginChecksaleitem(String userid, Integer itemid, Integer quantity, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User loginUser = (User)session.getAttribute("loginUser");
		if(loginUser.getId().equals("admin")) {
			throw new ItemException("관리자는 주문이 불가능합니다.", "../shop/detail?id="+itemid);
		}
		// user의 cart 테이블에서 조회
		System.out.println(itemid);
		Item item = null;
		List<Cart> cartlist = service.getuserCart(loginUser.getId(), itemid);
		System.out.println("saleitem의 itemid: "+ itemid);
		Integer total = 0;
		Integer sum = 0;
		if(quantity == null) {		// 장바구니에서 구매 시
			if(cartlist.size() > 0) {	// 카트
				for(Cart c : cartlist) {
					if(cartlist.size() == 1) { // 한 개의 아이템
						total += c.getQuantity() * c.getPrice();
						mav.addObject("itemid", c.getItemid());
					} else {	// 아이템 여러개
						total += c.getQuantity() * c.getPrice();
						mav.addObject("itemid", 0);
					}
				}
			} 
			mav.addObject("total", total);
			mav.addObject("user", loginUser);
			mav.addObject("cartlist", cartlist);
			return mav;
		} else {	// 바로구매 시
			item = service.itemOne(itemid);
			mav.addObject("user", loginUser);
			mav.addObject("saleitem", item);
			mav.addObject("quantity", quantity);
			return mav;
		}
		
	}
	
	@RequestMapping("order")
	public ModelAndView loginCheckorder(@RequestParam Map<String, String> param, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User loginUser = (User) session.getAttribute("loginUser");
		mav.addObject("postcode", param.get("postcode"));
		mav.addObject("address", param.get("address"));
		mav.addObject("detailAddress", param.get("detailAddress"));
		mav.addObject("user",loginUser);

		System.out.println("order의 itemid: " + param.get("itemid"));
		
		// 마이페이지에서 
		Integer itemid = Integer.parseInt(param.get("itemid"));
		Integer quantity = Integer.parseInt(param.get("quantity"));
		Integer sum = 0;
		List<Cart> cartlist = null;
		Integer size = 0;
		
		// 장바구니 여러개
		if(itemid == 0) {
			cartlist = service.getuserCart(loginUser.getId(), 0);
			for(Cart c : cartlist) {
				sum += c.getPrice() * c.getQuantity();
			}
			size = cartlist.size();
			mav.addObject("itemid", 0);
			mav.addObject("size", size);
			mav.addObject("cartlist", cartlist);
			mav.addObject("sum", sum);
		} else { // 장바구니 한 개
			cartlist = service.getuserCart(loginUser.getId(), itemid);
			if(cartlist.size() == 1) {
				sum = cartlist.get(0).getPrice() * cartlist.get(0).getQuantity();
			} else {
				Item itemlist = service.itemOne(itemid);
				sum = Integer.parseInt(param.get("quantity")) * itemlist.getPrice();
			}
			size = cartlist.size();
			System.out.println("order size 1 나오면 됨: "+size);
			mav.addObject("itemid", itemid);
			mav.addObject("cartlist", cartlist);
			mav.addObject("size", size);
			if(quantity != null || quantity !=0) {
				size = 0;
				Item itemlist = service.itemOne(itemid);
				mav.addObject("item", itemlist);
				sum = itemlist.getPrice() * quantity;
				mav.addObject("size", size);
				mav.addObject("sum", sum);
				mav.addObject("quantity", quantity);
			}
		}
		return mav;
	}
	
	@PostMapping("kakao")
	@ResponseBody
	public Map<String, Object> loginCheckkakao(@RequestParam Map<String, String> param, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		User loginUser = (User)session.getAttribute("loginUser");
		List<Cart> cartlist = null;
		Item item = null;
		int sum = 0;
		System.out.println("param"+param);
		if(Integer.parseInt(param.get("itemid")) == 0) {	// 장바구니 여러 개
			cartlist = service.getuserCart(loginUser.getId(), 0); 
			for(Cart c : cartlist) {
				sum += c.getPrice() * c.getQuantity();
			}
			if(cartlist.size() > 1) {
				map.put("name", cartlist.get(0).getName()+"외 "+(cartlist.size()-1));	// 상품명
			}
		} else {	// 한 개 주문 시
			Integer itemid = Integer.parseInt(param.get("itemid"));
			cartlist = service.getuserCart(loginUser.getId(), itemid);
			// 주문 정보
			if(cartlist.size() > 0) {	// 장바구니에 있는 상품이면
				map.put("name", cartlist.get(0).getName());
				sum = cartlist.get(0).getPrice() * Integer.parseInt(param.get("quantity"));
			} else {	// 장바구니에 없는 상품이면
				item = service.itemOne(itemid);
				sum = item.getPrice() * Integer.parseInt(param.get("quantity"));
				map.put("name", item.getName());	// 상품명
			}
		}
		map.put("merchant_uid", loginUser.getId()+"-"+session.getId()); // 주문 번호
		
		Integer max = service.getMax();
		Integer saleid;
		if(max == 0 || max == null || max.toString().trim().equals("")) {
			saleid = 1;
		} else {
			saleid = max+1;
		}
		String addr = param.get("addr");
		String detailaddr = param.get("detailAddress");
		String pcode = param.get("postcode");
		
		map.put("amount", sum);
		// ↓ 주문자 정보
		map.put("uid", saleid);
		map.put("buyer_userid", loginUser.getName());
		map.put("buyer_email", loginUser.getEmail());
		map.put("buyer_tel", loginUser.getTel());
		map.put("buyer_addr", addr+","+detailaddr);
		map.put("buyer_postcode", pcode);
		return map;		// 클라이언트는 json 객체로 전달
	}
	
	@RequestMapping("salecheck")
	public ModelAndView loginChecksalecheck(@RequestParam Map<String, String> param, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User loginUser = (User)session.getAttribute("loginUser");
		List<Cart> salelist = service.getuserCart(loginUser.getId(), 0);
		
		int sum = 0;
		Integer max = service.getMax();
		Integer saleid;
		if(max == 0 || max == null || max.toString().trim().equals("")) {
			saleid = 1;
		} else {
			saleid = max+1;
		}
		System.out.println("salecheck itemid"+param.get("itemid"));
		
		// mypage에서 주문
		// 장바구니
		if (param.get("itemid") == null || param.get("itemid").toString().trim().equals("") || 
				param.get("itemid").equals("0")) {	// 여러개인 경우
			List<Cart> citemid = service.getuserCart(loginUser.getId(), 0);
			mav.addObject("cartlist", citemid);
			for(Cart c : citemid) {
				sum += c.getPrice() * c.getQuantity();
				service.saleinsert(saleid, loginUser.getId(), c.getItemid(), c.getName(),
						c.getQuantity(), c.getPictureUrl(), c.getPrice() * c.getQuantity(), 
					Integer.parseInt(param.get("postcode")), param.get("address"), param.get("detailAddress"));
			}
			service.cartdelete(0, loginUser.getId());
		} else {	// 한 개인 경우
			Integer itemid = Integer.parseInt(param.get("itemid"));
			Item item = service.itemOne(itemid);
			sum += item.getPrice() * Integer.parseInt(param.get("quantity"));
			service.saleinsert(saleid, loginUser.getId(), item.getId(), item.getName(),
					Integer.parseInt(param.get("quantity")), item.getPictureUrl(), item.getPrice() * Integer.parseInt(param.get("quantity")), 
				Integer.parseInt(param.get("postcode")), param.get("address"), param.get("detailAddress"));
			List<Sale> saleitem = service.saleitemList(loginUser.getId(), saleid);
			mav.addObject("cartlist", saleitem);
		}
		throw new ItemException("결제되었습니다.", "../user/mypage?id="+loginUser.getId());
	}
	
}
