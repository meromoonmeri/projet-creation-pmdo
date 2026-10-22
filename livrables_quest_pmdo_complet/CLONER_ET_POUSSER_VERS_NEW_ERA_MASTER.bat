@echo off
chcp 65001 >nul
echo ============================================================================
echo  QUEST PMDO 0.8.12 - DOUBLON INTEGRAL TOWN02 SANS GIT LFS (3 637 MAPS)
echo ============================================================================
echo [1/3] Clonage complet sans Git LFS depuis le tag verifie...
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git NEW-ERA-MASTER-LOCAL
if errorlevel 1 (
    echo ERREUR lors du clonage. Verifiez votre connexion internet et Git.
    pause
    exit /b 1
)
cd NEW-ERA-MASTER-LOCAL
git checkout -B main
echo.
echo [2/3] Dossier pret pour PMDO 0.8.12 !
echo       Copiez simplement les 4 dossiers (town02, town02_tiles_pack_a, b, c) dans PMDO\MODS\ !
echo.
echo [3/3] Poussee automatique vers https://github.com/meromoonmeri/NEW-ERA-MASTER.git ...
git remote set-url origin https://github.com/meromoonmeri/NEW-ERA-MASTER.git
git push -u -f origin main
echo.
echo TERMINE ! Votre depot https://github.com/meromoonmeri/NEW-ERA-MASTER est a jour sans Git LFS !
pause
