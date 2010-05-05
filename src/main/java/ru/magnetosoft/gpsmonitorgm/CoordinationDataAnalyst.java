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

public class CoordinationDataAnalyst
{

	static class CoordinateDataBounds
	{

		private double minLatitude=Double.MAX_VALUE, minLongitude=Double.MAX_VALUE,
			maxLatitude=Double.MIN_VALUE, maxLongitude=Double.MIN_VALUE;

		/**
		 * Getter for maxLatitude
		 * 
		 * @return the maxLatitude
		 */
		public double getMaxLatitude()
		{
			return this.maxLatitude;
		}

		/**
		 * Getter for maxLongitude
		 * 
		 * @return the maxLongitude
		 */
		public double getMaxLongitude()
		{
			return this.maxLongitude;
		}

		/**
		 * Getter for minLatitude
		 * 
		 * @return the minLatitude
		 */
		public double getMinLatitude()
		{
			return this.minLatitude;
		}

		/**
		 * Getter for minLongitude
		 * 
		 * @return the minLongitude
		 */
		public double getMinLongitude()
		{
			return this.minLongitude;
		}

		public void refreshDataBounds(double latitude,double longitude)
		{
			if(minLatitude>latitude)
				minLatitude=latitude;
			if(minLongitude>longitude)
				minLongitude=longitude;
			if(maxLatitude<latitude)
				maxLatitude=latitude;
			if(maxLongitude<longitude)
				maxLongitude=longitude;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see java.lang.Object#toString()
		 */
		@Override
		public String toString()
		{
			return "minLatitude: "+minLatitude+"; minLongitude: "+minLongitude
				+"; maxLatitude: "+maxLatitude+"; maxLongitude: "+maxLongitude;
		}
	}
	final private int INVALID_INDEX=-1;
	final private int INITIAL_CP_DETECTION_STEP=15;
	static final private double wgs84_earthEquatorialRadiusMeters=6378137.0;
	// final private double MINIMAL_PERCENT_OF_ROUTE_FOR_CALCULATION = 3;
	static final private double degreePerRadian=180/Math.PI;

	private double calculateSphericalDistance(double phi1,double lambda1,double phi2,
		double lambda2)
	{

		double pdiff=Math.sin(((phi2-phi1)/2f));
		double ldiff=Math.sin((lambda2-lambda1)/2f);
		double rval=Math.sqrt((pdiff*pdiff)+Math.cos(phi1)*Math.cos(phi2)*(ldiff*ldiff));
		return 2.0f*(float)Math.asin(rval);

	}

	private double convertDegreeToRadians(double coord)
	{
		return (coord/degreePerRadian);
	}

	protected static double getMaxBoundMeterDistance(CoordinateDataBounds bounds)
	{
		return getMeterDistance(bounds.getMinLatitude(),bounds.getMinLongitude(),bounds.getMaxLatitude(),bounds.
			getMaxLongitude());
	}

	public static double getMeterDistance(double latitudePoint1,double longitudePoint1,
		double latitudePoint2,double longitudePoint2)
	{

		/*
		 * double radLat1 = convertDegreeToRadians(latitudePoint1); double radLon1 =
		 * convertDegreeToRadians(longitudePoint1); double radLat2 =
		 * convertDegreeToRadians(latitudePoint2); double radLon2 =
		 * convertDegreeToRadians(longitudePoint2);
		 */
		double radLat1=latitudePoint1/degreePerRadian;
		double radLon1=longitudePoint1/degreePerRadian;
		double radLat2=latitudePoint2/degreePerRadian;
		double radLon2=longitudePoint2/degreePerRadian;

		/*
		 * double dist = calculateSphericalDistance(radLat1, radLon1, radLat2, radLon2);
		 */
		double pdiff=Math.sin(((radLat2-radLat1)/2f));
		double ldiff=Math.sin((radLon2-radLon1)/2f);
		double rval=Math.sqrt((pdiff*pdiff)+Math.cos(radLat1)*Math.cos(radLat2)
			*(ldiff*ldiff));
		double dist=2.0f*(float)Math.asin(rval);

		double mDist=dist*wgs84_earthEquatorialRadiusMeters;
		return mDist;
	}

