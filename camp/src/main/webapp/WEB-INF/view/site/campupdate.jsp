<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/detail.css">
<title>캠핑장 업데이트</title>

</head>
<body>
<div style="width: 90%; margin: 0 auto; padding-bottom: 60px; padding-top:80px">
		<div class="wrap">
			<div class="mainImg">
				<c:if test="${camp.firstImageUrl != null}">
					<img src="${camp.firstImageUrl}" style="width: 90%">
				</c:if>
				<c:if test="${camp.firstImageUrl == ''}">
					<img src="${path}/img/campimg.jpg" width="590px" height="393px">
				</c:if>
			</div>
			<div class="info">
				<h3>${camp.facltNm}</h3>
				<form:form modelAttribute="camp" method="post" action="campupdate" name="f">
				<input type="hidden" name="contentId" value="${camp.contentId }">
				<table class="w3-table w3-bordered"
					style="border-top: 2px solid #cddc39; border-bottom: 2px solid #cddc39;">
					<tr>
						<th>주소</th>
						<td><form:input path="addr1" class="form-control" id="addr1" value="${camp.addr1}"/></td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td><form:input path="tel" class="form-control" id="tel" value="${camp.tel}"/></td>
					</tr>
					<tr>
						<th>캠핑장 환경</th>
						<td><form:input path="lctCl" class="form-control" id="lctCl" style="width:40%" placeholder="입지구분" value="${camp.lctCl}"/>/
						<form:input path="facltDivNm" class="form-control" id="facltDivNm" style="width:40%" placeholder="사업주체.구분" value="${camp.facltDivNm}"/></td>
					</tr>
					<tr>
						<th>캠핑장 유형</th>
						<td><form:input path="induty" class="form-control" id="induty" value="${camp.induty}"/></td>
					</tr>
					<tr>
						<th>운영 기간</th>
						<td><form:input path="operPdCl" class="form-control" id="operPdCl" value="${camp.operPdCl}"/></td>
					</tr>
					<tr>
						<th>운영 일</th>
						<td><form:input path="operDeCl" class="form-control" id="operDeCl" value="${camp.operDeCl}"/></td>
					</tr>
					<tr>
						<th>홈페이지</th>
						<td><form:input path="homepage" class="form-control" id="homepage" value="${camp.homepage}"/></td>
					</tr>
				</table>
				<div style="margin-top: 15px">
						<button type="submit" class="btn btn-white">
							<i class='fas fa-tools'></i>
							 <b>캠핑장 수정</b>
						</button>
				</div>
				</form:form>
		</div>
	</div>
</div>
			
</body>
</html>