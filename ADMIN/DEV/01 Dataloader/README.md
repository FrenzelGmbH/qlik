# ADMIN - DEV - 01 Dataloader

In diesem Ordner befinden sich sämtliche "Datenpumpen" welche einen rohen Datenextrakt als QVD in das Datastaging ablegen.

Load Skript Syntax Template:

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
LET _ENV = "DEV";

//here we load the global config
$(include=../../COMMON/00 Config/CONF_PATHS.txt);
```
