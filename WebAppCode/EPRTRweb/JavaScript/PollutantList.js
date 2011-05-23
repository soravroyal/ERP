//References for the jQuery code, second provides intellisense in the VS environment.
/// <reference path="jquery.js" />
/// <reference path="jquery-vsdoc.js" />

// Print the contents of a Div
// Opens a new window, writes the contents of the div ready print
function pollutantPrint(divToPrint) {
    rep=new RegExp('<DIV style="DISPLAY: block" class="tabMain jmol">',"gi");
    rep2=new RegExp('<div class="tabMain jmol" style="DISPLAY: block;">',"gi")
    var Content1=divToPrint.replace(/DISPLAY: none/gi,"DISPLAY: block");
    Content1=Content1.replace(rep2,'<DIV style="display: none" class="tabMain jmol">');
    Content1=Content1.replace(rep,'<DIV style="display: none" class="tabMain jmol">');
    win=window.open("","","resizable=1,scrollbars=1,height=600, width=650,dependent=yes,toolbar=yes,menubar=yes");
    self.focus();
    win.document.write('<html><head>');
    win.document.write('<link href="CSS/PrintStyles.css" rel="stylesheet" type="text/css"/>');
    win.document.write('<script type="text/javascript" >function Tip(){}</script>');
    win.document.write('<script type="text/javascript" >function jmolInitialize(aa, bb){}</script>');
    win.document.write('<script type="text/javascript" >function jmolApplet(aa, bb, cc){}</script>');
    win.document.write('</head><body><div id="printDiv">');
    win.document.write(Content1);
    win.document.write('</div></body></html>');
    win.document.close();
    win.focus();
}

//Tooltip function, wires up 'hover' function to tags with tooltip class
//Content of the tooltip is held in a span tag inside the parent element
//Tooltip will track with the mouse
this.tooltip=function() {
    // Offset of where tooltip is displayed relative to the mouse position
    xOffset=10;
    yOffset=20;

    // When we hover, show the contents of the span tag
    $(".tooltip").hover(function(e) {
        this.s=$(this).children("span").html();
        $("body").append("<p id='tooltip'>"+this.s+"</p>");
        $("#tooltip")
            .css("top",(e.pageY-xOffset)+"px")
            .css("left",(e.pageX+yOffset)+"px")
            .fadeIn("slow");
    },
        function() {
            $("#tooltip").remove();
        });

    // Move the displayed tag with the mouse
    $(".tooltip").mousemove(function(e) {
        $("#tooltip")
        .css("top",(e.pageY-xOffset)+"px")
        .css("left",(e.pageX+yOffset)+"px");
    });
}

// Toggle visibility of backgroundSetting div when pollutantToggle is clicked
this.pollutantToggle=function() {
    $(".pollutantToggle").click(function() {
        $(this).children("a").addClass("pollutantVisited");
        // Need to walk up the Dom and then back down to get the tag we want.
        $(this).parent().parent().next("tr").children(".padCol").children(".backgroundSetting").toggle();
    });
}

