#!/usr/bin/env bash
# ==============================================================================
# Création automatique du dépôt GitHub « PROJET PMD » (meromoonmeri/PROJET-PMD)
# Basé sur meromoonmeri/town02 et structuré 100 % comme Palikadude/Halcyon :
#   1) Base : meromoonmeri/town02 (main + Git LFS)
#   2) Cartes : meromoonmeri/projet-creation-pmdo (arena/637b0828-projet-creation-pmdo)
#   3) Guilde : meromoonmeri/guilde-treehouse-pmd (12 salles modulaires × 6 ambiances = 84 grounds Halcyon)
#   4) Placement Halcyon complet :
#      - Mod.xml (<Name>PROJET PMD</Name>, <Namespace>halcyon</Namespace>)
#      - Content/Tile/*.tile + Content/Tile/index.idx (binaire TileGuide)
#      - Data/Ground/*.rsground (AssetName synchronisé + BOM UTF-8)
#      - Data/Script/halcyon/ground/<id>/init.lua (relocalisation + transitions PMD)
#      - Data/Zone/master_zone.json & Data/Zone/index.idx (indices 0..390 intacts + ajouts)
#
# Prérequis sur votre machine : git, git-lfs, gh (connecté : `gh auth status`), python3 + Pillow
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOM_DEPOT_GITHUB="${1:-meromoonmeri/PROJET-PMD}"
VISIBILITE="${2:-public}"
DOSSIER_SORTIE="${3:-$HOME/PROJET-PMD}"

echo "=================================================================="
echo " Assemblage Halcyon / town02 -> PROJET PMD ($NOM_DEPOT_GITHUB)"
echo " Dossier local : $DOSSIER_SORTIE"
echo "=================================================================="

for cmd in git gh python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Erreur : la commande '$cmd' est requise mais introuvable." >&2
    exit 1
  fi
done

if ! git lfs version >/dev/null 2>&1; then
  echo "Erreur : 'git-lfs' est requis (town02 stocke ses 2 091 .tile sous Git LFS)." >&2
  exit 1
fi

python3 "$SCRIPT_DIR/assembler_repo_unifie_town02.py" \
  --sortie "$DOSSIER_SORTIE" \
  --nom-mod "PROJET PMD" \
  --compiler-builds \
  --creer-et-pousser "$NOM_DEPOT_GITHUB" \
  --visibilite "$VISIBILITE"
