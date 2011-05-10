package com.esri.solutions.flexviewer.components
{
	public class TriangleSymbolOutline extends ShapeSymbol
	{
		public function TriangleSymbolOutline(_color:uint = 0xFFFFFF,_size:int = 10)
		{
			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.lineStyle(2, this.color, 1);      		
    	 	graphics.moveTo(0,this.size);
    	 	graphics.lineTo(this.size/2,0);
    	 	graphics.lineTo(this.size,this.size);    	 		
    	 	graphics.lineTo(0,this.size);
      		//position();
  		
		}

	}
}