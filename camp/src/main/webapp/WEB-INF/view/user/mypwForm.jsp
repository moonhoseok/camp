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
		<h3 class="w3-center">비밀번호 변경</h3>
		<form action="mypwForm" method="post" name="f" onsubmit="return chk(this)">
			<table class="w3-table">
				<tr>
					<td colspan="3">
						<input type="password" name="pass" placeholder="현재 비밀번호" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="password" name="chgpass" placeholder="변경 비밀번호" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="password" name="chgpass2" placeholder="변경 비밀번호 재입력" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<div style="margin-bottom: 30px; margin-top:30px; text-align: center">
							<input type="submit" value="비밀번호 변경" class="btn"
								style="background-color: #cddc39; color: black;	">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<script>
		function chk(f) {
			let str = f.chgpass.value
			let regpass = /[A-Za-z]/
			let regnum = /[0-9]/
			let regetc = /[~!@#$%^&*]/
			if(f.pass.value == "") {
				alert("현재 비밀번호를 입력하세요");
				return false;
			}
			if(f.chgpass.value != f.chgpass2.value) {	// 입력값이 다를 때
				alert("비밀번호 입력값이 다릅니다.");
				f.chgpass.value="";
				f.chgpass2.focus();
				return false;
			} else { //입력값이 같을 때 
				if(str.length < 8 || str.length > 17 ) {	// 길이가 안 맞으면
					alert("비밀번호는 8~16자리로 입력해야합니다.")
					return false;
				} else {	// 길이 맞을 때
					if(!regpass.test(str) || !regnum.test(str) || !regetc.test(str)) {	// 영어 포함 여부
						alert("비밀번호는 영어, 숫자, 특수문자를 포함한 8~16자리로 입력해주세요.")
						return false;
					} else {
						return document.f.submit();
					}
				}  
			}
		}
	</script>
</body>
</html>