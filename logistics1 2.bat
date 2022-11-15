:: ====================================
::
:: Mukti Flora Rahman
::
:: 2019-01-29
:: logistics.bat
::
:: ====================================
::-- Function to check # of parameters to prgm --
:: ====================================
:parameters
@echo off >nul
setlocal enabledelayedexpansion
chcp 65001 >nul
set result=false
set filnamn=%1
set cpath=%cd%
set backup=%cpath%\%filnamn%.backup
set help1=%cd%\help1.txt
set help2=%cd%\help2.txt
set v1=%2
set v2=%3

if [%1] == [] goto :goodbye
if not exist "%1" goto :goodbye

:: Finns det argument eller inte?
if [%v1%] == [] (
	goto :info
)

if [%v1%] == [/backup] (
	echo.
	echo %filnamn% %backup%
	copy %filnamn% %backup%
	echo.
	goto :exitprogram
)

if [%v1%] == [/print] (
	echo.
	echo ID	Namn		Vikt	 L	 B	 H
	echo ===	=========	====	===	===	===
	for /f "delims=| tokens=1-6" %%G in (%filnamn%) do (
		echo	%%G	%%H	%%I	%%J	%%K	%%L
	)
	echo.
	goto :exitprogram
)

if [%v1%] == [/?] (
	echo.
	type %help1%
	echo.
	goto :exitprogram
)

:: if 2nd arg is NOT empty and 1st is sort
if [%v1%] == [/sort] (
	if [%v2%] == [i] call :sorti 999
	if [%v2%] == [n] call :sortn 999
	if [%v2%] == [v] call :sortv 999
	if [%v2%] == [l] call :sortl 999
	if [%v2%] == [h] call :sorth 999
	if [%v2%] == [b] call :sortb 999

	if [%v2%] == [?] (
		echo.
		type %help2%
		echo.
		goto :exitprogram
	)

	if [%v2%] == [] (
		echo.
		type %help2%
		echo.
		goto :exitprogram
	)
)

if not defined %v1% (
	goto :exitprogram
)

echo.
goto :goodbye
::====================================

::-- Funktion som visar start sidan av programmet --
::====================================
:info
cls
set radfyra=Välj ett av dessa för att gå vidare.
set innehall=Innehållet i vårt sortiment.
set ID=ID
set Namn=Namn
set Vikt=Vikt
set L=L
set B=B
set H=H
set rubrik=%ID%	%Namn%		%Vikt%	%L%	%B%	%H%
set valtext=Skriv in ditt val:
echo.
echo.
echo. Logistik och Logik!
echo.
echo. Välj ett av alternativen för att gå vidare.
echo.
echo.
echo. b  -  /backup	Genererar en säkerhetskopia av datafilen i samma katalog.
echo. p  -  /print	Skriver ut innehållet i datafilen.
echo. s  -  /sort	Sorterar och skriver ut innehållet i datafilen .
echo.			  i efter produktnummer     n efter namn
echo.			  v efter vikt							l efter längd
echo.			  b efter bredd							h efter höjd
echo. ?  -  Skriver ut den här hjälptexten.
echo. q  -  /quit	Avsluta programmet.
echo.
echo.
set /p ch1=%valtext%
echo.
echo.
if not defined ch1 (
goto :info
)
if %ch1%==b goto :backup
if %ch1%==p goto :print
if %ch1%==s goto :sort
if %ch1%==? goto :info
if %ch1%==q goto :exitprogram
echo Ogiltigt val, försök igen.
pause >nul
goto :info
endlocal
::====================================

::-- Funktion för att skapa backupfil --
::====================================
:backup
cls
echo.
echo. Nu kopieras vårt sortiment till
echo. %backup%....
echo.
timeout 2 >nul
echo.
copy %filnamn% %backup%
echo.
echo.
pause
goto :info
::====================================

::-- Funktion för att skriva ut innehåll om möbler --
::====================================
:print
cls
echo.
echo. %innehall%
echo. ----------------------------
echo.
echo.
echo %rubrik%
echo ----------------------------------------------------
	for /f "delims=| tokens=1-6" %%G in (sortiment.txt) do (
		echo	%%G	%%H	%%I	%%J	%%K	%%L
	)
echo.
echo.
pause
goto :info
::====================================

::-- Funktion som visar sorterings alternativ --
::
::====================================
:sort
setlocal
cls
echo.
echo.
echo.
echo. Här får du välja hur du vill sortera utskriften.
echo. Du kan sortera efter flera olika egenskaper.
echo. Sorterar och skriver ut innehållet i datafilen.
echo.
echo. i  -  efter produktnummer
echo. n  -  efter namn
echo. v  -  efter vikt
echo. l  -  efter längd
echo. b  -  efter bredd
echo. h  -  efter höjd
echo. ?  -  Skriver ut den här hjälptexten.
echo. q  -  Återvänd till förstasidan.
echo.
echo.
set /p ch2= %valtext%
echo.
echo.
if not defined ch2 (
goto :sort
)
	if %ch2%==i goto :sort%ch2%
	if %ch2%==n goto :sort%ch2%
	if %ch2%==v goto :sort%ch2%
	if %ch2%==l goto :sort%ch2%
	if %ch2%==b goto :sort%ch2%
	if %ch2%==h goto :sort%ch2%
	if %ch2%==? goto :sort
	if %ch2%==q goto :info
echo.
echo Ogiltigt val, försök igen.
pause >nul
ch2=z
endlocal
goto :sort
::====================================


::-- All subfunctions to make sorts --
::====================================
:sorti
cls
setlocal
echo.
echo.Sorterat efter ID
echo.
echo ID	Namn		Vikt	 L	 B	 H
echo ===	=========	====	===	===	===
for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
	echo	%%G	%%H	%%I	%%J	%%K	%%L >>sort.txt
)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.

:: if function was called with arg 999, then exit
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::====================================
:sortn
cls
echo.
echo.Sorterat efter Namn
echo.
echo Namn		ID	Vikt	 L	 B	 H
echo =========	===	====	===	===	===
for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
	echo	%%H	%%G	%%I	%%J	%%K	%%L >>sort.txt
)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::====================================
:sortv
cls
echo.
echo.Sorterat efter Vikt (i gram)
echo.
echo Vikt	ID	Namn		L	 B	 H
echo ===	===	=========	===	===	===
for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
	echo	%%I	%%G	%%H	%%J	%%K	%%L >>sort.txt
)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::====================================
:sortl
cls
echo.
echo.Sorterat efter Längd (i cm)
echo.
echo L	ID	Namn		Vikt	 B	 H
echo ===	===	=========	====	===	===
for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
	echo	%%J	%%G	%%H	%%I	%%K	%%L >>sort.txt
)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::====================================
:sortb
cls
echo.
echo.Sorterat efter Bredd (i cm)
echo.
echo B	ID	Namn		Vikt	 L	 H
echo ===	===	=========	====	===	===
	for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
		echo	%%K	%%G	%%H	%%I	%%J	%%L >>sort.txt
	)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::====================================
:sorth
cls
echo.
echo.Sorterat efter Höjd (i cm)
echo.
echo H	ID	Namn		Vikt	 L	 B
echo ===	===	=========	====	===	===
	for /f "skip=1 delims=| tokens=1-6" %%G in (sortiment.txt) do (
		echo	%%L	%%G	%%H	%%I	%%J	%%K >>sort.txt
	)
sort sort.txt /o sort.txt
type sort.txt
del sort.txt
echo.
if [%1] == [999] goto :exitprogram
pause
goto :sort
::====================================

::-- Nu är programmet slut --
::====================================
:exitprogram
echo.
goto :eof
::====================================
