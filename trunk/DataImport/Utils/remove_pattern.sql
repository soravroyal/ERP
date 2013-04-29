use EPRTRcms;

DECLARE @table_name NVARCHAR(128) = 'dbo.ReviseResourceValue_test1';
DECLARE @column_name NVARCHAR(128) = 'ResourceValue';
DECLARE @match_pattern NVARCHAR(MAX) = 'target="_blank"';
DECLARE @where_pattern NVARCHAR(MAX) = 'WHERE PATINDEX(''%<A%HREF%TARGET%=%[_]BLANK%>%'', UPPER(' + @column_name + ')) > 0 OR PATINDEX(''%<A%TARGET%=%[_]BLANK%HREF%>%'', UPPER(' + @column_name + ')) > 0';
DECLARE @replace_pattern NVARCHAR(MAX) = '';

DECLARE @dsql NVARCHAR(MAX) = N'
UPDATE ' + @table_name + N'
SET ' + @column_name + ' = REPLACE (' + @column_name + ', ''' + @match_pattern + ''', ''' + @replace_pattern + ''')' +
@where_pattern;

EXECUTE sp_executesql @dsql;