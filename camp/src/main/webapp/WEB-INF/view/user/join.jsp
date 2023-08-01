<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>굿캠핑 회원가입</title>
</head>
<body>
<style>
   table tr:nth-child(5) select {text-align: center}
   .inputWrap {display:flex; 
   			align-items: center;
   			position: relative;}
   b {font-size: 14px; width: 20%}
  	#chkicon {position: absolute;
   		font-size: 16px;
   		right: 2%;
   		color:green}
   	#failicon {position: absolute;
   		font-size: 16px;
   		right: 2%;
   		color:red}	
   .brithWrap {display:flex;
   			width:100%;
   			justify-content: space-between;}
   .brithWrap>div {width:32%}
   .chkmsg {padding: 5px 0px 5px 18%}
   
   .btn-gray {background-color: #dedede}
   .btn-lime {background-color: #cddc39}
</style>
	<div class="w3-content" style="max-width: 500px;padding-top:100px">
		<h3 class="w3-center" style="font-weight:bold; padding: 20px 0px">회원가입</h3>
		<form method="post" action="join" name="f" onchange="joinchk()">
		<input type="hidden" name="chkid" value="1" id="chkid">
			<div class="idbox">
				<div class="inputWrap">
					<b>아이디</b>
					<input type="text" name="id" oninput="checkId()" placeholder="ID를 입력해주세요" class="form-control"/>
					<i class='far fa-check-circle' id="chkicon"></i>
					<i class='far fa-times-circle' id="failicon"></i>
				</div>
				<p id="chkId" class="chkmsg"></p>		
			</div>
			<div class="passbox">
				<div class="inputWrap">
					<b>비밀번호&emsp;</b>
					<input type="password" name="pass" oninput="checkPass()" placeholder="비밀번호 영어, 숫자, 특수문자를 포함한 8~16자" class="form-control"/>
					<i class='far fa-check-circle' id="chkicon"></i>
					<i class='far fa-times-circle' id="failicon"></i>
				</div>
				<p id="chkPass" class="chkmsg"></p>
			</div>
			<div class="passbox2">
				<div class="inputWrap">
					<b>재입력</b>
					<input type="password" name="chgpass" class="form-control" oninput="checkPass2()" placeholder="비밀번호 재입력">
					<i class='far fa-check-circle' id="chkicon"></i>
					<i class='far fa-times-circle' id="failicon"></i>
	            </div>
	            <p id="chkPass2" class="chkmsg"></p>
			</div>
			<div class="namebox">
				<div class="inputWrap">
					<b>이름</b>
					<input type="text" name="name" class="form-control" oninput="checkName()"/>
					<i class='far fa-check-circle' id="chkicon"></i>
					<i class='far fa-times-circle' id="failicon"></i>
				</div>
				<p id="chkName" class="chkmsg"></p>
			</div>
			<div>
				<div class="inputWrap">
					<b>생년월일</b>
					<div class="brithWrap">
						<div>
							<select class="form-control" name="year">
								<option value="0">년</option>
								<c:forEach var="year" begin="1930" end="2023">
									<option value="${year}">${year}</option>
								</c:forEach>
							</select>
						</div>
						<div>
							<select class="form-control" name="month">
								<option value="0">월</option>
								<c:forEach var="mon" begin="1" end="12">
									<option value="${mon}">${mon}</option>
								</c:forEach>
							</select>
						</div>
						<div>
							<select class="form-control" name="day">
								<option value="0">일</option>
								<c:forEach var="day" begin="1" end="31">
									<option value="${day}">${day}</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
				<p id="chkBirth" class="chkmsg"></p>
			</div>
			<div class="telbox">
				<div class="inputWrap">
					<b>전화번호</b>
					<select class="form-control" style="width:30%" name="firstnum" onchange="chgTel(this)">
		               	<option value="010">010</option>
		               	<option value="011">011</option>
		               	<option value="016">016</option>
		             </select>
		             &nbsp; &nbsp;
		             <input type="text" name="tel" class="form-control" style="width:70%" oninput="checkTel()">
		             <i class='far fa-check-circle' id="chkicon"></i>
		             <i class='far fa-times-circle' id="failicon"></i>
				</div>
	            <p id="chkTel" class="chkmsg"></p>
			</div>
			<div>
				<div class="inputWrap">
					<b>성별</b>
					<div style="width:100%">
						<input type="radio" name="gender" value="1" checked>&nbsp; 남 &emsp; 
	             		<input type="radio" name="gender" value="2">&nbsp; 여
					</div>
				</div>
				<p class="chkmsg"></p>
			</div>
			<div class="emailbox">
				<div class="inputWrap">
					<b>이메일</b>
					<div style="width:100%; display:flex; justify-content: space-between; align-items: center;">
						<input type="text" name="emailid" class="form-control" style="width:42%" oninput="checkEmail()">
						<strong>@</strong>
						<select class="form-control" style="width:50%" name="emailAddr">
			               	<option value="@naver.com">naver.com</option>
			               	<option value="@gmail.com">gmail.com</option>
			               	<option value="@daum.com">daum.net</option>
			               	<option value="@nate.com">nate.com</option>
						</select>
					</div>
				</div>
				<p id="chkEmail" class="chkmsg"></p>
			</div>
			<div class="w3-center" style="margin-top: 40px; margin-bottom:70px">
				<button type="submit" class="btn btn-lime" id="jobutton" disabled="ture">회원가입</button>
	            <button type="reset" class="btn btn-gray">다시 작성</button>
			</div>
		</form>
	</div>
<script>
	$(function(){
		$(".inputWrap").find("#chkicon").css("display","none")
		$(".inputWrap").find("#failicon").css("display","none")
	})
	
	let regEng = /[A-Za-z]/
	let regNum = /[0-9]/
	let regEtc = /[~!@.#$%^&*;,]/
	let regKor = /[ㄱ-ㅎ가-힣]/
	
	// 아이디 체크
	function checkId() {
		let userid = document.f.id.value
		if(regKor.test(userid) || regEtc.test(userid)) {
			$("#chkId").html("아이디는 숫자와 영어로 입력하세요.");
			$("#chkId").css("color","red");
			$(".idbox").find("#chkicon").css("display","none")
			$(".idbox").find("#failicon").css("display","block")
		} else if(userid.length < 4 || userid.length > 21) {
			$("#chkId").html("아이디는 5~20글자 이하로 입력하세요.");
			$("#chkId").css("color","red");
			$(".idbox").find("#chkicon").css("display","none")
			$(".idbox").find("#failicon").css("display","block")
		} else {
			$.ajax({
				url: "joinCheck",
				type: "POST",
				data: {id:userid},
				dataType: "text",
				success: function(result) {
					if(result == "불가") {
						$("#chkId").html("이미 사용 중인 아이디입니다.");
						$("#chkId").css("color","red");
						$(".idbox").find("#failicon").css("display","block")
						$(".idbox").find("#chkicon").css("display","none")
					} else if (result == "사용") {
						$("#chkId").html("")
						$(".idbox").find("#failicon").css("display","none")
						$(".idbox").find("#chkicon").css("display","block")
					} 
				},
				error : function() {
					alert("error");
				}
			})
			idval = userid;
		}
	}
	// 비밀번호 체크
	function checkPass() {
		let userpass = document.f.pass.value
		if(userpass.length < 8  || userpass.length > 17) {
			$("#chkPass").html("비밀번호는 8~16자로 입력하세요.");
			$("#chkPass").css("color","red");
			$(".passbox").find("#chkicon").css("display","none")
			$(".passbox").find("#failicon").css("display","block")
		} else {
			 if(!regNum.test(userpass) || !regEtc.test(userpass) || !regEng.test(userpass)) {
				$("#chkPass").html("비밀번호는 영어, 숫자, 특수문자를 포함해야합니다.");
				$("#chkPass").css("color","red");
				$(".passbox").find("#chkicon").css("display","none")
				$(".passbox").find("#failicon").css("display","block")
			} else {
				$("#chkPass").html("");
				$(".passbox").find("#failicon").css("display","none")
				$(".passbox").find("#chkicon").css("display","block")
			}
		}
	}
	
	// 재입력 확인
	function checkPass2() {
		let getpass = document.f.pass.value
		let chkpass = document.f.chgpass.value
		if(getpass != chkpass) {
			$("#chkPass2").html("비밀번호 입력값이 다릅니다.");
			$("#chkPass2").css("color","red");
			$(".passbox2").find("#chkicon").hide()
			$(".passbox2").find("#failicon").show()
		} else {
			$("#chkPass2").html("");
			$(".passbox2").find("#chkicon").show()
			$(".passbox2").find("#failicon").hide()
		}
	}
	
	// 이름
	function checkName() {
		let username = document.f.name.value
		if(username.length == 1) {
			$("#chkName").html("이름은 최소 2글자 이상 입력해주세요.");
			$("#chkName").css("color","red");
			$(".namebox").find("#chkicon").hide();
			$(".namebox").find("#failicon").show();
		} else if (regEtc.test(username)) {
			$("#chkName").html("특수문자를 포함할 수 없습니다.");
			$("#chkName").css("color","red");
			$(".namebox").find("#chkicon").hide();
			$(".namebox").find("#failicon").show();
		}else {
			$("#chkName").html("");
			$(".namebox").find("#chkicon").show();
			$(".namebox").find("#failicon").hide();
		}
	}
	
	
	let firstTel = $("select[name=firstnum]").val()
	function chgTel(chgnum) {
		firstTel = $(chgnum).val();
		checkTel();
	}
	
	// 전화번호
	function checkTel() {
		let usertel = document.f.tel.value
		if(!regNum.test(usertel) || usertel.length>9 || usertel.length<7) {
			$("#chkTel").html("전화번호는 7~8자리 숫자만 가능합니다.");
			$("#chkTel").css("color","red");
			$(".telbox").find("#chkicon").hide();
			$(".telbox").find("#failicon").show();
		} else {
			let phonNum = firstTel+usertel;
			$.ajax({
				url: "joinCheck",
				type: "POST",
				data: {tel:phonNum},
				dataType: "text",
				success: function(result) {
					if(result == "불가") {
						$("#chkTel").html("이미 사용 중인 번호입니다.");
						$("#chkTel").css("color","red");
						$(".telbox").find("#failicon").show();
						$(".telbox").find("#chkicon").hide();
					} else if (result == "사용") {
						$("#chkTel").html("")
						$(".telbox").find("#failicon").hide();
						$(".telbox").find("#chkicon").show();
					} 
				},
				error : function() {
					alert("error");
				}
			})
		}
	}
	
	// 이메일
	function checkEmail() {
		let eid = document.f.emailid.value
		if(regEtc.test(eid) || regKor.test(eid)) {
			$("#chkEmail").html("이메일 아이디는 영어나, 숫자만 가능합니다.");
			$("#chkEmail").css("color","red");
		} else {
			$("#chkEmail").html("");
		}
	}
	
	function joinchk() {
		let idval = document.f.id.value;
		let passval = document.f.pass.value;
		let passchgval = document.f.chgpass.value;
		let nameval = document.f.name.value;
		let telval = document.f.tel.value;
		let yearval = document.f.year.value;
		let monthval = document.f.month.value;
		let dayval = document.f.day.value;
		let genderval = document.f.day.value;
		let emailval = document.f.emailid.value;
		let emailAddrval = document.f.emailAddr.value;
		let emalid = emailval+emailAddrval;
		
		if(emailval != "" && idval != "" && passval != "" && passchgval != ""  && genderval != ""
			&& nameval != "" && telval != "" && (passval == passchgval) && yearval != 0 && monthval != 0 && dayval != 0
			&& $(".chkmsg").text() == "") {
			$("#jobutton").attr("disabled", false);
		} else {
			$("#jobutton").attr("disabled", true);
		}
	}
</script>
</body>
</html>