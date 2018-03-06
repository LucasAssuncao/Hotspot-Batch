@echo off

REM =====================================================
For /F "tokens=1,2,3 delims=/ " %%A in ('Date /t') do @(
    Set dia=%%A
    Set mes=%%B
    Set ano=%%C)
REM =====================================================

IF "%~1"=="/?" (
    :HELP
    REM  ECHO Example 2: "%~NX0" LSERVER P4ssw0rd
    ECHO.
    ECHO Create a HotSpot to share Internet connection with other devices, like Smarphones and LapTops. 
    ECHO.
    ECHO PS: Your PC needs an Internet connection to share Internet with other devices.
    ECHO Also, your PC needs a Wireless Network Card that supports a Windows HostedNetwork
    ECHO.    
    REM ECHO Arg 1: ServerName ^(The name of the HotSpot^)
    REM ECHO Arg 2: Password   ^(The password of the HotSpot^)
    ECHO. 
    ECHO How to Use: hotspot [Option as Arg1] ... Arg2 ... Arg3
    ECHO.

    ECHO -----------------------------------------------------

    ECHO To create a HotSpot: 
    ECHO hotspot -c [HotspotName as Arg2] [Password as Arg3]
    ECHO.
    ECHO Example: hotspot -c LSERVER P4ssw0rd
    ECHO          ou
    ECHO          hotspot --create LSERVER P4ssw0rd
    ECHO.
    ECHO OBS: Password needs at least 8 characters
    ECHO.

    ECHO -----------------------------------------------------

    ECHO To START a HotSpot:
    ECHO.
    ECHO Example: hotspot -s
    ECHO          ou
    ECHO          hotspot --start    
    ECHO.

    ECHO -----------------------------------------------------
    
    ECHO To STOP a HotSpot:
    ECHO.
    ECHO Example: hotspot -p
    ECHO          ou
    ECHO          hotspot --pause
    ECHO.

    ECHO -----------------------------------------------------
    
    ECHO To CHECK if your PC Wireless Network Card supports a HotSpot:
    ECHO.
    ECHO Example: hotspot -ch
    ECHO          ou
    ECHO          hotspot --check
    ECHO.

    ECHO -----------------------------------------------------

    ECHO To CREATE a HotSpot with random SSID and Password:
    ECHO.
    ECHO Example: hotspot -cr
    ECHO          ou
    ECHO          hotspot --create-random
    ECHO.

    ECHO -----------------------------------------------------

    ECHO To GET the last HotSpot data ^(SSID and Password^):
    ECHO.
    ECHO Example: hotspot -gl
    ECHO          ou
    ECHO          hotspot --get-last
    ECHO.

    ECHO -----------------------------------------------------

    ECHO To Check the current status of your HotSpot ^(On Off^):
    ECHO.
    ECHO Example: hotspot -st
    ECHO          ou
    ECHO          hotspot --status
    ECHO.

    ECHO -----------------------------------------------------

    EXIT /B

) ELSE ( 
    IF "%~1"=="-h" (
        goto HELP
    )
    
    IF "%~1"=="--help" (
        goto HELP
    )

    IF "%~1"=="-c" (  
        netsh wlan set hostednetwork mode=allow ssid=%2 key=%3

	echo =================================== >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot created at: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot Name: %2 >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot Password: %3 >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo =================================== >> C:\batch\TXT\wifiHistory.txt

	GOTO eof
    )
    
    IF "%~1"=="--create" (
        netsh wlan set hostednetwork mode=allow ssid=%2 key=%3

	echo =================================== >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot created at: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot Name: %2 >> C:\batch\TXT\wifiHistory.txt
	echo HotSpot Password: %3 >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo =================================== >> C:\batch\TXT\wifiHistory.txt

    	GOTO eof
    )

    IF "%~1"=="-cr" (  
        GOTO random
	:kreate
	netsh wlan set hostednetwork mode=allow ssid=%wname% key=%pas%
	
	tail -n 7 C:\batch\TXT\wifiHistory.txt
	ECHO.
	netsh wlan start hostednetwork
	GOTO eof
    )
    
    IF "%~1"=="--create-random" (
	GOTO random
	:kreate
        netsh wlan set hostednetwork mode=allow ssid=%wname% key=%pas%
	
	tail -n 7 C:\batch\TXT\wifiHistory.txt
	ECHO.
	netsh wlan start hostednetwork
	GOTO eof
    )

    IF "%~1"=="-s" (
        netsh wlan start hostednetwork
	GOTO eof
    )

    IF "%~1"=="--start" (
        netsh wlan start hostednetwork
	GOTO eof
    )

    IF "%~1"=="-p" (
        netsh wlan stop hostednetwork
	GOTO eof
    )

    IF "%~1"=="--pause" (
        netsh wlan stop hostednetwork
	GOTO eof
    )

    IF "%~1"=="-ch" (
        netsh wlan show drivers | find "Hosted Network"
        ECHO.
	GOTO eof
    )

    IF "%~1"=="--check" (
        netsh wlan show drivers | find "Hosted Network"
        ECHO.
	GOTO eof
    )

    IF "%~1"=="-gl" (
        tail -n 7 C:\batch\TXT\wifiHistory.txt
        ECHO.
	GOTO eof
    )

    IF "%~1"=="--get-last" (
        tail -n 7 C:\batch\TXT\wifiHistory.txt
        ECHO.
	GOTO eof
    )

    IF "%~1"=="-st" (
        powershell "$test = netsh wlan show hostednetwork; $test -replace('\s+',' ')"
        ECHO.
	GOTO eof
    )

    IF "%~1"=="--status" (
        powershell "$test = netsh wlan show hostednetwork; $test -replace('\s+',' ')" 
        ECHO.
	GOTO eof
    )    

    ECHO.
    powershell "Write-Host -ForegroundColor Red" You need to pass a parameter
    powershell "Write-Host -ForegroundColor Red"  Type "/?" to get help
    ECHO.
    GOTO eof
)

:random
set filename=C:\batch\TXT\names.txt
for /f "tokens=*" %%a in ('powershell -ex bypass -c "gc %filename% | ? { $_ } | Get-Random"') do (
  set "wname=%%a"
)

set pas=
set s=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
set m=0
:loop
set /a n=%random% %% 62
call set pas=%pas%%%s:~%n%,1%%
set /a m=m+1
if not %m%==8 goto loop:


echo =================================== >> C:\batch\TXT\wifiHistory.txt
echo. >> C:\batch\TXT\wifiHistory.txt
echo HotSpot created at: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
echo HotSpot Name: %wname% >> C:\batch\TXT\wifiHistory.txt
echo HotSpot Password: %pas% >> C:\batch\TXT\wifiHistory.txt
echo. >> C:\batch\TXT\wifiHistory.txt
echo =================================== >> C:\batch\TXT\wifiHistory.txt

GOTO kreate

:eof
