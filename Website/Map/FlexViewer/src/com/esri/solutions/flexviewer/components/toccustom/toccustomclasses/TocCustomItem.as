////////////////////////////////////////////////////////////////////////////////
//
// Copyright © 2008 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/FlexViewer/License.txt
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.solutions.flexviewer.components.toccustom.toccustomclasses
{
	
	import com.esri.solutions.flexviewer.AppUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectUtil;
	
	/**
	 * The base TOC item.
	 */
	public class TocCustomItem extends EventDispatcher
	{
		public function TocCustomItem( parentItem:TocCustomItem = null )
		{
			_parent = parentItem;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  parent
		//--------------------------------------------------------------------------
		
		private var _parent:TocCustomItem;
		
		/**
		 * The parent TOC item of this item.
		 */
		public function get parent():TocCustomItem
		{
			return _parent;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  children
		//--------------------------------------------------------------------------
		
		[Bindable]
		/**
		 * The child items of this TOC item.
		 */
		public var children:ArrayCollection; // of TocItem
		
		/**
		 * Adds a child TOC item to this item.
		 */
		internal function addChild( item:TocCustomItem ):void
		{
			if (!children) {
				children = new ArrayCollection();
			}
			children.addItem(item);
		}
		//--------------------------------------------------------------------------
		//  Property:  id
		//--------------------------------------------------------------------------
		
		
		
		private var _id:String;
		
		[Bindable("propertyChange")]
		/**
		 * The text label for the item renderer.
		 */
		public function get id():String
		{
			return _id;
		}
		/**
		 * @private
		 */
		public function set id( value:String ):void
		{
			var oldValue:Object = _id;
			_id = value ;
			
			// Dispatch a property change event to notify the item renderer
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", oldValue, _label));
		}
		//--------------------------------------------------------------------------
		//  Property:  label
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_LABEL:String = "(Unknown)";
		
		private var _label:String = DEFAULT_LABEL;
		
		[Bindable("propertyChange")]
		/**
		 * The text label for the item renderer.
		 */
		public function get label():String
		{
			return _label;
		}
		/**
		 * @private
		 */
		public function set label( value:String ):void
		{
			var oldValue:Object = _label;
			_label = (value ? value : DEFAULT_LABEL);
			
			// Dispatch a property change event to notify the item renderer
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", oldValue, _label));
		}
		
			//--------------------------------------------------------------------------
		//  Property:  legend - url for legend image
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_LEGEND:String = "";
		
		private var _legend:String = DEFAULT_LEGEND;
		
		[Bindable]
		/**
		 * The legend url for the item renderer.
		 */
		public function get legend():String
		{
			return _legend;
		}
		/**
		 * @private
		 */
		public function set legend( value:String ):void
		{
			var oldValue:Object = _legend;
			_legend = (value ? value : DEFAULT_LEGEND);
		}
			//--------------------------------------------------------------------------
		//  Property:  legend id- id for legend image
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_LEGENDID:String = "";
		
		private var _legendId:String = DEFAULT_LEGEND;
		
		[Bindable]
		/**
		 * The legend url for the item renderer.
		 */
		public function get legendId():String
		{
			return _legendId;
		}
		/**
		 * @private
		 */
		public function set legendId( value:String ):void
		{
			var oldValue:Object = _legend;
			_legendId = (value ? value : DEFAULT_LEGENDID);
		}
		//--------------------------------------------------------------------------
		//  Property:  icon shape
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_SHAPE:String = "(Unknown)";
		
		private var _shape:String = DEFAULT_SHAPE;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get shape():String
		{
			return _shape;
		}
		/**
		 * @private
		 */
		public function set shape( value:String ):void
		{
			_shape = value;
		}
		
		
		//--------------------------------------------------------------------------
		//  Property:  icon size
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_SIZE:int = 0;
		
		private var _size:int = DEFAULT_SIZE;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get size():int
		{
			return _size;
		}
		/**
		 * @private
		 */
		public function set size( value:int ):void
		{
			_size = value;
		}
		//--------------------------------------------------------------------------
		//  Property:  icon color
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_COLOR:uint = 0;
		
		private var _color:uint = DEFAULT_COLOR;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get color():uint
		{
			return _color;
		}
		/**
		 * @private
		 */
		public function set color( value:uint ):void
		{
			_color = value;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  layer link
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_LINK:String = "";
		
		private var _link:String = DEFAULT_LINK;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get link():String
		{
			return _link;
		}
		/**
		 * @private
		 */
		public function set link( value:String ):void
		{
			_link = value;
		}
		//--------------------------------------------------------------------------
		//  Property:  layer cofilter - call setAllLayerDefinition(cofilter) when switching on this layer
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_COFILTER:String = null;
		
		private var _cofilter:String = DEFAULT_COFILTER;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get cofilter():String
		{
			return _cofilter;
		}
		/**
		 * @private
		 */
		public function set cofilter( value:String ):void
		{
			_cofilter = value;
		}
		//--------------------------------------------------------------------------
		//  Property:  layer turnOff - turn these mapservices off when turning this on
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_TURNOFF:String = null;
		
		private var _turnoff:String = DEFAULT_TURNOFF;
		
		
		/**
		 * The text label for the item renderer.
		 */
		public function get turnoff():String
		{
			return _turnoff;
		}
		/**
		 * @private
		 */
		public function set turnoff( value:String ):void
		{
			_turnoff = value;
		}
		//--------------------------------------------------------------------------
		//  Property:  item image (not icon)
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_IMAGE:String = "(Unknown)";
		
		private var _image:String = DEFAULT_IMAGE;
		
		
		/**
		 * The image for the item renderer.
		 */
		public function get image():String
		{
			return _image;
		}
		/**
		 * @private
		 */
		public function set image( value:String ):void
		{
			_image = value;
		}
		//--------------------------------------------------------------------------
		//  Property:  visible
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_VISIBLE:Boolean = true;
		
		private var _visible:Boolean = DEFAULT_VISIBLE;
		
		[Bindable("propertyChange")]
		/**
		 * Whether the map layer referred to by this TOC item is visible or not.
		 */
		public function get visible():Boolean
		{
			return _visible;
		}
		/**
		 * @private
		 */
		public function set visible( value:Boolean ):void
		{
			setVisible(value, true);
		}
		
		/**
		 * Allows subclasses to change the visible state without causing a layer refresh.
		 */
		internal function setVisible( value:Boolean, layerRefresh:Boolean = true ):void
		{
		
			if(value  && legend != "" && legendId != "" )
			{
				if((!isTopLevel() && getToplevelParent().visible) || isTopLevel() )
				{
					AppUtil.setLegendImage("add", "", legend,legendId);
				}
				
			} 
			else if(legendId)
			{
				AppUtil.setLegendImage("remove", "", "",legendId);
			} 
			
			if (value != _visible) {
				var oldValue:Object = _visible;
				_visible = value;
				
				updateIndeterminateState();
				if (layerRefresh) {
					refreshLayer();
				}
				
				
				
				// Dispatch a property change event to notify the item renderer
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", oldValue, value));
			}
		}
		
		private function setVisibleDirect( value:Boolean ):void
		{
			if(value  && legend != "" && legendId != "" )
			{
				if((!isTopLevel() && getToplevelParent().visible) || isTopLevel() )
				{
					AppUtil.setLegendImage("add", "", legend,legendId);
				}
			} 
			else if(legendId)
			{
				AppUtil.setLegendImage("remove", "", "",legendId);
			} 
			if (value != _visible) {
				var oldValue:Object = _visible;
				_visible = value;
				
				
				
				// Dispatch a property change event to notify the item renderer
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", oldValue, value));
			}
		}
		
		//--------------------------------------------------------------------------
		//  Property:  indeterminate
		//--------------------------------------------------------------------------
		
		internal static const DEFAULT_INDETERMINATE:Boolean = false;
		
		private var _indeterminate:Boolean = DEFAULT_INDETERMINATE;
		
		[Bindable("propertyChange")]
		/**
		 * Whether the visibility of this TOC item is in a mixed state,
		 * based on child item visibility or other criteria.
		 */
		public function get indeterminate():Boolean
		{
			return _indeterminate;
		}
		/**
		 * @private
		 */
		public function set indeterminate( value:Boolean ):void
		{
			if (value != _indeterminate) {
				var oldValue:Object = _indeterminate;
				_indeterminate = value;
				
				// Dispatch a property change event to notify the item renderer
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "indeterminate", oldValue, value));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Whether this TOC item is at the root level.
		 */
		public function isTopLevel():Boolean
		{
			return _parent == null;
		}
		
		public function getToplevelParent():TocCustomItem { 
			if(!isTopLevel()){
				return _parent.getToplevelParent();
			}
			return this;
		
		}
		/**
		 * Whether this TOC item contains any child items.
		 */
		public function isGroupLayer():Boolean
		{
			return children && children.length > 0;
		}
		
		/**
		 * Updates the indeterminate visibility state of this TOC item.
		 */
		internal function updateIndeterminateState( calledFromChild:Boolean = false ):void
		{
			// Inspect the visibility of the children
			var vis:Boolean = false;
			var invis:Boolean = false;
			for each (var item:TocCustomItem in children) {
				if (item.indeterminate) {
					vis = invis = true;
					break;
				} else if (item.visible) {
					vis = true;
				} else {
					invis = true;
				}
			}
			indeterminate = (vis && invis);
			
			// Special case for when children are all shown or all hidden
			if (calledFromChild) {
				if (vis && !invis) {
					setVisibleDirect(true);
				} else if (!vis && invis) {
					setVisibleDirect(false);
				}
			}
			
			// Recurse up the tree
			if (parent) {
				parent.updateIndeterminateState(true);
			}
		}
		
		/**
		 * Invalidates any map layer that is associated with this TOC item.
		 */
		internal function refreshLayer():void
		{
			// Recurse up the tree
			if (parent) {
				parent.refreshLayer();
			}
		}
		
		override public function toString():String
		{
			return ObjectUtil.toString(this);
		}
	}

}
