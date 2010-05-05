/**
 * Copyright (c) 2006-2007, Magnetosoft, LLC
 * All rights reserved.
 * 
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 */
package ru.magnetosoft.gpsmonitorgm;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

/**
 * 
 * Класс, описывающий маршруты в системе.
 * 
 * Маршрутом является отрезок пути от одного считывания до другого считывания данных с GPS
 * устройства.
 * 

 */
public class Route
{

	private double acceptedVolume;
	private String carNumber=null;
	private double declaredVolume;
	private double distance;
	//private CheckPoint finalCheckPoint=null;
	private Date finalCheckPointArrivalDate;
	private Date finalCheckPointLeaveDate;
	private double finishFuelLevel;
	private String id;
	/**
	 * Для маршрута, для которого было найдено соответствие - ссылка на связанный маршрут.
	 */
	private String linkedToRouteId;
	//private CheckPoint loadingTerminalCheckPoint=null;
	private Date loadingTerminalCheckPointArrivalDate;
	private Date loadingTerminalCheckPointLeaveDate;
	private String loadingTerminalId;
	private String loadingTerminalName;
	/**
	 * Для маршрута, который был подставлен, как настоящий - ссылка на оригинальный маршрут.
	 */
	private String originalRouteId;
	private List<PitStop> pitStops=null;
//	private List<PossibleLoadingTerminal> possibleLoadingTerminals=null;
	private List<RoutePoint> routePoints=null;
//	private RouteStorageData routeStorageData;
//	private CheckPoint startCheckPoint=null;
	private Date startCheckPointArrivalDate;
	private Date startCheckPointLeaveDate;
	private double startFuelLevel;
	private String sudsNumber;
	private String supplierId=null;
	private String ttnNumber;
	private String woodDeliveryReportDBF;
	private boolean woodDeliveryReportFullFiled;

	/**
	 * @return the acceptedVolume
	 */
	public double getAcceptedVolume()
	{
		return this.acceptedVolume;
	}

	public void setRoutePoints(List<RoutePoint> routePoints)
	{
		this.routePoints=routePoints;
	}
 
	public List<RoutePoint> getRoutePoints()
	{
		return routePoints;
	}

	/**
	 * @return the carNumber
	 */
	public String getCarNumber()
	{
		return this.carNumber;
	}

	/**
	 * @return the declaredVolume
	 */
	public double getDeclaredVolume()
	{
		return this.declaredVolume;
	}

	/**
	 * @return the distance
	 */
	public double getDistance()
	{
		return this.distance;
	}

	/**
	 * @return the finalCheckPointArrivalDate
	 */
	public Date getFinalCheckPointArrivalDate()
	{
		return this.finalCheckPointArrivalDate;
	}

	/**
	 * @return the finalCheckPointLeaveDate
	 */
	public Date getFinalCheckPointLeaveDate()
	{
		return this.finalCheckPointLeaveDate;
	}

	/**
	 * @return the finishFuelLevel
	 */
	public double getFinishFuelLevel()
	{
		return this.finishFuelLevel;
	}

	/**
	 * @return the id
	 */
	public String getId()
	{
		return this.id;
	}

	/**
	 * @return
	 */
	public String getLinkedToRouteId()
	{
		return this.linkedToRouteId;
	}

	/**
	 * @return the loadingTerminalCheckPointArrivalDate
	 */
	public Date getLoadingTerminalCheckPointArrivalDate()
	{
		return this.loadingTerminalCheckPointArrivalDate;
	}

	/**
	 * @return the loadingTerminalCheckPointLeaveDate
	 */
	public Date getLoadingTerminalCheckPointLeaveDate()
	{
		return this.loadingTerminalCheckPointLeaveDate;
	}

	/**
	 * Getter for loadingTerminalId
	 * 
	 * @return the loadingTerminalId
	 */
	public String getLoadingTerminalId()
	{
		return this.loadingTerminalId;
	}

	/**
	 * Getter for loadingTerminalName
	 * 
	 * @return the loadingTerminalName
	 */
	public String getLoadingTerminalName()
	{
		return this.loadingTerminalName;
	}

	/**
	 * @hibernate.property
	 * @return
	 */
	public String getOriginalRouteId()
	{
		return this.originalRouteId;
	}

	/**
	 * @return the pitStops
	 * 
	 */
	public List<PitStop> getPitStops()
	{
		return this.pitStops;
	}

	/**
	 * @return the startCheckPointArrivalDate
	 */
	public Date getStartCheckPointArrivalDate()
	{
		return this.startCheckPointArrivalDate;
	}

	/**
	 * @return the startCheckPointLeaveDate
	 */
	public Date getStartCheckPointLeaveDate()
	{
		return this.startCheckPointLeaveDate;
	}

	/**
	 * @return the startFuelLevel
	 */
	public double getStartFuelLevel()
	{
		return this.startFuelLevel;
	}

	public String getSudsNumber()
	{
		return this.sudsNumber;
	}

	/**
	 * @return
	 */
	public String getSupplierId()
	{
		return this.supplierId;
	}

	/**
	 * @return the ttnNumber
	 */
	public String getTtnNumber()
	{
		return this.ttnNumber;
	}

	/**
	 * Getter for woodDeliveryReportDBF
	 * 
	 * @return the woodDeliveryReportDBF
	 */
	public String getWoodDeliveryReportDBF()
	{
		return this.woodDeliveryReportDBF;
	}

