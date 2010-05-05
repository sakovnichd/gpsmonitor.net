<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page pageEncoding="UTF-8" contentType="text/html"%>

<html>
    <head>
        <title>GPS Monitor - Mondi</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="stylesheet" type="text/css" media="screen" href="./css/style.css" />
        <link rel="stylesheet" type="text/css" media="print" href="./css/print.css" />
        
       
        <script type="text/javascript" src="./js/jquery.js"></script>
<script type="text/javascript">jQuery.noConflict()</script>
	<script src="./js/prototype.js" type="text/javascript"></script>
	<script src="./js/scriptaculous.js" type="text/javascript"></script>

        <script type="text/javascript" src="./js/javascript.js"></script>
        <script type="text/javascript" src="./js/epoch_classes.js"></script>
        <script type="text/javascript" src="./js/zoom.js"></script>
        <script type="text/javascript" src="./js/timemarks.js"></script>
        
        <script type="text/javascript">
	var calendar1, calendar2;
	window.onload = function() {
        calendar1 = new Epoch('dp_cal1','popup',document.getElementById('masterFormData:date_start'));
        calendar2 = new Epoch('dp_cal2','popup',document.getElementById('masterFormData:date_end'));
	openRouteByCoockie();
        showLoadingPoint();

        zoombox.createBox("zoom");
    }
</script>

        
    </head>
<body>

<div id="header"> <%--<!-- шапка -->--%>
<div id="logo"><img src="./img/mondi-logo.png" height="60" width="155" alt="Mondi Business Paper" /></div>
<div id="title">
<div id="titleleft"></div>
<div id="titleright"></div>
<img src="./img/gpsmonitoring-logo.png" width="195" height="24" alt="GPS мониторинг" />
</div>
</div>

<div id="body">

<div id="rulers">
<h:commandLink action="#{visit.print}" styleClass="print" value="Печать"/>
<h:outputLink  value="#{visit.mapPath}?w=1024&h=768" styleClass="save">
	<h:outputText  value="Сохранить"/>
</h:outputLink>
<a href="help.html" class="help">Справка</a>
</div>

<div id="scale">
<div class="scale2">Масштаб:</div>

<div class="scale2">
<h:commandLink actionListener="#{mapManager.decreaseScale}" rendered="#{mapManager.canDecreaseScale}">
<h:graphicImage url="./img/scale-minus.png" width="9" height="9" alt="Уменьшить масштаб"/>
</h:commandLink>
</div>

<div class="scale"><h:outputText escape="false" value="#{mapManager.scale}"/></div>

<div class="scale2">
<h:commandLink actionListener="#{mapManager.increaseScale}" rendered="#{mapManager.canIncreaseScale}">
<h:graphicImage url="./img/scale-plus.png" width="9" height="9" alt="Увеличить масштаб"/>
</h:commandLink>
</div>
<div class="scale2">
<h:commandLink actionListener="#{mapManager.scaleAllRootes}">
<h:outputText value="Оптим. масштаб"/>
</h:commandLink>
</div>

<a class="zoomer1" href="#" id="zoomer" onclick="zoomcheck(false);">Увеличить</a>


</div>

<div id="map">

</div>

<div id="search">
<h1>Поиск маршрута</h1>
<div  class="searcherror error">	Ошибки введённых данных.</div>

<div id="searchform_wrapper">
<table class="search">
<tr>
<td class="numberinfo">
Номер автомобиля:
</td>
<td class="dateinfo">
Интервал времени:
</td>
<td class="searchsubmit">&nbsp;</td>
</tr>
<tr>
<td>
	<input type=""Text value="#{routeManager.carNumber}" validator="#{routeManager.validateCarNumberSyntax}" styleClass="search number"
title="Номер автомобиля" alt="Номер автомобиля"/>
</td>
<td>


