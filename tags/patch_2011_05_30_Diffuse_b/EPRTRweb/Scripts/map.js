
// --------------------------------------------------------------------------------------------------
// Return flex object 
// --------------------------------------------------------------------------------------------------
function thisMovie(id) {
    //alert('thisMovie: '+id);
  if (window.document[id]) {
    return window.document.getElementById(id);
  }
  if (navigator.appName.indexOf("Microsoft Internet") == -1) {
      if (document.embeds && document.embeds[id]) {
          return document.embeds[id];
      }
  }
  else {
    return window.document.getElementById(id);
  }
}


// --------------------------------------------------------------------------------------------------
// Wait indicator
// --------------------------------------------------------------------------------------------------
function ShowWaitIndicator() 
{
  var icon = window.document.getElementById("waitindicator");
  if (icon != undefined) 
      icon.style.visibility = 'visible';
}
function HideWaitIndicator() 
{
  var icon = window.document.getElementById("waitindicator");
  if (icon != undefined)
    icon.style.visibility = 'hidden';
}


// --------------------------------------------------------------------------------------------------
// Called by map when map is ready
// --------------------------------------------------------------------------------------------------

var flexMapIsReadyStack = {};

function flexMapIsReady(value, id) {


    var fn = flexMapIsReadyStack[id];

if (fn != null) {
        flexMapIsReadyStack[id] = null; //remove from stack
        fn.call();
    }
}

// --------------------------------------------------------------------------------------------------
// InitializeMap
// --------------------------------------------------------------------------------------------------
function InitializeMap(id, filter, layers, header, isExpanded, visibleLayers) {

  var map = thisMovie(id);
  
  //if map is not ready add to callback-stack
  if (map == undefined || !map.isReady()) {
     flexMapIsReadyStack[id] = function() { InitializeMap(id, filter, layers, header, isExpanded, visibleLayers); };
    return;
  }

  try {
      var setVisibleLayers = (visibleLayers != undefined && visibleLayers.length > 0);

      if (filter != undefined && filter.length > 0) {

          map.setAllLayersDefinition(filter);

          //only relevant for expanded map
          if (isExpanded != undefined && (isExpanded || isExpanded == "True" || isExpanded == 1)) {
              map.setMapPrintDetails(header);
          }
      }

      if (layers != undefined && layers.length > 0) {
          map.includeLayers(layers, !setVisibleLayers);
          if (setVisibleLayers) {
              map.setVisibleLayers(visibleLayers);
          }
      } else {
          map.excludeAllLayers();
      }

      map.clearSelection();
  } catch (Error) {
    alert('error:' + Error);
  }

  return;
}

// --------------------------------------------------------------------------------------------------
// Set extend of map
// --------------------------------------------------------------------------------------------------
function SetExtent(id, extent) {

    var map = thisMovie(id);
    
    //if map is not ready add to callback-stack
    if (map == undefined || !map.isReady()) {
        flexMapIsReadyStack[id] = function() { SetExtent(id, extent); };
        return;
    }

    if (extent != undefined) {
        map.setExtent(extent);
    }
    return;
}

// --------------------------------------------------------------------------------------------------
// Add swf map object
// --------------------------------------------------------------------------------------------------
function AddMap(id, configfile, width, heigth, params, applicationPath, culture, isReadyCallback) {

    try {

    var flashvarsdetails = {};
    var attributes = {};

    flashvarsdetails["urlprefix"] = GetBasePath(applicationPath);
    flashvarsdetails["configfile"] = GetBasePath(applicationPath) + configfile;
    flashvarsdetails["locale"] = culture;
    flashvarsdetails["divid"] = id;

    if (isReadyCallback != null) {
        flashvarsdetails["callbackfunction"] = escape(isReadyCallback.toString());
    }


        swfobject.embedSWF(GetBasePath(applicationPath) + "index.swf",
                    id,
                    width,
                    heigth,
                    "9.0.0",
                    "playerProductInstall.swf",
                    flashvarsdetails,
                    params,
                    attributes);
  }
  catch (err) {
  }
                   
}

// --------------------------------------------------------------------------------------------------
// Search pages, small map, swf map object
// --------------------------------------------------------------------------------------------------
function AddSmallMap(id, configfile, applicationPath, culture) {
    var params = { allowscriptaccess: "always", wmode: "transparent" };
    AddMap(id, configfile, 400, 350, params, applicationPath, culture);
}

// --------------------------------------------------------------------------------------------------
// Expanded, swf map object
// --------------------------------------------------------------------------------------------------
function AddExpandedMap(id, configfile, applicationPath, culture, callback) {

    var params = { wmode: "transparent" };
    params.scale = "noscale";
    params.allowfullscreen = "true";
    params.allowscriptaccess = "always";

    //map will be initialized by the callback function
    AddMap(id, configfile, "100%", "100%", params, applicationPath, culture, callback.toString());
}


// --------------------------------------------------------------------------------------------------
// Map search, swf map object
// --------------------------------------------------------------------------------------------------
function AddMapSearch(id, configfile, applicationPath, culture) {

    var params = { allowscriptaccess: "always", wmode: "transparent" };
    AddMap(id, configfile, 745, 560, params, applicationPath, culture);
}

