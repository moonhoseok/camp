<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="../css/main.css">
<script src="https://kit.fontawesome.com/21a6628c62.js" crossorigin="anonymous"></script>
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
		padding: 80px 0px;
		line-height: 4rem;}
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
</style>
<table>
<header>
	<h3>${title} 검색 결과 입니다</h3>
</header>
<table>
	<tr>
		<th>${title} :</th>
		<td>${result}</td>
	</tr>
	<tr>
		<td colspan="2" style="text-aling:center">
			<c:if test="${title=='아이디'}">
				<input type="button" value="로그인 페이지로 돌아가기" onclick="sendclose()" class="btn btn-lime">
			</c:if>
		</td>
	</tr>
</table>
<script>
	function sendclose() {
		location.href="login?id=${result}";
	}
</script>
</body>
</html>