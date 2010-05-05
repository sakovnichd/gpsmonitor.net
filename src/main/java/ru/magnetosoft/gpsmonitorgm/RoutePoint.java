package ru.magnetosoft.gpsmonitorgm;

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
import java.util.Date;

/**
 *Точка маршрута
 *
 *Хранит в себе все основные показатели автомобиля, включая:
 *время замера параметров
 *координаты в данный момент времени
 *уровень топлива в данный момент времени
 *мгновенную скорость в данный момент времени
 */
public class RoutePoint
{
	private Date date;
	private double latitude;
	private double longitude;
	private double fuelLevel;
	private double speed=-1;

	public RoutePoint(Date date,double latitude,double longitude,double fuelLevel)
	{
		this.date=date;
		this.latitude=latitude;
		this.longitude=longitude;
		this.fuelLevel=fuelLevel;
	}


	
	/**
	 *Получить скорость на данном участке маршрута
	 */
	public double getSpeed()
	{
		//throw new UnsupportedOperationException();
		return speed;
	}

	public void setSpeed(double s)
	{
		speed=s;
	}

	/**
	 *Получить время, в которое данная точка маршрута была занесена.
	 */
	public Date getDate()
	{
		return date;
	}

	public void setDate(Date d)
	{
		date=d;
	}

	/**
	 * @return the latitude
	 */
	public double getLatitude()
	{
		return this.latitude;
	}

	/**
	 * @return the longitude
	 */
	public double getLongitude()
	{
		return this.longitude;
	}

	/**
	 * @param latitude the latitude to set
	 */
	public void setLatitude(double latitude)
	{
		this.latitude=latitude;
	}

	/**
	 * @param longitude the longitude to set
	 */
	public void setLongitude(double longitude)
	{
		this.longitude=longitude;
	}

	public String toString()
	{
		return "DT: "+date+"; LT: "+latitude+"; LN: "+longitude+"; FL: "+fuelLevel+"; SP: "+speed;
	}

	/**
	 * Getter for fuelLevel
	 * @return the fuelLevel
	 */
	public double getFuelLevel()
	{
		return this.fuelLevel;
	}

	/**
	 * Setter for property fuelLevel
	 * @param fuelLevel the fuelLevel to set
	 */
	public void setFuelLevel(double fuelLevel)
	{
		this.fuelLevel=fuelLevel;
	}
}