<%--<!-- <input type="text" name="timestart" class="search time" onkeypress="return checktime(this, event)" onfocus="this.value=''" value="00:00" /> -->--%>
<t:inputText styleClass="search time" onkeypress="return checktime(this, event)" onfocus="this.value=''" value="#{routeManager.startDatePeriodTime}">
	<f:convertDateTime type="time" pattern="HH:mm" timeZone="Europe/Moscow"/>
</t:inputText>

<%--<!--<input id="date_start" class="search date" value="19.08.2006" type="text">&ndash;-->--%>
<t:inputText id="date_start" styleClass="search date"  value="#{routeManager.startDatePeriodDate}">
	<f:convertDateTime type="date" pattern="dd.MM.yyyy" timeZone="Europe/Moscow"/>
</t:inputText>
&ndash;
<%--<!--<input type="text" name="timeend" class="search time" onkeypress="return checktime(this, event)" onfocus="this.value=''" value="23:59" />-->--%>
<h:inputText styleClass="search time" onkeypress="return checktime(this, event)"  onfocus="this.value=''" value="#{routeManager.endDatePeriodTime}">
	<f:convertDateTime type="time" pattern="HH:mm" timeZone="Europe/Moscow"/>
</h:inputText>
<%--<!--<input id="date_end" class="search date"  type="text">-->--%>
<h:inputText id="date_end" styleClass="search date"  value="#{routeManager.endDatePeriodDate}">
	<f:convertDateTime type="date" pattern="dd.MM.yyyy" timeZone="Europe/Moscow"/>
</h:inputText>

</td>
<td>
<h:commandButton value="Найти" styleClass="submit" title="Найти" actionListener="#{routeManager.search}"/>
</td>
</tr>
</table>

</div>
</div>


<div id="routes">
<h2>
<h:commandLink value="'Мастер контрольный'"
   styleClass ="viewroutes" style="position:absolute; right:25px" action="#{routeManager.viewController}"/>
</h2>

<a href="#" id="pitStopsRangesButton" class="pitStopsRangesButton" onclick="javascript:togglePitStopsRanges();">
<h:outputText  value="На карте"/>
</a>
<%/*
<h:outputFormat escape="false" value="<input id='pitStopsRangesString'  name='pitStopsRangesString' type='hidden' value='{0}'/>">
	<f:param name="data" value="#{guiManager.pitStopsRangesStirng}"/>
</h:outputFormat>
*/%>
<input id="pitStopsRangesString"  name="pitStopsRangesString" type="hidden" value=""/>
<div id="pitStopsRanges" class="pitStopsRanges" style="display: none">
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
</div>
<h:inputText id="valueRadiusBlue" value="#{mapManager.blueRadius}" style="display: none"/><h:inputText id="valueTimeBlue" value="#{mapManager.blueTime}" style="display: none"/>
<h:inputText id="valueRadiusGreen" value="#{mapManager.greenRadius}" style="display: none"/><h:inputText id="valueTimeGreen" value="#{mapManager.greenTime}" style="display: none"/>
<h:inputText id="valueRadiusRed" value="#{mapManager.redRadius}" style="display: none"/><h:inputText id="valueTimeRed" value="#{mapManager.redTime}" style="display: none"/>
<script type="text/javascript" language="JavaScript"> <!--
<%/*
<t:dataList value="#{guiManager.pitStopsRanges}" var="range" layout="simple">
	<h:outputFormat value="addRangeRecord({0, number, #######.##},{1, number, #######.##});">
		<f:param name="number" value="#{range.from}"/>
		<f:param name="fromDate" value="#{range.to}"/>
	</h:outputFormat>
</t:dataList>
*/%>
-->
</script>


<div class="maplist">
<t:dataTable id="routesOnMap"  value="#{mapManager.routesOnMap}" binding="#{mapManager.routesTable}" var="route" styleClass="routes" rowClasses="odd,even" rowIndexVar="currentRowIndex">
<h:column>
<h:panelGrid columns="1">

