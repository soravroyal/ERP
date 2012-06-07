--------------------------------------------------------------------------------
--
--	Delta script adding functions to EPRTRmaster
--
--	WOS, Atkins 0202201
--
--------------------------------------------------------------------------------


if object_id('dbo.fAT_GETMETHODDESIGNATION')is not null DROP FUNCTION dbo.fAT_GETMETHODDESIGNATION
go
CREATE FUNCTION dbo.fAT_GETMETHODDESIGNATION 
( 
    @mlID int   
) 
RETURNS NVARCHAR(4000) 
AS 
BEGIN 
    DECLARE @r VARCHAR(4000) 
    SELECT @r = ISNULL(@r+'|', '') + mu.MethodDesignation
    FROM METHODUSED mu
    WHERE mu.MethodListID = @mlID 
    RETURN @r 
END 
GO 


if object_id('dbo.fAT_GETMETHODTYPE')is not null DROP FUNCTION dbo.fAT_GETMETHODTYPE
go
CREATE FUNCTION dbo.fAT_GETMETHODTYPE
( 
    @mlID int   
) 
RETURNS NVARCHAR(255) 
AS 
BEGIN 
    DECLARE @r VARCHAR(255) 
    SELECT @r = ISNULL(@r+'|', '') + lov.Code
    FROM METHODUSED mu
    inner join LOV_METHODTYPE lov
	on mu.LOV_MethodTypeID = lov.LOV_MethodTypeID        
	WHERE mu.MethodListID = @mlID 
    RETURN @r 
END 
GO 

--select * from METHODUSED where MethodListID = 110225
