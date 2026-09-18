@echo off
title SuperStation One - Google Drive Sync
echo ==========================================================
echo   SuperStation One - Google Drive Sync Tool
echo ==========================================================
echo.
echo 1. Download latest additions from Google Drive to Drive O:
echo 2. Upload local additions on Drive O: to Google Drive
echo 3. Exit
echo.
set /p choice="Enter choice (1, 2, or 3): "

if "%choice%"=="1" (
    echo.
    echo Downloading from Google Drive to O:\SuperStationOne\games...
    "O:\SuperStationOne\tools\rclone.exe" copy "gdrive:SuperStation One Hub" "O:\SuperStationOne\games" --transfers=8 --checkers=16 --progress
    echo Done!
) else if "%choice%"=="2" (
    echo.
    echo Uploading local games to Google Drive...
    "O:\SuperStationOne\tools\rclone.exe" copy "O:\SuperStationOne\games" "gdrive:SuperStation One Hub" --transfers=8 --checkers=16 --progress
    echo Done!
) else (
    echo Exiting.
)
pause
