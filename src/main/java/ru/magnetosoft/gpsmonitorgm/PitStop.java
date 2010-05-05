/**
 * Copyright (c) 2006-2010, Magnetosoft, LLC
 * All rights reserved.
 *
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 * file: PitStop.java
 */
package ru.magnetosoft.gpsmonitorgm;

import java.util.Date;

/**
 * Created on 26.03.2010, 17:43:56
 * 
 * @author sakovnichd
 */
public class PitStop
{

	private Date arrivalDate;
	private double finalFuelLevel=0;
	private String id;
	private double latitude;
	private Date leaveDate;
	private double longitude;
	private double startFuelLevel=0;

	/** Creates a new instance of PitStop */
	public PitStop()
	{
	}

	/**
	 * @return the arrivalDate
	 */
	public Date getArrivalDate()
	{
		return this.arrivalDate;
	}

	/**
	 * @return the finalFuelLevel
	 */
	public double getFinalFuelLevel()
	{
		return this.finalFuelLevel;
	}

	/**
	 */
	public String getId()
	{
		return id;
	}

	/**
	 * @return the latitude
	 */
	public double getLatitude()
	{
		return this.latitude;
	}

	/**
	 * @return the leaveDate
	 */
	public Date getLeaveDate()
	{
		return this.leaveDate;
	}

	/**
	 * @return the longitude
	 */
	public double getLongitude()
	{
		return this.longitude;
	}

	/**
	 * @return the startFuelLevel
	 */
	public double getStartFuelLevel()
	{
		return this.startFuelLevel;
	}

	/**
	 * @param arrivalDate
	 *            the arrivalDate to set
	 */
	public void setArrivalDate(Date arrivalDate)
	{
		this.arrivalDate=arrivalDate;
	}

	/**
	 * @param finalFuelLevel
	 *            the finalFuelLevel to set
	 */
	public void setFinalFuelLevel(double finalFuelLevel)
	{
		this.finalFuelLevel=finalFuelLevel;
	}

	public void setId(String id)
	{
		this.id=id;
	}

	/**
	 * @param latitude
	 *            the latitude to set
	 */
	public void setLatitude(double latitude)
	{
		this.latitude=latitude;
	}

	/**
	 * @param leaveDate
	 *            the leaveDate to set
	 */
	public void setLeaveDate(Date leaveDate)
	{
		this.leaveDate=leaveDate;
	}

	/**
	 * @param longitude
	 *            the longitude to set
	 */
	public void setLongitude(double longitude)
	{
		this.longitude=longitude;
	}

	/**
	 * @param startFuelLevel
	 *            the startFuelLevel to set
	 */
	public void setStartFuelLevel(double startFuelLevel)
	{
		this.startFuelLevel=startFuelLevel;
	}

	public String toString()
	{
		return this.getClass().getCanonicalName()+"#"+getId();
	}
}
