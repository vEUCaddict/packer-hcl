REM Run this script before shut down


REM AppVol Stop Service

NET START | FIND "App Volumes Service" >nul

IF errorlevel 0 NET STOP "App Volumes Service"


REM Delete AppVol SvService.log file

del /F /S /Q "%PROGRAMFILES(x86)%\CloudVolumes\Agent\Logs\svservice.log"


REM PAUSE


REM Delete files and folders in Users Temporary Files folder

del /F /S /Q %LOCALAPPDATA%\Temp\*.*

for /D %%i in ("%LOCALAPPDATA%\Temp\*") do RD "%%i" /S /Q


REM Delete files and folders in Temporary Files folder in Windows directory

del /F /S /Q %WINDIR%\Temp\*.*

for /D %%i in ("%WINDIR%\Temp\*") do RD "%%i" /S /Q


REM Delete files and folders in Temporary Files folder in C:\Temp

del /F /S /Q C:\Temp\*.*

for /D %%i in ("C:\Temp\*") do RD "%%i" /S /Q


REM Clear Event Logs

FOR /F "tokens1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V

IF (%adminTest%)==(Access) goto theEnd

FOR /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

goto theEnd

:do_clear

echo clearing %1

wevtutil.exe cl %1

goto :eof

:theEnd


REM Rearm Office 2016
"%PROGRAMFILES%\Microsoft Office\Office16\OSPPREARM.EXE"

REM Rearm NVIDIA Grid License
REM sc stop NVWMI
REM sc stop NVDisplay.ContainerLocalSystem
REM rmdir /S /Q "%PROGRAMFILES%\NVIDIA Corporation\Grid Licensing\"


REM Pause


REM Flush DNS

ipconfig /flushdns


REM Release IP

ipconfig /release


REM shutdown

shutdown /s /t 5 /c "Please take a snapshot after the VM is powered down"

 