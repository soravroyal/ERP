define(["dojo/_base/declare","dojo/_base/lang","dojo/Deferred" ,"esri/arcgis/utils"],
    function(declare,lang,Deferred, utils){
        var AppConfigUtils =  declare("",null,{
            _config: {},
            constructor: function(args){
                //specify class defaults 
                 lang.mixin(this._config, args);

                //Check url parameters for an application id( appid) or webmap id 
                 var urlObject = esri.urlToObject(document.location.href);
                 urlObject.query = urlObject.query || {};
                 lang.mixin(this._config,urlObject.query);
            },
            getConfig: function(){
            //Check to see if logged into an organization or if there is an application id. If either exist mix those values into config. 
            //Return default values if not an org or if there isn't an application id 
            return this._queryOrganization().then(lang.hitch(this,this._queryApplication));

            },
           _queryApplication : function(){
            //Is there an application id? If so query to get the configured values from the application. 
                if(this._config.appid){
                     return this._getApplicationId(this._config.appid);
                }else{
                 return  this._getDefaults();
              }
            },
            _queryOrganization: function(){
                //If logged into an organization get the organizations basemap gallery group
                //Additional organization options may be added later (print, routing etc)
                var organizationPath = document.location.protocol + "//" + document.location.hostname + "/sharing/rest/portals/self";
                if(organizationPath.indexOf("arcgis.com") !== -1){
                 return esri.request({
                    url: organizationPath,
                    content:{"f": "json"},
                    callbackParamName:"callback",
                    load: lang.hitch(this,function(response){
                            this._config.self = response;
                            return this._config;
                    })
                 });
                }else{
                    return  this._getDefaults();
                }
            },
            _getDefaults: function(){
                 var deferred = new Deferred();
                deferred.resolve(this._config);
                 return deferred.promise;
            },
             _getApplicationId:function(appid){
                //If there is an application id query arcgis.com using esri.arcgis.utils.getItem to get the item info. If the item info includes 
                //itemData.values then the app was configurable so overwrite the default values with the configured values. 
                var deferred = new Deferred();
                utils.getItem(appid).then(lang.hitch(this,function(response){
                   lang.mixin(this._config, response.itemData.values);
                //overwrite any values with url params 
                 var urlObject = esri.urlToObject(document.location.href);
                 urlObject.query = urlObject.query || {};
                 lang.mixin(this._config,urlObject.query);
                   deferred.resolve(this._config);
                }));
                return deferred.promise;
            }
           });
        return AppConfigUtils;
    });

