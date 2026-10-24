#!/usr/bin/env bash
# ==============================================================================
# Création clé-en-main du fangame PMDO 0.8.12 :
#   « Pokémon Mystery Dungeon : Destiny »
#
# Structure & organisation 100 % identiques à Palikadude/Halcyon & meromoonmeri/town02 :
#   1) Base complète : meromoonmeri/town02 (main + Git LFS : 89 zones, Content/, Data/, Strings/)
#   2) Écran-Titre officiel « Pokémon Mystery Dungeon : Destiny » :
#      - Content/BG/Title_Screen_Background.dir (320×240, 24 poses animées en boucle SANS logo :
#        Crépuscule Doré -> Heure Bleue -> Soir & Nuit Étoilée Scintillante -> Retour fluide)
#      - Content/UI/Title.png (320×240 RGBA style Pokémon Super Mystery Dungeon : Pokémon +
#        Mystery Dungeon dégradé cyan->lavande + blason métallique DESTINY)
#      - Content/UI/Enter.png (74×11 RGBA pixel-art PRESS ENTER)
#      - Data/Script/halcyon/services/destiny_title_anim/init.lua (animation .dir temps réel sous TopMenu)
#   3) Consolidation intégrale des cartes :
#      - 38 scènes multicalques Studio (DST1 + MWE1..RUA1 + KYE1/KYA1 + Légendaires & Rescue Team)
#      - 84 cartes Guilde Treehouse PMD (12 salles modulaires × 6 ambiances + extérieurs Halcyon)
#      - Content/Tile/*.tile + Content/Tile/index.idx binaire (0 damier mauve)
#      - Data/Ground/*.rsground + Data/Script/halcyon/ground/<id>/init.lua + master_zone.json
#
# Usage :
#   ./CREER_FANGAME_PMD_DESTINY.sh                         # Crée le dossier local ~/Pokemon-Mystery-Dungeon-Destiny
#   ./CREER_FANGAME_PMD_DESTINY.sh --push meromoonmeri/Pokemon-Mystery-Dungeon-Destiny public
# ==============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSEMBLER="$REPO_DIR/source/consolidation_unifiee_town02/assembler_repo_unifie_town02.py"
if [ ! -f "$ASSEMBLER" ]; then
  ASSEMBLER="$REPO_DIR/assembler_repo_unifie_town02.py"
fi

MODE_PUSH=""
NOM_DEPOT_GITHUB=""
VISIBILITE="public"
DOSSIER_SORTIE="${HOME}/Pokemon-Mystery-Dungeon-Destiny"

if [ "${1:-}" = "--push" ]; then
  MODE_PUSH="1"
  NOM_DEPOT_GITHUB="${2:-meromoonmeri/Pokemon-Mystery-Dungeon-Destiny}"
  VISIBILITE="${3:-public}"
  DOSSIER_SORTIE="${4:-$HOME/Pokemon-Mystery-Dungeon-Destiny}"
elif [ -n "${1:-}" ]; then
  DOSSIER_SORTIE="$1"
fi

echo "=========================================================================="
echo " Assemblage Fangame PMDO 0.8.12 : Pokémon Mystery Dungeon : Destiny"
echo " Architecture : Palikadude/Halcyon + meromoonmeri/town02 + 122 Grounds"
echo " Dossier cible : $DOSSIER_SORTIE"
echo "=========================================================================="

for cmd in git python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Erreur : la commande '$cmd' est requise mais introuvable." >&2
    exit 1
  fi
done

if ! git lfs version >/dev/null 2>&1; then
  echo "Erreur : 'git-lfs' est requis (town02 stocke ses planches .tile sous Git LFS)." >&2
  exit 1
fi

EXTRA_ARGS=()
if [ -n "$MODE_PUSH" ]; then
  if ! command -v gh >/dev/null 2>&1; then
    echo "Erreur : 'gh' (GitHub CLI) est requis pour --push." >&2
    exit 1
  fi
  EXTRA_ARGS+=(--creer-et-pousser "$NOM_DEPOT_GITHUB" --visibilite "$VISIBILITE")
fi

python3 "$ASSEMBLER" \
  --sortie "$DOSSIER_SORTIE" \
  --nom-mod "Pokemon Mystery Dungeon: Destiny" \
  --installer-ecran-titre-destiny \
  --compiler-builds \
  "${EXTRA_ARGS[@]}"
