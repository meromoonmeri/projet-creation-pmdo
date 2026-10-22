# ADD-ON « Réseau des Anciens Chemins » — 34 donjons pmd-red reconstruits (2026-07-27)

Recréation INTÉGRALE de la structure de progression des donjons d'exploration
du jeu d'origine (IDs 0-43 de `include/constants/dungeon.h`), d'après la
décompilation pret/pmd-red :
- **Étages EXACTS** : `src/dungeon_info.c` `sDungeonFloorCount[]` (Tiny Woods 4,
  Sky Tower 26+10, Silver Trench/Western/Wish/Buried/Joyous-classe 100…).
- **Enchaînements multi-parties fusionnés en zones à relais** : Mt. Thunder+Peak,
  Mt. Blaze+Peak, Frosty Forest+Grotto, Mt. Freeze+Peak, Magma Cavern+Pit,
  Sky Tower+Summit → segment 0 → **Station-Relais** (Terminal de Sauvegarde
  Kangourex + réserve, patron canonique) → segment cime.
- **Add-on NEUTRE** : préfixe `new_era_zone_XX`, zéro écrasement, déblocage
  Livre II (ch11+) ou fin d'histoire.
- **Modernisation PMDO** : générateurs RangeDict/GridFloor (fini les tuiles GBA),
  autotiles DumpAsset thématiques, tables de spawn **Gén. 4-9** par thème
  élémentaire (11 pools de 12-14 espèces vérifiées dans MonsterFeature),
  niveaux recalés sur la courbe New Era, musiques existantes.
- **Grounds** : entrances = nos 32 imports pmd-red 1:1 réutilisés (foret_tendre_oree,
  parvis_celeste, fosse_ardente…), relais = 6 stations générées, fins = arènes 1:1.

## Reskin textuel « New Era » (IDs 0-43)

| ID | Origine | Nom New Era | Étages | Niv | Relais |
|---|---|---|---|---|---|
| 0 | Tiny Woods | Lisière du Premier Signal | 4 | 5 | — |
| 1 | Thunderwave Cave | Conduit à Ondes Rémanentes | 6 | 6 | — |
| 2 | Mt. Steel | Pylône du Vieux Fer | 10 | 8 | — |
| 3 | Sinister Woods | Taillis des Interférences | 14 | 10 | — |
| 4 | Silent Chasm | Faille du Silence Long | 10 | 12 | — |
| 5 | Mt. Thunder (+Peak) | Antenne du Grand Orage | 11+4 | 14 | Station de la Foudre Basse |
| 7 | Great Canyon | Canyon des Voix Éteintes | 13 | 16 | — |
| 8 | Lapis Cave | Veine d'Azur Profond | 15 | 18 | — |
| 9 | Mt. Blaze (+Peak) | Cheminée du Réacteur Rouge | 13+4 | 20 | Station du Manteau Ardent |
| 11 | Frosty Forest (+Grotto) | Forêt du Givre Statique | 10+6 | 22 | Station du Point de Rosée |
| 13 | Mt. Freeze (+Peak) | Aiguille du Zéro Absolu | 16+6 | 24 | Station du Grand Blanc |
| 15 | Magma Cavern (+Pit) | Cœur de la Fournaise-Mère | 24+4 | 28 | Station de Contrôle du Noyau |
| 17 | Sky Tower (+Summit) | Tour du Ciel Fracturé | 26+10 | 32 | Station du Dernier Palier |
| 19 | Stormy Sea | Mer des Tempêtes Sans Fin | 41 | 36 | — |
| 20 | Silver Trench | Fosse d'Argent Abyssale | 100 | 45 | — |
| 21 | Meteor Cave | Berceau du Météore | 21 | 40 | — |
| 23 | Western Cave | Caverne du Silence Occidental | 100 | 50 | — |
| 26 | Wish Cave | Puits des Vœux Fossiles | 100 | 48 | — |
| 27 | Buried Relic | Relique Ensevelie | 100 | 46 | — |
| 28 | Pitfall Valley | Vallée des Chutes Perdues | 26 | 38 | — |
| 29 | Northern Range | Crêtes de la Boussole Nord | 26 | 39 | — |
| 31 | Desert Region | Région des Sables Morts | 21 | 37 | — |
| 32 | Southern Cavern | Caverne du Méridien Sud | 51 | 42 | — |
| 33 | Wyvern Hill | Colline des Vouivres | 31 | 43 | — |
| 34 | Fiery Field | Champ de Cendres Vives | 31 | 44 | — |
| 35 | Northwind Field | Champ du Vent Polaire | 31 | 45 | — |
| 36 | Solar Cave | Grotte du Soleil Enfoui | 21 | 41 | — |
| 37 | Lightning Field | Champ des Cent Éclairs | 31 | 46 | — |
| 38 | Darknight Relic | Relique de la Nuit Noire | 16 | 44 | — |
| 39 | Wondrous Sea | Mer des Prodiges | 13 | 42 | — |
| 40 | Murky Cave | Boyau des Eaux Troubles | 20 | 47 | — |
| 41 | Grand Sea | Grand Large Oublié | 31 | 48 | — |
| 42 | Uproar Forest | Forêt du Vacarme | 11 | 40 | — |
| 43 | Oddity Cave | Grotte des Anomalies | 16 | 49 | — |

## Lexique du reskin techno-mystique
- Statue Kangourex → **Terminal de Sauvegarde** (même script natif :
  `GeneralFunctions.Kangashkhan_Rock_Interact` = sauvegarde + réserve/coffres).
- Relais → **Station** (…de Contrôle du Noyau, du Dernier Palier, etc.).
- Les IDs 6/10/12/14/16/18 (cimes) sont fusionnés dans leur zone mère ;
  22/24/25/30 = doublons/BOSS internes du moteur GBA, exclus comme dans
  l'inventaire d'origine.

## Fichiers générés
34 × `Data/Zone/new_era_zone_XX.json` + 34 scripts de zone + 6 relais
(.rsground + init.lua : North=segment cime, South=fin de run propre,
Kangourex natif) + index.idx (+34) + déblocage OnUpgrade (ch11+/StoryCompleted).
Audit : 34/34 ranges d'étages exacts, 0 réf. cassée, niveaux plafonnés,
6/6 relais spatialement valides, Lua 40/40 OK.
