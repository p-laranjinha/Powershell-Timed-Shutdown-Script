# <img src="https://raw.githubusercontent.com/p-laranjinha/Powershell-Timed-Shutdown-Script/master/icon.svg" width="32px" /> Windows Shutdown Timer Powershell Script

This repository contains a small script/executable that allows the user to set a timer to shutdown their computer.

<p align="center">
  <img src="https://raw.githubusercontent.com/p-laranjinha/Powershell-Timed-Shutdown-Script/master/screenshot.png" />
</p>

## Turning .ps1 into .exe

In order to turn the `ShutdownTimer.ps1` into `ShutdownTimer.exe`:
- Make sure [PS2EXE](https://github.com/MScholtes/PS2EXE) is installed via `powershell.exe -command "Install-Module ps2exe"` as an Administrator
- Make sure execution policy allows PS2EXE to be run via `powershell -command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"` as an Administrator
- Run `powershell.exe -command "Invoke-ps2exe .\ShutdownTimer.ps1 .\ShutdownTimer.exe -noConsole -iconFile .\icon.ico"`

## Turning .svg into .ico

In order to turn the `icon.svg` into `icon.ico`:
- Make sure [ImageMagick](https://www.imagemagick.org/script/index.php) is installed
- Run `magick convert -background none icon.svg -define icon:auto-resize icon.ico`