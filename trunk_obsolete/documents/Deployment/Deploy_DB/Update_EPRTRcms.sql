


---Script to update EPRTRCMS with changes from Atkins
/*

--Prepare tables to bring to EEA
use eprtrcms
go
--new_contentsgroup
--drop table eprtrcms.dbo.new_contentsgroup
select * into eprtrmaster.dbo.new_contentsgroup 
from eprtrcms.dbo.LOV_Contentsgroup
order by Code

--new_resource
--delete from eprtrcms.dbo.reviseresourcekey where resourcekey ='HomeWelcomeText1'
--drop table eprtrcms.dbo.new_resource
select a.*,b.culturecode,b.resourcevalue into eprtrmaster.dbo.new_resource 
from eprtrcms.dbo.reviseresourcekey a
inner join eprtrcms.dbo.reviseresourcevalue b 
on a.resourcekeyid = b.resourcekeyid
order by a.resourcetype,a.resourcekey


--apply changes for testing purposes
delete from eprtrcms.dbo.new_resource where resourcekeyid in  (11,25)
update eprtrcms.dbo.new_resource set resourcekey ='HomeWelcomeText1',contentsgroupid = 6 where resourcekey= 'HomeWelcomeText'

insert into eprtrcms.dbo.new_contentsgroup (code,name,startyear,endyear)
select 'DCL1',name,startyear,endyear from eprtrcms.dbo.LOV_Contentsgroup
where code = 'DCL'
insert into eprtrcms.dbo.new_contentsgroup (code,name,startyear,endyear)
select 'DCL2',name,startyear,endyear from eprtrcms.dbo.LOV_Contentsgroup
where code = 'DCL'
delete from eprtrcms.dbo.new_contentsgroup where code in ('DCL1','DCL2')


*/

insert into eprtrcms.dbo.LOV_Contentsgroup 
(code,name,startyear,endyear)
select code,name,startyear,endyear
from eprtrmaster.dbo.new_contentsgroup where
code not in
(select code from eprtrcms.dbo.LOV_Contentsgroup)


delete from eprtrcms.dbo.reviseresourcekey where 
resourcekeyid not in (
select a.resourcekeyid from eprtrcms.dbo.reviseresourcekey a
inner join eprtrmaster.dbo.new_resource b
on a.resourcekey=b.resourcekey and a.resourcetype=b.resourcetype)

delete from eprtrmaster.dbo.new_resource where 
resourcekeyid in
(select b.resourcekeyid from eprtrmaster.dbo.new_resource b
inner join eprtrcms.dbo.reviseresourcekey  c
on b.resourcekey=c.resourcekey and b.resourcetype=c.resourcetype)


insert into eprtrcms.dbo.reviseresourcekey 
(resourcekey,resourcetype,allowhtml,keydescription,keytitle,contentsgroupid)
select a.resourcekey,a.resourcetype,a.allowhtml,a.keydescription,a.keytitle,c.lov_contentsgroupid
from eprtrmaster.dbo.new_resource a
inner join eprtrmaster.dbo.new_contentsgroup b
on a.contentsgroupid = b.lov_contentsgroupid
inner join eprtrcms.dbo.LOV_Contentsgroup c
on b.code = c.code

insert into eprtrcms.dbo.reviseresourcevalue
(resourcekeyid,culturecode,resourcevalue)
select b.resourcekeyid,a.culturecode,a.resourcevalue
from eprtrmaster.dbo.new_resource a
inner join eprtrcms.dbo.reviseresourcekey b
on a.resourcekey=b.resourcekey and a.resourcetype=b.resourcetype

drop table eprtrmaster.dbo.new_resource
drop table eprtrmaster.dbo.new_contentsgroup

/*

drop table eprtrcms.dbo.reviseresourcekey
select * into eprtrcms.dbo.reviseresourcekey from eprtrcms.dbo.reviseresourcekey_copy
drop table eprtrcms.dbo.LOV_Contentsgroup
select * into eprtrcms.dbo.LOV_Contentsgroup from eprtrcms.dbo.LOV_Contentsgroup_copy
--backup tables prior to testing
select * into eprtrcms.dbo.reviseresourcekey_copy from eprtrcms.dbo.reviseresourcekey
select * into eprtrcms.dbo.LOV_Contentsgroup_copy from eprtrcms.dbo.LOV_Contentsgroup
*/