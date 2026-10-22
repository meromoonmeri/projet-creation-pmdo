# Aegis Cave — conversion NON canonique (mise en réserve)

**NE PAS RÉUTILISER CES CARTES POUR cloven_ruins.**

Les 19 `.rsground` + 19 planches `.tile` ici ont été produites par
`tools/convert_sky_aegis.py` (commit 2180945) à partir des fichiers
`files/MAP_BG/d54…d61` de pret/pmd-sky, en supposant que
« numéro de donjon == numéro de groupe de cartes » (DUNGEON_ICE_AEGIS_CAVE=54
→ d54p11a…). Cette hypothèse est FAUSSE, vérifié le 2026-08-07 sur les
scènes SSB du jeu lui-même :

| Groupe MAP_BG | Identité réelle (preuve SSB) |
|---|---|
| d50-d53 | Épisodes Spéciaux 5 (Falaises Spatiales, Mont de Glace Sombre, Forêt de Givre, Mont de Glace Immense) — scènes n08/n09, BGM_SPACIAL_CLIFFS, combat Primal Dialga sur d53p41a/b |
| d54p11a/p31a/p32a | **Jungle Méridionale** (Épisode Spécial 4, Team Charm) — n06a0201/0301/0401/0501/0502 : « Nous sommes sorties de la Jungle Méridionale », BGM_SOUTHERN_JUNGLE / BGM_ILLUSION_STONE_CHAMBER |
| d55 | **Carrière Rocher** (ES4) — BGM_BOULDER_QUARRY, scène du coffre vide / Team AWD (n06a3401) |
| d56 | **Caverne Calcaire** (ES4) — « I-in a limestone cavern! », BGM_LIMESTONE_CAVERN (n06a2802) |
| d57 | **Mont Travail** (Épisode Spécial 3 : Sunflora/Haunter) — « I'm going to arrest you! », « hot hot hot! » (n04a2001/2501) |
| d58-d61 | **UN SEUL template dupliqué** (md5 identiques sur .bma/.bpc/.bpl, même layout 57×57, 23 % libre) — pas quatre salles distinctes |

Les layouts/tilesets des véritables salles fixes d'Aegis Cave (chambres des
Regi, salles Zarbi, fond du puits) ne sont PAS extractibles de ce dépôt
(la table dungeon→map_group vit dans dungeon.bin, absent du repo). Les
grounds ici montreraient une jungle verte pour la « section Glace », une
caverne calcaire pour la « section Roche » et un volcan pour « Regirock » :
visuellement faux, donc exclus.

## Ce qui est en revanche canonique et déjà intégré (cloven_ruins)

- Ordre des boss : Regice → Regirock → Registeel → Regigigas (+ 8 gardes :
  4 Hitmonlee + 4 Bronzong, conforme Serebii).
- Mécanique des mots Zarbi : GLACE/ROCHE/ACIER, pierres dropées par les
  Zarbi (items `ruines_pierre_*`), tablette au camp, « fermer les yeux »,
  boucle du labyrinthe tant que le mot est incomplet (RuinesZarbi.lua).
- Structure d'étages conforme : Glace B1-B3, Roche B1-B3, Acier B1-B4,
  Puits B1-B5 (Serebii : Ice Maze B3F, Rock Maze B3F, Steel Maze B4F,
  Deepest Part B5F).
- Arènes : étages-arene fixes (rsmap) où l'éveil ET le combat se jouent
  sur la même carte (zéro différence exploration/combat).
- Finale Regigigas + effondrement + révélation de la Tour (RuinesTitan/
  RuinesRenforts) — la cutscene SSB d'origine (D61P41A) n'existe pas dans
  le repo (aucun dossier de scènes pour d58-d61).
