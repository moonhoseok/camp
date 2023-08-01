<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file = "/WEB-INF/view/jspHeader.jsp" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title><sitemesh:write property="title" /></title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://kit.fontawesome.com/21a6628c62.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<script type="text/javascript" src="http://cdn.ckeditor.com/4.5.7/standard/ckeditor.js"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
body,h1,h2,h3,h4,h5,h6 {font-family: "Raleway", sans-serif}

body, html {
  height: 100%;
  line-height: 1.8;
}

/* Full height image header */
.bgimg-1 {
  background-position: center;
  background-size: cover;
  background-image: url("${path}/img/main_1.jpg");

  min-height: 100%;
}

.w3-bar .w3-button {
  padding: 16px;
}
</style>
<sitemesh:write property="head" />
</head>
<body>
<!-- Navbar (sit on top) -->
<div class="w3-top">
   <div class="w3-bar w3-white w3-card" id="myNavbar">
      <a href="${path}/user/main" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px"><b>GOOD</b> camping</a>
      <!-- Right-sided navbar links -->
	<div class="w3-right w3-hide-small">
		<a href="${path}/user/main" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px"><i class="fa fa-home" style="color:plum"></i> 홈</a>
		<a href="${path}/site/search" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px"><i class="fa fa-th" style="color:#dae17c"></i> 캠핑장 찾기</a>
		<a href="${path}/weather/today" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px"><i class="fa fa-cloud" style="color:lightblue"></i> 날씨</a>
		<a href="${path}/board/list" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px"><i class="fa fa-heart" style="color:pink"></i> 커뮤니티</a>
		<a href="${path}/shop/list" class="w3-bar-item w3-button w3-hover-light-grey"
             style="margin-right:50px; padding:20px 16px"><i class='fas fa-shopping-cart' style="color:gold "></i> 쇼핑</a>
		<c:if test="${empty sessionScope.loginUser}">
            <a href="${path}/user/login" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px">
               <i class="fa fa-user"></i> 로그인
            </a>
            <a href="${path}/user/join" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px">
               <i class="fa fa-envelope"></i> 회원가입
            </a>
         </c:if>
         <c:if test="${!empty sessionScope.loginUser}">
            <a href="${path}/user/mypage?id=${sessionScope.loginUser.id}" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px">
               <i class='fas fa-user-circle'></i> <b>${sessionScope.loginUser.name}님</b>
               </a>
            <a href="${path}/user/logout" class="w3-bar-item w3-button w3-hover-light-grey" style="padding:20px 16px">
               <i class='fas fa-sign-out-alt'></i> 로그아웃
            </a>
         </c:if>
      </div>
    <!-- Hide right-floated links on small screens and replace them with a menu icon -->

    <a href="javascript:void(0)" class="w3-bar-item w3-button w3-right w3-hide-large w3-hide-medium" onclick="w3_open()">
      <i class="fa fa-bars"></i>
    </a>
  </div>
</div>

<!-- Sidebar on small screens when clicking the menu icon -->
<nav class="w3-sidebar w3-bar-block w3-lime w3-card w3-animate-left w3-hide-medium w3-hide-large" style="display:none" id="mySidebar">
  <a href="javascript:void(0)" onclick="w3_close()" class="w3-bar-item w3-button w3-large w3-padding-16">Close &times;</a>
  <a href="${path}/user/main" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">홈</a>
  <a href="${path}/site/search" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">캠핑장 찾기</a>
  <a href="${path}/weather/today" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">날씨</a>
  <a href="${path}/board/list" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">커뮤니티</a>
  <a href="${path}/shop/list" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">쇼핑</a>
  <a href="${path}/user/join" onclick="w3_close()" class="w3-bar-item w3-button w3-hover-light-grey">회원가입</a>
</nav>


<!-- Modal for full size images on click-->
<div id="modal01" class="w3-modal w3-black" onclick="this.style.display='none'">
  <span class="w3-button w3-xxlarge w3-black w3-padding-large w3-display-topright" title="Close Modal Image">&times;</span>
  <div class="w3-modal-content w3-animate-zoom w3-center w3-transparent w3-padding-64">
    <img id="img01" class="w3-image">
    <p id="caption" class="w3-opacity w3-large"></p>
  </div>
</div>

<sitemesh:write property="body" />
<!-- Footer -->
<footer class="w3-center w3-lime w3-padding-64">
  <p style="margin:0">Powered by 62기 4조 김유승 김민영 문호석</p>
</footer>
 
<script>
// Modal Image Gallery
function onClick(element) {
  document.getElementById("img01").src = element.src;
  document.getElementById("modal01").style.display = "block";
  var captionText = document.getElementById("caption");
  captionText.innerHTML = element.alt;
}


// Toggle between showing and hiding the sidebar when clicking the menu icon
var mySidebar = document.getElementById("mySidebar");

function w3_open() {
  if (mySidebar.style.display === 'block') {
    mySidebar.style.display = 'none';
  } else {
    mySidebar.style.display = 'block';
  }
}

// Close the sidebar with the close button
function w3_close() {
    mySidebar.style.display = "none";
}
</script>

</body>
</html>