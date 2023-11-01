# Windows Shutdown Timer Powershell Script

In order to be able to run this script you'll have to:
- Right click the **Shutdown Timer** shortcut file
- Click on properties
- Replace the **filepath** text inside the " " in the **Target:** field for the path to the **shutdown.ps1** script

You may find the script path by right clicking the file and choosing **Copy as path**.

In the end the contents of the **Target:** field will go from

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -ExecutionPolicy bypass -File "filepath"`

to something like

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -ExecutionPolicy bypass -File "C:\Users\abc\Shutdown script\shutdown.ps1"`.

Afterwards you'll be able to run the script by opening the shortcut.