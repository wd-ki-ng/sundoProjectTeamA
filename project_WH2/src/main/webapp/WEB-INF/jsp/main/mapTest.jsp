<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="servlet.util.Util" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<% Util util = new Util(); %>
    <meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!-- 구글 차트 -->
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<!-- OpenLayers CDN -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
	<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<style type="text/css">
        #map {
        	width: 70%;
            height: 400px;
            background-color: #ccc;
            margin-top: 20px;
        }
</style>

</head>
<body>
<script type="text/javascript">
let map;
let sggLayer;
let sdLayer;
let bjdLayer;
$(document).ready(function() {
    	map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
        target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
        layers: [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
          new ol.layer.Tile({
            source: new ol.source.OSM({
           url: 'http://api.vworld.kr/req/wmts/1.0.0/88840D39-A1E3-37E0-8508-EA3D0238A271/Base/{z}/{y}/{x}.png' 
                    // vworld의 지도를 가져온다.
            })
          })
        ],
        view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
          center: ol.proj.fromLonLat([128.4, 35.7]),
          zoom: 7
        })
    	
    });

    		
	$('#sd').change(function(){
		map.removeLayer(sdLayer);
		map.removeLayer(sggLayer);
		map.removeLayer(bjdLayer);
		var sdnm = $(this).val(); // 변경된 요소의 값 가져오기
		  // tl_sd layer추가

	    $.ajax({
	        url:"/sgg.do",
	        type:'POST',
	        dataType:'json',
	        data: {'sdnm': sdnm},
	        success:function(data){
	        	var sggnm = JSON.stringify(data);
	        	var sgnm = JSON.parse(sggnm);
	        	//var sggnm = JSON.parse(data);
	             var sggt = $("#sgglist");
	             sggt.html("<option>--시/군/구를 선택하세요--</option>");
	             for(var i = 0; i < sgnm.length; i++) {
	                var item = sgnm[i];
	                //속성 값 설정
	        		sggt.append("<option id='sggnm' value='" + item.sggCd  + "'>" +  item.sggNm + "</option>");
	             }
	     	    	sdLayer = new ol.layer.Tile({
	     		    visible:true,
	     		    source : new ol.source.TileWMS({
	     		      url : 'http://localhost:8080/geoserver/cite/wms',
	     		      params : {
	     		        'VERSION' : '1.1.0',
	     		        'LAYERS' : 'cite:tl_sd',
	     		        'bbox' : ['1.3871489341071218', '3910407.083927817', '1.4680011171788167', '4666488.829376997'],
	     		        'CQL_Filter' : "sd_cd='" + sdnm + "'",
	     		        'SRS' : 'EPSG:3857',
	     		        'format' : 'image/png'
	     		      },
	     		      serverType : 'geoserver',
	     		    })
	     		  });
	     	    	
	     		   	 map.addLayer(sdLayer); // 맵 객체에 레이어를 추가함
	     		   	 
	  	           $.ajax({ 
	  		   	        url:"/searchsd.do",
	  		   	        type:'get',
	  		   	        dataType:'json',
	  		   	        data: {'sdnm': sdnm},
	  		   	        success:function(data){
	  		   	        	var searchsd = JSON.parse(data[0].stAsgeojson).bbox;
	  		   	        	map.getView().fit(searchsd,{
	  		   	        		duration : 500
	  		   	        	});
	  		   	       	 },
	  		   	       	 error: function() {
	  		   	             // 에러 발생 시 수행할 작업
	  		   	         	   alert('ajax 실패');
	  		   	       }
	  		   		});//searchsd ajax 종료
	       	 },
	       	 error: function() {
	             // 에러 발생 시 수행할 작업
	         	   alert('ajax 실패');
	       }
		});
	});
	
	$('#sgglist').change(function(){
		map.removeLayer(sggLayer);
		map.removeLayer(bjdLayer);
		var sggnm = $(this).val();
		
        // tl_sgg layer추가
	    $.ajax({
	        url:"/bjd.do",
	        type:'POST',
	        dataType:'json',
	        data: {'sggnm': sggnm},
	        success:function(data){
	        	var bjnm = JSON.stringify(data);
	        	var bjdnm = JSON.parse(bjnm);
	        	//var sggnm = JSON.parse(data);
	             var bjdlist = $("#bjdlist");
	             bjdlist.html("<option>--동/읍/면을 선택하세요--</option>");
	             for(var i = 0; i < bjdnm.length; i++) {
	            	 var item = bjdnm[i];
	            	 
	                bjdlist.append("<option value='" + item.bjdCd  + "'>" +  item.bjdNm + "</option>");
	             }
	         	 // tl_sgg layer추가
	             sggLayer = new ol.layer.Tile({
	             visible:true,
	             source : new ol.source.TileWMS({
	               url : 'http://localhost:8080/geoserver/cite/wms',
	               params : {
	                 'VERSION' : '1.1.0',
	                 'LAYERS' : 'cite :tl_sgg',
	                 'BBOX' : ['1.386872', '3906626.5', '1.4428071', '4670269.5'],
	                 'CQL_Filter' : "sgg_cd='" + sggnm + "'",
	                 'SRS' : 'EPSG:3857',
	                 'format' : 'image/png'
	               },
	               serverType : 'geoserver',
	             })
	           });
				
	           map.addLayer(sggLayer);  
	           
	           $.ajax({ 
	   	        url:"/searchsgg.do",
	   	        type:'get',
	   	        dataType:'json',
	   	        data: {'sggnm': sggnm},
	   	        success:function(data){
	   	        	var searchsgg = JSON.parse(data[0].stAsgeojson).bbox;
	   	        	map.getView().fit(searchsgg,{
	   	        		duration : 500
	   	        	});
	   	       	 },
	   	       	 error: function() {
	   	             // 에러 발생 시 수행할 작업
	   	         	   alert('ajax 실패');
	   	       }
	   		});//searchsgg ajax 종료
	       	 },
	       	 error: function() {
	             // 에러 발생 시 수행할 작업
	         	   alert('ajax 실패');
	       }
		}); // bjd ajax 종료
	}); //sgglist change 메소드 종료
	
	$('#bjdlist').change(function(){
		map.removeLayer(bjdLayer);
		var bjdlist = $(this).val();
		//tl_bjd Layer 추가
        bjdLayer = new ol.layer.Tile({
            visible:true,
            source : new ol.source.TileWMS({
              url : 'http://localhost:8080/geoserver/cite/wms',
              params : {
                'VERSION' : '1.1.0',
                'LAYERS' : 'cite :tl_bjd',
                'BBOX' : ['1.386872', '3906626.5', '1.4428071', '4670269.5'],
                'CQL_Filter' : "bjd_cd='" + bjdlist + "'",
                'SRS' : 'EPSG:3857',
                'format' : 'image/png'
              },
              serverType : 'geoserver',
            })
          });
       		 map.addLayer(bjdLayer); 
     		 
        $.ajax({ 
	        url:"/searchbjd.do",
	        type:'get',
	        dataType:'json',
	        data: {'bjdlist': bjdlist},
	        success:function(data){
	        	var searchbjd = JSON.parse(data[0].stAsgeojson).bbox;
	        	map.getView().fit(searchbjd,{
	        		duration : 500
	        	});
	       	 },
	       	 error: function() {
	             // 에러 발생 시 수행할 작업
	         	   alert('ajax 실패');
	       }
		});//searchbjd ajax 종료

	});// bjdlist change 메소드 종료

	
