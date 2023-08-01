<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>날씨</title>
</head>
<body>
<style>
 	* {margin: 0; padding: 0;}
    a {text-decoration: none;}
    ol, ul {list-style: none}
    header {position: relative;
    		height:150px; 
    		background-color:#cddc39;}
	header>h3 {position:absolute;
		bottom: 5px;
		left: 5%;
		font-weight: bold;}
	.wrap {display:flex;
		width:90%;
		margin-left:10%;
		justify-content: space-between;
		margin-bottom: 60px}
	.titleWrap {display:flex;
		width:90%;
		margin-left:10%;
		margin-top:50px;
		justify-content: space-between;}	
	
	.whole {width:38%;
		background-color: lightSkyBlue;
		border-radius: 15px;
		padding: 15px 0px}
	.wholeImg {width: 60%;
			margin-left: 20%}
	.weeked {width:50%}
	
	.whole_bar {display:flex;
		margin-bottom: 20px;
		margin-left: 15px}
	.whole_bar li {
		background-color: #fff;
		padding: 7px 15px 5px 15px;}
	
	.whole_bar li.on {background-color: deepSkyBlue  }
	.weeked>img {width:75%}
	
	
	.searchWrap {width:80%;
		margin: 0 auto;
		margin-bottom: 60px
	}
	
	.btn-lime {background-color: #cddc39}
	
	.weatherImg {width: 50px}
	.weatherBig {width: 18%}
	
	#today {text-align: center;
		 border: 1px solid #ddd; 
		 border-radius: 15px; 
		 padding-top: 5px;
		 padding-bottom : 25px; 
		 margin-bottom: 25px;}
	 
</style>
	<header>
		<h3>날씨 보기</h3>
	</header>
	<div class="searchWrap">
		<h3 style="font-weight: bold; margin-bottom:15px; padding-top:40px">날씨 찾아보기</h3>
		<table class="w3-table" style="width:100%">
			<tr>
				<td id="si" style="margin-right:5px">
					<select name="si" onchange="getText('si')" class="w3-input w3-border w3-round-large">
						<option value="">시,도 선택</option>
					</select>
				</td>
				<td id="gi">
					<select name="gu" onchange="getText('gu')" class="w3-input w3-border w3-round-large">
						<option value="">구,군 선택</option>
					</select>
				</td>
				<td id="dong">
					<select name="dong" class="w3-input w3-border w3-round-large">
						<option value="">동,리 선택</option>
					</select>
				</td>
				<td>
					<button class="btn btn-lime" onclick="getXy(1)">검색</button>
				</td>
			</tr>
		</table>
		<div id="result" style="padding:15px">
		
		</div>
	</div>
	<script>
	window.onload=function(){
		getLocation();
	}
	$(function(){
		getSido();
	})
	let area1;
	let area2;
	let area3;
	function getLocation() {
		let latitude;
		let longitude;
		if (navigator.geolocation) { // GPS를 지원하면
			navigator.geolocation.getCurrentPosition(function(position) {
				latitude = position.coords.latitude;
				longitude = position.coords.longitude
				console.log(latitude);
				console.log(longitude);
				let params = "latitude="+latitude+"&longitude="+longitude;
				console.log(params)
				$.ajax({
					url: "${path}/ajax2/getlocation",
					data: params,
					success : function(data) {
						let dataresult = data.split(",");
						area1 = dataresult[0];
						area2 = dataresult[1];
						area3 = dataresult[2];
						getXy(2)
					}
				})
			}, function(error) {
				console.error(error);
			}, {
				enableHighAccuracy: false,
				maximumAge: 0,
				timeout: Infinity
		    });
		} else {
			alert('GPS를 지원하지 않습니다');
		}
	}
	
	
	function getSido() {  //서버에서 리스트객체를 배열로 직접 전달 받음
		$.ajax({
			   url : "${path}/ajax2/select",
			   success : function(arr) {
				   //arr : 서버에서 전달 받는 리스트 객체를 배열로 인식함
				   $.each(arr,function(i,item){
					   // i : 인덱스. 첨자. 0부터시작
					   //item : 배열의 요소
					   $("select[name=si]").append(function(){
						   return "<option>"+item+"</option>"
					   })
				   })
			   }
		   })
   }
	function getText(name) { //si
		let city = $("select[name='si']").val();  //시도 선택값 
		let gu = $("select[name='gu']").val();    //구군 선택값
		let disname;
		let toptext="구군을 선택하세요";
		let params = "";
		if (name == "si") { //시도 선택한 경우
			params = "si=" + city.trim();
			disname = "gu"; 
		} else if (name == "gu") { //구군 선택한 경우 
			params = "si="+city.trim()+"&gu="+gu.trim();
			disname = "dong";
			toptext="동리를 선택하세요";		
		} else { 
			return ;
		}
		$.ajax({
		  url : "${path}/ajax2/select",
		  type : "POST",    
		  data : params,  			
		  success : function(arr) {
			  $("select[name="+disname+"] option").remove(); //출력 select 태그의 option 제거
			  $("select[name="+disname+"]").append(function(){
				  return "<option value=''>"+toptext+"</option>"
			  })
			  $.each(arr,function(i,item) {  //서버에서 전송 받은 배열값을 option 객체로 추가
				  $("select[name="+disname+"]").append(function(){
					  return "<option>"+item+"</option>"
				  })
			  })
		  }
	   })				
	}
	function getXy(num){
		let siname;
		let gunname;
		let dongname;
		if(num==1){	// 선택값
			siname = $("select[name='si']").val();  //시도 선택값 
			gunname = $("select[name='gu']").val();    //구군 선택값
			dongname = $("select[name='dong']").val();
		}
		if(num==2){	// api에서 제공하는 지역 이름
			siname = area1;  	
			gunname = area2;    
			dongname = area3;
		}
		let params = "si="+siname+"&gu="+gunname+"&dong="+dongname;
		let html;
		$.ajax({
			url : "${path}/ajax2/selectXy",
			type : "POST",
			data : params,
			success : function(data) {
				let obj = JSON.parse(data);
				let dangi = obj[0].dangi
				let rain = obj[1].rain
				let temp = obj[2].temp
				
				// 강수 
				let rainAm;
				let rainPm;
				let rnAm;
				let rnPm;
				
				// 최고 최저 온도
				let taMin
				let taMAx
				
				let date = new Date();
				let year = date.getYear()+1900;
				let mon = date.getMonth()+1;
				mon = mon >=10? mon:"0"+mon;
				let day = date.getDate();
				day = day >= 10 ? day:"0"+day;
			
				let da = date.getDate();
				
				// json data에 맞는 날짜 시간				
				
				let time = date.getHours();
				time = time >= 10 ? time+"00":"0"+time+"00";
				
				// 오늘
				let html2;
				let html =  "<h3 style='font-weight:bold'>"+siname+" "+gunname+" "+dongname+" 날씨</h3>"
				html += "<div id='today'>"
				for(i=0; i<90; i++) {
					let d = dangi[i]
					let today = year+""+mon+""+day;
					if(time == d["fcstTime"] && today == d["fcstDate"]) {
						if(d["category"] == "TMP") {
								html += "<div style='display:flex;justify-content: center; align-items: center;'>";
								html += "<span style='padding-top:20px; font-size:16px'>현재 온도</span>"
								html += "<h3 style='font-weight:bold; font-size: 50px; padding: 0px 10px;'>"
								html += d["fcstValue"]+"&deg;</h3>";
								html += "</div>"
						}
						if(d["category"] == "SKY") { // 하늘 상태 
							if(d["fcstValue"] == 1) {
								html2 = "<img src='../img/sun.png' alt='맑음' class='weatherBig'>"
							} else if (d["fcstValue"] == 2) {
								html2 = "<img src='../img/sun_cloud.png' alt='조금 흐림' class='weatherBig'>"
							} else if (d["fcstValue"] == 3) {
								html2 = "<img src='../img/cloud.png' alt='흐림' class='weatherBig'>"
							} else if (d["fcstValue"] == 4) {
								html2 = "<img src='../img/cloud2.png' alt='구름 많음' class='weatherBig'>"
							} 
						} 
						if(d["category"] == "PTY") { // 강수 상태 
							if(d["fcstValue"] == 1) {	// 비
								html2 = "<img src='../img/rain.png' alt='비' class='weatherBig'>"
							} else if (d["fcstValue"] == 2) {	// 비/눈
								html2 = "<img src='../img/snowRainCloud.png' alt='비,눈' class='weatherBig'>"
							} else if (d["fcstValue"] == 3) {	// 눈
								html2 = "<img src='../img/snow.png' alt='눈' class='weatherBig'>"
							}
						}
						if(d["category"] == "POP") {
							html += "<div style='display:flex; flex-direction: column-reverse; align-items: center;'>"
							html += "<ul style='display:flex'><li>강수 확률: <b style='padding:10px'>"+d["fcstValue"]+"%</b></li>"
						}
						if(d["category"] == "REH") {
							html += "<li>  습도: <b style='padding:10px'>"+d["fcstValue"]+"%</b></li></ul>"
						}
					}
				}
				html += html2;
				html += "</div>"
				html += "</div>"
				
				// 단기 - 이틀
				let lowTemp;
				let html3;
				html += "<table class='w3-center' style='width: 100%; padding:15px 0px;'><tr>";
				for(i=90; i<100; i++) {
					let d = dangi[i];		// 90부터 시작
					let day1 = date.getDate()+1;
					day1 = day1 >= 10 ? day1:"0"+day1;
					let today = year+""+mon+""+day1;
					if("0500" == d["fcstTime"] && today == d["fcstDate"]) {
						if(d["category"] == "TMP") {
							lowTemp = "<b style='color:skyblue; font-size:16px'>"+d["fcstValue"]+"</b>"
						}
						if(d["category"] == "POP") {
							html += "<td><b>내일</b><p>"+mon+"-"+day1+"</p></td>";
							html += "<td>오전"
							html += "<p>"+d["fcstValue"]+"%</p></td>"
						}
						if(d["category"] == "SKY") { // 하늘 상태 
							if(d["fcstValue"] == 1) {
								html3 = "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {
								html3 = "<td><img src='../img/sun_cloud.png' alt='조금 흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {
								html3 = "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 4) {
								html3 = "<td><img src='../img/cloud2.png' alt='구름 많음' class='weatherImg'></td>"
							} 
						} 
						if(d["category"] == "PTY") { // 강수 상태 
							if(d["fcstValue"] == 1) {	// 비
								html3 = "<td><img src='../img/rain.png' alt='비' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {	// 비/눈
								html3 = "<td><img src='../img/snowRainCloud.png' alt='비,눈' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {	// 눈
								html3 = "<td><img src='../img/snow.png' alt='눈' class='weatherImg'></td>"
							}
						}
					} 
				}
				html+= html3
				// 오후
				let html4;
				for(i=90; i<100; i++) {
					let d = dangi[i];		// 90부터 시작
					let day1 = date.getDate()+1;
					day1 = day1 >= 10 ? day1:"0"+day1;
					let today = year+""+mon+""+day1;
					if("1700" == d["fcstTime"] && today == d["fcstDate"]) {
						if(d["category"] == "TMP") {
							highTemp = "<b style='color:red; font-size:16px'>"+d["fcstValue"]+"</b>"
						}
						if(d["category"] == "POP") {
							html += "<td>오후"
							html += "<p>"+d["fcstValue"]+"%</p></td>"
						}
						if(d["category"] == "SKY") { // 하늘 상태 
							if(d["fcstValue"] == 1) {
								html4 = "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {
								html4 = "<td><img src='../img/sun_cloud.png' alt='조금 흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {
								html4 = "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 4) {
								html4 = "<td><img src='../img/cloud2.png' alt='구름 많음' class='weatherImg'></td>"
							} 
						} 
						if(d["category"] == "PTY") { // 강수 상태 
							if(d["fcstValue"] == 1) {	// 비
								html4 = "<td><img src='../img/rain.png' alt='비' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {	// 비/눈
								html4 = "<td><img src='../img/snowRainCloud.png' alt='비,눈' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {	// 눈
								html4 = "<td><img src='../img/snow.png' alt='눈' class='weatherImg'></td>"
							}
						}
					} 
				}
				html += html4;
				html += "<td style='padding-right:10px'>"+lowTemp+"/"+highTemp+"</td>"
			
				// 단기 - 2일 후
				let lowTemp1;
				let html5;
				for(i=100; i<110; i++) {
					let d = dangi[i];		// 90부터 시작
					let day2 = date.getDate()+2;
					day2 = day2 >= 10 ? day2:"0"+day2;
					let today = year+""+mon+""+day2;
					if("0500" == d["fcstTime"] && today == d["fcstDate"]) {
						if(d["category"] == "TMP") {
							lowTemp1 = "<b style='color:skyblue; font-size:16px'>"+d["fcstValue"]+"</b>"
						}
						if(d["category"] == "POP") {
							html += "<td><b>2일 후</b><p>"+mon+"-"+day2+"</p></td>";
							html += "<td>오전"
							html += "<p>"+d["fcstValue"]+"%</p></td>"
						}
						if(d["category"] == "SKY") { // 하늘 상태 
							if(d["fcstValue"] == 1) {
								html5 = "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {
								html5 = "<td><img src='../img/sun_cloud.png' alt='조금 흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {
								html5 = "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 4) {
								html5 = "<td><img src='../img/cloud2.png' alt='구름 많음' class='weatherImg'></td>"
							} 
						} 
						if(d["category"] == "PTY") { // 강수 상태 
							if(d["fcstValue"] == 1) {	// 비
								html5 = "<td><img src='../img/rain.png' alt='비' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {	// 비/눈
								html5 = "<td><img src='../img/snowRainCloud.png' alt='비,눈' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {	// 눈
								html5 = "<td><img src='../img/snow.png' alt='눈' class='weatherImg'></td>"
							}
						}
					} 
				}
				html+= html5
				// 오후
				let html6;
				let highTemp1;
				for(i=100; i<110; i++) {
					let d = dangi[i];		// 90부터 시작
					let day2 = date.getDate()+2;
					day2 = day2 >= 10 ? day2:"0"+day2;
					let today = year+""+mon+""+day2;
					if("1700" == d["fcstTime"] && today == d["fcstDate"]) {
						if(d["category"] == "TMP") {
							highTemp1 = "<b style='color:red; font-size:16px'>"+d["fcstValue"]+"</b>"
						}
						if(d["category"] == "POP") {
							html += "<td>오후"
							html += "<p>"+d["fcstValue"]+"%</p></td>"
						}
						if(d["category"] == "SKY") { // 하늘 상태 
							if(d["fcstValue"] == 1) {
								html6 = "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {
								html6 = "<td><img src='../img/sun_cloud.png' alt='조금 흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {
								html6 = "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 4) {
								html6 = "<td><img src='../img/cloud2.png' alt='구름 많음' class='weatherImg'></td>"
							} 
						} 
						if(d["category"] == "PTY") { // 강수 상태 
							if(d["fcstValue"] == 1) {	// 비
								html6 = "<td><img src='../img/rain.png' alt='비' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 2) {	// 비/눈
								html6 = "<td><img src='../img/snowRainCloud.png' alt='비,눈' class='weatherImg'></td>"
							} else if (d["fcstValue"] == 3) {	// 눈
								html6 = "<td><img src='../img/snow.png' alt='눈' class='weatherImg'></td>"
							}
						}
					} 
				}
				html += html6;
				html += "<td style='padding-right:20px'>"+lowTemp1+"/"+highTemp1+"</td>"
			
				// 중기
				for(i=0, j=3; i<5; i++, j++) {
					let r = rain[i]
					rainAm = r["wf"+j+"Am"]
					rainPm = r["wf"+j+"Pm"]
	
					let t = temp[i]
					rnAm = r["rnSt"+j+"Am"]
					rnPm = r["rnSt"+j+"Pm"]
					taMin = t["taMin"+j]
					taMax = t["taMax"+j]
					if(i%2 == 0) {
						html+= "<tr style='line-height: 7.5rem'>"
					}
					html += "<td style='line-height:2.3rem'><b>"+j+"일 후</b><p>"+mon+"-"+(da+j)+"</p></td>"	// 날짜
					html += "<td style='line-height:2.3rem;'>오전<p>"+rnAm+"%</p></td>"
					if(rainAm == "맑음") {
						html+= "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"	
					} else if(rainAm == "흐림") {
						html+= "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"						// 오전
					} else if(rainAm == "흐리고 소나기" || rainAm == "흐리고 비") {
						html+= "<td><img src='../img/shower.png' alt='흐리고 비' class='weatherImg'></td>"	
					} else if (rainAm == "흐리고 눈") {
						html+= "<td><img src='../img/cloudSnow.png' alt='흐리고 눈' class='weatherImg'></td>"	
					} else if (rainAm == "흐리고 비/눈") {
						html+= "<td><img src='../img/snowRain.png' alt='흐리고 비/눈' class='weatherImg'></td>"	
					} else if(rainAm == "구름많음") {
						html+= "<td><img src='../img/cloud2.png' alt='구름많음' class='weatherImg'></td>"					
					} else if(rainAm == "구름많고 비" || rainAm == "구름많고 소나기") {
						html+= "<td><img src='../img/rain.png' alt='구름많고 비' class='weatherImg'></td>"	
					} else if (rainAm == "구름많고 눈") {
						html+= "<td><img src='../img/snow.png' alt='구름많고 눈' class='weatherImg'></td>"	
					} else if (rainAm == "구름많고 비/눈") {
						html+= "<td><img src='../img/snowRainCloud.png' alt='구름많고 비/눈' class='weatherImg'></td>"	
					}
					// 오후
					html += "<td style='line-height:2.3rem'>오후<p>"+rnPm+"%</p></td>"
					if(rainPm == "맑음") {
						html+= "<td><img src='../img/sun.png' alt='맑음' class='weatherImg'></td>"	
					} else if(rainPm == "흐림") {
						html+= "<td><img src='../img/cloud.png' alt='흐림' class='weatherImg'></td>"						
					} else if(rainPm == "흐리고 소나기" || rainPm == "흐리고 비") {
						html+= "<td><img src='../img/shower.png' alt='흐리고 비' class='weatherImg'></td>"	
					} else if (rainPm == "흐리고 눈") {
						html+= "<td><img src='../img/cloudSnow.png' alt='흐리고 눈' class='weatherImg'></td>"	
					} else if (rainPm == "흐리고 비/눈") {
							html+= "<td><img src='../img/snowRain.png' alt='흐리고 비/눈' class='weatherImg'></td>"	
					} else if(rainPm == "구름많음") {
						html+= "<td><img src='../img/cloud2.png' alt='구름많음' class='weatherImg'></td>"						
					} else if(rainPm == "구름많고 비" || rainPm == "구름많고 소나기") {
						html+= "<td><img src='../img/rain.png' alt='구름많고 비' class='weatherImg'></td>"	
					} else if (rainPm == "구름많고 눈") {
						html+= "<td><img src='../img/snow.png' alt='구름많고 눈' class='weatherImg'></td>"	
					} else if (rainPm == "구름많고 비/눈") {
						html+= "<td><img src='../img/snowRainCloud.png' alt='구름많고 비/눈' class='weatherImg'></td>"	
					}
					// 온도
					html+= "<td style='padding-right:20px'><b style='color:skyblue; font-size:16px'>"+taMin+"</b>"
					html+= " / <b style='color:red; font-size:16px'>"+taMax+"</b>"+"</td>"						// 최저 최고
					if(i%2 == 1) {
						html+= "</tr>"
					}
					
				}
				html+= "<td></td>"
				html+= "<td></td>"
				html+= "<td></td>"
				html+= "<td></td>"
				html+="</tr></table>"
				
				$("#result").html(html);
			}
		})
	}
	</script>
</body>
</html>