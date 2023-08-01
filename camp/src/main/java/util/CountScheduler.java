package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.concurrent.Exchanger;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.mariadb.jdbc.Connection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.scheduling.annotation.Scheduled;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;
import logic.Camp;
import logic.CampService;
import logic.User;

public class CountScheduler {
	
	@Autowired
	private CampService service;
	
	@Scheduled(cron="0 00 09 13 * ?")
	public void campinsert() throws IOException {
		String gongurl = "http://apis.data.go.kr/B551011/GoCamping/basedList"
				+ "?serviceKey=nTEPXnPuEfFja%2B8NyIriI8RcoAj76sAB4Tl%2FW7vx2EEW1VjNsA8wczqlHhv6ocUsMNFbYnASilpAel15%2Fri3Jg%3D%3D"
				+ "&numOfRows=4000&pageNo=1&MobileOS=ETC&MobileApp=AppTest";
		URL url = new URL(gongurl);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();	// 공공데이터 포털에 접속
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type","application/json");
		System.out.println("Response code: "+conn.getResponseCode());
		BufferedReader rd;
		if(conn.getResponseCode() >= 200 && conn.getResponseCode() <=300) {	// 정상 처리
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		System.out.println(sb.toString());
		Document doc = Jsoup.parse(sb.toString());
		Elements recodes = doc.select("items");
			for(Element r : recodes) {	
				for(Element i : r.select("item")) {	
					Camp camp = new Camp();
					camp.setContentId(Integer.parseInt(i.select("contentId").html()));
					camp.setBrazierCl(i.select("brazierCl").html());
					camp.setSbrsCl(i.select("sbrsCl").html());
					camp.setPosblFcltyCl(i.select("posblFcltyCl").html());
					camp.setHvofBgnde(i.select("hvofBgnde").html());
					camp.setCaravAcmpnyAt(i.select("caravAcmpnyAt").html());
					camp.setToiletCo(i.select("toiletCo").html());
					camp.setSwrmCo(i.select("swrmCo").html());
					camp.setHvofEnddle(i.select("hvofEnddle").html());
					camp.setFeatureNm(i.select("featureNm").html());
					camp.setInduty(i.select("induty").html());
					camp.setLctCl(i.select("lctCl").html());
					camp.setDoNm(i.select("doNm").html());
					camp.setSigunguNm(i.select("sigunguNm").html());
					camp.setAddr1(i.select("addr1").html());
					camp.setTel(i.select("tel").html());
					camp.setHomepage(i.select("homepage").html());
					camp.setResveUrl(i.select("resveUrl").html());
					camp.setGnrlSiteCo(i.select("gnrlSiteCo").html());
					camp.setAutoSiteCo(i.select("autoSiteCo").html());
					camp.setGlampSiteCo(i.select("glampSiteCo").html());
					camp.setCaravSiteCo(i.select("caravSiteCo").html());
					camp.setIndvdlCaravSiteCo(i.select("indvdlCaravSiteCo").html());
					camp.setSiteBottomCl1(i.select("siteBottomCl1").html());
					camp.setSiteBottomCl2(i.select("siteBottomCl2").html());
					camp.setSiteBottomCl3(i.select("siteBottomCl3").html());
					camp.setSiteBottomCl4(i.select("siteBottomCl4").html());
					camp.setSiteBottomCl5(i.select("siteBottomCl5").html());
					camp.setGlampInnerFclty(i.select("glampInnerFclty").html());
					camp.setCaravInnerFclty(i.select("caravInnerFclty").html());
					camp.setPrmisnDe(i.select("prmisnDe").html());
					camp.setOperPdCl(i.select("operPdCl").html());
					camp.setOperDeCl(i.select("operDeCl").html());
					camp.setIntro(i.select("intro").html());
					camp.setExtshrCo(i.select("extshrCo").html());
					camp.setFrprvtWrppCo(i.select("frprvtWrppCo").html());
					camp.setFireSensorCo(i.select("fireSensorCo").html());
					camp.setThemaEnvrnCl(i.select("themaEnvrnCl").html());
					camp.setEqpmnLendCl(i.select("eqpmnLendCl").html());
					camp.setAnimalCmgCl(i.select("animalCmgCl").html());
					camp.setFirstImageUrl(i.select("firstImageUrl").html());
					camp.setFacltNm(i.select("facltNm").html());
					camp.setLineIntro(i.select("lineIntro").html());
					camp.setBizrno(i.select("bizrno").html());
					camp.setFacltDivNm(i.select("facltDivNm").html());
					camp.setMapX(i.select("mapX").html());
					camp.setMapY(i.select("mapY").html());
					service.campinsert(camp);
				}
			}
		}
	@Scheduled(cron="0 12 0 * * ?") 
	public void usercount () {
		// 로그
		Calendar calendar = new GregorianCalendar();
		SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
				
		String now = simpleDate.format(calendar.getTime());		
				
		calendar.add(Calendar.DATE, -1);		
		String yesterday = simpleDate.format(calendar.getTime());		
				
		// list
		List<User> loglist = service.loglist();
		for(int i = 0; i < loglist.size(); i++) {
			String log = simpleDate.format(loglist.get(i).getLastlog());
			if(yesterday.equals(log)) {
				service.userRest(loglist.get(i).getId(), 2);
			}
		}
		
	}
}
