@echo off
color 0b
SET fName=YourFileNameHere
SET fExtension=.qvw

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"

SET "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
SET "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

SET "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
SET oldName=%fName%%fExtension%
SET newName=%fName%_%fullstamp%%fExtension%

cd ../PROD/
copy "%oldName%" "../_BACKUP/%newName%"
echo backup done!

cd ../DEV/
copy "%oldName%" "../PROD/%oldName%"
echo new version deployed!

echo done :)

pause
