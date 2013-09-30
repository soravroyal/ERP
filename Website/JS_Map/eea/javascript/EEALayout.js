//Adds elements and functionality to ESRI JavaScript BasicViewer Template
dojo.require("utilities.agsjs.dijit.TOC");
dojo.require("eea.widgets.ChartComponent");
dojo.require("eea.widgets.TableComponent");
dojo.require("dojo._base.Deferred");
dojo.require("esri.IdentityManager");
dojo.require("esri.arcgis.Portal");
dojo.require("dojo.window");
dojo.require("dgrid.OnDemandGrid");
dojo.require("dgrid.Selection");
dojo.require("dojo.store.Memory");

var configOptions, map, layers, toc, originalFieldInfos = {};
;
/**
 *
 *  Add GUI elements
 *
 * */

/*** End Add GUI elements ****/

/*** function calls ***/
function getEEAConfigDefaults(options) {

    //config defaults:
    configOptions = options;
    if (!configOptions.customlogo || configOptions.customlogo.image === "") {
        configOptions.customlogo = {
            image : 'eea\\assets\\images\\EEALogo232x35.png',
            link : 'http://eea.europa.eu'
        }
    } else if (!configOptions.customlogo.image) {
        configOptions.customlogo = {
            image : configOptions.customlogoimage,
            link : configOptions.customlogolink || ''
        }
    }
    if (!configOptions.toplogo) {
        configOptions.toplogo = {
            image : 'http://eyeonearth.org/templates/images/eye_on_earth.png',
            link : 'http://eyeonearth.org'
        }
    }
    if (configOptions.toplogoimage !== undefined)
        configOptions.toplogo.image = configOptions.toplogoimage;
    if (configOptions.toplogolink !== undefined)
        configOptions.toplogo.link = configOptions.toplogolink;
    if (!configOptions.facebook) {
        configOptions.facebook = {
            image : 'eea\\assets\\images\\face_book_trans-25.png',
            link : 'http://www.facebook.com/pages/Eye-on-Earth/158471324249252'
        }
    }
    if (configOptions.facebookimage !== undefined)
        configOptions.facebook.image = configOptions.facebookimage;
    if (configOptions.facebooklink !== undefined)
        configOptions.facebook.link = configOptions.facebooklink;
    if (!configOptions.twitter) {
        configOptions.twitter = {
            image : 'eea\\assets\\images\\twitter_trans_25.png',
            link : 'https://twitter.com/eyeonearthorg'
        }
    }
    if (configOptions.twitterimage !== undefined)
        configOptions.twitter.image = configOptions.twitterimage;
    if (configOptions.twitterlink !== undefined)
        configOptions.twitter.link = configOptions.twitterlink;
    if (configOptions.excludeValues === "") {
        configOptions.excludeValues = null;
    } else if (( typeof configOptions.excludeValues) === "string") {
        configOptions.excludeValues = configOptions.excludeValues.split(",");
    }

    configOptions.sourceCountry = configOptions.sourceCountry ? configOptions.sourceCountry : "";

    return configOptions;
}

var chartConfig, chartComponent, user, portal;
//var settingChart = false;
var customChartMapping = {};
function addCustomChart(selection, appid) {
    if (customChartMapping[appid]) {
        chartConfig = customChartMapping[appid];
        if (chartComponent) {
            chartComponent.destroyRecursive();
        }
        var outputOptions = {
            proxy : configOptions.proxyurl,
            'chartType' : chartConfig.chart_chartType,
            'restUrl' : chartConfig.chart_restUrl,
            'chartTitle' : chartConfig.chart_title,
            'chartCaption' : chartConfig.chart_caption,
            'whereclause' : chartConfig.chart_whereclause
        }
        if (chartConfig.chart_outputtype !== 'table') {
            outputOptions.id = "customChart";
            outputOptions.maxSeries = chartConfig.chart_maxSeries;
            outputOptions.noMax = chartConfig.chart_noMax;
            outputOptions.theme = chartConfig.chart_theme;
            outputOptions.yearAxis = chartConfig.chart_yearAxis || false;
            outputOptions.dateAxis = chartConfig.chart_dateAxis || false;
            outputOptions.swapSerieAndFields = chartConfig.chart_swapSeriAndFields || false;
            outputOptions.seriesColors = chartConfig.chart_seriesColors;
            outputOptions.seriesnameField = chartConfig.chart_seriesnameField;
            chartComponent = new eea.widgets.ChartComponent(outputOptions);
        } else {
            chartComponent = new eea.widgets.TableComponent(outputOptions);
        }

        chartComponent.startup();
        chartComponent.set('joinFields', chartConfig.chart_joinFields);
        chartComponent.set('tableFields', chartConfig.chart_tableFields);
        //chartComponent.placeAt('legendPanel');

        chartComponent.set('selection', map.infoWindow.getSelectedFeature());
        var popupMainSection = dojo.query(".mainSection", map.infoWindow.domNode);
        chartComponent.placeAt(popupMainSection[0]);

        // map.infoWindow.setContent(chartComponent.domNode);
        // settingChart = false;
    } else {
        getChartConfig(selection, appid)
    }
}

