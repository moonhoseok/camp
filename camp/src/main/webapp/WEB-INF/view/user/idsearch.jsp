<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<title>아이디 찾기</title>
</head>
<body>
	<div class="w3-content" style="max-width: 600px; padding:150px 0px">
		<h3 class="w3-center">아이디 찾기</h3>
		<form:form modelAttribute="user" action="idsearch" method="post">
			<spring:hasBindErrors name="user">
				<font color="red">
					<c:forEach items="${errors.globalErrors}" var="error">
						<spring:message code="${error.code}"/>
					</c:forEach>				
				</font>
			</spring:hasBindErrors>
			<table class="w3-table">
				<tr>
	               <td>
	               		<input type="text" name="email" id="email" class="form-control" placeholder="email형식으로 입력해주세요.">
	               		<font color="red"><form:errors path="email"/></font>
	               </td>
	            </tr>
				<tr>
					<td>
						<input type="text" name="tel" placeholder="-을 포함한 전화번호 입력" class="form-control">
						<font color="red"><form:errors path="tel"/></font>
					</td>
				</tr>
				<tr>
					<td class="w3-center">
						<input type="submit" value="아이디 찾기" class="btn" style="background-color:#cddc39; color:black;">
					</td>
				</tr>
			</table>
		</form:form>
	</div>
</body>
</html>