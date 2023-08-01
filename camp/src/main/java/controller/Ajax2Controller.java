package controller;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.net.http.HttpHeaders;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.javassist.bytecode.Descriptor.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpRequest;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("ajax2")
public class Ajax2Controller {
	
	@RequestMapping("select")
	public List<String> select(String si, String gu, HttpServletRequest request) {
		BufferedReader fr = null;
		String path = request.getServletContext().getRealPath("/")+"file/sido2.txt";
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
					if(arr.length >= 5) set.add(arr[0].trim()); //중복제거됨. 
				}
			} catch(IOException e) {
				e.printStackTrace();
			}
		} else if(gu == null) { //si 파라미터 존재 => 시도선택 : 구군값 전송
		   si = si.trim();
		   try {
			  while ((data = fr.readLine()) != null) {
				 String[] arr = data.split("\\s+");
			  	 if(arr.length >= 5 && arr[0].equals(si) && !arr[1].contains(arr[0])) {
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
				  if(arr.length >= 5 && arr[0].equals(si) &&
			    	 arr[1].equals(gu) && !arr[0].equals(arr[1]) && !arr[2].contains(arr[1])) {
					  set.add(arr[2].trim());
			      }
			  }
			} catch (IOException e) {
			    e.printStackTrace();
			}
		}
		List<String> list = new ArrayList<>(set); //Set 객체 => List 객체로 
		
		
		return list;
	}
	
	@RequestMapping(value="getlocation", produces="text/plain; charset=utf-8")
	public String getlocation (String latitude, String longitude, HttpServletRequest request) {
		System.out.println(latitude);
		System.out.println(longitude);
		// 주소 입력 -> 위도, 경도 좌표 추출.
	    BufferedReader io = new BufferedReader(new InputStreamReader(System.in));   
		String clientId = "ejwerh9pii";
		String clientSecret = "mKhADzjBdfOmstZ91FOEQyT41mphLx7R9oZEr3us";
		//https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords={입력_좌표}&sourcecrs={좌표계}
		// &orders={변환_작업_이름}&output={출력_형식}
	    try {
	       // Geocoding 개요에 나와있는 API URL 입력.
	       String apiURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"; // JSON
	       apiURL += "coords="+longitude+","+latitude+"&sourcecrs=epsg:4326";
	       apiURL += "&orders=admcode";
	       apiURL += "&output=json";
	    		   
	       URL url = new URL(apiURL);
	       HttpURLConnection con = (HttpURLConnection) url.openConnection();
	       con.setRequestMethod("GET");
	       
	       // Geocoding 개요에 나와있는 요청 헤더 입력.
	       con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
	       con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
	       
	       // 요청 결과
	       int responseCode = con.getResponseCode();
	       BufferedReader br;
	       System.out.println("responseCode 코드:"+responseCode);
	       if (responseCode == 200) {
	          br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
	       } else {
	          br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	       }
	       
	       String inputLine;
	       StringBuffer response = new StringBuffer();
	       
	       while((inputLine = br.readLine()) != null) {
	          response.append(inputLine);
	       }
	       
	       System.out.println("결과:"+response);
	       
	       br.close();
	       con.disconnect();
	       
	       JSONParser json_parse = new JSONParser();
	       JSONObject obj = (JSONObject) json_parse.parse(response.toString());
	       JSONArray parse_result = (JSONArray) obj.get("results");
	       JSONObject parse_region = (JSONObject) parse_result.get(0);
	       JSONObject region = (JSONObject) parse_region.get("region");
	       JSONObject area1 = (JSONObject) region.get("area1");
	       JSONObject area2 = (JSONObject) region.get("area2");
	       JSONObject area3 = (JSONObject) region.get("area3");
	       
	       String addresult = area1.get("name").toString();
	       addresult += ","+area2.get("name").toString();
	       addresult += ","+area3.get("name").toString();
	       
	       return addresult; 
	       
	    } catch (Exception  e) {
	       System.out.println(e);
	    }
	    
	    return null; 
	}
	
	@RequestMapping(value="selectXy", produces="text/plain; charset=utf-8")
	public String select2(String si, String gu, String dong, HttpServletRequest request) throws IOException, ParseException{
		// 시도 읽어서 x축 y축		단기
		BufferedReader fr = null;
		String path = request.getServletContext().getRealPath("/")+"file/sido2.txt";
		try {
			fr = new BufferedReader(new FileReader(path));
		} catch(Exception e) {	
			e.printStackTrace();	
		}
		// 단기 예보
		String nx = null;
		String ny = null;
		String data = null;
		if (si != null && gu != null && dong != null) {
			try {
				while ((data = fr.readLine()) != null) {
					String[] arr = data.split("\\s+");
					if (arr[0].equals(si) && arr[1].equals(gu) && arr[2].equals(dong)) {
						nx = arr[3].trim();
						ny = arr[4].trim();
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		// 기상청
		SimpleDateFormat f1 = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat f2 = new SimpleDateFormat("HH");
		Date nowDate = new Date();
		String date = f1.format(nowDate);
		String time = f2.format(nowDate);
		Integer hour = Integer.parseInt(time);		
//		String setTime = null;
//		// 2시, 5시, 8시, 11시, 14시, 17시, 20시, 23시
//		if(2 <= hour && hour < 5) setTime = "0200";
//		else if (5 <= hour && hour < 8 ) setTime = "0500";
//		else if (8 <= hour && hour < 11 ) setTime = "0800";
//		else if (11 <= hour && hour < 14 ) setTime = "1100";
//		else if (14 <= hour && hour < 17 ) setTime = "1400";
//		else if (17 <= hour && hour < 20 ) setTime = "1700";
//		else if (20 <= hour && hour < 23 ) setTime = "2000";
//		else setTime = "2300";
		
		   System.out.println("nx: "+nx+", ny: "+ny);
	        
		
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=nY07X%2FnosUoRk5vTJtPdwtlLfVdD2WrLlSNhY3TYcPJdHHo7VHz7svJAp8N7fYhxqf48iOlhi11dRIqL7eg%2F9g%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("809", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON)*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(date, "UTF-8")); 
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode("0500", "UTF-8")); /* 정시단위 */
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(nx,"UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(ny,"UTF-8"));
       
     
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("단기 Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(),"UTF-8"));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        int cnt = 0;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
//        System.out.println(sb.toString());
        rd.close();
        conn.disconnect();
        
		
		// 중기 - 육상(강수)
		BufferedReader fr2 = null;
		String path2 = request.getServletContext().getRealPath("/")+"file/rain.txt"; // 중기 육상 예보 조회 (강수)
		try {
			fr2 = new BufferedReader(new FileReader(path2));	// 육상
		} catch(Exception e) {	
			e.printStackTrace();	
		}
    	String regId = null;
		String stnData = null;
		try {
			while ((stnData = fr2.readLine()) != null) {
				String[] arr = stnData.split("\\s+");
				if (si.contains(arr[0].substring(0, 2))) {
					regId = arr[1].trim();
				}
				if (si.contains("강원")) {
					if (gu.equals("고성군") || gu.equals("속초시") || gu.equals("양양군") 
							|| gu.equals("강릉시") || gu.equals("동해시")
							|| gu.equals("삼척시") || gu.equals("태백시")) {
						regId = "11D20000"; // 영동
					} else {
						regId = "11D10000"; // 영서
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		String tmFc = null;
		if(hour < 18) {
			tmFc = date+"0600";
		} else {
			tmFc = date+"1800";
		}
		StringBuilder urlBuil = new StringBuilder("http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst");
		urlBuil.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=nY07X%2FnosUoRk5vTJtPdwtlLfVdD2WrLlSNhY3TYcPJdHHo7VHz7svJAp8N7fYhxqf48iOlhi11dRIqL7eg%2F9g%3D%3D");
		urlBuil.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
		urlBuil.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
		urlBuil.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); 
		urlBuil.append("&" + URLEncoder.encode("regId","UTF-8") + "=" + URLEncoder.encode(regId, "UTF-8")); // 지역번호
		urlBuil.append("&" + URLEncoder.encode("tmFc","UTF-8") + "=" + URLEncoder.encode(tmFc, "UTF-8")); 	// 시간
	         
        URL url2 = new URL(urlBuil.toString());
        HttpURLConnection con = (HttpURLConnection) url2.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("Content-type", "application/json");
        System.out.println("육상(강수) Response code: " + con.getResponseCode());
        BufferedReader rd2;
        if(con.getResponseCode() >= 200 && con.getResponseCode() <= 300) {
            rd2 = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
        } else {
            rd2 = new BufferedReader(new InputStreamReader(con.getErrorStream(),"UTF-8"));
        }
        StringBuilder sb2 = new StringBuilder();
        String line2;
        while ((line2 = rd2.readLine()) != null) {
            sb2.append(line2);
        }
        rd2.close();
        con.disconnect();
		
		
        // 중기 : 기온
		BufferedReader fr3 = null;
		String path3 = request.getServletContext().getRealPath("/")+"file/temp.txt"; // 중기 기온 조회 (기온)
		try {
			fr3 = new BufferedReader(new FileReader(path3));	// 기온
		} catch(Exception e) {	
			e.printStackTrace();	
		}
     	
		String regid = null;
		String temp = null;
		try {
			while((temp = fr3.readLine()) != null) {
				String[] arr = temp.split("\\s+");
				if (gu.indexOf(arr[0]) == 0) {
					regid = arr[1].trim();
					break; // 양구군
				} else if (si.contains(arr[0])) {
					regid = arr[1].trim();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
    	StringBuilder urlBu = new StringBuilder("http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa");
    	urlBu.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=nY07X%2FnosUoRk5vTJtPdwtlLfVdD2WrLlSNhY3TYcPJdHHo7VHz7svJAp8N7fYhxqf48iOlhi11dRIqL7eg%2F9g%3D%3D");
    	urlBu.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
    	urlBu.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
    	urlBu.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON)*/
    	urlBu.append("&" + URLEncoder.encode("regId","UTF-8") + "=" + URLEncoder.encode(regid, "UTF-8")); 
    	urlBu.append("&" + URLEncoder.encode("tmFc","UTF-8") + "=" + URLEncoder.encode(tmFc, "UTF-8")); 
	         
        URL url3 = new URL(urlBu.toString());
        HttpURLConnection co = (HttpURLConnection) url3.openConnection();
        co.setRequestMethod("GET");
        co.setRequestProperty("Content-type", "application/json");
        System.out.println("중기 기온 Response code: " + co.getResponseCode());
        BufferedReader rd3;
        if(co.getResponseCode() >= 200 && co.getResponseCode() <= 300) {
            rd3 = new BufferedReader(new InputStreamReader(co.getInputStream(),"UTF-8"));
        } else {
            rd3 = new BufferedReader(new InputStreamReader(co.getErrorStream(),"UTF-8"));
        }
        StringBuilder sb3 = new StringBuilder();
        String line3;
        while ((line3 = rd3.readLine()) != null) {
            sb3.append(line3);
        }
        rd3.close();
        co.disconnect();
        
        
        // JSON 
        // 초단기 문자열 
        data = sb.toString();		
        JSONParser parser = new JSONParser();
        JSONObject obj = (JSONObject) parser.parse(data);	// 데이터 객체화
        JSONObject parse_response = (JSONObject) obj.get("response");
        JSONObject parse_body = (JSONObject) parse_response.get("body");
        JSONObject parse_items = (JSONObject) parse_body.get("items");
        JSONArray parse_item = (JSONArray) parse_items.get("item");
        JSONObject weather = new JSONObject();
        System.out.println("parse_body"+sb.toString());
        int dataSize = parse_item.size();	
        List<Object> itemlist = new ArrayList<>();
      
        for(int i = 0; i<dataSize; i++) {	
        	Map<String, Object> itemset = new LinkedHashMap<>();
        	weather = (JSONObject) parse_item.get(i);
        	if(weather.get("category").equals("TMP") || weather.get("category").equals("SKY") ||
        	weather.get("category").equals("REH") || weather.get("category").equals("POP") || 
        	weather.get("category").equals("PTY")) {
	        	if(date.equals(weather.get("fcstDate"))
	        	  		||(!date.equals(weather.get("fcstDate")) && weather.get("fcstTime").equals("0500"))
	            		||(!date.equals(weather.get("fcstDate")) && weather.get("fcstTime").equals("1700"))) {	
	        		itemset.put("fcstTime", weather.get("fcstTime"));
	        		itemset.put("fcstDate", weather.get("fcstDate"));
	        		itemset.put("category", weather.get("category"));
	        	    itemset.put("fcstValue", weather.get("fcstValue"));
	        	    itemlist.add(itemset);
	            } 
        	} 
        }
        JSONObject weatherresult = new JSONObject();
        weatherresult.put("dangi", itemlist);
        
        // 중기 강수
        String rainData = sb2.toString();
        JSONParser rainparser = new JSONParser();
        JSONObject rainobj = (JSONObject) rainparser.parse(rainData);
        JSONObject rain_response = (JSONObject) rainobj.get("response");
        JSONObject rain_body = (JSONObject) rain_response.get("body");
        JSONObject rain_items = (JSONObject) rain_body.get("items");
        JSONArray rain_item = (JSONArray) rain_items.get("item");

        JSONObject rain = new JSONObject();
        rain = (JSONObject) rain_item.get(0);
        List<Object> rainlist = new ArrayList<>();
        for(int i = 3; i<=7; i++) {	
        	Map<String, Object> itemset = new LinkedHashMap<>();
        	itemset.put("wf"+i+"Am", rain.get("wf"+i+"Am"));
        	itemset.put("wf"+i+"Pm", rain.get("wf"+i+"Pm"));
        	itemset.put("rnSt"+i+"Am", rain.get("rnSt"+i+"Am"));
        	itemset.put("rnSt"+i+"Pm", rain.get("rnSt"+i+"Pm"));
        	rainlist.add(itemset);
        }
        JSONObject rainresult = new JSONObject();
        rainresult.put("rain", rainlist);
        
        // 중기 기온
        String tempData = sb3.toString();
        JSONParser tempparser = new JSONParser();
        JSONObject tempobj = (JSONObject) tempparser.parse(tempData);
        JSONObject temp_response = (JSONObject) tempobj.get("response");
        JSONObject temp_body = (JSONObject) temp_response.get("body");
        JSONObject temp_items = (JSONObject) temp_body.get("items");
        JSONArray temp_item = (JSONArray) temp_items.get("item");
        
        JSONObject tempitem = new JSONObject();
        tempitem = (JSONObject) temp_item.get(0);
        List<Object> templist = new ArrayList<>();
        for(int i=3; i<=7; i++) {
        	Map<String, Object> itemset = new LinkedHashMap<>();
        	itemset.put("taMax"+i, tempitem.get("taMax"+i));
        	itemset.put("taMin"+i, tempitem.get("taMin"+i));
        	templist.add(itemset);
        }
        
        JSONObject tempresult = new JSONObject();
        tempresult.put("temp", templist);
        
        // Object -> Array
        JSONArray weaitem = new JSONArray();
        weaitem.add(weatherresult);
        weaitem.add(rainresult);
        weaitem.add(tempresult);
        
        return weaitem.toString();
	}
	
}