<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!-- On iOS, as part of optimizing your web application, have it use the
    standalone mode to look more like a native application. When you use this
    standalone mode, Safari is not used to display the web content—specifically,
    there is no browser URL text field at the top of the screen or button bar
    at the bottom of the screen. -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!-- Controls the dimensions and scaling of the browser window in iOS,
    Android, webOS, Opera Mini, Opera Mobile and Blackberry. width: controls
    the width of the viewport initial-scale: controls the zoom level when the
    page is first loaded maximum-scale: control how users are allowed to zoom
    the page in or out user-scalable: control how users are allowed to zoom
    the page in or out -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <!-- Sets the style of the status bar for a web application when in standalone mode -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/dojo/dijit/themes/claro/claro.css" />
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/3.5/js/esri/css/esri.css" />
    <link rel="stylesheet"  href="Map_New/css/layout.css"/>
    <script type="text/javascript">
      var path_location = location.pathname.replace(/\/[^/]+$/, '');
      var dojoConfig = {
        parseOnLoad: true,
        packages: [ { 
                name: "utilities",
                location: path_location + '/Map_New/javascript' 
             },{
                name: "templateConfig",
                location: path_location + '/Map_New'
             }
        ]
      };
    </script>
    <script type="text/javascript" src="//serverapi.arcgisonline.com/jsapi/arcgis/3.5"></script>
    <script type="text/javascript" src="Map_New/javascript/layout.js"></script>
 
    
    <script type="text/javascript">
        dojo.require("utilities.app");
        dojo.require("templateConfig.commonConfig");


        dojo.ready(function () {

            var defaults = {
                webmap: "45ac2ed1f4074dc696aeb47abfc3bc5b",
                bingmapskey: commonConfig.bingMapsKey,
                sharingurl: "",
                proxyurl: "",
                helperServices: commonConfig.helperServices
            };


            var app = new utilities.App(defaults);
            app.init().then(function (options) {
                init(options);
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
