<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>굿캠핑 로그인</title>
</head>
<body>
<div class="w3-padding-64">
	<div class="w3-padding-64">
		<form:form modelAttribute="user" method="post" action="login" name="loginForm">
		<input type="hidden" name="name" value="유효성">
		<input type="hidden" name="birth" value="2023-06-23">
		<input type="hidden" name="email" value="a@b.c">
		<input type="hidden" name="tel" value="010-1234-1234">
			<div class="w3-container w3-content">
				<h2 style="text-align:center; font-weight: bold;">Good Camping</h2>
				<p style="text-align:center;">굿캠핑에 오신 걸 환영합니다.</p>
				<div class="form-group" style="width:70%; margin:0 auto">
					<label for="id">ID</label>
					<form:input path="id" class="form-control" id="userId" style="height:50px;" value="${param.id}"/>
					<font color="red"><form:errors path="id"/></font>
					<br>
					<label for="pwd">Password</label>
					<form:password path="pass" class="form-control" id="pwd" style="height:50px;"/>
				</div>
				<spring:hasBindErrors name="user">
					<font color="red" class="w3-center" style="display:block">
						<c:forEach items="${errors.globalErrors}" var="error">
							<spring:message code="${error.code}"/>
						</c:forEach>
					</font>
				</spring:hasBindErrors>
				<div style="width:70%; text-align: center; margin: 0 auto; margin-top:30px">
				<hr>
					<button type="submit" class="btn" 
					style="background-color:#cddc39;color:black; width: 100%; height: 50px; font-size: 20px;">로그인</button>
				</div>
				<div style="width:70%; text-align: center; margin: 0 auto; margin-top:30px">
				<hr>
				<a href="${apiURL}">
					<img height="40" src="http://static.nid.naver.com./oauth/small_g_in.PNG" style="margin-right:10px;margin-left:5px;">
				</a>
				<a href="${kakaoApiURL}">
					<img height="40" src="../img/kakao_login_medium.png">
				</a>
				
				<div style="width:70%; margin: 0 auto; margin-top:20px">
					<a href="idsearch">아이디 찾기</a> │
					<a href="pwsearch">비밀번호 찾기</a>
				</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</body>
</html>