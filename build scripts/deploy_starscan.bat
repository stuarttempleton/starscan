@echo off

set buildroot=D:\StarscanBuilds
set itchproject=starscan
set itchowner=voltur

echo.
echo Deploying %itchproject% from %buildroot% for %itchowner%
echo.

echo.
butler push %buildroot%\Windows %itchowner%/%itchproject%:windows
echo.
butler push %buildroot%\Linux %itchowner%/%itchproject%:linux
echo.
butler push %buildroot%\macOS %itchowner%/%itchproject%:osx
