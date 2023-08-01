	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>

</head>
<body>
<div class="w3-content" style="max-width: 600px;padding-top:100px; margin-bottom:50px;">
			<h3 style="margin-bottom: 20px">회원 목록</h3>
			<table class="w3-table info-tabl w3-centered">
				<tr>
					<th>이름</th>
					<th>전화번호</th>
					<th>이메일</th>
					<th>가입날짜</th>
					<th>탈퇴</th>
				</tr>
				<tr>
               <th colspan="5" style="padding:10px 0px"><hr style="margin:0; border-color:#eee"></th>
           	 </tr>
				<tr>
					<td>나</td>
					<td>87654321</td>
					<td>naver</td>
					<td>오늘</td>
					<td><button type="button" style="background-color:#cddc39;color:black;" class="btn btn-dark">탈퇴</button></td>
				</tr>
				<tr>
               <th colspan="5" style="padding:10px 0px"><hr style="margin:0; border-color: #eee"></th>
            </tr>
            <tr>
					<td>너</td>
					<td>12345678</td>
					<td>google</td>
					<td>어제</td>
					<td><button type="button" style="background-color:#cddc39;color:black;" class="btn btn-dark">탈퇴</button></td>
				</tr>
			</table>
		</div>
</body>
</html>