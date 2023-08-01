<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>굿캠핑 개인정보 수정</title>
</head>
<body>
	<style>
		a {color:#333}
		.btn-lime {background-color: #cddc39;}
		.btn-gray {background-color: #d3d3d3}
	</style>
	<div class="w3-content" style="max-width: 600px; padding-top: 120px">
		<h3 class="w3-center" style="font-weight: bold">개인정보 수정</h3>
		<form:form modelAttribute="user" action="update" method="post">
			<spring:hasBindErrors name="user">
				<font color="red" style="display:block" class="w3-center">
					<c:forEach items="${errors.globalErrors}" var="error">
						<spring:message code="${error.code}" />
					</c:forEach>
				</font>
			</spring:hasBindErrors>
			<table class="w3-table">
				<tr>
					<th>아이디</th>
					<td colspan="3">
						<form:input path="id" readonly="true" style="border:none"/>
						<font color="red"><form:errors path="id"/></font>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td colspan="3">
						<form:password path="pass" class="form-control"
						 placeholder="비밀번호 확인 필요"/>
						<font color="red"><form:errors path="pass"/></font>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td colspan="3">
						<form:input path="name" placeholder="수정할 이름 입력" class="form-control"/>
						<font color="red"><form:errors path="name"/></font>
					</td>
				</tr>
				<tr>
					<th>생년월일 변경</th>
					<td colspan="3">
						<form:input path="birth" class="form-control" placeholder="0000-00-00형식"/>
						<font color="red"><form:errors path="birth"/></font>
					</td>
				</tr>
				<tr>
					<th>이메일 변경</th>
               		<td colspan="3">
               			<form:input path="email" id="email"
                 		 class="form-control" placeholder="email형식으로 입력해주세요."/>
						<font color="red"><form:errors path="email"/></font>
               		</td>
            	</tr>
				<tr>
					<th>전화번호 변경</th>
					<td colspan="3">
						<form:input path="tel" placeholder="-을 포함한 전화번호 10자리 또는 11자리" 
						class="form-control"/>
						<font color="red"><form:errors path="tel"/></font>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<a href="mypwForm?id=${user.id}" style="float:right" class="btn btn-lime">비밀번호 변경</a>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div style="margin-bottom: 50px; text-align: center">
							<input type="submit" value="수정" class="btn btn-lime">
							<input type="button" value="회원탈퇴" class="btn btn-gray"
							 onclick="location.href='deleteForm'">
						</div>
					</td>
				</tr>
			</table>
		</form:form>
	</div>
</body>
</html>