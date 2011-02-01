package com.esri.solutions.flexviewer.components
{
	public class RectangleSymbol extends ShapeSymbol
	{
		public function RectangleSymbol(_color:uint = 0xFFFFFF,_size:int = 10)
		{
			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.clear();
  			graphics.beginFill(this.color);
    	 	graphics.drawRect(0,0,this.size,this.size);
         	graphics.endFill();
         	//position();
  		} 	

	}
}