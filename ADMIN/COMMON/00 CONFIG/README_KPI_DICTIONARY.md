# KPI Dictionary

## About

Author: Richard Patsch <richard@frenzel.net>
Version: 1.0
License: MIT

## Usage

1. How to use it on your surface:
Make use of this expression: $(=Only({<KPI.Label={"CallsTotal"}>} KPI.Definition))

2. Add the sourcecode below within one of your tabs in your QlikView script to load
the KPI dictionary.

SourceCode:

```VBA

//load KPI Dictionary from Excel file
KPI_Dictionary:
LOAD KPI.Label,
     KPI.Company,
     Definition_wrong_syntax AS KPI.Definition,
     KPI.Description,
     KPI.Valid
FROM
[..\..\ADMIN\COMMON\00 CONFIG\kpi_beta.xlsx]
(ooxml, embedded labels, table is Sheet1);

//Create tempTable to resolve references within the KPI.Definitions
tempTable:
LOAD
	'initialTestLabel' AS NAME,
	'h3h3' AS EXPRESSION  
AutoGenerate(1);  

//foreach through all Dictionary records and resolve references if necessary
FOR i = 0 TO NoOfRows('KPI_Dictionary')-1
	LET vRow = peek('KPI.Definition', $(i), 'KPI_Dictionary');
	LET vName = peek('KPI.Label', $(i), 'KPI_Dictionary');

	IF Index('$(vRow)', '|')>0 THEN
		do while Index('$(vRow)', '|')
			LET vSearchString = mid('$(vRow)',Index('$(vRow)','|',1), (Index('$(vRow)','|',2)+1-Index('$(vRow)','|',1)));
			LET vKpiLabelString = mid('$(vSearchString)',2,Len('$(vSearchString)')-2);
			LET vQuery = lookup('KPI.Definition', 'KPI.Label', '$(vKpiLabelString)', 'KPI_Dictionary');
			LET vRow = Replace('$(vRow)','$(vSearchString)', '$(vQuery)');		

			//while condition is not working (for whatever reason..)
			IF(Index('$(vRow)', '|')=0)THEN
				exit do;
			END IF			
		loop;		
	END IF

	Concatenate(tempTable)
	LOAD
		'$(vRow)' AS EXPRESSION,
		'$(vName)' AS NAME
	AutoGenerate(1);		
NEXT i;

//drop dictionary
DROP TABLE KPI_Dictionary;

//replace § signs with $
NoConcatenate
KPI_Dictionary:
LOAD
	NAME AS KPI.Label,
	replace(EXPRESSION,'§','$')AS KPI.Definition
RESIDENT tempTable
WHERE match(NAME,'initialTestLabel')=0;

//drop unnecessary tables
DROP TABLE tempTable;

```
