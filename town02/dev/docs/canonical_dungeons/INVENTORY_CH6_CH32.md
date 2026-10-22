# Inventaire canonique Ch.6–32 — vérification au 2026-08-22

Ce fichier remplace l'inventaire `docs/canonical_dungeons/INVENTORY_CH6_CH32.md`
mentionné dans la commande : **ce chemin n'existait pas dans le dépôt**. Les
chiffres annoncés ont donc été recomptés directement sur l'arbre de travail
(commit de base `230800fb`, « Clear chapter 6-32 dungeon substitute data »).

## Chiffres annoncés vs chiffres mesurés

| Élément annoncé | Mesure réelle | Verdict |
|---|---|---|
| 27 routes principales Ch.6–32 | 27 chapitres (6→32) référencés dans `docs/inventaire_donjons.md` ; **aucune** zone principale Ch.6+ n'existe encore dans `Data/Zone` (purge du commit de base) | ✅ compte des chapitres exact, ❌ « routes » **non implémentées** |
| 51 donjons PMD Red | `docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md` : « 51 donjons d'histoire importables (49 à créer + 2 faits) » | ✅ cohérent (planning, pas contenu) |
| 245 Grounds Red archivés | `RESERVE/red_grounds` = **245** fichiers, `RESERVE/red_tiles` = 245 | ✅ exact |
| 23 packages DTEF importés | `Data/AutoTile` = **11 AutoTileData** ; un seul **triplet complet** floor/wall/secondary appartenant au mod : `sinister_woods_b41`. Les 8 `apricorn_grove_*` sont des variantes de couleur, pas des triplets DTEF | ❌ **corrigé : 1 package DTEF importé par le mod, pas 23** |
| (corrigé 2026-08-23) tilesets utilisables | **74 triplets complets** au total après scan exhaustif incluant les archives `RESERVE/` (157 tilesets attestés par les données actives + 156 attestés par les archives converties). Correspondances canoniques retrouvées : `mt_thunder`, `murky_cave`, `lightning_field`, `silver_trench_3`, `wyvern_hill`, `buried_relic_1`, `wish_cave_1`, `sky_tower`, `northern_desert_1`, `surrounded_sea`, `craggy_coast`, `hidden_highland`, `tiny_meadow`… | ✅ **le blocage tileset tombe de 13 donjons à 1** |
| (ancienne mesure) tilesets utilisables | 49 triplets de biome fournis par PMDO et déjà référencés par des zones/maps/grounds livrés (`treeshroud_forest_1`, `magma_cavern_2`, `crystal_cave_1/2`, `western_cave_1/2`, `mt_blaze`, `mt_freeze`, `frosty_forest`, `lapis_cave`, `sealed_ruin`, `spacial_rift_1/2`, `stormy_sea_1`, `quicksand_pit`, `purity_forest_4/6/7/8`, `world_abyss_2`, …) | ✅ **découverte : la couverture réelle est de 50 triplets, pas 1** |

Autres mesures utiles :

| Ressource | Compte |
|---|---|
| `Data/Zone/*.json` | 44 (43 avant génération + `gloomy_forest`) |
| `Data/Ground/*.rsground` | 419 |
| `Data/Map/*.rsmap` | 60 |
| `Data/Item/*.json` | 239 |
| `RESERVE/zones` | 199 |
| `RESERVE/sky_grounds` | 467 |

## Conséquences pour le Dungeon Builder

1. **Le tileset est le goulot d'étranglement réel**, pas la génération. Un donjon
   ne peut être généré avec son identité visuelle propre que si son triplet
   `<biome>_floor` / `_wall` / `_secondary` est soit importé dans
   `Data/AutoTile` (DTEF propre au mod), soit déjà référencé par des données
   livrées (tileset de base PMDO). `dungeon_builder audit` liste les deux
   familles, et `check_tileset_uniqueness()` **interdit à deux donjons de
   partager le même triplet** sans champ `dtef.justification` explicite.
   `tools/dungeon_builder.py audit` liste à tout moment les packages
   disponibles, et `generate` **refuse** d'écrire une zone dont le tileset
   n'est pas importé (aucun partage aveugle de tileset entre deux donjons).
2. Sinister Woods reste le donjon de référence validé de bout en bout
   (`sinister_woods_b41` importé, midpoint produit, Ground de fin canonique
   `sinister_woods_clearing` présent). Les 49 triplets de base permettent
   d'attribuer un tileset distinct par biome aux donjons suivants, mais chaque
   attribution doit être décidée donjon par donjon (biome canonique) et non
   recopiée.
3. Les donjons hors périmètre (Aegis Cave / `cloven_ruins`) ne sont pas
   touchés : aucun fichier de ces zones n'est modifié, et un test de
   non-régression le vérifie.

## Périmètre restant (à traiter donjon par donjon)

Pour chaque donjon Ch.6–32, l'ordre de travail imposé par cet inventaire est :

1. importer/retexturer le package DTEF du biome (pipeline existant) ;
2. écrire `DungeonDefs/canonical/<donjon>.json` (source Bulbapedia adaptée) ;
3. `dungeon_builder preview` puis `validate` ;
4. vérifier le Ground de fin : s'il existe, le combat final s'y déroule ; sinon
   créer le `.rsmap` d'arène dédié **puis** le convertir en Ground ;
5. `dungeon_builder generate` + rapport.