function getChartConfig(selection, appid) {
    var deferred = getChartItem(appid);
    // getChartItem("2bb3089c7f794234937641fe6aab58b2");
    //selection.chartmedie. appid
    deferred.then(function(response) {
        chartConfig = response.itemData.values;
        customChartMapping[appid] = chartConfig;
        addCustomChart(selection, appid);
    })
}

function getChartItem(appid) {
    var deferred = new dojo._base.Deferred();
    esri.arcgis.utils.getItem(appid).then(function(response) {
        deferred.resolve(response);
    });
    return deferred.promise;
}

function setSelection(evt) {
    // if (!settingChart) {
    var selection = map.infoWindow.getSelectedFeature();
    var i, appid, originalInfoset = false;
    if (selection && selection._graphicsLayer) {
        var infotemplate = selection._graphicsLayer.infoTemplate;
        /***   Do not show aliases in list for attributes that have no value ****/
        if (configOptions.hideEmptyValues || (configOptions.excludeValues && configOptions.excludeValues.length < 0)) {
            if (!originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]]) {
                //remember original fieldInfos list
                originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]] = infotemplate.info.fieldInfos.slice(0);
                originalInfoset = true;
            }
            //filter out fieldinfos with no values or values to exclude
            infotemplate.info.fieldInfos = dojo.filter(infotemplate.info.fieldInfos, function(fInfo) {
                var include = true;
                var show = true;
                if (configOptions.excludeValues) {
                    for ( i = 0; i < configOptions.excludeValues.length; i++) {
                        include = selection.attributes[fInfo.fieldName] !== configOptions.excludeValues[i] && selection.attributes[fInfo.fieldName] !== Number(configOptions.excludeValues[i]);
                    }
                }
                if (configOptions.hideEmptyValues) {
                    show = selection.attributes[fInfo.fieldName] !== null && selection.attributes[fInfo.fieldName] !== " " && selection.attributes[fInfo.fieldName] !== "";
                }
                return show && include;
            })
            if (originalInfoset && infotemplate.info.fieldInfos.length !== originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]].length) {
                //reselect to apply updated fieldinfo
                map.infoWindow.select(map.infoWindow.selectedIndex);
            } else {
                // return to original fieldinfo list
                originalInfoset = false;
                if (originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]]) {
                    infotemplate.info.fieldInfos = originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]].slice(0);
                    delete originalFieldInfos[selection._graphicsLayer.id + "_" + selection.attributes[selection._graphicsLayer.objectIdField]];
                }
            }
        }
        /** end  **/
        if (customChartMapping[selection._graphicsLayer.id]) {
            appid = customChartMapping[selection._graphicsLayer.id];
        } else if (infotemplate && infotemplate.info.mediaInfos && !originalInfoset) {
            for ( i = 0; i < infotemplate.info.mediaInfos.length; i++) {
                var info = infotemplate.info.mediaInfos[i];
                var title = String(info.title)
                var caption = String(info.caption)
                if (title.match("appid")) {
                    appid = title.replace("appid=", "");
                    customChartMapping[selection._graphicsLayer.id] = appid;
                    //remove this chart settings from media infos to display custom chart instead:
                    infotemplate.info.mediaInfos.splice(i, 1);

                } else if (caption.match("_table") || caption.match("_percenttable")) {
                    var data = {};
                    data.attributes = selection.attributes;
                    data.fields = infotemplate._fieldLabels;
                    //add table with values defined in web map chart section
                    // set fields in the caption and prefix with either '_table' or '_percenttable'
                    //use '_percenttable to calculate and show an extra row in table with percentages of numeric values'
                    var h, j, percent = caption.match("_percenttable");
                    var percentages = [];
                    sum = 0;
                    //var chart = infotemplate.info.mediaInfos.splice(i, 1);
                    var popupMainSection = dojo.query(".mainSection", map.infoWindow.domNode);
                    var tablefields = caption.replace("_table:", "")
                    tablefields = tablefields.replace("_percenttable:", "")
                    tablefields = tablefields.replace(/{/g, "")
                    tablefields = tablefields.replace(/}/g, "").split(",");

                    var tablecontent = "";
                    var tablecaptions = "";
                    var tablepercents = "";
                    var tablevalues = "";
                    h = 0;
                    for ( j = 0; j < tablefields.length; j++) {
                        tablecaptions += "<th>" + infotemplate._fieldLabels[tablefields[j]] + "</th>";
                        var value = selection.attributes[tablefields[j]];
                        if (percent) {

                            if (isNaN(value))
                                value = value.replace(",", ".");
                            if (!isNaN(Number(value)) && value != "" && value != " ") {
                                tablepercents += "<td>{" + h + "}</td>";
                                percentages.push(Number(value));
                                sum += Number(value);
                                h++;
                            } else {
                                tablepercents += "<td>&nbsp;</td>";
                            }

                        }
                        tablevalues += "<td>" + value + "</td>";
                    }
                    for ( j = 0; j < percentages.length; j++) {
                        if (sum === 0)
                            sum = 1;
                        percentages[j] = percentages[j] / sum * 100;
                        tablepercents = tablepercents.replace("{" + j + "}", "~" + percentages[j].toFixed(1) + "%")
                    }

                    if (tablepercents) {
                        tablepercents = "<tr>" + tablepercents + "</tr>";
                    }
                    tablecontent += "<tr>" + tablecaptions + "</tr>" + tablepercents + "<tr>" + tablevalues + "</tr>";

                    var table = dojo.create("table", {
                        innerHTML : tablecontent,
                        class : 'gradienttable'
                    })
                    dojo.place("<b>" + title + "<b>", popupMainSection[0], 'last');
                    dojo.place(table, popupMainSection[0], 'last');

                }
            }

        }
    }
    if (appid) {
        //  getUser();
        addCustomChart(selection, appid);
    }

    //   settingChart = true;
    // }
}

