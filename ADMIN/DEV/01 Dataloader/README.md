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
 */

SET varTableName = "tbl_demo";

QUALIFY "*";

$(varTableName):
LOAD 
    *;
SQL SELECT * FROM [$(varTableName)];

UNQUALIFY "*";

STORE $(varTableName) INTO "$(PATH_DATASTAGING)$(varTableName).qvd" (qvd);
```

