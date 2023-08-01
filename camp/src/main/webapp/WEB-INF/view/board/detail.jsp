<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!--  
	Contrller, ShopService, BoardDao 구현
		1. num파라미터에 해당하는 게시물 정보를 board객체 전달
		   service.getBoard(num)
		   boarddao.selectone(num)
		2. 조회수 증가
			boarddao.addReadcnt(num)
-->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 상세보기</title>

<style type="text/css">
	.leftcol{text-align: left; vertical-align: top;}
	.lefttoptable{ height: 250px; border-width: 0px;
		text-align: left; vertical-align: top; padding: 0px;}
	h3 {font-weight: bold; width: 90%; margin:0 auto; margin-bottom:20px}
	.btn-lime {background-color: #cddc39;}
	.btn-gray {background-color: #dedede;}
	a {color:#333}
</style>
</head>
<body>
<script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>

<br><br><br><br><br>
		<input type="hidden" id="boardNum" value="${board.num}">
		<input type="hidden" id="userId" value="${loginUser.id}">
	<h3>${boardName}</h3>
	<div class="w3-center" 
		style="width:90%; margin: 0 auto">
		<table class="w3-table w3-striped">
			<tr>
				<td width="15%">글쓴이</td>
				<td width="85%" class=" leftcol">${board.writer }</td>
			</tr>
			<tr>
				<td>제목</td>
				<td class="leftcol">${board.title}</td>
			</tr>
			<tr>
				<td>내용</td><td class="leftcol">
					<table class="lefttoptable" style="width:100%;">
						<tr><td class="leftcol lefttoptable">${board.content }</td></tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>첨부파일</td><td>&nbsp;
					<c:if test="${!empty board.fileurl }">
						<a href="file/${board.fileurl}">${board.fileurl }</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="w3-center" style="padding-top:20px">
				<%--<a href="reply?num=${board.num }">[답변]</a>--%>
					<c:if test="${loginUser.id == board.writer || loginUser.id eq 'admin'}">
					<a href="update?num=${board.num }" class="btn btn-lime">수정</a>
					<a href="delete?num=${board.num }" class="btn btn-lime">삭제</a>
					</c:if>
					<a href="list?boardid=${board.boardid }" class="btn btn-lime">게시물 목록</a>
				
					<c:choose>
  						<c:when test="${goodselect == 0 }"> <!-- count가0이면 빈하트-->
        					<button class="btn btn-white"onclick="changeLike()" >
							<i class="fas fa-heart" style="font-size:18px; color:white;" id="btn_like"></i>
							</button>
   						</c:when>
    					<c:otherwise> <!-- count가1이면 빨간 하트-->
       						<button class="btn btn-white"onclick="changeLike()" >
								<i class="fas fa-heart" style="font-size:18px; color:red;" id="btn_like"></i>
							</button>
    					</c:otherwise>
					</c:choose>
					<a id="count">  ${board.likecnt}</a>
				</td>
			</tr>	
		</table>
		<hr>
		<%-- 댓글 등록 조회 삭제 --%>
		<c:if test="${loginUser.id != null }">
		<span id="comment"></span>
		<form:form  modelAttribute="comment" action="comment" method="post" name="commForm">
		<form:hidden path="num"/>
			<div class="w3-row">
				<div class="w3-col s2 w3-center">
					<p><form:input path="writer" class="form-control" placeholder="작성자"
						readonly="true" value="${loginUser.id}"/>
						<font color="red"><form:errors path="writer"/></font>
					</p>
				</div>
				<div class="w3-col s8 w3-center">
					<p><form:input path="content"  class="form-control" placeholder="내용"/>
						<font color="red"><form:errors path="content"/></font>
					</p>
				</div>
				<div class="w3-col s1 w3-center">
					<p><button type="submit" class="btn btn-lime">댓글 등록</button></p>
				</div>
				<div class="w3-col s1 w3-center">
				비밀<input type="checkbox" name="secret" value="1"/>
				</div>
			</div>
		</form:form>
		</c:if>
		<div class="w3-container">
			<table class="w3-table-all">
				<c:forEach var="c" items="${commlist}" varStatus="stat">
					<tr>
						<td>${c.seq}</td>
						<td>${c.writer }</td>
				<c:if test="${c.secret == 1 }">
				<c:choose>
	                <c:when test="${c.writer eq loginUser.id || loginUser.id == 'admin'}">
	                    <td><input id="${c.seq}" value="${c.content }" readonly="readonly" style="border: none;"></td>
	                </c:when>
	                <c:otherwise><td>비밀댓글입니다요.</td></c:otherwise>
	            </c:choose> 
				</c:if>
				<c:if test="${c.secret != 1 }">
					<td><input id="${c.seq}" value="${c.content }" readonly= "ture" style="border: none;"></td>
				</c:if>		
						<td><fmt:formatDate value="${c.regdate }" pattern="yyyy-MM-dd HH:mm:ss"/> </td>
						<td class="w3-right">
							<form action="commdel" method="post" name="commdel${stat.index}">
								<input type="hidden" id="num" name ="num" value="${board.num}">
								<input type="hidden" id="seq" name ="seq" value="${c.seq}">
								<c:if test="${loginUser.id == c.writer || loginUser.id eq 'admin'}">
								<a class="btn btn-lime up up${c.seq}" 
											href="javascript:commupdate1(${c.seq})">수정</a>
								<a class="btn btn-lime go go${c.seq}" id="${c.seq}"
											href="javascript:commupdate2(${c.seq})">확인</a>
								<a class="btn btn-lime del del${c.seq}" id="${c.seq}"
											href="javascript:commupdatedel(${c.seq})">취소</a>
								<a class="btn btn-lime" 
								href="javascript:document.commdel${stat.index}.submit()">삭제</a>
								</c:if>
							</form>
						</td>
					</tr>		
				</c:forEach>
			</table>
		</div>
	</div> 
	<br><br><br>
<script type="text/javascript">
	
	$(".del").hide();
	$(".go").hide();
	function commupdate2(cno){
		let bnum = $("#boardNum").val();
		let seq = cno;
		let text = $("#"+cno).val();
		console.log("댓글 수정 내용 : num" + bnum +" seq"+ seq+"text" + text )
		$.ajax({
			type : "post",
			url : "commupdate",
			data : "bnum="+bnum+"&seq="+seq+"&text="+text,
			success : function(cdata){
				if(cdata.good==1){
					alert("댓글수정 성공")
					commupdatedel(cno)
				}
			}
		})
		
	}
	function commupdate1(cno){
		$("#"+cno).attr("style", "border: 1px solid #333;");
		$("#"+cno).attr("readonly",false);
		$(".del"+cno).show();
		$(".go"+cno).show();
		$(".up"+cno).hide();
		console.log("댓글수정")
	}
	function commupdatedel(cno){
		$("#"+cno).attr("style", "border: none;");
		$("#"+cno).attr("readonly", true);
		$(".del"+cno).hide();
		$(".go"+cno).hide();
		$(".up"+cno).show();
		console.log("댓글수정취소")
	}
	
	function changeLike() {
		let boardNum = $("#boardNum").val();
		let userId = $("#userId").val();
		console.log('here')
		console.log(boardNum)
		console.log(userId)
		if ('${loginUser.id}' == '') {
			alert("로그인한 유저만 가능합니다.")
		} else {
			$.ajax({
				type : "post",
				url : "boardLike",
				//dataType : "json",
				data : "boardNum=" + boardNum + "&userId=" + userId,
				success : function(jdata) {
					console.log(jdata)
					console.log("좋아요 갯수 : "+jdata.count)
					if (jdata.likecheck == 1) { // 좋아요
						$("#btn_like").attr("style",
								"color:white;");
						alert("@@싫어요@@")
					
					}
					if (jdata.likecheck == 0) { //안좋아요
						$("#btn_like").attr("style",
								"color:red;");
						alert("@@좋아요@@")
					
					}
					$("#count").html(jdata.count);
				}
			})
		}
	}
</script>
</body>
</html>
