// Displays the appropriate content section when a menu item is clicked.
// Sections and menu items are paired by assigning the same css class (dummy classes are used in the css specifically for this purpose)
this.menuClick=function() {
    $(".contentsBox_item").click(function(c) {
        c.preventDefault();
        c.stopPropagation();
        var menuItem;
        // Add css class to hughlight the menu item
        $(this).addClass("contentsBox_item_selected");
        // Remove css class from all sibling menu items
        $(this).siblings().removeClass("contentsBox_item_selected");
        // Hide all sibling content sheets
        $(this).parent().parent().siblings(".second_resultSheet_content").hide();
        // Search for the content sheet with the same class and show the sheet
        // NOTE: May be possible to do this more generically by passing the css class name from the menu item and using it to show the appropriate sheet.
        if($(this).hasClass("pollutantSummary")) { $(this).parent().parent().siblings(".pollutantSummary").show(); }
        if($(this).hasClass("pollutantNames")) { $(this).parent().parent().siblings(".pollutantNames").show(); }
        if($(this).hasClass("pollutantGroupInfo")) { $(this).parent().parent().siblings(".pollutantGroupInfo").show(); }
        if($(this).hasClass("pollutantrands")) { $(this).parent().parent().siblings(".pollutantrands").show(); }
        if($(this).hasClass("pollutantPhysical")) { $(this).parent().parent().siblings(".pollutantPhysical").show(); }
        if($(this).hasClass("pollutantHealth")) { $(this).parent().parent().siblings(".pollutantHealth").show(); }
        if($(this).hasClass("pollutantCLPGHS")) { $(this).parent().parent().siblings(".pollutantCLPGHS").show(); }
        if($(this).hasClass("pollutantProvisions")) { $(this).parent().parent().siblings(".pollutantProvisions").show(); }
        if($(this).hasClass("eprtrProvisions")) { $(this).parent().parent().siblings(".eprtrProvisions").show(); }
        if($(this).hasClass("measurement")) { $(this).parent().parent().siblings(".measurement").show(); }
        if($(this).hasClass("hazards")) { $(this).parent().parent().siblings(".hazards").show(); }
    });
}

// Called when the pollutant group filter fropdown selection changes
// We then copy option items from the 'hidden' pollutants dropdown to the visible one
this.groupChanged=function() {
    $("#groupFilter").change(function() {
        // Get the selected groupId
        var groupIndex=$("#groupFilter option:selected").val();
        // remove all the current option values from the dropdown
        $("#pollutantFilter").children("option").remove();
        if(groupIndex=="0") {
            $("#pollutantFilterMaster").children("option").clone().appendTo("#pollutantFilter");
        }
        else {
            // Copy options from the hidden control dependant on group chosen
            if(groupIndex=="1") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='1']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="2") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='2']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="3") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='3']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="4") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='4']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="5") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='5']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="6") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='6']").clone().appendTo("#pollutantFilter");
            }
            if(groupIndex=="7") {
                $("#pollutantFilterMaster").children("option[value='0']").clone().appendTo("#pollutantFilter")
                $("#pollutantFilterMaster").children("option[value='7']").clone().appendTo("#pollutantFilter");
            }
        }
        // Sort values in the dropdown
        sortPollutant();
    });
}



// Handle clicks to tabs in molecule display
this.tabClick=function() {
    $(".tab").click(function() {
        // If its not the current active tab, add the css class
        if(!$(this).hasClass("activeTab")) {
            $(this).addClass("activeTab");
            // Remove the activeTab css class from siblings
            $(this).siblings("a").removeClass("activeTab");
            // If its the jmol tab (denoted by having css class jmol), show the content, hide the image tab 
            if($(this).hasClass("jmol")) {
                $(this).parent().siblings(".image").hide();
                $(this).parent().siblings(".jmol").show();
            }
            // Otherwise show the image tab and hide the jmol tab
            else {
                $(this).parent().siblings(".jmol").hide();
                $(this).parent().siblings(".image").show();
            }
        }
    });
}

