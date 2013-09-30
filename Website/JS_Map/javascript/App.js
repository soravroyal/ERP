define(["dojo/_base/declare","dojo/_base/lang","dojo/_base/kernel", "dojo/_base/array","dojo/dom-class","dojo/Deferred" , "dojo/promise/all" , "dojo/i18n", "utilities/AppConfigUtils"],
    function(declare,lang, kernel, array, domClass, Deferred, all, jsapiBundle, AppConfigUtils){
        var App =  declare("utilities.App",null,{
            _config: {},
            i18n:  {},
            _geometryService: null, 
            _proxy: null,
            constructor: function(/*Object*/defaults, /*Object GeometryService?*/geometryService, /*String?*/proxy){
                //specify class defaults 
                lang.mixin(this._config, defaults);
                this._geometryService = geometryService;
                this._proxy = proxy;
            },
            init: function(){
                var deferred = new Deferred();
                all([this.getlocalization(), this.setDefaults() ]).then(dojo.hitch(this, function(results){
                    //Now that we have the i18n and service defaults set create the config class
                    //and get the configuration options. 
                        var appConfig = new AppConfigUtils(this._config);
                          appConfig.getConfig().then(dojo.hitch(this,function(options){
                              lang.mixin(this._config, options);
                              deferred.resolve(this._config);
                          }))
                }));
                return deferred.promise;
            },
            getlocalization: function(){
              //Get the localization strings (if applicable) 
              //Add RTL class if the locale is Hebrew or Arabic 
                var deferred = new Deferred(), isRightToLeft = false;
                //Bi-directional language support added to support right-to-left languages like Arabic and Hebrew
                //Note: The map must stay ltr
                array.some(["ar","he"], lang.hitch(this, function(l){
                  if(kernel.locale.indexOf(l) !== -1){
                      isRightToLeft = true;
                      return true;
                  }
                }));
                var dirNode = document.getElementsByTagName("html")[0];
                if(isRightToLeft){
                      dirNode.setAttribute("dir","rtl");
                      domClass.add( dirNode,"esriRtl");
                }else{
                  dirNode.setAttribute("dir","ltr");
                  domClass.add(dirNode,"esriLtr");
                }
                deferred.resolve();
                return deferred.promise;

            },
            setDefaults: function(){
              //Check to see if the app is hosted on arcgis.com. If the app is hosted then set the arcgisUrl to the proper environment (dev, qa, production).
              //Also set the proxy to the Arcgis.com proxy. 
              //If the app isn't hosted or the user has specified a proxy url or geometry service url then use the user-defined values 
                 var deferred = new Deferred();
                   if(!this._config.sharingurl){
                      esri.arcgis.utils.arcgisUrl = location.protocol + '//' + location.host + "/sharing/content/items";
                  }else{
                     esri.arcgis.utils.arcgisUrl = this._config.sharingurl;
                  }
                if(this._geometryService){
                  esri.config.defaults.geometryService = this._geometryService;
                }
                if(!this._proxy){
                  this._proxy =  location.protocol + '//' + location.host + "/sharing/proxy";
               }
                esri.config.defaults.io.proxyUrl =this._proxy;
                esri.config.defaults.io.alwaysUseProxy = false;    
                deferred.resolve();
                return deferred.promise;  
            }


           });
        return App;
    });

