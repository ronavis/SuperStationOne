@echo off
title CHDMAN Batch Audio/Data CD Converter
echo =======================================================
echo PS1 / Saturn / PCEngine CD to CHD Converter
echo =======================================================
echo.
echo Place chdman.exe in this folder or in your PATH.
echo This script will convert all .cue / .bin files in the
echo current directory into space-saving, lossless .chd files.
echo.
pause

for %%i in (*.cue) do (
    echo Converting "%%i" to "%%~ni.chd"...
    chdman createcd -i "%%i" -o "%%~ni.chd"
)

echo.
echo Conversion complete!
pause
