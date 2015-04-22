@ECHO off
ECHO %date% %time%: started scheduler.bat >>"scheduler.log"

REM -------------------------------------------------------
REM - File: scheduler.bat
REM - Description: run qv-scripts from the command line
REM -------------------------------------------------------
ECHO Starting reload process
ECHO ======================================================

"C:\Program Files\QlikView\QV.exe" /l "D:\qlik\ADMIN\PROD\01 Dataloader\01 Reload Task.qvw"
timeout /T 20

ECHO %date% %time%: finished scheduler.bat >>"scheduler.log"