# ROSTER D'IMPORT — DONJONS PMD RED RÉPARTIS CHAPITRES 7 À 32

**Date : 2026-08-06 — Statut : LISTE PRÉSENTÉE POUR VALIDATION (framework §9 : « lister d'abord, présenter avant génération »).**
Aucun fichier de zone généré, aucun commit. Dès validation de ce roster, génération chapitre par chapitre (ch7 d'abord).

Sources vérifiées (aucune hypothèse) :
- `pret/pmd-red/data/dungeon/dungeon_data.json` (98 donjons, flags canoniques) — extrait ici.
- `pret/pmd-red/data/dungeon/<Donjon>/floor_id.json` (étages canoniques) — extrait ici.
- `pret/pmd-red/src/dungeon_cutscene_*.c` (constantes `CUTSCENE_*_ATTEMPT1` = association boss↔donjon) — vérifié donjon par donjon.
- `pret/pmd-red/src/dungeon_data.c` (`gInvalidDungeonIDs` = exclusions système).
- Mod : `docs/DOCUMENT_MAITRE_donjons_externes.md` (Parties 2, 6, 8), `docs/pmdred_extraction_tracabilite.md` (assets convertis), `docs/vague6_friend_areas_boss.md` (friend areas), `docs/inventaire_donjons.md` (roster ch6-14), barème des paliers (Partie 2).

---

## 1. RÈGLES D'EXCLUSION (justifiées par les sources)

| Exclu | Justification |
|---|---|
| **57 Friend Areas (H01P01→H29P04)** | Directive utilisateur du jour : « les friend areas sont juste des zones d'accueil, pas des donjons ». Déjà importées 1:1 comme arènes de boss (`vague6_friend_areas_boss.md`). |
| **17 labyrinthes élémentaires** (NORMAL/FIRE/WATER/GRASS/ELECTRIC/ICE/FIGHTING/GROUND/FLYING/PSYCHIC/POISON/BUG/ROCK/GHOST/DRAGON/DARK/STEEL MAZE) | Décision validée 2026-07-27 (Partie 8, point 7) : ne PAS importer les mazes pmd-red (donjons procéduraux sans asset) ; compléter notre système dojo avec les 9 types manquants. |
| **4 duels rivaux** (TEAM_SHIFTY/CONSTRICTOR/HYDRO/RUMBLEROCK) | Partie 6 : « à traiter comme combats ponctuels avec NOS équipes rivales, pas un nouveau groupe ». |
| **Exclusions système** (`gInvalidDungeonIDs`) | `src/dungeon_data.c`: BOSS_3, BOSS_4, BOSS_9, WONDROUS_SEA, AUTOPILOT, D50, D51, D54, POISON_MAZE, D61, OUT_ON_RESCUE. |
| **Entrées non-donjon** | JOIN_LOCATION_* (64/65/74), UNKNOWN_WORLD, POKEMON_SQUARE (+_2), RESCUE_TEAM_BASE (+_2), AGB_SLOT, NORMAL_MAZE_2, RESCUE_TEAM_2, RESCUE_TEAM_MAZE, FROSTY_GROTTO_2, HOWLING_FOREST_2, MT_FREEZE_PEAK_2 (doublons). |
| **Sky Tower + Sky Tower Summit** | **DÉJÀ IMPORTÉS** : = `tour_celeste` / `tour_celeste_sommet` (ch10, commits 8ae6e29/83cf229 ; entrée `parvis_celeste` = D13P01, sommet = D13P03). Pas de ré-import. |

**Reste : 51 donjons d'histoire importables** (dont 49 à créer + 2 déjà faits).

---

## 2. ROSTER DES 51 DONJONS (DONNÉES CANONIQUES VÉRIFIÉES + ASSIGNATION CHAPITRE)

Légende : **Étages** = `floor_id.json` (canonique) ; **Boss** = `dungeon_cutscene_*.c` (canonique) ; **Asset converti** = `pmdred_extraction_tracabilite.md` (lots 1-3) ; **Palier** = barème Partie 2 ; **Ch.** = chapitre proposé (répartition ch7→ch32, ~2/chapitre, respect du barème ; rescaling de niveau au palier du chapitre selon la pratique « Renivelage »).

| # | PMD Red (canonique) | Étages | Boss canonique | Asset converti (entrée/arène) | Palier | **Ch.** | Nom FR proposé |
|---|---|---|---|---|---|---|---|
| 1 | Tiny Woods | 3 | — | `foret_tendre_oree` (D01P01) | 1→resc. | **7** | Forêt Tendre |
| 2 | Thunderwave Cave | 5 | — | `grotte_statique_seuil` (D02P01) | 1→resc. | **7** | Grotte Statique |
| 3 | Mt. Steel | 9 | — | `pic_ferreux_pied` (D03P01) | 1→resc. | **7** | Pic Ferreux |
| 4 | Sinister Woods | 13 | — | `bois_sombres_oree` (D04P01) | 2 | **8** | Bois Sombres |
| 5 | Silent Chasm | 9 | — | `gouffre_muet_bord` (D05P01) | 2 | **8** | Gouffre Muet |
| 6 | Mt. Thunder | 10 | — | `mont_grondant_pied` (D06P01) | 2 | **9** | Mont Grondant |
| 7 | Mt. Thunder Peak | 3 | **Zapdos** | — | 2 | **9** | Cime du Mont Grondant |
| 8 | Great Canyon | 12 | — | `grand_canyon_porte` (D07P01) | 2 | **9** | Grand Canyon |
| 9 | Lapis Cave | 14 | — | `grotte_lazuli_seuil/fond` (D08P01/02) | 2-3 | **10** | Grotte Lazuli |
| 10 | Mt. Blaze | 12 | — | `mont_cendre_pied` (D09P01) | 3 | **10** | Mont Cendré |
| 11 | Mt. Blaze Peak | 3 | **Moltres** | — | 3 | **10** | Cime du Mont Cendré |
| 12 | Frosty Forest | 9 | — | `foret_givree_oree` (D10P01) | 3 | **11** | Forêt Givrée |
| 13 | Frosty Grotto | 5 | **Articuno** | — | 3 | **11** | Grotte Givrée |
| 14 | Mt. Freeze | 15 | — | `mont_gele_pied` (D11P01) | 3 | **11** | Mont Gelé |
| 15 | Mt. Freeze Peak | 5 | — | — | 3 | **12** | Cime du Mont Gelé |
| 16 | Magma Cavern | 23 | — | `gorge_ardente_porte` (D12P01) | 3-4 | **12** | Gorge Ardente |
| 17 | Magma Cavern Pit | 3 | **Groudon** | D12P02/04 (lot 3) | 4 | **12** | Fond de la Gorge Ardente |
| 18 | Sky Tower | 25 | — | `parvis_celeste` (D13P01) | 4 | ✅ ch10 | Tour Céleste (déjà) |
| 19 | Sky Tower Summit | 9 | **Rayquaza** | `autel_celeste`/D13P03 | 4 | ✅ ch10 | Sommet de la Tour Céleste (déjà) |
| 20 | Stormy Sea | 40 | **Kyogre** | — | 4-5 | **13** | Mer Orageuse |
| 21 | Silver Trench | 99 | **Lugia** | — | 4-5 | **13** | Fosse d'Argent |
| 22 | Meteor Cave | 20 | **Deoxys** | — | 4-5 | **14** | Grotte de la Météorite |
| 23 | Western Cave | 99 | **Mewtwo** | — | 5 | **14** | Grotte Occidentale |
| 24 | Wish Cave | 99 | **Jirachi** | `sanctuaire_voeu` (D23P01) | 5 | **15** | Grotte du Vœu |
| 25 | Buried Relic | 99 | **Regis** | — | 5 | **15** | Relique Enfouie |
| 26 | Pitfall Valley | 25 | — | `vallon_perdu` (D22P01) | 5 | **16** | Vallon Perdu |
| 27 | Northern Range | 25 | **Latios** | — | 5 | **16** | Chaîne Nordique |
| 28 | Desert Region | 20 | — | — | 5 | **17** | Région Désertique |
| 29 | Southern Cavern | 50 | — | — | 5-6 | **17** | Caverne Méridionale |
| 30 | Wyvern Hill | 30 | — | — | 5-6 | **18** | Colline aux Drakes |
| 31 | Fiery Field | 30 | **Entei** | — | 5-6 | **18** | Plaine Ardent |
| 32 | Northwind Field | 30 | **Suicune** | — | 5-6 | **19** | Champ du Vent du Nord |
| 33 | Solar Cave | 20 | — | — | 5-6 | **19** | Grotte Solaire |
| 34 | Lightning Field | 30 | **Raikou** | — | 6 | **20** | Champ de Foudre |
| 35 | Darknight Relic | 15 | — | — | 6 | **20** | Relique de la Nuit |
| 36 | Murky Cave | 19 | — | `caverne_trouble_fond/autel` (D24P01/02) | 6 | **21** | Caverne Trouble |
| 37 | Grand Sea | 30 | — | — | 6 | **21** | Grande Mer |
| 38 | Uproar Forest | 10 | — | — | 6 | **22** | Forêt du Tumulte |
| 39 | Oddity Cave | 15 | — | — | 6 | **22** | Caverne Étrange |
| 40 | Remains Island | 20 | — | — | 6 | **23** | Île des Vestiges |
| 41 | Marvelous Sea | 20 | — | — | 6 | **23** | Mer Merveilleuse |
| 42 | Fantasy Strait | 30 | — | — | 6 | **24** | Détroit Fantastique |
| 43 | Rock Path | 4 | — | — | 6 | **24** | Sentier Rocheux |
| 44 | Snow Path | 4 | — | — | 7 | **25** | Sentier Neigeux |
| 45 | Howling Forest | 15 | — | — | 7 | **25** | Forêt des Hurlements |
| 46 | Waterfall Pond | 19 | — | — | 7 | **26** | Étang de la Cascade |
| 47 | Unown Relic | 11 | — | — | 7 | **26** | Relique des Zarbi |
| 48 | Joyous Tower | 99 | — | — | 7 | **27** | Tour Joyeuse |
| 49 | Far-Off Sea | 75 | — | — | 7 | **27** | Mer Lointaine |
| 50 | Mt. Faraway | 40 | **Ho-Oh** | — | 7-8 | **28** | Mont Lointain |
| 51 | Purity Forest | 99 | **Celebi** | — | 8 | **29** | Forêt de la Pureté |

**Répartition par chapitre** : ch7 (3) · ch8 (2) · ch9 (3) · ch10 (3) · ch11 (3) · ch12 (3) · ch13 (2) · ch14 (2) · ch15 (2) · ch16 (2) · ch17 (2) · ch18 (2) · ch19 (2) · ch20 (2) · ch21 (2) · ch22 (2) · ch23 (2) · ch24 (2) · ch25 (2) · ch26 (2) · ch27 (2) · ch28 (1) · ch29 (1) — 49 à créer + 2 déjà faits = 51.

---

## 3. DONNÉES CANONIQUES PORTABLES 1:1 (dungeon_data.json → ZoneData RogueEssence)

Pour chaque donjon, les flags officiels se portent directement sur la `ZoneData` :
`maxItemsAllowed` → `BagRestrict` (ex. Meteor Cave=3, Purity Forest=0) · `maxPartyMembers` → `TeamSize` (ex. Meteor Cave=1, Purity Forest=1, pics=4) · `keepMoney` → `MoneyRestrict` · `turnLimit` → `TimeLimit` · `enterWithoutGameSave` / `hasCheckpoint` → gestion de sauvegarde.
Les tables de monstres par étage (`pokemon_found.json` : espèces + niveaux + probabilités), objets (`dungeon_item_data.json`), pièges (`trap_data.json`) et la géométrie par étage (`main_data.inc`) sont disponibles comme source canonique ; adaptation : niveaux rescallés au palier du chapitre (espèces/probabilités conservées, sauf vérification `Content/Chara/` exigée par le framework).

---

## 4. ARBITRAGES À VALIDER (conflits avec l'existant, signalés sans décision prise)

1. **Sky Tower / Summit** : déjà importés (ch10) → non ré-importés (acté).
2. **Wish Cave (Jirachi)** : Partie 8.3 tranché — `wishmaker_cave` (donjon du mod) + `sanctuaire_voeu` (ground pmd-red) comme salle finale. Conforme.
3. **Magma Cavern Pit (Groudon)** : légende de Dotra (ch5) validée (Partie 8.6) → cohérent.
4. **Silver Trench (Lugia)** : Lugia est déjà le boss du ch10 du mod (Autel des Cieux) → **2 occurrences Lugia** ? À arbitrer : Silver Trench = donjon d'arc avec Lugia en revanche/autre forme, ou casting remplacé (dérogerait à la règle 1:1).
5. **Mt. Faraway (Ho-Oh)** : le mod assigne déjà Ho-Oh au ch18 (arène `pic_arc_en_ciel`, vague6) → **2 occurrences Ho-Oh** ? À arbitrer.
6. **Purity Forest (Celebi)** : mod assigne Celebi au ch20 (`foret_guerison`, vague6) → à arbitrer.
7. **Buried Relic (Regis)** : le trio Regi est déjà dans `cloven_ruins` ch7 (`sanctuaire_titans`) → Buried Relic = revanche/autre forme à arbitrer.
8. **Frosty Grotto (Articuno)** : aucun conflit — Articuno non assigné ailleurs dans le mod (vérifié vague6). OK.
9. **Stormy Sea (Kyogre)** : cohérent avec le plan existant (Kyogre ch12, arène `plancher_abysses`).
10. **Western Cave (Mewtwo)** : lore Mewtwo via `labo_decrepit` (ch22) → à coordonner (pas de blocage).
11. **Noms FR** : les noms proposés ci-dessus suivent la convention de la traçabilité (ex. `foret_tendre_oree` → Forêt Tendre). Certains restent proches des noms officiels (Grotte du Vœu, Tour Joyeuse…) — conformément à la règle pmd-red de la Partie 6 (« seuls changent le nom de zone et le casting »), mais à confirmer.
12. **Statut des 49 zones** : en tant que donjons secondaires (job board + déblocage chapitre) ou principaux d'arc ? Les 2-3 premiers chapitres (7-8) gardent leurs principaux existants (`cloven_ruins` ch7, `crystal_sanctuary` ch8) → les PMD Red y sont des secondaires ; pour ch15+, à décider.

---

## 5. PROCHAINE ÉTAPE (après validation)

1. Génération **chapitre 7** d'abord (3 donjons : Forêt Tendre, Grotte Statique, Pic Ferreux) : `Data/Zone/<id>.json` (structure RogueEssence éprouvée par `generate_*_dungeons.py`), tables d'ennemis depuis `pokemon_found.json` (espèces vérifiées `Content/Chara/`), branchement entrées converties (`foret_tendre_oree`, `grotte_statique_seuil`, `pic_ferreux_pied`), `master_zone` + `index.idx`, musique vérifiée `Content/Music/`.
2. Audit de fidélité par donjon (mêmes garanties que le pilote D13P03) puis commit.
3. Passage au chapitre suivant (framework §8 : un chapitre à la fois).

**EN ATTENTE DE VOTRE VALIDATION du roster + des arbitrages §4.**
