@echo off
setlocal enabledelayedexpansion

:: Query the registry for Osdag install location (check HKCU)
for /f "tokens=3*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" /v InstallLocation 2^>nul') do (
    set "INSTALL_PATH=%%A %%B"
    echo Found Osdag install location in HKCU: !INSTALL_PATH!
)


:: Trim trailing space if present
set "INSTALL_PATH=!INSTALL_PATH:~0,-1!"

:: Check if the InstallLocation was found
if defined INSTALL_PATH (
    :: Set the environment path (with quotes to handle spaces correctly)
    set "ENV_PATH=!INSTALL_PATH!\.pixi\envs\default"

    :: Check if osdag.exe exists
    if not exist "!ENV_PATH!\Scripts\osdag.exe" (
        pause
        exit /b
    )

    :: Run Osdag
    cmd /c "!ENV_PATH!\Scripts\osdag.exe"
) else (
    exit /b
)

endlocal
pause