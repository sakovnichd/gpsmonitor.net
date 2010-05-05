/**
 * Copyright (c) 2006-2009, Magnetosoft, LLC
 * All rights reserved.
 *
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 * file: BAUtils.java
 */
package ru.magnetosoft.gpsmonitorgm.ba;

import java.io.FileInputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import javax.xml.namespace.QName;
import ru.magnetosoft.bigarch.wsclient.bl.attachmentservice.AttachmentEndpoint;
import ru.magnetosoft.bigarch.wsclient.bl.attachmentservice.AttachmentService;
import ru.magnetosoft.bigarch.wsclient.bl.documentservice.DocumentEndpoint;
import ru.magnetosoft.bigarch.wsclient.bl.documentservice.DocumentService;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchEndpoint;
import ru.magnetosoft.bigarch.wsclient.bl.searchservice.SearchService;
import ru.magnetosoft.magnet.authent.client.AuthenticationModuleInvoker;
import ru.magnetosoft.magnet.authent.client.ISessionTicket;

/**
 * Класс содержащий вспомогательные методы по работе с компонентами системы: БД,
 * ba-server,organization,search,authentication
 * Created on 12.03.2010, 14:03:03
 * 
 * @author sakovnichd
 */
public class BAUtils
{

	public BAUtils()
	{
	}

	public static DocumentEndpoint documentInvoker;
	public static SearchEndpoint searchInvoker;
	public static AuthenticationModuleInvoker authenticationInvoker;
	public static AttachmentEndpoint attachmentInvoker;
	public static ISessionTicket supervisorTicket;
	private static boolean isInit=false;
	/**
	 * Инициализация соединений с модулями
	 * @param conf объект-конфигурация {@link ConfigurationBean }
	 * @throws Exception
	 */
	public static void initConnections() throws Exception
	{
		if(isInit)return;
		String pref=System.getProperty("ru.magnetosoft.gpsmonitor.config")+"/";
		BLConfiguration config=BLConfiguration.readConfig(new FileInputStream(pref+"documentservice-configuration.xml"));
		System.out.println("connecting to DocumentService on '"+config.url+"' ...");
		documentInvoker=new DocumentService(new URL(config.url),new QName(config.namespace,config.name)).
			getDocumentServiceEndpointPort();
		config=BLConfiguration.readConfig(new FileInputStream(pref+"searchservice-configuration.xml"));
		System.out.println("connecting to SearchService on '"+config.url+"' ...");
		searchInvoker=new SearchService(new URL(config.url),new QName(config.namespace,config.name)).
			getSearchServiceEndpointPort();
		config=BLConfiguration.readConfig(new FileInputStream(pref+"attachmentservice-configuration.xml"));
		System.out.println("connecting to AttachmentService on '"+config.url+"' ...");
		attachmentInvoker=new AttachmentService(new URL(config.url),new QName(config.namespace,config.name)).
			getAttachmentServiceEndpointPort();
		config = BLConfiguration.readConfig(new FileInputStream(pref+"authentication-configuration.xml"));
    System.out.println("connecting to AuthenticationService on '" + config.url + "' ...");
    List<URL> ah = new ArrayList<URL>();
    ah.add(new URL(config.url));
    authenticationInvoker = AuthenticationModuleInvoker.getInstance(ah);
		isInit=true;
	}
	

	
}
