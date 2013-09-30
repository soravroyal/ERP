{
    "configurationSettings": [{
            "category": "<b>Update Fitler Text</b>",
            "fields": [{
                    "placeHolder": "Defaults to map title",
                    "label": "Title Text:",
                    "fieldName": "title",
                    "type": "string",
                    "tooltip": "Defaults to map title"
                }, {
                    "placeHolder": "Defaults to the web map snippet",
                    "label": "Subtitle Text:",
                    "fieldName": "subtitle",
                    "type": "string",
                    "tooltip": "Defaults to webmap snippet"
                },{
                    "label" : "Auto Query",
                    "fieldName" : "autoquery",
                    "type" : "boolean",
                    "tooltip" : ""
                },{
                    "type": "paragraph",
                    "value": "Turn on Auto Query to preselect first feature"
                },{
                    "label" : "Auto Zoom",
                    "fieldName" : "zoomto",
                    "type" : "boolean",
                    "tooltip" : ""
                },{
                    "type": "paragraph",
                    "value": "Zoom to filtered features"
                }
            ]
        }
    ],
    "values": {
        "autofilter":false,
        "zoomto":false
    }
}