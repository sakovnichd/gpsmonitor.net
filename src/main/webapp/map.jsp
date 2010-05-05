<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>JSP Page</title>
		<script type="text/javascript" src="./js/jquery.js"></script>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAqa9OlAgfyqgzaXKwv59LjRQCCboF3zE9D-ggrMCSaC8kc95kDBR1K_q2tFdysVIoPsj1lkre5mwRdQ&sensor=false"
		type="text/javascript"></script>
    <script type="text/javascript">
			var map;
			function initialize() {
				if (GBrowserIsCompatible()) {
					map = new GMap2(document.getElementById("map_canvas"));
					map.setCenter(new GLatLng(60.4419, 40), 5);
					map.setUIToDefault();
				}
			}
		var route=null;
function addRoute(){
	$.ajax({
    url: './TrackDispatcher',
    type: 'POST',
    dataType: 'json',
    data:{startDate:$('#startDate').val()},
    error: function(XMLHttpRequest, textStatus, errorThrown){
      alert('Error loading XML document');
    },
    success: function(res,textStatus){
      //alert(res.length);
			
			var polyOptions = {geodesic:true};
			var a=[];
			for(i=0;i<res.length;i++){
				a.push(new GLatLng(res[i][0], res[i][1]))
			};
			var polyline = new GPolyline(a, "#00ff00", 1,1,polyOptions);
			if(route)
				map.removeOverlay(route);
			route=polyline;
			map.addOverlay(polyline);
			<%--var sw = new GLatLng(south,west);
var ne = new GLatLng(north,east);
var bounds = new GLatLngBounds(sw, ne);
var centerpoint = new GLatLng((north + south)/2, (east + west)/2);
var zoomlevel = map.getBoundsZoomLevel(bounds);--%>
    }
  });
}
    </script>
  </head>
  <body onload="initialize()" onunload="GUnload()">
		<input id="startDate" type="text" value="2010-03-25 13:36"/>
		<input type="button" value="Add route" onclick="addRoute()"/>
    <div id="map_canvas" style="width: 1000px; height: 600px"></div>
  </body>
</html>
