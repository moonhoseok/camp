<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중복검사</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
</head>
<body>
	<div class="w3-content" style="text-align: center; margin-top:10px">
		<div class="form-group" style="width: 70%; margin: 0 auto">
			<input type="text" class="form-control" readonly value="${param.id}">
		</div>
		<div id="msg">메세지</div>
		<div style="width:70%; text-align: center; margin: 0 auto; margin-top:10px">
		<button onclick="self.close()" class="btn btn-dark"
			style="background-color: #cddc39; color: black; width:120px">닫기</button>
		</div>
	</div>
	<script type="text/javascript">
	if(${able}){
		opener.document.f.id.value="";
		document.quertSelector("#msg").setAttribute("class","able");
	}else{
		
		document.quertSelector("#msg").setAttribute("class","disable");
	}
	
</script>
	</form>
</body>
</html>