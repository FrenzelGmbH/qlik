# ADMIN - DEV - 01 Dataloader

(EN) This folder is the source of plain data load scripts to generate a clean QVD-Datastaging Layer which can then be used as source of transformation.

(D) In diesem Ordner befinden sich sämtliche "Datenpumpen" welche einen rohen Datenextrakt als QVD in das Datastaging ablegen.

## Code Conventions

(EN) All generated data files should be written CamelCase. Pls. don't include special characters.

(D) Alle erzeugten QVDaten Dateien sollen mittels CamelCase Konvention geschrieben werden.

## Code Samples

Load Skript Introduction Syntax Template:

```vba
/**
 * @author Philipp Frenzel <philipp@frenzel.net>
 * @version 1.0
 * @copyright Frenzel GmbH 2015
 * @depends - list of scripts that need to be executed before
 * @provides - list of output files
 * @schedule - * * * * * in the style of unix cron
 */

//set the environment
SET _ENV = "DEV";
SET _DEBUG = 1;

//here we load the global config
$(include=../../COMMON/00 Config/CONF_PATHS.txt);

//at this point we integrate the qv-components
$(include=../../COMMON/LIBS/QVComponents/QVC_Runtime/Qvc.qvs);
$(include=../../COMMON/LIBS/QVComponents/QVC_Runtime/language/qvc_language_GE.qvs);
```

Load Skript Dataloader Syntax Template:

```vba
/**
 * LoadSourceTableByName
 * @param NameSpace String a prefix which will be added to the qvd to separate sources
 * @param TableDomain String the SQL Domain that you wanna laod the data from
 * @param TableAlias String if a Table has a strange name, you can pass a beautified name
 * @param TableName String the name of the table that will be exported
 * @param Historical Boolean if a historical version will be saved on a monthtly basis, pls. check comment!
 * @version 1.02
 * @author Philipp Frenzel <philipp@frenzel.net>
 */
 
SUB LoadSourceTableByName(NameSpace, TableDomain, TableAlias, TableName, Historical, FilterCondition, StorageDivider)

LET varTableDomain = TableDomain; 
LET varTableName = TableName;
LET varTableAlias = TableAlias;
LET varNameSpace = NameSpace;
LET varFilterCondition = FilterCondition;
LET varStorageDivider = StorageDivider;
SET varSQLToRun = 'SELECT * FROM $(varTableDomain)$(varTableName)';

IF FilterCondition = '' THEN
	//nothing will be changed
ELSE
	SET varSQLToRun = '$(varSQLToRun) $(varFilterCondition)';
	CALL Qvc.Log('Will Execute: $(varSQLToRun)','INFO');
END IF
 
QUALIFY "*";
 
$(varTableAlias):
LOAD *;
SQL $(varSQLToRun);
 
UNQUALIFY "*";
  
// Here we store the table as is into the filesystem 
STORE $(varTableAlias) INTO "$(PATH_DATASTAGING)$(varNameSpace)_$(varTableAlias)_$(varStorageDivider).qvd" (qvd);
 
IF Historical = 1 THEN 
	// ATTENTION, if you save historical data, pls. ensure that a folder with the tablename name exists within the datastaging root folder!
	STORE $(varTableAlias) INTO "$(PATH_DATASTAGING)HISTORY/$(varTableName)/$(varNameSpace)_$(varTableAlias)_$(varStorageDivider)$(VERSIONDATE).qvd" (qvd);
END IF

Let varNoRecords = NoOfRows(varTableAlias);
Let msgLogFile = 'The Table ' & varTableAlias & ' has been loaded with ' & varNoRecords & ' rows.';

//hier schreiben wir einen Kommentar in ein LogFile
CALL Qvc.Log(msgLogFile,'INFO');

IF _DEBUG = 0 THEN
  DROP TABLE $(varTableAlias);
END IF;
 
END SUB
```

Enhanced loader sub:

```vba
/**
 * LoadSourceTableByName
 * @param TableName String the name of the table that will be exported
 * @param Historical Boolean if a historical version will be saved on a monthtly basis, pls. check comment!
 * @version 1.0
 * @author Philipp Frenzel <philipp@frenzel.net>
 */

SUB LoadSourceTableByName(TableName, Historical)

LET varTableName = TableName;

QUALIFY "*";
 
$(varTableName):
LOAD *;
SQL SELECT * FROM spaceman.$(varTableName);
 
UNQUALIFY "*";
 
 
// Here we store the table as is into the filesystem 
STORE $(varTableName) INTO "$(PATH_DATASTAGING)$(varTableName).qvd" (qvd);

IF Historical = 1 THEN

// ATTENTION, if you save historical data, pls. ensure that a folder with the tablename name exists within the datastaging root folder!
STORE $(varTableName) INTO "$(PATH_DATASTAGING)HISTORY/($varTableName)/$(varTableName)$(VERSIONDATE).qvd" (qvd);

END IF

DROP TABLE $(varTableName);

END SUB
```


Identifizieren von Dubletten:

```vba
//first we load the raw source table
RawTable:
LOAD 
    *
FROM [$(PATH_DATASTAGING)TestSource.qvd];

//then we will load the table sorted by our dublicates identification
SortedTable:
NOCONCATENATE LOAD
    *
RESIDENT RawTable
ORDER BY %DublettenId, %Date;

//to avoid circular references, we drop the raw table
DROP TABLE RawTable;

//now we check for dublicates and add a flag
FinalTable:
NOCONCATENATE LOAD
    *
    ,IF(PREVIOUS(%DublettenId) = %DublettenId,0,1) AS FLAG_VALID
RESIDENT SortedTable;

//and finally we drop sorted as it's not needed anymore
DROP TABLE SortedTable;
```

# Logging via stored procedure
```
LogIntoTable:
Load 
	*;
SQL EXECUTE [dbo].[mdb].[NameOfProcedure]
		@param1 = $(vDocumentname),
		@param2 = $(vSuccess)
;
```