var fieldsGrid
function createTable(data, tablefields) {
    require(["dojo/_base/declare", "dgrid/OnDemandGrid"], function(declare, OnDemandGrid) {

        var i, columns = {};
        var rows = [];
        var popupMainSection = dojo.query(".mainSection", map.infoWindow.domNode);
        var obj = {};
        for ( j = 0; j < tablefields.length; j++) {
            columns[tablefields[j]] = {
                "label" : data.fields[tablefields[j]]
            }
            obj[tablefields[j]] = data.attributes[tablefields[j]]

        }
        rows.push(obj)
        var fieldsStore = new dojo.store.Memory({
            data : rows
        });
        if (fieldsGrid)
            fieldsGrid.destroy();
        if (!fieldsGrid) {
            fieldsGrid = new (declare([OnDemandGrid]))({
                columns : columns
            });
            //fieldsGrid.startup();
            //  domConstruct.place(this.fieldsGrid.domNode, this.tableContainer);
            //   fieldsGrid.set('columns', columns);

            fieldsGrid.set('class', 'fieldGrid');
            dojo.place(fieldsGrid.domNode, popupMainSection[0], 'last');
        }
        fieldsGrid.set('store', fieldsStore);
    })
}

function getUser() {
    if (user) {
        addCustomChart(selection, appid);
    } else {
        esri.id.signIn().then(dojo.hitch(this, function(usr) {
            user = usr;
            addCustomChart(selection, appid);
            esri.config.defaults.io.alwaysUseProxy = false;
        }));
        /* esri.config.defaults.io.alwaysUseProxy = true;
         var portal = new esri.arcgis.Portal('http://www.arcgis.com');

         portal.signIn().then(dojo.hitch(this, function(usr) {
         user = usr;
         addCustomChart(selection, appid);
         esri.config.defaults.io.alwaysUseProxy = false;
         }));*/
    }
}

