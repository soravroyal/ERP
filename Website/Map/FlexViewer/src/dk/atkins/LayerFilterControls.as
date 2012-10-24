package dk.atkins
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.core.Container;
	import mx.events.ListEvent;
	import mx.resources.ResourceManager;
	/**
	* Dispatched when a new layer definition string has been created
	* 
	*  @eventType dk.atkins.filterChangeEvent.FILTER_CHANGE
	*/
	[Event(name="filterChange", type="dk.atkins.filterChangeEvent")]
	public class LayerFilterControls extends VBox

	{
		private var _filterGroups:XMLList;
		private var groupLabels:ArrayCollection = new ArrayCollection();
		private var filterItemLabels:ArrayCollection = new ArrayCollection();
		private var OR_arrayCol:ArrayCollection = new ArrayCollection();
		private var AND_arrayCol:ArrayCollection = new ArrayCollection();
		private var Controls_arr:ArrayCollection = new ArrayCollection();
		private var _definitionFilter:String;
		
		/**
		* Constructor
		* 
		*/			
		public function LayerFilterControls()
		{
			super();
			createChildren();
			_definitionFilter = "";
		}
		
		override protected function createChildren():void {
			
		//<filter type="checkbox" label="Air" data="air&gt;0" condition="OR" />
		
		    // Call the createChildren() method of the superclass.
		    super.createChildren();
		    
			resourceManager.addEventListener(Event.CHANGE,updateLocale);
		       
		    
		}
		/**
		 * The layer definition based on chosen filters as a string 
		 * 
		 */
		public function get definitionFilter():String{
			return _definitionFilter;
		}
		/**
		 * The xml defining the groups and filtercontrols.
		 * 
		 * <p> Example of xml: 
		 * 	condition AND/OR indicates operator to bind this data with the other filters
		 * 	type is checkbox or combobox
		 *  data is the string to add to filter definition
		 * 	selected indicates the selected item / or whether checkbox is selected
		 * <br /><br />
		 *	&nbsp;&lt;filtergroups&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&lt;group label="Year"&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;filter type="combobox" datafield="year" data="2001,2004,2009" condition="AND" selected="2009"/&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&lt;/group&gt;<br />
		 * 		&nbsp;&nbsp;&nbsp;&lt;group label="Release"&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;filter type="checkbox" label="Air" data="air&gt;0" condition="OR" selected="true"/&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;filter type="checkbox" label="Soil" data="soil&gt;0" condition="OR" selected="true"/&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;filter type="checkbox" label="Water" data="water&gt;0" condition="OR" selected="true"/&gt;<br />
		 *		&nbsp;&nbsp;&nbsp;&lt;/group&gt;<br />
		 * &nbsp;&lt;filtergroups&gt;<br /><br />
		 * </p>
		*/
		public function get filterGroups():XMLList
			{
				return _filterGroups;
			}
			
		public function set filterGroups(value:XMLList):void
			{
				
				_filterGroups = value;
				//for(var i:int =0; i < _filterGroups.group.length(); i++){
				//	var group:XML = _filterGroups.group[i];
				//}
				if(_filterGroups){
					this.removeAllChildren();
					OR_arrayCol.removeAll();
					AND_arrayCol.removeAll();
					Controls_arr.removeAll();
				}
				for each(var group:XML in _filterGroups.group){
					var hbox:HBox = new HBox();
					var vbox:VBox = new VBox();
			    	var groupLabel:Label = new Label();
			    	groupLabel.text = ResourceManager.getInstance().getString("FilterAllWidgetStrings", "filtergroup_"+group.@label.toString().toLowerCase()) || group.@label;
			    	groupLabels.addItem({label:groupLabel, localekey:"filtergroup_"+group.@label.toString().toLowerCase()});
			    	groupLabel.styleName = "RecordText";
			    	groupLabel.width = 80;
			    	hbox.addChild(groupLabel);
			    	for each(var filter:XML in group.filter){			    		
			    		addFilterControl(filter.@id.toString(), filter.@type.toString(), filter.@data.toString(), filter.@condition.toString(), filter.@label.toString(), vbox, filter.@selected.toString(), filter.@datafield.toString(), group.@label.toString());
			    	}
			    	hbox.addChild(vbox);
			    	var spacer:Spacer = new Spacer();
			    	spacer.height = 8;
			    	this.addChild(spacer);
			    	this.addChild(hbox);
			    }
			}
		/**
			* Turns a filter on/off by creating a new layer definition string
			*
			* @param filter Name of filter e.g. Year.
			* @param select Select or deselect the filter.
			*
			* @return void.
			*
			* 
			*/
		
		public function setFilter(filter:String, select:Boolean = true):void{
			
		
			for each (var con:Object in Controls_arr){
				if(con["item"] is CheckBox && CheckBox(con).id == filter){
					if(CheckBox(con["item"]).selected != select){
						CheckBox(con["item"]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					break;	
				} 
				if(con["item"] is ComboBox){					
					for(var i:int = 0; i <  ComboBox(con["item"]).dataProvider.length; i ++){
						if(ComboBox(con["item"]).dataProvider.getItemAt(i)["label"] == filter){						
							if(i != ComboBox(con["item"]).selectedIndex){
								ComboBox(con["item"]).selectedIndex = i;
								ComboBox(con["item"]).dispatchEvent(new ListEvent(ListEvent.CHANGE));
							}
							break;
						}
					}	
				}	
			}			
				
		}
		
		public function getFilter():String{
			var filterString:String = "";
			for each (var con:Object in Controls_arr){
				if(con["item"] is CheckBox){
					if(filterString != "") filterString = filterString + ",";
					filterString += CheckBox(con["item"]).id + ":" + CheckBox(con["item"]).selected;					
				} 
				if(con["item"] is ComboBox){
					if(filterString != "") filterString = filterString + ",";	
					filterString += ComboBox(con["item"]).selectedLabel;				
				}	
			}			
			return filterString;	
		}
			
		private function addFilterControl(id:String,type:String, data:String,condition:String, _label:String, box:Container,selected:String = "true",datafield:String="", group:String= ""):void{
			var label:String =  ResourceManager.getInstance().getString("FilterAllWidgetStrings", "filteritem_"+_label.toLowerCase()) || _label;
			switch (type){
				case "checkbox" :
					var chk:CheckBox = new CheckBox();
					chk.selected = selected == "true";
					chk.data = data;
					chk.label = label;
					chk.height = 18;
					chk.id = id;
					chk.addEventListener(MouseEvent.CLICK, filterCheckBoxChange);					
					Controls_arr.addItem({item:box.addChild(chk),localekey:"filteritem_"+_label.toLowerCase()});
					
					var chkObj:FilterItem = new FilterItem(label,label,chk.selected,data,group);
					
					if(condition == "OR"){
						OR_arrayCol.addItem(chkObj);
					}else{
						AND_arrayCol.addItem(chkObj);
					} 
				break;
				case "combobox" :				
					if(label){
						var cmblabel:Label = new Label(); 
						cmblabel.text = label;
						cmblabel.id = id;
						Controls_arr.addItem(box.addChild(cmblabel));
					}
					var cmb:ComboBox = new ComboBox();
					var selectedIndex:int;
					var dataprovider_arr:Array = data.split(",");
					var dataprovider:ArrayCollection = new ArrayCollection();
					for (var i:int = 0; i < dataprovider_arr.length; i ++){
						
						var ilabel:String =  dataprovider_arr[i].toString();
						if(ilabel == selected){
							selectedIndex = i;
						}
						var _item:Object = {label:ilabel, data:datafield + "=" + ilabel};
						dataprovider.addItem(_item);
						var comObj:FilterItem = new FilterItem(_item.label, _item.label,i == selectedIndex,_item.data,group);
						if(condition == "OR"){
							OR_arrayCol.addItem(comObj);
						}else{
							AND_arrayCol.addItem(comObj);
						} 
					}
					cmb.dataProvider = dataprovider;
					cmb.addEventListener(ListEvent.CHANGE , filterComboBoxChange);
					cmb.selectedIndex = selectedIndex;
					filterComboBoxChange(null, cmb)
					
					Controls_arr.addItem({item:box.addChild(cmb),localekey:"filteritem_"+_label});
				break;
				case "radiobtn" :
				// N/A
				break;
			};

		}
		
		private function filterComboBoxChange(e:ListEvent, cbox:ComboBox = null):void{
			if(!cbox)cbox = ComboBox(e.currentTarget);
			setFilterArrays(cbox.selectedItem.label, true);
			//remove other items selection flags
			for(var i:int = 0; i <  cbox.dataProvider.length; i ++){
				if(cbox.dataProvider.getItemAt(i)["label"] != cbox.selectedItem.label){
					setFilterArrays(cbox.dataProvider.getItemAt(i)["label"], false);
				}
			}
			updateFilter();
			
		}
		private function filterCheckBoxChange(e:MouseEvent):void{
			setFilterArrays(CheckBox(e.currentTarget).id, CheckBox(e.currentTarget).selected);
			updateFilter();			
		}
		private function setFilterArrays(id:String, selected:Boolean):void{
			for(var i:int = 0; i < OR_arrayCol.length;i++){
				var or_item:FilterItem = FilterItem(OR_arrayCol.getItemAt(i));				
				if(id == or_item.id){
					or_item.selected = selected;
					OR_arrayCol.setItemAt(or_item,i)
					break; 
				};				
			}			
			for(var j:int = 0; j < AND_arrayCol.length;j++){
				var item:FilterItem = FilterItem(AND_arrayCol.getItemAt(j));
				if(id == item.id){
					item.selected = selected; 
					AND_arrayCol.setItemAt(item,j)
					break;
				};			
			}
			
		}
		private function updateFilter():void{						
			var filter_string:String = "";
			for(var i:int = 0; i < OR_arrayCol.length;i++){
				var or_item:FilterItem = FilterItem(OR_arrayCol.getItemAt(i));
				if(or_item.selected){
					if( filter_string != "") filter_string += " OR ";
					filter_string +=  or_item.data;
				} 
			}
			
			
			for(var j:int = 0; j < AND_arrayCol.length;j++){
				
				var item:FilterItem = FilterItem(AND_arrayCol.getItemAt(j));				
				if(item.selected){
					if( filter_string != "") filter_string += " AND ";
						filter_string +=  item.data;
				}				
			}
			
			
			if(_definitionFilter != filter_string){
				//dispatch filterchange event				
				_definitionFilter = filter_string;				
				dispatchEvent(new filterChangeEvent(filterChangeEvent.FILTER_CHANGE,false,false,_definitionFilter));
			}
		}
		private function updateLocale(event:Event):void{
	    	for (var i:int = 0; i < groupLabels.length; i ++){
	    		Label(groupLabels.getItemAt(i)["label"]).text = resourceManager.getString("FilterAllWidgetStrings", groupLabels.getItemAt(i)["localekey"])			    	
	    	}
	    	for (var j:int = 0; j < Controls_arr.length; j ++){
	    		if(Controls_arr.getItemAt(j)["item"] is Label){
	    			Label(Controls_arr.getItemAt(j)["item"]).text = resourceManager.getString("FilterAllWidgetStrings", Controls_arr.getItemAt(j)["localekey"]) || Controls_arr.getItemAt(j)["localekey"];;	    	
	    		}
	    		else if(Controls_arr.getItemAt(j)["item"] is CheckBox){
	    			CheckBox(Controls_arr.getItemAt(j)["item"]).label = resourceManager.getString("FilterAllWidgetStrings", Controls_arr.getItemAt(j)["localekey"]) || Controls_arr.getItemAt(j)["localekey"];
	    		}
	    		  			    	
	    	}	
	    	    	
	    }	

	}
}