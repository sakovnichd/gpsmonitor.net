function Calendar(date){
	if (arguments.length == 0) {
		this._currentDate = new Date();
		this._selectedDate = null;
	}
	else {
		this._currentDate = new Date(date);
		this._selectedDate = new Date(date);
	}
  Calendar.NUM_DAYS = [0,31,59,90,120,151,181,212,243,273,304,334];
  Calendar.LEAP_NUM_DAYS = [0,31,60,91,121,152,182,213,244,274,305,335];
  Calendar.MSPD = 24 * 60 * 60 * 1000;
	this._showing = false;
	this._includeWeek = false;
	this._hideOnSelect = true;
	this._alwaysVisible = false;
	this._dateSlot = new Array(42);
	this._weekSlot = new Array(6);
	this._firstDayOfWeek = 1;
	this._minimalDaysInFirstWeek = 4;
	this._monthNames = [
		"January",		"February",		"March",	"April",
		"May",			"June",			"July",		"August",
		"September",	"October",		"November",	"December"
	];
	this._shortMonthNames = [
		"jan", "feb", "mar", "apr", "may", "jun",
		"jul", "aug", "sep", "oct", "nov", "dec"
	];
	this._weekDayNames = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
	this._shortWeekDayNames = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб" ];
	this._defaultFormat = "yyyy-MM-dd";
	this._format = this._defaultFormat;
  this._calDiv = null;
	this._clearButtonLabel = "";
	this._lang = "ru";
}

