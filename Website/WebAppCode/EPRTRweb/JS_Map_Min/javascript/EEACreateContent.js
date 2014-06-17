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
            if (options.mapName == "map_small") {
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


            }
            //-----------------------------------------------------------------------------
            else if (options.mapName == "map_extended") {
                this.mainWindow = new BorderContainer({
                    id: options.mapName + 'mainWindow',
                    design: 'headline',
                    gutters: false,
                    style: {
                        height: '750px',
                        width: '1000px'
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


                // add header for buttons
                this.mapHeader = new BorderContainer({
                    id: options.mapName + "headerContainer",
                    region: "top",
                    dir: "ltr",
                    style: {
                        width: '1000px',
                        height: '40px',
                        paddingTop: '0px'

                    },
                    className: "headerContainer"
                }).placeAt(this.mainWindow);
                dojo.create("div", {
                    id: options.mapName + "header"
                }, options.mapName + "headerContainer");

                this.mapHeaderLeft = new ContentPane({
                    id: options.mapName + "headerLeftContainer",
                    region: "left",
                    dir: "ltr",
                    style: {
                        width: '300px',
                        height: '35px',
                        paddingTop: '2px'

                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                this.mapHeaderCenter = new ContentPane({
                    id: options.mapName + "headerCenterContainer",
                    region: "center",
                    dir: "ltr",
                    style: {
                        width: '590px',
                        height: '35px',
                        paddingTop: '2px'
                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                this.mapHeaderRight = new ContentPane({
                    id: options.mapName + "headerRightContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '100px',
                        height: '35px',
                        paddingTop: '2px'


                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                // add right panel for legend
                this.mapLegend = new ContentPane({
                    id: options.mapName + "legendContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '200px',
                        height: '750px',
                        overflow: 'auto',
                        backgroundColor: 'white'
                    },
                    className: "roundedCorners legendContainer"
                }).placeAt(this.mainWindow);



                dojo.create("div", {
                    id: 'legendHeader',
                    region: 'top',
                    style: 'width:180px; height:25px'
                }, options.mapName + "legendContainer");

                dojo.create("div", {
                    id: options.mapName + "legend",
                    region: 'bottom',
                    style: 'paddingTop:10px'

                }, options.mapName + "legendContainer");
                //---------------------------------------------------------------------

            }
            else if (options.mapName == "map_details") {
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

            }
            // ------------------------------------------------------------------------------------------------------
            else if (options.mapName == "map_viewer") {
                this.mainWindow = new BorderContainer({
                    id: options.mapName + 'mainWindow',
                    design: 'headline',
                    gutters: false,
                    style: {
                        height: '550px',
                        width: '750px'
                    }
                }).placeAt(options.mapName, "first");

                //add map content
                this.mapPane = new ContentPane({
                    id: options.mapName + "map",
                    region: "left",
                    dir: "ltr",
                    style: {
                        height: '550px',
                        width: '750px'
                    },
                    className: "roundedCorners"
                }).placeAt(this.mainWindow);


                // add header for buttons
                this.mapHeader = new BorderContainer({
                    id: options.mapName + "headerContainer",
                    region: "top",
                    dir: "ltr",
                    style: {
                        width: '750px',
                        height: '40px',
                        paddingTop: '0px'

                    },
                    className: "headerContainer"
                }).placeAt(this.mainWindow);
                dojo.create("div", {
                    id: options.mapName + "header"
                }, options.mapName + "headerContainer");

                this.mapHeaderLeft = new ContentPane({
                    id: options.mapName + "headerLeftContainer",
                    region: "left",
                    dir: "ltr",
                    style: {
                        width: '220px',
                        height: '35px',
                        paddingTop: '2px'

                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                this.mapHeaderCenter = new ContentPane({
                    id: options.mapName + "headerCenterContainer",
                    region: "center",
                    dir: "ltr",
                    style: {
                        width: '350px',
                        height: '35px',
                        paddingTop: '2px'
                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                this.mapHeaderRight = new ContentPane({
                    id: options.mapName + "headerRightContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '100px',
                        height: '35px',
                        paddingTop: '2px'

                    }, className: "headerContainer"
                }).placeAt(this.mapHeader);


                // add right panel for legend
                this.mapLegend = new ContentPane({
                    id: options.mapName + "legendContainer",
                    region: "right",
                    dir: "ltr",
                    style: {
                        width: '192px',
                        height: '550px',
                        overflow: 'auto'
                    },
                    className: "roundedCorners legendContainer"
                }).placeAt(this.mainWindow);

                dojo.create("div", {
                    id: 'legendHeader',
                    region: 'top',
                    style: 'width:180px; height:25px'
                }, options.mapName + "legendContainer");

                dojo.create("div", {
                    id: options.mapName + "legend",
                    region: 'bottom',
                    style: 'paddingTop:10px'
                }, options.mapName + "legendContainer");
                //---------------------------------------------------------------------

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

