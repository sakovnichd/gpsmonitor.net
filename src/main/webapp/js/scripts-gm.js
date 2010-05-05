function initializeMap() {
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setCenter(new GLatLng(60.4419, 50), 5);
		map.setUIToDefault();
		var bluePS = new GIcon();
		bluePS.image = "./img/pitstop-blue.png";
		bluePS.iconSize = new GSize(15, 15);
		bluePS.iconAnchor = new GPoint(1, 15);
		var greenPS = new GIcon();
		greenPS.image = "./img/pitstop-green.png";
		greenPS.iconSize = new GSize(15, 15);
		greenPS.iconAnchor = new GPoint(1, 15);
		var redPS = new GIcon();
		redPS.image = "./img/pitstop-red.png";
		redPS.iconSize = new GSize(15, 15);
		redPS.iconAnchor = new GPoint(1, 15);
		var startIcon = new GIcon();
		startIcon.image = "./img/flag-blue1.png";
		startIcon.iconSize = new GSize(15, 15);
		startIcon.iconAnchor = new GPoint(1, 15);
		var endIcon = new GIcon();
		endIcon.image = "./img/flag-unknown.png";
		endIcon.iconSize = new GSize(15, 15);
		endIcon.iconAnchor = new GPoint(1, 15);
		//bluePS.infoWindowAnchor = new GPoint(1, 1);
		constants.blueMarkerOpts = {
			icon:bluePS
		};
		constants.greenMarkerOpts = {
			icon:greenPS
		};
		constants.redMarkerOpts = {
			icon:redPS
		};
		constants.startMarkerOpts = {
			icon: startIcon
		};
		constants.endMarkerOpts = {
			icon: endIcon
		};
		constants.lineColors=[];
		constants.lineColors['linestyle1']="#ff0000";
		constants.lineColors['linestyle2']="#ffa200";
		constants.lineColors['linestyle3']="#FFFF00";
		constants.lineColors['linestyle4']="#30FF00";
		constants.lineColors['linestyle5']="#00FFFF";
		constants.lineColors['linestyle6']="#0000ff";
		constants.lineColors['linestyle7']="#FF30ff";

		//setStrokeStyle(style:GPolyStyleOptions)
	}else
		alert('Карта не поддерживается Вашим браузером.')
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
			var polyOptions = {
				geodesic:true
			};
			var routePoints=[];
			if(points.length==0)return;
			var south=points[0][0];
			var north=points[0][0];
			var east=points[0][1];
			var west=points[0][1];
			for(i=0;i<points.length;i++){
				routePoints.push(new GLatLng(points[i][0], points[i][1]))
				south=Math.min(south, points[i][0]);
				north=Math.max(north, points[i][0]);
				east=Math.max(east, points[i][1]);
				west=Math.min(west, points[i][1]);
			};
			var polyline = new GPolyline(routePoints, constants.lineColors["linestyle1"], 2,1,polyOptions);

			if(!mapItems){
				var sw = new GLatLng(south,west);
				var ne = new GLatLng(north,east);
				var bounds = new GLatLngBounds(sw, ne);
				var centerpoint = new GLatLng((north + south)/2, (east + west)/2);
				var zoomlevel = map.getBoundsZoomLevel(bounds);
				map.setCenter(centerpoint, zoomlevel, G_NORMAL_MAP );
			}
			mapItems={};
			mapItems.markers=[];
			mapItems.route=polyline;
			mapItems.routePoints=routePoints;
			map.addOverlay(polyline);
			mapItems.startMarker=new GMarker(routePoints[0],constants.startMarkerOpts);
			mapItems.endMarker=new GMarker(routePoints[routePoints.length-1],constants.endMarkerOpts);
			for(i=0;i<res.pitStops.length;i++){
				var ps=res.pitStops[i];
				var point = new GLatLng(ps.latitude,ps.longitude);
				var marker;
				if(ps.stopTime/1000/60>=60)
					marker=new GMarker(point,constants.redMarkerOpts);
				else if(ps.stopTime/1000/60>=40)
					marker=new GMarker(point,constants.greenMarkerOpts);
				else if(ps.stopTime/1000/60>=15)
					marker=new GMarker(point,constants.blueMarkerOpts);
				mapItems.markers.push(marker);
				map.addOverlay(marker);
				(function(ps){
					GEvent.addListener(marker, "click", function(e) {
						//var myHtml = "<b>#" + e + "</b><br/>qwe";
						$("#psArrivalTime").text(ps.arrivalTime);
						$("#psLeaveTime").text(ps.leaveTime);
						$("#psLeaveFuel").text(Math.floor(ps.leaveFuel));
						$("#psArrivalFuel").text(Math.floor(ps.arrivalFuel));
						$("#psStopTime").text(Math.floor(ps.stopTime/1000/3600)+":"+Math.floor(ps.stopTime%(1000*3600)/60000));
						$("#psStopFuel").text(ps.arrivalFuel-ps.leaveFuel);
						map.openInfoWindowHtml(e, $("#pitStopMsg").html());
					});
				})(ps)

			}
			map.addOverlay(mapItems.startMarker);
			map.addOverlay(mapItems.endMarker);
	
}

function mapUnload()
{
	GUnload()	;
}

function changeRouteColor(e)
{
 if(mapItems&&mapItems.route){
	 map.removeOverlay(mapItems.route);
	 mapItems.route=new GPolyline(mapItems.routePoints, constants.lineColors[e.target.id], 2,1,{});
	 map.addOverlay(mapItems.route);
 }
	 
}