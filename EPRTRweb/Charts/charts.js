

function CreatePieChart(myData, swfFile, div, elements, myText) {

  try{
      // parameters
    var decodedData = decodeURIComponent(myData);
    var params = { allowscriptaccess: "always", scrolling: "no", wmode: "transparent" };
    var att = {}
    var flashvars = {};
    flashvars["data"] = myData;
    flashvars["lang"] = Lang;
    flashvars["text"] = myText;
    flashvars["filterArr"] = searchFilter;

    // adjust height, since 100% no NOT woek in embedSWF
    var height = 600;
    if (elements >= 5 && elements < 8) height += elements * 10;
    if (elements >= 8 && elements < 10) height += elements * 20;
    if (elements >= 10) height += elements * 50;
        
    //embed swf
    swfobject.embedSWF(swfFile,
                      div,
                      "100%",
                      height, //100% do NOT work
                      "9.0.0",
                      "playerProductInstall.swf",
                      flashvars,
                      params,
                      att);

  }
  catch (err) {
    //alert('error: ' + err)
  }

}

function IndustrialActivityPieChart(myNonHazData, myHazData, swfFile, div, nonHazLabel, hazLabel) {

    try {
        // parameters

        var params = { allowscriptaccess: "always", wmode: "transparent" };
        var att = {}
        var flashvars = {};
        var myNonHazLabel = "Non Hazardous waste transfer";
        var myHazLabel = "Hazardous waste transfer";
        flashvars["hazData"] = myHazData;
        flashvars["nonHazData"] = myNonHazData;
        flashvars["hazDatalabel"] = hazLabel;
        flashvars["nonHazDataLabel"] = nonHazLabel;
        flashvars["lang"] = Lang;
        flashvars["filterArr"] = searchFilter;

        //embed swf
        swfobject.embedSWF(swfFile,
                      div,
                      "100%",
                      "550",
                      "9.0.0",
                      "playerProductInstall.swf",
                      flashvars,
                      params,
                      att);

    }
    catch (err) {
        //alert('error: ' + err)
    }

}

function BarChart(myLabel, myData, swfFile, div, myCSS, myHeight, myText) {
    if (myHeight == 0 || myHeight == undefined) {
        myHeight = 1000;
    }

    try {
        // parameters

        var params = { allowscriptaccess: "always", wmode: "transparent" };
        var att = {}
        var flashvars = {};
        flashvars["chartLabel"] = myLabel;
        flashvars["data"] = myData;
        flashvars["type"] = myCSS;
        flashvars["lang"] = Lang;
        flashvars["text"] = myText;
        flashvars["filterArr"] = searchFilter;

        //embed swf
        swfobject.embedSWF(swfFile,
                      div,
                      "100%",
                      myHeight,
                      "9.0.0",
                      "playerProductInstall.swf",
                      flashvars,
                      params,
                      att);

    }
    catch (err) {
        //alert('error: ' + err)
    }

}