# Arène Tornadus régénérée par la méthode des relais (patron : crooked_den)

Date : 2026-08-05. Outil : `tools/mapgen/gen_tornadus_arene.py`.
Validée par l'auteur avant poussée.

## 1. Problème traité

L'ancien `Data/Ground/mount_windswept_guardian.rsground` (141×168 cellules
de 8 px) référençait la feuille **`Mt Horn Entrance Layer 1`, tuiles de
24 px sur une grille 8 px** — rendu en jeu cassé (détecté par
`validate_all.py` : `ts=24 != carte 8`).

La chorégraphie de `mount_windswept_guardian_ch_5.lua` (recalée au commit
`26e3c1a`) vit entièrement dans un carré de **432×432 px**
(x∈[168,264], y∈[24,392], caméras centrées sur (216,216)).

## 2. v1 écartée

Première tentative : composition **algorithmique** à partir des tuiles de
`mount_windswept_entrance` (fenêtre recentrée + pavage) — résultat
visuellement jugé « horrible » par l'auteur (patchwork plat, formations
incoherentes). Même leçon que `CORRECTION_DIAGNOSTIC_TILESET…` : la
composition algorithmique produit des damiers ; **l'art officiel porté donne
les rendus dignes du jeu** (l'arène Regigigas, jugée « magnifique »).

## 3. v2 retenue : plan officiel EoS

**Source** : `Data/Ground/mt_travail_peak.rsground` de
`slothplaysnecro/PMDO-Explorers-Maps` (plans EoS authentiques portés sous
RogueEssence), rendu vendored dans `tools/mapgen/data/mt_travail_peak_source.png`
(504×480 px, génération déterministe hors-ligne).

Choix du plan : **sommet avec horizon dégagé** (ciel, nuages, chaîne lointaine,
mer) encadré par deux masses de falaise — idéal pour un boss **volant** :
Tornadus rejoint son perchoir (216,24) **dans la bande ciel**, l'horizon
derrière lui.

| Élément | Choix |
|---|---|
| Patron structurel | `crooked_den` (feuille dédiée 8 px, spawners TEAMMATE, marker d'entrée, une couche) — cloné |
| Taille | **54×54 cellules = 432×432 px** = exactement l'espace du Lua |
| Cadrage | fenêtre (36,24)→(468,456) de la source : horizon à y≈116, plateforme dessous |
| Feuille | `Mount_Windswept_Guardian_Base` (8 px, 2916 cellules, dédup) — entrée `index.idx` **mise à jour en place**, 541 autres entrées byte-exactes |
| Obstacles | classification couleur+texture par cellule (bande ciel/perchoir libre sauf rochers bruités ; plateforme : seul le sol tan est praticable), zones scéniques forcées, garde-fou Lua (boîte 3×3), BFS depuis l'entrée sud, poches bouchées → **64 % marchable, positions Lua toutes libres/joignables** |
| Identité | `AssetName`, `Name` (« Sommet Venteux »), `Music` (`Sky Tower.ogg`) conservés |
| Entités | spawners `TEAMMATE_1/2/3` aux positions des `TeleportTo` du Lua ; `Main_Entrance_Marker` (utilisé par `zone/mount_windswept/init.lua:148,156`) + marker `entrance` en (216,408) |
| Combat | `Data/Map/mount_windswept_guardian.rsmap` (19×19 `craggy_peak`, Tornadus 33) **non touché** |
| Zone / scripts | non touchés |

## 4. Validation

- `tools/validate_all.py` : ✅ toutes salles valides (l'arène passe de ❌ à ✅).
- `tools/verify_tile_index.py` : 542/542 cohérent.
- Rendus : `docs/renders/mount_windswept_guardian.png` (salle),
  `mount_windswept_guardian_masque.png` (collisions vert/violet).

## 5. Non testé

Validation statique uniquement. À vérifier en jeu : entrée segment 2 →
`Main_Entrance_Marker`, cinématique (caméras (216,216)), atterrissage de
Tornadus au perchoir (216,24) avec l'horizon en fond, combat, sorties
`DefeatedBoss` / `DiedToBoss`.
