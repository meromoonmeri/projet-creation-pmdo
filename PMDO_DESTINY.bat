@echo off
REM PMD Destiny - moteur PMDO avec notre quest par defaut
REM Adapter le chemin ci-dessous a votre installation PMDO.
cd /d "%~dp0.cache\pmdo-runtime\engine\PMDO"
PMDO.exe -quest quest_pmd_destiny %*
