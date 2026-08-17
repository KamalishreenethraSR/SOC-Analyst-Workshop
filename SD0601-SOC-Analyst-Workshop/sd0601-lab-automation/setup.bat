@echo off
REM ==============================================================================
REM SD0601 — Windows VM Controller Entry Point (Batch File)
REM ==============================================================================
REM Primary launcher for Windows 10/11 VM. Launches setup.ps1 with bypass execution policy.
REM ==============================================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
