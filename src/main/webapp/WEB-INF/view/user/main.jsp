<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="../css/main.css">
<title>GOOD Camping 홈페이지</title>
</head>
<body>
	<!-- main -->
	<div class="animation_canvas">
        <div class="slider_panel">
            <img src="../img/main_1.jpg" alt="" class="slider_image">
            <img src="../img/main_2.jpg" alt="" class="slider_image">
            <img src="../img/main_3.jpg" alt="" class="slider_image">
            <img src="../img/main_4.jpg" alt="" class="slider_image">
            <img src="../img/main_5.jpg" alt="" class="slider_image">
        </div>
    </div>
	<div class="slider_text_panel">
        <div class="slider_text">
            <h1>사막 이미지</h1>
            <p>더운 사막</p>
        </div>
        <div class="slider_text">
            <h1>수국 이미지</h1>
            <p>물에서 자라는 수생식물</p>
        </div>
        <div class="slider_text">
            <h1>해파리 이미지</h1>
            <p>해파리는 독이 있다</p>
        </div>
        <div class="slider_text">
            <h1>코알라 이미지</h1>
            <p>코알라는 유칼리나무잎만 먹는다</p>
        </div>
        <div class="slider_text">
            <h1>등대 이미지</h1>
            <p>이건 그냥 등대 이미지</p>
        </div>
    </div>
        <div class="control_panel">
        <div class="control_button"></div>
        <div class="control_button"></div>
        <div class="control_button"></div>
        <div class="control_button"></div>
        <div class="control_button"></div>
    </div>
    
	<!-- 검색, 채팅 -->
	<div class="page2">
		<div>
			<h3>캠핑장 찾기</h3>
			<form action="campsearch" method="post">
				<table>
					<tr>지역</tr>
					<!-- sido ajax -->
					<tr>
						<th>입지 구분</th>
						<td>
							<select>
								<option></option>
							</select>
						</td>
					</tr>
					<tr>
						<th>주요 시설</th>
						<td>
							<select>
								<option></option>
							</select>
						</td>
					</tr>
					<tr>
						<th>바닥 형태</th>
						<td>
							<select>
								<option></option>
							</select>
						</td>
					</tr>
					<tr>
						<th>가격대</th>
						<td>
							<select>
								<option></option>
							</select>
						</td>
					</tr>
					<tr>
						<input type="submit" value="검색하기">
						<input type="button" value="상세검색">
					</tr>
				</table>
			</form>
		</div>
		<div>
			<h4>채팅</h4>			
			<input type="text"> <button>전송</button>
		</div>
	</div>
	<!-- 인기 캠핑장 -->
	<div class="page3">
		<h3>회원들이 추천한 인기 캠핑장</h3>
		<div>
			<div></div>
			<div></div>
			<div></div>
		</div>
		<input type="button" value="인기 캠핑장 더보기">
	</div>
	
	<!-- 테마별, 태그별 캠핑장 찾기 -->
	<div class="page4">
		<h3>테마별, 태그별 캠핑장 찾기</h3>
		<button>#봄 꽃여행</button>
		<button>#여름 물놀이</button>
		<button>#가을 단풍명소</button>
		<button>#겨울 눈꽃명소</button>
		<button>#반려견 동반</button>
	</div>
	
	<!-- 게시물 -->
	<div class="page5">
		<div>
			<h3>인기 게시물</h3>
			<table>
			</table>
		</div>
		<div>
			<h3>자유 게시판</h3>
			<table>
			</table>
		</div>
	</div>
	
	<script>
		$(function(){
            $(".control_button").each(function(index){
                $(this).attr("idx",index);  // 인덱스 추가
            }).click(function(){
                let index = $(this).attr("idx");    // idx 속성값 
                moveSlider(index);      // -> index 0~4
            })
        
            $(".slider_text").css("left",-300).each(function(index){
                $(this).attr("idx",index);
            });
            moveSlider(0);  // index 0으로 시작 첫번째 이미지부터 보여줌
            let idx = 0;
            let inc = 1;
            setInterval(function(){
                if(idx >=4 ) {
                    inc = -1;
                }
                if(idx <=0) {
                    inc =1;
                }
                idx += inc;
                moveSlider(idx);
            },2000)
        })
        function moveSlider(index) {
          	let winWidth = document.body.offsetWidth;
			let moveLeft = -(index *winWidth);       // 0~2400까지
            $(".slider_panel").animate({left:moveLeft},'slow'); 
            $(".control_button[idx="+index +"]").addClass("select");    // 파란 점으로 표시
            $(".control_button[idx!="+index+"]").removeClass("select");
                // idx에 해당하는 글자부분 보여주고
            $(".slider_text[idx="+index+"]").show().animate({
                left : 0
            },'slow')
                // idx에 해당하지 않는 부분 숨기고
            $(".slider_text[idx!="+index+"]").hide('slow',function(){
                $(this).css("left",-300);
            })
        }
    </script>
</body>
</html>