<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/item.css">
<title>상품 등록</title>
</head>
<body>
<header>
	<h3>상품 등록</h3>
</header>
<div class="wrap">
	<form:form modelAttribute="item" action="additem" enctype="multipart/form-data">
		<table class="w3-table">
			<tr>
				<th>상품 명</th>
				<td><form:input path="name" style="width:100%; padding:5px 7px"/></td>	
				<td><font color="red"  style="width:100%"><form:errors path="name"/></font></td>
			</tr>
			<tr>
				<th>상품 가격</th>
				<td><form:input path="price" style="width:100%; padding:5px 7px"/></td>
				<td><font color="red"><form:errors path="price"/></font></td>
			</tr>
			<tr>
				<th>상품 이미지</th>
				<td colspan="2"><input type="file" name="picture"></td>
			</tr>
			<tr>
				<th>상품 설명</th>
				<td><form:textarea path="description" cols="20" rows="5"  style="width:100%; padding:5px 7px"/></td>
				<td><font color="red"><form:errors path="description"/></font></td>
			</tr>
			<tr>
				<td colspan="3" class="w3-center">
					<input type="submit" value="상품 등록" class="btn btn-lime">
					<input type="button" value="상품 목록" onclick="location.href='shop'" class="btn btn-gray">
				</td>
			</tr>
		</table>
	</form:form>
</div>
</body>
</html>