<t:div>
<h:outputLink value="javascript:route2('masterFormData:routesOnMap:#{currentRowIndex}:route', '#{route.id}');">

	<h:outputFormat value="{0} ({1} - {2})">
		<f:param name="number" value="#{route.carNumber}"/>
		<f:param name="fromDate" value="#{route.startCheckPointLeaveDate}"/>
		<f:param name="toDate" value="#{route.finalCheckPointArrivalDate}"/>
	</h:outputFormat>
	
	<h:graphicImage value="#{mapManager.relativePathToLegendPic}" width="35" height="3" styleClass="legend" />
</h:outputLink>
</t:div>

<t:div id="route" styleClass="routedetails">

<%/*Code for processing selected routes*/%>
<h:outputText escape="false"  value="<input name='routeIdInnerHolder'  type='hidden' value='#{route.id}'/>"/>

<h:commandLink value="Убрать с карты" styleClass ="delroute" actionListener="#{mapManager.removeRouteFromMap}"/>

<h:commandLink value="Показать оригинальный маршрут" styleClass ="delroute" actionListener="#{mapManager.showOriginalRoute}" rendered="#{route.originalRouteId != null}"/>

<h:commandLink value="Показать связанный маршрут" styleClass ="delroute" actionListener="#{mapManager.showLinkedRoute}" rendered="#{route.linkedToRouteId != null}"/>

<t:htmlTag value="dl">

<%/*Номер ТТН*/%>
<t:htmlTag value="dt">
<h:outputText value="Номер ТТН:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputText value="#{route.ttnNumber}"/>
</t:htmlTag>




<t:htmlTag value="dt">
<h:outputText value="Стартовая точка: #{route.startCheckPoint.name}"/>
</t:htmlTag>

<t:htmlTag value="dd">
	<h:outputFormat value="Убытие: {0}">
		<f:param name="date" value="#{route.startCheckPointLeaveDate}"/>
	</h:outputFormat>
</t:htmlTag>



</t:div>
</h:panelGrid>
</h:column>
</t:dataTable>
</div>



<h2>
<h:outputFormat value="Маршруты ({0} - {1})">
	<f:param name="fromDate" value="#{routeManager.startDatePeriod}"/>
	<f:param name="toDate" value="#{routeManager.endDatePeriod}"/>
</h:outputFormat>
</h2>

<%/*Дипазоны маршрутов*/%>


<script type="text/javascript" language="JavaScript"> 

var ranges = <h:outputText value="'#{guiManager.distanceRangesString}'"/>;
ranges = ranges.replace(/;/g,':');
var cookie = 'distanceRanges='+ranges+'; expires=Thu, 2 Aug 2010 20:47:11 UTC; path=/secure/map-page.jsf';
document.cookie = cookie;
 </script>


<a href="#" id="distanceRangesButton" class="distanceRangesButton" onclick="javascript:toggleDistanceRanges();">
<h:outputText  value="Диапазоны расстояний (#{guiManager.distanceRangesString})"/>
</a>
<h:selectOneMenu style="display: block" id="selectOrderMenu" value="#{routeManager.selectedSortField}" title="Задать поле для сортировки маршрутов">
     <t:selectItems value="#{routeManager.sortingList}" var="sorting" itemLabel="#{sorting.name}" itemValue="#{sorting.type}"/>
</h:selectOneMenu>
<br/>

<div class="sortDiv">
<h:selectBooleanCheckbox id="orderCheckBox" title="Выполнить сортировку в обратном порядке" value="#{routeManager.backOrder}"/>
<h:outputLabel id="orderLabel" for="orderCheckBox" value="Обратный порядок"/>
<h:commandButton actionListener="#{routeManager.sortFoundRoutes}" value="Сортировать" styleClass="sortButton" type="submit" title="Сортировать" />
</div>


