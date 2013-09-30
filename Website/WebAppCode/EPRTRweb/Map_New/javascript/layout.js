dojo.require("esri.layout");
dojo.require("esri.widgets");
dojo.require("esri.dijit.PopupTemplate");
dojo.require("esri.tasks.query");
dojo.require("esri.dijit.PopupMobile");
dojo.require("esri.arcgis.utils");
dojo.require("utilities.EEACreateContent");
dojo.require("dojo.Deferred");
dojo.require("dojo.DeferredList");

var map;
var options;
var appcontent;

function init(initOptions) {

    options = initOptions;

    var supportsOrientationChange = "onorientationchange" in window, orientationEvent = supportsOrientationChange ? "orientationchange" : "resize";
    //IE8 doesn't support addEventListener so check before calling
    if (window.addEventListener) {
        window.addEventListener(orientationEvent, function() {
            orientationChanged();
        }, false);
    }

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
    var mapDeferred = esri.arcgis.utils.createMap(options.webmap, "map", {
        mapOptions : mapOptions,
        ignorePopups : false,
        bingMapsKey : options.bingmapskey
    });
    mapDeferred.then(function(response) {
        document.title = options.title || response.itemInfo.item.title;
        if (dojo.byId("title")) {
            dojo.byId("title").innerHTML = options.title || response.itemInfo.item.title;
        }
        if (dojo.byId("subtitle")) {
            dojo.byId("subtitle").innerHTML = options.subtitle || response.itemInfo.item.snippet || "";
        }

        map = response.map;
        map.disableScrollWheelZoom();
        var layers = response.itemInfo.itemData.operationalLayers;
        var filter_layers = [];
        dojo.forEach(layers, function(layer) {
            // if (layer.layerObject && layer.layerObject.type !== "Feature Layer") {
            layer.layerObject.suspend();
            // }
            if (layer.definitionEditor) {
                filter_layers.push(getLayerFields(layer));
            } else if (layer.layers) {
                var hasDef = false;
                //Check ArcGISDynamicMapService layers for filters
                dojo.forEach(layer.layers, dojo.hitch(this, function(sublayer) {
                    if (sublayer.definitionEditor) {
                        hasDef = true;
                        sublayer.title = layer.title;
                        sublayer.layerId = layer.id;
                        filter_layers.push(getLayerFields(sublayer));
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
        dList.then(function(response) {
            var layers = [];
            /*If there are interactive filters build the filter display*/
            dojo.forEach(response, function(r, index) {
                if (response[index][0] === true) {
                    layers.push(response[index][1]);
                }
            });

            this.filterLayers(layers);

        });

    }, function(error) {
        alert(options.i18n.viewer.errors.message, error);

    });

}

function filterLayers(layers) {
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
        if (zoomto === true) {
            extent = queryExtents(url, defExp, ["*"]);
            extent.then(function() {
                count++;
                if (mapextent) {
                    mapextent = mapextent.union(extent.results[0]);
                } else {
                    mapextent = extent.results[0];
                }
                if (mapextent) {
                    if (count === layers.length) {
                        mapextent = mapextent.expand(1.2);
                        map.setExtent(mapextent);
                    }
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

function getLayerFields(layer) {

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
                extent = feature.geometry.getExtent()
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

function orientationChanged() {
    if (map) {
        map.reposition();
        map.resize();
    }
}

