# Add-on « Réseau des Anciens Chemins » v2 — les 12 derniers donjons de PMD Rouge/Bleu

> Session `arena/019fa547`, 2026-07-30. Générateur : `tools/gen_addon_pmdred_network_v2.py`.
> Complète l'add-on v1 (34 zones, `new_era_zone_00..43`). **Avec cette vague, les 46 donjons
> du jeu d'origine existent tous dans New Era.**

## 1. Méthode

Le générateur v2 **étend** `tools/gen_addon_pmdred_network.py` : il l'importe et réutilise
telles quelles ses tables (`SPECIES`, `AT`, `MUSIC`), ses helpers (`load`/`save`,
`retarget_floor_ranges`, `scale_levels`) et son patron `ZONE_LUA`. Rien n'a été réinventé.

Ce qui est propre à cette vague :
- la table `Z2` des 12 donjons restants ;
- la gestion des **restrictions** (Tour de la Joie Première, Forêt de l'Épure) ;
- le pool **100 % Unown** pour la Relique des Glyphes.

Aucune zone existante (`00..43`) n'est touchée : le générateur n'écrit que `44..55`.

## 2. Les 12 zones

| Zone | Origine | Nom New Era | Étages | Niv | Thème | Déblocage |
|---|---|---|---|---|---|---|
| 44 | Rock Path | Sente des Éboulis | 4 | 8 | mountain | ch11+ |
| 45 | Snow Path | Sente des Névés | 4 | 22 | ice | ch11+ |
| 46 | Howling Forest | Futaie du Signal Perdu | 15 | 30 | forest | ch11+ |
| 47 | Mt. Faraway | Cime de l'Aurore Lointaine | 40 | 44 | mountain | ch11+ |
| 48 | Waterfall Pond | Bassin de la Chute Claire | 19 | 35 | sea | ch11+ |
| 49 | Unown Relic | Relique des Glyphes | 99 | 46 | relic | post-game |
| 50 | Joyous Tower | Tour de la Joie Première | 99 | **1** | sky | post-game |
| 51 | Far-Off Sea | Mer du Lointain | 75 | 48 | sea | post-game |
| 52 | Purity Forest | Forêt de l'Épure | 99 | **1** | forest | post-game |
| 53 | Remains Island | Île des Vestiges | 99 | 47 | relic | post-game |
| 54 | Marvelous Sea | Mer des Merveilles | 99 | 47 | sea | post-game |
| 55 | Fantasy Strait | Détroit des Chimères | 99 | 47 | psychic | post-game |

## 3. Choix notables

### 3.1 Aucun légendaire — deux donjons amputés de leur boss, volontairement

- **Futaie du Signal Perdu** (Howling Forest) : **sans Suicune**.
- **Cime de l'Aurore Lointaine** (Mt. Faraway) : **sans Ho-Oh**.

Raison : la règle du projet interdit tout légendaire en boss ou en spawn, et ces deux-là
ont **déjà** leur donjon-Ancrage — Suicune dans `antre_chuchotant` (ch25), Ho-Oh dans
`tour_sacree` (ch18). Les recréer ici ferait doublon. Fin de donjon sobre :
`EndDungeonRun` vers `master_zone` carte 1, comme les 34 zones de la v1.

Vérification automatique passée : **0 espèce légendaire ou fabuleuse** dans les 12 zones
(contrôle sur une liste de 80 espèces, gén. 1-9).

### 3.2 Restrictions « niveau 1 »

Reproduites via les champs de zone, sur le patron **exact** de `new_era_zone_26`
(Puits des Vœux Fossiles / Wish Cave), seule zone du dépôt qui les posait déjà :

```
Level = 1, LevelCap = true, KeepSkills = false,
TeamRestrict = true, TeamSize = 1,
MoneyRestrict = true, BagRestrict = 0
```

Appliqué à la **Tour de la Joie Première** et à la **Forêt de l'Épure** — les deux donjons
« solo niveau 1 » de l'original. Les mêmes valeurs sont recopiées dans le résumé
`ZoneEntrySummary` de `index.idx` (le moteur valide contre le résumé, pas contre le JSON).

Note : `TeamSize = 1` (solo strict). Le Puits des Vœux, lui, est à `TeamSize = 2` — c'est
conforme à l'original, où Wish Cave autorise un partenaire.

### 3.3 Relique des Glyphes : 100 % Unown

Le pool thématique est remplacé par `unown` sur tous les slots. Le moteur gère les formes
via le champ `Form` du spawn ; la variété de glyphes est donc portée par les données
d'espèce, pas par des entrées séparées.

### 3.4 Reskin

Aucun nom d'origine ni élément d'intrigue. Le lexique des bâtisseurs est conservé :
*Sente*, *Signal*, *Balise*, *Relique*, *Cime*. « Futaie du **Signal** Perdu » et
« **Relique** des Glyphes » raccrochent explicitement au Réseau des Anciens Chemins.

### 3.5 Pas de ground d'entrée ni d'arène

Ces 12 donjons n'ont ni entrée pmd-red importée ni arène de Veilleur : `GroundMaps` est
vide, `Maps` vaut `[[0]]` (un segment procédural). Entrée et sortie passent par
`master_zone` carte 1 (Metano), comme les zones sans ground de la v1.

## 4. Étages — source et divergences

Valeurs issues de `src/dungeon_info.c` `sDungeonFloorCount[]` (pret/pmd-red), fournies par
la consigne. **La décompilation n'a pas pu être clonée depuis ce sandbox** (pas d'accès
réseau garanti) : les valeurs ont donc été reprises telles quelles, sans recoupement
indépendant.

