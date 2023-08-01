<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정</title>
</head>
<body>
<style>
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
</style>
<header>
	<h3>상품 상세 보기</h3>
</header>
<div class="wrap" style="width:90%; margin:0 auto; padding: 60px 0px">
	<form:form modelAttribute="item" action="update" enctype="multipart/form-data">
		<form:hidden path="id"/>
		<form:hidden path="pictureUrl"/>
		<table class="w3-table">
			<tr>
				<th>상품 이름</th>
				<td><form:input path="name" style="width:100%; padding:5px 7px"/></td>
				<td><font color="red"><form:errors path="name"/></font>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><form:input path="price" style="width:100%; padding:5px 7px"/></td>
				<td><font color="red"><form:errors path="price"/></font></td>
			</tr>
			<tr>
				<th>상품 이미지</th>
				<td><input type="file" name="picture"/></td>
				<td>${item.pictureUrl}</td>
			</tr>
			<tr>
				<th>상품 설명</th>
				<td><form:input path="description" cols="20" rows="5" style="width:100%; padding:5px 7px"/></td>
				<td><font color="red"><form:errors path="description"/></font></td>
			</tr>
			<tr>
				<td colspan="3" class="w3-center">
					<input type="submit" value="수정하기" class="btn btn-lime">&emsp;
					<input type="button" value="목록보기" onclick="location.href='list'" class="btn btn-gray">
				</td>
			</tr>
		</table>
	</form:form>
</div>
</body>
</html>