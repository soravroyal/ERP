package com.esri.solutions.flexviewer.components
{
	
	
	public class CircleSymbol extends ShapeSymbol {
	 	
	 	//size is radius 

	 	 
  		public function CircleSymbol(_color:uint = 0xFFFFFF,_size:int = 10) {
  			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.clear();
  			graphics.beginFill(this.color);
      		graphics.drawCircle(this.size/2, this.size/2, this.size);
      		graphics.endFill();
      		//position();
      		      		
  		} 	 	
		
 	}
}