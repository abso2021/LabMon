@echo off

powershell -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"Welcome to LabMon v1.0`nBy Abbas Sobhi - May 2025\", \"LabMon (LabVIEW Monitor)\", 'OK', 'Information')"


Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass

powershell -ExecutionPolicy Bypass -File "C:\Users\abbas\Desktop\LabMon\LabMon.ps1"

pause
