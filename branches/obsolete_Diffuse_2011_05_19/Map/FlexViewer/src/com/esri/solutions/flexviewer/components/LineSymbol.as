package com.esri.solutions.flexviewer.components
{
	public class LineSymbol extends ShapeSymbol
	{
		public function LineSymbol(_color:uint = 0xFFFFFF,_size:int = 10)
		{
			super(_color,_size);  			
  			drawme();     		
  		}
  		override public function drawme():void{
  			graphics.clear();
  			graphics.lineStyle(2, this.color, 1);
  			graphics.moveTo(this.x,this.height/2);
  			graphics.lineTo(this.size-1,this.height/2);
  		}
  		override public function get measuredHeight():Number {
			return this.size/4;
			
		}

	}
}