@echo off

REM =====================================================
For /F "tokens=1,2,3 delims=/ " %%A in ('Date /t') do @(
    Set dia=%%A
    Set mes=%%B
    Set ano=%%C)
REM =====================================================

IF "%~1"=="/?" (
    :HELP
    REM  ECHO Exemplo 2: "%~NX0" LSERVER P4ssw0rd
    ECHO.
    ECHO Cria um ponto de acesso Wi-Fi para ser utilizado. 
    ECHO.
    ECHO OBS: A maquina deve possuir conexao com a Internet 
    ECHO para fornecer Internet para os outros dispositivos conectados
    ECHO.    
    ECHO Argumento 1: ServerName ^(Corresponde ao nome do HotSpot Wi-Fi que sera criado^)
    ECHO Argumento 2: Password   ^(Corresponde a senha do Hotspot Wi-Fi que sera criado^)
    ECHO. 
    ECHO Como Usar: hotspot [Option as Arg1] ... Arg2 ... Arg3
    ECHO.

    ECHO -----------------------------------------------------

    ECHO Para criar um HotSpot: 
    ECHO hotspot -c [HotspotName as Arg2] [Password as Arg3]
    ECHO.
    ECHO Exemplo: hotspot -c LSERVER P4ssw0rd
    ECHO          ou
    ECHO          hotspot --create LSERVER P4ssw0rd
    ECHO.
    ECHO OBS: A senha deve ter no minimo 8 caracteres
    ECHO.

    ECHO -----------------------------------------------------

    ECHO Para INICIAR um HotSpot:
    ECHO.
    ECHO Exemplo: hotspot -s
    ECHO          ou
    ECHO          hotspot --start    
    ECHO.

    ECHO -----------------------------------------------------
    
    ECHO Para PARAR um HotSpot:
    ECHO.
    ECHO Exemplo: hotspot -p
    ECHO          ou
    ECHO          hotspot --pause
    ECHO.

    ECHO -----------------------------------------------------
    
    ECHO Para CHECAR se a placa wireless suporta um HotSpot:
    ECHO.
    ECHO Exemplo: hotspot -ch
    ECHO          ou
    ECHO          hotspot --check
    ECHO.

    ECHO -----------------------------------------------------

    ECHO Para CRIAR um Hotspot com SSID e Senha Aleatoria:
    ECHO.
    ECHO Exemplo: hotspot -cr
    ECHO          ou
    ECHO          hotspot --create-random
    ECHO.

    ECHO -----------------------------------------------------

    ECHO Para CONSULTAR os dados do Hotspot atual:
    ECHO.
    ECHO Exemplo: hotspot -gl
    ECHO          ou
    ECHO          hotspot --get-last
    ECHO.

    ECHO -----------------------------------------------------

    ECHO Para CONSULTAR o STATUS do Hotspot atual:
    ECHO.
    ECHO Exemplo: hotspot -st
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
	echo Rede Wi-Fi gerada em: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
	echo Nome da Rede Wi-fi: %2 >> C:\batch\TXT\wifiHistory.txt
	echo Senha da Rede Wi-fi: %3 >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo =================================== >> C:\batch\TXT\wifiHistory.txt

	GOTO eof
    )
    
    IF "%~1"=="--create" (
        netsh wlan set hostednetwork mode=allow ssid=%2 key=%3

	echo =================================== >> C:\batch\TXT\wifiHistory.txt
	echo. >> C:\batch\TXT\wifiHistory.txt
	echo Rede Wi-Fi gerada em: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
	echo Nome da Rede Wi-fi: %2 >> C:\batch\TXT\wifiHistory.txt
	echo Senha da Rede Wi-fi: %3 >> C:\batch\TXT\wifiHistory.txt
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
        netsh wlan show drivers | find "Rede hospedada"
        ECHO.
	GOTO eof
    )

    IF "%~1"=="--check" (
        netsh wlan show drivers | find "Rede hospedada"
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
    powershell "Write-Host -ForegroundColor Red" Voce precisa passar um parametro
    powershell "Write-Host -ForegroundColor Red"  Digite "/?" para verificar os parametros disponiveis
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
echo Rede Wi-Fi gerada em: %dia%/%mes%/%ano% >> C:\batch\TXT\wifiHistory.txt
echo Nome da Rede Wi-fi: %wname% >> C:\batch\TXT\wifiHistory.txt
echo Senha da Rede Wi-fi: %pas% >> C:\batch\TXT\wifiHistory.txt
echo. >> C:\batch\TXT\wifiHistory.txt
echo =================================== >> C:\batch\TXT\wifiHistory.txt

GOTO kreate

:eof