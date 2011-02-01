package eu.europa.eea.widgets.Gazetteer
{
	import com.esri.ags.geometry.MapPoint;
	import com.google.maps.services.Placemark;
	
	import mx.utils.StringUtil;
	
	public dynamic class GazetteerResultData
	{
		
		public var title:String;
		public var mapPoint:MapPoint;
		
		public function GazetteerResultData(location:Placemark)
		{
			title = location.address;
			mapPoint = new MapPoint(location.point.lng(), location.point.lat());
		}
		
		/* public function getFormatedData():String
		{
			var data:String;
			data = getFormatedLocation();
			return data;
		}			
			
		private function getFormatedLocation():String
		{
			return StringUtil.substitute("X = {0}\nY = {1}", 
				mapPoint.x.toFixed(2), 
				mapPoint.y.toFixed(2));
		} */

	}
}