function addEEALayout(options, mapObject, mapLayers, response) {
    //config
    configOptions = options;
    map = mapObject;
    layers = mapLayers;

    if (configOptions.visiblelayers)
        initialVisibleLayers()

    //add html elements:
    //Top right corner: logo, facebook, twitter and sync extent tool container
    navHTML = '<div id="facebook" class="facebook"></div>' + '<div id="twitter" class="twitter"></div>' + '<div id="headerlogo_right" class="headerlogo_right"></div>' + '<div id="syncActions"></div>';
    dojo.create("div", {
        id : 'logoAndSocial',
        innerHTML : navHTML
    }, "header");

    //iframe container
    dojo.create("div", {
        id : 'iframeContainer'
    }, "bc");

    //custom chart
    dojo.connect(map.infoWindow, 'onShow', setSelection);
    dojo.connect(map.infoWindow, 'onSelectionChange', setSelection);

    /* if (configOptions.embed) {

    var unembedbtn = new dijit.form.Button({
    showLabel : false,
    label : "", //i18n.tools.unembed.label,
    title : "Go to fullscreen map", //i18n.tools.unembed.title,
    iconClass : 'unembedlink',
    id : 'unembedButton',
    onClick: function(){window.location.href = window.location.href +"?appid=" + configOptions.appid + "&webmap=" + configOptions.webmap}
    }, dojo.create('div'));
    dojo.byId('webmap-toolbar-fullscreen').appendChild(unembedbtn.domNode);

    }*/

    //splitters:
    /*dijit.byId("leftPane").params.splitter = true;
     dijit.byId("leftPane").params.minSize = 120;*/
    dijit.byId("leftPane").set("gutters", true);
    dijit.byId("leftPane").set("splitter", true);
    dijit.byId("leftPane").set("minSize", 120);

    require(["dojo/dom-attr"], function(domAttr) {
        // use setAttr() to set the tab index
        domAttr.set("leftPane", "data-dojo-props", "design:'headline', gutters:false,region:'left',splitter:true,minSize:120");

    });

    dijit.byId("leftPane").resize();
    /* var lp = dijit.byId("leftPane");

    var content = dijit.byId("leftPane").domNode.innerHTML;
    var parentNode = dijit.byId("leftPane").domNode.parentNode;

    var parent = dijit.byId(parentNode.id)*/
    // parent.removeChild(lp);
    // lp.id = "yy";
    // var newLp
    /*  lp = new dijit.layout.BorderContainer({

    region : 'left',
    design: 'headline',
    splitter:true,
    minSize:120,
    innerHTML : content
    });*/
    //  bc.placeAt(parentNode.id,"first");
    //  parent.addChild(lp);
    //set functionality
    addTopLogoAndSocialMedia();
    if(!configOptions.displaylayerlist === false && configOptions.tocLevel)addToc();
}

/*** END function calls ***/

/**
 *
 *  Add functions
 *
 * */

//logo facebook, twitter function
function addTopLogoAndSocialMedia() {
    if (!configOptions.embed && (configOptions.displaytitle === 'true' || configOptions.displaytitle === true) && configOptions.toplogo) {

        if (configOptions.toplogo.image) {
            var link = dojo.create('a', {
                href : configOptions.toplogo.link,
                target : '_blank'
            }, dojo.byId('headerlogo_right'));
            dojo.create('img', {
                src : configOptions.toplogo.image,
                border : '0'
            }, link);
        }
        var facebook_link = dojo.create('a', {
            href : configOptions.facebook.link,
            target : '_blank'
        }, dojo.byId('facebook'));
        dojo.create('img', {
            src : configOptions.facebook.image,
            border : '0'
        }, facebook_link);

        var twitter_link = dojo.create('a', {
            href : configOptions.twitter.link,
            target : '_blank'
        }, dojo.byId('twitter'));
        dojo.create('img', {
            src : configOptions.twitter.image,
            border : '0'
        }, twitter_link);

        setTimeout(function() {
            dojo.style(dojo.byId("header"), "height", "38px");
            ;
        }, 100);
        //dojo.style(dojo.byId("header"), "height", "38px");

    }
}

