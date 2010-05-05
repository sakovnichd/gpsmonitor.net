/**
 * Copyright (c) 2006-2010, Magnetosoft, LLC
 * All rights reserved.
 *
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 * file: MapPageController.java
 */
package ru.magnetosoft.gpsmonitorgm.controllers;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import javax.servlet.http.HttpServletRequest;
import ru.magnetosoft.bigarch.wsclient.bl.documentservice.AttributeTextType;
import ru.magnetosoft.bigarch.wsclient.bl.documentservice.AttributeType;
import ru.magnetosoft.bigarch.wsclient.bl.documentservice.DocumentType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.HashMapEntryType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.HashMapType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.MapDataType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchRequestType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchResponseType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchResultResponseType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchResultsRequestType;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchResultsResponseType;
import ru.magnetosoft.gpsmonitorgm.ba.BAUtils;
import ru.magnetosoft.magnet.authent.client.ISessionTicket;

/**
 * Created on 07.04.2010, 11:39:45
 * 
 * @author sakovnichd
 */
public class MapPageController
{

	public MapPageController()
	{
	}

	public static void prepare(HttpServletRequest request) throws Exception
	{
		Date d=new Date();
		SimpleDateFormat sdfd=new SimpleDateFormat("dd.MM.yyyy");
		SimpleDateFormat sdft=new SimpleDateFormat("HH:mm");
		request.setAttribute("dateStart",request.getParameter("dateStart")!=null?request.getParameter("dateStart"):sdfd.
			format(d));
		request.setAttribute("timeStart",request.getParameter("timeStart")!=null?request.getParameter("timeStart"):sdft.
			format(d));
		request.setAttribute("dateEnd",request.getParameter("dateEnd")!=null?request.getParameter("dateEnd"):sdfd.
			format(d));
		request.setAttribute("timeEnd",request.getParameter("timeEnd")!=null?request.getParameter("timeEnd"):sdft.
			format(d));
		request.setAttribute("truckId",request.getParameter("truckId"));
		request.setAttribute("trackFileId",request.getParameter("trackFileId"));
		if(request.getParameter("mapType")!=null&&"gm".equals(request.getParameter("mapType")))
		{
			request.setAttribute("mapType","gm");
		}else
		{
			request.setAttribute("mapType","ym");
		}
		BAUtils.initConnections();
		ISessionTicket supervisorTicket=BAUtils.authenticationInvoker.login("BA_CLIENT","BA_CLIENT","ORGANIZATION","magnet","big-archive",60);
		SearchRequestType rqst=new SearchRequestType();
		rqst.setRequestData(new MapDataType());
		rqst.getRequestData().setMap(new HashMapType());
		HashMapEntryType hm=new HashMapEntryType();
		hm.setKey("template_id");
		hm.setValue("e0627dfd26d64763af960f74370df036");
		rqst.getRequestData().getMap().getContent().add(hm);
		SearchResponseType srt=BAUtils.searchInvoker.searchSync(supervisorTicket.getId(),rqst);
		SearchResultsRequestType req=new SearchResultsRequestType();
		//System.out.println("Search "+extValueCode+"="+extValue+"; context name="+srt.getContextName()+"");
		req.setContextName(srt.getContextName());
		req.setExpectedQuantity(1000);
		req.setFromPosition(0);
		SearchResultsResponseType fspt=BAUtils.searchInvoker.getSearchResults(supervisorTicket.
			getId(),req);
		Map<String,String> cars=new TreeMap<String,String>();
		if(fspt.getTotalCount()>0)//документ уже есть
		{
			for(SearchResultResponseType rt:fspt.getResults())
			{
				String id=rt.getId();
				if("".equals(id.trim()))
					continue;
				DocumentType dt=BAUtils.documentInvoker.getDocument(supervisorTicket.getId(),id);
				String reg_number=null;
				String gps_id=null;
				for(AttributeType at:dt.getAttributes().getAttributes())
				{
					if("reg-number".equals(at.getCode()))
						reg_number=((AttributeTextType)at).getValue();
					else if("gps-id".equals(at.getCode()))
						gps_id=((AttributeTextType)at).getValue();
				}
				if(gps_id!=null&&!gps_id.equals(""))
					cars.put(reg_number,gps_id);
			}
		}
		request.setAttribute("cars",cars);
	}
}
