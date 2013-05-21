use EPRTRmaster
-- remove Country ID for RBDs that are not to be show in dropdown list

update LOV_RIVERBASINDISTRICT
set LOV_CountryID = null
where Code in ('GR15', 'NOBAR', 'NONOS', 'NONS' )
