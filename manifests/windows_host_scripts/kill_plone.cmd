@echo off
set defpath="\Program Files\PuTTy"

set keyfile=insecure_putty_key.ppk
set port=2222
set prog=plink.exe

REM Search for prog on path
set found=
for %%i in (%path%) do if exist %%i\%prog% set found=%%i\%prog%

REM if not found, use default path
if [%found%]==[] (
    if exist %defpath%\%prog% (
        set found=%defpath%\%prog%
    )
)

if [%found%]==[] (
    echo Unable to find %prog%. Please make sure %prog% is installed
    echo and that your executable path includes the directory containing it.
    exit /B
)

if not exist %keyfile% (
    echo Unable to find the Putty keyfile %keyfile%.
    echo This file needs to be in the file from which you are executing
    echo this command.
    echo.
    echo %keyfile% is ordinarily generated when you use "vagrant up"
    echo to create the Plone virtual box.
    exit /B
)

set command_line=%found% -i %keyfile% -P %port% vagrant@localhost ./kill_plone.sh
echo %command_line%
%command_line%
echo.