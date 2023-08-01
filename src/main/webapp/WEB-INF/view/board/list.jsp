<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
  .btn-lime {background-color:#cddc39}
  .btn-gray {background-color:#dedede} 
</style>
<title>${boardName}</title>
<script type="text/javascript">
	function listpage(page){
		document.searchform.pageNum.value=page;
		document.searchform.submit();
	}
</script>
</head>
<body>
<br><br><br><br><br>
<a href="${path}/board/list?boardid=1" 
    class="w3-bar-item w3-button w3-padding 
    <c:if test='${url =="board" && boardid =="1"}'>btn-lime</c:if>">
    <i class="fa fa-eye fa-fw"></i>&nbsp; 공지사항</a>
    <a href="${path}/board/list?boardid=2" 
    class="w3-bar-item w3-button w3-padding
    <c:if test='${url =="board" && boardid =="2"}'>btn-lime</c:if>">
    <i class="fa fa-eye fa-fw"></i>&nbsp; 자유게시판</a>
    <a href="${path}/board/list?boardid=3" 
    class="w3-bar-item w3-button w3-padding
    <c:if test='${url =="board" && boardid =="3"}'>btn-lime</c:if>">
    <i class="fa fa-eye fa-fw"></i>&nbsp; QnA</a>
    <br>
<h2>${boardName}</h2>
<div class="w3-center" style="border: 1px solid #333; border-radius: 10px; padding: 10px;">
<table class="w3-table w3-border">
	<tr>
	<form action="list" method="post" name="searchform">
	<td>
		<input type="hidden" name="pageNum" value="1">
		<input type="hidden" name="boardid" value="${param.boradid}">
		<select name="searchtype" class= "w3-select" style="border: 1px solid #333;">
			<option value="">선택하세요</option>
			<option value="title">제목</option>
			<option value="writer">작성자</option>
			<option value="content">내용</option>
		</select>
			<script type="text/javascript">
				searchform.searchtype.value="${param.searchtype}";
			</script>	
	</td>
	<td colspan="3"><input type="text" name="searchcontent"
		value="${param.searchcontent}" class="w3-input" style="border: 1px solid #333;">
	</td>
	<td>
		<input type="submit" value="검색" class="w3-btn btn-lime">
		<input type="button" value="전체게시물보기" class="w3-btn btn-gray"
			onclick="location.href='list?boardid=${boardid}'">
	</td>
	</form>
	</tr>
	<c:if test="${listcount>0}"> <!-- 등록된 게시물 건수  -->
		<tr><td colspan="5" class="w3-right-align">글개수:${listcount}</td></tr>
		<tr style="background-color:#cddc39; color:#000">
		<th>번호</th><th>제목</th><th>글쓴이</th><th>날짜</th><th>조회수</th><th>좋아요</th></tr>
	 <tr>
     	<th colspan="6" style="padding:10px 0px"><hr style="margin:0; opacity:0"></th>
     </tr>
	<c:forEach var="board" items="${boardlist}"><%-- 게시물 목록 --%>
		<tr><td>${boardno}</td><%-- 화면의 출력할 가상의 게시물 번호  --%>
			<c:set var="boardno" value="${boardno-1}"/>
			<td class="w3-left">
			<c:if test="${! empty board.fileurl}">
				<a href="file/${board.fileurl}">@</a></c:if>
			<c:if test="${empty board.fileurl}">&nbsp;&nbsp;&nbsp;</c:if>
			<c:forEach begin="1" end="${board.grplevel}">&nbsp;&nbsp;</c:forEach>
			<c:if test="${board.grplevel >0 }">ㄴ</c:if>
		<a href="detail?num=${board.num}">${board.title}</a>
			</td>
			<td>${board.writer}</td>
			<td><fmt:formatDate value="${board.regdate}" pattern="yyyyMMdd" var="rdate"/>
				<c:if test="${today == rdate}">
					<fmt:formatDate value="${board.regdate}" pattern="HH:mm:ss"/>
				</c:if>
				<c:if test="${today != rdate}">
					<fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd HH:mm"/>
				</c:if>
			</td>
			<td>${board.readcnt}</td>
			<td>${board.readcnt}</td>
		</tr>		
	</c:forEach>
		<tr><td colspan="5" class="w3-center">
		<c:if test="${pageNum > 1 }">
			<a href="javascript:listpage('${pageNum-1})">[이전]</a>
		</c:if>
		<c:if test="${pageNum <=1 }">[이전]</c:if>
		<c:forEach var="a" begin="${startpage}" end="${endpage}">
			<c:if test="${a==pageNum }">[${a}]</c:if>
			<c:if test="${a != pageNum }">
			<a href="javascript:listpage('${a}')">[${a}]</a></c:if>
		</c:forEach>
		<c:if test="${pageNum < maxpage }">
			<a href="javascript:listpage('${pageNum+1 }')">[다음]</a>
		</c:if>
		<c:if test="${pageNum >= maxpage}">[다음]</c:if>	
		</td></tr>
	</c:if><!-- 등록된 게시물이 있는 경우 끝 -->
	<c:if test="${listcount == 0 }">
		<tr><td colspan="5">등록된 게시물이 없습니다.</td></tr>
	</c:if>
	<tr><td colspan="5">
	 <a href="write" class="w3-right">[글쓰기]</a>
	 </td></tr>
</table>
</div>
<br><br><br><br><br><br><br>
</body>
</html>