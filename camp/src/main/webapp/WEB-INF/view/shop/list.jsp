<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/item.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>GoodCamping 쇼핑몰</title>
</head>
<body>
	<header>
		<h3>상품 목록</h3>
	</header>
	<c:if test="${loginUser.id == 'admin'}">
		<div style="width:90%; margin: 0 auto; margin-top:60px; margin-bottom:30px">
			<a href="additem" class="btn btn-lime" style="display:block; float:right;">상품 등록하기</a>
		</div>
	</c:if>
	<div class="icon-box">
		<i class='fas fa-list-ul' id="list" 
			style="border: 1px solid #333; color:#333;"></i>&emsp; 
		<i class='fas fa-th-large' id="box"></i>
	</div>
	<form action="../cart/addcart" name="addform" method="post">
		<input type="hidden" name="id" value="">
	</form>
	<div class="wrap">
		<c:forEach items="${list}" var="item">
		<div class="listitem" style="padding: 10px 0px">
			<img src="../img/${item.pictureUrl}" style="width:15%; margin: 0% 3% 0% 1%">
			<div style="padding:10px 0px">
				<a href="detail?id=${item.id}"><b style="font-size:18px">${item.name}</b></a>
				<p><fmt:formatNumber value="${item.price}" pattern="###,###"/>원</p>
				<br>
				<a href="javascript:addcart_list(${item.id})"><i class='fas fa-shopping-cart'></i> 장바구니에 넣기</a>
			</div>
		</div>
		<hr>
		</c:forEach>
	</div>
	<div class="wrap-box">
		<c:forEach items="${list}" var="item" varStatus="vs">
			<div class="box-inner" style="padding-bottom:30px">
				<a href="detail?id=${item.id}"><img src="../img/${item.pictureUrl}" style="width:100%"></a>
				<ul style="padding:10px 0px">
					<li><a href="detail?id=${item.id}"><b style="font-size:18px">${item.name}</b></a></li>
					<li><p><fmt:formatNumber value="${item.price}" pattern="###,###"/>원</p></li>
					<li><a href="javascript:addcart_box(${item.id})"><i class='fas fa-shopping-cart'></i> 장바구니에 넣기</a></li>
				</ul>
			</div>
		</c:forEach>
	</div>
	

	<div class="w3-center" style="width:90%; margin: 0 auto; padding-bottom:60px">
		<c:if test="${pageNum > 1 }">
			<a href="javascript:listpage('${pageNum-1 }')">[이전]</a>
		</c:if>
		<c:if test="${pageNum <= 1 }">[이전]</c:if>
		<c:forEach var="a" begin="${startpage }" end="${endpage}">
			<c:if test="${a == pageNum}">[${a}]</c:if>
			<c:if test="${a != pageNum}">
				<a href="javascript:listpage('${a}')">[${a}]</a>
			</c:if>
		</c:forEach>
		<c:if test="${pageNum < maxpage }">
			<a href="javascript:listpage('${pageNum+1})">[다음]</a>
		</c:if>
		<c:if test="${pageNum >= maxpage}">[다음]</c:if>
	</div>
	<script>
		function addcart_list(listid) {
			console.log(listid)
			document.addform.id.value=listid
			document.addform.submit();
		}
		
		function addcart_box(boxid) {
			console.log(boxid)
			document.addform.id.value=boxid
			document.addform.submit();
		}
		$(".wrap-box").hide();
		
		$("#list").click(function(){
			$(".wrap-box").hide();
			$(".wrap").show();
			$(this).css({"color":"#333","border":"1px solid #333"});
			$("#box").css({"color":"#ccc","border":"1px solid #ccc"});
		})
		$("#box").click(function(){
			$(".wrap").hide();
			$(".wrap-box").show()
			$(this).css({"color":"#333","border":"1px solid #333"});
			$("#list").css({"color":"#ccc","border":"1px solid #ccc"});
		})
	</script>
</body>
</html>