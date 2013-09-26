package com.esri.solutions.flexviewer.components
{
	public class CircleSymbolOutline extends ShapeSymbol {
	 	
	 	//size is radius 

	 	 
  		public function CircleSymbolOutline(_color:uint = 0xFFFFFF,_size:int = 10) {
  			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.clear();
  			graphics.lineStyle(2, this.color, 1);
      		graphics.drawCircle(this.size/2, this.size/2, this.size);
      		//position();
      		      		
  		} 	 	
		
 	}
}