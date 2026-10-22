# Audit canonique — Grounds, Roads, Entrances, Boss Arenas, architecture spatiale

Date : 2026-08-02 — branche `new-era-1-9`
Référentiels : `Minemaker0430/ExplorersOfSkyOrigins` (main, 878 blobs) et
`audinowho/PMDODump` (master, 172 blobs), lus par l'arbre Git — aucun clone
(EoSO = 1,3 Go, hors budget sandbox).
Outils produits : `tools/audit_roads_eoso.py`, `tools/audit_import_fidelite.py`.

Toute ligne ci-dessous est adossée à un fichier lu. Ce qui n'a pas été vérifié
est signalé comme tel.

---

## Synthèse

L'import du lot Explorers est **fidèle sur la géométrie et infidèle sur tout
le reste**. Les cartes sont copiées au bit près ; les scripts, les PNJ et les
liaisons ont été jetés.

| Dimension | Verdict |
|---|---|
| Géométrie / collisions / tilesets | **conforme** — 25 cartes comparées, écarts nuls sauf 2 cas |
| Entités (PNJ, objets, marqueurs) | **massivement perdues** — voir §2 |
| Scripts | **11 514 lignes canoniques → 671 importées (5,8 %)** |
| Roads | **0 sur 63 branché** côté New Era |
| Enregistrement moteur | 105 grounds sur 277 déclarés nulle part |

---

## 1. Origine des grounds — confirmée

277 grounds dans New Era. 82 ont une origine Explorers documentée
(`vague4_sloth_import_total.md`). J'ai confronté chaque nom source à l'arbre
d'EoSO :

- **81 / 82 sources existent réellement** dans `Data/Ground/` d'EoSO.
- **1 anomalie** : `vision_ouverture` déclaré importé de `intro_cutscene` —
  **ce ground n'existe pas dans EoSO** (404). Sa provenance est donc fausse ou
  le fichier vient d'ailleurs. Sa carte est vide (0 tuile dessinée), ce qui est
  cohérent avec un ground fabriqué de toutes pièces.

**14 grounds EoSO n'ont jamais été importés**, tous du bloc intérieur de la
guilde : `guild_bedroom`, `guild_bedroom_night`, `guild_dining_hall`,
`guild_dining_hall_night`, `guild_entrance`, `guild_gate_view`,
`guild_guildmaster_chambers`, `guild_guildmaster_chambers_night`,
`guild_second_floor`, `krabby_scene_a`, `krabby_scene_b`, `sentry_hole`,
`sunset_view`, `demo_room`.

C'est cohérent : New Era possède sa propre guilde intérieure (Metano). Mais cela
signifie que **le bloc guilde importé est amputé** — on a le parvis et le
sous-sol, pas les étages ni le poste de garde (`sentry_hole`) qui les relie.

## 2. Fidélité de l'import — 25 cartes comparées une à une

Méthode : téléchargement de la source EoSO et de la cible New Era, comparaison
grille / collisions / tuiles / tilesets / entités.

**9 cartes sur 25 sont strictement identiques à leur source.** Les 16 autres ont
perdu des entités. Extraits :

