# Vérification de la revendication « Treasure Town importé et opérationnel »

Date : 2026-08-02 — branche `new-era-1-9`
Méthode : lecture directe des `.rsground`, des `.lua`, de `master_zone.json`,
de `Content/Tile/index.idx` et de `Data/Zone/index.idx` sur le dépôt distant.
Aucune affirmation ci-dessous n'est déduite d'un nom de fichier.

## Verdict en une ligne

**Faux.** Treasure Town est **importé** (la carte, les tilesets et la musique
existent réellement) mais **n'est pas opérationnel** : la seule carte branchée,
`bourg_comptoir`, dépose le joueur et son partenaire **dans un mur**, et son
marqueur d'entrée est lui aussi bloqué. Les 15 autres cartes du lot Treasure
Town / Guilde sont des coquilles vides.

---

## 1. Ce qui est réellement présent

| Élément | État vérifié |
|---|---|
| `Data/Ground/bourg_comptoir.rsground` | présent, 144×63 cellules (1152×504 px), TexSize 3 |
| Tilesets `TreasureTownEast` / `TreasureTownWest` | présents (582 764 et 462 703 o), **référencés 1× chacun** dans `Content/Tile/index.idx` |
| Décor peint | 4 032 tuiles posées (2 352 East + 1 680 West) — la carte n'est pas vide |
| Musique `Treasure Town.ogg` | présente dans `Content/Music/`, assignée au ground |
| Collisions | 23,6 % de cases libres, **6 composantes** ; la principale fait 2 090 cases |
| `master_zone.GroundMaps[52]` | `bourg_comptoir` — la carte est bien déclarée |
| `Data/Zone/index.idx` | contient `bourg_comptoir` |
| `SV.Chapter11` | déclaré dans `scriptvars.lua` : `ShowedTitleCard`, `FinishedTreasureTownIntro` |
| Scénario | `bourg_comptoir_ch_11.lua` (115 l.) + `altere_pond_ch_11.lua` (traversée avec Loaklass) écrits et cohérents avec `AUDIT_INTEGRATION_NARRATIVE_TREASURE_TOWN.md` |
| Bascule ch10 → ch11 | `ground/autel_celeste/init.lua` : `SV.ChapterProgression.Chapter = 11` |

La revendication « importé » est donc **exacte**. Celle d'« opérationnel » ne l'est pas.

## 2. Bug bloquant — le joueur arrive dans un mur

Grille de collision de `bourg_comptoir` : 144×63 cellules de 8 px.
Une cellule est franchissable si `Tags == 0`.

| Point de dépôt | Source | Cellule | État réel |
|---|---|---|---|
| `Main_Entrance_Marker` (256, 300) | entité de la carte | (32, 37) | **BLOQUÉ** |
| hero fin de cinématique (280, 320) | `bourg_comptoir_ch_11.lua` | (35, 40) | **BLOQUÉ** |
| partner fin de cinématique (256, 320) | idem | (32, 40) | **BLOQUÉ** |
| Loaklass (216, 360) | idem, ×2 (cinématique + `SetupGround`) | (27, 45) | **BLOQUÉ** |
| hero arrivée (280, 368) | idem | (35, 46) | libre |
| partner arrivée (256, 368) | idem | (32, 46) | libre |
| hero `SetupGround` (272, 360) | idem | (34, 45) | libre |

Deux conséquences distinctes, toutes deux fatales :

1. **`GAME:EnterGroundMap("bourg_comptoir", "Main_Entrance_Marker")`** est appelé
   deux fois — `altere_pond_ch_11.lua` (fin de la traversée) et
   `altere_pond_ch_11.Lapras_Action` (allers-retours). Le marqueur visé est dans
   un mur : le joueur est déposé hors zone franchissable dès la première arrivée.
2. **Le `MoveToPosition` final de la cinématique** vise (280, 320) et (256, 320),
   également bloqués. Le duo ne peut pas atteindre sa cible ; la cinématique se
   fige ou le pathfinding échoue avant `GAME:CutsceneMode(false)`.

La zone libre la plus proche de chaque point :

| Point | Cellule libre la plus proche | Distance |
|---|---|---|
| `Main_Entrance_Marker` (256, 300) | (292, 284) | 4,5 cellules |
| hero fin (280, 320) | (316, 324) | 4,0 cellules |
| partner fin (256, 320) | (276, 364) | 5,4 cellules |
| Loaklass (216, 360) | (220, 372) | 1,0 cellule |

