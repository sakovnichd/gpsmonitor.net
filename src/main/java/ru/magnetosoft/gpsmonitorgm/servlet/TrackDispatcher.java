/**
 * Copyright (c) 2006-2009, Magnetosoft, LLC
 * All rights reserved.
 *
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 * file: TrackDispatcher.java
 *//*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ru.magnetosoft.gpsmonitorgm.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Properties;
import java.util.TimeZone;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ru.magnetosoft.bigarch.wsclient.bl.attachmentservice.AttachmentType;
import ru.magnetosoft.gpsmonitorgm.CoordinationDataAnalyst;
import ru.magnetosoft.gpsmonitorgm.NMEAParser;
import ru.magnetosoft.gpsmonitorgm.PitStop;
import ru.magnetosoft.gpsmonitorgm.Route;
import ru.magnetosoft.gpsmonitorgm.RoutePoint;
import ru.magnetosoft.gpsmonitorgm.ba.BAUtils;
import ru.magnetosoft.magnet.authent.client.ISessionTicket;

/**
 * Created on 25.03.2010, 10:45:47
 *
 * @author sakovnichd
 */
public class TrackDispatcher extends HttpServlet
{

	/**
	 * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	private static Connection connection;

	protected void processRequest(HttpServletRequest request,HttpServletResponse response)
		throws ServletException,IOException
	{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out=response.getWriter();
		try
		{
			String trackFileId=request.getParameter("trackFileId");
			if(trackFileId!=null&&trackFileId.trim().equals(""))
				trackFileId=null;
			String truckId=request.getParameter("truckId");
			String startDate=request.getParameter("startDate");
			String endDate=request.getParameter("endDate");
			SimpleDateFormat sdf=new SimpleDateFormat("dd.MM.yyyy HH:mm");
			//SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm");

			char c=' ';
			double length=0.0;
			List<RoutePoint> l;
			if(trackFileId==null)
			{

				Date start=sdf.parse(startDate);
				Date end=sdf.parse(endDate);
				l=getDBTrackPoints(truckId,start,end);
			}else
			{
				l=getFMTrackPoints(trackFileId);
				if(l.size()>0)
				{
					startDate=sdf.format(l.get(0).getDate());
					endDate=sdf.format(l.get(l.size()-1).getDate());
				}
			}
			RoutePoint p0=null;
			//while(rs.next())
			out.write("{");
			out.write("\"startDate\":\""+startDate+"\",");
			out.write("\"endDate\":\""+endDate+"\",");
			out.write("\"points\":[");
			List<RoutePoint> lx=new ArrayList();
			for(RoutePoint p:l)
			{
				double v=0;
				if(p0!=null)
				{
					double s=CoordinationDataAnalyst.getMeterDistance(p0.getLatitude(),p0.getLongitude(),p.
						getLatitude(),p.getLongitude());
					//скорость km/h
					v=s*3600/(p.getDate().getTime()-p0.getDate().getTime());
					if(v<120)
						length+=CoordinationDataAnalyst.getMeterDistance(p0.getLatitude(),p0.getLongitude(),p.
							getLatitude(),p.getLongitude());
					else
						lx.add(p);
				}
				if(v<120)
				{
					out.write(c+"["+p.getLatitude()+","+p.getLongitude()+"]");
					c=',';
					p0=p;
				}
			}
			for(RoutePoint p:lx)
				l.remove(p);
			out.write("]");
			out.write(",\"length\":"+length);
			out.write(",\"startFuel\":"+(l.size()>0?l.get(0).getFuelLevel():0));
			out.write(",\"endFuel\":"+(l.size()>0?l.get(l.size()-1).getFuelLevel():0));
			Route r=new Route();
			r.setRoutePoints(l);
			List<PitStop> lps=CoordinationDataAnalyst.resolvePitStops(r,15,50);
			c=' ';
			out.write(",\"pitStops\":[");
			for(PitStop ps:lps)
			{
				out.write(c+"{\"latitude\":"+ps.getLatitude());
				out.write(",\"longitude\":"+ps.getLongitude());
				out.write(",\"arrivalTime\":\""+sdf.format(ps.getArrivalDate())+"\"");
				out.write(",\"arrivalFuel\":"+ps.getStartFuelLevel());
				out.write(",\"leaveTime\":\""+sdf.format(ps.getLeaveDate())+"\"");
				out.write(",\"leaveFuel\":"+ps.getFinalFuelLevel());
				out.write(",\"stopTime\":"+(ps.getLeaveDate().getTime()-ps.getArrivalDate().getTime()));
				out.write("}");
				c=',';
			}
			out.write("]}");
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}finally
		{
			out.close();
		}
	}

	/**
	 * Получение точек из БД
	 * @param truckId
	 * @param start
	 * @param end
	 * @return
	 * @throws Exception
	 */
	private List<RoutePoint> getDBTrackPoints(String truckId,Date start,Date end) throws Exception
	{
		PreparedStatement stmt=getConnection().prepareStatement("select row_date,ncoord,ecoord,fuel"
			+" FROM coordinates"+" where truck_id=? and crd_date>=? and crd_date<=? order by crd_date");
		stmt.setString(1,truckId);
		Calendar c=new GregorianCalendar();
		c.setTime(start);
		c.add(Calendar.HOUR,-4);
		stmt.setTimestamp(2,new java.sql.Timestamp(c.getTime().getTime()));
		c.setTime(end);
		c.add(Calendar.HOUR,-4);
		stmt.setTimestamp(3,new java.sql.Timestamp(c.getTime().getTime()));
		ResultSet rs=stmt.executeQuery();
		List<RoutePoint> res=new ArrayList<RoutePoint>();
		while(rs.next())
		{
			RoutePoint p=new RoutePoint(new Date(rs.getTimestamp(1).getTime()),ddm2ddd(rs.getDouble(2)),ddm2ddd(rs.
				getDouble(3)),rs.getDouble(4));
			res.add(p);
		}
		return res;
	}