| Ground NEA | Source | Ce qui a été perdu |
|---|---|---|
| `bourg_comptoir` | `treasure_town` | **18 PNJ**, 11 objets, 4 spawners, **3 marqueurs de transition** |
| `guilde_sous_sol` | `guild_basement` | **10 PNJ** (Chatot, Wigglytuff, Loudred, Sunflora, Croagunk, Diglett, Dugtrio, Bidoof, Chimecho, Corphish), 9 objets, 5 marqueurs |
| `carrefour_assemblee` | `crossroads_assembly` | 2 PNJ, **4 entrées** (`TreasureTownEntrance`, `GuildOutsideEntrance`, `CrossRoadsSouthEntrance`, `DungeonEntrance`), 3 marqueurs |
| `guilde_parvis` | `guild_outside` | Bidoof, `GuildEntrance`, `CrossRoadsEntrance`, 2 marqueurs |
| `dojo_ossatueur` | `marowak_dojo` | Marowak, l'entrée du donjon, la sortie, 2 marqueurs |
| `carrefour_sud` | `crossroads_south` | `BeachEntrance`, `CrossRoadsAssemblyEntrance`, 2 marqueurs |
| `cap_dents_mer` | `habitat_sharpedo_bluff_day` | `TreasureTownEntrance`, panneau, 2 spawners |
| `plage_crepuscule` | `dusk_beach` | **Grovyle**, **Wigglytuff**, 3 marqueurs de caméra |
| `rite_ame` | `personality_test` | **20 objets** (tout le dispositif d'aura et de nœuds) |
| `falaise_trempee_porte` | `drenched_bluff_entrance` | Spoink ; **collisions 1660 → 1658** (2 cases modifiées) |
| `grotte_plage_fond` | `beach_cave_pit` | **tuiles 8 740 → 380** — le décor a été écrasé |

Deux cas méritent attention particulière :

- **`grotte_plage_fond`** : 8 740 tuiles source contre 380 importées. La carte a
  été vidée de son décor, pas seulement de ses entités.
- **`falaise_trempee_porte`** : deux cases de collision diffèrent de la source.
  Micro-écart, mais il prouve que la grille a été retouchée quelque part.

### Correction d'une conclusion de mon rapport précédent

Dans `VERIF_TREASURE_TOWN_2026-08-02.md` j'ai signalé comme défaut d'import les
grounds à 100 % franchissable (`guilde_parvis_nuit`, `guilde_sous_sol_nuit`,
`sanctuaire_titans_entree`, `statue_colosse_magma`, `carte_chapitre_v2`,
`ecran_titre_v2`, `source_chaude`…). **C'était un faux positif.**

Vérification faite : `guild_outside_night` a **0 case bloquée dans EoSO
lui-même**. Idem `chapter_card`, `title_catch`, `aegis_cave_entrance`,
`deep_aegis_cave_regigigas_boss_arena`. L'import est fidèle ; c'est la source
qui n'a pas de collisions, parce que ces cartes sont des **écrans de cinématique
où le joueur ne se déplace pas** (`guild_outside_night/init.lua` : un `FadeIn`
et rien d'autre).

En revanche `hot_spring` → `source_chaude` est bloqué à 94 % dans les deux, et
`spinda_cafe` → `cafe_toupie` à 86,1 % dans les deux : là les collisions
existent bien. La règle §8 « aucune zone walkable par défaut » ne peut donc pas
être appliquée mécaniquement : **il faut distinguer carte jouable et carte de
cinématique**, exactement comme le fait EoSO.

## 3. Roads — le graphe canonique existe, il n'est pas branché

J'ai extrait les transitions de tous les `init.lua` d'EoSO et vérifié que chaque
destination et chaque marqueur existent dans les `.rsground` source :

> **63 transitions, 28 grounds, 0 anomalie.** Le graphe EoSO est intègre.

Réseau canonique du hub :

```
treasure_town ──> habitat_sharpedo_bluff_day  @ TreasureTownEntranceMarker
treasure_town ──> marowak_dojo                @ MarowakDojoExitMarker
treasure_town ──> crossroads_assembly         @ TreasureTownEntranceMarker
crossroads_assembly ──> treasure_town         @ CrossRoadsAssemblyEntranceMarker
crossroads_assembly ──> guild_outside         @ CrossRoadsEntranceMarker
crossroads_assembly ──> crossroads_south      @ CrossRoadsAssemblyEntranceMarker
crossroads_south ──> beach                    @ Entrance
crossroads_south ──> crossroads_assembly      @ CrossRoadsSouthEntranceMarker
beach ──> crossroads_south                    @ BeachEntranceMarker
guild_outside ──> crossroads_assembly         @ GuildOutsideEntranceMarker
guild_outside ──> guild_basement              @ Ladder
guild_basement ──> guild_outside              @ GuildEntranceMarker
guild_basement ──> guild_second_floor         @ Entrance / EntranceBasement
habitat_sharpedo_bluff_day ──> treasure_town  @ HabitatSharpedoBluffDayEntranceMarker
marowak_dojo ──> treasure_town                @ MarowakDojoEntranceMarker
```

Toutes ces liaisons sont **bidirectionnelles et cohérentes** dans EoSO.

**Côté New Era : aucune de ces transitions n'existe.** Les objets qui les
portaient (`CrossRoadsAssemblyEntrance`, `MarowakDojoEntrance`,
`HabitatSharpedoBluffDayEntrance`, `GuildEntrance`, `BeachEntrance`…) ont été
supprimés à l'import, et les scripts qui les déclenchaient n'ont pas été repris.
Les 15 cartes du lot sont donc des **îlots sans entrée ni sortie**.

Seule exception : `bourg_comptoir` est atteignable, via une invention New Era
(Loaklass depuis `altere_pond`), pas via le réseau canonique.

## 4. Entrances et Boss Arenas — la règle est respectée par EoSO, à ne pas violer

Votre consigne est exactement conforme à ce que montrent les données. Sur les
95 grounds EoSO, **seuls 37 ont un script**. Les 58 autres sont des cartes
d'entrée ou d'arène **sans logique propre**, pilotées par la zone.

Cela confirme qu'il ne faut **pas** ajouter d'Entrance ni d'Arène là où le jeu
d'origine n'en a pas. Exemples relevés :

- `aegis_cave_entrance` et `deep_aegis_cave_regigigas_boss_arena` : présents
  dans EoSO, **sans script**, sans collisions. Ce sont des décors de transition.
- `mt_bristle_peak` a un script (65 l.), `mt_bristle_entrance` n'en a pas.
- `hot_spring`, `spinda_cafe`, `crossroads` : pas de script côté EoSO non plus.

Conséquence pratique : pour ces cartes, l'absence de script dans New Era **n'est
pas une anomalie**. L'anomalie porte uniquement sur les 23 cartes dont la source
EoSO **a** un script conséquent qui n'a pas été repris (§5).

## 5. Perte de scripts — le chiffre central

Pour chaque ground importé dont la source EoSO possède un `init.lua` :

| Ground NEA | Source | Lignes source | Lignes NEA |
|---|---|---:|---:|
| `guilde_sous_sol` | `guild_basement` | **3 726** | 19 |
| `plage_crepuscule` | `dusk_beach` | **1 469** | 32 |
| `bourg_comptoir` | `treasure_town` | **1 376** | 214 |
| `rite_ame` | `personality_test` | **1 266** | 19 |
| `guilde_parvis_soir` | `guild_outside_dusk` | **544** | 32 |
| `grotte_plage_fond` | `beach_cave_pit` | 455 | 32 |
| `falaise_trempee_porte` | `drenched_bluff_entrance` | 446 | 19 |
| `falaise_trempee_fond` | `drenched_bluff_end` | 361 | 19 |
| `tempete_vision_b` | `storm_cutscene_b` | 227 | 19 |
| `tempete_vision_c` | `storm_cutscene_c` | 168 | 19 |
| `tempete_vision_a` | `storm_cutscene_a` | 165 | 19 |
| `plage_lucioles` | `beach` | 159 | 19 |
| `carrefour_assemblee` | `crossroads_assembly` | 158 | 19 |
| `guilde_sous_sol_nuit` | `guild_basement_night` | 158 | 19 |
| `guilde_parvis` | `guild_outside` | 135 | 19 |
| `carte_chapitre_v2` | `chapter_card` | 131 | 19 |
| (7 autres) | | | |
| **TOTAL** | | **11 514** | **671** |

Le « 19 » qui revient est le squelette autogénéré : `Init`, `Enter` avec un
`FadeIn`, `Update` vide.

Les trois `storm_cutscene_*` sont particulièrement significatifs pour votre
demande sur **l'arc de la Météorite** : ce sont les visions de tempête
canoniques, 560 lignes de mise en scène au total, importées à 57 lignes de
squelette. Le contenu existe dans EoSO et est récupérable.

## 6. Arc du Fugitif et arc de la Météorite

- **Arc du Fugitif** : 37 occurrences, dont 34 dans `metano_town_ch_7.lua`.
  `SV.Chapter12` n'existe pas dans `scriptvars.lua`. L'arc est à l'état de plan
  (`CHAPITRE12_PLAN_COMPLET_ARC_FUGITIF.md`), pas d'implémentation. Les Roads,
  Grounds et Entrances de la fuite ne sont pas en place.
- **Arc de la Météorite** : 39 occurrences réparties sur 12 fichiers, avec une
  zone dédiée `zone/grotte_meteore/init.lua`. Existe donc partiellement.
- **Xatu** : 298 occurrences dans `metano_town_ch_7.lua`, 36 dans
  `colline_anciens`. Le personnage est très présent — mais **il n'est pas dans
  la table `characters` de `CharacterEssentials.lua`**, ce qui est le schéma
  exact du bug Goinfrex corrigé précédemment (scène qui plante en silence sous
  `pcall`). **À vérifier en priorité.**

Note de méthode : `metano_town_ch_7.lua` fait 6 844 lignes, 387 fonctions,
2 327 dialogues. Il contient 10 variantes de discussion pour ~30 PNJ. C'est le
gisement de dialogue le plus dense du projet et il est déjà écrit.

## 7. PNJ manquants dans `CharacterEssentials`

Sur les 18 PNJ canoniques de Treasure Town, **4 seulement** sont déclarés
(`Kangaskhan`, `Kecleon`, `Murkrow`, `Marill`). Les 14 autres —  dont `Xatu`,
`Bidoof`, `Drowzee`, `Wigglytuff`, `Chatot`, `Loudred`, `Marowak` — ne le sont
pas. Toute scène qui les invoque échouera silencieusement sous `pcall`.

## 8. Adaptation temporelle — 10/15 ans après

Positions canoniques des 18 PNJ extraites et sauvegardées dans
`reference/eoso/treasure_town_npcs.json` (coordonnées, direction, trigger,
espèce). 16 sur 18 sont sur une case franchissable ; les 4 à Y négatif
(`Marill`, `Azurill`, `Bidoof`, `Drowzee`) sont hors écran, positionnés par
script au moment des scènes du chapitre 3 — comportement normal.

Proposition d'évolution, **12 PNJ sur 18 changent** :

| PNJ | Espèce EoSO | 10/15 ans après | Remarque |
|---|---|---|---|
| Bidoof | bidoof | **bibarel** | le plus fort potentiel narratif : le maladroit devenu sûr de lui |
| Azurill | azurill | **marill** | |
| Marill | marill | **azumarill** | la fratrie a grandi ensemble |
| Drowzee | drowzee | **hypno** | attention : c'était le ravisseur d'Azurill |
| Duskull | duskull | **dusclops** | |
| Shuppet | shuppet | **banette** | |
| Wurmple | wurmple | **beautifly** | |
| Seedot | seedot | **nuzleaf** | |
| Pidgey | pidgey | **pidgeot** | |
| Corphish | corphish | **crawdaunt** | |
| Vigoroth | vigoroth | **slaking** | |
| Murkrow | murkrow | ~~honchkrow~~ | **impossible** : `honchkrow` n'existe pas dans le projet (déjà établi). À garder Murkrow ou basculer sur `mandibuzz`. |
| Kangaskhan, Kecleon ×2, Electivire, Swellow, Xatu | — | inchangés | pas d'évolution ou stade final |

Vérification de disponibilité dans `mission_gen.lua` (461 espèces) :
`bibarel`, `nuzleaf`, `pidgeot`, `banette`, `dusclops`, `slaking`, `crawdaunt`,
`hypno`, `electivire`, `xatu`, `swellow`, `bidoof` sont **disponibles**.
`azumarill`, `beautifly`, `marill`, `kangaskhan`, `murkrow`, `honchkrow` n'y
figurent pas — à confirmer dans l'index des espèces du jeu de base avant usage
(`mission_gen` n'est pas la liste exhaustive du moteur, c'est une sélection).

## 9. Plan de branchement canonique proposé

Ordre de dépendance, du socle vers le contenu.

**Étape 1 — restaurer les entités perdues.** Réinjecter dans les `.rsground` New
Era les objets, marqueurs et spawners supprimés, en reprenant les coordonnées
exactes des sources EoSO. Sans marqueurs, aucun Road n'est branchable. Purement
mécanique, aucun arbitrage.

**Étape 2 — rebrancher les 63 Roads** selon le graphe du §3, en renommant les
cibles (`treasure_town` → `bourg_comptoir`, `guild_outside` → `guilde_parvis`…).
Le graphe étant prouvé intègre côté source, la seule difficulté est le renommage.

**Étape 3 — déclarer les 15 cartes dans `master_zone`** puis resynchroniser
`Data/Zone/index.idx`. Actuellement 105 grounds sur 277 ne sont déclarés nulle
part.

**Étape 4 — corriger les 4 points de dépôt de `bourg_comptoir`** (bug déjà
documenté : marqueur d'entrée et cibles de déplacement dans un mur). L'étape 1
le résout en partie puisqu'elle réinstalle les vrais marqueurs canoniques, qui
eux sont sur des cases libres — je l'ai vérifié :
`CrossRoadsAssemblyEntranceMarker` (1116, 203), `MarowakDojoEntranceMarker`
(968, 340), `HabitatSharpedoBluffDayEntranceMarker` (19, 193) : **tous libres**.

**Étape 5 — déclarer les 14 PNJ manquants** dans `CharacterEssentials`, avec les
espèces évoluées du §8.

**Étape 6 — porter les scripts.** 11 514 lignes de source disponibles. Les
dialogues sont à réécrire pour New Era (contexte, dix ans plus tard, règles de
non-nommage), mais la structure de mise en scène — caméras, déplacements,
timings, déclencheurs — est directement transposable et c'est le plus coûteux à
produire de zéro.

## 10. Ce que je n'ai pas encore fait

Par honnêteté, le périmètre demandé est plus large que ce que couvre ce
document. Restent ouverts :

- La comparaison des **252 grounds hors lot Explorers** (origine Rescue Team ou
  création New Era) — non traitée ici.
- La **continuité spatiale inter-cartes** (raccords de reliefs, orientation des
  falaises, cohérence des chemins) : je n'ai vérifié que la connectivité
  logique, pas la crédibilité visuelle des raccords.
- Les **musiques et backgrounds** par ground : vérifiés présents pour le lot
  Treasure Town, pas au-delà.
- L'audit **fidélité des cinématiques existantes** ligne à ligne contre EoSO.
- Le **détail de l'arc Météorite** dans `zone/grotte_meteore`.

Et le rappel habituel : **rien n'est testé manette en main**. Tout ce qui
précède est de la lecture de fichiers, y compris les blocages annoncés.
