package dk.atkins
{
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
 
   
	public class MapCursors
	{
		private static var _cursors:MapCursors;
			
		private static var _lock:Boolean = false;
			
		[Embed("images/cursors/crosshair.png")]
		private var crosshairCursor:Class;
		
		[Embed("images/cursors/i_zoomin.png")]
		private var zoominCursor:Class;
		
		[Embed("images/cursors/i_zoomout.png")]
		private var zoomoutCursor:Class;
		
		private var _cursor:String;
		
	 
	 	public function init():void
		{
			_cursors = this;
			_lock = true; //make sure only one container is created.

		}
		
		public static function getInstance():MapCursors
		{
			if (!_lock){
				_cursors = new MapCursors();
				_lock = true;
			}
			return _cursors;		
		}
		public function showCursor(cursor:String):void
		
		{	
			_cursor = cursor;
			switch(_cursor){
				case "crosshair":{
					CursorManager.setCursor(crosshairCursor, CursorManagerPriority.LOW, -5,-5);		
					break;
				}
				case "zoomin": {
					CursorManager.setCursor(zoominCursor, CursorManagerPriority.LOW, 0, 0);					
					break;
				}
				case "zoomout":{
					CursorManager.setCursor(zoomoutCursor, CursorManagerPriority.LOW, 0, 0);					
					break;
				}
				default: {
					removeCursors();
					break;
				}
			} 	
		     
		}		
		
		 
		public function removeCursors():void
		{
			_cursor = "";
			CursorManager.removeAllCursors();
		}
		public function getCursor():String
		{
			return _cursor;
		}
		
	}
}