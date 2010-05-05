<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page pageEncoding="UTF-8" contentType="text/html" import="java.util.*,java.text.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
            %><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
            %><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
            %>
<html>
	<head>
		<title>GPS Monitor</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" media="screen" href="./css/style.css" />
		<link rel="stylesheet" type="text/css" media="print" href="./css/print.css" />
		<link rel="stylesheet" type="text/css" href="./css/datepicker.css" />
		<%
		ru.magnetosoft.gpsmonitorgm.controllers.MapPageController.prepare(request);
		%>
		<style>
			.selectionColor{
				position: relative;
				border: 1px solid black;
				height: 20px;
				width: 100px;
				background-color: red;
				cursor: pointer;
			}
		</style>
	</head>
	<body onload="initialize()" onunload="mapUnload()" >
		<div style="display: none">
			<div id="pitStopMsg" style="top: 537px; left: 334px; display: block;" class="">
				<%--<img width="108" height="73" class="tmback" alt="" src="./img/tm-back.png">--%>
				<div class="<%--tmajax--%>" style="width: 260px;">
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
			<div id="logo"><img src="./img/Geometric.png" height="50" width="218" alt="Geometric" /></div>
			<div id="title">
				<div id="titleleft"></div>
				<div id="titleright"></div>
				<img src="./img/gpsmonitoring-logo_gr.png" width="195" height="24" alt="GPS мониторинг" />
				<div style="padding: 30px 0 0 30px" id="mapSelectors">
					<input type="radio" name="mt" value="gm" id="rbGm" <c:if test="${mapType=='gm'}">checked="checked"</c:if>/>
					<label for="rbGm" style="position:relative;top:-2px;font-weight: bold">GoogleMaps</label>
					&nbsp;
					<input type="radio" name="mt" value="ym" id="rbYm" <c:if test="${mapType=='ym'}">checked="checked"</c:if>/>
					<label for="rbYm" style="position:relative;top:-2px;font-weight: bold">YandexMaps</label>
				</div>
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
				<input id="masterFormData:valueRadiusBlue" name="masterFormData:valueRadiusBlue" type="text" value="30" style="display: none" /><input id="masterFormData:valueTimeBlue" name="masterFormData:valueTimeBlue" type="text" value="30" style="display: none" />
				<input id="masterFormData:valueRadiusGreen" name="masterFormData:valueRadiusGreen" type="text" value="0" style="display: none" /><input id="masterFormData:valueTimeGreen" name="masterFormData:valueTimeGreen" type="text" value="0" style="display: none" />
				<input id="masterFormData:valueRadiusRed" name="masterFormData:valueRadiusRed" type="text" value="0" style="display: none" /><input id="masterFormData:valueTimeRed" name="masterFormData:valueTimeRed" type="text" value="0" style="display: none" />

				<div class="routeslist" style="background-color: #F1F2F2">
					<table class="routes">
						<tbody>
							<tr>
								<td>
									<div id="search">
										<form>
											<input type="hidden" name="trackFileId" id="trackFileId" value="${trackFileId}"/>
											<input type="hidden" name="mapType" id="mapType"/>
										<h1>Параметры маршрута
											<hr />
										</h1>
										
										<div id="searchform_wrapper">
											<table class="search">
												<c:if test="${empty trackFileId}">
												<tr>
													<td class="numberinfo">
									Id автомобиля:
													</td>
													<td class="dateinfo">
														<select size="1" name="truckId" id="truckId" class="search number" title="Id автомобиля">
															<%--<option value="359983001851694">359983001851694</option>--%>
															<c:forEach items="${cars}" var="v">
																<option value="${v.value}" <c:if test="${truckId==v.value}">selected</c:if>>${v.key}</option>
															</c:forEach>
														</select>
													</td>
													<%--							<td class="searchsubmit">&nbsp;	</td>--%>
												</tr>
												</c:if>
												<tr>
													<td>
									Старт маршрута:
													</td>
													<td>
														<input id="dateStart" name="dateStart" type="text" value="${dateStart}" <c:if test="${not empty trackFileId}">disabled</c:if> class="search date" />
														<input id="timeStart" name="timeStart" type="text" value="${timeStart}" <c:if test="${not empty trackFileId}">disabled</c:if> class="search time" onfocus=" " />
													</td>
												</tr>
												<tr>
													<td>
									Финиш маршрута:
													</td>
													<td>
														<input id="dateEnd" name="dateEnd" type="text" value="${dateEnd}" <c:if test="${not empty trackFileId}">disabled</c:if> class="search date" />
														<input id="timeEnd" name="timeEnd" type="text" value="${timeEnd}" <c:if test="${not empty trackFileId}">disabled</c:if>  class="search time" onfocus="" />
													</td>
												</tr>
												<c:if test="${empty trackFileId}">
												<tr>
													<td colspan="2" align="right">
														<input type="button" value="Отобразить маршрут" onclick="searchRoute()" title="Найти"  />
													</td>
												</tr>
												</c:if>
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
												</form>
									</div>

								</td>
							</tr>
							<tr>
								<td>
									<hr />
									<div class="routedetail" style="padding-left: 5px">
										<dl>
											<dt>Длина маршрута</dt>
											<dd><span id="routeLength"></span> км</dd>
											<dt>Уровни топлива</dt>
											<dd>Старт: <span id="startFuel"></span> Финиш: <span id="endFuel"></span> </dd>
										</dl>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<hr />
									<a href="#" id="printBtn" class="print" onclick="printMap();return false">Версия для печати </a>
								</td>
							</tr>
							<tr>
								<td>
									<hr />
									<div class="routedetail" style="padding-left: 5px">
										<dl>
											<dt>Выберите цвет трека:</dt>
											<dd style="margin: 0;padding-top: 7px">
												<span class="selectionColor" id="linestyle1" style="background-color: #ff0000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle2" style="background-color: #ffa200">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle3" style="background-color: #FFFF00">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle4" style="background-color: #30FF00">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle5" style="background-color: #00FFFF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle6" style="background-color: #0000ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
												<span class="selectionColor" id="linestyle7" style="background-color: #FF30ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
											</dd>

										</dl>
									</div>
									
								</td>
							</tr>
							<tr>
								<td>
									<%--параметры простоя--%>
									<div id="pitStopsRanges" class="pitStopsRanges" style="display: block">

										<h3 align="center">Легенда</h3>
										<img src="./img/pitstop-blue.png"/> <%--Радиус: <input name="rangeValueRadiusBlue" type="text" size="5" value=""/>--%> Время простоя: 15-40 мин <%--<input name="rangeValueTimeBlue" type="text" size="5" value=""/>--%>
										<br/>
										<img src="./img/pitstop-green.png"/> <%--Радиус: <input name="rangeValueRadiusGreen" type="text" size="5" value="'+valueRadiusGreen+'"/>--%> Время простоя: 40-60 мин <%--<input name="rangeValueTimeGreen" type="text" size="5" value=""/>--%>
										<br/>
										<img src="./img/pitstop-red.png"/> <%--Радиус: <input name="rangeValueRadiusRed" type="text" size="5" value="'+valueRadiusRed+'"/>--%> Время простоя: >60 мин <%--<input name="rangeValueTimeRed" type="text" size="5" value=""/>--%>
										<br/>
										<img src="./img/flag-blue1.png"/>  Начало пути
										<br/>
										<img src="./img/flag-unknown.png"/>  Конец пути

										<%--<div class="distanceRangesControlHolder">
							<a href="#" class="distanceRangesControlApply" onclick="applyPitStopsRecords(); togglePitStopsRanges();" >Принять</a>
							<a href="#" onclick="togglePitStopsRanges();" class="distanceRangesControlAdd">Отменить</a>
						</div>--%>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

			</div>
		</div>
									<%--<br  style="page-break-before:always;"/>--%>