	public boolean isDeclaredLoadingTerminalExists()
	{
		return (getLoadingTerminalName()!=null);
	}

	/**
	 * @return
	 */
	public boolean isWoodDeliveryReportFullFiled()
	{
		return this.woodDeliveryReportFullFiled;
	}

	/**
	 * @param acceptedVolume
	 *            the acceptedVolume to set
	 */
	public void setAcceptedVolume(double acceptedVolume)
	{
		this.acceptedVolume=acceptedVolume;
	}

	/**
	 * @param carNumber
	 *            the carNumber to set
	 */
	public void setCarNumber(String carNumber)
	{
		this.carNumber=carNumber;
	}

	/**
	 * @param declaredVolume
	 *            the declaredVolume to set
	 */
	public void setDeclaredVolume(double declaredVolume)
	{
		this.declaredVolume=declaredVolume;
	}

	/**
	 * @param distance
	 *            the distance to set
	 */
	public void setDistance(double distance)
	{
		this.distance=distance;
	}

	/**
	 * @param finalCheckPointArrivalDate
	 *            the finalCheckPointArrivalDate to set
	 */
	public void setFinalCheckPointArrivalDate(Date finalCheckPointArrivalDate)
	{
		this.finalCheckPointArrivalDate=finalCheckPointArrivalDate;
	}

	/**
	 * @param finalCheckPointLeaveDate
	 *            the finalCheckPointLeaveDate to set
	 */
	public void setFinalCheckPointLeaveDate(Date finalCheckPointLeaveDate)
	{
		this.finalCheckPointLeaveDate=finalCheckPointLeaveDate;
	}

	/**
	 * @param finishFuelLevel
	 *            the finishFuelLevel to set
	 */
	public void setFinishFuelLevel(double finishFuelLevel)
	{
		this.finishFuelLevel=finishFuelLevel;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id)
	{
		this.id=id;
	}

	public void setLinkedToRouteId(String linkedRouteId)
	{
		this.linkedToRouteId=linkedRouteId;
	}

	/**
	 * @param loadingTerminalCheckPointArrivalDate
	 *            the loadingTerminalCheckPointArrivalDate to set
	 */
	public void setLoadingTerminalCheckPointArrivalDate(Date loadingTerminalCheckPointArrivalDate)
	{
		this.loadingTerminalCheckPointArrivalDate=loadingTerminalCheckPointArrivalDate;
	}

	/**
	 * @param loadingTerminalCheckPointLeaveDate
	 *            the loadingTerminalCheckPointLeaveDate to set
	 */
	public void setLoadingTerminalCheckPointLeaveDate(Date loadingTerminalCheckPointLeaveDate)
	{
		this.loadingTerminalCheckPointLeaveDate=loadingTerminalCheckPointLeaveDate;
	}

	/**
	 * Setter for property loadingTerminalId
	 * 
	 * @param loadingTerminalId
	 *            the loadingTerminalId to set
	 */
	public void setLoadingTerminalId(String loadingTerminalId)
	{
		this.loadingTerminalId=loadingTerminalId;
	}

	/**
	 * Setter for property loadingTerminalName
	 * 
	 * @param loadingTerminalName
	 *            the loadingTerminalName to set
	 */
	public void setLoadingTerminalName(String loadingTerminalName)
	{
		this.loadingTerminalName=loadingTerminalName;
	}

	public void setOriginalRouteId(String originalRouteId)
	{
		this.originalRouteId=originalRouteId;
	}

	/**
	 * @param pitStops
	 *            the pitStops to set
	 */
	public void setPitStops(List<PitStop> pitStops)
	{
		this.pitStops=pitStops;
	}

	/**
	 * @param startCheckPointArrivalDate
	 *            the startCheckPointArrivalDate to set
	 */
	public void setStartCheckPointArrivalDate(Date startCheckPointArrivalDate)
	{
		this.startCheckPointArrivalDate=startCheckPointArrivalDate;
	}

	/**
	 * @param startCheckPointLeaveDate
	 *            the startCheckPointLeaveDate to set
	 */
	public void setStartCheckPointLeaveDate(Date startCheckPointLeaveDate)
	{
		this.startCheckPointLeaveDate=startCheckPointLeaveDate;
	}

	/**
	 * @param startFuelLevel
	 *            the startFuelLevel to set
	 */
	public void setStartFuelLevel(double startFuelLevel)
	{
		this.startFuelLevel=startFuelLevel;
	}

	public void setSudsNumber(String sudsNumber)
	{
		this.sudsNumber=sudsNumber;
	}

	public void setSupplierId(String supplierId)
	{
		this.supplierId=supplierId;
	}

	/**
	 * @param ttnNumber
	 *            the ttnNumber to set
	 */
	public void setTtnNumber(String ttnNumber)
	{
		this.ttnNumber=ttnNumber;
	}

	/**
	 * Setter for property woodDeliveryReportDBF
	 * 
	 * @param woodDeliveryReportDBF
	 *            the woodDeliveryReportDBF to set
	 */
	public void setWoodDeliveryReportDBF(String woodDeliveryReportDBF)
	{
		this.woodDeliveryReportDBF=woodDeliveryReportDBF;
	}

	public void setWoodDeliveryReportFullFiled(boolean routeFullFiled)
	{
		this.woodDeliveryReportFullFiled=routeFullFiled;
	}

	public String toString()
	{
		return this.getClass().getCanonicalName()+"#"+getId();
	}
}
