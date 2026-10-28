#!/bin/sh
# PMD Destiny — moteur PMDO avec notre quest par défaut
# (généré par OUTILS/installer_moteur_pmdo_destiny.py)
cd "$(dirname "$0")/.cache/pmdo-runtime/engine/PMDO" && exec ./PMDO -quest quest_pmd_destiny "$@"
