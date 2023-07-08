@echo off

echo %%~f1 is "%~dp0"

(for %%a in (%~dp0sigils\*.png)  do (
    start %~dp0/Aseprite.lnk -b "%%a" --color-mode indexed --save-as %%a 
    echo %%a
))

:: bypass for the sake of debug sanity
: EOF