// Provides the search/filter functionality
// Filtering achieved by adding removing a 'hide' css class
// Inclusion is decided by comparing text of the filter with text of the divs in the tr
//    as the filter text is generated by the xslt, will work in all languages
//    only 'special' filter is for the 'All' option which uses index 1
this.search=function() {
    $(".search_button").click(function() {
        // Turn the header row on
        $(".generalListStyle_headerRow").removeClass("hide");
        // Get the group filter text
        var groupFilter=$("#groupFilter option:selected").text();
        // Get the group filter index
        var groupIndex=$("#groupFilter option:selected").val();
        // Get the pullutant filter text
        var pollutantFilter=$("#pollutantFilter option:selected").text();
        // get the pollutant filter index
        var pollutantIndex=$("#pollutantFilter option:selected").val();
        if(groupIndex==0) {
            // If both indexes are 1, show all rows
            if(pollutantIndex==0) {
                $(".generalListStyle_row").removeClass("hide");
                $(".generalListStyle_row").next("tr").removeClass("hide");
            }
            else {
                // Otherwise compare the text of the filter with the text of the corresponding div
                // Loop through all the rows
                $(".generalListStyle_row").each(function() {
                    // Walk down the dom to the <a> and get the text and compare
                    if($(this).children("td:eq(0)").children("div").children("a").text()==pollutantFilter) {
                        // If we match, remove the css class
                        // this, is the table display row
                        $(this).removeClass("hide");
                        // the next row holds the actual content
                        $(this).next("tr").removeClass("hide");
                    }
                    // else add the css class
                    else {
                        $(this).addClass("hide");
                        $(this).next("tr").addClass("hide");
                    }
                });
            }
        }
        else {
            // group selected, show all pollutants in group
            if(pollutantIndex==0) {
                $(".generalListStyle_row").each(function() {
                    if($(this).children("td:eq(1)").children("div").text()==groupFilter) {
                        $(this).removeClass("hide");
                        $(this).next("tr").removeClass("hide");
                    }
                    else {
                        $(this).addClass("hide");
                        $(this).next("tr").addClass("hide");
                    }
                });
            }
            else {
                // both pollutant and group selected, so filter by both
                $(".generalListStyle_row").each(function() {
                    if($(this).children("td:eq(0)").children("div").children("a").text()==pollutantFilter&&$(this).children("td:eq(1)").children("div").text()==groupFilter) {
                        $(this).removeClass("hide");
                        $(this).next("tr").removeClass("hide");
                    }
                    else {
                        $(this).addClass("hide");
                        $(this).next("tr").addClass("hide");
                    }
                });
            }
        }
    });
}

// Get the current div and print its contents
this.printClick=function() {
    $(".pollutantPrint").click(function() {
        var divToPrint=$(this).parent(".second_contentBoxStyler").parent(".backgroundSetting").html();
        pollutantPrint(divToPrint);
    });
}

// Sort option values in group dropdown
this.sortGroup=function() {
    var $dd=$('#groupFilter');
    if($dd.length>0) { // make sure we found the select we were looking for
        // save the selected value
        var selectedVal=$dd.val();
        // get the options and loop through them
        var $options=$('option',$dd);
        var arrVals=[];
        $options.each(function() {
            // push each option value and text into an array
            arrVals.push({
                val: $(this).val(),
                text: $(this).text()
            });
        });
        // sort the array by the value (change val to text to sort by text instead)
        arrVals.sort(function(a,b) {
            if(a.text>b.text) {
                return 1;
            }
            else if(a.text==b.text) {
                return 0;
            }
            else {
                return -1;
            }

        });
        // loop through the sorted array and set the text/values to the options
        for(var i=0,l=arrVals.length;i<l;i++) {
            $($options[i]).val(arrVals[i].val).text(arrVals[i].text);
        }
        // set the selected value back
        $dd.val(selectedVal);
    }
}

// Sort option values in the pollutant dropdown
this.sortPollutant=function() {
    var $dd=$('#pollutantFilter');
    if($dd.length>0) { // make sure we found the select we were looking for
        // save the selected value
        var selectedVal=$dd.val();
        // get the options and loop through them
        var $options=$('option',$dd);
        var arrVals=[];
        $options.each(function() {
            // push each option value and text into an array
            arrVals.push({
                val: $(this).val(),
                text: $(this).text()
            });
        });
        // sort the array by the value (change val to text to sort by text instead)
        arrVals.sort(function(a,b) {
            if(a.text>b.text) {
                return 1;
            }
            else if(a.text==b.text) {
                return 0;
            }
            else {
                return -1;
            }

        });
        // loop through the sorted array and set the text/values to the options
        for(var i=0,l=arrVals.length;i<l;i++) {
            $($options[i]).val(arrVals[i].val).text(arrVals[i].text);
        }
        // set the selected value back
        $dd.val(selectedVal);
    }
}

// Initialise and wire up events
$(document).ready(function() {
    tooltip();
    pollutantToggle();
    menuClick();
    tabClick();
    search();
    groupChanged();
    printClick();
    sortGroup();
    sortPollutant();
});