<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/detail.css">
<script src="https://kit.fontawesome.com/21a6628c62.js"
	crossorigin="anonymous"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>캠핑장 상세 정보</title>
<style>
.mainImg {
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	width: 48%;
	height: 52vh
}
</style>
</head>
<body>
	<br>
	<br>
	<br>
	<br>
	<br>

	<div style="width: 90%; margin: 0 auto; padding-bottom: 60px">
		<div class="wrap">
			<div class="mainImg">
				<c:if test="${camp.firstImageUrl != null}">
					<img src="${camp.firstImageUrl}" style="width: 90%">
				</c:if>
				<c:if test="${camp.firstImageUrl == ''}">
					<img src="${path}/img/campimg.jpg" width="590px" height="393px">
				</c:if>
			</div>
			<div class="info">
				<h3>${camp.facltNm}</h3>
				<table class="w3-table w3-bordered"
					style="border-top: 2px solid #cddc39; border-bottom: 2px solid #cddc39;">
					<tr>
						<th>주소</th>
						<td>${camp.addr1}</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td>${camp.tel}</td>
					</tr>
					<tr>
						<th>캠핑장 환경</th>
						<td>${camp.lctCl}/ ${camp.facltDivNm }</td>
					</tr>
					<tr>
						<th>캠핑장 유형</th>
						<td>${camp.induty}</td>
					</tr>
					<tr>
						<th>운영 기간</th>
						<td>${camp.operPdCl}</td>
					</tr>
					<tr>
						<th>운영 일</th>
						<td>${camp.operDeCl}</td>
					</tr>
					<tr>
						<th>홈페이지</th>
						<td><a href="${camp.homepage}" target="_blank">${camp.homepage}</a></td>
					</tr>
				</table>
				<div style="margin-top: 15px">
					<c:if test="${likeselect ==0 }">
						<button class="btn btn-white" onclick="change('like')" id="like">
							<i class="glyphicon glyphicon-thumbs-up" style="color: blue"></i>
							<b>추천</b>
						</button>
					</c:if>
					<c:if test="${likeselect ==1 }">
						<button class="btn btn-white" style="background-color: #cddc39"
							onclick="change('like')" id="like">
							<i class="glyphicon glyphicon-thumbs-up" style="color: blue"></i>
							<b>추천</b>
						</button>
					</c:if>
					<c:if test="${loveselect ==0 }">
						<button class="btn btn-white" onclick="change('love')" id="love">
							<i class="fa fa-heart" style="color: red"></i> <b>찜하기</b>
						</button>
					</c:if>
					<c:if test="${loveselect ==1 }">
						<button class="btn btn-white" style="background-color: #cddc39"
							onclick="change('love')" id="love">
							<i class="fa fa-heart" style="color: red"></i> <b>찜하기</b>
						</button>
					</c:if>
					<c:if test="${loginUser.id == 'admin' }">
						<button class="btn btn-white" onclick="location.href='campupdate?contentId=${camp.contentId}'" >
							<i class='fas fa-tools'></i>
							 <b>캠핑장 수정</b>
						</button>
					</c:if>

				</div>
			</div>
		</div>
	</div>

	<!-- 상세 안내 -->
	<div class="faci">
		<h3 style="margin-bottom: 45px">부대시설</h3>
		<c:if test="${camp.sbrsCl != null }">
			<div class="faciWrap">
				<c:if test="${fn:contains(camp.sbrsCl,'무선인터넷')}">
					<div>
						<i class='fas fa-wifi' id="wifi"></i>
						<p>와이파이</p>
					</div>
				</c:if>
				<c:if test="${fn:contains(camp.sbrsCl,'전기')}">
					<div>
						<i class='far fa-lightbulb' id="light"></i>
						<p>전기</p>
					</div>
				</c:if>
				<c:if test="${fn:contains(camp.sbrsCl,'마트.편의점')}">
					<div>
						<i class='fas fa-shopping-cart' id="shop"></i>
						<p>마트,편의점</p>
					</div>
				</c:if>
				<c:if test="${fn:contains(camp.sbrsCl,'온수')}">
					<div>
						<i class='fas fa-tint' id="tint"></i>
						<p>온수</p>
					</div>
				</c:if>
				<c:if test="${fn:contains(camp.sbrsCl,'산책로')}">
					<div>
						<i class='fas fa-route' id="route"></i>
						<p>산책로</p>
					</div>
				</c:if>
				<c:if test="${fn:contains(camp.sbrsCl,'물놀이장')}">
					<div>
						<i class='fas fa-swimming-pool' id="pool"></i>
						<p>수영장</p>
					</div>
				</c:if>
				<c:if test="${camp.animalCmgCl !='불가능'}">
					<div>
						<i class='fas fa-dog' id="dog"></i>
						<p>반려동물</p>
					</div>
				</c:if>
			</div>
		</c:if>
	</div>

	<div class="w3-center btnWrap" style="border-bottom: 1px solid #cddc39">
		<div id="etc" class="debtn"
			onclick="javascript:btn_div('etcInner','etc')">기타 주요시설</div>
		<div id="loc" class="debtn"
			onclick="javascript:btn_div('locInner','loc')">위치 안내</div>
	</div>
	<div style="width: 90%; margin: 0 auto; margin-bottom: 80px">
		<!-- 기타 주요시설 -->
		<div id="etcInner" class="inner">
			<h3 style="margin-bottom: 20px">
				<i class="fas fa-duotone fa-check"></i> 기타 주요 시설 안내
			</h3>
			<table class="w3-table w3-bordered"
				style="border-top: 2px solid #cddc39; border-bottom: 2px solid #cddc39;">
				<tr>
					<th>주요시설</th>
					<td>${camp.induty}사이트</td>
				</tr>
				<tr>
					<th>기타 정보</th>
					<td><c:if test="${camp.caravAcmpnyAt != 'N' }">
							개인 카라반 입장 가능 &nbsp;
						</c:if> 반려동물 ${camp.animalCmgCl} &nbsp;</td>
				</tr>
				<tr>
					<th>기타 부대시설</th>
					<td>바다 사이드 쪽은 카라반, 트레일러 입장 금지</td>
				</tr>
				<tr>
					<th>바닥 형태(단위: 면)</th>
					<td><c:if test="${camp.siteBottomCl1 != '0' }">
					잔디(${camp.siteBottomCl1}) &nbsp;
					</c:if> <c:if test="${camp.siteBottomCl2 != '0' }">
					파쇄석(${camp.siteBottomCl2}) &nbsp;
					</c:if> <c:if test="${camp.siteBottomCl3 != '0' }">
					데크(${camp.siteBottomCl3}) &nbsp;
					</c:if> <c:if test="${camp.siteBottomCl4 != '0' }">
					자갈(${camp.siteBottomCl4}) &nbsp;
					</c:if> <c:if test="${camp.siteBottomCl5 != '0' }">
					맨흙(${camp.siteBottomCl5}) &nbsp;
					</c:if></td>
				</tr>
				<tr>
					<th>캠핑 장비 대여</th>
					<td>${camp.eqpmnLendCl }</td>
				</tr>
				<tr>
					<th>화로대</th>
					<td>${camp.brazierCl}</td>
				</tr>
				<tr>
					<th>안전 시설 현황</th>
					<td><c:if test="${camp.extshrCo != '0' }">
							소화기(${camp.extshrCo}) &nbsp;
						</c:if> <c:if test="${camp.frprvtWrppCo != '0' }">
							방화수(${camp.frprvtWrppCo}) &nbsp;
						</c:if> <c:if test="${camp.fireSensorCo != '0' }">
							화재감지기(${camp.fireSensorCo}) &nbsp;
						</c:if></td>
				</tr>
			</table>
		</div>

		<!-- 위치 정보 -->
		<div id="locInner" class="inner w3-center">
			<h4>${camp.facltNm}</h4>
			<p style="margin-bottom: 15px">${camp.addr1}</p>
			
			<div id="map" style="height: 400px;"></div> 
   
   <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e68d595e1b5cf86f4c344b473c443aef&libraries=services,clusterer,drawing"></script>
   <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e68d595e1b5cf86f4c344b473c443aef"></script>
   <script type="text/javascript">
   
   var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
   var options = { //지도를 생성할 때 필요한 기본 옵션
      center: new kakao.maps.LatLng(${camp.mapY}, ${camp.mapX}), //지도의 중심좌표.
      level: 3 //지도의 레벨(확대, 축소 정도)
   };
   var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴
   var markerPosition  = new kakao.maps.LatLng(${camp.mapY}, ${camp.mapX});  // 마커가 표시될 위치 
   var marker = new kakao.maps.Marker({  // 마커를 생성한다
       position: markerPosition
   });

   marker.setMap(map); // 마커가 지도 위에 표시되도록 설정한다
   </script>
		</div>
	</div>

	<script type="text/javascript">
		$(function(){
			$("#etcInner").show();
			$("#etcInner").siblings().hide();
			$("#etc").addClass("select");
		})
		
		function btn_div(id, tab) {
			$(".inner").each(function(){
				$(this).hide();
			})
			$(".debtn").each(function(){
				$(this).removeClass("select")
			})
			$("#"+id).show();
			$("#"+tab).addClass("select")
		}
		function change(type){
			console.log(type)
			console.log(${camp.contentId})
			console.log('${loginUser.id}')
			if('${loginUser.id}'== ''){
				alert("로그인한 유저만 가능합니다.")
			}else{
				$.ajax({
					type : "post",
					url : "change",
					//dataType : "json",
						data : "contentId=${camp.contentId}&userId=${loginUser.id}&type="+type,
						success : function(jdata){
						console.log(jdata)
						if(jdata.type == 2){
							if(jdata.check == 1){ // 좋아요
								$("#like").attr("style","background-color:white;");
								alert("추천이 취소되었습니다.")
							} 
							if(jdata.check == 0){ //안좋아요
								$("#like").attr("style","background-color:#cddc39;");
								alert("추천하였습니다.")
							}
						}
						if(jdata.type == 3){
							if(jdata.check == 1){ // 좋아요
								$("#love").attr("style","background-color:white;");
								alert("찜이 취소되었습니다.")
							} 
							if(jdata.check == 0){ //안좋아요
								$("#love").attr("style","background-color:#cddc39;");
								alert("찜하였습니다.")
							}
						}
					}
				})
			}
		}
	</script>
</body>
</html>