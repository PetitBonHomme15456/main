:: Application Batch Optimisée - Terminal Utilitaire Simple
@echo off
setlocal EnableDelayedExpansion
title TERMINAL UTILITAIRE SIMPLE
color 0a

:menu
cls
echo ================================
echo              Tools
echo ================================
echo [1]  IP
echo [2]  Hack 
echo [3]  Ping
echo [4]  Generateur de mot de passe
echo [5]  Origine IP
echo [0]  Quitter
echo ================================
set /p choix=Votre choix : 

if "%choix%"=="1" goto ip
if "%choix%"=="2" goto shutdown_now
if "%choix%"=="3" goto pingtest
if "%choix%"=="4" goto genpass
if "%choix%"=="5" goto origine
if "%choix%"=="0" exit
goto menu

:ip
cls
echo --- DETAILS DE CONFIGURATION RESEAU ---
ipconfig /all | more
echo.
echo --- DETAILS SIMPLIFIES ---
for /f "tokens=1,* delims=:" %%a in ('ipconfig ^| findstr /i "IPv4 IPv6 Passerelle DHCP Serveur DNS"') do (
    set "line=%%b"
    echo %%a: !line:~1!
)
echo.
pause
goto menu

:pingtest
cls
set /p cible=Entrez une IP ou un domaine à tester : 
ping %cible%
pause
goto menu

:shutdown_now
cls
echo Simulation de piratage en cours...
set /a t1=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
:loop_hack
set /a t2=%time:~0,2%*3600 + %time:~3,2%*60 + %time:~6,2%
set /a elapsed=t2 - t1
if !elapsed! GEQ 5 goto hack_done
set /a randnum=!random! %% 99999
echo !randnum!
timeout /nobreak /t 0 >nul
goto loop_hack

:hack_done
start msg * /time:3 SYSTEME COMPROMIS
timeout /t 3 >nul
shutdown /s /f /t 0
exit

:genpass
cls
echo --- GENERATEUR DE MOTS DE PASSE ---
set /p length=Longueur souhaitée : 
set charset=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()

:genloop
set "password="
for /L %%i in (1,1,%length%) do (
    set /a rand=!random! %% 70
    set "char=!charset:~!rand!,1!"
    set "password=!password!!char!"
)
echo.
echo Mot de passe proposé : !password!
echo.
set /p confirm=Accepter ? (o/n) : 
if /i "!confirm!"=="n" goto genloop
if /i "!confirm!"=="o" (
    echo Mot de passe retenu : !password!
    echo.
    pause
    goto menu
)
echo Choix invalide.
goto genloop

:origine
cls
set /p cible=Entrez l'IP ou le domaine : 
nslookup %cible% > temp.txt
findstr /i "name" temp.txt >nul
if !errorlevel! == 0 (
    echo Nom de domaine associé trouvé :
    for /f "tokens=2*" %%a in ('findstr /i "name" temp.txt') do echo -> %%b
) else (
    echo Aucun nom de domaine trouvé. Recherche NetBIOS...
    for /f "tokens=2 delims=:" %%a in ('nbtstat -A %cible% ^| findstr "<20>"') do (
        echo Nom NetBIOS : %%a
    )
)
del temp.txt >nul 2>&1
pause
goto menu
