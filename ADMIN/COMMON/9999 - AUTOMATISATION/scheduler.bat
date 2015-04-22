@ECHO off
ECHO %date% %time%: started scheduler.bat >>"scheduler.log"

REM -------------------------------------------------------
REM - File: scheduler.bat
REM - Description: run qv-scripts from the command line
REM - Options /r run /l loads and executes makros
REM -------------------------------------------------------
ECHO Starting reload process
ECHO ======================================================

ECHO Reload "D:\qlik\ADMIN\PROD\01 Dataloader\01 Reload Task.qvw"
"C:\Program Files\QlikView\QV.exe" /r "D:\qlik\ADMIN\PROD\01 Dataloader\01 Reload Task.qvw"
timeout /T 20

ECHO %date% %time%: finished scheduler.bat >>"scheduler.log"