	/**
	 * Получение точек из файла в FileManager
	 * @param fileId
	 * @return
	 * @throws Exception
	 */
	private List<RoutePoint> getFMTrackPoints(String fileId) throws Exception
	{
		List<RoutePoint> res=new ArrayList<RoutePoint>();
		if(fileId==null)
			return res;
		ISessionTicket supervisorTicket=BAUtils.authenticationInvoker.login("BA_CLIENT","BA_CLIENT","ORGANIZATION","magnet","big-archive",60);
		AttachmentType at=BAUtils.attachmentInvoker.getAttachment(supervisorTicket.getId(),null,fileId,true);
		InputStream is=at.getData().getInputStream();
		NMEAParser parser=new NMEAParser(is);
		NMEAParser.NMEAPoint p;
		while((p=parser.nextPoint())!=null)
			res.add(new RoutePoint(p.getDate(),p.getLatitude(),p.getLongitude(),0));
		return res;
	}

	/**
	 * Перевод gps координат из формата градусы, минуты, доли минут в
	 * формат градусы, доли градусов. То есть из формата в котором они (координаты)
	 * поступают в потоке в более удобов	аримый формат
	 *
	 * @param ddm координата в формате градусы, минуты, доли минут
	 * @return double
	 */
	public static double ddm2ddd(double ddm)
	{
		int point=Double.toString(ddm).indexOf(".");
		String dd="";
		Double result=0.0;
		if(point!=-1)
		{
			int e=Double.toString(ddm).length();
			String mm=Double.toString(ddm).substring(point-2,e);
			double dbl_mm=new Double(mm);
			dbl_mm=dbl_mm/60.0f*100.0f;
			int i=Double.toString(dbl_mm).indexOf(".");
			dd=Double.toString(ddm).substring(0,point-2)+Double.toString(dbl_mm);
			result=(new Double(dd))/Math.pow(10,i);
		}
		return result;
	}
////	final private double degreePerRadian=180/Math.PI;
//	final private double wgs84_earthEquatorialRadiusMeters=6378137.0;

	private Connection getConnection() throws SQLException
	{
		if(connection!=null)
			return connection;
		Driver d=new org.postgresql.Driver();
		Properties props=new Properties();
		props.put("user","apoleshko");
		props.put("password","ujmik,ol.");
		//Connection conn=instance.connect("jdbc:mysql://localhost/harvester_db",props);
		connection=d.connect("jdbc:postgresql://192.168.150.43:5432/GPSOnlineData",props);
		return connection;
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**
	 * Handles the HTTP <code>GET</code> method.
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request,HttpServletResponse response)
		throws ServletException,IOException
	{
		processRequest(request,response);
	}

	/**
	 * Handles the HTTP <code>POST</code> method.
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request,HttpServletResponse response)
		throws ServletException,IOException
	{
		processRequest(request,response);
	}

	/**
	 * Returns a short description of the servlet.
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo()
	{
		return "Short description";
	}// </editor-fold>
}
// package ru.magnetosoft.gpsmonitor.listener;
//
///**
// * Класс для операций с GPS координатами
// *
// * @author apoleshko
// *         Date: 08.08.2008
// *         Time: 14:10:15
// */
//public class GPS {
//    /**
//     * Перевод углового растояния в метрическую систему. Для широты и долготы Сыктывкара.
//     *
//     * @param ddd угловое расстояние
//     * @return
//     */
//    public static double Ddd2meters(double ddd) {
//        Double latitude = 111.134861, ddd_m;
//        ddd_m = ddd * latitude * 1000;
//        return ddd_m;
//    }
//
//    /**
//     * Вычисляет растояние между двумя точками
//     *
//     * @param p1_lat Широта первой точки
//     * @param p1_lng Долгота первой точки
//     * @param p2_lat Широта второй точки
//     * @param p2_lng Долгота второй точки
//     * @return Угловое растояние
//     */
//    public static double Calc_range(double p1_lat, double p1_lng, double p2_lat, double p2_lng) {
//        double range;
//        range = Math.sqrt(Math.pow((p2_lat - p1_lat), 2) + Math.pow((p2_lng - p1_lng), 2));
//        return range;
//    }

