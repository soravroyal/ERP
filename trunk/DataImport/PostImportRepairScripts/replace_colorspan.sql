use EPRTRcms

DECLARE @table_name NVARCHAR(128) = 'dbo.ReviseResourceValue';
DECLARE @column_name NVARCHAR(128) = 'ResourceValue';
DECLARE @regex nvarchar(128) = '%<span style="color: #993300;%'
DECLARE @where_pattern NVARCHAR(MAX) = 'WHERE PATINDEX('''+@regex+''', UPPER(ResourceValue)) > 0 ';

-- * Declaire first temporary function
-- * This function identifies the first SPAN node with the color attribute set to #993300 
-- * This node is replaced with an EM node and the SPAN end node is replased wiat an EM end node
declare @Fsql1 nvarchar(max) = '

    create function dbo._ReplaceSpan(@resval nvarchar(max))
    returns nvarchar(max) as
    begin
	  -- Index of SPAN with color 993300
	  declare @pi_1 int = PATINDEX(''' + @regex + ''', UPPER(@resval)) ;
	  -- String part before start span node	  
	  declare @lf_1 nvarchar(max)= LEFT(@resval,(@pi_1-1));

	  -- String part incl. the span
	  declare @r_1 nvarchar(max) = RIGHT(@resval, (LEN(@resval)-@pi_1));
	  -- String part excl. the span
	  declare @r_2 nvarchar(max)= RIGHT(@r_1,(LEN(@r_1) - PATINDEX(''%>%'',@r_1)));

	  -- index of span end node	  
	  declare @pi_3 int = PATINDEX(''%</SPAN>%'',UPPER(@r_2));
	  -- String part between start and end span nodes	  
	  declare @lf_2 nvarchar(max)= LEFT(@r_2,(@pi_3-1));
	  -- length of string part
	  declare @l_3 int = LEN(@r_2);

--* loop
        -- Temp String reduced for every span we discover
        declare @s_t nvarchar(max)=@lf_2 ;
        declare @pi_t int = 0 ;
        declare @r_t nvarchar(max) = RIGHT(@r_2, (@l_3-@pi_3)+1) ;
        declare @l_t int = LEN(@r_t) ;
        set @lf_2 = ''''

        WHILE PATINDEX(''%<SPAN%'', UPPER(@s_t)) > 0
            BEGIN 
            -- * We know that the first end span belongs another span
            -- * String set to be @lf_2 minus start span 
            -- Move </SPAN> from rt to st
			set @lf_2 = @lf_2 + @s_t + ''</SPAN>''-- LEFT(@r_t,(@pi_t-1));
			set @r_t = RIGHT(@r_t,(LEN(@r_t)-7))

            -- to be evaluated next time
            set @pi_t = PATINDEX(''%</SPAN%'', UPPER(@r_t))
            set @s_t = LEFT(@r_t,@pi_t-1);-- RIGHT(@r_t, (@l_t - @pi_t)) ; 
            set @r_t = RIGHT(@r_t, (LEN(@r_t)-@pi_t)+1) 

            --* Add string part uptil next end span
            --* we add to @pi_3
			set @pi_3 = @pi_3 + 7 + @pi_t ;
          
--          set @s_t = @s_t + LEFT(@r_t,(@pi_t-1));
            END;

		if (@lf_2 = '''') set @lf_2 = @s_t ;
	  -- String part incl. the span
	  declare @r_3 nvarchar(max) = RIGHT(@r_2, (@l_3-@pi_3));
	  -- String part excl. the span
	  declare @r_4 nvarchar(max)= RIGHT(@r_3,(LEN(@r_3) - PATINDEX(''%>%'',@r_3)));

      return 
		@lf_1 + ''<em>'' + @lf_2 + ''</em>'' + @r_4
    end ;
  '
  if object_id('dbo._ReplaceSpan') is not null drop function dbo._ReplaceSpan
  exec (@Fsql1);

-- * Declaire second temporary function
-- * This function calls the first function as long as SPAN nodes with 
-- * the color attribute set to #993300 exists 
declare @Fsql2 nvarchar(max) = '
    create function dbo._ReplaceAllSpan(@resval nvarchar(max))
    returns nvarchar(max) as
    begin
	  WHILE PATINDEX(''' + @regex + ''', UPPER(@resval)) > 0
		BEGIN
			set @resval = dbo._ReplaceSpan(@resval);	
		END
      return 
		@resval
    end ;
  '

  if object_id('dbo._ReplaceAllSpan') is not null drop function dbo._ReplaceSpan
  exec (@Fsql2);

-- * UPDATE THE RECORDS using the two temp functions 
  DECLARE @dsql NVARCHAR(MAX) = N'
UPDATE ' + @table_name + N'
SET ' + @column_name + ' = dbo._ReplaceAllSpan(' + @column_name + ')' +
@where_pattern;

EXECUTE sp_executesql @dsql;

/*SELECT top 1 [ResourceValue],dbo._ReplaceAllSpan(ResourceValue) as repl
  FROM dbo.ReviseResourceValue_Moh
  WHERE PATINDEX(@regex , UPPER(ResourceValue)) > 0 ;
  
--<span style="color: #993300;">
*/

  -- * Clean up by deleting the temp functions
  drop function dbo._ReplaceAllSpan ;
  drop function dbo._ReplaceSpan ;