@echo off
REM Safe ART Runner Launcher for Windows VM
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-test.ps1" %*
