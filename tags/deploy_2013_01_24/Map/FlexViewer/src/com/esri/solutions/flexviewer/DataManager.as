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
	
	import com.esri.solutions.flexviewer.utils.Hashtable;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

    [Event(name="dataAdded", type="com.esri.solutions.flexviewer.AppEvent")]
    [Event(name="dataFetch", type="com.esri.solutions.flexviewer.AppEvent")]
    
    /**
     * data manager will be storing the session data to support data reuse such as
     * widget chain.
     * A data manager UI (a special widget) will be developed to allow user edit the data.
     */
	public class DataManager extends EventDispatcher
	{
        private var container:SiteContainer = SiteContainer.getInstance();
        
        private var dataTable:Hashtable;
                
		public function DataManager()
		{
			//TODO: implement function
			super();
			
			dataTable = new Hashtable();
            SiteContainer.addEventListener(AppEvent.CONFIG_LOADED, config);
            
            //this is a example to setup the listner to get the type of data the Data
            //Manager is interested in.
            SiteContainer.addEventListener(AppEvent.DATA_FETCH, fetchData);
            SiteContainer.addEventListener(AppEvent.DATA_ADDED, addData);
        }
        
        private function config(event:AppEvent):void
        {
            
        }
        
        private function fetchData(event:AppEvent):void
        {
        	SiteContainer.dispatchEvent(new AppEvent(AppEvent.DATA_UPDATED, false, false, dataTable));
        }
        
        private function addData(event:AppEvent):void
        {
        	var key:String = event.data.key;
        	if(key != "")
        	{
	        	var dataCollection:ArrayCollection  = event.data.collection;
	        	if (dataTable.containsKey(key))
	        	{
	        		dataTable.remove(key);
	        	}
	        	dataTable.add(key,dataCollection);
        	}
        	SiteContainer.dispatchEvent(new AppEvent(AppEvent.DATA_UPDATED, false, false, dataTable));
        }
        
        
        
	}
}