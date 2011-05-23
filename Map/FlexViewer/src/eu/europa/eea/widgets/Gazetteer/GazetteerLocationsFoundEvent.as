package eu.europa.eea.widgets.Gazetteer
{
	import flash.events.Event;

	public class GazetteerLocationsFoundEvent extends Event
	{
		
		public static const TYPE_NAME:String = "locationsFound";
		
		public var locations:Array;
		
		public function GazetteerLocationsFoundEvent(locations:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(TYPE_NAME, bubbles, cancelable);
			this.locations = locations;
		}
		
	}
}