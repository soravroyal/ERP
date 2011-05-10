*****************************************************************************

Sample Flex Viewer Readme

Version 1.0
*****************************************************************************

Directions:
-----------

Step 1:

Copy the FlexViewer directory onto your web server so that it can be accessed
as a website or virtual directory.
Example: Copy the FlexViewer directory under C:\Inetpub\wwwroot for 
Microsoft IIS web servers. 


Step 2:
 
The FlexViewer directory contains “config.xml” which is the main configuration
file. Open the config.xml file in the FlexViewer directory using a text editor
like Notepad. Make necessary changes to the XML tags. See the "Description of
XML Configuration Files" section below for more information.


Step 3:
 
The FlexViewer\com\esri\solutions\flexviewer\widgets directory contains the widgets 
and widget configuration files (.xml). Make necessary changes to the configuration 
files using a text editor like Notepad. To add multiple instances of the same widget, 
define multiple configuration files for each widget and add a reference for the widget 
to the main config.xml file specifying the appropriate configuration file. 
See the "Description of XML Configuration Files" section below for more information.


Step 4:
Test the application in a browser by entering the URL to the index.html page. 
Example: http://<server>/FlexViewer/index.html
Substitute "<server>" with name of your server.
Please note: "index.html" may not be defined as a default document on your web server.





Notes:
------

1) Base maps are map services which users can toggle between. Only one base map is 
visible at any given time.


2) Live maps are map services that can be overlaid on top of the base maps.


3) Results from widgets like LiveLayer, Locate, GeoRSS and Search are displayed 
using Graphics Layers and cannot be projected on the fly. Please make sure the 
coordinate system of the data used for widgets matches the coordinate system of 
the primary map service. The primary map service is the first map service that 
gets added to the map and can be a base map or live map.


4) All images and flash movies (SWFs) are stored in the 
FlexViewer\com\esri\solutions\flexviewer\assets directory.  
These can be changed or substituted as required but maintain the same size and 
format for best results.
   
   
   

Usage License:
--------------

Copyright © 2008 ESRI

All rights reserved under the copyright laws of the United States.
You may freely redistribute and use this software, with or
without modification, provided you include the original copyright
and use restrictions.  See use restrictions in the file:
<install location>/FlexViewer/License.txt





=======================================
DESCRIPTION OF XML CONFIGURATION FILES:
=======================================


config.xml:
-----------

userinterface:  Elements used to define the branding and overall appearance of the website.
   - banner: Parameter to make banner visible or invisible.
   - title: Title displayed on banner.
   - subtitle:  Subtitle displayed on banner.
   - logo: Path to the image displayed on banner.
   - stylesheet: Path to compiled stylesheet(.swf) applied to website.
   - menus: List of menus on the banner used to organize functional elements of the website.
      - menu: Configuration parameters for each menu.


map: Elements used to define map content and map extents.
   - basemaps: List of map services used as base maps. Only one base map is visible at all times.
      - mapservice: The URL or endpoint to the map service being used and the type of map service tiled/dynamic.
   - livemaps: List of map service that will be overlaid on top of the base map.
     - mapservice: The URL or endpoint to the map service being used and the type of map service tiled/dynamic.
   
  
navtools: List of navigation tools included in the website.
   - navtool: Configuration parameters for each navigation tool.
   
   
widgets: List of widgets included in the website.
   - widget: Configuration parameters for each widget.
  
  
links: List of hyperlinks available from the website.
   - link: Configuration parameters for each link.

   
   
AboutWidget.xml:
----------------

- title: Title displayed in widget.
- subtitle:  Subtitle displayed in widget.
- version: Version of website.
- description: Additional information about website.
- copyright: Copyright information about website.
   
   

BookmarkWidget.xml:
-------------------

- bookmarks: List of predefined bookmarks.
  - bookmark: Configuration parameters for each bookmark.
    Example: <bookmark name="Contiguous US">-122.2 24.9 -70.6 46.9</bookmark>
    
- labels: Optional list of labels to override default labels displayed in widget.
  - bookmarkslabel: Label for Bookmarks panel. 
  - addbookmarkslabel: Label for Add Bookmarks panel.
  - addlabel: Label for Add Bookmark description. 
  - submitlabel: Label for Submit button.
  - errorlabel: Label displayed when error occurs while adding bookmark.



