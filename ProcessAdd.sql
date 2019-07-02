--EXEC sp_serveroption 'DOTSSAS',
--                     'remote proc transaction promotion', 'false'

DECLARE @MDX NVARCHAR(MAX) = 'SELECT NON EMPTY { [Measures].[Maximum Sale Key] } ON COLUMNS FROM [Fdw]'

DECLARE @ResultTable TABLE(Result NVARCHAR(MAX))

INSERT @ResultTable 
EXECUTE(@MDX) AT DOTSSAS

DECLARE @MaxSaleKey NVARCHAR(MAX)
SET @MaxSaleKey = (SELECT Result FROM @ResultTable)
--SELECT @Result



DECLARE @XMLA NVARCHAR(MAX) =
'<Batch xmlns="http://schemas.microsoft.com/analysisservices/2003/engine">
  <Parallel>
    <Process xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500">
      <Object>
        <DatabaseID>MultidimensionalProject2</DatabaseID>
        <CubeID>Fdw</CubeID>
        <MeasureGroupID>Fact Sale</MeasureGroupID>
        <PartitionID>p03</PartitionID>
      </Object>
      <Type>ProcessAdd</Type>
      <WriteBackTableCreation>UseExisting</WriteBackTableCreation>
    </Process>
  </Parallel>
  <Bindings>
    <Binding>
      <DatabaseID>MultidimensionalProject2</DatabaseID>
      <CubeID>Fdw</CubeID>
      <MeasureGroupID>Fact Sale</MeasureGroupID>
      <PartitionID>p03</PartitionID>
      <Source xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ddl2="http://schemas.microsoft.com/analysisservices/2003/engine/2" xmlns:ddl2_2="http://schemas.microsoft.com/analysisservices/2003/engine/2/2" xmlns:ddl100_100="http://schemas.microsoft.com/analysisservices/2008/engine/100/100" xmlns:ddl200="http://schemas.microsoft.com/analysisservices/2010/engine/200" xmlns:ddl200_200="http://schemas.microsoft.com/analysisservices/2010/engine/200/200" xmlns:ddl300="http://schemas.microsoft.com/analysisservices/2011/engine/300" xmlns:ddl300_300="http://schemas.microsoft.com/analysisservices/2011/engine/300/300" xmlns:ddl400="http://schemas.microsoft.com/analysisservices/2012/engine/400" xmlns:ddl400_400="http://schemas.microsoft.com/analysisservices/2012/engine/400/400" xmlns:ddl500="http://schemas.microsoft.com/analysisservices/2013/engine/500" xmlns:ddl500_500="http://schemas.microsoft.com/analysisservices/2013/engine/500/500" xsi:type="QueryBinding">
        <DataSourceID>Fdw</DataSourceID>
        <QueryDefinition>SELECT * FROM FactSale WHERE SaleKey >'+ @MaxSaleKey +'</QueryDefinition>
      </Source>
    </Binding>
  </Bindings>
</Batch>'

exec (@XMLA) AT DOTSSAS