Calendar.prototype.create = function() {
	var div, table, tbody, tr, td, dp = this;
	this._calDiv = document.createElement("div");
	this._calDiv.className = "calendar dn";
	div = document.createElement("div");
	div.className = "calendarHeader";
	this._calDiv.appendChild(div);
	table = document.createElement("table");
	table.cellSpacing = 0;
	div.appendChild(table);
	tbody = document.createElement("tbody");
	table.appendChild(tbody);
	tr = document.createElement("tr");
	tbody.appendChild(tr);
	td = document.createElement("td");
	this._previousMonth = document.createElement("button");
	this._previousMonth.className = "prevMonthButton"
	this._previousMonth.appendChild(document.createTextNode("<"));
	td.appendChild(this._previousMonth);
	tr.appendChild(td);
	td = document.createElement("td");
	td.className = "monthContainer";
	tr.appendChild(td);
	this._monthSelect = document.createElement("select");
    for(var i = 0; i < this._monthNames.length; i++){
        var opt = document.createElement("option");
        opt.innerHTML = this._monthNames[i];
        opt.value = i;
        if(i == this._currentDate.getMonth()){ opt.selected = "selected" }
        this._monthSelect.appendChild(opt);
    }
	td.appendChild(this._monthSelect);
	td = document.createElement("td");
	td.className = "yearContainer";
	tr.appendChild(td);
	this._yearSelect = document.createElement("select");
	for(var i=1990; i < 2026; ++i){
		var opt = document.createElement("option");
		opt.innerHTML = opt.value = i;
		if(i == this._currentDate.getFullYear()){ $(opt).removeAttr("selected") }
		this._yearSelect.appendChild(opt);
	}
	td.appendChild(this._yearSelect);
	td = document.createElement("td");
	this._nextMonth = document.createElement("button");
	this._nextMonth.appendChild(document.createTextNode(">"));
	this._nextMonth.className = "nextMonthButton";
	td.appendChild(this._nextMonth);
	tr.appendChild(td);
	div = document.createElement("div");
	div.className = "calendarBody";
	this._calDiv.appendChild(div);
	this._table = div;
	var text;
	table = document.createElement("table");
	table.className = "calendarGrid";
	table.cellPadding = "3";
	table.cellSpacing	= "0";
  div.appendChild(table);
	var thead = document.createElement("thead");
	table.appendChild(thead);
	tr = document.createElement("tr");
	thead.appendChild(tr);
	if(this._includeWeek){
		td = document.createElement("th");
		text = document.createTextNode("Н");
		td.appendChild(text);
		td.className = "weekNumberHead";
		tr.appendChild(td);
	}
	for(i=0; i < 7; ++i){
		td = document.createElement("th");
		text = document.createTextNode(this._shortWeekDayNames[(i+this._firstDayOfWeek)%7]);
		td.appendChild(text);
		td.className = "weekDayHead";
		tr.appendChild(td);
	}
	tbody = document.createElement("tbody");
	table.appendChild(tbody);
	for(week=0; week<6; ++week){
		tr = document.createElement("tr");
		tbody.appendChild(tr);
		if(this._includeWeek){
			td = document.createElement("td"); // MAYBE_TH
			td.className = "weekNumber";
			text = document.createTextNode(String.fromCharCode(160));
			td.appendChild(text);
			tr.appendChild(td);
			var tmp = {tag: "WEEK", value: -1, data: text};
			this._weekSlot[week] = tmp;
		}
		for(day=0; day<7; ++day){
			td = document.createElement("td");
			text = document.createTextNode(String.fromCharCode(160));
			td.appendChild(text);
			tr.appendChild(td);
			var tmp = {tag: "DATE", value: -1, data: text}
			this._dateSlot[(week*7)+day] = tmp;
		}
	}
	div = document.createElement("div");
	div.className = "calendarFooter";
	this._calDiv.appendChild(div);
	table = document.createElement("table");
	table.className = "calendarSubmitTable";
	table.cellSpacing = 0;
	div.appendChild(table);
	tbody = document.createElement("tbody");
	table.appendChild(tbody);
	tr = document.createElement("tr");
	tbody.appendChild(tr);
	td = document.createElement("td");
	this._todayButton = document.createElement("button");
	var today = new Date(), buttonText = today.getDate() + " " + this._monthNames[today.getMonth()] + ", " + today.getFullYear();
	this._todayButton.appendChild(document.createTextNode(buttonText));
	td.appendChild(this._todayButton);
	tr.appendChild(td);
	td = document.createElement("td");
	this._clearButton = document.createElement("button");
	this._clearButton.appendChild(document.createTextNode(this._clearButtonLabel));
	td.appendChild(this._clearButton);
	tr.appendChild(td);
	this._update()._updateHeader();
	this._previousMonth.hideFocus = true;
	this._nextMonth.hideFocus = true;
	this._todayButton.hideFocus = true;
	this._previousMonth.onclick = function(){ dp.prevMonth() }
	this._nextMonth.onclick = function(){ dp.nextMonth() }
	this._todayButton.onclick = function(){ dp.setSelectedDate(new Date()); dp.hide() }
	this._clearButton.onclick = function(){ dp.clearSelectedDate(); dp.hide() }
  this._calDiv.onselectstart = function(){ return false }
	this._table.onclick = function (e) {
		if(e == null){ e = document.parentWindow.event }
		var el = e.target || e.srcElement;
		while(el.nodeType != 1){ el = el.parentNode }
		while(el != null && el.tagName && el.tagName.toLowerCase() != "td"){ el = el.parentNode }
		if(el == null || el.tagName == null || el.tagName.toLowerCase() != "td"){ return }
		var d = new Date(dp._currentDate), n = Number(el.firstChild.data);
		if(isNaN(n) || n <= 0 || n == null){ return }
		if(el.className == "weekNumber"){ return }
		d.setDate(n);
		dp.setSelectedDate(d);
		if(!dp._alwaysVisible && dp._hideOnSelect){ dp.hide() }
	};
	this._calDiv.onkeydown = function(e){
		if(e == null){ e = document.parentWindow.event }
		var kc = e.keyCode || e.charCode;
		if(kc == 13){
			var d = new Date(dp._currentDate).valueOf();
			dp.setSelectedDate(d);
			if(!dp._alwaysVisible && dp._hideOnSelect){ dp.hide() }
			return false
		}
		if(kc < 37 || kc > 40){ return true }
		var d = new Date(dp._currentDate).valueOf();
		if(kc == 37){ d -= Calendar.MSPD } // left
		if (kc == 39){ d += Calendar.MSPD } // right
		if (kc == 38){ d -= 7 * Calendar.MSPD } // up
		if (kc == 40){ d += 7 * Calendar.MSPD } // down
		dp.setCurrentDate(new Date(d));
		return false;
	}
	this._calDiv.onmousewheel = function(e){
		if(e == null){ e = document.parentWindow.event }
		var n = - e.wheelDelta / 120, d = new Date(dp._currentDate), m = d.getMonth() + n;
		d.setMonth(m);
		dp.setCurrentDate(d);
		return false
	}
	this._monthSelect.onchange = function(e){
		if(e == null){ e = document.parentWindow.event }
		e = getEventObject(e);
		dp.setMonth(e.value);
	}
	this._monthSelect.onclick = function(e){
		if(e == null){ e = document.parentWindow.event }
		e = getEventObject(e);
		e.cancelBubble = true
	}
	this._yearSelect.onchange = function(e){
		if(e == null){ e = document.parentWindow.event }
		e = getEventObject(e);
		dp.setYear(e.value);
	}
	document.body.appendChild(this._calDiv);
	return this._calDiv
}
Calendar.prototype._update = function(){
	var date = this._currentDate, today = toISODate(new Date()), selected = "";
	if(this._selectedDate != null){ selected = toISODate(this._selectedDate) }
	var current = toISODate(this._currentDate), d1 = new Date(date.getFullYear(), date.getMonth(), 1),
	    d2 = new Date(date.getFullYear(), date.getMonth()+1, 1), monthLength = Math.round((d2 - d1) / Calendar.MSPD);
	var firstIndex = (d1.getDay() - this._firstDayOfWeek) % 7, index = 0, id1;
  if(firstIndex < 0){ firstIndex += 7 }
	while(index < firstIndex){
		this._dateSlot[index].value = -1;
		this._dateSlot[index].data.data = String.fromCharCode(160);
		this._dateSlot[index].data.parentNode.className = "";
		index++;
	}
  for(i = 1; i <= monthLength; i++, index++){
		id1 = toISODate(d1);
    this._dateSlot[index].value = i;
		this._dateSlot[index].data.data = i;
		this._dateSlot[index].data.parentNode.className = "";
		if(id1 == today){ this._dateSlot[index].data.parentNode.className = "today" }
		if(id1 == current){ this._dateSlot[index].data.parentNode.className += " current" }
		if(id1 == selected){ this._dateSlot[index].data.parentNode.className += " selected" }
		if(index % 7 > 4){ this._dateSlot[index].data.parentNode.className += " weekend" }
		d1 = new Date(d1.getFullYear(), d1.getMonth(), d1.getDate()+1);
	}
	var lastDateIndex = index;
  while(index < 42){
		this._dateSlot[index].value = -1;
		this._dateSlot[index].data.data = String.fromCharCode(160);
		this._dateSlot[index].data.parentNode.className = "";
		++index;
	}
	if(this._includeWeek){
		d1 = new Date(date.getFullYear(), date.getMonth(), 1);
		for(i=0; i < 6; ++i){
			if(i == 5 && lastDateIndex < 36){
				this._weekSlot[i].data.data = ""; /*String.fromCharCode(160);*/
				$(this._weekSlot[i].data.parentNode.parentNode).addClass("tinyCalendarWeek");
			} else {
				week = weekNumber(this, d1);
				this._weekSlot[i].data.data = week;
				$(this._weekSlot[i].data.parentNode.parentNode).removeClass("tinyCalendarWeek");
			}
			d1 = new Date(d1.getFullYear(), d1.getMonth(), d1.getDate()+7);
		}
	}
	return this
}
Calendar.prototype.show = function(to){
	if(!this._showing){
		$(this._calDiv).removeClass("dn");
    var p = getPoint(to), w = document.body.offsetWidth, cw = this._calDiv.offsetWidth, tp = (p.y + to.offsetHeight + 1) + "px"; lp = (p.x + cw < w)? p.x + "px" : p.x + to.offsetWidth - cw + "px";
    $(this._calDiv).css({top: tp, left: lp});
		this._showing = true;
	  if( jQuery.browser.msie ){
	    var dh = this._calDiv.offsetHeight, body = $("body")[0];
	    if(!body){ return }
	    var underDiv = this._calDiv.cloneNode(false);
	    $(underDiv).addClass("calendarUnderDiv").css({width:cw, height:dh}).html("<iframe width='100%' height='100%' frameborder='0'></iframe>");
	    body.appendChild(underDiv);
	    this._underDiv = underDiv;
	  }
    if(this._calDiv.focus){ this._calDiv.focus() }
    var todayLabel = (this._lang == "ru")? "Сегодня" : "Today";
    $(".calendarFooter button:first", $(this._calDiv)).text(todayLabel);
	}
	return this
}
Calendar.prototype.hide = function(){
	if(this._showing) {
		$(this._calDiv).addClass("dn");
		this._showing = false;
		if( jQuery.browser.msie ){
		  if( this._underDiv ){ this._underDiv.removeNode(true) }
		}
	}
	return this
}
Calendar.prototype.toggle = function(element){
	if(this._showing){ this.hide() } else { this.show(element) }
	return this
}
Calendar.prototype.onchange = function(){};
Calendar.prototype.setCurrentDate = function(d){
	if(d == null){ return }
	if(typeof d == "string" || typeof d == "number"){ d = new Date(d) }
	if(this._currentDate.getDate() != d.getDate() || this._currentDate.getMonth() != d.getMonth() || this._currentDate.getFullYear() != d.getFullYear()){
		this._currentDate = new Date(d);
		this._updateHeader()._update();
	}
	return this
}
Calendar.prototype.setSelectedDate = function(d){
	this._selectedDate = new Date(d);
	this.setCurrentDate(this._selectedDate);
	if(typeof this.onchange == "function"){ this.onchange() }
	return this
}
Calendar.prototype.clearSelectedDate = function(){
	this._selectedDate = null;
	if(typeof this.onchange == "function"){ this.onchange() }
	return this
}
Calendar.prototype.getElement = function(){ return this._calDiv }
Calendar.prototype.setIncludeWeek = function(v){
	if(this._calDiv == null){ this._includeWeek = v }
	return this
}
Calendar.prototype.setLang = function(v){
  this._lang = v;
  return this
}
Calendar.prototype.setClearButtonLabel = function(v){
  this._clearButtonLabel = v;
  return this
}
Calendar.prototype.getSelectedDate = function(){
	return (this._selectedDate == null)? null : new Date(this._selectedDate);
}
Calendar.prototype.initialize = function(mn, smn, wd, swd, frmt, fd, inc, min, l){
  this.setMonthNames(mn).setShortMonthNames(smn).setWeekDayNames(wd).setShortWeekDayNames(swd)
  .setFormat(frmt).setFirstDayOfWeek(fd).setIncludeWeek(inc).setMinimalDaysInFirstWeek(min).setClearButtonLabel(l).create();
}
Calendar.prototype._updateHeader = function(){
	var op = this._monthSelect.options, m = this._currentDate.getMonth(), y = this._currentDate.getFullYear(), i;
	for(i=0; i < op.length; ++i) {
		$(op[i]).removeAttr("selected");
		if(op[i].value == m){ op[i].selected = "selected" }
	}
	op = this._yearSelect.options;
	for(i=0; i < op.length; ++i) {
		$(op[i]).removeAttr("selected");
		if(op[i].value == y){ op[i].selected = "selected" }
	}
	return this
}
Calendar.prototype.setYear = function(y){
	var d = new Date(this._currentDate);
	d.setFullYear(y);
	this.setCurrentDate(d);
	return this
}
Calendar.prototype.setMonth = function(m){
	var d = new Date(this._currentDate);
	d.setMonth(m);
	this.setCurrentDate(d);
	return this
}
Calendar.prototype.nextMonth = function(){ this.setMonth(this._currentDate.getMonth()+1); return this }
Calendar.prototype.prevMonth = function(){ this.setMonth(this._currentDate.getMonth()-1); return this }
Calendar.prototype.setFirstDayOfWeek = function(d){ this._firstDayOfWeek = d; return this }
Calendar.prototype.getFirstDayOfWeek = function(){ return this._firstDayOfWeek }
Calendar.prototype.setMinimalDaysInFirstWeek = function(n){ this._minimalDaysInFirstWeek = n; return this }
Calendar.prototype.getMinimalDaysInFirstWeek = function(){ return this._minimalDaysInFirstWeek }
Calendar.prototype.setMonthNames = function(a){ this._monthNames = a; return this }
Calendar.prototype.setShortMonthNames = function(a){ this._shortMonthNames = a; return this }
Calendar.prototype.setWeekDayNames = function(a){ this._weekDayNames = a; return this }
Calendar.prototype.setShortWeekDayNames = function(a){ this._shortWeekDayNames = a; return this }
Calendar.prototype.getFormat = function(){ return this._format }
Calendar.prototype.setFormat = function(f){ this._format = f; return this }
Calendar.prototype.formatDate = function() {
	if(this._selectedDate == null){ return "" }
  var bits = new Array(), date = this._selectedDate;
  bits['d'] = date.getDate();
  bits['dd'] = pad(date.getDate(),2);
  bits['ddd'] = this._shortWeekDayNames[date.getDay()];
  bits['dddd'] = this._weekDayNames[date.getDay()];
  bits['M'] = date.getMonth()+1;
  bits['MM'] = pad(date.getMonth()+1,2);
  bits['MMM'] = this._shortMonthNames[date.getMonth()];
  bits['MMMM'] = this._monthNames[date.getMonth()];
  var yearStr = "" + date.getFullYear();
  yearStr = (yearStr.length == 2) ? '19' + yearStr: yearStr;
  bits['yyyy'] = yearStr;
  bits['yy'] = bits['yyyy'].toString().substr(2,2);
  bits['s'] = date.getSeconds();
  bits['ss'] = pad(date.getSeconds(),2);
  bits['m'] = date.getMinutes();
  bits['mm'] = pad(date.getMinutes(),2);
  bits['H'] = date.getHours();
  bits['HH'] = pad(date.getHours(),2);
  var frm = new String(this._format);
  var keys = ['d','dd','ddd','dddd','M','MM','MMM','MMMM','yyyy','yy', 's', 'ss', 'm', 'mm', 'H', 'HH'];
  for(var i = 0; i < keys.length; i++){
     frm = eval("frm.replace(/\\b" + keys[i] + "\\b/,\"" + bits[keys[i]] + "\");");
  }
  return frm;
}
function isLeapYear(y){ return ((y%4 == 0) && ((y%100 != 0) || (y%400 == 0))) }
function yearLength(y){ return (isLeapYear(y))? 366 : 365 }
function dayOfYear(date) {
	var a = Calendar.NUM_DAYS, month = date.getMonth();
	if(isLeapYear(date.getFullYear())){ a = Calendar.LEAP_NUM_DAYS }
	return a[month] + date.getDate();
}
function weekNumber(c, date) {
	var dow = date.getDay(), doy = dayOfYear(date), year = date.getFullYear();
	var relDow = (dow + 7 - c.getFirstDayOfWeek()) % 7; // 0..6
	var relDowJan1 = (dow - doy + 701 - c.getFirstDayOfWeek()) % 7; // 0..6
	var week = Math.floor((doy - 1 + relDowJan1) / 7); // 0..53
	if((7 - relDowJan1) >= c.getMinimalDaysInFirstWeek()){ ++week }
	if(doy > 359){
		var lastDoy = yearLength(year), lastRelDow = (relDow + lastDoy - doy) % 7;
		if(lastRelDow < 0){ lastRelDow += 7 }
		if(((6 - lastRelDow) >= c.getMinimalDaysInFirstWeek()) && ((doy + 7 - relDow) > lastDoy)){ week = 1 }
	} else if(week == 0){
		var prevDoy = doy + yearLength(year - 1);
		week = weekOfPeriod(c, prevDoy, dow);
	}
	return week;
}
function weekOfPeriod(c, dayOfPeriod, dayOfWeek) {
	var periodStartDayOfWeek = (dayOfWeek - c.getFirstDayOfWeek() - dayOfPeriod + 1) % 7;
	if(periodStartDayOfWeek < 0){ periodStartDayOfWeek += 7 }
	var weekNo = Math.floor((dayOfPeriod + periodStartDayOfWeek - 1) / 7);
	if((7 - periodStartDayOfWeek) >= c.getMinimalDaysInFirstWeek()){ ++weekNo }
	return weekNo;
}
function getEventObject(e){ return (e.srcElement || e.target) }
function Point(iX, iY){
  this.x = iX;
  this.y = iY;
}
function getPoint(aTag){
  var o = aTag, p = new Point(0,0);
  do{
    p.x += o.offsetLeft;
    p.y += o.offsetTop;
    o = o.offsetParent;
  } while(o.tagName != "BODY" && o.tagName != "HTML");
  return p
}
function toISODate(d) {
	var s = d.getFullYear(), m = d.getMonth() + 1, day = d.getDate();
	if(m < 10){ m = "0" + m	}
	if(day < 10){ day = "0" + day }
	return String(s) + String(m) + String(day)
}
function pad(number,X) {   // utility function to pad a number to a given width
	X = (!X ? 2 : X);
	number = ""+number;
	while(number.length < X){ number = "0" + number }
	return number
}