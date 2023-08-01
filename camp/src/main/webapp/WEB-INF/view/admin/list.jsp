<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>회원 목록</title>
</head>
<body>
<style>
    header {position: relative;
    		height:150px; 
    		background-color:#cddc39;}
	header>h3 {position:absolute;
		bottom: 5px;
		left: 5%;
		font-weight: bold;}
	h4 {font-weight: bold;}	
	a {color:#333; font-weight: bold}
	.btn-lime {background-color:#cddc39;}
</style>
	<header>
		<h3>회원 목록</h3>
	</header>
	<br><br><br>
	<div style="width:90%; margin:0 auto; border: 1px solid #333; border-radius: 10px; padding: 10px;">
		<table class="w3-table">
			<tr style="padding:15px 0px 25px 0px">
				<form action="list" method="post" name="searchform">
					<td>
						<input type="hidden" name="pageNum" value="1">
						<select name="searchtype"  class="form-control" style="border: 1px solid #333;">
							<option value="">선택하세요</option>
							<option value="id">아이디</option>
							<option value="name">이름</option>
						</select>
						<script type="text/javascript">
							searchform.searchtype.value="${param.searchtype}";
						</script>	
					</td>
					<td colspan="5">
						<input type="text" name="searchcontent"
						value="${param.searchcontent}" class="form-control">
					</td>
					<td>
						<input type="submit" value="검색" class="btn btn-lime">
						<input type="button" value="전체 회원 목록 보기" class="btn btn-gray"
						onclick="location.href='list'">
					</td>
				</form>
			</tr>
			<tr>
				<td colspan="7"><b style="float:right">총 회원 수: ${listcount}</b></td>
			</tr>
			<tr style="background-color:#cddc39;">
				<th>아이디</th>
				<th>이름</th>
				<th>전화</th>
				<th>생일</th>
				<th>이메일</th>
				<th>마지막 접속시간</th>
				<th></th>
			</tr>
			<form action="list" method="post" name="restform">
				<input type="hidden" name="rest" value="">
				<input type="hidden" name="userid" value="">		
			</form>		
			<c:forEach items="${list}" var="user">
				<tr>
					<c:if test="${user.rest == 0 || user.rest == 1}">
						<c:set var="userid" value="${user.id}" />
						<c:if test="${fn:length(userid) > 10}">
							<td>${fn:substring(userid, 0, 10)}.......</td>
						</c:if>
						<c:if test="${fn:length(user.id) <= 10}">
							<td>${user.id}</td>
						</c:if>					
					</c:if>
					<c:if test="${user.rest == 2}">
						<c:set var="userid" value="${user.id}" />
						<c:if test="${fn:length(userid) > 10}">
							<td>${fn:substring(userid, 0, 10)}....... <b>[휴면 계정]</b></td>
						</c:if>
						<c:if test="${fn:length(user.id) <= 10}">
							<td>${user.id} <b>[휴면 계정]</b></td>
						</c:if>		
					</c:if>
					<td>${user.name}</td>
					<td>${user.tel}</td>
					<td><fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd"/></td>
					<td>${user.email}</td>
					<td><fmt:formatDate value="${user.lastlog}" pattern="yyyy-MM-dd"/></td>
					<td>
						<a href="../user/delete?id=${user.id}">[강제 탈퇴]</a>
						<c:if test="${user.rest == 0  || user.rest == 1}">
							<a href="javascript:rest('${user.id}')">[휴면 계정으로 전환]</a>
						</c:if>
						<c:if test="${user.rest == 2}">
							<a href="javascript:restclear('${user.id}')">[휴면 계정 해제]</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="7" class="w3-center">
					<c:if test="${pageNum > 1 }">
						<a href="javascript:listpage('${pageNum-1 }')">[이전]</a>
					</c:if>
					<c:if test="${pageNum <= 1 }">[이전]</c:if>
					<c:forEach var="a" begin="${startpage }" end="${endpage}">
						<c:if test="${a == pageNum}">[${a}]</c:if>
						<c:if test="${a != pageNum}">
							<a href="javascript:listpage('${a}')">[${a}]</a>
						</c:if>
					</c:forEach>
					<c:if test="${pageNum < maxpage }">
						<a href="javascript:listpage('${pageNum+1})">[다음]</a>
					</c:if>
					<c:if test="${pageNum >= maxpage}">[다음]</c:if>
				</td>
			</tr>
		</table>
	</div>
	<br>
	<br>
	<br>
	<script>
		function listpage(page) {
			document.searchform.pageNum.value=page;
			document.searchform.submit();
		}
		function rest(id) {
			console.log(id)
			if(confirm("휴면 회원으로 전환하시겠습니까?") == true){  
				document.restform.rest.value=2;
				document.restform.userid.value=id;
				document.restform.submit();
			 } else {  
			    return false;
			 }
		}
		function restclear(id) {
			console.log(id)
			if(confirm("휴면 계정입니다. 해제하시겠습니까?") == true){  
				document.restform.rest.value=1;
				document.restform.userid.value=id;
				document.restform.submit();
			 } else {  
			    return false;
			 }
		}
	</script>
</body>
</html>