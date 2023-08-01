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
	
	
	.searchWrap {width:90%;
		margin-left:10%;
		margin-bottom: 60px
	}
	
	.btn-lime {background-color: #cddc39}
</style>
	<header>
		<h3>날씨 보기</h3>
	</header>
	<div class="titleWrap">
		<h3 style="font-weight: bold; margin-bottom:15px; width: 38%">현재 전국 날씨</h3>
		<h3 style="font-weight: bold; margin-bottom:15px; width: 50%">주간 날씨</h3>
	</div>
	<div class="wrap">
		<div class="whole">
			<ul class="whole_bar">
				<li style="border-radius: 25px 0px 0px 25px" class="libtn on">현재</li>
				<li class="libtn">오전</li>
				<li style="border-radius: 0px 25px 25px 0px" class="libtn">오후</li>
			</ul>
			<img alt="날씨" src="../img/whole.png" class="wholeImg">
		</div>
		<div class="weeked">
			<img alt="주간 날씨" src="../img/weeked.png">
			<img alt="주간 날씨" src="../img/weeked2.png">
		</div>
	</div>
	<div class="searchWrap">
		<h3 style="font-weight: bold; margin-bottom:15px">다른 지역 날씨 찾아보기</h3>
		<table class="w3-table" style="width:90%">
			<tr>
				<td id="si">
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
					<button class="btn btn-lime" onclick="getXy('si','gu')">검색</button>
				</td>
			</tr>
		</table>
		<div id="result">
		
		</div>
	</div>
	<script>
	$(function(){
		getSido();
	})
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
	function getXy(){
		let siname = $("select[name='si']").val();  //시도 선택값 
		let gunname = $("select[name='gu']").val();    //구군 선택값
		let dongname = $("select[name='dong']").val();
		let params = "si="+siname+"&gu="+gunname+"&dong="+dongname;
		$.ajax({
			url : "${path}/ajax2/selectXy",
			type : "POST",
			data : params,
			success : function(data) {
				let html;
				let obj = JSON.parse(data);
				let resultMsg = obj.response.header.resultMsg;
			
				if(resultMsg === "NO_DATA") {
					html = "<p>검색 결과가 없습니다</p>";
					$("#result").html(html);
				} else if (resultMsg === "NORMAL_SERVICE") {
					let items = obj.response.body.items;
					html = "<h4 style='font-weight: bold'>"+siname+" "+gunname+" "+dongname+" 날씨</h4>";
					console.log(items.item[0].category);
					if(items.item[0].category == "TMP") { // 기온
						html+= "<table><tr><th>"+this.fcstValue+"<th></tr>"
					}
					
					
					html += "</table>";
					$("#result").html(html);
				}
			}
		})
		
	}
	</script>
</body>
</html>