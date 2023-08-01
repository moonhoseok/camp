<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>상품 주문</title>
</head>
<body>
	<style>
		  * {margin: 0; padding: 0;}
	    a {text-decoration: none; color: #333}
	    ol, ul {list-style: none}
	
	    .btn-lime {background-color:#cddc39}
	   
	    .btn-gray {background-color:#dedede}
		.btn-white {background-color: #fff;}
		
		header {position: relative;
	    		height:150px; 
	    		background-color:#cddc39;}
		header>h3 {position:absolute;
			bottom: 5px;
			left: 5%;
			font-weight: bold;}
		h4 {font-weight: bold;}
		table tr {line-height: 3rem}
	</style>
	<header>
		<h3>주문자 정보 입력</h3>
	</header>
	<div style="width:90%; margin: 0 auto; padding:60px 0px">
		<form method="post" action="order" name="orderform">
			<table class="w3-table w3-striped">
				<tr>
					<th>상품</th>
					<th>상품 이름</th>
					<th>상품 가격</th>
					<th>개수</th>
				</tr>
				<c:if test="${!empty cartlist}">		<!-- 장바구니 존재 -->
					<c:forEach items="${cartlist}" var="cart">
						<input type="hidden" name="name" value="${cart.name}">
						<input type="hidden" name="pictureUrl" value="${cart.pictureUrl}">
						<input type="hidden" name="quantity" value="${cart.quantity}">
						<input type="hidden" name="price" value="${cart.price}">
						<c:choose>
							<c:when test="${itemid == 0}"><!-- 전체 주문 -->
								<input type="hidden" name="itemid" value="${itemid}">
							</c:when>
							<c:otherwise>	<!-- 한 개 주문 -->
								<input type="hidden" name="itemid" value="${itemid}">
							</c:otherwise>
						</c:choose>
						<tr id="del${cart.itemid}">
							<td style="width:10%">
								<img src="../img/${cart.pictureUrl}" style="width:90%">
							</td>
							<td>
								<b style="color:#333">${cart.name}</b>
							</td>
							<td><fmt:formatNumber value="${cart.price}" pattern="###,###"/></td>
							<td>
								${cart.quantity}
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="4" class="w3-center"><b>총 주문 금액: <fmt:formatNumber value="${total}" pattern="###,###"/></b></td>
					</tr>
				</c:if>
				<c:if test="${!empty param.quantity}">
					<input type="hidden" name="itemid" value="${param.itemid}">
					<input type="hidden" name="quantity" value="${quantity}">
					<tr id="del${si.id}">
						<td style="width:10%">
							<img src="../img/${saleitem.pictureUrl}" style="width:90%">
						</td>
						<td>
							<b style="color:#333">${saleitem.name}</b>
						</td>
						<td><fmt:formatNumber value="${saleitem.price}" pattern="###,###"/></td>
						<td>${quantity}</td>
					</tr>
					<tr>
						<td colspan="4" class="w3-center">
							<b>총 금액: <fmt:formatNumber value="${saleitem.price * quantity}" pattern="###,###"/></b>
						</td>
					</tr>
				</c:if>
			</table>
			<h4 style="padding-top:30px;">주문자 정보</h4>
			<table class="w3-table">
				<tr>
					<th style="width:20%">이름</th>
					<td>${user.name}</td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>${user.tel}</td>
				</tr>
				<tr>
					<th>주소</th>
				</tr>
				<tr>
					<td style="display:flex">
						<input type="text" id="postcode" name="postcode" placeholder="우편 번호"  class="form-control"></td>
					<td>&emsp;
						<input type="button" onclick="execDaumPostcode()" class="btn btn-gray" value="우편번호 찾기">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="text" id="address" name="address" value="" placeholder="주소" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="text" name="detailAddress" placeholder="상세주소" class="form-control">
					</td>
				</tr>
				<tr class="w3-center">
					<td colspan="2">
						<a href="javascript:chk()" class="btn btn-lime">다음</a>
						<a href="../user/mypage?id=${user.id}" class="btn btn-gray">취소</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	function execDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) { //선택시 입력값 세팅
				document.getElementById("postcode").value = data.zonecode; // 우편번호
				document.getElementById("address").value = data.address; // 주소
				document.querySelector("input[name=detailAddress]").focus(); 
			}
		}).open();
	}
	function chk() {
		if(document.getElementById("postcode").value == "" ||
				document.getElementById("address").value == "" ||
				document.querySelector("input[name=detailAddress]").value == "") {
				alert("주소를 입력해주세요.");
		} else {
			document.orderform.submit();
		}
	}
</script>
</body>
</html>