dojo.require("esri.layout");
dojo.require("esri.widgets");
dojo.require("esri.dijit.PopupTemplate");
dojo.require("esri.tasks.query");
dojo.require("esri.dijit.PopupMobile");
dojo.require("esri.arcgis.utils");
dojo.require("utilities.EEACreateContent");
dojo.require("dojo.Deferred");
dojo.require("dojo.DeferredList");
dojo.require("esri.dijit.Legend");
dojo.require("esri.dijit.BasemapGallery");
dojo.require("dijit.form.DropDownButton");
dojo.require("utilities.custommenu");
dojo.require("agsjs.dijit.TOC");
dojo.require("esri.dijit.Print");
dojo.require("dojo._base.array");
dojo.require("esri.tasks.PrintTemplate");
dojo.require("dojo.query");
dojo.require("esri.dijit.Geocoder");
dojo.require("esri.dijit.LocateButton");
dojo.require("esri.dijit.Bookmarks");
dojo.require("esri.dijit.OverviewMap");
dojo.require("dojox.layout.FloatingPane");
dojo.require("esri.widgets");
dojo.require("esri.toolbars.draw");
dojo.require("esri.symbols.SimpleMarkerSymbol");
dojo.require("esri.symbols.SimpleLineSymbol");
dojo.require("esri.symbols.SimpleFillSymbol");
dojo.require("dojo.parser");
dojo.require("dijit.registry");
dojo.require("esri.graphic");
dojo.require("esri.tasks.identify");
dojo.require("esri.tasks.IdentifyTask");
dojo.require("dojox.grid.DataGrid");
dojo.require("dijit.form.TextBox");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojo.data.ObjectStore");
dojo.require("dojo.store.Memory");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.Select");
dojo.require("dijit.layout.BorderContainer");
dojo.require("dijit.TitlePane");


//var map;
var map1;
var map2;
var map3;
var map4;
var options;
var appcontent;
var clickHandler, clickListener;
var toolbar;
var identifyTask, identifyParams;
 var searchGrid ;

var ReportingYear = "";

function init(initOptions) {

    options = initOptions;

    //Build the user interface for the application. In this case it's a simple app with a header and content
    appcontent = new utilities.EEACreateContent();
    appcontent.createLayout().then(function() {
        createMap();
		
    });

}

function createMap() {
    var popup = new esri.dijit.Popup({
        offsetX : 10,
        offsetY : 10,
        zoomFactor : 2
    }, dojo.create("div"));

    var mapOptions = {
        sliderStyle : "small",
        infoWindow : popup,
        logo : false	
    };
    if (appcontent._isMobile) {
        var popup = new esri.dijit.PopupMobile(null, dojo.create("div"));
        mapOptions.infoWindow = popup;
    }
    esri.config.defaults.map.width = 1000;
    esri.config.defaults.map.height= 750;
    esri.config.defaults.io.corsEnabledServers.push("sampleserver6.arcgisonline.com");
    var mapDeferred = esri.arcgis.utils.createMap(options.webmap, options.mapName + "map", {
        mapOptions : mapOptions,
        ignorePopups : true, // because we add the infowindow template to aour graphics
        bingMapsKey : options.bingmapskey,
        autoResize : true
    });
    mapDeferred.then(function (response) {
        //document.title = options.title || response.itemInfo.item.title;
        var map;
        var supportsOrientationChange = "onorientationchange" in window, orientationEvent = supportsOrientationChange ? "orientationchange" : "resize";
        //IE8 doesn't support addEventListener so check before calling
        if (window.addEventListener) {
            window.addEventListener(orientationEvent, function () {
                orientationChanged(map);
            }, false);
        }
		
		//get the popup click handler so we can disable it when search tool is active
		clickHandler = response.clickEventHandle;
		clickListener = response.clickEventListener;
		
        map = response.map;
        map.disableScrollWheelZoom();
      
	 
        switch (map.id) {
            case "map_smallmap":
                map1 = response.map;

                break;
            case "map_extendedmap":
                map2 = response.map;
                // add year selector
                addYearSelector(map2);                
                // add legend
                addLegend(response);
                // add basemap gallery
                addBasemapGalleryMenu(map2);
                // add layer list
                addLayerList(response.itemInfo.itemData.operationalLayers, map2);
				// add print options
				addPrint(map2, map2);
				// add geocode location
				createSearchTool(map2);
				// add locate button
				addLocateButton(map2);
				// add bookmarks
				addBookmarks(response);
				// add overview
				addOverview(false,map2);
				// add searches
				
				addSearchWidget(map2);
                break;
            case "map_detailsmap":              
                map3 = response.map;
                filterFacilityDetails(options.layerID, options.serviceName, "FacilityReportID = " + options.reportid)
                break;
			case "map_viewermap":
                map4 = response.map;
                // add year selector
                addYearSelector(map4);                
                // add legend
                addLegend(response);
                // add basemap gallery
                addBasemapGalleryMenu(map4);
                // add layer list
                addLayerList(response.itemInfo.itemData.operationalLayers, map4);
                // add print options
                addPrint(map4, map4);
                // add geocode location
                createSearchTool(map4);
                // add locate button
                addLocateButton(map4);
                // add bookmarks
                addBookmarks(response);
                // add overview
                addOverview(false,map4);
                // add searches
                
                addSearchWidget(map4);
        }

        var layers = response.itemInfo.itemData.operationalLayers;
        var filter_layers = [];
        dojo.forEach(layers, function (layer) {
            // if (layer.layerObject && layer.layerObject.type !== "Feature Layer") {
            layer.layerObject.suspend();

            // }
            if (layer.definitionEditor) {
                filter_layers.push(getLayerFields(layer, map));
            } else if (layer.layers) {
                var hasDef = false;
                //Check ArcGISDynamicMapService layers for filters
                dojo.forEach(layer.layers, dojo.hitch(this, function (sublayer) {
                    if (sublayer.definitionEditor) {
                        hasDef = true;
                        sublayer.title = layer.title;
                        sublayer.layerId = layer.id;
                        filter_layers.push(getLayerFields(sublayer, map));
                    }
                }));
                if (!hasDef) {
                    layer.layerObject.resume();
                }
            } else {
                layer.layerObject.resume();
            }
        });
        var dList = new dojo.DeferredList(filter_layers);
        dList.then(function (response) {
            var layers = [];
            /*If there are interactive filters build the filter display*/
            dojo.forEach(response, function (r, index) {
                if (response[index][0] === true) {
                    layers.push(response[index][1]);
                }
            });

            this.filterLayers(layers, map);

        });


    }, function (error) {
        alert(options.i18n.viewer.errors.message, error);

    });

}

