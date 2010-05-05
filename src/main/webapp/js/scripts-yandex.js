
function initializeMap() {
	map = new YMaps.Map(document.getElementById("map"));
	map.setCenter(new YMaps.GeoPoint(33.7433105,50.7900466), 5);
	map.addControl(new YMaps.TypeControl());
	map.addControl(new YMaps.ToolBar());
	map.addControl(new YMaps.Zoom());
	map.addControl(new YMaps.MiniMap());
	map.addControl(new YMaps.ScaleLine());
	map.enableScrollZoom();
	//		map.setUIToDefault();
	var bluePS= new YMaps.Style();
	bluePS.iconStyle = new YMaps.IconStyle();
	bluePS.iconStyle.href = "./img/pitstop-blue.png";
	bluePS.iconStyle.size = new YMaps.Point(15, 15);
	bluePS.iconStyle.offset = new YMaps.Point(-8, -15);
	var greenPS= new YMaps.Style();
	greenPS.iconStyle = new YMaps.IconStyle();
	greenPS.iconStyle.href = "./img/pitstop-green.png";
	greenPS.iconStyle.size = new YMaps.Point(15, 15);
	greenPS.iconStyle.offset = new YMaps.Point(-8, -15);
	var redPS = new YMaps.Style();
	redPS.iconStyle = new YMaps.IconStyle();
	redPS.iconStyle.href = "./img/pitstop-red.png";
	redPS.iconStyle.size = new YMaps.Point(15, 15);
	redPS.iconStyle.offset = new YMaps.Point(-8, -15);
		
	var startImage= new YMaps.Style();
	startImage.iconStyle = new YMaps.IconStyle();
	startImage.iconStyle.href = "./img/flag-blue1.png";
	startImage.iconStyle.size = new YMaps.Point(15, 15);
	startImage.iconStyle.offset = new YMaps.Point(-8, -15);
	var endImage= new YMaps.Style();
	endImage.iconStyle = new YMaps.IconStyle();
	endImage.iconStyle.href = "./img/flag-unknown.png";
	endImage.iconStyle.size = new YMaps.Point(15, 15);
	endImage.iconStyle.offset = new YMaps.Point(-8, -15);
	//bluePS.infoWindowAnchor = new GPoint(1, 1);
	constants.blueMarkerOpts = {
		style:bluePS
	};
	constants.greenMarkerOpts = {
		style:greenPS
	};
	constants.redMarkerOpts = {
		style:redPS
	};
	constants.startMarkerOpts = {
		style: startImage
	};
	constants.endMarkerOpts={
		style:endImage
	};
	var s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = 'ff0000FF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle1", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = 'ffa200FF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle2", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = 'FFFF00FF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle3", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = '30FF00FF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle4", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = '00FFFFFF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle5", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = '0000ffFF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle6", s);
	s = new YMaps.Style();
	s.lineStyle = new YMaps.LineStyle();
	s.lineStyle.strokeColor = 'FF30ffFF';
	s.lineStyle.strokeWidth = '2';
	YMaps.Styles.add("linestyle7", s);
}
function displayRoute(res){

	if(mapItems){
		map.removeOverlay(mapItems.route);
		for(i=0;i<mapItems.markers.length;i++)
			map.removeOverlay(mapItems.markers[i]);
		map.removeOverlay(mapItems.startMarker);
		map.removeOverlay(mapItems.endMarker);
	}

	var points=res.points;
			
	var routePoints=[];
	if(points.length==0)return;
	var south=points[0][0];
	var north=points[0][0];
	var east=points[0][1];
	var west=points[0][1];
	for(i=0;i<points.length;i++){
		routePoints.push(new YMaps.GeoPoint(points[i][1], points[i][0]))
		south=Math.min(south, points[i][0]);
		north=Math.max(north, points[i][0]);
		east=Math.max(east, points[i][1]);
		west=Math.min(west, points[i][1]);
	};
	
	var polyline = new YMaps.Polyline(routePoints);
	polyline.setStyle("linestyle1");

	if(!mapItems){
		var sw = new YMaps.GeoPoint(west,south);
		var ne = new YMaps.GeoPoint(east,north);
		var bounds = new YMaps.GeoBounds(sw, ne);
		var centerpoint = new YMaps.GeoPoint( (east + west)/2,(north + south)/2);
		var zoomlevel = bounds.getMapZoom(map);
		map.setCenter(centerpoint, zoomlevel);
	}
	mapItems={};
	mapItems.markers=[];
	mapItems.route=polyline;
	map.addOverlay(polyline);

	mapItems.startMarker=new YMaps.Placemark(routePoints[0],constants.startMarkerOpts);
	mapItems.startMarker.name = "Начало маршрута";
	//mapItems.startMarker.description = "Столица Российской Федерации";

	//			new GMarker(,constants.startMarkerOpts);
	mapItems.endMarker=new YMaps.Placemark(routePoints[routePoints.length-1],constants.endMarkerOpts);//,constants.endMarkerOpts);
	mapItems.endMarker.name = "Конец маршрута";
	for(i=0;i<res.pitStops.length;i++){
		var ps=res.pitStops[i];
		var point = new YMaps.GeoPoint(ps.longitude,ps.latitude);
		var marker;
		if(ps.stopTime/1000/60>=60)
			marker=new YMaps.Placemark(point,constants.redMarkerOpts);
		else if(ps.stopTime/1000/60>=40)
			marker=new YMaps.Placemark(point,constants.greenMarkerOpts);
		else if(ps.stopTime/1000/60>=15)
			marker=new YMaps.Placemark(point,constants.blueMarkerOpts);
		mapItems.markers.push(marker);

		$("#psArrivalTime").text(ps.arrivalTime);
		$("#psLeaveTime").text(ps.leaveTime);
		$("#psLeaveFuel").text(Math.floor(ps.leaveFuel));
		$("#psArrivalFuel").text(Math.floor(ps.arrivalFuel));
		$("#psStopTime").text(Math.floor(ps.stopTime/1000/3600)+":"+Math.floor(ps.stopTime%(1000*3600)/60000));
		$("#psStopFuel").text(ps.arrivalFuel-ps.leaveFuel);
		marker.description=$("#pitStopMsg").html();
		map.addOverlay(marker);
	}
	map.addOverlay(mapItems.startMarker);
	map.addOverlay(mapItems.endMarker);
}
function mapUnload()
{
	map.destructor();
}

function changeRouteColor(e)
{
 if(mapItems&&mapItems.route)
	 mapItems.route.setStyle(e.target.id);
}