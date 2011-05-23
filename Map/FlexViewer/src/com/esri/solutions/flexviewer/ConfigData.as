////////////////////////////////////////////////////////////////////////////////
//
// Copyright © 2008 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/FlexViewer/License.txt
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.solutions.flexviewer
{
	/**
	 * ConfigData class is used to store configuration information from the config.xml file.
	 */
	public class ConfigData
	{
		
		public var configUI:Array;
		
		public var configMenus:Array;
		
		public var configMap:Array;
		
		public var configBasemaps:Array;
		
		public var configExtents:Array;
		
		public var configWidgets:Array;
		
		public var configData:Array;
		
		public var configParams:Object;
		
		public var configMapSettings:Object;
		
		
		public var configLayerLegends:Object;
		
		public var configDynLayerIcons:Object;
		
		public var configLayerLink:Object;
		
		public function ConfigData()
		{
            configUI = [];
            configMenus = [];
            configMap = [];
            configBasemaps = [];
            configExtents = [];
            configWidgets = [];
            configParams = new Object();
            configLayerLegends = new Object();
            configDynLayerIcons = new Object();
            configMapSettings = new Object();
            configLayerLink = new Object();
		}

	}
}