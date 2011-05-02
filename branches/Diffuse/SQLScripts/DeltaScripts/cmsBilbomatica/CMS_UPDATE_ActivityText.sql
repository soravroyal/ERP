update ReviseResourceValue
set ResourceValue='Under construction.'
where ResourceKeyID in( select rk.ResourceKeyID from ReviseResourceKey rk
where rk.ResourceKey = 'ActivityPageContentEPER' and rk.ResourceType='Library')
