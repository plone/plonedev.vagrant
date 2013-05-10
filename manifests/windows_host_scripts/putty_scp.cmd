@echo off
set defpath="\Program Files\PuTTy"
set defpath_x64="\Program Files (x86)\PuTTy"

set keyfile=insecure_putty_key.ppk
set port=2222
set prog=pscp.exe

if [%1]==[] (
    echo usage: %prog% vagrant@localhost:guest_source host_target
    echo or %prog% host_source vagrant@localhost:guest_target
    exit /B
)


set found=
if exist %defpath%\%prog% (
    set found=%defpath%\%prog%
)
if exist %defpath_x64%\%prog% (
    set found=%defpath_x64%\%prog%
)
if [%found%]==[] (
    echo Unable to find %prog%. Please make sure %prog% is installed.
    echo If it is installed and you're still getting this error,
    echo edit this .cmd file to specify the path to Putty's install
    echo directory.
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

set command_line=%found% -i %keyfile% -P %port% %1 %2 %3 %4 %5 %6
echo %command_line%
%command_line%
echo.