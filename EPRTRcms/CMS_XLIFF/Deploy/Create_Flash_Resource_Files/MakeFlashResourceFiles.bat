erase %basedir%\files /q /s

call MakeFlashResourceFilesSingle.bat %2 MAP_BookmarkWidgetStrings BookmarkWidgetStrings
call MakeFlashResourceFilesSingle.bat %2 MAP_ControllerStrings ControllerStrings
call MakeFlashResourceFilesSingle.bat %2 MAP_FilterAllWidgetStrings FilterAllWidgetStrings 
call MakeFlashResourceFilesSingle.bat %2 MAP_GazetteerWidgetStrings GazetteerWidgetStrings
call MakeFlashResourceFilesSingle.bat %2 MAP_LookupSearchAllWidgetStrings LookupSearchAllWidgetStrings
call MakeFlashResourceFilesSingle.bat %2 MAP_OverviewMapWidgetStrings OverviewMapWidgetStrings 
call MakeFlashResourceFilesSingle.bat %2 MAP_PrintWidgetStrings PrintWidgetStrings 
call MakeFlashResourceFilesSingle.bat %2 MAP_SearchAllWidgetStrings SearchAllWidgetStrings
call MakeFlashResourceFilesSingle.bat %2 MAP_WidgetTemplateStrings WidgetTemplateStrings 
call MakeFlashResourceFilesSingle.bat %2 ChartLabels ChartLabels

erase %basedir%\%1 /q /s
xcopy %basedir%\files %basedir%\%1 /s

