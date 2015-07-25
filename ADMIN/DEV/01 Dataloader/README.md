# ADMIN - DEV - 01 Dataloader

In diesem Ordner befinden sich sämtliche "Datenpumpen" welche einen rohen Datenextrakt als QVD in das Datastaging ablegen.

Load Skript Introduction Syntax Template:

```
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

```
/**
 * @dataloader tbl_demo
 * @source OLEDB
 * @version 1.0
 * Loads only one single database table form the connection
 */

SET varTableName = "tbl_demo";

QUALIFY "*";

$(varTableName):
LOAD 
    *;
SQL SELECT * FROM [$(varTableName)];

UNQUALIFY "*";

Trace "Saving to Path: $(PATH_DATASTAGING)";

STORE $(varTableName) INTO "$(PATH_DATASTAGING)$(varTableName).qvd" (qvd);

IF _DEBUG = 0 THEN
  DROP TABLE $(varTableName);
END IF;

Let varNoRecords = NoOfRows(varTableName);
Let msgLogFile = 'The Table ' & varTableName & ' has been loaded with ' & varNoRecords & ' rows.';

//hier schreiben wir einen Kommentar in ein LogFile
CALL Qvc.Log(msgLogFile,'INFO');
```

Enhanced loader sub:

```
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

```
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