DrawWidget.xml:
---------------

- geometryservice: URL to the ArcGIS Server REST resource that represents a geometry service. 
- spatialref: Well known ID for Spatial Reference used to calculate lengths and areas.
  The default is 32618 which caluclate distances in meters and areas in square meters.
  All conversions are based on the the units used to calculate distances and areas.
- distanceunits: List of distance units used to display distance measurements.
  - distanceunit: Distance unit with abbreviated form and conversion factor from meters.
    Example: <distanceunit abbr="ft" conversion="3.2808">Feet</distanceunit>   
- areaunits: List of area units used to display area measurements.
  - areaunit: Area unit with abbreviated form and conversion factor from square meters. 
    Example: <areaunit abbr="sq ft" conversion="10.763910417">Square Feet</areaunit>
    
- labels: Optional list of labels to override default labels displayed in widget.
  - drawlabel: Label for Draw panel.
  - measurementslabel: Label for Measurements panel.
  - pointlabel: Label for Draw Point tool.
  - linelabel: Label for Draw Line tool.
  - freehandlinelabel: Label for Draw Freehand Line tool.
  - polygonlabel: Label for Draw Polygon tool.
  - freehandpolygonlabel: Label for Draw Freehand Polygon tool.
  - clearlabel: Label for Clear Drawing tool.
  - textlabel: Label for Text input box. 
  - colorlabel: Label for Color selector.
  - sizelabel: Label for Size selector
  - showmeasurementslabel: Label for Show Measurements check box.
  - distanceunitslabel: Label for Distance units selector.
  - areaunitslabel: Label for Area units selector.
  - arealabel: Label for AREA shown on map.
  - perimeterlabel: Label for PERIMETER shown on map
  - lengthlabel: Label for LENGTH shown on map.
   
   
   
GeoRSSWidget.xml:
-----------------

- source: URL to the resource that represents the GeoRSS feed. 
  Example: http://earthquake.usgs.gov/eqcenter/catalogs/eqs7day-M5.xml
- query: (Not being used in Version 1.0)
- fields: List of fields to be displayed in the widget and Info window.
- titlefield: Title field to be displayed.
- linkfield: Field with hyperlink value.
- refreshrate: Rate in seconds when new data will be requested from the GeoRSS source.
- zoomscale: Scale used when user clicks on a record to zoom to that feature.

- labels: Optional list of labels to override default labels displayed in widget.
  - loadinglabel: Label displayed while processing request.



IdentifyWidget.xml:
-------------------

- identifylayeroption: Option for layers identified (visible/all/top).
- identifytolerance: Distance in screen pixels from the point within which the identify should be performed.
- zoomscale: Scale used when user clicks on a record to zoom to that feature.

- labels: Optional list of labels to override default labels displayed in widget.
  - identifylabel: Label for Identify panel.
  - resultslabel: Label for Results panel.
  - descriptionlabel: Label for description of identify tool.
  - pointlabel: Label for Select by Point tool.
  - clearlabel: Label for Clear button.
  - loadinglabel: Label displayed while processing request.
  - selectionlabel: Label for selected features.
  
  
  
LiveLayerWidget.xml:
--------------------

- layer: URL to the ArcGIS Server REST resource that represents a layer in a service. 
  Example: http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Louisville/LOJIC_PublicSafety_Louisville/MapServer/0
- query: Query expression for features to be retrieved. Default is OBJECTID > 0 if nothing is specified.
- fields: List of fields to be displayed in the widget and Info window.
- titlefield: Title field to displayed.
- linkfield: Field with hyperlink value.
- refreshrate: Rate in seconds when new data will be requested from the layer.
- zoomscale: Scale used when user clicks on a record to zoom to that feature.

- labels: Optional list of labels to override default labels displayed in widget.
  - loadinglabel: Label displayed while processing request.



LiveMapsWidget.xml:
-------------------

- labels: Optional list of labels to override default labels displayed in widget.
  - visibilitylabel: Label for Layer Visibility panel.
  - transparencylabel: Label for Layer Transparency panel.
  
  
  
