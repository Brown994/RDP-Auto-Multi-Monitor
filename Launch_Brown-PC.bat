@echo off
set "ScriptPath=Launch_RDP.ps1"
set "RDPPath=%USERPROFILE%\OneDrive\Desktop\Brown-PC.rdp"

start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%ScriptPath%" -RDPPath "%RDPPath%" -OmitX "-1920"