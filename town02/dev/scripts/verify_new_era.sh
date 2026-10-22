#!/bin/bash
# verify_new_era.sh
# À exécuter dans le dossier du mod pour vérifier l'intégrité
# Usage: bash verify_new_era.sh
set -e
cd "$(dirname "$0")"

echo "============================================================"
echo "VÉRIFICATION NEW ERA : ABYSS TO ASCENSION"
echo "============================================================"

ERRORS=0
# Seuils resynchronises le 2026-07-30 (mesure sur le depot, commit 843256e).
# Les anciennes valeurs 68/248/51 dataient de la v0.4 : le script signalait
# 2 erreurs de comptage en permanence sur un depot pourtant sain.
#
# 2026-08-04 : 281 -> 277. Les Ruines Tordues n'ont plus AUCUN ground.
# Les quatre gardiens (Regice, Regirock, Registeel, Regigigas) attendent
# desormais dans des etages-arenes de la zone, au biome de leur labyrinthe,
# et leurs cinematiques se jouent en donjon. Grounds retires :
# cloven_ruins_regice, cloven_ruins_regirock, cloven_ruins_registeel,
# cloven_ruins_boss.
EXPECTED_GROUNDS=219
EXPECTED_TILESETS=735
EXPECTED_MUSIC=142

# 1. Ground maps
echo ""
echo "--- GROUND MAPS (.rsground) ---"
GMAPS=$(ls Data/Ground/*.rsground 2>/dev/null | wc -l)
if [ "$GMAPS" -eq "$EXPECTED_GROUNDS" ]; then
    echo "  ✓ $GMAPS/$EXPECTED_GROUNDS ground maps"
else
    echo "  ✗ $GMAPS/$EXPECTED_GROUNDS ground maps — COMPTE INATTENDU!"
    ERRORS=$((ERRORS+1))
fi

# Maps critiques pour Ch5 (ta sauvegarde)
for m in vast_steppe_entrance vast_steppe_midpoint vast_steppe_miniboss vast_steppe_guardian; do
    if [ -f "Data/Ground/${m}.rsground" ]; then
        SIZE=$(wc -c < "Data/Ground/${m}.rsground")
        echo "    ✓ ${m}.rsground ($SIZE o)"
    else
        echo "    ✗ ${m}.rsground MANQUANT"
        ERRORS=$((ERRORS+1))
    fi
done

# metano_town obligatoire
if [ -f "Data/Ground/metano_town.rsground" ]; then
    SIZE=$(wc -c < "Data/Ground/metano_town.rsground")
    if [ "$SIZE" -gt 30000000 ]; then
        echo "    ✓ metano_town.rsground ($SIZE o) — OK"
    else
        echo "    ✗ metano_town.rsground TROP PETIT ($SIZE o) — téléchargement incomplet !"
        ERRORS=$((ERRORS+1))
    fi
else
    echo "    ✗ metano_town.rsground MANQUANT"
    ERRORS=$((ERRORS+1))
fi

# 2. Tilesets
echo ""
echo "--- TILESETS (.tile) ---"
TILES=$(ls Content/Tile/*.tile 2>/dev/null | wc -l)
if [ "$TILES" -eq "$EXPECTED_TILESETS" ]; then
    echo "  ✓ $TILES/$EXPECTED_TILESETS tilesets"
else
    echo "  ✗ $TILES/$EXPECTED_TILESETS tilesets — COMPTE INATTENDU!"
    ERRORS=$((ERRORS+1))
fi

# Tilesets critiques Ch5
for t in VastSteppeMiniboss_Base VastSteppeMiniboss_Fringe VastSteppeMiniboss_Objects VastSteppeMiniboss_Objects_Under \
         VastSteppeGuardian_Base VastSteppeGuardian_Fringe VastSteppeGuardian_Objects VastSteppeGuardian_Objects_Under \
         SearingTunnelMiniboss_Base SearingTunnelMiniboss_Fringe SearingTunnelMiniboss_Rocks SearingTunnelMiniboss_Shadows \
         MountWindsweptMiniboss_Base MountWindsweptMiniboss_Fringe MountWindsweptMiniboss_Objects MountWindsweptMiniboss_Shadows \
         MountainPeak Spring_Cave_Pit Metano_Town_Base; do
    if [ ! -f "Content/Tile/${t}.tile" ]; then
        echo "    ✗ ${t}.tile MANQUANT"
        ERRORS=$((ERRORS+1))
    fi
done

# 3. Musiques
echo ""
echo "--- MUSIQUES (.ogg) ---"
MUSIC=$(ls Content/Music/*.ogg 2>/dev/null | wc -l)
if [ "$MUSIC" -eq "$EXPECTED_MUSIC" ]; then
    echo "  ✓ $MUSIC/$EXPECTED_MUSIC musiques"
else
    echo "  ✗ $MUSIC/$EXPECTED_MUSIC musiques — COMPTE INATTENDU!"
    ERRORS=$((ERRORS+1))
fi

# Team_Dazzling.ogg & Team_Dazzling_Theme.ogg
if [ -f "Content/Music/Team_Dazzling.ogg" ] && [ -f "Content/Music/Team_Dazzling_Theme.ogg" ]; then
    echo "    ✓ Team_Dazzling.ogg & Team_Dazzling_Theme.ogg présents"
else
    echo "    ✗ Team_Dazzling.ogg ou Team_Dazzling_Theme.ogg MANQUANT"
    ERRORS=$((ERRORS+1))
fi

# 4. Scripts Lua
echo ""
echo "--- SCRIPTS LUA ---"
LUA=$(find Data/Script/halcyon -name "*.lua" 2>/dev/null | wc -l)
echo "  $LUA fichiers Lua"

# Fichiers critiques
for f in Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua \
         Data/Script/halcyon/ground/metano_town/metano_town_ch_7.lua \
         Data/Script/halcyon/ground/metano_town/metano_town_ch_8.lua \
         Data/Script/halcyon/ground/metano_town/metano_town_ch_9.lua \
         Data/Script/halcyon/ground/metano_town/metano_town_ch_10.lua \
         Data/Script/halcyon/npc_routines.lua \
         Data/Script/halcyon/ground/metano_town/strings.resx \
         Data/Script/halcyon/scriptvars.lua; do
    if [ -f "$f" ]; then
        SIZE=$(wc -c < "$f")
        echo "    ✓ $(basename $f) ($SIZE o)"
    else
        echo "    ✗ $(basename $f) MANQUANT"
        ERRORS=$((ERRORS+1))
    fi
done

# 5. Cohérence des résumés de zones
# Le moteur valide les SegLoc contre Data/Zone/index.idx avant de charger le
# JSON complet. Ce contrôle cible les zones d'histoire dont la segmentation a
# changé récemment ; il évite de réintroduire un écran noir après un patch de
# segments ou de GroundMaps.
echo ""
echo "--- INDEX DES ZONES ---"
if python3 tools/verify_zone_index.py .; then
    echo "  ✓ résumés des zones d'histoire synchronisés"
else
    echo "  ✗ index.idx désynchronisé"
    ERRORS=$((ERRORS+1))
fi

# 6. Zones JSON
echo ""
echo "--- ZONES ---"
ZONES=$(ls Data/Zone/*.json 2>/dev/null | wc -l)
echo "  $ZONES zones JSON"

# 7. RÉSULTAT
echo ""
echo "============================================================"
if [ "$ERRORS" -eq 0 ]; then
    echo "✅ TOUT OK — $GMAPS maps, $TILES tilesets, $MUSIC musiques"
    echo "   Le mod devrait fonctionner."
else
    echo "❌ $ERRORS ERREUR(S) — Fichiers manquants"
    echo ""
    echo "SOLUTION:"
    echo "1. Télécharge le ZIP depuis GitHub:"
    echo "   https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4"
    echo "2. Dézippe dans un NOUVEAU dossier"
    echo "3. NE PAS faire git pull sur un ancien dossier"
    echo "4. Vérifie avec ce script: bash verify_new_era.sh"
fi
echo "============================================================"