function addDetails(response) {
    // if (configOptions.description === "") {
    if (response.itemInfo.item.description !== null) {
        configOptions.description = "<div><b>Description</b></div> " + response.itemInfo.item.description;
    }
    if (response.itemInfo.item.licenseInfo !== null) {
        configOptions.description = (configOptions.description != "") ? configOptions.description + "<br/><div><b>Access and Use Constraints</b></div> " + response.itemInfo.item.licenseInfo : response.itemInfo.item.licenseInfo;
    }
    if (response.itemInfo.item.accessInformation !== null) {
        configOptions.description = (configOptions.description != "") ? configOptions.description + "<br/><div><b>Credits</b></div> " + response.itemInfo.item.accessInformation : response.itemInfo.item.accessInformation;
    }
    //    }

}

function keepTimeInit() {

    if (configOptions.keepTime) {
        toggleTime(timeProperties);
    }
}

function initialVisibleLayers() {
    dojo.forEach(layers, function(layer) {
        if (layer.layerObject && layer.layerObject.type != "Feature Layer")
            layer.layerObject.setVisibleLayers(configOptions.visiblelayers.split(","));
    })
}

function addIframeLayerTemplate() {

}

function addToc() {
    var hideFromToc, layerInfos = [];
    dojo.forEach(layers, function(layer) {
        //noLayers option excludes legend noLegend:true will exclude sublayers (the two has been mixed up in toc dijit)
        if (layer.featureCollection) {
            dojo.forEach(layer.featureCollection.layers, function(flayer) {
                if (flayer.featureSet.features.length > 0) {
                    if (flayer.showLegend !== false) {
                        layerInfos.push({
                            title : flayer.layerObject.name,
                            layer : flayer.layerObject,
                            noLayers : true
                        });
                    }
                }
            });
        } else if (layer.showLegend !== false) {
            if (configOptions.showLegendToTOC !== 'false' && configOptions.showLegendToTOC !== false) {
                hideFromToc = dojo.filter(layer.layers, function(layerinfo) {
                    return layerinfo.showLegend === false;
                })

                layer.layerObject.layerInfos = dojo.filter(layer.layerObject.layerInfos, function(layerinfo) {
                    var i, include = true;
                    for ( i = 0; i < hideFromToc.length; i++) {
                        if (layerinfo.id === hideFromToc[i].id) {
                            include = false;
                        }
                    }
                    return include;

                })
            }
            layerInfos.push({
                title : layer.title,
                layer : layer.layerObject,
                noLayers : !(configOptions.legendInLayers === 'true' || configOptions.legendInLayers === true)
            });
        }

    })
    var vs = dojo.window.getBox();

    var style = dojo.create("style", {
        type : "text/css"
    }, dojo.query("head")[0]);
    dojo.attr(style, {
        innerHTML : ".dynamicTOCCssClass { max-height: " + [vs.h - 200] + "px; overflow-y:auto !important; overflow-x: hidden !important;}"
    });

    toc = new agsjs.dijit.TOC({
        map : map,
        layerInfos : layerInfos,
        maxLevel : configOptions.tocLevel || null,
        id : 'toc_dijit',
        class : 'dynamicTOCCssClass'
    });
    toc.startup();

    this._refreshTimer = window.setTimeout(function() {
        addTOCToToolbar()
    }, 700);
}

function addTOCToToolbar() {
    if (this._refreshTimer)
        clearTimeout(this._refreshTimer);
    if (dojo.byId('webmap-toolbar-center')) {
        var button = new dijit.form.DropDownButton({
            label : i18n.tools.layers.label,
            id : "alllayerBtn",
            iconClass : "esriLayerIcon",
            title : i18n.tools.layers.title,
            dropDown : toc,
            width : 'auto'
        });
        toc.legend = dijit.byId('legend');
        dojo.byId('webmap-toolbar-center').appendChild(button.domNode);
        // dijit.byId('layerBtn').hide();
        dojo.style(dojo.byId("layerBtn"), "display", "none");
    } else {
        this._refreshTimer = window.setTimeout(function() {
            addTOCToToolbar()
        }, 700);
    }
}

/*** End add functiosn ****/

