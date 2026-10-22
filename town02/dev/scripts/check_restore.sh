#!/bin/bash
# check_restore.sh — Protège contre la suppression silencieuse
# des gros fichiers par le sandbox Arena (~128 Mo limite).
# À exécuter EN DÉBUT DE CHAQUE SESSION, avant tout travail.
set -e
cd "$(dirname "$0")"
if [ ! -d .git ]; then
    git init -q
    git remote add origin https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4.git 2>/dev/null || \
        git remote set-url origin https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4.git
    git fetch --quiet origin main
    git update-ref refs/heads/main FETCH_HEAD
    git symbolic-ref HEAD refs/heads/main
    git config user.name "Arena Agent"
    git config user.email "agent@arena.local"
fi
CRITICAL_DIRS="Data/Ground/ Content/Music/ Content/Tile/"
CRITICAL_FILES="Data/Ground/metano_town.rsground Content/Music/Team_Dazzling.ogg"
MISSING=false
for f in $CRITICAL_FILES; do [ ! -f "$f" ] && MISSING=true && break; done
if $MISSING; then
    echo "⚠️  Fichiers critiques MANQUANTS — restauration depuis git..."
    git checkout HEAD -- $CRITICAL_DIRS
    echo "✅ Restauré."
fi
MAPS=$(ls Data/Ground/*.rsground 2>/dev/null | wc -l)
TILES=$(ls Content/Tile/*.tile 2>/dev/null | wc -l)
MUSIC=$(ls Content/Music/*.ogg 2>/dev/null | wc -l)
echo "🔒 CHECK: $MAPS/61 maps, $TILES/219 tiles, $MUSIC/41 music"
DELETED=$(git status --short | grep " D " | grep -E "Data/Ground|Content/Tile|Content/Music" | wc -l)
if [ "$DELETED" -gt 0 ]; then
    echo "🚫 $DELETED fichiers marqués deleted — NE PAS commit!"
fi