function filterLayers(layers, map) {
    var mapextent, url, count = 0;
    var zoomto = ((options.zoomto === 'true' || options.zoomto === true) && (options.autoquery === 'false' || options.autoquery === false || !options.autoquery));
    dojo.forEach(layers, function(layer) {
        //get the input values to the filter - if no value is specified use the defaults
        var extent, values = [];
        dojo.forEach(layer.definitionEditor.inputs, function(input) {
            dojo.forEach(input.parameters, function(param) {
                var value = this.options[input.prompt] || "";

                var field = null;
                var fields = null;
                if (layer.layerObject && layer.layerObject.fields) {
                    fields = layer.layerObject.fields;
                } else if (layer.fields) {
                    fields = layer.fields;
                }
                dojo.some(fields, function(f) {
                    if (f.name === param.fieldName) {
                        field = f;
                        return true;
                    }
                });
                if (field && field.domain && field.domain.codedValues) {
                    dojo.forEach(field.domain.codedValues, function(val, index) {
                        if (value === val.name) {
                            value = val.code;
                        }

                    });

                }

                //is it a number
                var defaultValue = isNaN(param.defaultValue) ? param.defaultValue : dojo.number.parse(param.defaultValue);
                if (isNaN(value)) {
                    values.push((value === "" ) ? defaultValue : value);
                } else {
                    //for some reason "" returns false for is  nan
                    if (value === "") {
                        values.push((value === "" ) ? defaultValue : value);
                    } else {
                        values.push((value === "" ) ? dojo.number.parse(defaultValue) : dojo.number.parse(value));
                    }
                }
            });
        });

        var defExp = dojo.replace(layer.definitionEditor.parameterizedExpression, values);
        //Apply the filter - different approach for Feature Layer and Dynamic Layer
        if (layer.layerObject && layer.layerObject.type === "Feature Layer") {
            stopIndicator(layer.layerObject);
            layer.layerObject.setDefinitionExpression(defExp);
            layer.layerObject.resume();
            url = layer.layerObject.url;
            //if auto query is true, query layer using filter as where clause and add result if only one is returned
            if (layer.popupInfo && !querying && (options.autoquery === 'true' || options.autoquery === true)) {
                layer.layerObject.setInfoTemplate(new esri.dijit.PopupTemplate(layer.popupInfo));
                queryFeature(url, defExp, layer.layerObject);

            } else if (options.zoomto === 'true' || options.zoomto === true) {
                //zoom to extent of filtered features
                zoomto = true;
            }
        } else if (layer.layerId) {//dynamic layer
            // var layerDef = [];
            var mapLayer = map.getLayer(layer.layerId);
            var layerDef = mapLayer.layerDefinitions;
            layerDef[layer.id] = defExp;
            stopIndicator(mapLayer);
            mapLayer.setLayerDefinitions(layerDef);
            mapLayer.resume();
            url = mapLayer.url + "/" + layer.id
            //if auto query is true, query layer using filter as where clause and add result if only one is returned
            if (layer.popupInfo && !querying && (options.autoquery === 'true' || options.autoquery === true)) {
                queryFeature(url, defExp, mapLayer, layer.popupInfo);
            } else if (options.zoomto === 'true' || options.zoomto === true) {
                //zoom to extent of filtered features
                zoomto = true;
            }

        }
        if (zoomto === true && layer.title == "World Countries") {
            extent = queryExtents(url, defExp, ["*"]);
            extent.then(function() {
                count++;
                if (mapextent) {
                    mapextent = mapextent.union(extent.results[0]);
                } else {
                    mapextent = extent.results[0];
                }
                if (mapextent) {
                    //if (count === layers.length) {
                        mapextent = mapextent.expand(1.2);
                        map.setExtent(mapextent);
                    //}
                }
            });
        }

    });

}

function stopIndicator(layer) {
    //stop the busy indicator when the layer's updated
    var handler = dojo.connect(layer, "onUpdateEnd", function() {
        esri.hide(dojo.byId("loader"));
        dojo.disconnect(handler);
    });
}

function getLayerFields(layer, map) {

    if (layer.layerObject) {
        var deferred = new dojo.Deferred();
        deferred.resolve(layer);
        return deferred.promise;
    } else if (layer.layerId) {
        var l = map.getLayer(layer.layerId);
        return esri.request({
            url : l.url + "/" + layer.id,
            content : {
                "f" : "json"
            },
            callbackParamName : "callback",
            load : function(response) {
                layer.fields = response.fields;
                return layer;
            }
        });
    }

}

var info;
var querying = false;
function queryFeature(url, where, layer, popupInfo) {
    querying = true;
    var qt = new esri.tasks.QueryTask(url);
    var query = new esri.tasks.Query();
    query.where = where;
    info = popupInfo
    
    //outfields are the fieldNames in info.fieldInfos array, where fieldInfo visible=true
    var outFields = dojo.map(dojo.filter(info.fieldInfos, function(fieldInfo) {
        return fieldInfo.visible
    }), function(fieldInfo) {
        return fieldInfo.fieldName;

    })

    query.returnGeometry = false;
    // query.outFields= ["*"];

    if (layer.type === 'Feature Layer') {

        query.outFields = outFields;
        query.returnGeometry = true;
        layer.selectFeatures(query, esri.layers.FeatureLayer.SELECTION_NEW).then(function(results) {

            var point, featureextent;
            if (results[0].geometry.type === 'point') {
                point = results[0].geometry
            } else {
                featureextent = results[0].geometry.getExtent();
                point = featureextent.getCenter();
            }
            map.infoWindow.setFeatures(results.slice(0, 1));
            map.infoWindow.show(point);

            if (options.zoomto === 'true' || options.zoomto === true) {
                //zoom to result
                if (results[0].geometry.type === 'point')
                    map.centerAndZoom(point, 10);
                else {
                    map.setExtent(featureextent.expand(1.2));
                }
            }

        });
    } else {
        qt.executeForIds(query).then(function(ids) {
            query.objectIds = ids.slice(0, 1);
            query.where = null;
            query.outFields = outFields;
            query.returnGeometry = true;
            qt.execute(query, function(result, popupInfo) {
                var point, featureextent;
                if (result.features[0].geometry.type === 'point') {
                    point = result.features[0].geometry
                } else {
                    featureextent = result.features[0].geometry.getExtent();
                    point = featureextent.getCenter();
                }

                result.features[0]['infoTemplate'] = new esri.dijit.PopupTemplate(info);
                map.infoWindow.setFeatures(result.features.slice(0, 1));
                map.infoWindow.show(point);
                if (options.zoomto === 'true' || options.zoomto === true) {
                    //zoom to result
                    if (result.features[0].geometry.type === 'point')
                        map.centerAndZoom(point, 10);
                    else {
                        map.setExtent(featureextent.expand(1.2));
                    }
                }

            });
        })
    }

}