LocateWidget.xml:
-----------------

- locator: URL to the ArcGIS Server REST resource that represents a locator service.
  Example: http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Locators/ESRI_Geocode_USA/GeocodeServer
- minscore: Minimum score used to eliminate address matches with lower scores.
- listfield: An input field that will be a predefined list of values.
- listvalues: Comma separated list of values used in the list field.
  Example: AK,AL,AR,AZ,CA,CO,CT,DE,DC,FL,GA,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MS,MO,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VA,WA,WI,WV,WY
- zoomscale: Scale used when user clicks on a record to zoom to that feature.

- labels: Optional list of labels to override default labels displayed in widget.
  - addresslabel: Label for Address panel.
  - coordinateslabel: Label for Coordinates panel.
  - resultslabel: Label for Results panel.
  - xlabel: Label for X-coordinate input.
  - ylabel: Label for Y-coordinate input.
  - examplelabel: Label for Example.
  - examplevaluelabel: Label for Example value.
  - submitlabel: Label for Submit button.
  - clearlabel: Label for Clear button.
  - loadinglabel: Label displayed while processing request.
  - locationslabel: Label for selected locations.
  


OverviewMapWidget.xml:
----------------------

- mapservice: The URL or endpoint to the map service being used and the type of map service tiled/dynamic.
  Note: The coordinate system of the overview map service needs to be the same as the primary map service.
 
 

PrintWidget.xml:
----------------

- title: Default title for printed map.
- subtitle: Default subtitle for printed map.
- copyright: Copyright information for printed map.

- labels: Optional list of labels to override default labels displayed in widget.
  - titlelabel: Label for Title input.
  - subtitlelabel: Label for Subtitle input.
  - submitlabel: Label for Submit button.
 
 
 
SearchWidget.xml:
-----------------

- layers: List of searchable layers.
  - layer: Paramaters for each searchable layer
    - name: Name of layer displayed in searchable layer list.
    - url: URL to the ArcGIS Server REST resource that represents a layer in a service. 
      Example: http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Louisville/LOJIC_PublicSafety_Louisville/MapServer/2
    - expression: Query expression used to retrieve features.
      Example: LAST_UPDATED = '[value]'
      The pattern [value] is replaced by the text input by the user in the search field.
    - textsearchlabel: Label displayed when layer is selected in the Text Search panel.
    - graphicalsearchlabel: Label displayed when layer is selected in the Graphical Search panel.
    - fields: List of fields to be displayed in the widget and Info window.
    - titlefield: Title field to be displayed.
    - linkfield: Field with hyperlink value.
- zoomscale: Scale used when user clicks on a record to zoom to that feature.

- labels: Optional list of labels to override default labels displayed in widget.
  - graphicalsearchlabel: Label for Graphical Search panel.
  - textsearchlabel: Label for Text Search panel.
  - resultslabel: Label for Results panel.
  - layerlabel: Label for list of searchable layers.
  - nolayerlabel: Label displayed when no searchable layers are defined.
  - pointlabel: Label for Select by Point tool.
  - linelabel: Label for Select by Line tool.
  - rectanglelabel: Label for Select by Rectangle tool.
  - polygonlabel: Label for Select by Polygon tool.
  - submitlabel: Label for Submit button.
  - clearlabel: Label for Clear button.
  - loadinglabel: Label displayed while processing request.
  - selectionlabel: Label for selected features.
  


ServiceAreaWidget.xml:
----------------------

- serviceareaservice: URL to the ArcGIS Server REST resource that represents a GP service for creating service areas.
- locator: URL to the ArcGIS Server REST resource that represents a locator service.
- sharedwidgets: Comma-separated list of widgets from where data will be used.

- labels: Optional list of labels to override default labels displayed in widget.
  - servicearealabel: Label for Service Area description.
  - locationlabel: Label for Location input.
  - previouslocationlabel: Label for list of previous locations identified by other tools.
  - addlocationlabel: Label for Add Location tool.
  - intervallabel: Label for Drive Time Intervals.
  - submitlabel: Label for Submit button.
  - clearlabel: Label for Clear button
  - loadinglabel: Label displayed while processing request.
  


