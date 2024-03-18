<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<!-- OpenLayers CDN -->
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.1.1/build/ol.js"></script>
<link rel="stylesheet" href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.1.1/css/ol.css">


<style type="text/css">
#map {
    width: 100%; 
    height: 500px;
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
                      url : 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/midnight/{z}/{y}/{x}.png'
                    // url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
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
          'BBOX' : [ 1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5 ],
          'SRS' : 'EPSG:3857', // SRID
          'FORMAT' : 'image/png' // 포맷
        },
        serverType : 'geoserver',
      })
    });

    let sdLayer = new ol.layer.Tile({
      source : new ol.source.TileWMS({
        url : 'http://localhost:8080/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
        params : {
          'VERSION' : '1.1.0', // 2. 버전
          'LAYERS' : 'solbum:tl_sd', // 3. 작업공간:레이어 명
          /* 'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], */
          'BBOX' : [ 1.3871489341071218E7, 3910407.083927817,
              1.4680011171788167E7, 4666488.829376997 ],
          'SRS' : 'EPSG:3857', // SRID
          'FORMAT' : 'image/png' // 포맷
        },
        serverType : 'geoserver',
      })
    });

</script>
</head>
<body>

	<div id="map" class="map"></div>   
	  
    <script src="js/map.js"></script>

</body>
</html>