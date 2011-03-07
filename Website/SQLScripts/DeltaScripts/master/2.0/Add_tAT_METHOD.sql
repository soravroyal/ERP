--------------------------------------------------------------------------------
--
--	Delta script creating at new METHOD table
--
--	WOS, Atkins 0202201
--
--------------------------------------------------------------------------------

use EPRTRmaster

if object_id('EPRTRmaster.dbo.tAT_METHOD')is not null DROP TABLE EPRTRmaster.dbo.tAT_METHOD
CREATE TABLE EPRTRmaster.dbo.tAT_METHOD(
	[MethodID] [int] IDENTITY(1,1) NOT NULL,
	[MethodListID] [int] NOT NULL,
	[MethodCode] [nvarchar](255) NULL,
	[MethodDesignation] [nvarchar](4000) NULL,
CONSTRAINT [MethodID] PRIMARY KEY CLUSTERED ([MethodID] ASC)) ON [PRIMARY]
go
 
