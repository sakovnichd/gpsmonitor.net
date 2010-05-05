/**
 * Copyright (c) 2006-2010, Magnetosoft, LLC
 * All rights reserved.
 *
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 * file: NMEAParser.java
 */

package ru.magnetosoft.gpsmonitorgm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import ru.magnetosoft.gpsmonitorgm.servlet.TrackDispatcher;
import sun.java2d.pipe.SpanShapeRenderer.Simple;

/**
 * Created on 22.04.2010, 10:46:01
 * 
 * @author sakovnichd
 */
public class NMEAParser {
BufferedReader br;
    public NMEAParser(InputStream is)
    {
			if(is==null)
				return;
			br=new BufferedReader(new InputStreamReader(is));
    }
		public class NMEAPoint
		{
			private double longitude;
			private double latitude;
			private Date date;

		public NMEAPoint(double longitude,double latitude,Date date)
		{
			this.longitude=longitude;
			this.latitude=latitude;
			this.date=date;
		}

		public Date getDate()
		{
			return date;
		}

		public double getLatitude()
		{
			return latitude;
		}

		public double getLongitude()
		{
			return longitude;
		}

		}
		/**
			*           1 	        2 	3 	      4 	5 	        6 	7 	   8 	     9 	     10 	11 	12
			* $GPRMC, 	Hhmmss.ss, 	A, 	1111.11, 	A, 	yyyyy.yy, 	a, 	x.x, 	x.x, 	ddmmyy, 	x.x, 	A 	*hh 	<CR><LF>
			* 1. Время фиксации местоположения UTC
			* 2. Состояние: А = действительный, V = предупреждение навигационного приёмника
			* 3,4. Географическая широта местоположения, Север/Юг
			* 5,6. Географическая долгота местоположения, Запад/Восток (E/W)
			* 7. Скорость над поверхностью (SOG) в узлах
			* 8. Истинное направление курса в градусах
			* 9. Дата: dd/mm/yy
			* 10. Магнитное склонение в градусах
			* 11. Запад/Восток (E/W)
			* 12. Контрольная сумма строки (обязательно)
		 * @return
		 * @throws IOException
		 */
		public NMEAPoint nextPoint() throws Exception
		{
			if(br==null)return null;
			String record;
			do{
				record=br.readLine();
			}while(record!=null&&!record.trim().equals("")&&!record.startsWith("$GPRMC"));

			if(record==null||record.trim().equals(""))
				return null;
			String[] r=record.split(",");
			SimpleDateFormat sdf=new SimpleDateFormat("ddMMyy HHmmss");
		return new NMEAPoint(TrackDispatcher.ddm2ddd(Double.parseDouble(r[5])),
			TrackDispatcher.ddm2ddd(Double.parseDouble(r[3])),sdf.parse(r[9]+" "+r[1].substring(0,6)));
		}

}
