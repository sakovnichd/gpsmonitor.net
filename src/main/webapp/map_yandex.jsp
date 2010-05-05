<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page pageEncoding="UTF-8" contentType="text/html"%>
<html>
	<head>
		<title>GPS Monitor - Mondi</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" media="screen" href="./css/style.css" />

		<link rel="stylesheet" type="text/css" media="print" href="./css/print.css" />
		<link rel="stylesheet" type="text/css" media="screen" href="./css/datepicker.css" />
		<script src="http://maps.google.com/maps?file=api&amp;v=3&amp;key=ABQIAAAAqa9OlAgfyqgzaXKwv59LjRQCCboF3zE9D-ggrMCSaC8kc95kDBR1K_q2tFdysVIoPsj1lkre5mwRdQ&sensor=false"
		type="text/javascript"></script>
		<script type="text/javascript" language="JavaScript">
			document.write("<link rel='stylesheet' href='./css/highres.css' type='text/css' />");
		</script>
		<script type="text/javascript" src="./js/jquery.js"></script>
		<script type="text/javascript" src="./js/DatePicker.js"></script>
		<script type="text/javascript" src="./js/DateHelper.js"></script>
		<script type="text/javascript" src="./js/jquery.maskeditinput-1.2.2.js"></script>
		<%--<script type="text/javascript">jQuery.noConflict()</script>
		<script src="./js/prototype.js" type="text/javascript"></script>
		<script src="./js/scriptaculous.js" type="text/javascript"></script>--%>
		<script type="text/javascript" src="./js/epoch_classes.js"></script>
		<script type="text/javascript">
			var calendar1, calendar2;
			function initialize() {
				//calendar1 = new Epoch('dp_cal1','popup',document.getElementById('dateStart'));
				//calendar2 = new Epoch('dp_cal2','popup',document.getElementById('dateEnd'));
				$("#dateStart,#dateEnd").mousedown(function(evt){
					_cal = calendarInit(evt.target, evt.target.id,'ru');
				})

				$.mask.definitions['~']='[+-]';
				$('#dateStart, #dateEnd').mask('99.99.9999');
				$('#timeStart, #timeEnd').mask('99:99');
				$(window).resize(function(){
					$('#map,.routeslist').height($(window).height()-$("#map").offset().top-3);
				});
				$(window).resize();
				if (GBrowserIsCompatible()) {
					map = new GMap2(document.getElementById("map"));
					map.setCenter(new GLatLng(60.4419, 50), 5);
					map.setUIToDefault();
				}
			}
			var route=null;
			var markers=null;
			function searchRoute(){
				jQuery.ajax({
					url: './TrackDispatcher',
					type: 'POST',
					dataType: 'json',
					data:{startDate:$("#dateStart").val()+" "+$("#timeStart").val(),
						endDate:$("#dateEnd").val()+" "+$("#timeEnd").val(),
						truckId:$("#truckId").val()},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						alert('Error loading document');
					},
					success: function(res,textStatus){
						//alert(res.length);
						jQuery("#routeLength").text((res.length/1000).toFixed(2));
						jQuery("#startFuel").text(res.startFuel);
						jQuery("#endFuel").text(res.endFuel);
						if(route){
							map.removeOverlay(route);
							for(i=0;i<markers.length;i++)
								map.removeOverlay(markers[i]);
						}
						markers=[];
						var points=res.points;
						var polyOptions = {geodesic:true};
						var a=[];
						if(points.length==0)return;
						var south=points[0][0];
						var north=points[0][0];
						var east=points[0][1];
						var west=points[0][1];
						for(i=0;i<points.length;i++){
							a.push(new GLatLng(points[i][0], points[i][1]))
							south=Math.min(south, points[i][0]);
							north=Math.max(north, points[i][0]);
							east=Math.max(east, points[i][1]);
							west=Math.min(west, points[i][1]);
						};
						var polyline = new GPolyline(a, "#00ff00", 1,1,polyOptions);

						if(!route){
							var sw = new GLatLng(south,west);
							var ne = new GLatLng(north,east);
							var bounds = new GLatLngBounds(sw, ne);
							var centerpoint = new GLatLng((north + south)/2, (east + west)/2);
							var zoomlevel = map.getBoundsZoomLevel(bounds);
							map.setCenter(centerpoint, zoomlevel, G_NORMAL_MAP );
						}
						route=polyline;
						map.addOverlay(polyline);
						
						//var bluePS = new GIcon(G_DEFAULT_ICON);

							var bluePS = new GIcon();
				bluePS.image = "./img/pitstop-blue.png";
				bluePS.iconSize = new GSize(15, 15);
				bluePS.iconAnchor = new GPoint(1, 15);
				//bluePS.infoWindowAnchor = new GPoint(1, 1);

							markerOptions = { icon:bluePS };

						for(i=0;i<res.pitStops.length;i++){
							var ps=res.pitStops[i];
							var point = new GLatLng(ps.latitude,ps.longitude);
							var marker=new GMarker(point,markerOptions);
							markers.push(marker);
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
					}
				});
			}
	


		</script>
	</head>
	<body onload="initialize()" onunload="GUnload()" >
		<div style="display: none">
		<div id="pitStopMsg" style="top: 537px; left: 334px; display: block;" class="">
			<%--<img width="108" height="73" class="tmback" alt="" src="./img/tm-back.png">--%>
			<div class="<%--tmajax--%>" style="width: 240px;">
				<%--<strong><span title="Автомобиль">в671нн</span></strong><br/>--%>
				<div class="tmicons"><span>
						<img width="10" height="10" title="Время замера" alt="Время замера" src="./img/icon-time.png">
					</span>
					<span><img width="10" height="10" title="Уровень топлива" alt="Уровень топлива" src="./img/icon-fuel.png"></span></div>
				<div class="tmvalues"><div class="tmvalues_0">
						<span id="psArrivalTime"></span><br>
						<span id="psArrivalFuel">302.83</span> л<br/></div>
					<div class="tmvalues_1">
						<span id="psLeaveTime">26.05.07 11:15</span><br/>
						<span id="psLeaveFuel">206</span> л<br></div>
					<hr/>
					<div class="tmvalues_footer">Время простоя: <span id="psStopTime">0:44</span>
						<br/>Расход топлива: <span id="psStopFuel">-96.83</span> л.
						<%--<div>
							<br clear="all">
						</div>--%>
					</div>
				</div>
			</div>
		</div>
