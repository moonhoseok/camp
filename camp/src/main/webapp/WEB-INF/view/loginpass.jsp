<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<title>${title}찾기</title>
</head>
<body>
<style>
	.btn-lime {background-color: #cddc39;
		border:none;
		padding: 7px 10px;
		border-radius: 5px
	}
	
	table {margin: 0 auto;
		    width: 50%;
   			padding: 80px 0px;
   			line-height: 10rem}
   			 
	header {position: relative;
    		height:100px; 
    		background-color:#cddc39;
		text-align: center}
		
	header>h3 {position:absolute;
		bottom: 30px;
		width:50%;
		left:25%;
		font-weight: bold;
		text-align: center}
		
	h4 {text-align: center;
		font-weight: bold;
		padding-top:50px}
</style>
	<header>
		<h3>${title}를 초기화 해주세요.</h3>
	</header>
	<form:form modelAttribute="user" method="post" action="loginpass" name="f" onsubmit="return inchk(this)">
		<input type="hidden" name="id" value="${id}">
		<input type="hidden" name="name" value="유효성">
		<input type="hidden" name="birth" value="2023-06-23">
		<input type="hidden" name="email" value="a@b.c">
		<input type="hidden" name="tel" value="010-1234-1234">
		<spring:hasBindErrors name="user">
			<font color="red" class="w3-center" style="display:block">
				<c:forEach items="${errors.globalErrors}" var="error">
					<spring:message code="${error.code}" />
					<br>
				</c:forEach>
			</font>
		</spring:hasBindErrors>
	<h4>변경 할 비밀번호를 입력하세요.</h4>
	<table>
		<tr>
			<td colspan="2" >
				<form:password path="pass" placeholder="비밀번호 8~16자 숫자,영어 포함" class="form-control"
				style="margin:20px 0px" id="pass"/>
                <font color="red"><form:errors path="pass" /></font>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="password" name="chgpass" class="form-control" placeholder="비밀번호 재입력">
			</td>
		</tr>
		<tr>
			<td colspan="2" class="w3-center">
				<input type="button" value="비밀번호 변경" onclick="inchk()" class="btn btn-lime">
			</td>
		</tr>
	</table>
</form:form>
<script>
	function inchk() {
		let str = f.pass.value
		let regpass = /[A-Za-z]/
		let regnum = /[0-9]/
		let regetc = /[~!@#$%^&*]/
		if(f.pass.value != f.chgpass.value) {	// 입력값이 다를 때
			alert("비밀번호 입력값이 다릅니다.");
			f.chgpass.value="";
			f.chgpass.focus();
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