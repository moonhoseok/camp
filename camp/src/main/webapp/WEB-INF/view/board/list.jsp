<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!-- 포트번호 8080 -->
<c:set var="port" value="${pageContext.request.localPort}" />
<!-- IP주소 : localhost -->
<c:set var="server" value="${pageContext.request.serverName}" />
<!--  -->
<c:set var="path2" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
.btn-lime {
	background-color: #cddc39
}

.btn-gray {
	background-color: #dedede
}
</style>
<title>${boardName}</title>
<style>
* {
	margin: 0;
	padding: 0;
}

a {
	text-decoration: none;
}

ol, ul {
	list-style: none
}

header {
	position: relative;
	height: 150px;
	background-color: #cddc39;
}

header>h3 {
	position: absolute;
	bottom: 5px;
	left: 5%;
	font-weight: bold;
}

h4 {
	font-weight: bold
}

.btn-lime {
	background-color: #cddc39;
	color: #333
}
</style>
<script type="text/javascript">
	function listpage(page) {
		document.searchform.pageNum.value = page;
		document.searchform.submit();
	}
</script>


</head>
<body>

	<header>
		<h3>커뮤니티</h3>
	</header>
	<div class="w3-bar w3-black">
		<div style="width: 90%; margin: 0 auto">
			<a href="${path}/board/list?boardid=1"
				class="w3-bar-item w3-button w3-padding 
			<c:if test='${url =="board" && boardid =="1"}'>btn-lime</c:if>">
				<i class='fas fa-bullhorn'></i>&nbsp; 공지사항
			</a> <a href="${path}/board/list?boardid=2"
				class="w3-bar-item w3-button w3-padding
			<c:if test='${url =="board" && boardid =="2"}'>btn-lime</c:if>">
				<i class='far fa-comment-dots'></i>&nbsp; 자유게시판
			</a> <a href="${path}/board/list?boardid=3"
				class="w3-bar-item w3-button w3-padding
			<c:if test='${url =="board" && boardid =="3"}'>btn-lime</c:if>">
				<i class='far fa-question-circle'></i>&nbsp; QnA
			</a>
		</div>
	</div>
	<br>
	<br>


	<h3 style="width: 90%; margin: 0 auto; font-weight: bold;">${boardName}</h3>
	<br>
	<div class="w3-center"
		style="border: 1px solid #333; border-radius: 10px; padding: 10px; width: 95%; margin: 0 auto">
		<table class="w3-table">
			<tr>
				<form action="list" method="post" name="searchform">
					<td>
						<input type="hidden" name="pageNum" value="1">
						<input type="hidden" id="user" value="${loginUser.id}">
						<input	type="hidden" name="boardid" value="${param.boardid}">
						<select name="searchtype" class="form-control" style="border: 1px solid #333;">
							<option value="">선택하세요</option>
							<option value="title">제목</option>
							<option value="writer">작성자</option>
							<option value="content">내용</option>
						</select>
						<script type="text/javascript">
							searchform.searchtype.value = "${param.searchtype}";
						</script>
					</td>
					<td colspan="2">
						<input type="text" name="searchcontent"	value="${param.searchcontent}" class="form-control">
					</td>
					<td colspan="2">
						<input type="submit" value="검색" class="btn btn-lime"> 
						<input type="button" value="전체게시물보기" class="btn btn-gray"
						onclick="location.href='list?boardid=${boardid}'">
					</td>
					<td>
						<select name="cnt" class="form-control"	style="border: 1px solid #333;">
							<option value="">날짜순</option>
							<option value="readcnt">조회순</option>
							<option value="likecnt">좋아요</option>
						</select>
						<script type="text/javascript">
							searchform.cnt.value = "${param.cnt}";
						</script>
					</td>
					<td>
						<c:if test="${boardid == '2' }">
						<select name="cate" class="form-control" style="border: 1px solid #333;">
							<option value="">선택하세요</option>
							<option value="[캠핑장후기]">캠핑장후기</option>
							<option value="[캠핑팁]">캠핑팁</option>
							<option value="[자유게시판]">자유게시판</option>
						</select>
						<script type="text/javascript">
								searchform.cate.value = "${param.cate}";
						</script>
						</c:if>
					</td>
					<td>
						<input type="submit" value="검색" class="btn btn-lime">  
					</td>
				</form>
			</tr>
			<c:if test="${listcount>0}">
				<!-- 등록된 게시물 건수  -->
				<tr>
					<td colspan="8" class="w3-right-align"><b>글 개수</b>:
						${listcount}</td>
				</tr>
				<tr style="background-color: #cddc39; color: #000">
					<th>번호</th>
					<th colspan="3">제목</th>
					<th>글쓴이</th>
					<th>날짜</th>
					<th>조회수</th>
					<th>좋아요</th>
				</tr>
				<tr>
					<th colspan="8" style="padding: 10px 0px">
						<hr style="margin: 0; opacity: 0">
					</th>
				</tr>
				<c:forEach var="board" items="${boardlist}">
					<%-- 게시물 목록 --%>
					<tr>
						<td>${boardno}</td>
						<%-- 화면의 출력할 가상의 게시물 번호  --%>
						<c:set var="boardno" value="${boardno-1}" />

						<td	colspan="3" class="w3-left">
						<c:if test="${board.secret != 1 }">

								<c:if test="${! empty board.fileurl}">
									<a href="file/${board.fileurl}">@</a>
								</c:if>
								<c:if test="${empty board.fileurl}">&nbsp;&nbsp;&nbsp;</c:if>
								<c:forEach begin="1" end="${board.grplevel}">&nbsp;&nbsp;</c:forEach>
								<c:if test="${board.grplevel >0 }">ㄴ</c:if>
								<a href="detail?num=${board.num}">${board.cate}${board.title}</a>
							</c:if> <c:if test="${board.secret == 1 }">
								<c:choose>
									<c:when
										test="${board.writer eq loginUser.id || loginUser.id eq 'admin'}">
										<a href="detail?num=${board.num}">${board.cate}${board.title}</a>
									</c:when>
									<c:otherwise>비밀글은 작성자와 관리자만 볼 수 있습니다.</c:otherwise>
								</c:choose>
							</c:if>
						</td>

						<td colspan="3">${board.writer}</td>
						<td><fmt:formatDate value="${board.regdate}"
								pattern="yyyyMMdd" var="rdate" /> <c:if test="${today == rdate}">
								<fmt:formatDate value="${board.regdate}" pattern="HH:mm:ss" />
							</c:if> <c:if test="${today != rdate}">
								<fmt:formatDate value="${board.regdate}"
									pattern="yyyy-MM-dd HH:mm" />
							</c:if>
						</td>
						<td>${board.readcnt}</td>
						<td>${board.likecnt}</td>
						<%--좋아요 수 --%>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="8" class="w3-center"><c:if test="${pageNum > 1 }">
							<a href="javascript:listpage('${pageNum-1}')">[이전]</a>
						</c:if> <c:if test="${pageNum <=1 }">[이전]</c:if> <c:forEach var="a"
							begin="${startpage}" end="${endpage}">
							<c:if test="${a==pageNum }">[${a}]</c:if>
							<c:if test="${a != pageNum }">
								<a href="javascript:listpage('${a}')">[${a}]</a>
							</c:if>
						</c:forEach> <c:if test="${pageNum < maxpage }">
							<a href="javascript:listpage('${pageNum+1 }')">[다음]</a>
						</c:if> <c:if test="${pageNum >= maxpage}">[다음]</c:if></td>
				</tr>
			</c:if>
			<!-- 등록된 게시물이 있는 경우 끝 -->
			<c:if test="${listcount == 0 }">
				<tr>
					<td colspan="8">등록된 게시물이 없습니다.</td>
				</tr>
			</c:if>
			<tr>
				<td colspan="8"><c:choose>
						<c:when test="${boardid == 1 && loginUser.id == 'admin'}">
							<button onclick="location.href='write'"
								class="btn btn-lime w3-right">글쓰기</button>
						</c:when>
						<c:when test="${boardid != 1 }">
							<button onclick="location.href='write'"
								class="btn btn-lime w3-right">글쓰기</button>
						</c:when>
					</c:choose></td>
			</tr>
		</table>
	</div>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
</body>
</html>