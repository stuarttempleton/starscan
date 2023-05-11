@echo off

set buildroot=C:\StarscanBuilds
set itchproject=starscan
set itchowner=voltur
set artdirectory=custom_steam_images

echo.
echo Copying custom steam images to build dirs
echo.

xcopy %buildroot%\%artdirectory% %buildroot%\Linux\%artdirectory% /y /i /q
xcopy %buildroot%\%artdirectory% %buildroot%\Windows\%artdirectory% /y /i /q
xcopy %buildroot%\%artdirectory% %buildroot%\macOS\%artdirectory% /y /i /q

echo.
echo Deploying %itchproject% from %buildroot% for %itchowner%
echo.

echo.
butler push %buildroot%\Windows %itchowner%/%itchproject%:windows
echo.
butler push %buildroot%\Linux %itchowner%/%itchproject%:linux
echo.
butler push %buildroot%\macOS %itchowner%/%itchproject%:osx