function queryExtents(url, where, id) {

    var deferred = new dojo.Deferred();
    var qt = new esri.tasks.QueryTask(url);
    var query = new esri.tasks.Query();
    query.where = where;
    query.returnGeometry = true;
    // query.outFields = id;
    qt.execute(query, function(results) {
        var mapextent;
        dojo.forEach(results.features, function(feature) {
            var extent;
			
            if (feature.geometry.type !== "point") {
                //extent = feature.geometry.getExtent()
                extent = new esri.geometry.Extent(feature.geometry.getExtent().xmin - 200000, feature.geometry.getExtent().ymin - 200000, feature.geometry.getExtent().xmax + 200000, feature.geometry.getExtent().ymax + 200000, feature.geometry.getExtent().spatialReference);
            } else {
                var p = feature.geometry;
			
                extent = new esri.geometry.Extent((p.x - 200000), (p.y - 200000), (p.x + 200000), (p.y + 200000), p.spatialReference);
            }
            if (!mapextent) {
                mapextent = extent;
            } else {
                mapextent = mapextent.union(extent)
            }
        })

        deferred.resolve(mapextent);

    }, function(error) {
        console.log(error);
    });
    return deferred;
}

function filterFacility( layerID, servicePRTR, defExp)
{
if(map1!=undefined)
{
  var mapLayer = map1.getLayer(layerID);
  var layerDef = mapLayer.layerDefinitions;
  var visibleLayers = new Array();
  visibleLayers[0] = 0;
  // layer filter to sgow the symbology of facilities
  layerDef[0] = defExp;   

  mapLayer.setLayerDefinitions(layerDef); 
  mapLayer.setVisibleLayers(visibleLayers);
  // show layer with the new filter expression
  mapLayer.show(); 
  mapLayer.resume();
  // query to obtain extent and infowindows  
  queryFacility(layerID,servicePRTR, defExp, mapLayer.__popups[0]);
 }  
}

function filterFacilityExtended( layerID, servicePRTR, defExp)
{
 if(map2!=undefined)
{ 
  var mapLayer = map2.getLayer(layerID);
  var layerDef = mapLayer.layerDefinitions;
  var visibleLayers = new Array();
  visibleLayers[0] = 0;
  // layer filter to sgow the symbology of facilities
  layerDef[0] = defExp;   

  mapLayer.setLayerDefinitions(layerDef); 
  mapLayer.setVisibleLayers(visibleLayers);
  // show layer with the new filter expression
  mapLayer.show(); 
  mapLayer.resume();
  // query to obtain extent and infowindows  
  queryFacilityExtended(layerID,servicePRTR, defExp, mapLayer.__popups[0]);
 }  
}


function filterFacilityDetails(layerID, servicePRTR, defExp)
{
if(map3!=undefined)
{
	  var mapLayer = map3.getLayer(layerID);
	  var layerDef = mapLayer.layerDefinitions;
	  var visibleLayers = new Array();
	  visibleLayers[0] = 1;
	  // layer filter to sgow the symbology of facilities
	  
	  layerDef[1] = defExp;   
	  mapLayer.setLayerDefinitions(layerDef);  
	   mapLayer.setVisibleLayers(visibleLayers);
	  // show layer with the new filter expression
	 mapLayer.resume(); 
	 mapLayer.show(); 
	 
	  // query to obtain extent and infowindows  
	  queryFacilityDetails(layerID,servicePRTR, defExp, mapLayer.__popups[0]);
  }
}
function queryAndZoomFacility(FacilityReportID, map){
    queryTask = new esri.tasks.QueryTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer/0");
    query = new esri.tasks.Query(); 
    query.outFields =['*'];
    query.where ="FacilityReportID = " + FacilityReportID;    
    query.returnGeometry = true;
    // execute and result function
    queryTask.execute(query, function(results) {
        for (var i=0; i<results.features.length;i++){        
            feature = results.features[i];         
            feature['infoTemplate'] = new esri.dijit.PopupTemplate(info);          
              
            p = feature.geometry; 
            map.centerAndZoom(p, 15);
        }
    });

}
function queryFacility(layerName, servicePRTR, strSql, popupInfo)
 {
	
	map1.graphics.clear();	
	info = popupInfo;
	// query definition
	queryTask = new esri.tasks.QueryTask(servicePRTR);
	query = new esri.tasks.Query();	
	query.outFields =['*'];
	query.where =strSql;	
	query.returnGeometry = true;
	// execute and result function
	queryTask.execute(query, function(results) {	
	if (results.features.length==0){
	alert("there are no results");
		$('#contenedorinfoContainer').html('LNG_ErrorNoRegistros');
		$('#infoContainer').mb_open();
	} 
	else {  
	      var feature;
		  var extent;
		  var mapextent;		  
          var p ;	
		  var graphic;
		  // point symbol with transparency (we have to visualize the symbol of layer def) 
		  var simboloPunto = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, null, new dojo.Color([0,0,0,0.0]));

		  map1.graphics.clear();
		  
		 for (var i=0; i<results.features.length;i++){		  
			  feature = results.features[i];		 
			  feature['infoTemplate'] = new esri.dijit.PopupTemplate(info);			 
			  
			  graphic = feature;
			  graphic.setSymbol(simboloPunto)
			  map1.graphics.add(graphic);
			  
			  p = feature.geometry;	
			  extent = new esri.geometry.Extent((p.x - 10 ), (p.y  - 10), (p.x +10 ), (p.y +10 ), p.spatialReference);
				 if (!mapextent) {
					mapextent = extent;
				} else {
					mapextent = mapextent.union(extent);
				}  			            
			}
	
		map1.setExtent(mapextent);	
		// listener onclick of graphics to show the infowindow
		dojo.connect(map1.graphics,"onClick",identifyFeatures);
		filterFacilityExtended(layerName, servicePRTR, strSql);
	};
	})
};
function identifyFeatures(evt)
{
		  map1.infoWindow.setTitle("");
		  map1.infoWindow.setContent( evt.graphic.getContent());
		  map1.infoWindow.show(evt.screenPoint,map1.getInfoWindowAnchor(evt.screenPoint));
}