Géométrie utile de la carte : la grande allée traversante est à **y ≈ 184 px**
(144 cellules libres d'affilée, de x=0 à x=143). Le centre de la composante
principale est autour de **(688, 224) px**. Les scripts, eux, travaillent tous
autour de x≈216-280, y≈300-370 — c'est-à-dire dans le **quart sud-ouest**, la
partie la plus cloisonnée de la carte. Les coordonnées ont visiblement été
écrites sans jamais consulter la grille de collision.

## 3. Le reste du lot Treasure Town n'est pas branché du tout

| Ground | master_zone | init.lua | Marqueurs | Collisions | Décor |
|---|---|---|---|---|---|
| `bourg_comptoir` | **52** | 99 l. + scène ch11 | 1 (bloqué) | 23,6 % libre | 4 032 tuiles |
| `plage_lucioles` | absent | 19 l. squelette | `Entrance`, `CutsceneEntranceA` | 19,9 % libre | 4 753 |
| `plage_crepuscule` | absent | 32 l. | 3 (dont `C1S1_PlayerSpawn`) | **100 % libre** | 14 256 |
| `cafe_toupie` | absent | 19 l. squelette | 1 (`NewObject`) | 13,9 %, **3 zones** | 5 794 |
| `cap_dents_mer` | absent | 19 l. squelette | 1 (`NewObject`) | 13,2 % | 26 482 |
| `dojo_ossatueur` | absent | 19 l. squelette | **0** | 12,8 % | 1 527 |
| `dojo_ossatueur_final` | absent | 19 l. squelette | **0** | 8,5 % | 1 020 |
| `guilde_parvis` | absent | 19 l. squelette | **0** | 9,9 % | 1 390 |
| `guilde_parvis_soir` | absent | 32 l. | 6 (`CH1_*`, `CamPos_1`) | **100 % libre** | 1 390 |
| `guilde_parvis_nuit` | absent | 19 l. squelette | **0** | **100 % libre** | 1 424 |
| `guilde_sous_sol` | absent | 19 l. squelette | **0** | 22,7 %, 2 zones | 501 |
| `guilde_sous_sol_nuit` | absent | 19 l. squelette | **0** | **100 % libre** | 506 |
| `carrefour_nord` | absent | 19 l. squelette | **0** | 32,2 % | 3 078 |
| `carrefour_sud` | absent | 19 l. squelette | **0** | 23,1 % | 2 974 |
| `carrefour_assemblee` | absent | 19 l. squelette | **0** | 32,2 % | 3 610 |

Le squelette de 19 lignes est strictement identique partout :

```lua
function guilde_parvis.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_parvis")
  COMMON.RespawnAllies()
end
function guilde_parvis.Enter(map)  GAME:FadeIn(20)  end
function guilde_parvis.Update(map, time) end
```

Aucune boîte de dialogue, aucun PNJ, aucune sortie, aucune entrée. Ces cartes
ne sont atteignables par **aucun** `EnterGroundMap` du dépôt (vérifié sur les
692 fichiers `.lua` de `Data/Script/`).

### Sur les grounds de guilde précisément

Votre lecture est exacte : `guilde_parvis`, `guilde_parvis_soir`,
`guilde_parvis_nuit`, `guilde_sous_sol`, `guilde_sous_sol_nuit` proviennent bien
du même lot Explorers que Treasure Town (`vague4_sloth_import_total.md` :
`guild_outside`, `guild_outside_dusk`, `guild_outside_night`, `guild_basement`,
`guild_basement_night`). Ce sont les **abords et le sous-sol de la guilde de
Grodoudou**, pas la guilde de Metano — laquelle a ses propres grounds
(`guild_heros_room`, `guild_first_floor`, etc., indices 2 à 27 de `master_zone`),
tous actifs et sans rapport avec ce lot.

`guilde_parvis_soir` est le seul du lot à contenir une vraie mise en scène
importée : Koffing, Zubat, le `RelicFragment` et six marqueurs `CH1_*` — c'est
la scène du vol du fragment au crépuscule, telle quelle depuis Explorers.

## 4. Défaut structurel : les variantes soir/nuit ont perdu leurs collisions

Trois paires jour/nuit partagent exactement la même grille et le même décor,
mais la variante n'a **aucune** collision :

| Paire | Grille | Cases bloquées (jour) | Cases bloquées (variante) |
|---|---|---|---|
| `guilde_parvis` → `guilde_parvis_nuit` | 60×51 | 2 756 | **0** |
| `guilde_parvis` → `guilde_parvis_soir` | 60×51 | 2 756 | **0** |
| `guilde_sous_sol` → `guilde_sous_sol_nuit` | 81×54 | 3 380 | **0** |

Les couches de tuiles sont identiques à un calque près (`Gate Open` / `Gate` /
`Gate Closed` ; `Closed Door` / `Door Closed`). La géométrie est donc la même :
la grille de collision de la version jour est directement transposable. C'est
une correction mécanique, sans arbitrage de design.

Le même défaut touche **36 des 105 grounds en réserve** (100 % franchissable, y
compris des murs et de l'eau peints), dont `plage_crepuscule`,
`sanctuaire_titans_entree`, `statue_colosse_magma`, les trois `tempete_vision_*`.
Cela contredit la règle §8 du guide cutscenes (« Aucune zone n'est walkable par
défaut ») et l'affirmation « Zéro walkability par défaut » du §3.C de
`AUDIT_INTEGRATION_NARRATIVE_TREASURE_TOWN.md`.

## 5. Écart entre le document de conception et le code

`AUDIT_INTEGRATION_NARRATIVE_TREASURE_TOWN.md` décrit un plan en 4 actes.
Confrontation :

| Spécification | Réalité |
|---|---|
| Acte 1 chez Penticus (`guild_guildmasters_room`) | **absent** — aucun code ch11 dans ce ground |
| Acte 2 à la cascade | **déplacé** : la scène se joue à `altere_pond` avec Relicanth, pas Tropius |
| Acte 3 traversée + fondu | **présent et conforme** |
| Acte 4 arrivée plage | **présent**, mais joué sur `bourg_comptoir` et non sur `plage_lucioles`/`plage_crepuscule` comme annoncé |
| « 15 PNJ uniques minimum » | **0 PNJ** — seuls 6 totems décoratifs et 1 marqueur |
| « 10 variantes de dialogue par PNJ » | **0** |
| « Job Board fonctionnel » | **absent** |
| « soumise à `verify_ground_registration.py` » | l'enregistrement est bon ; **les collisions n'ont jamais été testées** |

Le clin d'œil aux quinze ans est bien écrit et respecte la règle de non-nommage
(`altere_pond_ch_11.lua` : « un duo d'explorateurs que j'ai eu la chance de
transporter, il y a quinze ans de cela »). Le contenu narratif tient ; c'est
l'implantation spatiale qui n'a pas été faite.

## 6. Sur ExplorersOfSkyOrigins

Le lot importé ne vient **pas** de `Minemaker0430/ExplorersOfSkyOrigins` mais du
dépôt `slothplaysnecro` (82 grounds Explorers convertis, cf.
`vague4_sloth_import_total.md`). D'après le tableau de fin de ce même document,
EoSO n'a fourni que **6 tilesets** (Aegis + Steam). Si vous voulez récupérer la
géométrie de collision propre de Treasure Town depuis EoSO plutôt que de la
retracer à la main, c'est une piste à instruire séparément — je ne l'ai pas
encore ouverte et je ne veux rien affirmer dessus sans avoir lu leurs fichiers.

## 7. Ce qu'il faut faire, par ordre de coût croissant

1. **Déplacer les 4 points de dépôt de `bourg_comptoir`** vers la composante
   principale (coordonnées de repli calculées ci-dessus). Corrige le blocage dur.
   Effort : une passe de script sur le `.rsground` + 6 lignes de Lua.
2. **Transposer les collisions jour → nuit/soir** sur les 3 paires de la guilde.
   Purement mécanique.
3. **Retracer les collisions des 36 grounds à 100 % libre.** Long, mais sans
   arbitrage.
4. **Peupler Treasure Town** (15 PNJ, dialogues, job board) — c'est le gros du
   travail, et le gisement de boîtes de dialogue pour le quota du ch11
   (actuellement 19 / 7 000).
5. **Brancher les 14 autres cartes du lot** (parvis, sous-sol, carrefours, café,
   dojo, plages) : chacune a besoin d'un marqueur d'entrée, d'une sortie et
   d'une déclaration dans `master_zone`.

## Réserve d'honnêteté

Rien de ce qui précède n'a été testé manette en main. Les blocages annoncés sont
déduits de la grille de collision lue dans le fichier et des coordonnées lues
dans les scripts — c'est solide sur le fond, mais seul un lancement réel
confirmera le comportement exact du moteur (notamment si `EnterGroundMap` sur un
marqueur bloqué recale le joueur ou le laisse coincé).
