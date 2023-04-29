<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script src="<%=request.getContextPath() %>/js/js_kmw.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=38fdb692fa19c0a5b6b48cdf0d99203b"></script>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/css_kmw/res_css/rescommon.css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/css_kmw/res_css/bdhRes2.css">

<script>	

function showMap() {
	  var mapDiv = document.getElementById("map");
	  mapDiv.style.display = "block";
	  var options = {
	    center: new kakao.maps.LatLng(36.348735, 127.4374054),
	    level: 3
	  };
	  var map = new kakao.maps.Map(mapDiv, options);
	  var markerPosition = new kakao.maps.LatLng(36.348735, 127.4374054);
	  var marker = new kakao.maps.Marker({
	    position: markerPosition
	  });
	  marker.setMap(map);
	}


		$(function(){
			$.setStepStyle(1);
			
			
			$('#searchBtn').on('click',function(){
				$('#nameVal').val("");
				addr = $('#inputAddr').val().trim();
				$.ajax({
					url : "<%=request.getContextPath()%>/BdhRes2.do",
					type : "post",
					data : {"addr":addr},
					success : function(res){
						code="<table id='bdhTb'><tr><td>지 역</td><td>헌혈의집 이름</td><td>주 소</td><td>전화번호</td><td >선 택</td></tr>";
						if(res.length == 0){ // 검색 결과가 없을 경우
		                    code += "<tr><td colspan='5' style='text-align:center; font-weight:bold;'>헌혈의집 정보가 존재하지 않습니다.</td></tr>";
		                } else {
		                    $.each(res,function(i,v){
		                        code+="<tr><td>"+v.bdh_region+"</td><td style='font-weight: bold;'>"+
		                        		v.client_name+"</td><td>"+v.client_addr+"</td><td>"+v.client_tel+"</td><td style='text-align: center;'><input type='button' id='selectBdh' value='선 택' onclick='showMap()'></td></tr>";
		                    });
		                }
						code+="</table>";
						
						$('#addrCol').html(code);
						$('#bdhTb tr:eq(0)').css({'background-color':'#f6f6f6','text-align':'center','font-weight':'bold'});
						$('#bdhTb td').css('border-bottom', '1px solid #dad8d9');
						
					},
					error : function(xhr){
						alert("status : "+xhr.status);
					},
					dataType : 'json'
				})
			})
			
			$(document).on('click','#selectBdh',function(){		
				bdhName = $(this).closest('tr').find('td:eq(1)').text();
				bdhAddr = $(this).closest('tr').find('td:eq(2)').text();
				bdhTel = $(this).closest('tr').find('td:eq(3)').text();
				
				$('#nameVal').val(bdhName);
				$('#addrVal').val(bdhAddr);
				$('#telVal').val(bdhTel);
				
				
			})
			$('#nextBtn').on('click',function(){
				cnt = $('input[name="type"]:checked').length;
				if(cnt == 0){
					alert('헌혈종류를 입력하세요');
					return false;
				}else if($('#addrVal').val()==''){
					alert('헌혈의집을 입력하세요');
					return false;
				}else{
					return true;
				}
			})
				
			
			
		})
		
</script>
</head>
<body>
	<div id="container">
		<header>
			<div id="text">
				<p>헌혈의집 예약</p>
			</div>
			<div id="stepBox">
				<div class="step">
					<span>STEP1</span><br>
					<p>유의사항</p>
				</div>
				<div class="step">
					<span>STEP2</span><br>
					<p>헌혈의집 선택</p>
				</div>
				<div class="step">
					<span>STEP3</span><br>
					<p>날짜 및 시간 선택</p>
				</div>
				<div class="step">
					<span>STEP4</span><br>
					<p>개인정보입력 및 확인</p>
				</div>
			</div>
		</header>
	<form action="/BdhRes3.do" method="post">
		<div id="select">
			<div class = "selectValue">
				<div class="sTitle">
					<p>헌혈종류</p>
				</div>
				<div class="sValue">
					<input type="radio" name="type" value="전혈">전혈
					<input type="radio" name="type" value="혈장">혈장
					<input type="radio" name="type" value="혈소판">혈소판
				</div>
			</div>
			
			<div class = "selectValue">
				<div class="sTitle">
					<p>편의시설 선택</p>
				</div>
				<div class="sValue">
					<input type="checkbox">주차가능
					<input type="checkbox">지하철인근
					<input type="checkbox">인터넷이용
				</div>
			</div>
			
			<div class = "selectValue">
				<div class="sTitle">
					<p>헌혈의집 검색</p>
				</div>
				<div class="sValue">
					<input type="text" placeholder="헌혈의집 명 또는 헌혈의집 주소를 입력해주세요" name="bdhAddr" id="inputAddr">
					<input type="button" id="searchBtn" value="검 색">
				</div>
			</div>
			<div class = "selectValue">
				<div class="sTitle">
					<p>예약할 헌혈의집 이름</p>
				</div>
				<div class="sValue">
					<input type="text" name="nameVal" id="nameVal" readonly="readonly">
				</div>
			</div>
		</div>
		<input type="hidden" name="addrVal" id="addrVal">
		<input type="hidden" name="telVal" id="telVal">
		<div id="result">
			<div id="addrCol">
				
			</div>
		</div>
		<div id="map" style="display: none;width:80%;height:400px;"></div>
		
		<div id="btnwrap">
			<input type="button" value="이 전" class="btn" id="preBtn" onclick="location.href='/BdhRes1.do'">
			<input type="submit" value="다 음" class="btn" id="nextBtn">
		</div>
	</form>
	</div>
</body>
</html>