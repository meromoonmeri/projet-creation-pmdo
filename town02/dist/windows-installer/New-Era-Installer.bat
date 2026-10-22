@ECHO OFF
REM ============================================================================
REM  New Era: Abyss to Ascension - Windows installer bootstrap
REM
REM  Double-click this .bat to install the mod. It reassembles the split
REM  parts into New-Era-Setup.exe (a real 7-Zip SFX self-extracting Windows
REM  installer, ~365 MiB), verifies its SHA-256, then launches it. The .exe
REM  itself is a native GUI installer with progress bar, install-path
REM  chooser, cancel/finish dialogs — exactly like a fangame installer.
REM
REM  What happens:
REM    1. copy /b concatenates New-Era-Setup.exe.part_001..005 into
REM       New-Era-Setup.exe in the same folder.
REM    2. Windows built-in certutil verifies SHA-256 matches the expected
REM       value stored below; on mismatch the .exe is deleted and the
REM       user is asked to redownload.
REM    3. New-Era-Setup.exe is launched. It shows a GUI with:
REM       - a "Extract to:" dialog defaulting to PMDO/MODS
REM       - a progress bar during extraction
REM       - a completion message
REM
REM  No PowerShell required, no third-party runtime; only the copy /b and
REM  certutil shipped with Windows since Windows 7.
REM ============================================================================

SETLOCAL EnableExtensions

SET "SCRIPT_DIR=%~dp0"
IF "%SCRIPT_DIR:~-1%"=="\" SET "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

SET "EXE_OUT=%SCRIPT_DIR%\New-Era-Setup.exe"
SET "EXPECTED_SHA=d172e45f0b1dfe3899c6b4615e88fc20032fa9508e9f024e9b46f3909a94edfb"

REM Check parts exist
FOR %%p IN (001 002 003 004 005) DO (
    IF NOT EXIST "%SCRIPT_DIR%\New-Era-Setup.exe.part_%%p" (
        ECHO.
        ECHO [ERROR] Part manquante : New-Era-Setup.exe.part_%%p
        ECHO         Assurez-vous d'avoir telecharge le dossier
        ECHO         dist\windows-installer\ en entier depuis GitHub.
        PAUSE
        EXIT /B 1
    )
)

REM Reassemble
IF EXIST "%EXE_OUT%" DEL /Q "%EXE_OUT%"
ECHO Reassemblage de New-Era-Setup.exe (5 parts, ~365 MiB) ...
copy /b ^
    "%SCRIPT_DIR%\New-Era-Setup.exe.part_001" ^
  + "%SCRIPT_DIR%\New-Era-Setup.exe.part_002" ^
  + "%SCRIPT_DIR%\New-Era-Setup.exe.part_003" ^
  + "%SCRIPT_DIR%\New-Era-Setup.exe.part_004" ^
  + "%SCRIPT_DIR%\New-Era-Setup.exe.part_005" ^
    "%EXE_OUT%" >NUL

IF NOT EXIST "%EXE_OUT%" (
    ECHO [ERROR] Reassemblage echoue.
    PAUSE
    EXIT /B 2
)

REM Verify SHA-256 using certutil (Windows built-in since Windows 7)
ECHO Verification SHA-256 ...
FOR /F "skip=1 delims=" %%h IN (
    'certutil -hashfile "%EXE_OUT%" SHA256 ^| findstr /v ":"'
) DO (
    SET "ACTUAL_SHA=%%h"
    GOTO :got_hash
)
:got_hash

REM Trim spaces and lowercase
SET "ACTUAL_SHA=%ACTUAL_SHA: =%"
FOR %%A IN ("%ACTUAL_SHA%") DO SET "ACTUAL_SHA=%%~A"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:A=a%%"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:B=b%%"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:C=c%%"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:D=d%%"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:E=e%%"
CALL SET "ACTUAL_SHA=%%ACTUAL_SHA:F=f%%"

IF /I NOT "%ACTUAL_SHA%"=="%EXPECTED_SHA%" (
    ECHO.
    ECHO [ERROR] SHA-256 mismatch !
    ECHO    Attendu  : %EXPECTED_SHA%
    ECHO    Obtenu   : %ACTUAL_SHA%
    ECHO    Une part est corrompue. Retelechargez le dossier
    ECHO    dist\windows-installer\ depuis GitHub.
    DEL /Q "%EXE_OUT%"
    PAUSE
    EXIT /B 3
)

ECHO SHA-256 OK : %ACTUAL_SHA%
ECHO.
ECHO Lancement de New-Era-Setup.exe (fenetre d'installation)...

REM Launch the SFX installer; it takes over from here with its native GUI.
START "" "%EXE_OUT%"

ENDLOCAL & EXIT /B 0
