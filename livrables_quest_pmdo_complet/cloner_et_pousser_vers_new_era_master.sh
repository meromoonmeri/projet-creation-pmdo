#!/usr/bin/env bash
set -euo pipefail
echo "[1/3] Clonage complet sans Git LFS (3 637 cartes, 37 370 fichiers)..."
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git NEW-ERA-MASTER-LOCAL
cd NEW-ERA-MASTER-LOCAL
git checkout -B main
git remote set-url origin https://github.com/meromoonmeri/NEW-ERA-MASTER.git
echo "[2/3] Poussée vers https://github.com/meromoonmeri/NEW-ERA-MASTER.git (main)..."
git push -u -f origin main
echo "[3/3] Terminé ! Copiez town02 + town02_tiles_pack_{a,b,c} dans PMDO/MODS/."