<h:outputText escape="false"  value="<input id='distanceRangesString'  name='distanceRangesString' type='hidden' value='#{guiManager.distanceRangesString}'/>"/>

<input id="distanceRangesString"  name="distanceRangesString" type="hidden" value=""/>
<div id="distanceRanges" class="distanceRanges" style="display: none">
<h3 align="center">Задача диапазонов (км)</h3>
<div id="distanceRangesList">



</div> <%--<!-- <div id="distanceRangesList"> -->--%>
<div class="distanceRangesControlHolder">
<a href="#" onclick="javascript:addRangeRecord(0,0)" class="distanceRangesControlAdd">Добавить</a>
<a href="#" class="distanceRangesControlApply" onclick="applyRangesRecords(); toggleDistanceRanges();" >Принять</a>
</div>
</div>


<script type="text/javascript" language="JavaScript"> 

<t:dataList value="#{guiManager.distanceRanges}" var="range" layout="simple">
	<h:outputFormat value="addRangeRecord({0, number, #######.##},{1, number, #######.##});">
		<f:param name="number" value="#{range.from}"/>
		<f:param name="fromDate" value="#{range.to}"/>
	</h:outputFormat>
</t:dataList>


</script>        






<div class="routeslist">

<t:dataTable id="masterRoutesData" binding="#{routeManager.routesTable}" value="#{routeManager.foundRoutes}" var="route" styleClass="routes" rowClasses="odd,even" rowIndexVar="currentRowIndex">

<h:column>
<h:panelGrid columns="1">

<h:outputLink id="expandLink" value="javascript:route2('masterFormData:masterRoutesData:#{currentRowIndex}:route', '#{route.id}');">
<h:outputFormat value="{4} {0} ({1} - {2}) {3, number, ####.##} км">
	<f:param name="number" value="#{route.carNumber}"/>
	<f:param name="fromDate" value="#{route.startCheckPointLeaveDate}"/>
	<f:param name="toDate" value="#{route.finalCheckPointArrivalDate}"/>
	<f:param name="distance" value="#{route.distance / 1000}"/>
        <f:param name="id" value="№ #{currentRowIndex+1}: "/>
</h:outputFormat>

</h:outputLink>

<t:div id="route" styleClass="routedetails" >
<h:outputText escape="false"  value="<input name='routeIdInnerHolder'  type='hidden' value='#{route.id}'/>"/>


<h:commandLink value="Показать на карте" styleClass ="showroute" actionListener="#{routeManager.addRouteToMap}"/>

<t:htmlTag value="dl">

<%/*Номер ТТН*/%>
<t:htmlTag value="dt">
<h:outputText value="Номер ТТН:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputText value="#{route.ttnNumber}"/>
</t:htmlTag>


<%/*Номер СУДС*/%>
<t:htmlTag value="dt">
<h:outputText value="Номер СУДС:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputText value="#{route.sudsNumber}"/>
</t:htmlTag>



<t:htmlTag value="dt">
<h:outputText value="Стартовая точка: #{route.startCheckPoint.name}"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputFormat value="Убытие: {0}">
		<f:param name="date" value="#{route.startCheckPointLeaveDate}"/>
	</h:outputFormat>
</t:htmlTag>

<%/*ПП по накладной*/%>
<t:htmlTag value="dt" rendered="#{route.declaredLoadingTerminalExists}">
<h:outputText value="Пункт погрузки по накладной:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputText value="#{route.loadingTerminalName}"/>
</t:htmlTag>

<%/*возможные пункты погрузки*/%>
<t:htmlTag value="dt" >
<h:outputText value="Возможные пункты погрузки:"/>
</t:htmlTag>

