package com.esri.solutions.flexviewer.components
{
	public class RectangleSymbolOutline extends ShapeSymbol
	{
		public function RectangleSymbolOutline(_color:uint = 0xFFFFFF,_size:int = 10)
		{
			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.clear();
  			graphics.lineStyle(2, this.color, 1);
    	 	graphics.drawRect(0,0,this.size,this.size);

         	//position();
  		} 	

	}
}