<div class="pitStops" id="pitStopsTable" style="padding: 20px 5px 0 5px;page-break-before:always;">
	<table border="1" width="100%" style="table-layout: fixed">
				<colgroup>
					<col style="width: 50px"/>
					<col style=""/>
					<col style="text-align: right"/>
					<col style=""/>
					<col style="text-align: right"/>
					<col style="text-align: right" align="right"/>
					<col style="text-align: right"/>
				</colgroup>
				<thead>
					<tr>
						<th>№</th>
						<th>Начало простоя</th>
						<th>Уровень топлива</th>
						<th>Окончание простоя</th>
						<th>Уровень топлива</th>
						<th>Время простоя</th>
						<th>Расход топлива</th>
					</tr>
				</thead>
				<tbody>
					<tr><td></td></tr>
				</tbody>
			</table>

		</div>
<%
		if(request.getParameter("mapType")!=null&&"gm".equals(request.getParameter("mapType")))
				{ request.setAttribute("mapType","gm");
				%>
		<script src="http://maps.google.com/maps?file=api&amp;v=3&amp;key=ABQIAAAAen3NyV56ahcd1g4c3h6RBhSoYb0URiH66KbN9DHjrjY2Y-CFSxQDL2lPvz5kc-KDqdFgmpbOQhs20g&sensor=false"
		type="text/javascript"></script>
		<script type="text/javascript" src="./js/scripts-gm.js"></script>
		<% }else
		 {request.setAttribute("mapType","ym");%>
		<script src="http://api-maps.yandex.ru/1.1/index.xml?key=ANUGs0sBAAAA6tOANgMA2BWmngPdE6mjOWks6K3tWSr2-WcAAAAAAAAAAACVR3VHhmPjRX1OlKvpWZvhme7P-A==" type="text/javascript"></script>
		<script type="text/javascript" src="./js/scripts-yandex.js"></script>
		<% }%>
		<script type="text/javascript" language="JavaScript">
			document.write("<link rel='stylesheet' href='./css/highres.css' type='text/css' />");
		</script>
		<script type="text/javascript" src="./js/commons.js"></script>
		<script type="text/javascript" src="./js/jquery.js"></script>
		<script type="text/javascript" src="./js/DatePicker.js"></script>
		<script type="text/javascript" src="./js/DateHelper.js"></script>
		<script type="text/javascript" src="./js/jquery.maskeditinput-1.2.2.js"></script>
		<%--<script type="text/javascript">jQuery.noConflict()</script>
		<script src="./js/prototype.js" type="text/javascript"></script>
		<script src="./js/scriptaculous.js" type="text/javascript"></script>--%>
		<%--<script type="text/javascript" src="./js/epoch_classes.js"></script>--%>
		<script type="text/javascript">
		  var setRoute=<%=request.getParameter("setRoute")==null||request.getParameter("setRoute").equals("false")?false:true%>;
			var mapItems=null;
			var constants={};
		</script>
	</body>
</html>