function queryFacilityExtended(layerName, servicePRTR, strSql, popupInfo)
 {
	
		map2.graphics.clear();	
		info = popupInfo;
		// query definition
		queryTask = new esri.tasks.QueryTask(servicePRTR);
		query = new esri.tasks.Query();	
		query.outFields =['*'];
		query.where =strSql;	
		query.returnGeometry = true;
		// execute and result function
		queryTask.execute(query, function(results) {	
		if (results.features.length==0){
		alert("there are no results");
			$('#contenedorinfoContainer').html('LNG_ErrorNoRegistros');
			$('#infoContainer').mb_open();
		} 
		else {  
			  var feature;
			  var extent;
			  var mapextent;		  
			  var p ;	
			  var graphic;
			  // point symbol with transparency (we have to visualize the symbol of layer def) 
			  var simboloPunto = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, null, new dojo.Color([0,0,0,0.0]));

			  map2.graphics.clear();
			  
			 for (var i=0; i<results.features.length;i++){		  
				  feature = results.features[i];		 
				  feature['infoTemplate'] = new esri.dijit.PopupTemplate(info);			 
				  
				  graphic = feature;
				  graphic.setSymbol(simboloPunto)
				  map2.graphics.add(graphic);
				  
				  p = feature.geometry;	
				  extent = new esri.geometry.Extent((p.x - 10 ), (p.y  - 10), (p.x +10 ), (p.y +10 ), p.spatialReference);
					 if (!mapextent) {
						mapextent = extent;
					} else {
						mapextent = mapextent.union(extent);
					}  			            
				}
		
			map2.setExtent(mapextent);	
			// listener onclick of graphics to show the infowindow
			dojo.connect(map2.graphics,"onClick",identifyFeaturesExtended);
		};
	
	})
};

function identifyFeaturesExtended(evt)
{
		  map2.infoWindow.setTitle("");
		  map2.infoWindow.setContent( evt.graphic.getContent());
		  map2.infoWindow.show(evt.screenPoint,map2.getInfoWindowAnchor(evt.screenPoint));
}


function queryFacilityDetails( layerName, servicePRTR, strSql, popupInfo)
    {
	
	map3.graphics.clear();	
	info = popupInfo;
	// query definition
	queryTask = new esri.tasks.QueryTask(servicePRTR);
	query = new esri.tasks.Query();	
	query.outFields =['*'];
	query.where =strSql;	
	query.returnGeometry = true;
	// execute and result function
	queryTask.execute(query, function(results) {	
	if (results.features.length==0){
	alert("there are no results");
		$('#contenedorinfoContainer').html('LNG_ErrorNoRegistros');
		$('#infoContainer').mb_open();
	} 
	else {  
	      var feature;
		  var extent;
		  var mapextent;		  
          var p ;	
		  var graphic;
		  // point symbol with transparency (we have to visualize the symbol of layer def) 
		  var simboloPunto = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, null, new dojo.Color([0,0,0,0.0]));

		  map3.graphics.clear();
		  
		 for (var i=0; i<results.features.length;i++){		  
			  feature = results.features[i];		 
			  feature['infoTemplate'] = new esri.dijit.PopupTemplate(info);			 
			  
			  graphic = feature;
			  graphic.setSymbol(simboloPunto)
			  map3.graphics.add(graphic);
			  
			  p = feature.geometry;	
			  extent = new esri.geometry.Extent((p.x ), (p.y ), (p.x ), (p.y ), p.spatialReference);
				 if (!mapextent) {
					mapextent = extent;
				} else {
					mapextent = mapextent.union(extent);
				}  			            
			}
	
		map3.setExtent(mapextent);	
		// listener onclick of graphics to show the infowindow
		dojo.connect(map3.graphics,"onClick",identifyFeaturesDetails);
	
	};
	})
};

function identifyFeaturesDetails(evt)
{
		  map3.infoWindow.setTitle("");
		  map3.infoWindow.setContent( evt.graphic.getContent());
		  map3.infoWindow.show(evt.screenPoint,map3.getInfoWindowAnchor(evt.screenPoint));
}


function orientationChanged(map) {
    if (map) {
        map.reposition();
        map.resize();
    }
}

function enablePopups(map) {
	if (clickListener) {
		clickHandler = dojo.connect(map, "onClick", clickListener);
	}
}

function disablePopups() {
	if (clickHandler) {
		dojo.disconnect(clickHandler);
	}
}