// --------------------------------------------------------------------------------------------------
// Facility Details map, swf map object
// --------------------------------------------------------------------------------------------------
function AddDetailsMap(id, configfile, applicationPath, culture, callback) {
    var params = { allowscriptaccess: "always", wmode: "transparent" };

    //map will be initialized by the callback function
    AddMap(id, configfile, "100%", "100%", params, applicationPath, culture, callback);
}

//// --------------------------------------------------------------------------------------------------
// Set point on facility details map
// --------------------------------------------------------------------------------------------------
function SetDetailsMapPoint(id, reportid, sectors) {
    // leave
    var mapobject = thisMovie(id);

    //if map is not ready add to callback-stack
    if (mapobject == undefined || !mapobject.isReady()) {
        flexMapIsReadyStack[id] = function() { SetDetailsMapPoint(id, reportid, sectors); };
        return;
    }

    var b = mapobject.setAllLayersDefinition(reportid);
    mapobject.includeLayers(sectors);
    return;
}


// --------------------------------------------------------------------------------------------------
// Open/update expanded map in new window
// --------------------------------------------------------------------------------------------------
function ExpandedMapClicked(expandLink, smallMapId) {

    try {
        var smallmap = thisMovie(smallMapId);
        if (smallmap != undefined) {
            var extent = smallmap.getExtent();
            expandLink += "&extent=" + extent;
        }
    }
    catch (Error) {
    }

    var h = screen.availHeight - 100;
    var w = screen.availWidth - 50;
    
    mapWindow = window.open(expandLink, 'ExpandedMap', 'scrollbars=no,menubar=no,height='+h+',width='+w+',resizable=yes,toolbar=no,location=no,status=no,dependent=yes');
    mapWindow.focus();
}

function ClosePopupWindows() {
    
  // Close expanded map window
  try {
      mapWindow.close();
  }
  catch (Error) { }

  // Close facility details popup window
  try {
      openwin.close();
  }
  catch (Error) { }

  // Close activity, pollutant (etc...) information popup window
  try {
      popupWindow.close();
  }
  catch (Error) { }
}

// --------------------------------------------------------------------------------------------------
// Open facilitydetails in new window. Called by Map
// --------------------------------------------------------------------------------------------------
function openwin(facilityReportId) {
    var h = screen.availHeight - 50;
    var top = 25;
    var openwin = window.open('PopupFacilityDetails.aspx?FacilityReportId=' + facilityReportId, 'FacilityReportId' + facilityReportId, 'scrollbars=yes,menubar=no,height=' + h + ',width=850,top='+top+'resizable=yes,toolbar=no,location=no,status=no,replace=true');
    openwin.focus();
    return true;
}



// --------------------------------------------------------------------------------------------------
// Create a png of map and save to disk under MapPrint/img - filename is a string  e.g. "eprtrmap" 
// or "45687587" - saved as " MapPrint/img/eprtrmap.png"  and " MapPrint/img/45687587.png"
// --------------------------------------------------------------------------------------------------
function createMapPng(id, filename)
{
  try {
    var obj = thisMovie(id)
    if (obj != undefined) {
      obj.createMapPng(filename);
    }
  }
  catch (Error) {
  }
}

// --------------------------------------------------------------------------------------------------
// Helper functions
// --------------------------------------------------------------------------------------------------
function GetBasePath(applicationPath) {

    var basePath = applicationPath;
    if (basePath && basePath.length > 1) {
        basePath = basePath + "/"
    }
    basePath = basePath + "Map/";
    return basePath;
}


// --------------------------------------------------------------------------------------------------
// Perserve scroll
// --------------------------------------------------------------------------------------------------

// let client listen to scroll events
window.onscroll = ScrollEvent;

var scrollY;
var scrollPercent;
var ignoreScoll = false;

function ScrollEvent()
{
  try
  {
    if (ignoreScoll == false) 
    {
      var scrollheight = getScrollHeight();
      if (document.all) 
      {
        if (!document.documentElement.scrollTop)
          scrollY = document.body.scrollTop;
        else
          scrollY = document.documentElement.scrollTop;
      }
      else 
        scrollY = window.pageYOffset;
    
      if (scrollheight > 0)
        scrollPercent = scrollY / scrollheight;
    }
    ignoreScoll = false;
 }
 catch (err) { 
 }
}

// --------------------------------------------------------------------------------------------------
// Return scroll height of browser
// --------------------------------------------------------------------------------------------------
function getScrollHeight() {
  var h = undefined;
  if (!document.documentElement.scrollTop) {
    h = document.body.scrollHeight;
  }
  else {
    h = document.documentElement.scrollHeight;
  }
  return h;
}

// --------------------------------------------------------------------------------------------------
// Set new scroll position. This has to be done with a timeout call
// --------------------------------------------------------------------------------------------------
function SetScroll()
{
  try
  {
    if (scrollY != undefined) 
    {
      ignoreScoll = true;
      var totalHeight = getScrollHeight();
      var scrollFromTop = Math.round(totalHeight * scrollPercent);

      //alert("Percent:  " + scrollPercent + "  Height: " + totalHeight + "  Res: " + scrollFromTop);
      setTimeout('window.scroll(0,' + scrollFromTop + ')', 1); //scrollTo
    }
  }
  catch (err) {  
  }
}

