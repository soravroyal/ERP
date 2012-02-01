package eu.europa.eea.controls
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbol.PictureMarkerSymbol;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.esri.solutions.flexviewer.AppEvent;
	import com.esri.solutions.flexviewer.SiteContainer;
	import com.esri.solutions.flexviewer.components.toc.utils.MapUtil;
	
	import eu.europa.eea.widgets.Gazetteer.GazetteerResultData;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.controls.Text;
	
	public class GazetteerLocationRenderer
	{
		
		private var map:Map;
		private var graphicsLayer:GraphicsLayer = new GraphicsLayer();
		private var resultGraphics:Dictionary = new Dictionary();
		private var iconURL:String = "com/esri/solutions/flexviewer/assets/images/icons/i_pushpin.png";
		
		public var generalViewExtentSize:Number = 2;

		
		public function GazetteerLocationRenderer(map:Map)
		{
			this.map = map;
			graphicsLayer.symbol = new PictureMarkerSymbol(iconURL, 30, 30);
			map.addLayer(graphicsLayer);
		}
		
		public function addLocation(result:GazetteerResultData):void
		{
			var g:Graphic = new Graphic();
			g.geometry = result.mapPoint;
			if(map.spatialReference.wkid == 102100)
			{
				g.geometry = WebMercatorUtil.geographicToWebMercator(result.mapPoint) as MapPoint;
			}
			g.attributes = result;
			g.addEventListener(MouseEvent.ROLL_OVER, onMouseOverGraphic)
			graphicsLayer.add(g);
			resultGraphics[result.title] = g;
			MapUtil.zoomToLocation(map, result.mapPoint, generalViewExtentSize);
			
		}
		
		private function onMouseOverGraphic(event:MouseEvent):void
		{
			var g:Graphic = event.currentTarget as Graphic; 
			var resultData:GazetteerResultData = g.attributes as GazetteerResultData;
			SiteContainer.dispatchEvent(new AppEvent(AppEvent.SHOW_INFOWINDOW, false, false, createInfopopupData(resultData)));
			//AppContainer.dispatchEvent(new AppEvent(AppEvent.SHOW_INFOWINDOW, false, false, createInfopopupData(resultData)));
		}
		
		private function createInfopopupData(resultData:GazetteerResultData):Object
		{
			var infoData:Object = new Object();
 			infoData.point = resultData.mapPoint;
 			infoData.iconURL = iconURL;
 			var text:Text = new Text();
 			text.styleName = "InfoTitle";
 			text.text = resultData.title;
 			infoData.title = resultData.title;
 			infoData.childComponent = text;
			return infoData;
		}
		
		public function removeLocation(result:GazetteerResultData):void
		{
			var g:Graphic = resultGraphics[result.title];
			resultGraphics[result.title] = null;
			graphicsLayer.remove(g);
		}
		
		public function clear():void
		{
			resultGraphics = new Dictionary();			
			SiteContainer.dispatchEvent(new AppEvent(AppEvent.SHOW_INFOWINDOW, false, false, null));
			graphicsLayer.clear();
		}

	}
}