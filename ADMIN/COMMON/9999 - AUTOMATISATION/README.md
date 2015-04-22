# 9999 - AUTOMATISATION

This folder gives you the tools to build an windows based scheduling of reloading qlikview documents.

```
@ECHO off
ECHO %date% %time%: started scheduler.bat >>"scheduler.log"

REM -------------------------------------------------------
REM - File: scheduler.bat
REM - Description: run qv-scripts from the command line
REM - Options /r run /l loads and executes makros
REM -------------------------------------------------------
ECHO Starting reload process
ECHO ======================================================

ECHO Reload "D:\qlik\ADMIN\DEV\01 Dataloader\01 Hello World.qvw"
"c:\Program Files\QlikView\QV.exe" /r "c:\qlik\ADMIN\PROD\01 Dataloader\01 Hello World.qvw"
timeout /T 20

ECHO %date% %time%: finished scheduler.bat >>"scheduler.log"
```
