@echo off
netsh wlan show interfaces | findstr SSID | findstr %1

if %ERRORLEVEL% EQU 0 (
    echo running command...
    %2 %3 %4 %5 %6 %7 %8 %9
    
)