</div>
		<div id="header">
			<div id="logo"><img src="./img/mondi-logo.png" height="60" width="155" alt="Mondi Business Paper" /></div>
			<div id="title">
				<div id="titleleft"></div>
				<div id="titleright"></div>
				<img src="./img/gpsmonitoring-logo.png" width="195" height="24" alt="GPS мониторинг" />
			</div>

		</div>
		<div id="body" style="position: relative">
			<div style="margin-right: 300px">
				<%--<div id="rulers">
					<a href="#" onclick="if(window.clearFormHiddenParams_masterFormData!=undefined) {clearFormHiddenParams_masterFormData('masterFormData');}document.forms['masterFormData'].elements['masterFormData:_idcl'].value='masterFormData:_idJsp0';if(document.forms['masterFormData'].onsubmit){var result=document.forms['masterFormData'].onsubmit();  if( (typeof result == 'undefined') || result ) {document.forms['masterFormData'].submit();}}else{document.forms['masterFormData'].submit();}return false;"  class="print">Печать</a>
					<a id="" name="" href="/gps-monitor-client/secure/map?w=1024&h=768" class="save">Сохранить</a>
					<a href="help.html" class="help">Справка</a>
				</div>--%>

				<div id="map" style="height: 500px;background-color: black">
				</div>

			</div>

			<div id="routes" style="width: 300px;position: absolute;right: 0;top:0">
				<%--параметры простоя
		<div id="pitStopsRanges" class="pitStopsRanges" style="display: block">

						<h3 align="center">Задайте радиус и время простоя</h3>
						<img src="./img/pitstop-blue.png"/> Радиус: <input name="rangeValueRadiusBlue" type="text" size="5" value=""/> Время: <input name="rangeValueTimeBlue" type="text" size="5" value=""/>
						<br/>
						<img src="./img/pitstop-green.png"/> Радиус: <input name="rangeValueRadiusGreen" type="text" size="5" value="'+valueRadiusGreen+'"/> Время: <input name="rangeValueTimeGreen" type="text" size="5" value=""/>
						<br/>
						<img src="./img/pitstop-red.png"/> Радиус: <input name="rangeValueRadiusRed" type="text" size="5" value="'+valueRadiusRed+'"/> Время: <input name="rangeValueTimeRed" type="text" size="5" value=""/>

						<div class="distanceRangesControlHolder">
							<a href="#" class="distanceRangesControlApply" onclick="applyPitStopsRecords(); togglePitStopsRanges();" >Принять</a>
							<a href="#" onclick="togglePitStopsRanges();" class="distanceRangesControlAdd">Отменить</a>
						</div>
					</div>--%>
				<input id="masterFormData:valueRadiusBlue" name="masterFormData:valueRadiusBlue" type="text" value="30" style="display: none" /><input id="masterFormData:valueTimeBlue" name="masterFormData:valueTimeBlue" type="text" value="30" style="display: none" />
				<input id="masterFormData:valueRadiusGreen" name="masterFormData:valueRadiusGreen" type="text" value="0" style="display: none" /><input id="masterFormData:valueTimeGreen" name="masterFormData:valueTimeGreen" type="text" value="0" style="display: none" />
				<input id="masterFormData:valueRadiusRed" name="masterFormData:valueRadiusRed" type="text" value="0" style="display: none" /><input id="masterFormData:valueTimeRed" name="masterFormData:valueTimeRed" type="text" value="0" style="display: none" />

				<div class="routeslist" style="background-color: #F1F2F2">
					<table class="routes">
						<tbody>
							<tr>
								<td>
									<div id="search">
										<h1>Поиск маршрута</h1>
										<div id="searchform_wrapper">
											<table class="search">
												<tr>
													<td class="numberinfo">
									Id автомобиля:
													</td>
													<td class="dateinfo">
														<input id="truckId" type="text" value="359983001851694" alt="Номер автомобиля" title="Id автомобиля" class="search number" />
													</td>
													<%--							<td class="searchsubmit">&nbsp;	</td>--%>
												</tr>
												<tr>
													<td>
									Старт маршрута:
													</td>
													<td>
														<input id="dateStart" type="text" value="24.03.2010" class="search date" />
														<input id="timeStart" type="text" value="16:31" class="search time" onfocus=" " />
													</td>
												</tr>
												<tr>
													<td>
									Финиш маршрута:
													</td>
													<td>
														<input id="dateEnd" type="text" value="25.03.2010" class="search date" />
														<input id="timeEnd" type="text" value="16:31"  class="search time" onfocus="" />
													</td>
												</tr>
												<tr>
													<td colspan="2" align="right">
														<input type="button" value="Отобразить маршрут" onclick="searchRoute()" title="Найти"  />
													</td>
												</tr>
											</table>
										</div>
										<div class="searcherror error" style="display: none">
											<ul>
												<li>
													<span title="Ошибки введённых данных.">Номер машины должен соответствовать шаблону 'бЦЦЦбб' (например 'а021вм').
									Буквы номера должны быть русскими.</span>
												</li>
											</ul>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div class="routedetail">
										<dl>
											<dt>Длина маршрута</dt>
											<dd><span id="routeLength"></span> км</dd>
											<dt>Уровни топлива</dt>
											<dd>Старт: <span id="startFuel"></span> Финиш: <span id="endFuel"></span> </dd>
										</dl>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			</div>
		</div>
	</body>
</html>