function addLegend(response)
{
	var legendTb = new dijit.form.ToggleButton({
		label : "Legend",
		id : "legendBtn",
		showLabel : true,			
		checked : true,
		iconClass : 'esriLegendIcon',
		id : 'legendButton'
	}, dojo.create('div'));
	dojo.byId(options.mapName+ "headerRightContainer").appendChild(legendTb.domNode);
	dojo.connect(legendTb, 'onClick', function() {
				showLeftPanel();
			});

	
 var legendId = options.mapName + "legend";
 var legend = esri.arcgis.utils.getLegendLayers(response);
 var legendDijit = new esri.dijit.Legend({
						map:response.map,
						layerInfos: legend
					}, legendId);
				legendDijit.startup();	
	

hideLeftPanel();	
}
function addYearSelector(map){
        var yearSpan = dojo.create('span', {
            style:"",
            innerHTML :"Year: " 
        });
        
        dojo.byId("legendHeader").appendChild(yearSpan);
		
		
		var select = new dijit.form.Select({
        name: "select2",
        options: [
            { label: "2001", value: "2001" },
            { label: "2004", value: "2004" },
            { label: "2007", value: "2007" },
            { label: "2008", value: "2008" },
            { label: "2009", value: "2009" },
            { label: "2010", value: "2010" },
            { label: "2011", value: "2011" },         
            { label: "All Years", value: "AY", selected: true }
        ]
    });
    select.on("change", function(year){
      var layer = map.getLayer("EprtrFacilities_Dyna_WGS84_1098");
      var layerDefinitions = [];
      if (year == "AY"){
        layerDefinitions[0] = "";
        ReportingYear = "";
      }else{
        layerDefinitions[0] = "ReportingYear = " + year;
        ReportingYear = year;
      }
      layer.setLayerDefinitions(layerDefinitions);

    })

    //select.insertBefore(dojo.byId(options.mapName + "legend"));
    //select.placeAl(dojo.byId(options.mapName + "legend"));
    //dojo.place(select, dojo.byId(options.mapName + "legend"), "before");
    //select.placeAt(dojo.body());
    //dojo.byId(options.mapName + "legendContainer").appendChild(select.domNode);
    dojo.byId("legendHeader").appendChild(select.domNode);
	
	var lineHoriz = dojo.create ('HR' , {
			width:'100%',
			align:"center"
		});
		
	dojo.byId("legendHeader").appendChild(lineHoriz);
		

}
function showLeftPanel() {	
        
      
        if(dojo.byId(options.mapName + "legendContainer").style.width != "0px")
            hideLeftPanel()
        else
        {
        dojo.style(dojo.byId(options.mapName + "legendContainer"), "width", "200px");
		switch (options.mapName) {
            case "map_extended":	
       
			dojo.style(dojo.byId(options.mapName + "map"), "width", "800px");
            dojo.style(dojo.byId(options.mapName + "legendContainer"), "left", "810px");
			break;
			case "map_viewer":
           
			dojo.style(dojo.byId(options.mapName + "map"), "width", "550px");
			break;			
		}		

        }  

    
		
	}
function hideLeftPanel() {	
 
    
    dojo.style(dojo.byId(options.mapName + "legendContainer"), "width", "0px");
	switch (options.mapName) {
            case "map_extended":         
			dojo.style(dojo.byId(options.mapName + "map"), "width", "1000px");
			break;
			case "map_viewer":
			dojo.style(dojo.byId(options.mapName + "map"), "width", "800px");
           
			break;			
			}
}

function resizeMap(mapa) {

	if (mapa) {	
	 mapa.reposition();
	mapa.resize(true);	
	}
	
}

function addBasemapGalleryMenu(map) {
       var basemapGroup = {
           "owner" : "",
           "title" : ""
       };
   var basemapGallery = new esri.dijit.BasemapGallery({
       showArcGISBasemaps: true,
       portalUrl:"http://eea.maps.arcgis.com/",
       bingMapsKey:"AngrFRWkKXOKP4DuIx_T3wGWalupu63oFfJcDJHqa5_QA34tELFodeuc97CMw5us",
       basemapsGroup : basemapGroup,
         map: map
       }, "basemapGallery");
       basemapGallery.startup();

       basemapGallery.on("error", function(msg) {
         console.log("basemap gallery error:  ", msg);
       });

       basemapGallery.on("load",function(){
         basemapGallery.remove ("basemap_15");
         basemapGallery.remove ("basemap_14");
          basemapGallery.remove ("basemap_0");
       
        });             

}
  

function addLayerList(layers,map) {

	var layerList = buildLayerVisibleList(layers);
	if (layerList.length > 0) {
	
		//create a menu of layers
		layerList.reverse();
	
		var cp = new dijit.layout.ContentPane({
        id :  'layerList',
       
		});
		var menu = new dijit.Menu({
			id : 'layerMenu'
		});
	
		var layerInfos = [];
		dojo.forEach(layerList, function(layer) {
			menu.addChild(new dijit.CheckedMenuItem({
				label : layer.title,
				checked : layer.visible,
				onChange : function() {
					if (layer.layer.featureCollection) {
					
						//turn off all the layers in the feature collection even
						//though only the  main layer is listed in the layer list
						dojo.forEach(layer.layer.featureCollection.layers, function(layer) {
							layer.layerObject.setVisibility(!layer.layerObject.visible);
						});
					} else {
				
						layer.layer.setVisibility(!layer.layer.visible);
						if(layer.layer.visible && (dojo.byId(options.mapName + "legendContainer").style.width == "0px"))                         
							showLeftPanel();
						else if(!layer.layer.visible && (dojo.byId(options.mapName + "legendContainer").style.width != "0px"))                               
							hideLeftPanel();
					}

				}
			}));
			if (layer.layer.layerInfos)
				layerInfos.push(layer.layer.layerInfos);
			layerInfos[0][1].setVisibility = false;	
				
		});
		
		cp.set('content', menu.domNode);
		 
		var button = new dijit.form.DropDownButton({
			label : "Layers",
			id : "layerBtn",
            style: "margin-left:120px",
			iconClass : "esriLayerIcon",
			title :"Layers",
			dropDown : cp
		});
		
	
   
     dojo.byId(options.mapName + "headerLeftContainer").appendChild(button.domNode);
 
	}
}

function buildLayerVisibleList(layers) {
	var layerInfos = [];
	dojo.forEach(layers, function(mapLayer, index) {
		if (mapLayer.featureCollection && !mapLayer.layerObject) {
			if (mapLayer.featureCollection.layers) {
				//add the first layer in the layer collection... not all  - when we turn off the layers we'll
				//turn them all off
				if (mapLayer.featureCollection.layers) {
					layerInfos.push({
						"layer" : mapLayer,
						"visible" : mapLayer.visibility,
						"title" : mapLayer.title
					});
				}
			}
		} else if (mapLayer.layerObject) {
			layerInfos.push({
				layer : mapLayer.layerObject,
				visible : mapLayer.layerObject.visible,
				title : mapLayer.title
			});
		}
	});
	return layerInfos;
}

