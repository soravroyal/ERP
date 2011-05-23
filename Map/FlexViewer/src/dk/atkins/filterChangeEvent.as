package dk.atkins
{
	import flash.events.Event;
	 /**
	    * Used to listen for filter/layer definition events
	    */

	public class filterChangeEvent extends Event
	{
		public static const FILTER_CHANGE:String = "filterChange";
		
		/**
		* The filter change event is used when a new filter/layer definition has been created 
		 * 
		 * @param data The new filter/ layer definition string
		*/
		public function filterChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			if (data != null) _data = data;
			super(type, bubbles, cancelable);
		}
				
	    //--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------
	    
	    private var _data:Object;
	
	    /**
	    * The data will be passed via the event. It allows even dispatcher publishes
	    * data to event listener(s).
	    * 
	    * The data is the new filter/layer definition string
	    */
		public function get data():Object
		{
			return _data;
		} 
		
		/**
		 * @private
		 */
		public function set data(data:Object):void
		{
			_data = data;
		}
		
	}
}