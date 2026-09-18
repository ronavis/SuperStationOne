@echo off
title SuperStation One - Google Drive Sync
echo ==========================================================
echo   SuperStation One - Google Drive Sync Tool
echo ==========================================================
echo.
echo 1. Download ROMs & BIOS from Google Drive Hub
echo 2. Backup Saves, Configs & BIOS to Google Drive Hub
echo 3. Exit
echo.
set /p choice="Enter choice (1, 2, or 3): "

if "%choice%"=="1" (
    powershell -ExecutionPolicy Bypass -File "%~dp0download_library.ps1"
) else if "%choice%"=="2" (
    powershell -ExecutionPolicy Bypass -File "%~dp0backup_to_cloud.ps1"
) else (
    echo Exiting.
)
pause
