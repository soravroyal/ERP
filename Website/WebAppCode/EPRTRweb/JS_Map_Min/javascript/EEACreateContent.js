define(["dojo/_base/declare", "dojo/parser", "dojo/_base/lang", "dojo/_base/window", "dojo/has", "dojo/Deferred", "dojo/dom-class", "dojo/dom-construct", "dijit/layout/BorderContainer", "dijit/layout/ContentPane"], function (declare, parser, lang, window, has, Deferred, domClass, domConstruct, BorderContainer, ContentPane) {
    var EEACreateContent = declare("utilities.EEACreateContent", null, {
        _isMobile: false,
        mainWindow: null,
        mapPane: null,
        constructor: function (args) {
            has("touch") && has("device-width") < 640 ? this._isMobile = true : this_isMobile = false;
        },
        createLayout: function () {
            var deferred = new Deferred();
            if (options.mapName == "miMapa") {
                this.mainWindow = new BorderContainer({
                    id: options.mapName + 'mainWindow',
                    design: 'headline',
                    gutters: false,
                    style: {
                        height: '400px',
                        width: '400px'
                    }
                }).placeAt(options.mapName, "first");

                //add map content
                this.mapPane = new ContentPane({
                    id: options.mapName + "map",
                    region: "left",
                    dir: "ltr",
                    style: {
                        height: '400px',
                        width: '400px'
                    },
                    className: "roundedCorners"
                }).placeAt(this.mainWindow);

                this.mapLegend = new ContentPane({
                    id: options.mapName + "legendContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '192px',
                        height: '395px',
                        display: "none"
                    },
                    className: "roundedCorners legendContainer"
                }).placeAt(this.mainWindow);
                dojo.create("div", {
                    id: options.mapName + "legend"
                }, options.mapName + "legendContainer");

            }
            else if (options.mapName == "miMapa2"){
                this.mainWindow = new BorderContainer({
                    id: options.mapName + 'mainWindow',
                    design: 'headline',
                    gutters: false,
                    style: {
                        height: '750px',
                        width: '960px'
                    }
                }).placeAt(options.mapName, "first");

                //add map content
                this.mapPane = new ContentPane({
                    id: options.mapName + "map",
                    region: "left",
                    dir: "ltr",
                    style: {
                        height: '750px',
                        width: '1000px'
                    },
                    className: "roundedCorners"
                }).placeAt(this.mainWindow);

                this.mapLegend = new ContentPane({
                    id: options.mapName + "legendContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '192px',
                        height: '395px'
                    },
                    className: "roundedCorners legendContainer"
                }).placeAt(this.mainWindow);
                dojo.create("div", {
                    id: options.mapName + "legend"
                }, options.mapName + "legendContainer");
            }
            else if (options.mapName == "miMapa3") {
                this.mainWindow = new BorderContainer({
                    id: options.mapName + 'mainWindow',
                    design: 'headline',
                    gutters: false,
                    style: {
                        height: '330px',
                        width: '330px'
                    }
                }).placeAt(options.mapName, "first");

                //add map content
                this.mapPane = new ContentPane({
                    id: options.mapName + "map",
                    region: "left",
                    dir: "ltr",
                    style: {
                        height: '330px',
                        width: '330px'
                    },
                    className: "roundedCorners"
                }).placeAt(this.mainWindow);

                this.mapLegend = new ContentPane({
                    id: options.mapName + "legendContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '192px',
                        height: '395px',
                        display: "none"
                    },
                    className: "roundedCorners legendContainer"
                }).placeAt(this.mainWindow);
                dojo.create("div", {
                    id: options.mapName + "legend"
                }, options.mapName + "legendContainer");
            }


            //add a class for smartphones that applies slightly different styles
            if (this._isMobile) {
                domClass.add("mainWindow", "mobile");
            }
            this.mainWindow.startup();
            deferred.resolve();
            return deferred.promise;
        },
        setPanelContent: function (title, content, width) {
            var deferred = new Deferred();

            deferred.resolve();
            this.mainWindow.resize();
            return deferred.promise;
        }
    });
    return EEACreateContent;
});

