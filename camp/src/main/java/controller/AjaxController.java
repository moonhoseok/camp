package controller;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import logic.CampService;
import logic.Sale;

@RestController
@RequestMapping("ajax")
public class AjaxController {
	@Autowired
	private CampService service;
	
	@RequestMapping("select")
	public List<String> select(String si, String gu, HttpServletRequest request) {
		gu = null;
		BufferedReader fr = null;
		String path = request.getServletContext().getRealPath("/")+"file/sido.txt";
		try {
			fr = new BufferedReader(new FileReader(path));
		}catch(Exception e) {
			e.printStackTrace();
		}
		//Set : 중복불가
		//LinkedHashSet : 순서유지. 중복불가. 리스트아님(첨자사용안됨).
		Set<String> set = new LinkedHashSet<>();
		String data= null;
		if(si==null && gu==null) {  //시도 선택
			try {
				//fr.readLine() : 한줄씩 read
				while((data=fr.readLine()) != null) {
					// \\s+ : \\s(공백) +(1개이상) 
					String[] arr = data.split("\\s+");
					if(arr.length >= 2) set.add(arr[0].trim()); //중복제거됨. 
				}
			} catch(IOException e) {
				e.printStackTrace();
			}
		} else if(gu == null) { //si 파라미터 존재 => 시도선택 : 구군값 전송
		   si = si.trim();
		   try {
			  while ((data = fr.readLine()) != null) {
				 String[] arr = data.split("\\s+");
			  	 if(arr.length >= 2 && arr[0].equals(si) && !arr[1].contains(arr[0]) ) {
					 set.add(arr[1].trim()); //구정보 저장
				 }
			   }
		   } catch (IOException e) {
			   e.printStackTrace();
		   }
		} else { //si 파라미터,gu 파라미터 존재 => 구군선택 : 동값 전송
		   si = si.trim();
		   gu = gu.trim();
		   try {
			  while ((data = fr.readLine()) != null) {
				  String[] arr = data.split("\\s+");
		          if(arr.length >= 3 && arr[0].equals(si) &&
			    	 arr[1].equals(gu) && !arr[0].equals(arr[1]) && !arr[2].contains(arr[1])) {
			          	 if(arr.length > 3 ) {
			          		if(arr[3].contains(arr[1])) continue;
			          		arr[2] += " " + arr[3];
			          	 }
			          	 set.add(arr[2].trim());
			      }
			  }
			} catch (IOException e) {
			    e.printStackTrace();
			}
		}
		List<String> list = new ArrayList<>(set); //Set 객체 => List 객체로 
		System.out.println(list);
		return list; //리스트 객체가 브라우저에 전달. 뷰가 아님.
		             //pom.xml의 fasterxml.jackson... 의 설정에 의해서 브라우저는 배열로 인식함
		
	}
	@RequestMapping(value="select2",
			produces="text/plain; charset=utf-8")  //클라이언트로 문자열 전송. 인코딩 설정이 필요.
	public String select2(String si, String gu, HttpServletRequest request) {
		BufferedReader fr = null;
		String path = request.getServletContext().getRealPath("/")+"file/sido.txt";
		try {
			fr = new BufferedReader(new FileReader(path));
		}catch(Exception e) {	e.printStackTrace();	}
		Set<String> set = new LinkedHashSet<>();
		String data= null;
		if(si==null && gu==null) {
			try {
				while((data=fr.readLine()) != null) {
					String[] arr = data.split("\\s+");
					if(arr.length >= 3) set.add(arr[0].trim()); //중복제거됨. 
				}
			} catch(IOException e) {   e.printStackTrace();	}
		}
		List<String> list = new ArrayList<>(set); 
		return list.toString(); //[서울특별시,경기도....] 		
	}
	@RequestMapping("saledelete")
	@ResponseBody
	public List<Sale> loginChecksaledelete(Integer saleid, String userId) {
		service.saledelete(userId, saleid);
		List<Sale> salelist = service.saleSelect(userId);
		return salelist;
	}
	@RequestMapping("graph2")
	public List<Map.Entry<String, Integer>> graph2() {
		 Map<String,Integer> map = service.graph();
		 List<Map.Entry<String, Integer>> list =  new ArrayList<>(map.entrySet());
		 return list;	               
	}	
}