**Divergence constatée avec le générateur v1 : aucune.** La table `FLOORS` de v1 couvre les
ids 0..43 ; les 12 donjons traités ici n'y figuraient pas — soit ils étaient dans `SKIP`
(cimes fusionnées, doublons), soit au-delà de l'id 43. Il n'y a donc aucun conflit de
valeur entre les deux vagues.

Point à revérifier si tu clones un jour la décomp : **Far-Off Sea à 75 étages** est la
seule valeur de la liste qui ne soit ni un « petit » donjon (4-40) ni le palier classique
de 99 ; elle mérite un coup d'œil.

## 5. Validation exécutée

1. `json.load(encoding='utf-8-sig')` — 12 zones + `index.idx` : **OK**
2. Syntaxe Lua — 12 `init.lua` + `debug_tools/init.lua` + 3 fichiers de tag : **OK**
3. Musiques référencées présentes dans `Content/Music/` : **11/11 OK**
4. Cohérence `index.idx` ↔ JSON sur `Level`, `LevelCap`, `TeamRestrict`, `TeamSize`,
   `MoneyRestrict`, `BagRestrict`, `CountedFloors` : **OK pour les 12**
5. Aucun légendaire, aucun « Necrozma / Eternatus » : **OK**

### Note sur les autotiles

Les autotiles référencés (`mt_thunder_floor`, `stormy_sea_1_floor`, `sky_tower_floor`…)
**n'existent pas dans ce dépôt** — et c'est normal : ils proviennent du jeu de base
PMDO/PMDODump. Les donjons d'histoire font pareil (`vast_steppe` utilise
`lush_prairie_floor`, absent lui aussi de `Data/AutoTile/`, qui ne contient que les
8 `apricorn_grove_*` propres au mod). Le contrôle « chaque autotile existe dans le dépôt »
demandé par la consigne est donc **inapplicable tel quel** ; il a été remplacé par : les
12 zones n'utilisent **que** des autotiles déjà employés par les 34 zones de la v1, donc
déjà éprouvés en jeu.

## 6. Déblocage

Dans `Data/Script/halcyon/services/debug_tools/init.lua`, à la suite du bloc de la v1 :

- **44-48** ajoutés au bloc existant `Chapter >= 11 or StoryCompleted` ;
- **49-55** dans un nouveau bloc `StoryCompleted == true` (donjons post-game de l'original).

Le mécanisme `OnUpgrade` couvre à la fois les nouvelles parties et les sauvegardes
existantes, comme pour les 34 zones précédentes.
