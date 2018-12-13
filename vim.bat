@ECHO OFF
SETLOCAL

rem Determine if we are supposed to call term mode
if "%~n0%"=="vim"     set EXE_NAME=gvim.exe
if "%~n0%"=="vimdiff" set EXE_NAME=gvim.exe
if %EXE_NAME%=="" goto notfound

rem Determine exe
if exist "C:\Program Files (x86)\Vim\vim81\%EXE_NAME%" set VIM_EXE_PATH=C:\Program Files (x86)\Vim\vim81\%EXE_NAME%
if exist "C:\Program Files\Vim\vim81\%EXE_NAME%"       set VIM_EXE_PATH=C:\Program Files\Vim\vim81\%EXE_NAME%
if exist "%VIM%\vim81\%EXE_NAME%"                      set VIM_EXE_PATH=%VIM%\vim81\%EXE_NAME%
if exist "%VIMRUNTIME%\%EXE_NAME%"                     set VIM_EXE_PATH=%VIMRUNTIME%\%EXE_NAME%
if not exist "%VIM_EXE_PATH%" goto notfound

rem Determine if we are supposed to call diff mode
if "%~n0" == "gvimdiff" set PARAMBYNAME=-d
if "%~n0" == "vimdiff"  set PARAMBYNAME=-d

rem Execute
echo "%VIM_EXE_PATH%" %PARAMBYNAME% %*
"%VIM_EXE_PATH%" %PARAMBYNAME% %*
goto eof

:notfound
echo "%EXE_NAME%" not found
goto eof

:eof