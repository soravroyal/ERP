package com.esri.solutions.flexviewer
{
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	
	public final class AppUtil
	{
		private static var timer:Timer;
		private static var data:Object;
		public static function setLegendImage(action:String, label:String, legend:String = "", maplayerid:String="", layerid:String="" ):void{
	    		
				if(!timer) timer =  new Timer(800);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, setLegendImage);
				timer.stop();
				
				data = new Object();
				data.action = action;
				data.label = label;
				data.legend = legend;
				data.maplayerid = maplayerid;
				data.layerid = layerid;
				
				if(!Application.application.isModulesReady()){
					//setTimeout(setLegendImage, 800, action,label,legend,maplayerid,layerid);
					
					timer.start();
				}
				else
				{
					SiteContainer.dispatchEvent(new AppEvent(AppEvent.UPDATE_STATIC_LEGEND,false,false,data));
				}			
	    	}
	    	
	    	  
	}
	
	
}