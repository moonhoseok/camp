<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../css/item.css">
<meta charset="UTF-8">
<title>상품 삭제</title>
</head>
<body>
	<header>
		<h3>상품을 삭제하시겠습니까?</h3>
	</header>
	<div style="width:90%; margin: 0 auto; padding: 60px 0px">
		<table class="w3-table">
			<tr>
				<td style="width:50%">
					<img src="../img/${item.pictureUrl}" style="width:90%"></td>
				<td>
					<table class="w3-table">
						<tr>
							<th style="width:16%">상품 명</th>
							<td>${item.name}</td>
						</tr>
						<tr>
							<th>상품 가격</th>
							<td>${item.price}</td>
						</tr>
						<tr>
							<th>상품 설명</th>
							<td>${item.description}</td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top:30px">
								<form action="delete" method="post">
									<input type="hidden" name="id" value="${item.id }">
									<input type="submit" value="확인" class="btn btn-lime"> &emsp;
									<input type="button" value="취소" class="btn btn-gray" onclick="location.href='list'">
								</form>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>