<t:dataList value="#{route.possibleLoadingTerminals}" var="plt" layout="simple">
	<t:htmlTag value="dd">
		<t:htmlTag value="b"><h:outputText value="#{plt.checkPoint.name}"/></t:htmlTag>

		<h:outputFormat value=" (Период: {0} - {1}, Время: {3}) Расстояние доставки {2, number, ####.##} км">
			<f:param name="ad" value="#{plt.arrivalDate}"/>
			<f:param name="ld" value="#{plt.leaveDate}"/>
			<f:param name="deldist" value="#{plt.deliveryDistance / 1000}"/>
			<f:param name="duration" value="#{plt.timePeriodStayString}"/>
		</h:outputFormat>
	</t:htmlTag>
	<t:htmlTag value="dd">
		<h:outputFormat value="От старта: {0, number, ####.##} км (Длительность: {1})">
			<f:param name="dist" value="#{plt.fromStartDistance/1000}"/>
			<f:param name="time" value="#{plt.timePeriodFromStartString}"/>
		</h:outputFormat>
	</t:htmlTag>
	<t:htmlTag value="dd">
		<h:outputFormat value="До финиша: {0, number, ####.##} км (Длительность: {1})">
			<f:param name="dist" value="#{plt.toFinishDistance/1000}"/>
			<f:param name="time" value="#{plt.timePeriodToFinishString}"/>
		</h:outputFormat>
	</t:htmlTag>
</t:dataList>



<%/*пункты погрузки*/%>
<t:htmlTag value="dt" rendered="#{route.loadingTerminalExact}">
<h:outputText value="Пункт погрузки: #{route.loadingTerminalCheckPoint.name}"/>
</t:htmlTag>


<%/*финальная точка*/%>
<t:htmlTag value="dt">
<h:outputText value="Финальная точка: #{route.finalCheckPoint.name}"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputFormat value="Прибытие: {0}">
		<f:param name="date" value="#{route.finalCheckPointArrivalDate}"/>
	</h:outputFormat>
</t:htmlTag>

<%/*расстояние пути*/%>
<t:htmlTag value="dt">
<h:outputText value="Расстояние пути:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputFormat value="{0, number, ###.##} км">
		<f:param name="distance" value="#{route.distance / 1000}"/>
	</h:outputFormat>
</t:htmlTag>

<%/*уровень топлива*/%>
<t:htmlTag value="dt">
<h:outputText value="Уровни топлива:"/>
</t:htmlTag>
<t:htmlTag value="dd">
	<h:outputFormat value="Старт: {0, number, ###.##} Финиш: {1, number, ###.##}">
		<f:param name="distance" value="#{route.startFuelLevel}"/>
		<f:param name="distance" value="#{route.finishFuelLevel}"/>
	</h:outputFormat>
</t:htmlTag>

<t:htmlTag value="dt"><f:verbatim>Сырье</f:verbatim></t:htmlTag>
<t:htmlTag value="dd">
	<h:outputFormat escape="false" value="Отгружено: {0, number, ###.##} м<sup>3</sup>">
		<f:param name="date" value="#{route.acceptedVolume}"/>
	</h:outputFormat>
</t:htmlTag>

<t:htmlTag value="dd">
	<h:outputFormat escape="false" value="По данным поставщика: {0, number, ###.##} м<sup>3</sup>">
		<f:param name="date" value="#{route.declaredVolume}"/>
	</h:outputFormat>
</t:htmlTag>

<t:htmlTag value="dt"><f:verbatim>Спецификация по данным приёмки 'Фотоскан'</f:verbatim></t:htmlTag>

<t:dataList value="#{route.packs}" var="pack" layout="simple">
	<t:htmlTag value="dd">

	<h:outputFormat escape="false" value="{0}: {1, number, ###.##} м<sup>3</sup>">
		<f:param name="nomName" value="#{pack.nomenclatureName}"/>
		<f:param name="volume" value="#{pack.volume}"/>
	</h:outputFormat>

	</t:htmlTag>
</t:dataList>

</t:htmlTag>

</t:div>

</h:panelGrid>

</h:column>


</t:dataTable>


</div>

</div> <%-- body--%>

</body>
</html>