function addPrint(map, response) {	
        var legendLayer = new esri.tasks.LegendLayer();
        legendLayer.layerId = "EprtrFacilities_Dyna_WGS84_1098";
        legendLayer.subLayerIds = [];
	    // create an array of objects that will be used to create print templates
          var layouts = [{
            name: "Letter ANSI A Portrait", 
            label: "PDF", 
            format: "pdf", 
            options: { 
              legendLayers: [legendLayer],
              scalebarUnit: "Kilometers",
              titleText: "E-PRTR (The European Pollutant Release and Transfer Register)",
              authorText: "© Copyright 2009 European Commision. All rights reserved.",
              copyrightText: "Disclaimer: The European Commission maintains this website to enhance public access to the European pollutant release and transfer register. Our goal is to keep this information timely and \naccurate. If errors are brought to our attention, we will try to correct them. However the Commission accepts no responsibility or liability whatsoever with regard to the information on this site."
            }
          }, {
            name: "MAP_ONLY", 
            label: "PNG", 
            format: "jpg", 
            options:  { 
              legendLayers: [],
              scaleBarUnit: "Miles",
              titleText:""
            }
          }];
       
          // create the print templates		
		   
          var templates = dojo.map(layouts, function(lo) {
		  	
            var t = new esri.tasks.PrintTemplate();
            t.layout = lo.name;
            t.label = lo.label;
            t.format = lo.format;
            t.layoutOptions = lo.options;
            return t;
          });
		  	

	// print dijit
	var printer = new esri.dijit.Print({
		map : map,
		templates : templates,
		url : "http://sampleserver6.arcgisonline.com/arcgis/rest/services/Utilities/PrintingTools/GPServer/Export%20Web%20Map%20Task"
	}, dojo.create("span"));

	
	dojo.query('.esriPrint').addClass('esriPrint');

	dojo.byId(options.mapName + "headerCenterContainer").appendChild(printer.printDomNode);

	printer.startup();	
}

//Uses the Geocoder Widget (from 3.3)
function createSearchTool(map) {
	
	var geocoder = new esri.dijit.Geocoder({ 
        arcgisGeocoder: {
            placeholder: "Find a place...",
            searchExtent: { "xmin" : -5274436.027, "ymin" : 2507194.224, "xmax" : 5489163.741, "ymax" : 11514040.662, "spatialReference" : new esri.SpatialReference(3857) }
        },
          map: map,
          autoComplete: true			
        }, "search");



        geocoder.startup();
	
	dojo.connect(geocoder, "onFindResults", function(results) {
		dojo.some(results.results, function(result) {
			//display a popup for the first result
			//map.infoWindow.setTitle(i18n.tools.search.title);
			map.infoWindow.setContent(result.name);
			map.infoWindow.show(result.feature.geometry);
			return true;

		});
	});
	dojo.connect(geocoder, "onClear", function() {
		if (map.infoWindow.isShowing) {
			map.infoWindow.hide();
		}
	});
	
	
}

function addLocateButton(map)
{
  var geoLocate = new esri.dijit.LocateButton({
			map: map
		  }, "LocateButton");
		  geoLocate.startup();	  
}


//add any bookmarks to the application
function addBookmarks(info) {
	
	  var bookmarks_list = [{
         "extent": {
            "spatialReference": {
                "wkid": 4326
            }, 
            "xmin":-22.6746 ,
            "ymin":33.7635,
            "xmax":-31.5538,
            "ymax":72.7430
          },
          "name": "Europe" 
        }, {
          "extent": {
            "spatialReference": {
              "wkid":4326
            },              
            "xmin":-19.31825,
            "ymin":26.2519 ,
            "xmax":-12.5396,
            "ymax":31.1243   
          },
          "name": "Canary Island"
        }];
		
		var bookmarks = new esri.dijit.Bookmarks({
			map : info.map,
			bookmarks : bookmarks_list,
			 editable: true
		}, dojo.create("div"));

		dojo.connect(bookmarks, "onClick", function() {
			//close the bookmark window when an item is clicked
			dijit.byId('bookmarkButton').closeDropDown();
		});
		
		var cp = new dijit.layout.ContentPane({
			id : 'bookmarkView'
		});
	
		cp.set('content', bookmarks.bookmarkDomNode);
		var button = new dijit.form.DropDownButton({
			label : "Bookmarks",
			id : "bookmarkButton",
			iconClass : "esriBookmarkIcon",
			title : "Bookmarked places",
			dropDown : cp
		});

		dojo.byId(options.mapName + "headerCenterContainer").appendChild(button.domNode);
}

function addOverview(isVisible, map) {
	//attachTo:bottom-right,bottom-left,top-right,top-left
	//opacity: opacity of the extent rectangle - values between 0 and 1.
	//color: fill color of the extnet rectangle
	//maximizeButton: When true the maximize button is displayed
	//expand factor: The ratio between the size of the ov map and the extent rectangle.
	//visible: specify the initial visibility of the ovmap.
	
	var overviewMapDijit = new esri.dijit.OverviewMap({
		map : map,
		attachTo : "bottom-right",
		opacity : 0.5,
		color : "#000000",
		expandfactor : 2,
		maximizeButton : false,
		visible : isVisible,
		id : 'overviewMap'
	});
	
	overviewMapDijit.startup();
	
}

function destroyOverview() {
	var ov = dijit.byId('overviewMap');
	if (ov) {
		var vis = ov.visible;
		ov.destroy();
		addOverview(vis);
	}
}

//create a floating pane to hold the seacrh widget and add a button to the toolbar
//that allows users to hide/show the seacrh widget.
function addSearchWidget(map) {

	  toolbar = new esri.toolbars.Draw(map);
	  toolbar.on("draw-end", addToMapAndQuery);
			  
	var fp = new dojox.layout.FloatingPane({
		title : "Search",
		resizable : false,
		dockable : false,
		closable : false,
		style : "display:block;position:absolute;top:0px;left:0px;width:600px;height:300px;z-index:100;visibility:hidden;",
		id : 'floater'
	}, dojo.byId('floater'));
	fp.startup();

	var titlePane = dojo.query('#floater .dojoxFloatingPaneTitle')[0];
	//add close button to title pane
	var closeDiv = dojo.create('div', {
		id : "closeBtn",
		style:"float:right;clear:both;padding-right:10px;",
		innerHTML : esri.substitute({
			close_title : "Close",
			close_alt : "Close search widget"
		}, '<a alt=${close_alt} title=${close_title} href="JavaScript:toggleSearch();"><img  src="./JS_Map_Min/images/closepanel.png"/></a>')
	}, titlePane);
	
	createSearchTab();
	
	createGraphicSearchButtons(map);
	
	createTextSearchButton(map);
	
	createResultDataGrid(map);
	
	var toggleButton = new dijit.form.ToggleButton({
		label : "Search",
		title : "Search",
		id : "toggleButton",		
		iconClass : "esriSearchIcon"
	});

	dojo.connect(toggleButton, "onClick", function() {
		toggleSearch(map);
	});

	dojo.byId(options.mapName + "headerCenterContainer").appendChild(toggleButton.domNode);
	
	
}

