/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP 1000 [ResourceValueID]
      ,[ResourceKeyID]
      ,[CultureCode]
      ,[ResourceValue]
      ,[ChangedDate]
  FROM [EPRTRcms].[dbo].[tAT_ResourceValue]
  where ResourceKeyID in (select ResourceKeyID from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER')
  
  SELECT TOP 1000 [ResourceValueID]
      ,[ResourceKeyID]
      ,[CultureCode]
      ,[ResourceValue]
      ,[ChangedDate]
  FROM [EPRTRcms].[dbo].[tAT_ResourceValue]
  where ResourceKeyID in (select ResourceKeyID from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2.short')
    */
  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'pl-PL', N'Dwutlenek węgla (CO2)')
  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'de-DE',N'Kohlendioxid (CO2)')
  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'ro-RO',N'Dioxid de carbon (CO2)')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'fr-FR',N'Dioxyde de carbone (CO<sub>2</sub>)')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'es-ES',N'Dióxido de carbono (CO2)')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'it-IT',N'Biossido di carbonio (CO2)')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER'),'nl-NL',N'Kooldioxide (CO2)')

  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'pl-PL','CO<sub>2</sub>')
  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'de-DE','CO<sub>2</sub>')
  insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'ro-RO','CO<sub>2</sub>')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'fr-FR','CO<sub>2</sub>')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'es-ES','DCO<sub>2</sub>')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'it-IT','CO<sub>2</sub>')
insert into EPRTRcms.dbo.tAT_ResourceValue (ResourceKeyID,CultureCode,resourcevalue)
  values((select resourcekeyid from eprtrcms.dbo.tat_resourcekey where ResourceKey = 'CO2 in EPER.short'),'nl-NL','CO<sub>2</sub>')

--delete EPRTRcms.dbo.tAT_ResourceValue where resourcevalue = 'Dwutlenek wegla (CO2)'

