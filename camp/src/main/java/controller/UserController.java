package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.format.datetime.joda.DateTimeParser;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mchange.v2.cfg.PropertiesConfigSource.Parse;

import exception.LoginException;
import logic.Board;
import logic.BoardService;
import logic.Camp;
import logic.CampService;
import logic.CampingService;
import logic.Cart;
import logic.Comment;
import logic.Good;
import logic.Item;
import logic.Sale;
import logic.User;
import util.CipherUtil;

@Controller
@RequestMapping("user")
public class UserController {
	
	@Autowired
	private CampService service;
	
	@Autowired
	private BoardService bservice;
	
	@Autowired
	private CampingService cservice;
	
	@Autowired
	private CipherUtil util;
	
	private String passwordHash(String pass) {
		try {
			return util.makehash(pass, "SHA-512");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@GetMapping("*")
	public ModelAndView main() {
		ModelAndView mav = new ModelAndView();
		mav.addObject(new User());
		List<Board> boardlist = bservice.mainlist(2);
		List<Board> noticelist = bservice.mainlist(1);
		List<Sale> itemlist = service.salelist();
		mav.addObject("itemlist", itemlist);
		mav.addObject("boardlist",boardlist);
		mav.addObject("noticelist", noticelist);
		List<Camp> maincamp = cservice.maincamp();
		mav.addObject("maincamp", maincamp);
		return mav;
	}
	
	@PostMapping("search")
	public ModelAndView search() {
		ModelAndView mav = new ModelAndView("../site/search");
		return mav;
	}
	
	@GetMapping("join") 
	public ModelAndView join() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
	@PostMapping("join") 
	public ModelAndView join(@RequestParam Map<String, String> param) {
		ModelAndView mav = new ModelAndView();
		//{chkid=1, id=test3, pass=a123456789!, chgpass=a123456789!, name=테스트3, year=1947, 
		// month=4, day=17, firstnum=010, tel=33333333, gender=1, emailid=test3, emailAddr=@naver.com}
		String id = param.get("id");
		String pass = param.get("pass");
		String name = param.get("name");
		Integer gender = Integer.parseInt(param.get("gender"));
		
		String phone = param.get("tel");
		String phoneNum = null;
		if(phone.length() == 7) {
			phoneNum = phone.substring(0,3)+"-"+phone.substring(3);
		} else if(phone.length() == 8) {
			phoneNum = phone.substring(0,4)+"-"+phone.substring(4);
		}
		String tel = param.get("firstnum")+"-"+phoneNum;
		String email = param.get("emailid")+param.get("emailAddr");
		
		Date nowDate = new Date();
		SimpleDateFormat dateparse = new SimpleDateFormat("yyyy-MM-dd");
		
		String lastlog = dateparse.format(nowDate);
		
		String paramMon = param.get("month");
		String mon = null;
		if(paramMon.length() == 1) {
			mon = "0"+paramMon;
		} else {
			mon = paramMon;
		}
		
		String paramDay = param.get("day");
		String day = null;
		if(paramDay.length() == 1) {
			day = "0"+paramDay;
		} else {
			day = paramDay;
		}
		String birth = param.get("year")+"-"+mon+"-"+day;
		Integer rest = 1;
		
		service.insertUser(id, passwordHash(pass), name, gender, tel, email, lastlog, birth, rest);
		throw new LoginException("회원 가입되었습니다.", "login");
	}
	
	@RequestMapping(value="joinCheck", produces="text/plain; charset=utf-8")
	@ResponseBody
	public String userAdd(@RequestParam Map<String, String> param, HttpServletRequest request) {
		String idCheck = null;
		String telCheck = null;
	
		// 아이디
		if(param.get("id") != null) {
			String userid = service.getUserOne(param.get("id"));
			if(userid == null || userid.trim().equals("")) {
				idCheck = "사용";		// 사용 가능
				return idCheck;
			} else {
				idCheck = "불가";
				return idCheck;
			}
		}
		
		String phone = param.get("tel");
		String phoneNum = null;
		if(phone.length() == 10) {
			phoneNum = phone.substring(0,3)+"-"+phone.substring(3,6)+"-"+phone.substring(6);
		} else if(phone.length() == 11) {
			phoneNum = phone.substring(0,3)+"-"+phone.substring(3,7)+"-"+phone.substring(7);
		}
		
		if(param.get("tel") != null) {
			// 전화번호
			String usertel = service.getTel(phoneNum);
			if(usertel == null || usertel.trim().equals("")) {
				telCheck = "사용";		// 사용 가능
				return telCheck;
			} else {
				telCheck = "불가";
				return telCheck;
			}	
		}
		return null;
	}
	
	
	// naver로그인
	@GetMapping("login")
	public ModelAndView login(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		// 네이버
		String clientId = "jtLAQzVD33dfD_4IxaXV";
		String redirectURL = null;
		try {
			redirectURL = URLEncoder.encode("http://14.36.141.71:10062/camp/user/naverlogin","UTF-8");
		} catch(Exception e) {
			e.printStackTrace();
		}
		SecureRandom random = new SecureRandom();
		String state = new BigInteger(130,random).toString();
		String apiURL = "http://nid.naver.com/oauth2.0/authorize?response_type=code";
		apiURL += "&client_id="+clientId;
		apiURL += "&redirect_uri="+redirectURL;
		apiURL += "&state="+state;
		
		// 카카오
		String client_Id = "79d4f0b8f1a64393195daac005b9ecef";	// 카카오
		String redirectURL2 = null;
		try {
			redirectURL2 = URLEncoder.encode("http://14.36.141.71:10062/camp/user/kakaologin","UTF-8");
		} catch(Exception e) {
			e.printStackTrace();
		}
		String apiURL2 = "https://kauth.kakao.com/oauth/authorize?&response_type=code";
		apiURL2 += "&client_id="+client_Id;
		apiURL2 += "&redirect_uri="+redirectURL2;

		
		mav.addObject(new User());	//user 객체 전달
		mav.addObject("apiURL", apiURL);	// 네이버
		mav.addObject("kakaoApiURL", apiURL2);	// 카카오
		session.getServletContext().setAttribute("session", session);
		return mav;
	}
	

	
	// 네이버 로그인
	@RequestMapping("naverlogin")
	public String naverlogin(String code, String state, HttpSession session) {
		System.out.println("2. session.id="+session.getId());
		String clientId = "jtLAQzVD33dfD_4IxaXV";
		String clientSecret = "HO0PVjpjoj";
		String redirectURI=null;
		try {
			redirectURI = URLEncoder.encode("YOUR_CALLBACK_URL", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String apiURL;
		apiURL =  "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
		apiURL += "client_id="+clientId;
		apiURL += "&client_secret="+clientSecret; 
		apiURL += "&redirect_uri="+redirectURI;
		apiURL += "&code="+code;	// 네이버에서 전달해준 파라미터값
		apiURL += "&state=" + state;	// 네이버에서 전달해준 파라미터값. 초기에는 로그인 시작 시 개발자가 전달한 임의의 수
		// 내가 전달한 값을 다시 받음.
		System.out.println("code="+code+", state="+state);
		String access_token = "";
		String refresh_token = "";
		StringBuffer res = new StringBuffer();
		System.out.println("apiURL="+apiURL);
		try {
			URL url = new URL(apiURL); 
			// 네이버에 접속 => 토큰 전달 
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			System.out.print("responseCode="+responseCode);
			if(responseCode == 200) {	// 정상호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			while((inputLine = br.readLine()) != null) {
				res.append(inputLine);
			}
			br.close();
			// res: JSON 형태의 문자열 
			// {"access_token":"AAAAOolWTPpBht8Drpzznw1Y33gVkmwJIeEae1ndjI_Jc6qkiFZcm9z3rMNeI7IaovZMk5cJ4UYrv3gl33vHvgBglz4",...}
			if(responseCode == 200) {
				System.out.println("\n================res 1:");	// 네이버로부터 첫번째 요청에 대한 응답 메시지
				System.out.println("res: " +res.toString());
			}
		} catch(Exception e) {
			System.out.println(e);
		}
		
		// json 형태의 문자열 데이터 => json 객체로 변경
		JSONParser parser = new JSONParser();	// json-siple-1.1.1.jar 파일 설정 필요 -> pom.xml
		JSONObject json = null;;
		try {
			json = (JSONObject)parser.parse(res.toString());
		} catch (ParseException e) {
			e.printStackTrace();
		}	// res(네이버 응답 데이터)를 json 객체로 생성. - java에서도 쓸 수 있음
		String token = (String)json.get("access_token");	// 정상적인 로그인 요청인 경우 네이버가 발생한 코드값
		System.out.println("\n================token: "+token);
		String header = "Bearer " + token ;	//Bearer 다음에 공백 추가 : 공백을 넣어야 인증 정보를 확인해줌
		try {
			apiURL = "https://openapi.naver.com/v1/nid/me";		// 2번째 요청 URL. 토큰값 전송
			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Authorization", header);	// header 값에 인증 정보 넣음
			int responseCode = con.getResponseCode();
			BufferedReader br;
			res = new StringBuffer();
			if(responseCode == 200) { // 정상 호출
				System.out.println("로그인 정보 정상 수신");
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				System.out.println("로그인 정보 오류 수신");
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			while((inputLine = br.readLine()) != null) {
				res.append(inputLine);
			}
			br.close();
			System.out.println(res.toString());
		} catch(Exception e) {
			System.out.println(e);
		}
		try {
			json = (JSONObject) parser.parse(res.toString());
		} catch (ParseException e) {
			e.printStackTrace();
		}
		System.out.println(json);	// 네이버 사용자 정보 수신
		JSONObject jsondetail = (JSONObject)json.get("response");
		
		// == naver로부터 정보를 얻어 온 부분 ↓ ==
		String id = jsondetail.get("id").toString();
		User user = service.selectUserOne(id);
		if(user == null) {
			user = new User();
			user.setId(id);
			user.setName(jsondetail.get("name").toString());
			user.setEmail(jsondetail.get("email").toString());
			user.setTel(jsondetail.get("mobile").toString());
			String naver_birth =  jsondetail.get("birthyear").toString()+"-"+jsondetail.get("birthday").toString();
			SimpleDateFormat dateParser = new SimpleDateFormat("yyyy-MM-dd");
			Date date;
			try {
				date = dateParser.parse(naver_birth);
				user.setBirth(date);
			} catch (java.text.ParseException e) {
				e.printStackTrace();
			}
			if(jsondetail.get("gender").toString().equals("F")) {
				user.setGender(2);
			} else {
				user.setGender(1);
			}
			System.out.println("네이버 성별"+jsondetail.get("gender").toString());
			service.userInsert(user);
		}
		session.setAttribute("loginUser", user);
		return "redirect:mypage?id="+user.getId();
	}
	
	// 카카오 로그인
	@SuppressWarnings("unused")
	@RequestMapping("kakaologin")
	public String kakaologin(String code, HttpSession session) {
		System.out.println("2. session.id="+session.getId());
		
		HashMap<String, Object> userInfo = new HashMap<>();

		String client_Id = "79d4f0b8f1a64393195daac005b9ecef";
		String redirect_uri = null;
		try {
			redirect_uri = URLEncoder.encode("http://14.36.141.71:10062/camp/user/kakaologin", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		String kakaoApiURL;
		kakaoApiURL =  "https://kauth.kakao.com/oauth/token?grant_type=authorization_code";
		kakaoApiURL += "&client_id="+client_Id;
		kakaoApiURL += "&redirect_uri="+redirect_uri;
		kakaoApiURL += "&code="+code;	// 카카오에서 전달해준 코드값
		
		// 내가 전달한 값을 다시 받음.
		System.out.println("code="+code);
		
		StringBuffer res = new StringBuffer();
		System.out.println("kakaoApiURL="+kakaoApiURL);
	
		try {
			URL url = new URL(kakaoApiURL); 
			// 카카오 접속 => 토큰 전달 
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			int responseCode = conn.getResponseCode();
			System.out.print("responseCode="+responseCode);
			
			BufferedReader br;
			if(responseCode == 200) {	// 정상호출
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			
			String inputLine;
			while((inputLine = br.readLine()) != null) {
				res.append(inputLine);
			}
			br.close();
			if(responseCode == 200) {
				System.out.println("\n================res 1:");	// 첫번째 요청에 대한 응답 메시지
				System.out.println("res: " +res.toString());
			}
		} catch(Exception e) {
			System.out.println(e);
		}
		
		// json 형태의 문자열 데이터 => json 객체로 변경
		JSONParser parser = new JSONParser();
		JSONObject json = null;
		
		try {
			json = (JSONObject)parser.parse(res.toString());
			
		} catch(ParseException e) {
			e.printStackTrace();
		}
		
		String access_token = (String) json.get("access_token");
		System.out.println("###### access_token: "+access_token);
		String refresh_token = "";	// 사용자 리프레스 토큰값
		String token_type = "bearer"; // 토큰 타입 (고정)
		try {
			kakaoApiURL = "https://kapi.kakao.com/v2/user/me";
			URL url = new URL(kakaoApiURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "Bearer " + access_token);
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode: "+ responseCode);
			BufferedReader br;
			
			String inputLine;
			String result = "";
			
			if(responseCode == 200) { // 정상 호출
				System.out.println("로그인 정보 정상 수신");
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else { // 에러 발생
				System.out.println("로그인 정보 오류 수신");
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			while((inputLine = br.readLine()) != null) {
				res.append(inputLine);
				result += inputLine;
			}
			System.out.println("정상 정보: "+res.toString());
			
			System.out.println("response body : " + result);
			JsonParser parser2 = new JsonParser();
	        JsonElement element = parser2.parse(result);
	        
	        JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
	        JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
	        
	        String id = element.getAsJsonObject().get("id").getAsString();
	        String nickname = properties.getAsJsonObject().get("nickname").getAsString();
	        String email = kakao_account.getAsJsonObject().get("email").getAsString();
	        String gender = kakao_account.getAsJsonObject().get("gender").getAsString();
	        userInfo.put("id", id);
	        userInfo.put("nickname", nickname);
	        userInfo.put("email", email);
	        userInfo.put("gender", gender);
			
			br.close();
			
//			 == 카카오 정보를 얻어 온 부분  db에 ==
			User user = service.selectUserOne((String)userInfo.get("id"));
			if(user == null) {
				user = new User();
				user.setId((String)userInfo.get("id"));
				user.setName((String)userInfo.get("nickname"));
				user.setEmail((String)userInfo.get("email"));
				if(userInfo.get("gender").equals("female")) {
					user.setGender(2);
				} else {
					user.setGender(1);
				}
				System.out.println("카카오 성별: "+userInfo.get("gender"));
				service.userInsert(user);
			}
			session.setAttribute("loginUser", user);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:mypage?id=" + userInfo.get("id");
	}

	// 일반 로그인
	@PostMapping("login")
	public ModelAndView login(User user, BindingResult bresult, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		if(bresult.hasErrors()) {
			mav.getModel().putAll(bresult.getModel());
			bresult.reject("error.login.id");
			return mav;
		}
		User dbUser = service.selectUserOne(user.getId());
		// id 조회
		if(dbUser == null) {
			bresult.reject("error.login.id");
			mav.getModel().putAll(bresult.getModel());
			return mav;
		}
		
		String id = user.getId();
		int restNum = 1;
		
		// pw 조회
		if(passwordHash(user.getPass()).equals(dbUser.getPass())) {
			if(dbUser.getRest() == 2) {	//성공, 휴면 계정
				service.userRest(id, restNum);
				throw new LoginException("휴면 계정이 해지되었습니다. 다시 로그인 해주세요.", "login");
			} else {
				session.setAttribute("loginUser", dbUser);
				service.logupdate(user.getId());
				mav.setViewName("redirect:mypage?id="+user.getId());
				return mav;
			}
		} else {
			bresult.reject("error.login.id");
			mav.getModel().putAll(bresult.getModel());
		}
		return mav;
	}
	
	@RequestMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:login";
	}
	
	@RequestMapping("mypage")
	public ModelAndView idCheckmypage(String id, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User user = service.selectUserOne(id);
		User loginUser = (User) session.getAttribute("loginUser");

		// 주문내역 불러오기
		List<Sale> salelist = service.saleSelect(loginUser.getId());
		Integer size = salelist.size();
		
		// 장바구니
		List<Cart> cartlist = service.getuserCart(id, 0);
		int total = 0;
		if(cartlist.size() > 0) {
			for(int i = 0; i<cartlist.size(); i++) {
				total += cartlist.get(i).getPrice() * cartlist.get(i).getQuantity();
			}
		} else {
			total = 0;
		}
		mav.addObject("total", total);
		
		// 총 금액
		List<Integer> sumprice = new ArrayList<>();
		Integer sum = 0;
		for(int i = 0; salelist.size() > i; i++) {
			Integer sid = salelist.get(i).getSaleid();
			sum = 0;
			for(Sale s : salelist) {
				if(sid == s.getSaleid()) {
					sum += (s.getPrice()*s.getQuantity());
				}
			}
			sumprice.add(sum);
		}
		mav.addObject("size", size);
		mav.addObject("salelist", salelist);
		mav.addObject("sumprice", sumprice);
		mav.addObject("cartlist", cartlist);
		mav.addObject("user", user);
		
		List<Board> mpblist = bservice.mpblist(id);
		List<Comment> mpclist = bservice.mpclist(id);
		mav.addObject("mpblist", mpblist);
		mav.addObject("mpclist", mpclist);
		List<Good> goodlist = bservice.goodlist(id,1);
		List<Board> boardlist = new ArrayList<>();
		List<Camp> camplist = new ArrayList<>();
		try {
			for(Good g : goodlist) { 
				boardlist.add(bservice.mpglist(g.getGoodno()));
			}
			goodlist = bservice.goodlist(id, 3);
			for(Good g : goodlist) { 
				camplist.add(service.mpllist(g.getGoodno()));
			}
		}catch (NullPointerException e) {
			e.printStackTrace();
		}
		mav.addObject("boardlist", boardlist);
		mav.addObject("camplist", camplist);
		return mav;
	}
	
	@GetMapping({"update","delete"})
	public ModelAndView idCheckUser(String id, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User user = service.selectUserOne(id);
		if(user.getPass() == null || user.getPass().trim().equals("")) {
			throw new LoginException("소셜 SNS 로그인 사용자는 정보 수정이 불가능합니다.", "mypage?id="+user.getId());
		}
		mav.addObject("user", user);
		return mav;
	}
	
	@PostMapping("update")
	public ModelAndView idCheckupdate(@Valid User user, BindingResult bresult, String id, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		// 유효성 검사
		if(bresult.hasErrors()) {
			mav.getModel().putAll(bresult.getModel());
			bresult.reject("error.update.user");
			return mav;
		}
		// 비밀번호 비교
		User loginUser = (User)session.getAttribute("loginUser");
		
		if(!loginUser.getPass().equals(this.passwordHash(user.getPass()))) {
			bresult.reject("error.login.password");
			mav.getModel().putAll(bresult.getModel());
			return mav;
		}
		// 유효성 검사 완료, 비밀번호 일치
		try {
			service.userUpdate(user);
			if(loginUser.getId().equals(user.getId())) {
				session.setAttribute("loginUser", user);
			}
			mav.setViewName("redirect:mypage?id="+user.getId());
		} catch(Exception e) {
			e.printStackTrace();
			throw new LoginException("회원 정보 수정 실패", "update?id="+user.getId());
		}
		return mav;
	}
	
	@PostMapping("mypwForm")
	public String loginCheckPw(String pass, String chgpass, HttpSession session) {
		User loginUser = (User)session.getAttribute("loginUser");
		if(!passwordHash(pass).equals(loginUser.getPass())) {
			throw new LoginException("비밀번호가 틀렸습니다.", "mypwForm");
		}
		// 일치
		try {
			service.chgpass(loginUser.getId(), passwordHash(chgpass));
			loginUser.setPass(passwordHash(chgpass));
		} catch(Exception e) {
			e.printStackTrace();
			throw new LoginException("비밀번호 수정 시 오류 발생", "mypwForm?id="+loginUser.getId());
		}
		return "redirect:mypage?id="+loginUser.getId();
	}
	
	@PostMapping("delete")
	public String idCheckdelete(String pass, String id, HttpSession session) {
		// 관리자 탈퇴 불가능
		if(id.equals("admin")) {
			throw new LoginException("관리자는 탈퇴할 수 없습니다.", "mypage?id="+id);
		}
		// 세션 비밀번호 값과 비교
		User loginUser = (User)session.getAttribute("loginUser");
		if(!passwordHash(pass).equals(loginUser.getPass())) {
			throw new LoginException("비밀번호가 틀렸습니다.", "deleteForm?id="+loginUser.getId());
		}
		
		// 비밀번호 일치, 관리자 아닌 경우
		try {
			service.userDelete(id);
		} catch(DataIntegrityViolationException e) {
			throw new LoginException("주문 정보가 존재 해 탈퇴가 불가능합니다. 관리자에게 문의주세요.", "mypage?id="+loginUser.getId());
		} catch(Exception e) {
			e.printStackTrace();
			throw new LoginException("탈퇴 시 오류가 발생했습니다.", "deleteForm?id="+loginUser.getId());
		}
		
		// admin 회원정보 탈퇴
		if(loginUser.getId().equals("admin")) {
			return "redirect:../admin/list";
		} else {
			session.invalidate();
			throw new LoginException("탈퇴 되었습니다.", "login");
		}
	}
	
	@PostMapping("{url}search")
	public ModelAndView search(User user, BindingResult bresult, @PathVariable String url) {
		ModelAndView mav = new ModelAndView();
		String title = "아이디";
		if(url.equals("pw")) {	// 비밀번호 검증
			title = "비밀번호";
		}
		// 비밀번호 찾기 input에 값이 없을 때
		if(user.getId() == null || user.getId().trim().equals("")) {
			bresult.rejectValue("id", "error.required");
		}
		if(user.getEmail() == null || user.getEmail().trim().equals("")) {
			bresult.rejectValue("email", "error.required");
		}
		if(user.getTel() == null || user.getTel().trim().equals("")) {
			bresult.rejectValue("tel", "error.required");
		}
		if(bresult.hasErrors()) {
			mav.getModel().putAll(bresult.getModel());
			return mav;
		}
		// 입력 값 검증 완료
		if(user.getId() != null && user.getId().trim().equals("")) {
			user.setId(null);
		}
		// 아이디 찾기
		String result = null;
		if(user.getId() == null) {	// 아이디 없는 경우 => 아이디 찾기
			List<User> list = service.getUserlist(user.getTel(), user.getEmail());
			System.out.println("아이디 찾기 list: "+list);
			for(User u : list) {
				if(u != null) {
					result = u.getId();
				}
			}
		} else {	// 아이디 있는 경우 => 비밀번호 초기화 하기
			result = service.getSearch(user);
			if(result != null) {	
				String pass = null;
			}
			service.userPasschg(user.getId(), passwordHash(result));
			mav.addObject("result", result);
			mav.addObject("title", title);
			mav.addObject("id", user.getId());
			mav.setViewName("loginpass");
			return mav;
		}
		if(result == null) {	// 아이디 또는 비밀번호 검색 실패
			mav.getModel().putAll(bresult.getModel());
			return mav;
		}
		mav.addObject("result", result);
		mav.addObject("title", title);
		mav.setViewName("search");
		return mav;
	}
	@RequestMapping("loginpass")
	public ModelAndView loginpass(String id, String pass, HttpServletResponse response) throws IOException {
		ModelAndView mav = new ModelAndView();
		System.out.println("loginpass id:"+id);
		System.out.println("loginpass pass:"+pass);
		PrintWriter out = response.getWriter();
		if(pass.toString().trim().equals("")|| pass == null || pass.length() > 8 || pass.length() < 17) {
		}
		User dbUser = service.selectUserOne(id);
		service.userPasschg(id, passwordHash(pass));
		throw new LoginException("비밀번호가 변경 되었습니다.","login");
	}
	
	
}
