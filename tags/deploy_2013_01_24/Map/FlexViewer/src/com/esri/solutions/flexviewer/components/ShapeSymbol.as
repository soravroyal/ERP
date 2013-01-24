package com.esri.solutions.flexviewer.components
{
	import flash.display.Shape;
	
	import mx.core.IFlexDisplayObject;
		
	public class ShapeSymbol extends Shape implements IFlexDisplayObject
	{

        private var _color:uint = 0xFF0000;
        private var _size:int = 20;

	 	
		public function ShapeSymbol (_color:uint,_size:int)
		{	
			color = _color;
			size = _size;				
		}
		public function get color():uint{
			return _color;
		}
		public function set color (color:uint):void{
			_color = color;			
		}
		public function get size():int{
			return _size;
		}
		public function set size (size:int):void{
			_size = size;			
		}
		public  function drawme():void
		{
  			//override this method in symbol (RectangleSymbol, CircleSymbol, etc.)
  		}
  		
  		//Moves this object to the specified x and y coordinates.
  		public function	move(x:Number, y:Number):void{
			this.x = x;
			this.y = y;
		}
		public function position():void{
			var newy:Number = y;
			var newx:Number = x;
			//if(measuredHeight < height){
				newy =  y + height - height/2 - measuredHeight/2;
		// 	}else height = measuredHeight;
		//	if(measuredWidth < width){
			 	newx = x + width-width/2-measuredWidth/2;
	//		}else width = measuredWidth;
			move(newx,newy);
		}	
		public function setActualSize(newWidth:Number, newHeight:Number):void {
			this.width = newWidth;
			this.height = newHeight;
		}
		public function get measuredHeight():Number {
			return _size;
			
		}
		public function get measuredWidth():Number {
			return _size;
			
		}
	}
}