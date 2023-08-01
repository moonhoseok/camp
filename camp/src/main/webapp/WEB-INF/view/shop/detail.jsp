<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/item.css">
<title>상세 정보</title>
</head>
<body>
	<style>
		.wrap {display:flex;
			    justify-content: space-between;
			    padding: 60px 0px}
	</style>
	<header>
		<h3>상품 상세 보기</h3>
	</header>
	<div class="wrap">
		<img src="../img/${item.pictureUrl}" style="width:25%;">
		<div style="padding: 10px 0px; width:70%">
		<form action="../cart/addcart" name="f" method="post">
			<input type="hidden" name="id" value="${item.id}">
			<table class="w3-table">
				<tr>
					<th colspan="2"><b style="font-size:16px">${item.name}</b></th>
				</tr>
				<tr>
					<th style="width:15%">상품 가격</th>
					<td><fmt:formatNumber value="${item.price}" pattern="###,###"/></td>
				</tr>
				<tr>
					<th colspan="2">상세 설명</th>
				</tr>
				<tr>
					<td colspan="2">${item.description}</td>
				</tr>
				<tr>
					<th>구매 수량</th>
					<td>
						<select name="quantity" id="quantity">
							<c:forEach begin="1" end="10" var="i">
								<option>${i}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="w3-center" style="padding-top:40px">
						<button type="submit" class="btn btn-gray">
						<i class='fas fa-shopping-cart'></i>장바구니에 넣기</button>&emsp;
						<a href="javascript:addcart()" class="btn btn-lime">바로 구매</a>
					</td>
				</tr>
			</table>
			</form>
		</div>
	</div>
	<c:if test="${loginUser.id == 'admin'}">
		<div style="width:90%; margin: 0 auto; padding: 20px 0px 60px 0px" class="w3-center">
			<a href="../shop/update?id=${item.id}" class="btn btn-lime">정보 수정</a>&emsp;
			<a href="../shop/delete?id=${item.id}" class="btn btn-gray">제품 삭제</a>
		</div>
	</c:if>
	<form action="../cart/saleitem" name="saleitem" method="post">
		<input type="hidden" name="name" value="${item.name}">
		<input type="hidden" name="pictureUrl" value="${item.pictureUrl}">
		<input type="hidden" name="price" value="${item.price}">
		<input type="hidden" name="itemid" value="${item.id}">
		<input type="hidden" name="quantity" value="">
	</form>
	<script>
		function addcart(qu) {
			document.saleitem.quantity.value= $("#quantity").val();
			document.saleitem.submit();
		}
	</script>
</body>
</html>