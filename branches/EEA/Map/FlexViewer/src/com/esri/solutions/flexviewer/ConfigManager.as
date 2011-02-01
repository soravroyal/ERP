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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	/**
	 * ConfigManager is used to parse the config.xml file and store the information in ConfigData.
	 */
    [Event(name="configLoaded", type="com.esri.solutions.flexviewer.AppEvent")]
    
	public class ConfigManager extends EventDispatcher
	{
		
		private var configFileName:String;
		private var urlPrefix:String;
		private var appParameters:Object;
		
		public function ConfigManager()
		{
			super(); 
			//make sure the container is properly initialized and then
			//proceed with configuration initialization.
            SiteContainer.addEventListener(SiteContainer.CONTAINER_INITIALIZED, init);
		}
        		
		//init - start loading the configuration file and parse.
		public function init(event:Event):void
		{
			appParameters = new Object();
			getParameters();
			configLoad();
		}
		//get flashvars
		private function getParameters():void {        		
	            for(var o:String in Application.application.parameters){
	            	appParameters[o] = Application.application.parameters[o]
	            }
	            urlPrefix = "";
	            if ( appParameters["urlprefix"] != null){
	          	  urlPrefix = appParameters["urlprefix"];
	          	  if(urlPrefix.lastIndexOf("/") != urlPrefix.length-1){
						urlPrefix = urlPrefix + "/";
					}
	            } 
	            configFileName = "config_mapsearch_ex.xml"
	            if ( appParameters["configfile"] != null){
	          	  configFileName = appParameters["configfile"];
	            }
	             
	            
	            if ( appParameters["locale"] != null && appParameters["locale"] != ""){
	            	setLocale(appParameters["locale"]);
	            }
	           
	    }			
		//config load
		private function configLoad():void
		{
			var configService:HTTPService = new HTTPService();
			configService.url = configFileName;
			configService.resultFormat = "e4x";
			configService.addEventListener(ResultEvent.RESULT, configResult);
			configService.addEventListener(FaultEvent.FAULT, configFault);	
			configService.send();
		}
				
		//config fault
		private function configFault(event:mx.rpc.events.FaultEvent):void
		{
			var sInfo:String = "Error: ";
			sInfo += "Event Target: " + event.target + "\n\n";
			sInfo += "Event Type: " + event.type + "\n\n";
			sInfo += "Fault Code: " + event.fault.faultCode + "\n\n";
			sInfo += "Fault Info: " + event.fault.faultString;
			Alert.show(sInfo);
		}
		
		//config result
		private function configResult(event:ResultEvent):void
		{
			try
			{	
				//parse config.xml to create config data object
				var configData:ConfigData = new ConfigData();
				var configXML:XML = event.result as XML;
				var i:int;
				var j:int;
				
				configData.configParams = appParameters;				
				
				//================================================	
				//user interface
				var configUI:Array = [];
				var value:String;
				value = configXML..banner;
				var banner:Object = 
				{
					id: "banner",
					value: value
				}
				configUI.push(banner);
				value = configXML..title;
				var title:Object = 
				{
					id: "title",
					value: value
				}
				configUI.push(title);
				value = configXML..subtitle;
				var subtitle:Object = 
				{
					id: "subtitle",
					value: value
				}
				configUI.push(subtitle);
				value = configXML..logo;
				var logo:Object = 
				{
					id: "logo",
					value: value
				}
				configUI.push(logo);
				value = configXML..stylesheet;
				var stylesheet:Object = 
				{
					id: "stylesheet",
					value: urlPrefix + value
				}
				configUI.push(stylesheet);
				
				value = configXML..collapsewidgets;
				if ( configData.configParams["collapseWidgets"] == null){
	          	  configData.configParams["collapseWidgets"] = value;
	            }
				value = configXML..hidewidgetscontrol;
				if ( configData.configParams["hidewidgetscontrol"] == null){
	          	  configData.configParams["hidewidgetscontrol"] = value;
	            }
	            if(appParameters["locale"] == null && configXML..locale.toString().length > 0){
	            	setLocale(configXML..locale.toString());
	            }
	            
	            var cofilter:XMLList = configXML..mapservice.layers.layer.(@visible == 'true').@cofilter;
	            if(cofilter.length() == 1){
	          	  configData.configParams["cofilter"] = cofilter.toString();
	            }
				value = configXML..findlocation;
				var findlocation:Object = 
				{
					id: "findlocation",
					value: value,
					inputtext: configXML..findlocation.@inputtext.toString(),
					searchtext: configXML..findlocation.@searchtext.toString(),
					cleartext: configXML..findlocation.@cleartext.toString(),
					noresulttext: configXML..findlocation.@noresulttext.toString()
				}
	            configUI.push(findlocation);
				configData.configUI = configUI;
				
				//================================================	
				//menus
				var configMenus:Array = [];
				var menuList:XMLList = configXML..menu;
				var basemapMenuId:String = configXML.map.basemaps.@menu;
				var bmList:XMLList = configXML.map.basemaps.mapservice;
				var navtoolList:XMLList = configXML..navtool;
				var linkList:XMLList = configXML..link;
				var widgetList:XMLList = configXML..widget;
				for (i = 0; i < menuList.length(); i++)
				{
					var menuId:String = menuList[i].@id;
					var menuLabel:String = menuList[i];
					var menuIcon:String = menuList[i].@icon;
					var menuTarget:String = menuList[i].@target;
					if (menuList[i].@visible == "true")
					{
						var basemapItems:Array = [];
						if (menuId == basemapMenuId)
							basemapItems = getBasemapMenuItems(bmList);
						var navtoolItems:Array = getMenuItems(navtoolList, menuId, "navtool");
						var linkItems:Array = getMenuItems(linkList, menuId, "link");
						var widgetItems:Array = getMenuItems(widgetList, menuId, "widget");
						var menuItems:Array = [];
						menuItems = basemapItems.concat(navtoolItems, linkItems, widgetItems);
						var menu:Object = 
						{
							id: menuId,
							label: menuLabel,
							icon: menuIcon,
							items: menuItems,
							target: menuTarget
						}
						configMenus.push(menu);
					}
				}
				configData.configMenus = configMenus;
				
				//================================================	
				//map
				var configMap:Array = [];
				var mapserviceList:XMLList = configXML..mapservice;
				for (i = 0; i < mapserviceList.length(); i++)
				{
					var msId:String = mapserviceList[i].@id;
					
					if(msId == "" ) msId = i.toString();
					var msLabel:String = mapserviceList[i].@label;
					var msType:String = mapserviceList[i].@type;
					var msVisible:Boolean = true;
					if (mapserviceList[i].@visible == "false")
						msVisible = false;	
					var msAlpha:Number = 1;
					if (!isNaN(mapserviceList[i].@alpha))
						msAlpha = Number(mapserviceList[i].@alpha);						
					var msURL:String = mapserviceList[i].@url;
					if(!msURL) msURL = mapserviceList[i];
					
					//overlay layer to bg map
					var msOId:String = mapserviceList[i].@overlay;
					var msOtype:String = mapserviceList[i].@overlaytype;					
					var msOAlpha:Number = 1;
					if (!isNaN(mapserviceList[i].@overlayalpha))
						msOAlpha = Number(mapserviceList[i].@overlayalpha);
					
					var msLegend:String = mapserviceList[i].@legend;
					var msLayerSettings:XMLList = mapserviceList[i].layers || null;
					var msIconShape:String =  mapserviceList[i].@iconShape;
					var	msIconSize:String = mapserviceList[i].@iconSize;
					var	msIconColor:String = mapserviceList[i].@iconColor;
					var	msLayerLink:String = mapserviceList[i].@link;
					var	msTurnOff:String = mapserviceList[i].@turnoff;
					
					var mapservice:Object = 
					{
						id: msId,
						label: msLabel,
						type: msType,
						visible: msVisible,
						alpha: msAlpha,
						url: msURL,
						legend: msLegend,
						layerSettings:msLayerSettings,
						iconShape:msIconShape,
						iconSize:msIconSize,
						iconColor:msIconColor,
						layerLink:msLayerLink,
						turnOff:msTurnOff
					}					
					
					configMap.push(mapservice);
					/**/
					if(msOId){
						var overlaymapservice:Object = 
						{
							id: msId+"_o",
							label: msLabel,
							type: msOtype,
							visible: msVisible,
							alpha: msOAlpha,
							url: msOId,
							legend: msLegend,
							layerSettings:msLayerSettings,
							iconShape:msIconShape,
							iconSize:msIconSize,
							iconColor:msIconColor,
							layerLink:msLayerLink,
							turnOff:msTurnOff
						}
						configMap.push(overlaymapservice);
					}
						/**/
					
				}
				configData.configMap = configMap;
				
				//basemaps
				var configBasemaps:Array = [];
				var basemapList:XMLList = configXML.map.basemaps.mapservice;
				for (i = 0; i < basemapList.length(); i++)
				{
					var bmId:String = i.toString();
					//var bmId:String = basemapList[i].@id;
					var bmLabel:String = basemapList[i].@label;
					var bmOverlay:String = basemapList[i].@overlay;
					var bmLegend:String = basemapList[i].@legend;
					
					var basemap:Object = 
					{
						id: bmId,
						label: bmLabel,
						legend: bmLegend
					}
					configBasemaps.push(basemap);
					/* overlay of other layer e.g. a dynamic layer, when choosing this as bg layer */
					if(bmOverlay){
						var obasemap:Object = 
						{
							id: bmId+"_o",
							label: bmLabel,
							legend: bmLegend
						}
						configBasemaps.push(obasemap);	
					}
					/**/
				}
				configData.configBasemaps = configBasemaps;
				
				//=================================================
				//extents
				var configExtents:Array = [];
				var initialExtent:String = configXML.map.@initialExtent;
				var fullExtent:String = configXML.map.@fullExtent;
				if (initialExtent)
				{
					var iExt:Object = 
					{
						id: "initial",
						extent: initialExtent
					}
					configExtents.push(iExt);
				}
				if (fullExtent)
				{
					var fExt:Object = 
					{
						id: "full",
						extent: fullExtent
					}
					configExtents.push(fExt);
				}
				configData.configExtents = configExtents;
				
				
				//=================================================
				//=================================================
				//initial map settings
				var configMapSettings:Object = new Object();
				var showzoomslider:String = configXML.map.@showzoomslider;
				var scrollwheelzoomenabled:String = configXML.map.@scrollwheelzoomenabled;
				var lodminlevel:Number = Number(configXML.map.@lodminlevel);
				var infopopupmapsizelimit:String = configXML.map.@infopopupmapsizelimit;
				var action:String = configXML.map.@action;
				if(showzoomslider){
					configMapSettings["showzoomslider"] = showzoomslider == "true";
				}
				if(scrollwheelzoomenabled){
					configMapSettings["scrollwheelzoomenabled"] = scrollwheelzoomenabled == "true";
				}
				if(infopopupmapsizelimit != ""){
					configMapSettings["infopopupmapsizelimit"] = infopopupmapsizelimit;
				}
				
				configMapSettings["lodminlevel"] = lodminlevel;			
				configMapSettings["action"] = action;
				
				
				configData.configMapSettings = configMapSettings;
								
				//=================================================
				//widgets
				var configWidgets:Array = [];
				var wList:XMLList = configXML..widget;
				for (i = 0; i < wList.length(); i++)
				{
					var wLabel:String =wList[i].@label;
					var wIcon:String = wList[i].@icon;
					var wConfig:String = urlPrefix + wList[i].@config;
					var wPreload:String = wList[i].@preload;
					var wUrl:String = urlPrefix + wList[i];
					var wInvisBtns:String = wList[i].@invisbtns;
					var wbaseRestServerUrl:String = wList[i].@baserestserverurl;					
					var wWidgetResourceFile:String = wList[i].@widgetresourcefile;
					var widget:Object = 
					{
						id: i,
						label: wLabel,
						icon: wIcon,
						config: wConfig,
						preload: wPreload,
						url: wUrl,
						invisbtns: wInvisBtns,
						baserestserverurl: wbaseRestServerUrl,
						widgetresourcefile : wWidgetResourceFile
					}
					configWidgets.push(widget);
				}
				configData.configWidgets = configWidgets;
				
				//dispatch event
				SiteContainer.dispatchEvent(new AppEvent(AppEvent.CONFIG_LOADED, false, false, configData));
				
			}catch(error:Error){
				SiteContainer.dispatchEvent(new AppEvent(AppEvent.APP_ERROR, false, false, error.message));		
			}
		}
		
		//get menu items
		private function getMenuItems(xmlList:XMLList, menuId:String, itemAction:String):Array
		{
			var menuItems:Array = [];
			for (var i:int = 0; i < xmlList.length(); i++)
			{
				if (xmlList[i].@menu == menuId)
				{
					var itemLabel:String = xmlList[i].@label;
					var itemIcon:String = xmlList[i].@icon;
					var itemValue:String = xmlList[i];
					var menuItem:Object = 
					{
						id: i,
						label: itemLabel,
						icon: itemIcon,
						value: itemValue,
						action: itemAction
					}
					menuItems.push(menuItem);
				}
			}
			return menuItems;
		}
		
		//get basemap menu items
		private function getBasemapMenuItems(xmlList:XMLList):Array
		{
			var menuItems:Array = [];
			if (xmlList.length() > 1)
			{
				for (var i:int = 0; i < xmlList.length(); i++)
				{
					//var itemId:String = xmlList[i].@id; //originally: id: i
					var itemLabel:String = xmlList[i].@label;
					var itemIcon:String = xmlList[i].@icon;
					var itemValue:String = i.toString();
					var menuItem:Object = 
					{
						id: i,//itemId,
						label: itemLabel,
						icon: itemIcon,
						value: itemValue,
						action: "basemap"
					}
					menuItems.push(menuItem);
				}
			}
			return menuItems;
		}
		
		private function setLocale(locale:String):void{
			var locales:Array = ResourceManager.getInstance().getLocales();
			//check if locale is supported:
			for(var i:int = 0; i < locales.length; i++){
				if(locales[i] == locale){
					ResourceManager.getInstance().localeChain = [locale];
					return
				}
			}			
		}	
		
	}
}