# Les 14 étages fantômes des chapitres 7-10 + la Pluie de Cendres

Build : `2026-08-01-A`

Ce lot devait poser les deux briques natives repérées dans l'étude PMDO
(`ScreenRainEmitter`, `DefaultMapStatusStep`). En cherchant où les brancher,
j'ai trouvé bien pire.

---

## 1. LE BUG BLOQUANT — 14 étages qui ne pouvaient pas exister

### Le constat

En inspectant les `Floors` de `celestial_peak` pour y insérer la météo, j'ai
trouvé ceci :

```json
"Floors": { "nodes": [
   { "Item": {}, "Range": { "Min": 0, "Max": 4 } },
   { "Item": {}, "Range": { "Min": 4, "Max": 8 } }
]}
```

**`"Item": {}`** — littéralement vide. Aucune donnée de génération : pas de
plan de grille, pas de tileset, pas d'escaliers, pas de spawns.

Balayage de tout le dépôt : **4 zones, 14 étages** dans ce cas — et ce sont
exactement **les quatre donjons d'histoire des chapitres 7 à 10** :

| donjon | chapitre | étages vides |
|---|---|---|
| `cloven_ruins` | 7 | 4 / 7 |
| `crystal_sanctuary` | 8 | 3 / 6 |
| `forgotten_marsh` | 9 | 3 / 6 |
| `celestial_peak` | 10 | 4 / 8 |

Les 194 autres zones : **0 étage vide**.

### Ce que ça signifiait

Les arènes de boss (`LoadGen`) existaient. Les relais existaient. Les
cinématiques que j'ai écrites ces derniers lots — Diancie qui cède, le Cercle
qui compte, Lugia qui s'excuse, Régigigas relevé de sa consigne — existaient.

**Mais le donjon qui mène à ces boss, non.** Tout l'arc 7-10 reposait sur des
étages procéduraux impossibles à construire.

### La correction

Méthode : cloner le squelette de **`gloomy_forest`** — donjon d'histoire
complet, fonctionnel, à structure identique (5 segments, relais, boss) — puis
l'adapter par biome. Le squelette compte **20 `GenSteps`** : `MapDataStep`,
`InitGridPlanStep`, `GridPathBranch`, `DrawGridToFloorStep`,
`FloorStairsStep`, `MobSpawnSettingsStep`, `MapTextureStep`,
`PlaceRandomMobsStep`, les `ScriptGenStep`…

Adaptation par donjon :

| donjon | musique | tileset | élément | météo par étage |
|---|---|---|---|---|
| Aegis Cave | `Deep Dark Crater` | `western_cave_1` | rock | clear ×3, **sandstorm** |
| Sanctuaire de Cristal | `Crystal Cave` | `crystal_cave_1` | ice | clear ×4 |
| Marais Oublié | `Murky Cave` | `murky_cave` | water | clear ×2, **rain** ×2 |
| Pic Céleste | `Sky Tower` | `sky_tower` | flying | clear ×2, **falling_ash** ×2 |

**Toutes les musiques et tous les tilesets sont attestés** ailleurs dans le
dépôt (vérifié par comptage : `sky_tower_floor` ×43, `murky_cave_secondary`
×108, etc.). Aucune ressource inventée.

**Résultat : 0 étage vide dans tout le dépôt.**

---

## 2. LA PLUIE DE CENDRES — particule originale New Era

### Pourquoi pas de la neige

Le Pic Céleste n'est pas une montagne froide : c'est un sommet battu par une
tempête. Ce qui tombe n'est pas de la neige, c'est de la **cendre pâle
soulevée par le vent**. Le joueur doit comprendre, rien qu'en regardant
l'écran, que quelque chose brûle plus bas.

### Le format `.dir` décodé

Aucune documentation ne le donne. Je l'ai reconstitué en analysant les assets
existants du dépôt :

```
[ uint32 LE : taille du PNG ][ uint32 LE : 0 ]
[ PNG complet ]
[ frameW, frameH, LocHeight, frameCount   (uint32 LE) ]
```

