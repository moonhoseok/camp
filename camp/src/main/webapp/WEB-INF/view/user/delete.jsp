<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>굿캠핑 비밀번호 변경</title>
</head>
<body>
<div class="w3-content" style="max-width: 600px;padding-top:100px">
		<h3 class="w3-center">회원 탈퇴</h3>
		<form action="delete" method="post">
		<input type="hidden" name="id" value="${param.id}">
			<table class="w3-table">
				<tr>
					<td colspan="3">
						<input type="password" name="pass" placeholder="비밀번호 입력" class="form-control">
					</td>
				</tr>
					<td colspan="3">
						<div style="margin-bottom: 30px; margin-top:30px; text-align: center">
							<input type="submit" value="회원 탈퇴" class="btn btn-dark" 
							style="background-color: #cddc39; color: black;	">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>