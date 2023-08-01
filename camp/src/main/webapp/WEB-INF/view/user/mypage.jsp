<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/21a6628c62.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>내 정보</title>
</head>
<body>
<style>
	.btnWrap {display: flex;    
   		flex-direction: row;
        justify-content: center;
        margin: 50px 0px}
   
    .debtn {padding:10px 40px;
    	background-color: #cddc39;
    	cursor: pointer;
    	border: 1px solid #cddc39;
    	border-bottom:none}
    	
    .select {
    	background-color: #fff;
    }
    .info-table>tr, .info-table>td, .info-table>th {border: 1px solid #dedede;
		text-align: center}
	.btn-lime {background-color: #cddc39}
	.btn-gray {background-color: #d3d3d3}
	header {position: relative;
    		height:150px; 
    		background-color:#cddc39;}
	header>h3 {position:absolute;
		bottom: 5px;
		left: 5%;
		font-weight: bold;}
</style>
	<header>
		<h3>마이 페이지</h3>
	</header>
	<div style="width:90%; margin: 0 auto; padding:50px 0px">
		<div style="display:flex; justify-content: space-between;">
			<table class="w3-table-all" style="width:49%; border:none">
				<tr>
					<th colspan="2" style="font-size:16px">내 정보</th>
				</tr>
				<tr>
					<th>아이디</th>
					<td>${user.id}</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>${user.name}</td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td><fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd"/></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>${user.tel}</td>
				</tr>
				<tr style="border-bottom: none">
					<th>이메일</th>
					<td>${user.email}</td>
				</tr>
				<tr style="border-bottom: none">
					<td colspan="2" class="w3-center">
						<c:if test="${loginUser.id != 'amdin' && loginUser.pass == null }">
							<p>소셜 SNS 로그인 이용자는 정보 수정이 불가능합니다.</p>
							<a href="delete?id=${user.id}" class="btn btn-gray" style="color:#000"">회원 탈퇴</a>
						</c:if>
						<c:if test="${loginUser.id != 'admin' && loginUser.pass != null}">
							<a href="update?id=${user.id}" style="text-decoration: none; color: #000; margin-right:10px"
							class="btn btn-lime">내 정보 변경</a>
							<a href="delete?id=${user.id}" class="btn btn-gray" style="color:#000"">회원 탈퇴</a>
						</c:if>
						<c:if test="${loginUser.id == 'admin'}">
							<a href="../admin/list" class="btn btn-gray" style="float:right; color:#000">회원 목록</a>
						</c:if>
					</td>
				</tr>
			</table>
			<c:if test="${loginUser.id != 'admin' }">
			<table class="w3-table info-table w3-centered" style="width:49%">
				<tr>
					<th colspan="6" style="text-align:left; font-size:16px">장바구니</th>
				</tr>
				<tr style="background-color: #cddc39">
					<th>목록</th>
					<th>상품 이름</th>
					<th>상품 가격</th>
					<th>구매 수량</th>
					<th>주문하기</th>
					<th>삭제</th>
				</tr>
				<form action="../cart/delete" name="deleteform" method="get">
					<input type="hidden" name="id" value="">
				</form>
				<form action="../cart/saleitem" name="saleform" method="post">
					<input type="hidden" name="itemid" value="">
					<input type="hidden" name="userid" value="${user.id}">
				</form>
				<c:if test="${empty cartlist}">
					<tr>
						<td colspan="6" style="padding:60px 0px">장바구니에 등록 된 상품이 없습니다.</td>
					</tr>
				</c:if>
				<c:forEach items="${cartlist}" var="cart">
					<tr id="del${cart.itemid}">
						<td style="width:10%">
							<img src="../img/${cart.pictureUrl}" style="width:98%">
						</td>
						<td style="text-align:left">
							<a href="../shop/detail?id=${cart.itemid}">
								<b style="color:#333">
									<c:if test="${fn:length(cart.name) > 15}">
										${fn:substring(cart.name, 0, 15)} ...
									</c:if>
									<c:if test="${fn:length(cart.name) <= 15}">
										${cart.name}
									</c:if>
								</b>
							</a>
						</td>
						<td><fmt:formatNumber value="${cart.price}" pattern="###,###"/></td>
						<td>${cart.quantity}</td>
						<td><button class="btn btn-lime"
							onclick="javascript:salelist('${cart.itemid}','${user.id}')">주문하기</button></td>
						<td>
							<button value="${cart.itemid}" class="btn btn-gray"
								onclick="javascript:deletecart(${cart.itemid})" id="btn-del">삭제</button>
						</td>
					</tr>
				</c:forEach>
				<tr>
					<th colspan="6">
						총 구매 금액: <fmt:formatNumber value="${total}" pattern="###,###"/>원
					<c:if test="${!empty cartlist}">
						&emsp; <button class="btn btn-lime" onclick="javascript:allsale('${user.id}')">전체 주문하기</button>
					</c:if>
					<c:if test="${empty cartlist}">
						&emsp; <button class="btn btn-lime" onclick="location.href='../shop/list'">쇼핑몰 보기</button>
					</c:if>
					</th>
				</tr>
			</table>
			</c:if>
			<c:if test="${loginUser.id == 'admin' }">
			<div id="barcontainer" style="width:49%; border:1px solid #ffffff">
            	<canvas id="canvas2" style="width:100%"></canvas>
       		</div>
			</c:if>
		</div>
	</div>
	<!--  버튼 -->
	<div class="w3-center btnWrap" style="border-bottom: 1px solid #cddc39">
		<div id="etc" class="debtn" onclick="javascript:btn_div('etcInner','etc')">등록 게시글</div>
		<div id="info" class="debtn" onclick="javascript:btn_div('infoInner','info')">등록 댓글</div>
		<div id="pic" class="debtn" onclick="javascript:btn_div('picInner','pic')">캠핌장 찜</div>
		<div id="loc" class="debtn" onclick="javascript:btn_div('locInner','loc')">게시글 좋아요</div>
		<c:if test="${loginUser.id != 'admin'}">
			<div id="sale" class="debtn" onclick="javascript:btn_div('saleInner','sale')">주문내역</div>
		</c:if>
	</div>
	<div style="width: 90%; margin: 0 auto; margin-bottom: 80px">
		<!-- 등록 게시글 목록 -->
		<div id="etcInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class='far fa-file-alt'></i> 등록 게시글 목록
			</h3>
			<table class="w3-table w3-bordered w3-centered">
				<tr style="background-color: #cddc39">
					<th>제목</th>
					<th>글쓴이</th>
					<th>날짜</th>
					<th>좋아요</th>
					<th>조회수</th>
				</tr>
				<c:forEach items="${mpblist}" var="b">
					<tr>
						<td><a href="../board/detail?num=${b.num}" style="color:#333">${b.title}</a></td>
						<td>${b.writer}</td>
						<td><fmt:formatDate value="${b.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td>${b.likecnt }</td>
						<td>${b.readcnt}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<!-- 등록 댓글 목록 -->
		<div id="infoInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class='far fa-comment-dots'></i> 등록 댓글 목록
			</h3>
			<table class="w3-table w3-bordered w3-centered">
				<tr style="background-color: #cddc39">
					<th>글쓴이</th>
					<th>날짜</th>
					<th>내용</th>
				</tr>
				<c:forEach items="${mpclist}" var="com">
					<tr>
						<td><a href="../board/detail?num=${com.num}" style="color:#333">${com.writer}</a></td>
						<td><fmt:formatDate value="${com.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td>${com.content}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<!-- 캠핑장 찜 목록 -->
		<div id="picInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class="fa fa-heart"></i> 캠핑장 찜 목록
			</h3>
			<table class="w3-table w3-bordered w3-centered">
				<tr style="background-color: #cddc39">
					<th>캠핑장 이름</th>
					<th>전화번호</th>
					<th>주소</th>
					<th>홈페이지</th>
					<th>간단설명</th>
				</tr>
				<c:forEach items="${camplist}" var="cam">
					<tr>
						<td><a href="../site/detail?contentId=${cam.contentId}" style="color:#333">${cam.facltNm}</a></td>
						<td>${cam.tel}</td>
						<td>${cam.addr1}</td>
						<td>${cam.homepage}</td>
						<td>${cam.lineIntro}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
			
		<!-- 게시글 좋아요 목록 -->
		<div id="locInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class="glyphicon glyphicon-thumbs-up"></i> 게시글 좋아요 목록
			</h3>
			<table class="w3-table w3-bordered w3-centered">
				<tr style="background-color: #cddc39">
					<th>제목</th>
					<th>글쓴이</th>
					<th>날짜</th>
					<th>조회수</th>
				</tr>
				<c:forEach items="${boardlist}" var="b">
						<td><a href="../board/detail?num=${b.num}" style="color:#333">${b.title}</a></td>
						<td>${b.writer}</td>
						<td><fmt:formatDate value="${b.regdate}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td>${b.readcnt}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
			
		<c:if test="${loginUser.id !='admin'}">
		<!-- 결제 내역 목록 -->
		<div id="saleInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class='far fa-clipboard'></i> 주문 내역 보기
			</h3>
			<table class="w3-table">
				<tr style="background-color: #cddc39">
					<th>주문 상품</th>
					<th>상품 이름</th>
					<th>주문 수량</th>
					<th>가격</th>
					<th>주문 일자</th>
					<th>총 액</th>
				</tr>
			<c:choose>
				<c:when test="${size > 0}">
					<form name="saledeleteform" action="../cart/saledelete" method="post">
						<input type="hidden" name="saleid" value="">
					</form>
					<c:forEach items="${salelist}" var="sale" varStatus="vs">
						<c:if test= "${salelist[vs.index].saledate != salelist[vs.index-1].saledate}">
						<tr>
							<td colspan="6" style="padding:15px 0px 5px 15px">
								<b style="font-size:15px">결제 일시: <fmt:formatDate value="${sale.saledate}" pattern="yyyy-MM-dd HH:mm"/></b>
							</td>								
						</tr>
						</c:if>
						<tr>
							<td style="width:13%"><img src="../img/${sale.pictureUrl}" style="width:80%"></td>
							<td><a href="../shop/detail?id=${sale.itemid}" style="color:#333;"><b>${sale.name}</b></a></td>
							<td class="w3-center">${sale.quantity}</td>
							<td>
								<fmt:formatNumber value="${sale.price/sale.quantity}" pattern="###,###"/>
							</td>
							<td><fmt:formatDate value="${sale.saledate}" pattern="yyyy-MM-dd"/></td>
							<td><b><fmt:formatNumber value="${sale.price}" pattern="###,###"/></b></td>
						</tr>
						<c:if test= "${salelist[vs.index].saleid != salelist[vs.index+1].saleid}">
						<tr>
							<td colspan="6" class="w3-center" style="background-color: #eee">
								<b>총 구매 금액: <fmt:formatNumber value="${sumprice[vs.index]}" pattern="###,###"/></b>
								<button type="button" class="btn btn-lime" style="float:right" onclick="saledelete(${sale.saleid})">결제 내역 삭제</button>
							</td>								
						</tr>
						</c:if>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="6" class="w3-center">주문 정보가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
	</c:if>
</div>
<script type="text/javascript" 
       src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
	<script>
	$(function() {
		$("#etcInner").show();
		$("#etcInner").siblings().hide();
		$("#etc").addClass("select");
		if('${loginUser.id == admin}'){
			barlinegraph();
		}
	})
		// 결제 내역 지우기
		function saledelete(saleid) {
			$.ajax({
				type:"post",
				url :"${path}/ajax/saledelete",
				data : "saleid="+saleid+"&userId=${user.id}",
				success : function(jdata){
					alert("결제 내역을 삭제했습니다")
					let total =0;
					let html ="";
					html+= "<h3 style='margin-bottom: 20px'> <i class='far fa-clipboard'></i> 주문 내역 보기 "
						+ "</h3> <table class='w3-table'> <tr style='background-color: #cddc39'>" 
						+ "<th>주문 상품</th><th>상품 이름</th><th>주문 수량</th><th>가격</th><th>주문 일자</th><th>총 액</th></tr>";
					
					if(jdata.length>0){
						$.each(jdata, function(i,item){
							let date = new Date(item.saledate);
							let year = date.getYear()
							let mon = date.getMonth()+1
							let day = date.getDate();
							let minute = date.getMinutes();
							let hour = date.getHours();
							year = year+1900
							mon = mon >= 10 ? month : '0' + mon;
					        day = day >= 10 ? day : '0' + day;
					        hour = hour >= 10 ? hour : '0' + hour;
					        minute = minute >= 10 ? minute : '0' + minute;
							if(i==0){
								html+= "<tr><td colspan='6' style='padding:15px 0px 5px 15px'>"
								+ "<b style='font-size:15px'>결제 일시: "+year+"-"+mon+"-"+day+" "+hour+":"+minute+"</b>"
								+ "</td>"
							}else if(jdata[i].saledate != jdata[i-1].saledate){
								html+= "<tr><td colspan='6' style='padding:15px 0px 5px 15px'>"
									+ "<b style='font-size:15px'>결제 일시: "+year+"-"+mon+"-"+day+" "+hour+":"+minute+"</b>"
									+ "</td>"
							}
							html+= "<tr> <td style='width:13%'><img src='../img/"+item.pictureUrl+"' style='width:80%'></td>"
								+ "<td> <a href='../shop/detail?id="+item.itemid+"' style='color:#333'><b>"+item.name+"</b></a></td>"
								+ "<td class='w3-center'>"+item.quantity+"</td>"
								+ "<td>"+new Intl.NumberFormat('ko-KR').format(item.price/item.quantity)+"</td>"
								+ "<td>"+year+"-"+mon+"-"+day+"</td>"
								+ "<td> <b>"+new Intl.NumberFormat('ko-KR').format(item.price)+"</b></td>";
							if(i<(jdata.length-1)){
								if(jdata[i].saleid != jdata[i+1].saleid){
									total += (item.price*item.quantity)
									html+= "<tr> <td colspan='6' class='w3-center' style='background-color:#eee'>"
										+ "<b>총 구매 금액: "+new Intl.NumberFormat('ko-KR').format(total)+"</b>"
										+ "<button type='button' class='btn btn-lime' style='float:right;' onclick='saledelete("+item.saleid+")'>결제 내역 삭제"
										+ "</td></tr>"
									total = 0;
								}else{
									total += (item.price*item.quantity)
								}
							}else if(i == (jdata.length-1)){
								total += (item.price*item.quantity)
								html+= "<tr> <td colspan='6' class='w3-center' style='background-color:#eee'>"
									+ "<b>총 구매 금액: "+new Intl.NumberFormat('ko-KR').format(total)+"</b>"
									+ "<button type='button' class='btn btn-lime' style='float:right;' onclick='saledelete("+item.saleid+")'>결제 내역 삭제"
									+ "</td></tr>"
								total =0;
							}
						})
					}
					$("#saleInner").html(html);
				}
			})
		}
		function allsale(userid) {
			document.saleform.itemid.value=0;
			document.saleform.submit();
		}
		function salelist(itemid, userid) {
			document.saleform.itemid.value=itemid;
			document.saleform.submit();
		}
		function deletecart(itemid) {
			document.deleteform.id.value=itemid;
			document.deleteform.submit();
		}

		function btn_div(id, tab) {
			$(".inner").each(function() {
				$(this).hide();
			})
			$(".debtn").each(function() {
				$(this).removeClass("select")
			})
			$("#" + id).show();
			$("#" + tab).addClass("select")
		}
		let randomColorFactor = function(){
			return Math.round(Math.random() * 255) //0~255사이의 임의의 수 
		}
		let randomColor = function(opa) {
			return "rgba(" + randomColorFactor() + ","
			               + randomColorFactor() + ","
			               + randomColorFactor() + ","
			               + (opa || '.3') + ")"
		}
		function barlinegraph() { 
		    $.ajax("${path}/ajax/graph2",{
		   	 success : function(arr) { //arr : [{"2023-06-01":10},{"2023-05-30":20},....]
		   		 let canvas = "<canvas id='canvas2' style='width:100%'></canvas>"
		   		 $("#barcontainer").html(canvas)  //새로운 canvas 객체로 생성
		   		 barlineGraphPrint(arr)  //그래프 작성
		   	 },
		   	 error : function(e) {
		   		 alert("서버오류:" +e.status)
		   	 }
		    })	
		}
		function barlineGraphPrint(arr) {
			let colors = []  //임의의 색상 설정
			let regdates = [] //작성일자 목록 설정 
			let datas = []   //글작성 건수 목록 설정
			$.each(arr,function(index){
				colors[index] = randomColor(0.5) //임의의 색상 설정
				for(key in arr[index]) { //arr[index] : {"2023-06-01":10}
					regdates.push(key) //작성일자
					datas.push(arr[index][key]) //글작성건수
				}
			})
			let ti="물품별 최근 7일 판매현황";
			let config = {
					type : 'bar',   //그래프 종류
					data : {        //데이터 정보
						datasets : [
						  { type : "line",	borderWidth : 2,   borderColor : colors,
							label :'건수',	fill : false,  	   data : datas },
		                  {	type : "bar",  backgroundColor : colors,  label :'판매량',	data : datas }
		                 ],
					     labels : regdates,
					},
					
					options : {
						responsive : true,
						legend : {display:false},
					    title : {
					    	display : true, 	text : ti,
					    	position : 'bottom'
					    },
					    scales : {
					    	xAxes : [{ display : true,
					    		       scaleLabel : {display : true, labelString : "상품명"}
					    	         }],
					    	yAxes : [{
					    		scaleLabel : { display : true, labelString : "판매량"  },
					    		ticks : {beginAtZero : true}
					    	  }]
					    }
					}
			}
			let ctx = document.getElementById("canvas2")
			new Chart(ctx,config)
		}
	</script>
	<hr>
</body>
</html>