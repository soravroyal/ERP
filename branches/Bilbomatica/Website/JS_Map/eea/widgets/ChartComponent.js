define(["dijit/_Templated", "dijit/_WidgetBase", "dojo/_base/declare", "dojo/dom-class", "dojo/domReady!", "dojo/on", "dojo/_base/array", "dojo/_base/lang", 
"dojox/charting/Chart", "dojox/charting/axis2d/Default", "dojox/charting/plot2d/ClusteredColumns", "dojo/fx/easing", "dojox/charting/plot2d/Pie",
 "dojox/charting/action2d/MoveSlice", "dojox/charting/action2d/Tooltip", "dojox/charting/plot2d/StackedAreas", "dojox/charting/plot2d/ClusteredBars", 
 "dojox/charting/plot2d/Lines", "dojox/charting/widget/Legend", "dojox/charting/SimpleTheme", "dojox/charting/themes/Tufte", "dojox/charting/themes/MiamiNice", "dojox/charting/themes/Wetland", 
 "dojox/charting/themes/Harmony", "dojox/charting/themes/Desert", "dojox/charting/themes/Grasslands", "dojox/charting/themes/PrimaryColors", 
 "dojox/charting/themes/SageToLime", "dojox/charting/themes/CubanShirts"], function(Templated, WidgetBase, declare, domClass, ready, on, array, lang, Chart, Default, 
     ClusteredColumns, easing, Pie, MoveSlice, Tooltip, StackedAreas, ClusteredBars, Lines, Legend, SimpleTheme,Tufte, MiamiNice, Wetland, Harmony, Desert, Grasslands, PrimaryColors, SageToLime, CubanShirts) {
    declare("eea.widgets.ChartComponent", [WidgetBase, Templated], {
        templateString : dojo.cache("eea.widgets", "templates/ChartComponent.html"),
        widgetsInTemplate : false,

        //get a layer/table and extract all fields, expose these
        //two layers? also the one to use join fields

        constructor : function(options, srcRefNode) {

            // expected properties and values for the options argument:
            this.inherited(arguments);

            //default values
            this.selection = null;
            this.joinFields = [];
            this.tableFields = [];
            /** type
             * bars|columns|pie|lines|stackedarea
             */
            this.chartType = "pie";
            this.seriesnameField = "";
            this.restUrl = "";
            this.chartData = null;
            this.propertychanged = true;
            this.chartTitle = "";
            this.chartCaption = "";
            this.maxSeries = 5;
            this.noMax = false;
            this.whereclause = "";
            this.colortheme = MiamiNice;
            this.yearAxis = false;
            this.dateAxis = false;
            this.swapSerieAndFields = false;

            //watch changes
            this.watch("chartType", this.updateChartType);
            this.watch("selection", this.updateSelection);
            this.watch("joinFields", this.updateJoinFields);
            this.watch("tableFields", this.updateTableFields);
            this.watch("restUrl", this.updateRestUrl);
            this.watch("seriesnameField", this.updateseriesnameField);
            this.watch("chartData", this.updateChartData);
            this.watch("chartTitle", this.updateChartTitle);
            this.watch("chartCaption", this.updateChartCaption);
            this.watch("maxSeries", this.updateMaxSeries);
            this.watch("theme", this.updateTheme);
            this.watch("seriesColors", this.updateSeriesColors);

           
            // mixin constructor options
            dojo.safeMixin(this, options);

            if (( typeof this.theme) === "string") {
                this.colortheme = eval(this.theme);
            }
           /* if (( typeof this.seriesColors) === "string") {
                this.set('seriesColors', this.seriesColors.split(","));
            }*/
            if (this.seriesColors) {
                this.updateSeriesColors(null,null, this.seriesColors);
            }

            if (( typeof this.joinFields) === "string") {
                this.joinFields = this.parseJoinFieldsConfig(this.joinFields);
            }
            if (( typeof this.tableFields) === "string") {
                this.tableFields = this.tableFields.split(",");
            }
        },

        postCreate : function() {
            this.inherited(arguments);
        },
        startup : function() {
            this.inherited(arguments);
            var link = dojo.create("link", {
                type : "text/css",
                rel : "stylesheet",
                href : "eea/widgets/css/ChartComponent.css"

            });
            dojo.doc.getElementsByTagName("head")[0].appendChild(link);
        },
        updateChartType : function(attr, oldVal, newVal) {
            this.chartType = newVal;
            if (this.chartData) {
                this.createChart(this.chartData);
            }
        },
        updateSelection : function(attr, oldVal, newVal) {
            this.propertychanged = true;
            if (newVal.features) {
                this.selection = newVal.features[0];
            } else {
                this.selection = newVal;
            }
            this.updateChart()
            // this.setSelection(newVal);
        },
        updateJoinFields : function(attr, oldVal, newVal) {
            this.joinFields = newVal;
            if ( typeof this.joinFields === "string") {
                this.joinFields = this.parseJoinFieldsConfig(this.joinFields);
            }
            this.propertychanged = true;
            //   this.queryRESTService();
        },
        updateTableFields : function(attr, oldVal, newVal) {
            this.tableFields = newVal;
            if ( typeof this.tableFields === "string") {
                this.tableFields = this.tableFields.split(",");
            }
            this.propertychanged = true;
            // this.queryRESTService();
        },
        updateRestUrl : function(attr, oldVal, newVal) {
            this.restUrl = newVal;
            this.propertychanged = true;
            //   this.queryRESTService();
        },
        updateseriesnameField : function(attr, oldVal, newVal) {
            this.seriesnameField = newVal;
            if (this.chartData) {
                this.createChart(this.chartData);
            }
        },
        updateChartData : function(attr, oldVal, newVal) {
            this.chartData = newVal;
            this.createChart(this.chartData);
        },
        updateChartTitle : function(attr, oldVAl, newVal) {
            this.chartTitle = newVal;
            if (this.selection) {
                this.chartTitleDiv.innerHTML = this.substituteFieldNames(newVal, this.selection.attributes);
            } else {
                this.chartTitleDiv.innerHTML = newVal;
            }
        },
        updateChartCaption : function(attr, oldVAl, newVal) {
            this.chartCaption = newVal;
            if (this.selection) {
                this.chartCaptionDiv.innerHTML = this.substituteFieldNames(newVal, this.selection.attributes);
            } else {
                this.chartCaptionDiv.innerHTML = newVal;
            }
        },
        updateMaxSeries : function(attr, oldVAl, newVal) {
            if (!isNaN(newVal)) {
                this.maxSeries = newVal;
            }
        },
        updateTheme : function(attr, oldVAl, newVal) {
            if (newVal) {
                this.theme  = newVal;
                this.colortheme = eval(newVal);
                if (this.chartData) {
                    this.createChart(this.chartData);
                }
            }
        },
        updateSeriesColors : function(attr, oldVAl, newVal) {
            this.seriesColors = newVal;     
            if (newVal && newVal.length > 0) {          
                this.colortheme = new SimpleTheme({
                    colors : this.seriesColors
               });   
           }
        },
        substitute : function(str, arr) {
            var i, pattern, re, n = arr.length;
            for ( i = 0; i < n; i++) {
                pattern = "\\{" + i + "\\}";
                re = new RegExp(pattern, "g");
                str = str.replace(re, arr[i]);
            }
            return str;
        },
        substituteFieldNames : function(str, obj) {
            var i, pattern, re;
            Object.getOwnPropertyNames(obj).forEach(function(val, idx, array) {
                pattern = "\\{" + val + "\\}";
                re = new RegExp(pattern, "g");
                str = str.replace(re, obj[val]);
            });
            return str;

        },
        setSelection : function(selection) {
            if (selection) {
                if (selection.features) {
                    this.selection = selection.features[0];
                    //       this.set('seriesnameField', newVal.seriesnameField);
                } else {
                    this.selection = selection;
                }
                if (this.propertychanged) {
                    this.chartData = null;
                    this.queryRESTService();
                } else {
                    this.createChart(this.chartData);
                }

                this.updateChartTitle(null, "", this.chartTitle);
                this.updateChartCaption(null, "", this.chartCaption);
            }
        },
        updateChart : function() {
            if (this.selection) {
                if (this.propertychanged) {
                    this.chartData = null;
                    this.queryRESTService();
                } else {
                    this.createChart(this.chartData);
                }
                this.updateChartTitle(null, "", this.chartTitle);
                this.updateChartCaption(null, "", this.chartCaption);
            }
        },
        createChart : function(data) {
            var labelfunction;
            if (this.chart) {
                this.chart.destroy();
                this.chart = null;
            }
            var labels = dojo.map(data.fields, function(field, idx) {
                return {
                    value : idx + 1,
                    text : field.alias
                }
            });
            /*if (( typeof this.theme) === "string") {
                this.theme = eval(this.theme);
            }*/
            if (this.yearAxis) {
                labelfunction = this.getYearLabel;
                labels = null;
            } else if (this.dateAxis) {
                //utc date
                labelfunction = this.getDateLabel;
                labels = null;
            }

            var type;
            switch(this.chartType) {
                case "bars":
                    type = ClusteredBars;
                    this.chart = new Chart(this.chartContainer);
                    this.chart.setTheme(this.colortheme).addAxis("x", {
                        labels : labels,
                        labelFunc : labelfunction,
                        fixLower : "minor",
                        fixUpper : "minor",
                        natural : true
                    }).addAxis("y", {
                        vertical : true,
                        fixLower : "major",
                        fixUpper : "major",
                        includeZero : true
                    }).addPlot("default", {
                        type : type,
                        gap : 10,
                        animate : {
                            duration : 2000,
                            easing : easing.bounceInOut
                        }
                    })
                    this.addChartSeries(data);
                    break;
                case "columns":
                    type = ClusteredColumns;
                    this.chart = new Chart(this.chartContainer);
                    this.chart.setTheme(this.colortheme).addAxis("x", {
                        labels : labels,
                        labelFunc : labelfunction,
                        fixLower : "minor",
                        fixUpper : "minor",
                        natural : true
                    }).addAxis("y", {
                        vertical : true,
                        fixLower : "major",
                        fixUpper : "major",
                        includeZero : true
                    }).addPlot("default", {
                        type : type,
                        gap : 10,
                        animate : {
                            duration : 2000,
                            easing : easing.bounceInOut
                        }
                    })
                    this.addChartSeries(data);
                    break;
                case "pie":
                    type = Pie;
                    this.chart = new Chart(this.chartContainer);
                    this.chart.setTheme(this.colortheme).addPlot("default", {
                        type : type,
                        labels : false,
                        font : "normal normal 11pt Tahoma",
                        fontColor : "black",
                        labelOffset : -30,
                        radius : 180
                    })

                    this.addChartSeries(data);
                    var anim_a = new MoveSlice(this.chart, "default");
                    break;
                case "lines":

                    type = Lines;
                    this.chart = new Chart(this.chartContainer);
                    this.chart.setTheme(this.colortheme).addAxis("x", {
                        labels : labels,
                        labelFunc : labelfunction,
                        shadows : {
                            dx : 2,
                            dy : 2,
                            dw : 2
                        }/*,
                         fixLower : "minor",
                         fixUpper : "minor",
                         natural : true*/
                    }).addAxis("y", {
                        vertical : true,
                        fixLower : "major",
                        fixUpper : "major",
                        includeZero : true
                    }).addPlot("default", {
                        type : type,
                        markers : true,
                        shadows : {
                            dx : 2,
                            dy : 2,
                            dw : 2
                        },
                        animate : {
                            duration : 2000,
                            easing : easing.bounceInOut
                        }

                    })
                    this.addChartSeries(data);
                    break;
                case "stackedareas":
                    type = StackedAreas;
                    this.chart = new Chart(this.chartContainer);
                    this.chart.addAxis("x", {
                        labels : labels,
                        fixLower : "major",
                        labelFunc : labelfunction,
                        fixUpper : "major"
                    }).addAxis("y", {
                        vertical : true,
                        fixLower : "major",
                        fixUpper : "major",
                        min : 0
                    }).setTheme(this.colortheme).addPlot("default", {
                        type : type,
                        gap : 10,
                        animate : {
                            duration : 2000,
                            easing : easing.bounceInOut
                        }
                    })
                    this.addChartSeries(data);
                    break;
            }
            var anim_c = new Tooltip(this.chart, "default");

            this.chart.render();
            if (this.legend) {
                this.legend.destroyRecursive();
            }
            this.legend = new Legend({
                chart : this.chart
            });
            this.legend.placeAt(this.legendContainer);
            dojo.addClass(this.legend.domNode, "legend");
            this.propertychanged = false;

        },
        getYearLabel : function(o) {
            var date = new Date();
            var str = String(o).replace(",", "");
            var n = Number(str);
            if (!isNaN(n) && str.length === 4) {
                date.setYear(n);
                var d = date.getFullYear();
            } else {
                d = o;
            }
            return d;
        },
        getDateLabel : function(o) {
            var date = new Date();
            date.setTime(o);
            var d = (date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getFullYear();
            return d;
        },
        queryRESTService : function() {
            if (this.restUrl && this.selection && this.tableFields && this.joinFields) {
                var joinValue, joinOn, whereclause, outfields;
                whereclause = this.whereclause;
                outfields = lang.clone(this.tableFields);
                outfields.push(this.seriesnameField);
                for ( i = 0; i < this.joinFields.length; i++) {
                    whereclause = whereclause === "" ? whereclause : whereclause + " AND ";
                    joinOn = this.joinFields[i];
                    outfields.push(joinOn.field);
                    if (joinOn.type === 'string') {
                        joinValue = (this.selection.attributes[joinOn.featurefield]).trim();
                        whereclause = joinValue ? whereclause + joinOn.field + "='" + joinValue + "'" : whereclause;
                    } else {
                        joinValue = this.selection.attributes[joinOn.featurefield]
                        whereclause = joinValue ? whereclause + joinOn.field + "=" + joinValue : whereclause;
                    }

                }

                var query = this.restUrl + "/query?where=" + whereclause + "&outFields=" + outfields + "&returnGeometry=false&f=json";

                if (whereclause) {
                    var xhrArgs, deferred;

                    //Add date now to avoid cache in browser
                    var proxy = this.proxy ? this.proxy + "?" : "";
                    query = proxy + query;

                    // The parameters to pass to xhrGet
                    xhrArgs = {
                        url : query,
                        handleAs : "json",
                        dataType : "json",
                        cache : false,
                        headers : {
                            'Content-Type' : 'application/json;'
                        },

                        error : function(error) {

                            alert("Query failed : " + error);
                        }
                    }
                    // Call xhrGet to read item data
                    //deferred = dojo.xhrGet(xhrArgs);
                    deferred = dojo.xhrPost(xhrArgs);
                    deferred.then(dojo.hitch(this, function(data) {
                        dojo.hitch(this, this.loadQueryResults(data));
                    }))
                } else if (this.chart) {
                    this.chart.destroy();
                    this.chart = null;
                }
            }
        },
        loadQueryResults : function(data) {
            this.set('chartData', data);

        },
        addChartSeries : function(data) {
            var arr;
            if (!this.noMax) {
                arr = data.features.slice(0, this.maxSeries);
            } else {
                arr = data.features
            }
            if (this.swapSerieAndFields && !isNaN(arr[0].attributes[this.seriesnameField])) {

                for ( i = 0; i < this.tableFields.length; i++) {
                    var series = [];
                    var obj, a = this.tableFields[i];
                    seriesName = a;
                    for ( ii = 0; ii < arr.length; ii++) {
                        var feature = arr[ii];
                        obj = {
                            y : feature.attributes[a],
                            x : Number(feature.attributes[this.seriesnameField]),
                            text : data.fieldAliases[a],
                            /*stroke : "black",*/
                            tooltip : seriesName + " " + feature.attributes[this.seriesnameField] + ": " + feature.attributes[a]
                        }
                        series.push(obj);
                    }
                    this.chart.addSeries(seriesName, series);
                }

            } else {
                var data = dojo.map(arr, dojo.hitch(this, function(feature, idx) {
                    var series = [];
                    var seriesName = feature.attributes[this.seriesnameField] || this.selection.attributes[this.seriesnameField] || this.selection.attributes[this.joinFieldName];

                    for (a in feature.attributes) {
                        var obj;

                        if (array.indexOf(this.tableFields, a) !== -1) {
                            obj = {
                                y : feature.attributes[a],
                                text : data.fieldAliases[a],
                                stroke : "black",
                                tooltip : seriesName + " " + data.fieldAliases[a] + ": " + feature.attributes[a]
                            }
                            series.push(obj);
                        }
                    }
                    this.chart.addSeries(seriesName, series);

                }))
            }
        },
        parseJoinFieldsConfig : function(infos) {
            var fields = [];
            value_arr = infos.split(",");
            for ( i = 0; i < value_arr.length; i++) {
                value = value_arr[i].split(":");
                fields.push({
                    field : value[0],
                    featurefield : value[1],
                    type : value[2]

                })

            }
            return fields;
        },
        reset : function() {
            this.chartData = null;
            if (this.chart) {
                this.chart.destroy();
                this.chart = null;
            }
        }
    })
})

