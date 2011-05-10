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
	
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.ArcIMSMapServiceLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.layers.LayerInfo;
	import com.esri.solutions.flexviewer.AppUtil;
	import com.esri.solutions.flexviewer.components.toc.utils.MapUtil;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	/**
	 * A TOC item representing a map service or graphics layer.
	 */
	public class TocCustomMapLayerItem extends TocCustomItem
	{
		private var showLayers:Boolean;
		private var excludeSingleLayers:ArrayCollection;
		private var layerLegends:Object;
		public function TocCustomMapLayerItem( layer:Layer, labelFunction:Function = null, linkFunction:Function = null, coFilterFunction:Function = null,_showLayers:Boolean = true, excludeSingleLayers:ArrayCollection = null, legend:String = "", turnoff:String = null, layerLegends:Object = null)
		{
			super();
			
			_layer = layer;
			//set id
			id = layer.id;
			this.showLayers = _showLayers;
			this.excludeSingleLayers = excludeSingleLayers;
			this.layerLegends = layerLegends;
			// Set the initial visibility without causing a layer refresh
			setVisible(layer.visible, false);
			
			if (labelFunction == null) {
				// Default label function
				labelFunction = MapUtil.labelLayer;
			}
			_labelFunction = labelFunction;
			label = labelFunction(layer);			
			
			this.linkFunction = linkFunction;
			if (linkFunction != null) {
				link = linkFunction(this);
			}
			this.coFilterFunction = coFilterFunction;
			if (coFilterFunction != null) {
				cofilter = coFilterFunction(this);
			}
			
			this.legend = legend;
			this.turnoff = turnoff;
			
			if (layer.loaded) {
				// Process the layer info immediately
				createChildren();
			}
			
			// Listen for future layer load events
			layer.addEventListener(LayerEvent.LOAD, onLayerLoad, false, 0, true);
			
			// Listen for changes in layer visibility
			layer.addEventListener(FlexEvent.SHOW, onLayerShow, false, 0, true);
			layer.addEventListener(FlexEvent.HIDE, onLayerHide, false, 0, true);
			
			if(layer.visible && legend != "" && layer.id.search("_o") == -1)
			{
				AppUtil.setLegendImage("add",label,legend,layer.id);
			} 
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _layer:Layer;
		
		private var _labelFunction:Function;
		
		private var linkFunction:Function;
		
		private var coFilterFunction:Function;
		
		//--------------------------------------------------------------------------
		//  Property:  mapLayer
		//--------------------------------------------------------------------------
		
		/**
		 * The map layer to which this TOC item is attached.
		 */
		public function get layer():Layer
		{
			return _layer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override internal function updateIndeterminateState( calledFromChild:Boolean = false ):void
		{
			indeterminate = DEFAULT_INDETERMINATE;
			
			// Recurse up the tree
			if (parent) {
				parent.updateIndeterminateState(true);
			}
		}
		
		/**
		 * @private
		 */
		override internal function refreshLayer():void
		{
			layer.visible = visible;
			
			// ArcIMS requires layer names, whereas ArcGIS Server requires layer IDs
			var useLayerInfoName:Boolean = (layer is ArcIMSMapServiceLayer);
			
			var visLayers:Array = [];
			for each (var child:TocCustomItem in children) {
				accumVisibleLayers(child, visLayers, useLayerInfoName);
			}
			
			if (layer is ArcGISDynamicMapServiceLayer && showLayers) {
				ArcGISDynamicMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
			} else if (layer is ArcIMSMapServiceLayer) {
				ArcIMSMapServiceLayer(layer).visibleLayers = new ArrayCollection(visLayers);
			}
		}
		
		private function accumVisibleLayers( item:TocCustomItem, accum:Array, useLayerInfoName:Boolean = false ):void
		{
			if (item.isGroupLayer()) {
				// Don't include group layer IDs/names in the visible layer list, since the ArcGIS REST API
				// implicitly turns on all child layers when the group layer is visible. This goes
				// counter to what most users have come to expect from apps, e.g. ArcMap.
				for each (var child:TocCustomItem in item.children) {
					accumVisibleLayers(child, accum, useLayerInfoName);
				}
			} else {  // Leaf layer
				if (item.visible) {
					if (item is TocCustomLayerInfoItem) {
						var layer:TocCustomLayerInfoItem = TocCustomLayerInfoItem(item);
						accum.push(useLayerInfoName ? layer.layerInfo.name : layer.layerInfo.id);
					}
				}
			}
		}
		
		private function onLayerLoad( event:LayerEvent ):void
		{
			// Relabel this item, since map layer URL or service name might have changed.
			label = _labelFunction(layer);
			
			createChildren();
		}
		
		private function onLayerShow( event:FlexEvent ):void
		{			
			if(legend != "" && layer.id.search("_o") == -1) AppUtil.setLegendImage("add",label,legend,layer.id);
			
			if (layer is ArcGISDynamicMapServiceLayer && showLayers) 
			{
				
				var _mlayer:ArcGISDynamicMapServiceLayer = ArcGISDynamicMapServiceLayer(layer);
			 
				for(var i:int = 0; i < _mlayer.visibleLayers.length; i++)
				{
					var visibleLayerId:Number = _mlayer.visibleLayers[i];
					if(layerLegends && layerLegends[visibleLayerId] && _mlayer.visible)
					{
						AppUtil.setLegendImage("add", "", layerLegends[visibleLayerId].legend,_mlayer.id,visibleLayerId.toString());
					}
				}
			}
			
			setVisible(layer.visible, false);
			
		}
		
		private function onLayerHide( event:FlexEvent ):void
		{
			if(legend != "") 
			{		
				AppUtil.setLegendImage("remove",label,"",layer.id);
			}
			setVisible(layer.visible, false);
			if (layer is ArcGISDynamicMapServiceLayer && showLayers) {
				
				var _mlayer:ArcGISDynamicMapServiceLayer = ArcGISDynamicMapServiceLayer(layer);
			 	if(_mlayer.layerInfos)
			 	{
			 		for(var i:int = 0; i < _mlayer.layerInfos.length; i++)
					{
						if(layerLegends && layerLegends[i])
						{
							AppUtil.setLegendImage("remove", "", "",_mlayer.id,i.toString());
						}
					}
			 	}
				
			}
		}
		
		/**
		 * Populates this item's children collection based on any layer info
		 * of the map service.
		 */
		private function createChildren():void
		{
			children = null;
			
			var layerInfos:Array;  // of LayerInfo
			
			
			if (layer is ArcGISTiledMapServiceLayer) {
				layerInfos = ArcGISTiledMapServiceLayer(layer).layerInfos;
			} else if (layer is ArcGISDynamicMapServiceLayer) {
				layerInfos = ArcGISDynamicMapServiceLayer(layer).layerInfos;
			} else if (layer is ArcIMSMapServiceLayer) {
				layerInfos = ArcIMSMapServiceLayer(layer).layerInfos;
			}
			
			//to avoid showing layers under the mapservicelayers - try adjusting the code below.
			if (layerInfos && showLayers) {
		//	if (layerInfos) {
				var rootLayers:Array = findRootLayers(layerInfos);				
				for each (var layerInfo:LayerInfo in rootLayers) {
					var llegend:String = "";
					var llegendID:String = "";
					if(!excludeSingleLayers || excludeSingleLayers.contains(layer.id + "_" +layerInfo.name)){
						if(layerLegends && layerLegends[layerInfo.id])
						{	
							llegend = layerLegends[layerInfo.id].legend;
							llegendID = layer.id + "_" + layerInfo.id;
						} 
						var item:TocCustomLayerInfoItem = 	createTocLayer(this, layerInfo, layerInfos, this.linkFunction, this.coFilterFunction, llegend, llegendID);			
						//item.parent.visible = showLayers;
						addChild( item );			
					}		
				}
			}
		}
		
		private static function findRootLayers( layerInfos:Array ):Array  // of LayerInfo
		{
			var roots:Array = [];
			for each (var layerInfo:LayerInfo in layerInfos) {
				// ArcGIS: parentLayerId is -1
				// ArcIMS: parentLayerId is NaN
				if (isNaN(layerInfo.parentLayerId) || layerInfo.parentLayerId == -1) {
					roots.push(layerInfo);
				}
			}
			return roots;
		}
		
		private static function findLayerById( id:Number, layerInfos:Array ):LayerInfo
		{
			for each (var layerInfo:LayerInfo in layerInfos) {
				if (id == layerInfo.id) {
					return layerInfo;
				}
			}
			return null;
		}
		
		private static function createTocLayer( parentItem:TocCustomItem, layerInfo:LayerInfo, layerInfos:Array, linkFunction:Function = null, coFilterFunction:Function = null, llegend:String = "", llegendID:String = ""):TocCustomLayerInfoItem
		{
			var item:TocCustomLayerInfoItem = new TocCustomLayerInfoItem(parentItem, layerInfo, linkFunction,coFilterFunction, llegend, llegendID);

			// Handle any sublayers of a group layer
			if (layerInfo.subLayerIds) {
				for each (var childId:Number in layerInfo.subLayerIds) {
					var childLayer:LayerInfo = findLayerById(childId, layerInfos);
					if (childLayer) {
						item.addChild( createTocLayer(item, childLayer, layerInfos,linkFunction,coFilterFunction) );
					}
				}
			}
			return item;
		}
	}

}
