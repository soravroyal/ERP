define(["dojo/_base/declare", "dojo/parser", "dojo/_base/lang", "dojo/_base/window", "dojo/has", "dojo/Deferred", "dojo/dom-class", "dojo/dom-construct", "dijit/layout/BorderContainer", "dijit/layout/ContentPane"], function(declare, parser, lang, window, has, Deferred, domClass, domConstruct, BorderContainer, ContentPane) {
    var EEACreateContent = declare("utilities.EEACreateContent", null, {
        _isMobile : false,
        mainWindow : null,
        mapPane : null,
        constructor : function(args) {
            has("touch") && has("device-width") < 640 ? this._isMobile = true : this_isMobile = false;
        },
        createLayout : function() {
            var deferred = new Deferred();
            this.mainWindow = new BorderContainer({
                id : 'mainWindow',
                design : 'headline',
                gutters : false,
                style : {
                    height : '100%',
                    width : '100%'
                }
            }).placeAt(window.body(), "first");

            //add map content
            this.mapPane = new ContentPane({
                id : "map",
                region : "center",
                dir : "ltr"
            }).placeAt(this.mainWindow);
            
            
            //add the loading icon
            dojo.create("img", {
                id : "loader",
                src : "images/loading.gif",
                className : "loader"
            }, "map");            
            

            //add a class for smartphones that applies slightly different styles
            if (this._isMobile) {
                domClass.add("mainWindow", "mobile");
            }
            this.mainWindow.startup();
            deferred.resolve();
            return deferred.promise;
        },
        setPanelContent : function(title, content, width) {
            var deferred = new Deferred();

            deferred.resolve();
            this.mainWindow.resize();
            return deferred.promise;
        }
    });
    return EEACreateContent;
});

