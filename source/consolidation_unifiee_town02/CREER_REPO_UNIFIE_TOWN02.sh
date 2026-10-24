#!/usr/bin/env bash
# ==============================================================================
# Création automatique en 1 commande du dépôt GitHub unifié :
#   town02 + toutes les branches de projet-creation-pmdo + Guilde Treehouse PMD
#
# Usage :
#   bash source/consolidation_unifiee_town02/CREER_REPO_UNIFIE_TOWN02.sh [nom-du-repo] [--public|--private]
#
# Exemple :
#   bash source/consolidation_unifiee_town02/CREER_REPO_UNIFIE_TOWN02.sh town02-all-maps-pmdo --public
# ==============================================================================
set -euo pipefail

REPO_NAME="${1:-town02-all-maps-pmdo}"
VISIBILITY_FLAG="${2:---public}"
VISIBILITY="${VISIBILITY_FLAG#--}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${HOME}/${REPO_NAME}-build"

echo "======================================================================"
echo " Assemblage du dépôt unifié : meromoonmeri/${REPO_NAME} (${VISIBILITY})"
echo " Dossier de construction    : ${WORK_DIR}"
echo "======================================================================"

for cmd in git gh python3 tar; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "[ERREUR] Commande requise introuvable : ${cmd}" >&2
    exit 1
  fi
done

if ! git lfs version >/dev/null 2>&1; then
  echo "[ERREUR] git-lfs est requis pour matérialiser les .rsground de town02 (>200 Mo)." >&2
  echo "         Installez-le via : sudo apt install git-lfs  OU  brew install git-lfs" >&2
  exit 1
fi

echo "[0/4] Vérification de la session GitHub CLI (gh)..."
gh auth status

VENV_DIR="${WORK_DIR}_venv"
if [ ! -x "${VENV_DIR}/bin/python" ]; then
  echo "[0/4] Préparation de l'environnement Python dédié (Pillow + NumPy)..."
  python3 -m venv "${VENV_DIR}"
  "${VENV_DIR}/bin/pip" install --quiet --upgrade pip pillow numpy
fi

"${VENV_DIR}/bin/python" "${SCRIPT_DIR}/assembler_repo_unifie_town02.py" \
  --sortie "${WORK_DIR}" \
  --compiler-builds \
  --creer-et-pousser "meromoonmeri/${REPO_NAME}" \
  --visibilite "${VISIBILITY}"

echo "======================================================================"
echo " Terminé ! Votre dépôt unifié complet est disponible sur :"
echo "   https://github.com/meromoonmeri/${REPO_NAME}"
echo "======================================================================"
