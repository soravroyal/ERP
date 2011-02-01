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
	
	import com.esri.ags.layers.TiledMapServiceLayer;
	import com.esri.solutions.flexviewer.components.*;
	import com.esri.solutions.flexviewer.components.toc.controls.CheckBoxIndeterminate;
	import com.esri.solutions.flexviewer.components.toccustom.TOCCustom;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Button;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.resources.ResourceManager;
	/**
	 * A custom tree item renderer for a map Table of Contents.
	 */
	public class TocCustomItemRenderer extends TreeItemRenderer
	{
		// Renderer UI components
		private var _checkbox:CheckBoxIndeterminate;
		private var info_btn:Button;
		private var listOwner:TOCCustom;
		
		[Embed(source="/com/esri/solutions/flexviewer/assets/images/icons/i_info_small.png")]			
		[Bindable]
		public var infoIconCls:Class;

		
		// UI component spacing
		private static const PRE_CHECKBOX_GAP:Number = 5;
		private static const POST_CHECKBOX_GAP:Number = 4;
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// Create a checkbox child component for toggling layer visibility.
			if (!_checkbox) {
				_checkbox = new CheckBoxIndeterminate();
				_checkbox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
				_checkbox.addEventListener(MouseEvent.DOUBLE_CLICK, onCheckBoxDoubleClick);
				_checkbox.addEventListener(MouseEvent.MOUSE_DOWN, onCheckBoxMouseDown);
				_checkbox.addEventListener(MouseEvent.MOUSE_UP, onCheckBoxMouseUp);
				addChild(_checkbox);
			}
			if(!info_btn){
				info_btn = new Button();
				info_btn.visible = false;
				info_btn.setStyle("icon",infoIconCls);
				info_btn.width = 10;
				info_btn.height = 10;
				info_btn.addEventListener(MouseEvent.CLICK,openInfo);
				addChild(info_btn);
			}
			label.wordWrap = true;
			label.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
		
			if (data is TocCustomItem) {
				var item:TocCustomItem = TocCustomItem(data);
				
				// Set the checkbox state
				_checkbox.indeterminate = item.indeterminate;
				// The indeterminate state has visual priority over the selected state
				_checkbox.selected = item.visible && !item.indeterminate;
				
				// Hide the checkbox for child items of tiled map services
				var checkboxVisible:Boolean = true;
			
				if (isTiledLayerChild(item) || TOCCustom(parent.parent).hideCheckBoxes) {
					checkboxVisible = false;
				}
				_checkbox.visible = checkboxVisible;
				
				// Apply a bold label style to root nodes
				if (item.isTopLevel()) {
					setStyle("fontWeight", "bold");
				} else {
					setStyle("fontWeight", "normal");
				}
				

			}
		}
		
		/**
		 * @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			// Add space for the checkbox and gaps
			if (isNaN(explicitWidth) && !isNaN(measuredWidth)) {
				var w:Number = measuredWidth;
				w += _checkbox.measuredWidth;
				w += PRE_CHECKBOX_GAP + POST_CHECKBOX_GAP;
				measuredWidth = w;
			}
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var startx:Number = data ? TreeListData(listData).indent : 0;
				
			if (icon) {
				startx = icon.x;
			} else if (disclosureIcon) {
				startx = disclosureIcon.x + disclosureIcon.width;
			}
			startx += PRE_CHECKBOX_GAP;
			
			// Position the checkbox between the disclosure icon and the item icon
			_checkbox.x = startx;
			_checkbox.setActualSize(_checkbox.measuredWidth, _checkbox.measuredHeight);
			_checkbox.y = (unscaledHeight - _checkbox.height) / 2;
			startx = _checkbox.x + _checkbox.width + POST_CHECKBOX_GAP;
			
			if (icon) {
				icon.x = startx;
				startx = icon.x + icon.width;
			}
			if (data is TocCustomItem)
			{
				listOwner = TOCCustom(this.listData.owner);
				var item:TocCustomItem = TocCustomItem(data);
				var labeltxt:String = ResourceManager.getInstance().getString("FilterAllWidgetStrings", item.id);
				if (labeltxt && labeltxt != label.text){
					label.text = ResourceManager.getInstance().getString("FilterAllWidgetStrings", item.id);		
				}
			
				if (icon is ShapeSymbol)
				 {						
					var shIcon:ShapeSymbol =  ShapeSymbol(icon);			
					shIcon.size = item.size;
					shIcon.color = item.color;
					shIcon.drawme();
					shIcon.setActualSize(shIcon.measuredWidth,  shIcon.measuredHeight);	
					shIcon.y = (unscaledHeight - shIcon.height) / 2;				 
				 }
				 if (item.link != "" && item.link != null)
				 {
				 	info_btn.visible = true;
				 	info_btn.label = "info";
				 	info_btn.data = item.link;			 	
				 	
				 }				 
				 else
				 {
				 		info_btn.visible = false;
				 }
				 
				 
						
			}			
			
			label.x = startx;
			label.wordWrap = true;
			label.autoSize = TextFieldAutoSize.LEFT;						
			label.setActualSize(unscaledWidth - startx, measuredHeight);
			label.y = (unscaledHeight - label.height) / 2;	
			info_btn.x = label.x + label.width - info_btn.width;
			info_btn.y = label.y;
			
		}
		
		/**
		 * Whether the specified TOC item is a child of a tiled map service layer.
		 */
		private function isTiledLayerChild( item:TocCustomItem ):Boolean
		{
			while (item) {
				item = item.parent;
				if (item is TocCustomMapLayerItem) {
					if (TocCustomMapLayerItem(item).layer is TiledMapServiceLayer) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Updates the visible property of the underlying TOC item.
		 */
	   	private function onCheckBoxClick( event:MouseEvent ):void
	   	{
	   		event.stopPropagation();
	   		
	   		if (data is TocCustomItem) {
				var item:TocCustomItem = TocCustomItem(data);
				item.visible = _checkbox.selected;
				
				
				if(item.visible && item.cofilter != null && item.cofilter != ""){
	   				listOwner.setLayersDefinition(item.cofilter);		 	
	   			}else if (item.cofilter != null  && item.cofilter != ""){
	   				listOwner.setLayersDefinition("");	
	   			}
	   			
	   			
	   			if (item.visible && item is TocCustomLayerInfoItem && item.parent.turnoff != null && item.parent.turnoff != "")
				 {	
				 	listOwner.invalidateList();	
				 	listOwner.setLayersVisibility(item.parent.id,item.id,item.parent.turnoff);
				 
				 }				 
				 
	   		}
	   		
		}
		
		private function onCheckBoxDoubleClick( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
		
		private function onCheckBoxMouseDown( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
		
		private function onCheckBoxMouseUp( event:MouseEvent ):void
		{
			event.stopPropagation();
		}
		
		private function openInfo(event:MouseEvent): void
		{
			var externalCallSucces:Boolean =ExternalInterface.call("openwin",Button(event.target).data.toString());
			if(!externalCallSucces){
				navigateToURL(new URLRequest(Button(event.target).data.toString()));	
				
			}
		}
	}

}
