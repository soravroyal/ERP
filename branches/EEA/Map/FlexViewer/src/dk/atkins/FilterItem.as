package dk.atkins
{
	public class FilterItem
	{
		public var selected:Boolean;
		public var label:String;
		public var id:String;
		public var group:String;
		public var data:String;
		
		public function FilterItem(id:String, label:String, selected:Boolean, data:String, group:String = "")
		{
			this.selected = selected;
			this.label = label;
			this.id = id;
			this.group = group;
			this.data = data;
		}

		
	}
}