//Show/hide the seacrh widget when the search button is clicked.
function toggleSearch(map) {
	
	if (dojo.byId('floater').style.visibility === 'hidden') {
		dijit.byId('floater').show();
		disablePopups();
		
		//disable map popups otherwise they interfere with measure clicks
	} else {

		dijit.byId('floater').hide();
		enablePopups(map);
		//enable map popup windows
		dijit.byId('toggleButton').set('checked', false);	
	}

}
function createSearchTab()
{
 var searchTab = new dijit.layout.TabContainer(
			{
			     id:"searchTab",
                style:"width:100%;height:100%"
			}, "searchDiv");
			
var graphicTab = new dijit.layout.ContentPane(
			{
			id:"graphicTab",
			title:"Graphical search",
            style:"text-align:center"
			});		
			searchTab.addChild(graphicTab);
			 
 var textTab = new dijit.layout.ContentPane(
			{
			id:"textTab",
			title:"Text search",
            style:"text-align:center"
			});	 
			searchTab.addChild(textTab);	

var resultTab = new dijit.layout.ContentPane(
			{
			id:"resultTab",
			title:"Search results"
			});	 
			searchTab.addChild(resultTab);					
			searchTab.startup();
}

function createResultDataGrid(map)
{
    var featuresLabelSpan = dojo.create('span', {
            style:"",
            innerHTML :"Features selected: " 
        });
        
        dojo.byId("resultTab").appendChild(featuresLabelSpan);

    var featuresCountSpan = dojo.create('span', {
            id:"featuresCountSpan",
            style:"",
            innerHTML :"" 
        });
        
        dojo.byId("resultTab").appendChild(featuresCountSpan);

 searchGrid = new dojox.grid.DataGrid({    
			query:{},
            structure: [
                { name: "Facility Name", field: "FacilityName", width: "40%" },
				{ name: "City", field: "City", width: "20%" },
				{ name: "Address", field: "Address", width: "25%" },
				{ name: "PC", field: "PostalCode", width: "10%" },
                { name: " ", field: "FacilityReportID", width: "5%", formatter: myFunc },
			],
            onRowClick: function(evt){rowClick(map,evt)}
        }, "searchGrid");	
		dojo.byId("resultTab").appendChild(searchGrid.domNode);


        searchGrid.startup();
		

}
function rowClick(map, evt){
    if (evt.cell.field != 'FacilityReportID'){
        var FacilityReportID = searchGrid._getItemAttr(evt.rowIndex, 'FacilityReportID');
        queryAndZoomFacility(FacilityReportID, map);
    }
}
function myFunc(item){
    return "<a target='_blank' href='http://prtr.ec.europa.eu/PopupFacilityDetails.aspx?FacilityReportId="+item+"'><img src='./JS_Map_min/images/w_link.png'/></a>";
}
function createTextSearchButton(map)
{
    var selectorSpan = dojo.create('span', {
            style:"display: block;",
            innerHTML :"Search by facility name, city or postal code" 
        });
    dojo.byId("textTab").appendChild(selectorSpan);
	var facilityTextBox = new dijit.form.TextBox({
		name: "Facility",
		value: "",
		title:"Search by facility name, city or postal code",
		placeHolder: "Enter text"
	}, "facilityTextBox");	
	

	dojo.byId("textTab").appendChild(facilityTextBox.domNode);
	
	 var searchButton = new dijit.form.Button({
        label: "Search"       
    })
	dojo.byId("textTab").appendChild(searchButton.domNode);
	
	dojo.connect(searchButton, "onClick", function() {
		searchByText(facilityTextBox.get("value") );
	});
     var clearButton = new dijit.form.Button({
        label: "Clear"       
    })
    dojo.byId("textTab").appendChild(clearButton.domNode);
    
    dojo.connect(clearButton, "onClick", function() {
        clearResults(map);
    });	
	
}

function createGraphicSearchButtons(map)
{
    var selectorSpan = dojo.create('span', {
            style:"display: block;",
            innerHTML :"Use one of the graphical search tools to select facilities" 
        });
    dojo.byId("graphicTab").appendChild(selectorSpan);

	var togglePoint = new dijit.form.ToggleButton({
		label : "Point",
		title : "Point",
		id : "togglePoint",		
		iconClass : "esriPointIcon",
		showLabel: false
	});

	dojo.connect(togglePoint, "onClick", function() {
		searchByPoint();
	});
	dojo.byId("graphicTab").appendChild(togglePoint.domNode);

    var toggleRectangle = new dijit.form.ToggleButton({
        label : "Rectangle",
        title : "Rectangle",
        id : "toggleRectangle",       
        iconClass : "esriRectangleIcon",
        showLabel: false
    });

    dojo.connect(toggleRectangle, "onClick", function() {
        searchByRectangle();
    });
    dojo.byId("graphicTab").appendChild(toggleRectangle.domNode);  
	
	var togglePolygon = new dijit.form.ToggleButton({
		label : "Polygon",
		title : "Polygon",
		id : "togglePolygon",		
		iconClass : "esriPolygonIcon",
		showLabel: false
	});

	dojo.connect(togglePolygon, "onClick", function() {
		searchByPolygon();
	});
	dojo.byId("graphicTab").appendChild(togglePolygon.domNode);

    var toggleClear = new dijit.form.ToggleButton({
        label : "Clear",
        title : "Clear",
        id : "toggleClear",       
        iconClass : "esriClear",
        showLabel: false
    });

    dojo.connect(toggleClear, "onClick", function() {
        clearResults(map);
    });
    dojo.byId("graphicTab").appendChild(toggleClear.domNode);    
}

function searchByPoint()
{
toolbar.activate(esri.toolbars.Draw.POINT);
}
function searchByPolygon()
{
  toolbar.activate(esri.toolbars.Draw.POLYGON);
}
function searchByRectangle(){
    toolbar.activate(esri.toolbars.Draw.EXTENT);
}
function clearResults(map){
     map.graphics.clear();
     dojo.byId("featuresCountSpan").innerHTML = 0;
     searchGrid.setStore(null);
}
function searchByText(facilityText)
{
executeTextSearch("EprtrFacilities_Dyna_WGS84_1098","http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer/0",facilityText)
}

