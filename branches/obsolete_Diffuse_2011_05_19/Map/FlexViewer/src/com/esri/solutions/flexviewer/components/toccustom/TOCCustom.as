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

package com.esri.solutions.flexviewer.components.toccustom
{
	
	import com.esri.ags.Map;
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.solutions.flexviewer.ConfigData;
	import com.esri.solutions.flexviewer.components.legendicon;
	import com.esri.solutions.flexviewer.components.toc.utils.MapUtil;
	import com.esri.solutions.flexviewer.components.toccustom.toccustomclasses.TocCustomItem;
	import com.esri.solutions.flexviewer.components.toccustom.toccustomclasses.TocCustomItemRenderer;
	import com.esri.solutions.flexviewer.components.toccustom.toccustomclasses.TocCustomMapLayerItem;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ListEvent;
	import mx.graphics.ImageSnapshot;
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	//[IconFile("toc.gif")]
	
	/**
	 * A tree-based Table of Contents component for a Map.
	 */

	public class TOCCustom extends Tree
	{
		/**
		 * Creates a new TOC object.
		 * 
		 * @param map The map that is linked to this TOC.
		 */
		 

		public function TOCCustom( map:Map = null )
		{
			super();
			
			variableRowHeight = true;
			
			dataProvider = _tocRoots;
			itemRenderer = new ClassFactory(TocCustomItemRenderer);
			iconFunction = tocItemIcon;
			linkFunction = tocItemLink;
			coFilterFunction = tocItemCoFilter;
			
			this.map = map;
			
			
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
			
			//addEventListener(Event.ADDED, openTree);
			
			selectable = false;
			
			// Set default styles
			setStyle("borderStyle", "none");
			setStyle("layerIcon", _layerIcon);
			setStyle("groupLayerIcon", _groupLayerIcon);
			setStyle("mapServiceIcon", _mapServiceIcon);			
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		// The tree data provider
		private var _tocRoots:ArrayCollection = new ArrayCollection(); // of TocItem
		
		private var _map:Map;
		private var _mapChanged:Boolean = false;
		
		public var setLayersVisibility:Function;
		public var setLayersDefinition:Function;
		public var linkFunction:Function;
		public var coFilterFunction:Function;
		private var _configData:ConfigData;
		private var _labelAlias:String;
		private var _labelAliasObj:Object;
		
		// Layer list filters
		private var _includeLayers:ArrayCollection;
		private var _excludeLayers:ArrayCollection;		
		private var _excludeSingleLayers:ArrayCollection;
		private var _excludeGraphicsLayers:Boolean = false;
		private var _layerFiltersChanged:Boolean = false;
		private var _showLayersInMapservice:Boolean = true;
		private var _excludeLayersInMapservice:Object = new Object();

		
		//used for printing
		public var hideCheckBoxes:Boolean;
		
		
		// Label function for TocMapLayerItem
		private var _labelFunction:Function = null;
		private var _labelFunctionChanged:Boolean = false;
		
		// The effect used on layer show/hide
		private var _fade:Effect;
		private var _fadeDuration:Number = 250; // milliseconds
		private var _useLayerFadeEffect:Boolean = false;
		private var _useLayerFadeEffectChanged:Boolean = false;
		
		private var shapeIconPresent:Boolean = false;
		
		[Embed(source="com/esri/solutions/flexviewer/assets/images/toc/layer.png")]
		private var _layerIcon:Class;
		
		[Embed(source="com/esri/solutions/flexviewer/assets/images/toc/group-layer.png")]
		private var _groupLayerIcon:Class;
		
		[Embed(source="com/esri/solutions/flexviewer/assets/images/toc/map-service.png")]
		private var _mapServiceIcon:Class;
		
		
		
		//--------------------------------------------------------------------------
		//  Property:  map
		//--------------------------------------------------------------------------
		
		[Bindable("mapChanged")]
		/**
		 * The Map to which this TOC is attached.
		 */
		public function get map():Map {
			return _map;
		}
		public function get configData():ConfigData {
			return _configData;
		}
		public function set configData(configData:ConfigData):void {
			_configData = configData;
			shapeIconPresent = false;
		}
		
		/*public function get labelAlias():String {
			return _labelAlias;
		}
		public function set labelAlias(labelAlias:String):void {
			_labelAlias = labelAlias;
			if(!_labelAliasObj){ 
				_labelAliasObj = new Object();
			}
			var llabels:Array = _labelAlias.split(";");
			for(var i:int = 0; i < llabels.length; i++){
				var llabel:Array = String(llabels[i]).split(":");
				_labelAliasObj[llabel[0]] = llabel[1];
			}
			Application.application.labelAlias = _labelAliasObj;
		}*/
		
		/**
		 * @private
		 */
		public function set map( value:Map ):void {
			if (value != _map) {
				removeMapListeners();
				_map = value;
				addMapListeners();
				
				_mapChanged = true;
				invalidateProperties();
				
				dispatchEvent(new Event("mapChanged"));
			}
		}
		
		//--------------------------------------------------------------------------
		//  Property:  includeLayers
		//--------------------------------------------------------------------------
		
		[Bindable("includeLayersChanged")]
		/**
		 * A list of layer objects and/or layer IDs to include in the TOC.
		 */
		public function get includeLayers():Object {
			return _includeLayers;
		}
		/**
		 * @private
		 */
		public function set includeLayers( value:Object ):void {
			removeLayerFilterListeners(_includeLayers);
			_includeLayers = normalizeLayerFilter(value);
			addLayerFilterListeners(_includeLayers);
			
			onFilterChange();
			
			dispatchEvent(new Event("includeLayersChanged"));
		}
		
		//--------------------------------------------------------------------------
		//  Property:  excludeLayers
		//--------------------------------------------------------------------------
		
		[Bindable("excludeLayersChanged")]
		/**
		 * A list of layer objects and/or layer IDs to exclude from the TOC.
		 */
		public function get excludeLayers():Object {
			return _excludeLayers;
		}
		/**
		 * @private
		 */
		public function set excludeLayers( value:Object ):void {
			removeLayerFilterListeners(_excludeLayers);
			_excludeLayers = normalizeLayerFilter(value);
			addLayerFilterListeners(_excludeLayers);
			
			onFilterChange();
			
			dispatchEvent(new Event("excludeLayersChanged"));
		}
		//--------------------------------------------------------------------------
		//  Property:  excludeSingleLayers
		//--------------------------------------------------------------------------
		
		[Bindable("excludeSingleLayersChanged")]
		/**
		 * A list of layer objects and/or layer IDs to exclude from the TOC.
		 */
		public function get excludeSingleLayers():ArrayCollection {
			return _excludeSingleLayers;
		}
		/**
		 * @private
		 */
		public function set excludeSingleLayers( value:ArrayCollection ):void {
			removeLayerFilterListeners(_excludeSingleLayers);
			_excludeSingleLayers = normalizeLayerFilter(value);
			addLayerFilterListeners(_excludeSingleLayers);
			
			onFilterChange();
			
			dispatchEvent(new Event("excludeSingleLayersChanged"));
		}
		//--------------------------------------------------------------------------
		//  Property:  excludeGraphicsLayers
		//--------------------------------------------------------------------------
		
		[Bindable]
		[Inspectable(category="Mapping", defaultValue="false")]
		/**
		 * Whether to exclude all GraphicsLayer map layers from the TOC.
		 * 
		 * @default false
		 */
		public function get excludeGraphicsLayers():Boolean {
			return _excludeGraphicsLayers;
		}
		/**
		 * @private
		 */
		public function set excludeGraphicsLayers( value:Boolean ):void {
			_excludeGraphicsLayers = value;
			
			onFilterChange();
		}
		//--------------------------------------------------------------------------
		//  Property:  showLayersInMapservice
		//--------------------------------------------------------------------------
		
		[Bindable]
		[Inspectable(category="Mapping", defaultValue="true")]
		/**
		 * Whether to show all map layers as children of the mapservices in the TOC.
		 * 
		 * @default true
		 */
		public function get showLayersInMapservice():Boolean {
			return _showLayersInMapservice;
		}
		/**
		 * @private
		 */
		public function set showLayersInMapservice( value:Boolean ):void {
			_showLayersInMapservice = value;
			
		}
		//--------------------------------------------------------------------------
		//  Property:  excludeLayersInMapservice
		//--------------------------------------------------------------------------
		
		[Bindable]
		[Inspectable(category="Mapping", defaultValue="true")]
		/**
		 * Whether to show all map layers as children of the mapservices in the TOC.
		 * 
		 * @default true
		 */
		public function get excludeLayersInMapservice():Object {
			return _excludeLayersInMapservice;
		}
		/**
		 * @private
		 */
		public function set excludeLayersInMapservice( value:Object ):void {
			_excludeLayersInMapservice = value;
			
		}
		//--------------------------------------------------------------------------
		//  Property:  labelFunction
		//--------------------------------------------------------------------------
		
		/**
		 * A label function for map layers.
		 * 
		 * The function signature must be: <code>labelFunc( layer : Layer ) : String</code>
		 */
		override public function set labelFunction( value:Function ):void
		{
			// CAUTION: We are overriding the semantics and method signature of the 
			//   super Tree's labelFunction, so do not set the super.labelFunction property.
			//
			//   Also, we must reference the function using "_labelFunction" instead of
			//   "labelFunction" since the latter will call the getter method on Tree, 
			//   rather than grabbing this TOC's instance variable.
			
			_labelFunction = value;
			
			_labelFunctionChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//  Property:  useLayerFadeEffect
		//--------------------------------------------------------------------------
		
		[Bindable("useLayerFadeEffectChanged")]
		[Inspectable(category="Mapping", defaultValue="false")]
		/**
		 * Whether to use a Fade effect when the map layers are shown or hidden.
		 * 
		 * @default false
		 */
		public function get useLayerFadeEffect():Boolean {
			return _useLayerFadeEffect;
		}
		/**
		 * @private
		 */
		public function set useLayerFadeEffect( value:Boolean ):void {
			if (value != _useLayerFadeEffect) {
				_useLayerFadeEffect = value;
				
				_useLayerFadeEffectChanged = true;
				invalidateProperties();
				
				dispatchEvent(new Event("useLayerFadeEffectChanged"));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_mapChanged || _layerFiltersChanged || _labelFunctionChanged) {
				_mapChanged = false;
				_layerFiltersChanged = false;
				_labelFunctionChanged = false;
				
				// Repopulate the TOC data provider
				registerAllMapLayers();
			}
			
			if (_useLayerFadeEffectChanged) {
				_useLayerFadeEffectChanged = false;
				
				MapUtil.forEachMapLayer(map, function( layer:Layer ):void {
					setLayerFadeEffect(layer);
				});
			}
		}
		
		private function addMapListeners():void
		{
			if (map) {
				map.addEventListener(MapEvent.LAYER_ADD, onLayerAdd, false, 0, true);
				map.addEventListener(MapEvent.LAYER_REMOVE, onLayerRemove, false, 0, true);
				map.addEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll, false, 0, true);
				map.addEventListener(MapEvent.LAYER_REORDER, onLayerReorder, false, 0, true);
			}
		}
		
		private function removeMapListeners():void
		{
			if (map) {
				map.removeEventListener(MapEvent.LAYER_ADD, onLayerAdd);
				map.removeEventListener(MapEvent.LAYER_REMOVE, onLayerRemove);
				map.removeEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll);
				map.removeEventListener(MapEvent.LAYER_REORDER, onLayerReorder);
			}
		}
		
		/**
		 * Registers the new map layer in the TOC tree.
		 */
		private function onLayerAdd( event:MapEvent ):void
		{
			registerMapLayer(event.layer);
		}
		
		private function onLayerRemove( event:MapEvent ):void
		{
			unregisterMapLayer(event.layer);
		}
		
		private function onLayerRemoveAll( event:MapEvent ):void
		{
			unregisterAllMapLayers();
		}
		
		private function onLayerReorder( event:MapEvent ):void
		{
			var layer:Layer = event.layer;
			var index:int = event.index;
			
			for (var i:int = 0; i < _tocRoots.length; i++) {
				var item:Object = _tocRoots[i];
				if (item is TocCustomMapLayerItem && TocCustomMapLayerItem(item).layer === layer) {
					_tocRoots.removeItemAt(i);
					_tocRoots.addItemAt(item, _tocRoots.length - index - 1);
					break;
				}
			}
		}
		
		private function unregisterAllMapLayers():void
		{
			_tocRoots.removeAll();
		}
		
		private function unregisterMapLayer( layer:Layer ):void
		{
			for (var i:int = 0; i < _tocRoots.length; i++) {
				var item:Object = _tocRoots[i];
				if (item is TocCustomMapLayerItem && TocCustomMapLayerItem(item).layer === layer) {
					_tocRoots.removeItemAt(i);
					break;
				}
			}
		}
		
		/**
		 * Registers all existing map layers in the TOC tree.
		 */
		private function registerAllMapLayers():void
		{
			unregisterAllMapLayers();
			
			MapUtil.forEachMapLayer(map, function( layer:Layer ):void {
				registerMapLayer(layer);
			});
			//openTree();
		}
		
		/**
		 * Creates a new top-level TOC item for the specified map layer.
		 */
		private function registerMapLayer( layer:Layer ):void
		{
			if (filterOutLayer(layer)) {
				//trace("Filtering out TOC layer '" + layer.id + "'");
				return;
			}
			
			// Init any layer properties, styles, and effects
			if (useLayerFadeEffect) {
				setLayerFadeEffect(layer);
			}
			
			// Add a new top-level TOC item at the beginning of the list (reverse rendering order)
		//	var tocItem:TocCustomMapLayerItem = new TocCustomMapLayerItem(layer, _labelFunction);
			var legend:String;
			var turnoff:String;
			var layerLegends:Object;
			for(var i:int = 0; i < _configData.configMap.length; i ++){
				if(_configData.configMap[i].id == layer.id){
					legend = _configData.configMap[i].legend;
					turnoff = _configData.configMap[i].turnOff;
				}
			}
			
			layerLegends = _configData.configLayerLegends[layer.id];
			var showTheLayers:Boolean = showLayersInMapservice;	
			if(_excludeLayersInMapservice && _excludeLayersInMapservice[layer.id] == false)	
			{
				showTheLayers = _excludeLayersInMapservice[layer.id] 
			}
			var tocItem:TocCustomMapLayerItem = new TocCustomMapLayerItem(layer, _labelFunction,linkFunction,coFilterFunction, showTheLayers,excludeSingleLayers,legend,turnoff,layerLegends);
			_tocRoots.addItemAt(tocItem, 0);
			
			//trace("Adding TOC layer '" + layer.id + "' as '" + tocItem.label + "'");
		}
		
		private function setLayerFadeEffect( layer:Layer ):void
		{
			if (useLayerFadeEffect) {
				// Lazy load the effect
				if (!_fade) {
					_fade = new Fade();
					_fade.duration = _fadeDuration;
				}
				layer.setStyle("showEffect", _fade);
				layer.setStyle("hideEffect", _fade);
			} else {
				layer.clearStyle("showEffect");
				layer.clearStyle("hideEffect");
			}
		}
		
		private function addLayerFilterListeners( filter:ArrayCollection ):void
		{
			if (filter) {
				filter.addEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange, false, 0, true);
			}
		}
		
		private function removeLayerFilterListeners( filter:ArrayCollection ):void
		{
			if (filter) {
				filter.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange);
			}
		}
		
		private function onFilterChange( event:CollectionEvent = null ):void
		{
			var isValidChange:Boolean = false;
			
			if (event == null) {
				// Called directly from the setters
				isValidChange = true;
			} else {
				// Only act on certain kinds of collection changes.
				//  Specifically, avoid acting on the UPDATE kind.
				//   It causes unwanted refresh of the TOC model.
				switch (event.kind) {
					case CollectionEventKind.ADD:
					case CollectionEventKind.REMOVE:
					case CollectionEventKind.REPLACE:
					case CollectionEventKind.REFRESH:
					case CollectionEventKind.RESET:
						isValidChange = true;
				}
			}
			
			if (isValidChange) {
				_layerFiltersChanged = true;
				invalidateProperties();
			}
		}
		
		private function filterOutLayer( layer:Layer ):Boolean
		{
			var exclude:Boolean = false;
			if (excludeGraphicsLayers && layer is GraphicsLayer) {
				exclude = true;
			}
			if (!exclude && excludeLayers) {
				exclude = false;
				for each (var item:* in excludeLayers) {
					if (item === layer || item == layer.id) {
						exclude = true;
						break;
					}
				}
			}
			if (includeLayers) {
				exclude = true;
				for each (item in includeLayers) {
					if (item === layer || item == layer.id) {
						exclude = false;
						break;
					}
				}
			}
			return exclude;
		}
		
		private function normalizeLayerFilter( value:Object ):ArrayCollection
		{
			var filter:ArrayCollection;
			if (value is ArrayCollection) {
				filter = value as ArrayCollection;
			} else if (value is Array) {
				filter = new ArrayCollection(value as Array);
			} else if (value is String || value is Layer) {
				// Possibly a String (layer id) or Layer object
				filter = new ArrayCollection([value]);
			} else {
				// Unsupported value type
				filter = null;
			}
			return filter;
		}
		
		/**
		 * Double click handler for expanding or collapsing a tree branch.
		 */
		private function onItemDoubleClick( event:ListEvent ):void
		{
			if (event.itemRenderer && event.itemRenderer.data) {
				var item:Object = event.itemRenderer.data;
				expandItem(item, !isItemOpen(item), true, true, event);
			}
		}
		private function getToplevelParent(item:TocCustomItem):TocCustomItem { 
			if(!item.isTopLevel()){
				return getToplevelParent(item.parent);
			}
			return item;
		
		}
		private function tocItemIcon( item:Object ):Class
		{
		
			if (item is TocCustomMapLayerItem) {
				var mtopLevelParent:TocCustomItem = getToplevelParent(TocCustomItem(item));
				if(configData.configDynLayerIcons[mtopLevelParent.id] && configData.configDynLayerIcons[mtopLevelParent.id]["iconShape"]){
					shapeIconPresent = true;
					TocCustomItem(item).size = configData.configDynLayerIcons[mtopLevelParent.id]["iconSize"];	
					TocCustomItem(item).color = configData.configDynLayerIcons[mtopLevelParent.id]["iconColor"];										
					var mlegendIcon:legendicon = new legendicon();
					mlegendIcon.shape = configData.configDynLayerIcons[mtopLevelParent.id]["iconShape"];						
					return mlegendIcon.legendShape;				
				}
				return getStyle("mapServiceIcon");
			}
			if (item is TocCustomItem) {			 
				
				var topLevelParent:TocCustomItem = getToplevelParent(TocCustomItem(item));
				if(configData.configDynLayerIcons[topLevelParent.id]){
					if(configData.configDynLayerIcons[topLevelParent.id][TocCustomItem(item).id]){
						shapeIconPresent = true;
						TocCustomItem(item).size = configData.configDynLayerIcons[topLevelParent.id][TocCustomItem(item).id]["iconSize"];	
						TocCustomItem(item).color = configData.configDynLayerIcons[topLevelParent.id][TocCustomItem(item).id]["iconColor"];										
						var legendIcon:legendicon = new legendicon();
						legendIcon.shape = configData.configDynLayerIcons[topLevelParent.id][TocCustomItem(item).id]["iconShape"];						
						return legendIcon.legendShape;
					}					
				}
				
				if( TocCustomItem(item).isGroupLayer())	return getStyle("groupLayerIcon");
			}
			return getStyle("layerIcon");
		}
		
		private function tocItemLink( item:Object ):String{
			if (item is TocCustomItem) {
				var topLevelParent:TocCustomItem = getToplevelParent(TocCustomItem(item));
				var _link:String = "";				
				if(configData.configLayerLink[topLevelParent.id]){
					
					if (item is TocCustomMapLayerItem) {
						_link = configData.configLayerLink[topLevelParent.id]["layerLink"];
					}
					else if(configData.configLayerLink[topLevelParent.id][TocCustomItem(item).id]){
						
						_link = configData.configLayerLink[topLevelParent.id][TocCustomItem(item).id]["layerLink"];
					}					
				}
			}
			return _link;
		}
		private function tocItemCoFilter( item:Object ):String{
			if (item is TocCustomItem) {
				var topLevelParent:TocCustomItem = getToplevelParent(TocCustomItem(item));
				var _cofilter:String = null;				
				if(configData.configLayerLink[topLevelParent.id]){
					
					if (item is TocCustomMapLayerItem) {
						_cofilter = configData.configLayerLink[topLevelParent.id]["cofilter"];
					}
					else if(configData.configLayerLink[topLevelParent.id][TocCustomItem(item).id]){
						
						_cofilter= configData.configLayerLink[topLevelParent.id][TocCustomItem(item).id]["cofilter"];
					}					
				}
			}
			return _cofilter;
		}
		
		public function prettyPrint():BitmapData{
			
			if(shapeIconPresent && ArrayCollection(this.dataProvider).length > 0){
				var oldwidth:Number = this.width;
				this.hideCheckBoxes = true;
				this.updateDisplayList(oldwidth-2,500);
				
				//crop expand arrows
				var rect:Rectangle = getBounds(this);
				rect.offset(35,0);				
				rect.width = this.width - 35;
				
				var thisBitmap:BitmapData = cropOutWhitespace( ImageSnapshot.captureBitmapData(this,null,null,null,rect));
				this.hideCheckBoxes = false;			
				this.updateDisplayList(oldwidth,500);
				return thisBitmap;
			}
			
			return null;
		}
		private function cropOutWhitespace(bmd:BitmapData):BitmapData
		{
		    var rect:Rectangle = bmd.getColorBoundsRect(0xFFFFFFFF, 0x00000000, false);		    
		    var croppedBmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
		    croppedBmd.draw(bmd, new Matrix(1,0,0,1, -rect.x, -rect.y));
		    return(croppedBmd);
		}
		public function openTree():void
		{
			this.openItems = this.dataProvider;	
			      
		}
	}
	
	

}
