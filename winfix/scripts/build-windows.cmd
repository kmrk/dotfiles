@echo off
setlocal

set "PROJECT_ROOT=%CD%"
if not "%~1"=="" set "PROJECT_ROOT=%~1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-windows.ps1" -ProjectRoot "%PROJECT_ROOT%"
exit /b %ERRORLEVEL%