function addToMapAndQuery(evt) {
          var symbol;
          toolbar.deactivate();
         
          switch (evt.geometry.type) {
            case "point":
            case "multipoint":
              symbol = new esri.symbol.SimpleMarkerSymbol();
              break;
            case "polyline":
              symbol = new esri.symbol.SimpleLineSymbol();
              break;
            default:
              symbol = new esri.symbol.SimpleFillSymbol();
              break;
          }
          var graphic = new esri.Graphic(evt.geometry, symbol);
		  evt.target.map.graphics.add(graphic);
		  
		  executeIdentifyTask(evt.target.map, evt.geometry);
		  
		  
        }
		
function executeIdentifyTask(mapa,geom)
{

  
 identifyParams = new esri.tasks.IdentifyParameters();
 identifyParams.geometry = geom;
 identifyParams.mapExtent = mapa.extent;
 identifyParams.tolerance = 5;
 identifyParams.returnGeometry = true;
 identifyParams.layerIds = [0]; // city/uga(4) and county(6) layers used for this example
 identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
           
 identifyTask = new esri.tasks.IdentifyTask("http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer");
 identifyTask.execute(identifyParams, function (idResults) {addToGrid(idResults,mapa); });
 mapa.graphics.clear();
 
}

function executeTextSearch(layerID, servicePRTR,text)
 {
	var info = map2.getLayer(layerID).__popups[0];
	// query definition
	queryTask = new esri.tasks.QueryTask(servicePRTR);
	query = new esri.tasks.Query();	
	query.outFields =['*'];
	query.where ="FacilityName LIKE   '%" + text + "%'  OR FacilityID LIKE '%" + text + "%'";	
	query.returnGeometry = true;
	// execute and result function
	queryTask.execute(query, function(results) {	
	if (results.features.length==0){
	alert("there are no results");
		$('#contenedorinfoContainer').html('LNG_ErrorNoRegistros');
		$('#infoContainer').mb_open();
	} 
	else {  
		var values = [];
	    var feature;		
		var graphic;
		var mapextent;
		var p;
		// point symbol with transparency (we have to visualize the symbol of layer def) 
		var simboloPunto = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, null, new dojo.Color([0,0,0,0.0]));

		 
		// go to the result tab
		var tabs = dijit.byId("searchTab");
		tabs.selectChild(dijit.byId("resultTab"));
	
		//mapa.graphics.clear();
		  
		 for (var i=0; i<results.features.length;i++){		  
			  feature = results.features[i];		 
			  /*feature['infoTemplate'] = new esri.dijit.PopupTemplate(info);			 
			  
			  graphic = feature;
			  graphic.setSymbol(simboloPunto);
			  map2.graphics.add(graphic);	

			  if (!mapextent) {
			mapextent = extent;
				} else {
			mapextent = mapextent.union(extent);
				}  	*/		    
				
			  values.push(feature.attributes);			  
			}
			
		//map2.setExtent(mapextent);	
			
		var valuesStored =  new dojo.store.Memory({
        data: values,
        idProperty: "FacilityName"
			});
			
		// store datagrid with features
		searchGrid.setStore(dojo.data.ObjectStore({objectStore: valuesStored}));
	
	};
	})
};

function addToGrid(idResults,mapa) { 
	var values = [];
	var feature;
    var graphic;
    var mapextent;
	var p;
    var infowindow;
    var count = 0;
      var simboloPunto = new esri.symbol.PictureMarkerSymbol("./JS_Map_min/images/BulbGrey.png", 24, 40);
	// go to the result tab
	var tabs = dijit.byId("searchTab");
	tabs.selectChild(dijit.byId("resultTab"));

    var info = mapa.getLayer("EprtrFacilities_Dyna_WGS84_1098").__popups[0];
	
	

    var infoTemplate = new esri.InfoTemplate();
    infoTemplate.setTitle("${FacilityName}");
    infoTemplate.setContent("<b>City: </b>${City}<br/>"
                             + "<b>Address: </b>${Address}<br/>"
                             + "<b>Postal Code: </b>${PostalCode}<br/>"
                             + "<b>Sector: </b>${IASectorCode}<br/>"
                             + "<a href='http://prtr.ec.europa.eu/PopupFacilityDetails.aspx?FacilityReportId=${FacilityReportID}' target='_blank'>Show facility details</a>");


	for (var i = 0, il = idResults.length; i < il; i++) {
		var idResult = idResults[i];
        if (ReportingYear == ""){
		    values.push(idResult.feature.attributes);
            feature = idResult.feature;		 
	        graphic = idResult;
            graphic = new esri.Graphic(idResult.feature.geometry, simboloPunto, feature.attributes)//, infowindow);
            graphic.setInfoTemplate(infoTemplate);
	        mapa.graphics.add(graphic);
            count++;
		}else if (ReportingYear == idResult.feature.attributes.ReportingYear){
		    values.push(idResult.feature.attributes);
            feature = idResult.feature;		 
	        graphic = idResult;
            graphic = new esri.Graphic(idResult.feature.geometry, simboloPunto, feature.attributes)//, infowindow);
            graphic.setInfoTemplate(infoTemplate);
	        mapa.graphics.add(graphic);
            count++;
        }
		
	};	
    dojo.byId("featuresCountSpan").innerHTML =count;
    dojo.connect(mapa.graphics, "onClick", function(evt) {
        var g = evt.graphic;
        if (g.getContent()){
            mapa.infoWindow.setContent(g.getContent());
            mapa.infoWindow.setTitle(g.getTitle());
            mapa.infoWindow.show(evt.screenPoint, mapa.getInfoWindowAnchor(evt.screenPoint));
        }
    });
    /**dojo.connect(mapa.graphics, "onMouseOver", function(evt) {
            var content = evt.graphic.getContent();
            map.infoWindow.setContent(content);
            var title = evt.graphic.getTitle();
            map.infoWindow.setTitle(title);
            var highlightGraphic = new esri.Graphic(evt.graphic.geometry,highlightSymbol);
            map.graphics.add(highlightGraphic);
            map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
          });

          //listen for when map.graphics onMouseOut event is fired and then clear the highlight graphic
          //and hide the info window
          dojo.connect(map.graphics, "onMouseOut", function(evt) {
            map.graphics.clear();
            map.infoWindow.hide();
          });*/
	
	var valuesStored =  new dojo.store.Memory({
        data: values,
        idProperty: "FacilityName"
    });
	

	// store datagrid with features
	searchGrid.setStore(dojo.data.ObjectStore({objectStore: valuesStored}));
 
	
}






