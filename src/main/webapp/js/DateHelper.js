function getActiveObj(e) {
  if("activeElement" in document){ return document.activeElement }
  else { return e ? e.explicitOriginalTarget : null }
}

function isChildOf(ae, obj) {
  if(ae == obj){ return true }
  if(!ae)return false;
  if(ae.parentNode){
    var p = ae.parentNode;
    while(p){
      if(p == obj){ return true }
      p = p.parentNode;
    }
    return false;
  } else { return false }
}

var _cal;
function calendarInit(button, fieldId, lang){
  if(!lang){ lang = "ru" }
  if(!_cal){
    _cal = c = new Calendar();
    c.setIncludeWeek(true).setFormat("dd.MM.yyyy");
    if(lang=='ru'){
      c.setMonthNames(["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"])
      .setShortWeekDayNames(["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб" ])
      .setClearButtonLabel("Очистить").setLang(lang);
    } else {
      c.setMonthNames(["January","February","March","April","May","June","July","August","September","October","November","December"])
      .setShortWeekDayNames(["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ])
      .setClearButtonLabel("Clear").setLang(lang);
    }
    c.create();
  } else {
    _cal.hide()
  }
  var field = $("#"+fieldId);
  if(field.length==0){ return c }
  var val = field.val();
  c.onchange = null;
  if(val == null || val == undefined || val == "") {
    val = new Date();
  } else {
    var y = val.substr(6), m = val.substr(3,2), d = val.substr(0,2);

    //val = new Date(Date.parse(val));
    if(/^\d\d\d\d$/.test(y) && /^\d\d$/.test(d) && /^\d\d$/.test(m)){
      if(y<'100'){ y = (y<'70')? '20'+y : '19'+y }
      val = new Date(Date.parse(y + '/' + m + '/' + d));
    } else { val = new Date() }
    c.setSelectedDate(val);
  }
  if(field[0].onchange){
    ch = function(){ field[0].onchange() }
  } else {
    ch = function(){}
  }
  c.toggle(field[0]);

  c.onchange = function() {
    field.val(c.formatDate());
    document.body.onclick=null;
    ch();
  }

  document.body.onclick = function(event){
    if(!event){ event = window.event }
    var ao = target = event.target || event.srcElement;
    //$("#debug").text("ActiveObj:" + tag + ", isChildOf:" + isChildOf(ao, c._calDiv));
    if(!isChildOf(target, c._calDiv) && (target != button)){//(getActiveObj(event)!= field[0]))
      c.hide();
      document.body.onclick=null;
    }
    return false
  }
  return c
}