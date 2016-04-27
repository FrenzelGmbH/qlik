echo off
ECHO %date% %time%: started reload >> "Reload0800Task.log"

"C:\Program Files\QlikView\Qv.exe" /R "PATH_TO_YOUR_QLIVIEW\QV_FILE.qvw"

ECHO %date% %time%: ended reload >> "Reload0800Task.log"

Exit