	protected static long getTimePeriodInMinutes(Date from,Date to)
	{
		long fromLong=from.getTime();
		long toLong=to.getTime();

		return ((toLong-fromLong)/(1000*60));
	}

	/**
	 * Расчитать расстояние отрезка маршрута по точкаь маршрута.
	 * 
	 * 
	 * @param r
	 *            маршрут
	 * @param fromIndex
	 *            от такой точки маршрута
	 * @param toIndex
	 *            до такой точки маршрута
	 * @return расстояние отрезка
	 */
	protected double calculateDistance(Route r,int fromIndex,int toIndex)
	{
		double result=0;
		if(null==r)
			return 0;
		List<RoutePoint> routePoints=r.getRoutePoints();
		if(null==routePoints)
			return 0;

		RoutePoint prevRp=routePoints.get(fromIndex);
		for(int i=fromIndex;i<toIndex;i++)
		{
			result+=getMeterDistance(prevRp.getLatitude(),prevRp.getLongitude(),routePoints.get(i).
				getLatitude(),routePoints.get(i).getLongitude());
			prevRp=routePoints.get(i);
		}
		return result;
	}

	/**
	 * Создать список простоев.
	 * 
	 * @param route
	 *            маршрут
	 * @param pitStopTime
	 *            время простоя в зоне
	 * @param pitStopRadius
	 *            радиус зоны
	 * @return
	 */
	public static List<PitStop> resolvePitStops(Route route,int pitStopTime,int pitStopRadius)
	{
		long start=System.nanoTime();
		List<PitStop> pitStops=new ArrayList<PitStop>();
		List<RoutePoint> rp=route.getRoutePoints();

		int currP=0;

		while(currP<rp.size())
		{
			// обрабатываем след. точку
			currP++;
			// текущие расстояние
			CoordinateDataBounds bounds=new CoordinateDataBounds();
			// текущая точка данного простоя
			int currPSP;
			for(currPSP=currP;currPSP<rp.size();currPSP++)
			{
				bounds.refreshDataBounds(rp.get(currPSP).getLatitude(),rp.get(currPSP).getLongitude());
				if(getTimePeriodInMinutes(rp.get(currP).getDate(),rp.get(currPSP).getDate())>pitStopTime)
					break;
			}

			if(getMaxBoundMeterDistance(bounds)>(pitStopRadius*2))
				continue;

			//log.info("Найдена возможная точка простоя в: " + rp.get(currP).getDate());

			if(currPSP<rp.size())
			{
				double lat=rp.get(currP).getLatitude();
				double lon=rp.get(currP).getLongitude();

				while(currPSP<rp.size()
					&&getMaxBoundMeterDistance(bounds)<(pitStopRadius*2))
				{
					bounds.refreshDataBounds(rp.get(currPSP).getLatitude(),rp.get(currPSP).getLongitude());
					currPSP++;
				}
				if(currPSP>=rp.size())
					currPSP=rp.size()-1;

				PitStop ps=new PitStop();
				ps.setArrivalDate(rp.get(currP).getDate());
				ps.setLeaveDate(rp.get(currPSP).getDate());

				ps.setLatitude(lat);
				ps.setLongitude(lon);

				ps.setStartFuelLevel(rp.get(currP).getFuelLevel());
				ps.setFinalFuelLevel(rp.get(currPSP).getFuelLevel());

				pitStops.add(ps);
				// переходим на новую
				currP=currPSP;
			}else
			{
				break;
			}

		}

//		long finish = System.nanoTime();
//		double durationMsec = TimingUtils.getDurationMsec(start, finish);
//		String message = String.format("Продолжительность вычисления точек простоя: %.2f",
//				durationMsec);
//		//log.trace(message);
//		message = String.format("Найдено точек простоя (%d) для маршрута (%s)", pitStops.size(),
//				route.getId());
//		//log.info(message);
		return pitStops;
	}
	/**
	 * Найти точку старта для маршрута. <br/>
	 * 
	 * @param route
	 *            маршрут
	 * @param checkPoints
	 *            контрольные точки, предоставленные для анализа
	 * @return
	 */
//	public synchronized CheckPoint resolveStartCheckPoint(Route route,
//			List<CheckPoint> checkPoints, int cpRadius) {
//
//		log.debug("Начало вычисления вхожденияв стартовую точку...");
//		List<CheckPoint> possibleStartPoints = new ArrayList<CheckPoint>(10);
//		long start = System.nanoTime();
//		for (CheckPoint point : checkPoints) {
//			if (!point.isLoadingTerminal()) {
//				possibleStartPoints.add(point);
//				log.trace("Добавление " + point.getName()
//						+ " to list possible start checkpoints...");
//			}
//
//		}
//
//		List<RoutePoint> routePoints = route.getRoutePoints();
//		List<PossibleStartCheckPoint> possibleStartPointsResult = new ArrayList<PossibleStartCheckPoint>(
//				10);
//
//		// вычисление расстояния до всех возможных п/п
//		log.debug("Вычисление расстояния до всех возможных ПП...");
//		for (CheckPoint cp : possibleStartPoints) {
//			log.debug("Вычисление возможности для  " + cp.getName() + "...");
//			double mDist = getMeterDistance(routePoints.get(0).getLatitude(), routePoints.get(0)
//					.getLongitude(), cp.getLatitude(), cp.getLongitude());
//			log.debug("Расстояние вычислено как " + mDist + " метров.");
//			possibleStartPointsResult.add(new PossibleStartCheckPoint(mDist, cp));
//
//		} // for (CheckPoint cp : possibleStartPoints)
//
//		double minimalDist = Double.MAX_VALUE;
//		CheckPoint result = null;
//		for (PossibleStartCheckPoint ps : possibleStartPointsResult) {
//			if (minimalDist > ps.getDistance()) {
//				minimalDist = ps.getDistance();
//				result = ps.getCheckPoint();
//			}
//		}
//
//		long finish = System.nanoTime();
//		double durationMsec = TimingUtils.getDurationMsec(start, finish);
//		String message = String.format("Продолжительность вычисления стартовых точек: %.2f",
//				durationMsec);
//		log.trace(message);
//		log.info("Вычислена стартовая точка: " + result.getName());
//		return result;
//	}
	/**
	 * Вычисляет время выезда со стартовой точки
	 * 
	 * @param route
	 *            маршрут
	 * @param cp
	 *            стартовая точка
	 * @return время выезда со стартовой точки
	 */
//	public Date resolveStartCheckPointLeaveDate(Route route, CheckPoint cp, int cpRadius) {
//		if (route == null || cp == null)
//			return null;
//		log.debug("Вычисление даты выхода из стартовой точки...");
//		int n = route.getRoutePoints().size();
//		final int currentCPRadius = (cp.getRadius() != 0) ? (int) cp.getRadius() : cpRadius;
//		int i = 0;
//		while (i < n
//				&& getMeterDistance(route.getRoutePoints().get(i).getLatitude(), route
//						.getRoutePoints().get(i).getLongitude(), cp.getLatitude(), cp
//						.getLongitude()) < currentCPRadius)
//			i++;
//
//		for (; i < n; i++) {
//			RoutePoint rp = route.getRoutePoints().get(i);
//
//			// получить расстояние м-у точками
//			double mDist = getMeterDistance(rp.getLatitude(), rp.getLongitude(), cp.getLatitude(),
//					cp.getLongitude());
//
//			if (mDist >= currentCPRadius) {
//				return rp.getDate();
//			}
//
//		}
//		// return null;
//		return route.getRoutePoints().get(0).getDate();
//	}
	/**
	 * is route point in lt radius
	 * 
	 * @param cp
	 *            п/п
	 * @param minimalLTRadius
	 *            минимальный радиус
	 * @param rp
	 *            пункт погрузки
	 * @return
	 */
//	private boolean routePointIsInLTRadius(CheckPoint cp, double minimalLTRadius, RoutePoint rp) {
//		double mDist = getMeterDistance(rp.getLatitude(), rp.getLongitude(), cp.getLatitude(), cp
//				.getLongitude());
//
//		if (mDist < minimalLTRadius)
//			return true;
//		return false;
//	}
}