Vérifié sur `Steam.dir` (128×128, 1 frame) et `Slugma_Materialize.dir`
(1472×64, frames de 64×64).

### `Ash_Fall.dir` — création originale

**12 frames de 16×16**, générées par script :

- **frames 0-7 — la chute.** Dérive latérale en sinus (la cendre ne tombe pas
  droit), scintillement d'alpha, courte traînée derrière chaque flocon.
- **frames 8-11 — l'impact.** Un anneau de poussière qui s'élargit et
  s'efface au sol.

Ce découpage n'est pas arbitraire : `ScreenRainEmitter` prend **deux**
animations, `Anim` pour la chute et `ResultAnim` pour l'impact. La particule
a été dessinée pour ce contrat précis.

### `falling_ash` — le MapStatus

Construit à partir de **notre** `blowing_wind` (structure déjà validée en
jeu, même version de format), en remplaçant seulement l'émetteur :

```json
{ "$type": "RogueEssence.Content.ScreenRainEmitter",
  "Anim":       { "AnimIndex": "Ash_Fall", "StartFrame": 0, "EndFrame": 7  },
  "ResultAnim": { "AnimIndex": "Ash_Fall", "StartFrame": 8, "EndFrame": 11 },
  "Layer": 4, "ParticlesPerBurst": 2, "BurstTime": 14,
  "HeightSpeed": -70, "SpeedDiff": 40 }
```

`HeightSpeed` négatif = chute. `SpeedDiff` 40 = toutes les cendres ne tombent
pas à la même vitesse. Nom FR : **« Pluie de Cendres »**.

### Posé par `DefaultMapStatusStep`

La deuxième brique de l'étude. Elle applique un `MapStatus` **à la
génération**, avec une liste tirée par étage — exactement le mécanisme de
`ShimmeringZoneStep` du dungeon-pack, et déjà employé par `antre_enigme` dans
ce dépôt.

Sur le Pic : les deux premiers étages sont clairs, puis la cendre commence à
tomber. L'ascension devient visiblement plus hostile à mesure qu'on monte —
sans une ligne de dialogue pour l'expliquer.

---

## 3. Ce que ça change pour le joueur

Avant ce lot, l'arc 7-10 était une suite de cinématiques reliées par des
donjons qui ne pouvaient pas se générer. Maintenant :

- les **14 étages existent**, avec leur identité propre — la pierre corrompue
  des Ruines, le bleu des galeries de cristal, la boue du Marais, le ciel
  ouvert du Pic ;
- **la météo raconte** : la tempête de sable qui monte dans les Ruines, la
  pluie du Marais, la cendre du Pic ;
- rien de tout cela n'est dit au joueur. Il le **voit**.

---

## Validation

Lua **646/646** · `.resx` **576/576** · zones + index **208/208** ·
MapStatus **7/7 sans écart** · BOM préservé sur les 4 zones ·
`verify_legend`, `verify_bg_format`, `verify_scene_positions`,
`validate_all` : tous au vert.

`Ash_Fall.dir` relu avec la même logique que `tools/verify_bg_format.py` :
en-tête cohérent avec la taille réelle du PNG, grille 12×1 = 12 frames.

`Data/MapStatus/index.idx` : patch **chirurgical** (11 lignes ajoutées,
indentation d'origine à 1 espace préservée) après un premier essai qui
reformatait tout le fichier — annulé par `git checkout`.

## Non testé

**Rien n'est testé en jeu.** Points à vérifier en priorité :

- **Le rendu de `Ash_Fall`** : c'est une particule dessinée par script, sans
  aperçu visuel possible ici. Densité (`ParticlesPerBurst` 2, `BurstTime` 14)
  et vitesse (`HeightSpeed` -70) sont des valeurs de départ à ajuster à l'œil.
- **La génération des 14 étages** : le squelette est cloné d'un donjon qui
  marche, mais chaque tileset a ses contraintes de rendu (`LoadBlobStep`,
  `MapTextureStep`). Un tileset mal apparié donne des murs incohérents.
- Les 4 donjons n'avaient **jamais pu être parcourus** avant ce correctif.
