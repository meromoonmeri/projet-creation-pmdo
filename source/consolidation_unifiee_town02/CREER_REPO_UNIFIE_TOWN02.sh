#!/usr/bin/env bash
# Alias rétrocompatible vers CREER_PROJET_PMD.sh (dépôt unifié « PROJET PMD » façon Halcyon/town02)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/CREER_PROJET_PMD.sh" "$@"