$('#maplist').hide();
$('#uploadfile').hide();
$('#totallist').hide();
 }); //document ready 종료
function mapsearch(){
	 $('#maplist').show();
	 $('#uploadfile').hide();
	 $('#totallist').hide();
}

function upload(){
	 $('#maplist').hide()
	 $('#totallist').hide();
	 $('#uploadfile').show();
}

function reset(){
	map.removeLayer(sdLayer);
	map.removeLayer(sggLayer);
	map.removeLayer(bjdLayer);
}
	
function chartdate(){

	var bjdcd = $('#bjdlist').val();
	var chartdate = $('#chartdate').val();
	 $.ajax({ 
	        url:"/chardata.do",
	        type:'post',
	        dataType:'text',
	        data: {'bjdcd': bjdcd, 'chartdate':chartdate},
	        success:function(data){
	        	var chartbjd = JSON.stringify(data);
	        	var charbjd = JSON.parse(chartbjd);
	        	console.log(charbjd);
	        	var chartext =document.querySelector("select[id=chartdate] option:checked").text;
	        	google.charts.load("current", {packages:["corechart"]});
	        	google.charts.setOnLoadCallback(drawChart);
	        	function drawChart() {
	        	  var data = google.visualization.arrayToDataTable([
	        		    ['Effort', 'Amount given'],
	        		    [chartext, charbjd],
	        		  ]);

	        		  var options = {
	        		    title: '월 평균 전기사용량',
	        		    pieHole: 0.4,
	        		  };

	        		  var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
	     		  		chart.draw(data, options);
	        	}
	        
	       	 },
	       	 error: function() {
	             // 에러 발생 시 수행할 작업
	         	   alert('ajax 실패');
	       }
	       	
   		
		});//searchbjd ajax 종료
}
</script>
	<section style="text-align: center;">
		<h1>탑 메뉴</h1>
	</section>

    <div class="d-flex align-self-center border border-secondary">
            <div class="p-2 align-self-baseline mt-4 border border-secondary" style="width: 15%; ">
				<label class="mt-4" type="button" id="mapsearch" onclick="mapsearch()">탄소지도 검색</label><br>
				<label class="mt-4" type="button" id="upload" onclick="upload()">데이터 업로드</label><br>
            </div>
          	<div class="p-2 align-self-center" style="width: 30%;">  
				<div id ="maplist">
 		           	<select class="form-control mb-3" id="sd" name="sd">	
                		<option value="">--시/도/를 선택하세요--</option>
               			<c:forEach items="${sidolist}" var="sido">
                		<option id="sido" name="sido" value="${sido.sdCd}">${sido.sdNm}</option>  
                		</c:forEach>
               		</select>
                	<select class="form-control mb-3" id="sgglist" name="sgglist">
                    	<option value="">--시/군/구를 선택하세요--</option>
                	</select>
                	<select class="form-control mb-3" id="bjdlist" name="bjdlist"> 
                    	<option value="">--동/읍/면을 선택하세요--</option> 
                	</select>
                	<button type="button" class="btn btn-primary" onclick="reset()">초기화</button><hr>
                	<select id="chartdate" onchange="chartdate()">
                	<option value="">---날짜를 선택하세요---</option>
                		<optgroup label="2022년">
                			<option value="202201">1월</option>
                			<option value="202202">2월</option>
                			<option value="202203">3월</option>
                			<option value="202204">4월</option>
                			<option value="202205">5월</option>
                			<option value="202206">6월</option>
                			<option value="202207">7월</option>
                			<option value="202208">8월</option>
                			<option value="202209">9월</option>
                			<option value="202210">10월</option>
                			<option value="202211">11월</option>
                			<option value="202212">12월</option>
                		</optgroup>
                		<optgroup label="2023년">
                			<option value="202301">1월</option>
                			<option value="202302">2월</option>
                			<option value="202303">3월</option>
                			<option value="202304">4월</option>
                			<option value="202305">5월</option>
                			<option value="202306">6월</option>
                			<option value="202307">7월</option>
                			<option value="202308">8월</option>
                			<option value="202309">9월</option>
                			<option value="202310">10월</option>
                			<option value="202311">11월</option>
                			<option value="202312">12월</option>
                		</optgroup>
                	</select>
                	<div id="donutchart" style="width: 700px; height: 300px; float: left"></div>
            	</div>
            	<div id ="uploadfile">
            		<form action="read-file.do" method="post" enctype="multipart/form-data">
						<input type="file" name="upFile">
						<button>업로드</button>
					</form>
            	</div>

			</div>
        	<div class="p2" id="map" style="width: 50%; height: 700px;"></div>
    </div>
    <footer style="text-align: center">
    	<h1>footer</h1>
    </footer>
</body>
</html>