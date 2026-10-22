# Extraction pmd-red → New Era — Rapport de traçabilité (Étape 5)

Date : 2026-07-27
Source : [pret/pmd-red](https://github.com/pret/pmd-red) (décompilation PMD Red Rescue Team, GBA), clonée et analysée localement.
Outils produits : `tools/convert_pmdred_ground.py` (+ bibliothèque de décodage `/tmp/pmdred_extract/pmdred_lib.py`, transcrite du C de référence).

## Étape 1 — Extraction : décodeurs validés

| Format | Méthode | Statut |
|---|---|---|
| `.bpl` (palettes) | Décodeur maison d'après `src/ground_bg.c` : `numPalettes` en tête, 15 couleurs RGBA/palette, index 0 transparent | ✅ validé (D13P03 : 10 palettes) |
| `.bpc` (tuiles+chunks) | Décodeur maison : header 16 o, tuiles 4bpp 32 o, chunks 3×3 de u16 `tile|hflip|vflip|palette`. **Le format GBA n'est PAS lisible par skytemple-files** (compression BPC différente du NDS — vérifié : `BPC Image Decompressor` échoue) | ✅ validé (rendu T00P01 = Pokémon Square parfait, voir preview) |
| `.bma` (layout+collision) | Couches chunk-map : décompresseur NRL/XOR transcrit 1:1 de `BmaLayerNrlDecompressor` (stride 64, XOR ligne précédente). Collision : lue via skytemple-files (cette couche est au format commun GBA/NDS) | ✅ validé (les 2 implémentations concordent) |
| `.bpa` (animations) | Non traité (66 fichiers, tuiles animées — hors périmètre du pilote) | ⏳ |

Preuve visuelle : `T00P01_preview.png` (Pokémon Square rendu parfaitement — arbres, maisons, chemins, étangs).

## Étape 2 — Inventaire des zones (245 map file ids, 677 fichiers)

| Catégorie | Nombre | Exemples |
|---|---|---|
| Villes/spéciales (Square, bases, tests…) | 143 | T00P01 (Square), A0xx (intro) |
| Friend Areas | 57 | déjà couvert par le pack Friend Area du projet |
| **Cinématiques de donjon** (forte identité) | **32** | voir table ci-dessous |
| Donjons génériques (D14-D23…) | 13 | fonds d'entrée simples |

Les 32 zones de cinématique (ENTRY/MID/END), croisées avec `src/dungeon_cutscene_*.c` (26 scripts de boss : Rayquaza, Groudon, Kyogre, Ho-Oh, Lugia, Entei, Articuno, Moltres, Zapdos, Mewtwo, Latios, Celebi, Jirachi, Deoxys…) :

Tiny Woods, Thunderwave Cave, Mt. Steel, Sinister Woods, Silent Chasm, Mt. Thunder (3), Great Canyon, Lapis Cave (2), Mt. Blaze (3), Frosty Forest (3), Mt. Freeze (3), **Magma Cavern (3 — arène Groudon)**, **Sky Tower (3 — arène Rayquaza)**, The End.

## Étape 3-4 — Zone pilote convertie : D13P03 → Autel des Cieux

| Champ | Valeur |
|---|---|
| Nom d'origine | `MAP_SKY_TOWER_END` — Sky Tower Summit (arène Rayquaza, `dungeon_cutscene_rayquaza.c`, script `gs209`) |
| Nouveau nom | `autel_celeste` — **« Autel des Cieux »** (arène Lugia, ch10) |
| Fichiers sources | `D13P03.bpl` (10 palettes) / `D13P03c.bpc` (504 tuiles, 230 chunks) / `D13P03m.bma` (69×75 tuiles, collision 1 couche) |
| Fichiers produits | `Content/Tile/Autel_Celeste_Base.tile` (8 px, 5175 cellules) + `Data/Ground/autel_celeste.rsground` (552×600 px) |
| Géométrie | **1:1, aucune transformation** — grille identity-mapped (standard du projet), collision d'origine cellule par cellule (750 walkables = la plateforme ovale du sommet) |
| Positions d'entités | **EXACTES du `GroundLivesData s_gs209`** : héros (37,37), partenaire (32,37), alliés (34,42)/(38,41), boss (34,34), trigger de cutscene (34,35) — tuiles GBA × 8 px. Toutes vérifiées walkables sur la collision d'origine |
| Casting remplacé | Rayquaza → **Lugia** (le duo d'origine → héros+partenaire New Era, alliés → équipiers). Intro 3 couches New Era (Voix → DescendSky → titre), textes FR existants CPB_00x |
| Ajustements techniques | Palette : reprojection RGBA directe (les .bpl stockent déjà du 8 bits/canal). Résolution : **aucun changement de TileSize nécessaire** — le GBA et RogueEssence partagent la même unité de 8 px (`TEX_SIZE=8`) ; la carte est plus grande que l'écran d'origine 240×160 car le jeu scrollait — RogueEssence gère nativement le scroll, aucun XML à modifier |
| Branchement | `celestial_peak` segment 4 → `autel_celeste` (remplace `celestial_peak_boss` composé) ; master_zone idx 78 ; index.idx synchronisé |
| Statut | **Converti — à vérifier en jeu** (réserve ci-dessous) |

### ⚠ Réserve visuelle documentée (honnêteté technique)
La couche visuelle de D13P03 ne référence que le chunk n°1 (plateforme unie) — vérifié par DEUX décodeurs indépendants (le mien + skytemple-files, résultats identiques). Les 229 chunks de nuages du .bpc sont présents mais non référencés par le .bma : dans le jeu d'origine, le décor de nuages est rendu par les couches BG matérielles du GBA (ciel défilant) + animations de palette, pas par la tilemap. Compensation appliquée : fond `Sky` animé défilant de RogueEssence (`Background.BGAnim = Sky`) + fond bleu nuit de la palette d'origine. Le résultat en jeu = plateforme du sommet sur ciel mouvant, fidèle à l'esprit de la scène. Si le rendu est jugé trop nu, les chunks de nuages extraits peuvent servir de décorations (ils sont dans le .tile du catalogue → `D13P03_chunks.png`).

## Étape suivante (industrialisation — sur demande)
Le pipeline est prouvé. Candidats prioritaires (mêmes garanties 1:1) :
1. `D12P04` — Magma Cavern Pit (arène Groudon) → candidat arène pour un donjon volcanique futur (la légende de Dotra ch5 l'a déjà préparée).
2. `D01P01/D01P02` — Tiny Woods (entrée + fond) → biome doux, zones ch1.
3. `D10P01-03` — Frosty Forest → premier biome neige du projet.
4. `T00P01` — Pokémon Square (rendu parfait) → source de décor pour une future bourgade.
Chaque conversion suivra ce même rapport ligne par ligne.

---

## Lot 2 — Industrialisation (2026-07-27) : 18 zones converties

Pipeline identique au pilote (décodeurs maison `tools/pmdred_lib.py`, désormais
COPIÉ DANS LE DÉPÔT ; conversion par lot `tools/convert_pmdred_batch.py`).
Règle 1:1 respectée : géométrie, collision et positions d'entités lues
automatiquement dans les `GroundLivesData`/`GroundEffectData` des fichiers
`src/data/ground/ground_data_*_station.h` de pret/pmd-red — kind 0 = héros →
`Main_Entrance_Marker`, kind 4/34/10/11 = partenaire/alliés → `TEAMMATE_n`,
kind ≥ 80 = boss/PNJ → `Boss_Marker`/`PNJ_Marker_n`, effets → `Cutscene_Marker`.
Seul le nom de zone change.

| Source pmd-red | Zone d'origine | Asset New Era | Nom FR | Dim. (tuiles 8px) | Entités src | Audit flood-fill | Usage prévu |
|---|---|---|---|---|---|---|---|
| D01P01 | Tiny Woods (entrée) | foret_tendre_oree | Orée de la Forêt Tendre | 54×45 | 2 lives + 1 eff | 2430/2430 † | réserve entrée donjon palier 1 |
| D02P01 | Thunderwave Cave (entrée) | grotte_statique_seuil | Seuil de la Grotte Statique | 48×39 | 4 lives + 1 eff | 978/978 | réserve entrée donjon électrique |
| D03P01 | Mt. Steel (pied) | pic_ferreux_pied | Pied du Pic Ferreux | 45×39 | 2 lives + 1 eff | 344/344 | réserve entrée donjon minier |
| D04P01 | Sinister Woods (orée) | bois_sombres_oree | Orée des Bois Sombres | 57×48 | 2 lives + 1 eff | 292/292 | réserve forêt sombre (Suaire / arc Accusation) |
| D05P01 | Silent Chasm (bord) | gouffre_muet_bord | Bord du Gouffre Muet | 84×30 | 3 lives + 1 eff | 215/215 | réserve entrée gouffre |
| D06P01 | Mt. Thunder (pied) | mont_grondant_pied | Pied du Mont Grondant | 51×36 | 2 lives + 1 eff | 733/733 | réserve donjon orage (écho Fulgur) |
| D07P01 | Great Canyon (porte) | grand_canyon_porte | Porte du Grand Canyon | 57×30 | 2 lives + 1 eff | 659/659 | réserve canyon post-ch10 |
| D08P01 | Lapis Cave (seuil) | grotte_lazuli_seuil | Seuil de la Grotte Lazuli | 45×36 | 2 lives + 1 eff | 412/412 | réserve grotte bleue |
| D08P02 | Lapis Cave (fond) | grotte_lazuli_fond | Fond de la Grotte Lazuli | 45×36 | 2 lives + 1 eff | 412/412 | réserve salle finale grotte bleue |
| D09P01 | Mt. Blaze (pied) | mont_cendre_pied | Pied du Mont Cendré | 45×39 | 2 lives + 1 eff | 438/438 | réserve donjon feu |
| D10P01 | Frosty Forest (orée) | foret_givree_oree | Orée de la Forêt Givrée | 33×42 | 2 lives + 1 eff | 140/140 | candidate entrée Sentier Glaciaire (ch8, vague 2) |
| D11P01 | Mt. Freeze (pied) | mont_gele_pied | Pied du Mont Gelé | 33×36 | 2 lives + 1 eff | 340/340 | candidate entrée Sentier Enneigé (ch10, vague 2) |
| D12P01 | Magma Cavern (porte) | gorge_ardente_porte | Porte de la Gorge Ardente | 51×42 | 2 lives + 1 eff | 1083/1083 | réserve arc Groudon (légende de Dotra, ch5) |
| D13P01 | Sky Tower (entrée) | parvis_celeste | Parvis Céleste | 51×36 | 3 lives + 1 eff | 551/551 | réserve variante entrée Pic Céleste |
| D22P01 | Pitfall Valley (gs218) | vallon_perdu | Vallon Perdu | 51×45 | 2 lives + 4 effs | 2295/2295 † | réserve scène de sauvetage (mission majeure) |
| D23P01 | Wish Cave fond (gs219, Jirachi) | sanctuaire_voeu | Sanctuaire du Vœu | 45×42 | 3 lives + 1 eff | 702/702 | **salle finale Grotte du Vœu** (décision synthèse Jirachi 2026-07-27) |
| D24P01 | Murky Cave fond (gs220) | caverne_trouble_fond | Fond de la Caverne Trouble | 51×48 | 2 lives + 1 eff | 1378/1378 | réserve salle de sceau (arc Suaire) |
| D24P02 | Murky Cave autel (gs221) | caverne_trouble_autel | Autel de la Caverne Trouble | 51×36 | 2 lives + 1 eff | 778/778 | réserve autel de sceau (arc Suaire) |

† D01P01, D22P01, D24P01 : le BMA source n'a **pas** de couche collision
(`hasCollision=0`). Collision dérivée de la zone visible (tuile entièrement
noire = bloquée) — documenté dans le champ `Comment` de chaque `.rsground`.
Pour D01P01/D22P01 la carte entière est visible → tout marchable dans le
`.rsground`, à restreindre au moment du branchement si besoin (les positions
d'entités restent la vérité du script d'origine).

**Statut** : les 18 zones sont des ASSETS EN RÉSERVE — `.tile` + `.rsground` +
`init.lua` squelette, non branchés à `master_zone`/`index.idx` des zones
jouables. Le branchement se fera zone par zone au moment de l'assignation
(vague 2 pour foret_givree_oree/mont_gele_pied ; arc Jirachi pour
sanctuaire_voeu ; etc.), avec cinématique recastée et audit complet.

**Mapping donjon↔cinématique vérifié dans le code** (`src/ground_map.c`) :
D14→Stormy Sea (Kyogre), D15→Silver Trench (Lugia), D16→Fiery Field (Moltres),
D17→Lightning Field (Raikou/Suicune), D18→Northwind Field (Articuno),
D19→Mt. Faraway (Ho-Oh), D20→Western Cave (Mewtwo), D21→Northern Range
(Latios), D23→Wish Cave étage 20 (Jirachi), D25→Howling Forest (Suicune).
D14-D21, D25 restent à convertir (matériel-layer : géométrie/collision only,
même statut que D13P03 — le décor GBA vient des couches dungeon, compensable
par Background animé + retiling biome comme l'arène Lugia).

---

## Lot 3 — Arènes de cinématique de boss (2026-07-27) : 12 zones

Cartes « material-layer » (comme le pilote D13P03) : la tilemap GBA ne contient
que la silhouette de la zone jouable, le décor venait des couches dungeon
matérielles. Compensation prévue au branchement : Background animé + retiling
biome (procédé validé sur l'arène Lugia / Rainbow_Peak). Casting des boss
d'origine CONSERVÉ (règle 1:1 Partie 6) — chaque légendaire reste soumis à la
fiche narrative §5 avant tout branchement.

| Source | Zone d'origine (vérifiée `src/ground_map.c`) | Asset | Nom FR | Dim. | Boss d'origine | Audit flood |
|---|---|---|---|---|---|---|
| D12P02 | Magma Cavern mi-parcours (gs205) | gorge_ardente_coeur | Cœur de la Gorge Ardente | 57×57 | mise en scène | 657/657 |
| D12P04 | Magma Cavern Pit (gs206) | fosse_ardente | Fosse Ardente | 63×63 | **Groudon** | 650/650 |
| D13P02 | Sky Tower mi-parcours (gs208) | palier_celeste | Palier Céleste | 57×57 | mise en scène | 657/657 |
| D14P01 | Stormy Sea fond (gs210) | abime_tempetes | Abîme des Tempêtes | 66×63 | **Kyogre** | 868/868 |
| D15P01 | Silver Trench fond (gs211) | fosse_argentee | Fosse Argentée | 69×75 | **Lugia** (réserve — distincte de notre ch10) | 4347/4347 |
| D16P01 | Fiery Field fond (gs212) | champ_braises | Champ des Braises | 45×45 | **Moltres** | 558/594 ⚠ |
| D17P01 | Lightning Field fond (gs213) | champ_foudre | Champ de la Foudre | 48×45 | **Raikou** | 657/657 |
| D18P01 | Northwind Field fond (gs214) | champ_vent_boreal | Champ du Vent Boréal | 45×42 | **Articuno** | 378/378 |
| D19P01 | Mt. Faraway fond (gs215) | sommet_aurore | Sommet de l'Aurore | 66×63 | **Ho-Oh** | 856/856 |
| D20P01 | Western Cave fond (gs216) | antre_occident | Antre de l'Occident | 45×42 | **Mewtwo** | 1080/1080 |
| D21P01 | Northern Range fond (gs217) | cretes_boreales | Crêtes Boréales | 63×60 | **Latios/Latias** | 3078/3078 |
| D25P01 | Howling Forest fond (gs222) | bois_des_plaintes | Bois des Plaintes | 45×42 | **Suicune** | 618/618 |

⚠ D16P01 : 36 cases non connexes à la position du héros **dans la carte
d'origine** (îlots de lave isolés) — conservées telles quelles (règle 1:1),
aucune entité dessus.

Statut : réserve non branchée, comme le lot 2. Total pmd-red converti :
**31 zones** (1 pilote + 18 lot 2 + 12 lot 3).
