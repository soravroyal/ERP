package dk.atkins
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.tasks.FeatureSet;
	import com.esri.ags.tasks.Query;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.solutions.flexviewer.AppEvent;
	import com.esri.solutions.flexviewer.SiteContainer;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;	
		
	public class ZoomUtil
	{		
		private var minx:Number;
		private var miny:Number;
		private var maxx:Number;
		private var maxy:Number;
					
		public function ZoomUtil()
		{
		}
		//,queryLayer:String
		public function getFeatureGeometry(map:Map, condition:String = null,excludeMapLayersFromFilter:Object = null, basemaps:ArrayCollection = null):void{
			var queryLayer :String;
			var counter:int = 0;
			for each (var layerId:String in map.layerIds) {
				var layer:Layer = map.getLayer(layerId); 
				//&& layer.visible 
				if(layer is ArcGISDynamicMapServiceLayer  && (!excludeMapLayersFromFilter  || !excludeMapLayersFromFilter[layerId]) && (!basemaps || !basemaps.contains(layerId))){
					queryLayer = ArcGISDynamicMapServiceLayer(layer).url + "/0";
					
					//var queryTask:QueryTask = new QueryTask("http://sdkcga6307/ArcGIS/rest/services/Sector9all/MapServer/0");
					var queryTask:QueryTask = new QueryTask(queryLayer);
					
					var query:Query = new Query();
					query.where = condition || ArcGISDynamicMapServiceLayer(layer).layerDefinitions[0];
					query.outFields = ["ObjectId"];
					query.returnGeometry = true;
					query.spatialRelationship = "esriSpatialRelIntersects";
					query.outSpatialReference = map.spatialReference;
					
					queryTask.execute(query, new AsyncResponder(onResult, onFault)); 		
				}else{
					//if basemap it will not be queried.
					counter++;
				}
			}				
			var point:MapPoint;	
			var multipoint:Multipoint = new Multipoint();
			function onResult(featureSet:FeatureSet, token:Object = null):void   {
				counter++;
				if(featureSet.features.length > 499)
				{
					SiteContainer.dispatchEvent(new AppEvent(AppEvent.SET_MAP_NAVIGATION, false, false, {tool:"zoominitial",status:"zoom"}));
					return
				}
				for each (var gra:Graphic in featureSet.features) { 
					if(getGeomCenter(gra)){
						point = getGeomCenter(gra); 
						multipoint.addPoint(point);	
					} 
				
				}	
				//if(counter >= map.layerIds.length && minx){
				if(counter >= map.layerIds.length){	
					if(multipoint.points && multipoint.points.length > 1){
						 map.extent = multipoint.extent.expand(1.5);	
					}else if(point){
						minx = point.x - 1;
						maxx = point.x + 1;
						miny = point.y - 1;
						maxy = point.y + 1;
						setExtend(map,minx,miny,maxx,maxy);
					}
				}
						
			}		
			
			//on fault
			function onFault(info:Object, token:Object = null) : void
			{                    
				//showMessage(info.toString(), false);         
			}
		}
		
	
		//get geom center
		private function getGeomCenter(gra:Graphic):MapPoint
		{
			var pt:MapPoint;
           	switch (gra.geometry.type)
           	{
               case Geometry.MAPPOINT:
               {
                    pt = gra.geometry as MapPoint;
                    break;
               }
               
               case Geometry.POLYLINE:
               {
               		var pl:Polyline = gra.geometry as Polyline;
               		var pathCount:Number = pl.paths.length;
               		var pathIndex:int = int((pathCount / 2) - 1);
               		var midPath:Array = pl.paths[pathIndex];
               		var ptCount:Number = midPath.length;
               		var ptIndex:int = int((ptCount / 2) - 1);
               		pt = pl.getPoint(pathIndex, ptIndex);
               		break;
               }
               
               case Geometry.POLYGON:
               {
                    var poly:Polygon = gra.geometry as Polygon;
               		pt = poly.extent.center;
                    break;
               }
            }
			return pt;
		}
		
		private function reCenterAndZoom(map:Map,point:MapPoint,zoomScale:Number):void
		{
			if (map.scale > zoomScale){
				map.scale = zoomScale;
			}
			map.centerAt(point);
		}
		private function setExtend(map:Map,xmin:Number,ymin:Number,xmax:Number,ymax:Number):void
		{
			map.extent = new Extent(xmin,ymin,xmax,ymax,map.spatialReference);
		}	
	}
}