@echo off
set defpath="\Program Files\PuTTy"

set keyfile=insecure_putty_key.ppk
set port=2222
set prog=plink.exe

set found=
for %%i in (%path%) do if exist %%i\%prog% set found=%%i\%prog%
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

echo %found% -i %keyfile% -P %port% vagrant@localhost ./run.sh %1 %2 %3 %4 %5
%found% -i %keyfile% -P %port% vagrant@localhost ./run.sh %1 %2 %3 %4 %5
