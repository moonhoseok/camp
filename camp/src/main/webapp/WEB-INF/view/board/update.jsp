<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
<script type="text/javascript">
	function file_delete(){
		document.f.fileurl.value="";
		file_desc.style.display ="none";
	}
</script>
</head>
<body>
<style>
	.btn-lime {background-color: #cddc39}
	.btn-gray {background-color: #dedede}
	 
	 a {color:#333}
</style>
<br><br><br><br><br>
<div style="width:90%; margin: 0 auto; padding-bottom: 60px">
	<form:form modelAttribute="board" action="update" enctype="multipart/form-data" name="f">
		<form:hidden path="num"/>
		<table class="w3-table">
			<tr><td>작성자</td><td><form:input path="writer" class="form-control"/>
			<font color="red"><form:errors path="writer"/></font></td></tr>
			<tr><td>제목</td><td><form:input path="title" class="form-control"/>
			<font color="red"><form:errors path="title"/></font></td></tr>
			<tr><td>내용</td><td><form:textarea path="content" rows="15" cols="80" style="width:100%"/>
			<script>CKEDITOR.replace("content",{filebrowserImageUploadUrl
				 : "imgupload"});</script>
			<font color="red"><form:errors path="content"/></font></td></tr>
			<tr><td>첨부파일</td>
			<td>
				<c:if test="${!empty board.fileurl}">
					<div id="file_desc">
						<a href="file/${board.fileurl}">${board.fileurl}</a>
						<a href="javascript:file_delete()">[첨부파일삭제]</a>
					</div>
				</c:if>
			<form:hidden path="fileurl"/><input type="file" name="file1"></td></tr>
			<tr><td colspan="2" class="w3-center">
			<c:if test="${boardid == '3'}"> 
					비밀글<input type="checkbox" name="secret" value="1"/>
			</c:if>	
			<a href="javascript:document.f.submit()" class="btn btn-lime">게시글수정</a>
			<a href="list" class="btn btn-gray">게시글목록</a></td></tr> 		 
		</table>
	</form:form>
</div>
</body>
</html>