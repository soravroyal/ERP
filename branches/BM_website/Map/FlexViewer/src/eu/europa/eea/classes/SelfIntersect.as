package eu.europa.eea.classes
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	
	public class SelfIntersect
	{
		public function SelfIntersect()
		{
		}
		
		public static function testCheckPolygonSelfIntersect():void
		{
			
			var selfIntersected:Boolean;
			var testPoly:Polygon = new Polygon();
			testPoly.spatialReference = new SpatialReference(4326);
			// non-self-intersecting polygon:
			testPoly.rings =
			[
				[
					new MapPoint(0,0),
					new MapPoint(0,1),
					new MapPoint(1,1),
					new MapPoint(1,0),
					new MapPoint(0,0)
				]
			];
			
			selfIntersected = checkPolygonSelfIntersect(testPoly);
			
			trace("Not self intersecting test, Did it self-intersect? (should be false/0): " + selfIntersected);
		
			// self-intersecting polygon:
			testPoly.rings =
			[
				[
					new MapPoint(0,0),
					new MapPoint(0,1),
					new MapPoint(1,1),
					new MapPoint(-1,0),
					new MapPoint(0,0)
				]
			];
			testPoly.rings =
			[
				[
					new MapPoint(0,0),
					new MapPoint(-1,0),
					new MapPoint(1,1),
					new MapPoint(0,1),
					new MapPoint(0,0)
				]
			];
			
			
			selfIntersected = checkPolygonSelfIntersect(testPoly);
			
			trace("Self intersecting test, Did it self-intersect? (should be true/1) : " + selfIntersected);
		
		}

		public static function checkPolygonSelfIntersect(polygon:Polygon):Boolean
		{
			//Boolean saying whether polygon selfintersects
			var intersect:Boolean = false;
			for(var i:int = 0; i < polygon.rings.length; i ++)
			{
				//delete last element since first and last points are identical in a polygon
				/*var orgArray:Array = polygon.rings[i]
				var polyArray:Array = orgArray.slice(0,orgArray.length - 1)
				
				intersect = checkRingSelfIntersect(polyArray);*/
				intersect = checkRingSelfIntersect(polygon.rings[i]);
				if (intersect)
				{
					return intersect;
				}
			}
			return intersect;
		}
		
		private static function checkRingSelfIntersect(Z1:Array = null):Boolean
		{
			//Boolean saying whether line selfintersects
			var intersect:Boolean = false;
			
			//If no input argument is given return false
			if (!Z1)
			{
				return false;
			}
		
			//Checking if any two line segments cross
			for (var m:int = 0; m < Z1.length; m++)
			{
				var z11:MapPoint = Z1[m];
				var z12:MapPoint  = Z1[m+1];
				trace("1st line: " +  m  + " - " + (m+1));
				
				for (var n:int = m + 2; n < Z1.length - 1; n++)
				{
					var z21:MapPoint  = Z1[n];
					var z22:MapPoint  = Z1[n+1];
					trace("2nd line: " + n  + " - " + (n+1));
					if (curvIntersect(z11,z12,z21,z22))
					{
						intersect = true;
						return intersect;
					}
				}
			}
			return intersect;
		
		}
		
		private static function  curvIntersect(z11:MapPoint,z12:MapPoint,z21:MapPoint,z22:MapPoint):Boolean
		{
		
			//Boolean saying wether line segments intersect
			var intersect:Boolean = false;
		
			//Coordinates
			var x11:Number = z11.x; 
			var y11:Number = z11.y;
			var x12:Number = z12.x; 
			var y12:Number = z12.y;
			var x21:Number = z21.x; 
			var y21:Number = z21.y;
			var x22:Number = z22.x; 
			var y22:Number = z22.y;
		
			//Defining auxiliary quantities
			var X12:Number = x11-x21;
			var Y12:Number = y11-y21;
			var X1:Number  = x12-x11;
			var X2:Number  = x22-x21;
			var Y1:Number  = y12-y11;
			var Y2:Number  = y22-y21;
		
			//Defining quantities s and t: segments cross if both s and t are between 0 and 1.
			var s:Number = (X2*Y12-Y2*X12)/(X1*Y2-X2*Y1);
			var t:Number = -(Y1*X12-X1*Y12)/(X1*Y2-X2*Y1);
		
			//Checking cross condition
			/*
			* var c1:Boolean = (s >= 0 && s <= 1);
			* var c2:Boolean = (t >= 0 && t <= 1);
			*/
			
			var c1:Boolean = (s > 0 && s < 1);
			var c2:Boolean = (t > 0 && t < 1);
			
			if (c1 && c2)
			{
				intersect = true;
			}
			return intersect;
		}

	}
}