package com.esri.solutions.flexviewer.components
{
	import mx.controls.Image;
	
	
	
	public class CloudSymbol extends ShapeSymbol {
	 	
	 	//size is radius 
		[Embed(source="/com/esri/solutions/flexviewer/assets/images/icons/BulbGrey.png")]		
		public var CloudCls:Class;
	 	 
  		public function CloudSymbol(_color:uint = 0xFFFFFF,_size:int = 10) {
  			super(_color,_size); 
  				
  			//drawme();     		
  		}
  		/*override public function drawme():void{
  			var img:Image = new Image();
  			img.source =  CloudCls;
  			//addChild(img);      		      		
  		} */ 	
		
 	}
}