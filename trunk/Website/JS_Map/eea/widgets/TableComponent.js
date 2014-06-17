define(["dijit/_Templated", "dijit/_WidgetBase", "dojo/_base/declare", "dojo/dom-class", "dojo/domReady!", "dojo/on", "dojo/_base/array", "dojo/_base/lang", "dgrid/OnDemandGrid", "dgrid/Selection", "dojo/store/Memory","dojo/date/stamp", "dojo/date/locale"], function(Templated, WidgetBase, declare, domClass, ready, on, array, lang, OnDemandGrid, Selection, Memory, stamp, locale) {
    declare("eea.widgets.TableComponent", [WidgetBase, Templated], {
        templateString : dojo.cache("eea.widgets", "templates/TableComponent.html"),
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

            this.restUrl = "";
            this.chartData = null;
            this.propertychanged = true;
            this.chartTitle = "";
            this.chartCaption = "";
            this.layout = "table";
            // "list" | "table"

            this.whereclause = "";

            //watch changes
            this.watch("selection", this.updateSelection);
            this.watch("joinFields", this.updateJoinFields);
            this.watch("tableFields", this.updateTableFields);
            this.watch("restUrl", this.updateRestUrl);
            this.watch("chartData", this.updateTableData);
            this.watch("chartTitle", this.updateTableTitle);
            this.watch("chartCaption", this.updateTableCaption);
            this.watch("layout", this.updateLayout);

            // mixin constructor options
            dojo.safeMixin(this, options);

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
                href : "eea/widgets/css/TableComponent.css"

            });
            dojo.doc.getElementsByTagName("head")[0].appendChild(link);
        },

        updateSelection : function(attr, oldVal, newVal) {
            this.propertychanged = true;
            if (newVal.features) {
                this.selection = newVal.features[0];
            } else {
                this.selection = newVal;
            }
            this.updateTable()
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
        updateTableData : function(attr, oldVal, newVal) {
            this.chartData = newVal;
            if (this.layout === "table") {
                this.createTable(this.chartData);
            } else {
                this.createList(this.chartData);
            }
        },
        updateTableTitle : function(attr, oldVAl, newVal) {
            this.chartTitle = newVal;
            if (this.selection) {
                this.chartTitleDiv.innerHTML = this.substituteFieldNames(newVal, this.selection.attributes);
            } else {
                this.chartTitleDiv.innerHTML = newVal;
            }
        },
        updateTableCaption : function(attr, oldVAl, newVal) {
            this.chartCaption = newVal;
            if (this.selection) {
                this.chartCaptionDiv.innerHTML = this.substituteFieldNames(newVal, this.selection.attributes);
            } else {
                this.chartCaptionDiv.innerHTML = newVal;
            }
        },
        updateLayout : function(attr, oldVAl, newVal) {
            if (newVal) {
                this.layout = newVal;
            }
            if (this.layout === "table") {
                domClass.toggle(this.fieldsGrid.domNode, "noborders", false);
            } else {
                domClass.toggle(this.fieldsGrid.domNode, "noborders", true);
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
                    this.createTable(this.chartData);
                }

                this.updateTableTitle(null, "", this.chartTitle);
                this.updateTableCaption(null, "", this.chartCaption);
            }
        },
        updateTable : function() {
            if (this.selection) {
                if (this.propertychanged) {
                    this.chartData = null;
                    this.queryRESTService();
                } else {
                    this.createTable(this.chartData);
                }
                this.updateTableTitle(null, "", this.chartTitle);
                this.updateTableCaption(null, "", this.chartCaption);
            }
        },
        createTable : function(data) {
            var j,k, columns = {};
            for ( j = 0; j < this.tableFields.length; j++) {
                var date = false;
                columns[this.tableFields[j]] = {
                    "label" : data.fieldAliases[this.tableFields[j]]
                }
                for ( k = 0; k < data.fields.length; k++) {
                    if(data.fields[k].name === this.tableFields[j] && data.fields[k].type === "esriFieldTypeDate"){
                        date = true;
                    }
                }
                if(date){ //"esriFieldTypeDate"
                    columns[this.tableFields[j]]["formatter"] = this.formatDate;
                }

            }
            /* var fieldData = dojo.map(data.features, dojo.hitch(this, function(feature) {
             return feature.attributes;
             }));*/
            var o, emptycols = {};
            var fieldData = dojo.map(data.features, dojo.hitch(this, function(feature) {
                // map attributes from all features - remove if empty values or excluded values is set.
                var include = true;
                var show = true;
                for (o in feature.attributes) {
                    if (configOptions.excludeValues) {
                        for ( i = 0; i < configOptions.excludeValues.length; i++) {
                            include = feature.attributes[o] !== configOptions.excludeValues[i] && feature.attributes[o] !== Number(configOptions.excludeValues[i]);
                        }
                    }
                    if (configOptions.hideEmptyValues) {
                        show = feature.attributes[o] !== null && feature.attributes[o] !== " " && feature.attributes[o] !== "";
                    }
                    if (!show || !include) {
                        delete feature.attributes[o];
                        if (emptycols[o] !== false) {
                            emptycols[o] = true;
                        } else {
                            emptycols[o] = false;
                        }
                    } else {
                        emptycols[o] = false;
                    }
                }

                return feature.attributes;
            }));
            //delete columns with no data
            for (o in columns) {
                if (emptycols[o] === true) {
                    delete columns[o]
                }
            }
            var fieldsStore = new Memory({
                data : fieldData
            });
            if (!this.fieldsGrid) {
                this.fieldsGrid = new (declare([OnDemandGrid, Selection]))({
                    allowSelectAll : true,
                    selectionMode : "multiple"
                }, this.tableContainer);
            }
            //  domConstruct.place(this.fieldsGrid.domNode, this.tableContainer);

            this.fieldsGrid.set('columns', columns);
            this.fieldsGrid.set('store', fieldsStore);
            this.updateLayout();
            //this.fieldsGrid.set('class', 'gradienttable');
        },
        createList : function(data) {
            var listitems = "";
            dojo.forEach(data.features, dojo.hitch(this, function(feature) {
                var listcontent = "";
                for ( j = 0; j < this.tableFields.length; j++) {
                    listcontent += feature.attributes[this.tableFields[j]] + " ";
                }
                listitems += "<li>" + listcontent + "</li>";

            }));
            var list = dojo.create("ul", {
                innerHTML : listitems
            }, this.tableContainer)
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
                    deferred = dojo.xhrGet(xhrArgs);
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
        },
        formatDate : function(datum) {
            /* Format the value in store, so as to be displayed.*/
            //var d = stamp.fromISOString(datum);
            var d = new Date(datum);
            return locale.format(d, {
                selector : 'date',
                formatLength : 'long'
            });
        }
    })
})

