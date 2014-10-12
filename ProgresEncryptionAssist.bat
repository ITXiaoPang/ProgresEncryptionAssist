@echo off & cls
set CurrentPath=%cd%
set sendto_path=%userprofile%\AppData\Roaming\Microsoft\Windows\SendTo
if "%CurrentPath%" equ "%sendto_path%" goto error_sendto_directory
if not exist "%CurrentPath%\xcode.exe" goto error_xcode_not_found
if not exist "%sendto_path%\ProgresEncryptionAssist.lnk" goto makelink
if not exist src\con md src
if not exist xrc\con md xrc
del "%CurrentPath%\src\*" /Q
del "%CurrentPath%\xrc\*" /Q
:getParameter
set myParameter=%1
if not defined myParameter goto encryption
copy %myParameter% "%CurrentPath%\src" >nul 2>nul
shift
goto getParameter
:encryption
cd /d "%CurrentPath%\src"
..\xcode.exe -d ..\xrc *
del "%CurrentPath%\src\*" /Q
start explorer "%CurrentPath%\xrc"
goto end

:error_sendto_directory
echo Error: Please put me into any directory without this one
echo Press any key to exit
pause >nul 2>nul
goto end

:error_xcode_not_found
cls
echo Error: xcode.exe not found
echo Please input the directory of xcode.exe
set /p xcode_path=:
if not exist "%xcode_path%\xcode.exe" goto error_xcode_not_found
move %0 "%xcode_path%\"
goto end

:makelink
echo Set WshShell = WScript.CreateObject("WScript.Shell") > tmp.vbs
echo set oShellLink = WshShell.CreateShortcut("%sendto_path%\ProgresEncryptionAssist.lnk") >> tmp.vbs
echo oShellLink.TargetPath = "%CurrentPath%\ProgresEncryptionAssist.bat" >> tmp.vbs
echo oShellLink.IconLocation = "%CurrentPath%\ProgresEncryptionAssist.bat, 0" >> tmp.vbs
echo oShellLink.Description = "ProgresEncryptionAssist" >> tmp.vbs
echo oShellLink.WorkingDirectory = "%CurrentPath%" >> tmp.vbs
echo oShellLink.Save >> tmp.vbs
echo CreateObject("Scripting.FileSystemObject").GetFile(WScript.ScriptFullName).Delete >> tmp.vbs
start wscript -e:vbs tmp.vbs
echo Initial success.
echo Please select the unencrypted progress program(Support multiple) and sendto ProgresEncryptionAssist to encryption.
echo Press any key to exit.
pause >nul 2>nul
goto end

:end
exit
