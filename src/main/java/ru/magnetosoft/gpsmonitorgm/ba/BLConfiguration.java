/**
 * Copyright (c) 2007-2008, Magnetosoft, LLC
 * All rights reserved.
 * 
 * Licensed under the Magnetosoft License. You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.magnetosoft.ru/LICENSE
 *
 */
package ru.magnetosoft.gpsmonitorgm.ba;


import java.io.FileInputStream;
import java.io.InputStream;

import javax.xml.bind.JAXB;
import javax.xml.bind.annotation.XmlAttribute;


/**
 * Configuration of BL module.
 *
 * @author SheringaA
 */
public class BLConfiguration
{
    @XmlAttribute
    public String name;
    @XmlAttribute
    public String namespace;
    @XmlAttribute
    public String url;

    public static BLConfiguration readConfig (String fileName)
        throws Exception
    {
        InputStream cfg =new FileInputStream(fileName);
        return readConfig(cfg);
    } // end readConfig()
		public static BLConfiguration readConfig (InputStream cfg)
		{
			return JAXB.unmarshal(cfg, BLConfiguration.class);
		}
} // end BLConfiguration
