# canonical-dungeon — validation runtime par étage

Outil : `dev/tools/canonical_dungeon.py` (manifest | test | validate | report),
correcteur de convergence : `dev/tools/canonical_dungeon_fix.py`,
campagne par lots : `dev/tools/canonical_dungeon_batch.sh`.

## Campagne 2026-08-25 — 89 zones, 1848 étages, moteur PMDO 0.8.12 réel

Le service moteur `mapgen_validator` exécute la génération RogueElements
réelle (`structure:GetMap(context)`) et la traversabilité pour CHAQUE étage.
Preuves brutes : mapgen_*.jsonl. Matrice agrégée : matrix.json.

**État final : 89/89 zones CANONICAL_RUNTIME_PASS — 1848 étages générés et
vérifiés dans le moteur réel (multi-itérations, agrégation stricte : le pire
cas gagne).** Aucun faux PASS : chaque verdict provient d'une exécution
`GetMap` réelle journalisée dans les JSONL commités.

Contre-épreuves d'autorité (zones du JEU DE BASE, jamais modifiées, testées
avec le même validateur) : trickster_woods 14/14, faultline_ridge 10/10,
champions_road 29/29. Deux règles du validateur ont été corrigées quand le
canon lui-même les mettait en échec (parcours torique `Wrap`, connexité au
niveau tuiles, contrat `twosides`) — l'autorité est le moteur, pas nos
suppositions.

Les corrections de convergence sont exclusivement des paramètres
RogueElements attestés (jeu de base DumpAsset ou zones du mod déjà validées
runtime) : jamais de map statique, jamais de seed de production. Les étages
restent procéduraux et re-tirés à chaque entrée.

## Vrais bugs identifiés PAR le moteur et corrigés à la racine

1. **Autotiles inexistants** (KeyNotFoundException MapTextureStep) :
   chasm_cave/dark_hill/dusk_forest/sealed_ruin_pit/spiritomb_room
   référençaient `<biome>_floor` au lieu des autotiles canoniques du jeu
   de base (`<biome>_1_floor`…). Re-mappés (114 références).
2. **PickerSpawner malformés** (NRE PickerSpawner.ToString) : 45 steps
   avec `Spawns` + EffectTile `ID:""` au lieu du schéma canonique
   `Picker`/LoopedRand + `tile_wonder` (forme du jeu de base). Réparés.
3. **RoomGen non canoniques** (0 salle générée) : 62 RoomGen avec
   `RoomTerrain`/`Size`/`Resizable` (schéma inexistant en 0.8.12) au lieu
   de `Width`/`Height` RandRange. Normalisés.
4. **TerrainHallBrush avec terrain inexistant `hall`** (SIGABRT
   TileBlocked) : 45 pinceaux -> DefaultHallBrush canonique.
5. **.rsmap corrompus** (clé `""` au lieu de `$type`) :
   mount_windswept_guardian, frosty_forest_summit, mt_blaze_summit,
   vast_steppe_guardian, wish_cave_jirachi. Réparés.
6. **GetPlayerPartyMember crash sur save vierge** : le validateur crée
   désormais l'équipe de test canonique (turtwig/piplup/growlithe/
   zigzagoon, mêmes espèces que le save debug du projet).
7. **Escaliers `stairs_exit*` non reconnus** + **vaults scellés**
   (sealed_block/sealed_door) comptés comme cellules isolées : le
   validateur les traite selon la sémantique réelle du jeu.
8. **RandRange Min>Max** introduits par une passe de durcissement (57)
   puis interdits par construction dans le correcteur.

Les 12 donjons protégés n'ont reçu AUCUNE modification.

## Reproduire

    bash dev/tools/canonical_dungeon_batch.sh 1
    python3 dev/tools/canonical_dungeon.py validate all
    python3 dev/tools/canonical_dungeon.py report
