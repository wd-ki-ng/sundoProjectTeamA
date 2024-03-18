<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>브이월드 오픈API</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<!-- OpenLayer -->
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
.map {
   height: 800px;
   width: 100%;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
    let map = new ol.Map(
        { // OpenLayer의 맵 객체를 생성한다.
          target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
          layers : [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
          new ol.layer.Tile(
              {
                source : new ol.source.OSM(
                    {
                     // url : 'http://api.vworld.kr/req/wmts/1.0.0/88840D39-A1E3-37E0-8508-EA3D0238A271/midnight/{z}/{y}/{x}.png'
                    url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
                    })
              }) ],
          view : new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
            center : ol.proj.fromLonLat([ 127.8, 36.2 ]),
            zoom : 8
          })
        });

    let bjdLayer = new ol.layer.Tile({
      source : new ol.source.TileWMS({
        url : 'http://localhost:8080/geoserver/carbon/wms?service=WMS', // 1. 레이어 URL
        params : {
          'VERSION' : '1.1.0', // 2. 버전
          'LAYERS' : 'carbon:tl_bjd', // 3. 작업공간:레이어 명
          'BBOX' : [1.4184269003753535E7 ,1.4307652964599207E7, 4303168.337414677, 4426552.298260351],
          'SRS' : 'EPSG:3857', // SRID
          'FORMAT' : 'image/png' // 포맷
        },
        serverType : 'geoserver',
      })
    });

    let sdLayer = new ol.layer.Tile({
      source : new ol.source.TileWMS({
        url : 'http://localhost:8080/geoserver/carbon/wms?service=WMS', // 1. 레이어 URL
        params : {
          'VERSION' : '1.1.0', // 2. 버전
          'LAYERS' : 'carbon:tl_sd', // 3. 작업공간:레이어 명
          /* 'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], */
          'BBOX' : [1.419587442581328E7, 1.4319258386658952E7,4330044.05165829, 4453428.012503964],
          'SRS' : 'EPSG:3857', // SRID
          'FORMAT' : 'image/png' // 포맷
        },
        serverType : 'geoserver',
      })
    });
    map.addLayer(sdLayer);
    map.addLayer(bjdLayer); 
});
</script>

</head>
<body>

<div id="map" class="map"></div>
</body>
</html>