DECLARE @ResultTable TABLE(Result NVARCHAR(MAX))

INSERT INTO @ResultTable
SELECT *
FROM OPENQUERY(MULTIDIMENSIONAL, '
WITH MEMBER [Measures].[LatestDay] AS
TAIL(
    FILTER(
        [Date].[Date].[Date].MEMBERS, 
        NOT ISEMPTY([Measures].[Internet Sales Amount])
    )
).ITEM(0).NAME

SELECT [Measures].[LatestDay] ON COLUMNS
FROM [Adventure Works]
')
-- January 28, 2014


DECLARE @LatestDay NVARCHAR(MAX)
SET @LatestDay = (SELECT Result FROM @ResultTable)
SELECT @LatestDay = CONCAT(YEAR(@LatestDay), 
                           MONTH(@LatestDay),
                           DAY(@LatestDay))
-- January 28, 2014 will be converted to 2014128

DECLARE @XMLA NVARCHAR(MAX) =
'...
<QueryDefinition>
                 SELECT * 
                 FROM FactSale 
                 WHERE DateKey >'
                                + @LatestDay +
'</QueryDefinition>
...'

EXECUTE (@XMLA) AT MULTIDIMENSIONAL
