<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://myfaces.apache.org/tomahawk" prefix="t"%>


<html>
    <head>
        <title>GPS Мониторинг - Mondi</title>
        <link rel="stylesheet" type="text/css" href="./css/printpage.css" />
        <script type="text/javascript" src="./js/javascript.js"></script>
    </head>
<body onload="printpage();">


<div class="header"> <!-- шапка -->
<div class="logo"><img src="./img/mondi-logo.png" height="60" width="155" alt="Mondi Business Paper" /></div>
<div class="title">
<img src="./img/gpsmonitoring-logo-print.png" width="195" height="24" alt="GPS мониторинг" id="gpsmonitorlogo" />
</div>
</div>



<div id="body">

<f:view>


<div id="map">
		<img src="<h:outputText escape="false" value="#{visit.mapPath}?w=800&h=600&print=true"/>" alt="карта" width="800" height="600" class="map"/>        
        <!-- здесь ширина и высота карты могут не совпадать с реальными размерами
             (которые лучше сделать побольше, т.к. у принтера разрешение не меньше 300 dpi,
             тогда как на экране обычно 96 или 120 dpi).
             Главное - не нарушать пропорции, т.е. отношение сторон. -->
</div>

<div id="routes">

<div class="header"> <!-- шапка -->
<div class="logo"><img src="./img/mondi-logo.png" height="60" width="155" alt="Mondi Business Paper" /></div>
<div class="title">
<img src="./img/gpsmonitoring-logo-print.png" width="195" height="24" alt="GPS мониторинг" id="gpsmonitorlogo" />
</div>
</div>


<%---------------------------------------------------------%>
<h1>Отметки на карте</h1> 


<%
int i=1;
%>
<t:div styleClass="maplist blue">
<t:dataList value="#{mapManager.temporaryRouteMapMarks}" var="timemark" layout="orderedList">



<t:htmlTag value="h2">
<h:outputFormat value="{0}">
	<f:param name="number" value="#{timemark.carNumber}"/>
</h:outputFormat>
</t:htmlTag>

<t:dataList value="#{timemark.data}" var="data" layout="simple">


<%/*Date*/%>
<t:htmlTag value="dt">
	<h:outputFormat value="Дата: {0}; Топливо: {1}; Скорость: {2}">
		<f:param name="date" value="#{data.date}"/>
		<f:param name="fuelLeval" value="#{data.fuelLevel}"/>
		<f:param name="speed" value="#{data.speed}"/>
	</h:outputFormat>
</t:htmlTag>

</t:dataList>

</t:dataList>
</t:div>
<%---------------------------------------------------------%>


<h1>Маршруты на карте</h1> 

<t:dataList  value="#{mapManager.routesOnMap}" binding="#{mapManager.routesTable}"  var="route" layout="simple">
<t:div styleClass="maplist blue">

<%---------------------------------------------------------%>
<t:htmlTag value="table" styleClass="routes">
<t:htmlTag value="tr">

<t:htmlTag value="td">

<t:htmlTag value="h2">
<h:outputFormat value="{0} ({1} - {2})">
	<f:param name="number" value="#{route.carNumber}"/>
	<f:param name="fromDate" value="#{route.startCheckPointLeaveDate}"/>
	<f:param name="toDate" value="#{route.finalCheckPointArrivalDate}"/>
</h:outputFormat>
</t:htmlTag>

<t:htmlTag value="dl">

<t:htmlTag value="dd">
<h:graphicImage value="#{mapManager.relativePathToLegendPic}" width="150" height="10" styleClass="legend" />
</t:htmlTag>

</t:htmlTag>


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

</t:htmlTag> <% /*td*/ %>

<t:htmlTag value="td"> <% /*td*/ %>
<t:htmlTag value="dl">
<%/*возможные пункты погрузки*/%>
<t:htmlTag value="dt" rendered="#{not route.loadingTerminalExact}">
<h:outputText value="Возможные пункты погрузки:"/>
</t:htmlTag>

<t:dataList value="#{route.possibleLoadingTerminals}" var="plt" layout="simple">
	<t:htmlTag value="dd">
		<h:outputFormat value="Пункт погрузки: {0} ({1} - {2})">
			<f:param name="cp" value="#{plt.checkPoint.name}"/>
			<f:param name="ad" value="#{plt.arrivalDate}"/>
			<f:param name="ld" value="#{plt.leaveDate}"/>
		</h:outputFormat>
	</t:htmlTag>
</t:dataList>




<%/*пункты погрузки*/%>
<t:htmlTag value="dt" rendered="#{route.loadingTerminalExact}">
<h:outputText value="Пункт погрузки: #{route.loadingTerminalCheckPoint.name}"/>
</t:htmlTag>
<t:htmlTag value="dd" rendered="#{route.loadingTerminalExact}">
	<h:outputFormat value="Прибытие: {0}">
		<f:param name="date" value="#{route.loadingTerminalCheckPointArrivalDate}"/>
	</h:outputFormat>
</t:htmlTag>
<t:htmlTag value="dd" rendered="#{route.loadingTerminalExact}">
	<h:outputFormat value="Убытие: {0}">
		<f:param name="date" value="#{route.loadingTerminalCheckPointLeaveDate}"/>
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


</t:htmlTag> <% /*dl*/ %>
</t:htmlTag> <% /*td*/ %>


</t:htmlTag> <% /*tr*/ %>
</t:htmlTag>  <% /*table*/ %>
<%---------------------------------------------------------%>


</t:div>
</t:dataList>




</div>

</f:view>

</div> <!-- body -->

</body>
</html>
