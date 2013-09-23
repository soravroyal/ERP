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
	import mx.containers.HBox;
	

    /**
    * IWidgetTemplate is the interface between the Widget and the template. Developers
    * can implement this interface to develop their own widget template.
    */	
	public interface IWidgetTemplate
	{
		/**
		 * Pass in the title string to template implementation.
		 * 
		 * @param value the title string
		 */
		function setTitle(value:String):void;
		
		/**
		 * pass in the icon URL to the template implementation.
		 * 
		 * @param value the icon file URL string
		 */
		function setIcon(value:String):void;
		
		/**
		 * Get state token string
		 * 
		 */
		function getState():String;
		
		/**
		 * Pass in the state token string
		 * 
		 * @param value state token string
		 */
		function setState(value:String):void;
		
		function get titleBar():HBox;
	}
}