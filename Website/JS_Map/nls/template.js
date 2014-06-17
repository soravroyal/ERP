﻿define({root:
({
  viewer:{
    main:{
      scaleBarUnits: "metric" //"english (for miles) or "metric" (for km) - don't translate.
    },
    errors:{
      createMap: "Unable to create map",
      bitly: 'bitly is used to shorten the url for sharing. View the readme file for details on creating and using a bitly key',
      general: "Error"
    }
  },
  tools:{
    basemap: {
    title: "Switch Basemap",
    label: "Basemap"
    },
    print: {
    layouts:{
      label1: 'Landscape (PDF)',
      label2: 'Portrait (PDF)',
      label3: 'Landscape (Image)',
      label4: 'Portrait (Image)'
    },
    title: "Print Map",
    label: "Print"
    },
    share: {
    title: "Share Map",
    label: "Share",
    menu:{
      facebook:{
        label: "Facebook"
       },
      twitter:{
        label: "Twitter"
      },
      email:{
        label: "Email",
        message: "Check out this map"
      }    
    }
    },
    measure: {
      title: "Measure",
      label: "Measure"
    },
    time: {
      title: "Display Time Slider",
      label: "Time",
      timeRange: "<b>Time Range:</b> ${start_time} to ${end_time}",
      timeRangeSingle: "<b>Time Range:</b> ${time}"
    },
    editor: {
      title: "Display Editor",
      label: "Editor"
    },
    legend: {
      title: "Display Legend",
      label: "Legend"
    },
    details: {
      title: "Display Map Details",
      label: "Details"
    },
     unembed : {
        title : "Go to fullscreen map",
        label : ""
    },
    bookmark:{
      title: "Display Bookmarks",
      label: "Bookmarks",
      details: "Click a bookmark to navigate to the location"
    },
    layers: {
      title: "Display layer list",
      label: "Layers"
    },
    search: {
      title: "Find address or place",
      errors:{
       missingLocation: "Location not found"
      }
    }
  },
  panel:{
    close:{
      title: "Close Panel",
      label: "Close"
    }
  }
}),
"ar":1,
"da":1,
"de":1,
"es":1,
"fr":1,
"he":1,
"it":1,
"ja":1,
"ko":1,
"lt":1,
"nl":1,
"nb":1,
"pl":1,
"pt-br":1,
"pt-pt":1,
"ro":1,
"ru":1,
"sv":1,
"zh-cn":1
});