function initialize() {
	$("#dateStart,#dateEnd").mousedown(function(evt){
		_cal = calendarInit(evt.target, evt.target.id,'ru');
	})

	$.mask.definitions['~']='[+-]';
	$('#dateStart, #dateEnd').mask('99.99.9999');
	$('#timeStart, #timeEnd').mask('99:99');
	$('[name="mt"]').change(changeMapType);
	$(window).resize(function(){
		if(isPrintVersion)
			return;
		$('#map,.routeslist').height($(window).height()-$("#map").offset().top-3);
		isPrintVersion=false;
		$("#printBtn").removeClass("work").addClass("print").text("Версия для печати");
		$("#pitStopsTable").hide();
	});
	$(".selectionColor").click(changeRouteColor);
	$(window).resize();
	initializeMap();
	if(setRoute)
	searchRoute();
}

function searchRoute(){
	jQuery.ajax({
		url: './TrackDispatcher',
		type: 'POST',
		dataType: 'json',
		data:{
			startDate:$("#dateStart").val()+" "+$("#timeStart").val(),
			endDate:$("#dateEnd").val()+" "+$("#timeEnd").val(),
			truckId:$("#truckId").val(),
			trackFileId:$("#trackFileId").val()
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('Error loading document');
		},
		success: function(res,textStatus){
			//alert(res.length);
			jQuery("#routeLength").text((res.length/1000).toFixed(2));
			jQuery("#startFuel").text(res.startFuel);
			jQuery("#endFuel").text(res.endFuel);
			$("#dateStart").val(res.startDate.substring(0,10));
			$("#timeStart").val(res.startDate.substring(11));
			$("#dateEnd").val(res.endDate.substring(0,10));
			$("#timeEnd").val(res.endDate.substring(11));
			displayRoute(res);
			buildPSTable(res.pitStops);
		}
	});
}
var isPrintVersion=null;
/**
 * Печать карты
 */
function printMap()	{
	//				var w=window.open("about:blank", "printWindow");
	//				var doc=w.document;
	//				doc.write("<html><head><title></title>"+
	//					//"<link rel=\"stylesheet\" type=\"text/css\" href=\"http://api-maps.yandex.ru/1.1.8/_YMaps.css\" />"+
	//					"<link rel=\"stylesheet\" type=\"text/css\" href=\"./css/print.css\" />"
	//					+"</head><body></body></html>");
	//alert($('body').children().length);
	//$("body",doc).append($('body').children().clone());
	//$("body",doc).html($('body').html());
	if(isPrintVersion){
		isPrintVersion=false;
		$(window).resize();
	}	else{
		isPrintVersion=true;
		$("#map,.routeslist").height(500);
		$("#printBtn").removeClass("print").addClass("work").text("Версия для работы");
		$("#pitStopsTable").show();
	}

//				doc.close();
}

function changeMapType(e)
{
	$("#mapType").val($(e.currentTarget).val());
	if(mapItems)
		window.location.href="./index.jsp?"+$("form").serialize()+"&setRoute=true&"+(new Date().getTime());
	else
		window.location.href="./index.jsp?"+$("form").serialize()+"&setRoute=false&"+(new Date().getTime());;
//alert($("form").serialize());
}

function buildPSTable(pitStops)
{
	var b=$("#pitStopsTable tbody");
	b.children().remove();
	for(i=0;i<pitStops.length;i++){
		var ps=pitStops[i];
		var tr=$("<tr/>");
		tr.append($("<td/>").text(i+1));
		tr.append($("<td/>").text(ps.arrivalTime));
		tr.append($("<td align='right'/>").text(ps.arrivalFuel));
		tr.append($("<td/>").text(ps.leaveTime));
		tr.append($("<td align='right'/>").text(ps.leaveFuel));
		tr.append($("<td align='right'/>").text(Math.floor(ps.stopTime/1000/3600)+":"+Math.floor(ps.stopTime%(1000*3600)/60000)));
		tr.append($("<td align='right'/>").text(ps.arrivalFuel-ps.leaveFuel));
		tr.appendTo(b);
	}
}



