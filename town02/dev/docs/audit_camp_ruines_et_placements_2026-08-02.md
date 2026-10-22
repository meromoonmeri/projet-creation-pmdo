# Audit — Camp des Ruines, Colline des Anciens, Team Dazzling, Quizz de Kirlia

**Branche :** `arena/019fad83-new-era-abyss-to-ascension-v4`
**Base auditée :** `b526a68`
**Date :** 2026-08-02
**Build posé :** `2026-08-03-P`
**Statut :** correctifs appliqués et validés statiquement. **Rien n'est testé manette
en main** — le sandbox ne lance pas le jeu.

---

## 1. Pourquoi la cinématique du Camp des Ruines ne se lançait pas

### 1.1 Cause racine — ce n'était pas un problème de flags

Le réflexe était de suspecter les conditions de déclenchement. Elles sont
**correctes** : `mount_windswept_guardian_ch_5.lua:858` pose bien
`SV.Chapter5.RuinsCampPending = true` hors du `pcall`, et
`cloven_ruins_entrance/init.lua:91` lit bien ce flag pour lancer
`ArrivalCutscene()`.

Le défaut est ailleurs, un cran plus bas : **le joueur n'arrivait pas sur la carte
qui lit ces flags.**

`zone/cloven_ruins/init.lua` renvoyait vers `master_zone` ground **65**, en croyant
viser le camp. Le commentaire du code l'écrivait noir sur blanc :

```lua
--moitie des Ruines ramene au CAMPEMENT devant l'entree
--(cloven_ruins_entrance, ground 65)
```

Or, vérification faite dans `Data/Zone/index.idx` :

| index | ground réel |
|---:|---|
| 65 | **`vast_steppe_midpoint`** |
| 66 | **`mount_windswept_midpoint`** |
| **67** | **`cloven_ruins_entrance`** ← la cible voulue |
| **69** | **`cloven_ruins_midpoint`** ← le relais voulu |

Après un KO ou un abandon dans les Ruines, le joueur était donc déposé **au relais
de la Grande Steppe**. Le flag `PlayTempRuinsScene` restait posé, mais aucune carte
de la Steppe ne le lit : la scène ne se jouait jamais, et le drapeau restait
allumé pour une carte que le joueur n'atteignait pas.

Le bon nom, le mauvais numéro.

### 1.2 Le même défaut touche deux autres zones

En cherchant si le cas était isolé, j'ai trouvé **deux occurrences supplémentaires**
du même glissement d'index :

| Fichier | Index écrit | Ground réellement visé | Cible voulue |
|---|---:|---|---|
| `zone/cloven_ruins/init.lua` | 65 | `vast_steppe_midpoint` | `cloven_ruins_entrance` (67) |
| `zone/cloven_ruins/init.lua` | 66 | `mount_windswept_midpoint` | `cloven_ruins_midpoint` (69) |
| `zone/vast_steppe/init.lua` | 62 | `mount_windswept_guardian` | `vast_steppe_midpoint` (65) |
| `zone/mount_windswept/init.lua` | 63 | `crooked_cavern_midpoint` | `mount_windswept_midpoint` (66) |

Dans les trois cas, le symptôme est identique : le flag d'état
(`PlayTempRuinsScene`, `SteppeMidState`, `WindsweptMidState`) est posé, la scène de
réveil est écrite, et elle ne se déclenche pas parce que le joueur atterrit
ailleurs. **Les trois donjons du chapitre 5 étaient concernés.**

`searing_tunnel` utilise 47/48/49 — tous corrects. C'est la seule zone épargnée.

### 1.3 Origine probable

`master_zone.GroundMaps` compte 88 entrées. Chaque insertion d'une carte décale
tous les index suivants. Les commits de restructuration du ch5 (`e8ca019`,
`93a191d`, `19f9341`, `e41aa59`) ont ajouté des grounds ; les index écrits en dur
avant ces ajouts ont glissé sans que rien ne le signale. C'est le même mécanisme
que la désynchronisation d'`index.idx` corrigée par `b526a68`, sur un autre étage
de la chaîne.

### 1.4 Correctif : résolution par nom

Corriger trois nombres aurait rétabli le comportement aujourd'hui et laissé le
piège intact pour le prochain ajout de carte. J'ai donc introduit un résolveur
dans chacune des trois zones :

```lua
local function GROUND_IDX(name)
  local ok, idx = pcall(function()
    local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("master_zone")
    for ii = 0, zone.Grounds.Count - 1, 1 do
      if zone.Grounds[ii] == name then return ii end
    end
    return -1
  end)
  if not ok or idx == nil or idx < 0 then
    PrintInfo("[zone] ground introuvable dans master_zone : " .. tostring(name))
    return MASTER_FALLBACK   -- 1 = metano_town
  end
  return idx
end
```

**L'API est vérifiée contre la source du moteur**, pas supposée :
`RogueEssence/Data/ZoneData.cs:243-258` définit `ZoneEntrySummary` avec
`public List<string> Grounds;`, et `DataIndices[...]:Get(name)` retourne bien ce
type. Le patron `_DATA.DataIndices[...DataType.Zone]:Get(...)` est par ailleurs
attesté 4 fois dans `PartnerEssentials.lua`.

12 appels remplacés (3 + 6 dans `cloven_ruins`, 3 dans `vast_steppe`,
3 dans `mount_windswept`).

Simulation contre `index.idx` :

```
GROUND_IDX('cloven_ruins_entrance') = 67  -> cloven_ruins_entrance
GROUND_IDX('cloven_ruins_midpoint') = 69  -> cloven_ruins_midpoint
GROUND_IDX('vast_steppe_midpoint')  = 65  -> vast_steppe_midpoint
GROUND_IDX('mount_windswept_midpoint') = 66 -> mount_windswept_midpoint
```

**Non touché volontairement** : l'index 46 (`vast_steppe_entrance`) dans la branche
hors-ch5 de `cloven_ruins`. Le commentaire du code le désigne comme un vestige
assumé du ch7, et il pointe bien vers la carte nommée.

### 1.5 Outil de non-régression

`tools/verify_ground_targets.py` (nouveau) rapproche chaque index écrit en dur du
nom réellement présent à cette position dans `index.idx`, et signale les cibles
étrangères à la zone appelante. Il reste **60 signalements** hors périmètre de ce
lot : à trier zone par zone, un retour délibéré vers une autre zone étant
légitime.

---

## 2. Colline des Anciens — la localisation de Xatu était déjà bonne, la carte non

### 2.1 Vérification du placement demandé

**Aucune correction de localisation n'était nécessaire.** Le commit `5a5b4e4`
(2026-08-01) avait déjà déplacé Xatu de la Porte du Grand Canyon vers une Ground
dédiée. Vérifications :

- `ground/grand_canyon_porte/init.lua` : 19 lignes, aucune occurrence de « Xatu ».
  C'est une entrée de donjon nue, conforme au triptyque.
- `ground/colline_anciens/` existe, avec son propre `.rsground` et son script.
- Accès **exclusivement scripté** : le seul appel menant à cette carte est
  `zone/new_era_zone_07/init.lua:38`, dans `ExitSegment`, à la **première victoire
  seulement** (`SV.Reseau.VoiesOuvertes['new_era_zone_07']`). Aucune sortie de
  ground, aucun menu de destination n'y conduit. La règle canonique — pas d'accès
  libre — est respectée.

### 2.2 Ce qui n'allait pas : une couche d'entités de chambre à coucher

L'import de `5a5b4e4` a repris la **géométrie** correcte mais conservé la
**couche d'entités de `guild_heros_room`**, la chambre du héros à la Guilde.
La carte fait 30×20 tuiles (240×160 px) ; les entités venaient d'une carte de
44×44 :

| Entité | Position | Problème |
|---|---|---|
| `Main_Entrance_Marker` | (40, 200) | **hors carte** (H = 160 px) |
| `TEAMMATE_1` (spawner) | (8, 200) | **hors carte** |
| `Bedroom_Exit` | (0, 184) | hors carte, mobilier de chambre |
| `Book` | (288, 208) | **hors carte** (W = 240 px) |
| `entrance_1` | (0, 216) | hors carte |
| `Hero_Bed`, `Partner_Bed`, `Save_Point` | (172/228, 148) | mobilier de chambre |

La carte portait de surcroît le nom **« Your Room »** et la musique
**« Wigglytuff's Guild.ogg »**.

Le marqueur d'entrée hors des bornes est **exactement la classe de défaut corrigée
par `b526a68`** sur le relais du Mont Windsep (écran noir à l'arrivée).
`audit_bugs.py` signalait par ailleurs les 3 objets sans handler
(`Bedroom_Exit_Touch`, `Book_Action`, `Save_Point_Touch`) — muets en jeu.

### 2.3 La géométrie, elle, était juste

Analyse case par case des `obstacles` : deux composantes libres.

```
      0         1         2
      0123456789012345678901234567890
  0   ##############################
  1   #############...##############     <- eperon rocheux
  2   ###########.......############        19 cases, ISOLE
  3   ##########.........###########
  ...
  9   #########.####.....###########
 10   ########...............#######     <- plateau principal
 11   #####...................######        252 cases
 ...
 19   ..............................
```

Cette séparation **est conforme au script**, qui dit « sur l'éperon rocheux,
en face ». Xatu n'est pas approchable : il est vu, pas rejoint. Les tuiles et les
obstacles n'ont donc **pas été touchés** — la géométrie importée reste fidèle.

### 2.4 Correctifs appliqués

`tools/fix_colline_anciens_entities.py` (round-trip JSON prouvé, `indent=2` pour ce
fichier, BOM préservé) :

- suppression des 5 entités de mobilier de chambre ;
- `Main_Entrance_Marker` → (112, 144), `Dir8.Up` : le joueur arrive en bas du
  plateau et fait **face à l'éperon**, dans l'axe du regard ;
- spawner `TEAMMATE_1` → (96, 144), même plateau ;
- `Name` → « Hill of the Ancients », `Music` → `Sky Peak Prairie.ogg`
  (fichier vérifié présent dans `Content/Music/`).

Diff : **13 insertions, 171 suppressions**. Patch minimal, aucune tuile modifiée.

Le script du correctif comporte un garde qui **a servi** : ma première tentative
plaçait l'entrée en y=152, ce qui faisait déborder l'entité 16×16 sur la ligne 20
inexistante. Le script a refusé d'écrire.

Vérification après correctif :

```
Main_Entrance_Marker  (112,144) tile=(14,18) Tags=0
TEAMMATE_1            ( 96,144) tile=(12,18) Tags=0
libres=271  atteignables depuis l'entree=252  isolees=19 (l'eperon, voulu)
```

### 2.5 Réécriture de la scène

La scène de `d88ab68` avait plusieurs défauts réels :

| Défaut | Correction |
|---|---|
| Xatu placé en (120,60) — **case murale**, `Tags=1` | (112,16), au centre de l'éperon, 4 cases libres |
| Héros/partenaire en (140,120)/(100,120) : dos à l'éperon | (120,88)/(96,88), bord nord du plateau, face au nord |
| `GROUND:AddMapStatus("dream")` — **statut inexistant** (signalé par `audit_bugs`) | supprimé ; la transe passe par flashs + `ShakeScreen` |
| `SOUND:PlayBattleSE("EVT_Water_Splash")` — **SE inventé**, 0 occurrence ailleurs | `EVT_Emote_Startled_2` (5 usages attestés) |
| `GROUND:CharSetAnim(xatu, "Attack")` pour une transe | `"Charge"` (14 usages attestés) |
| Pas de fondu en première instruction | `GAME:FadeOut(false, 1)` posé d'abord, conforme au correctif du 07-30 |
| Aucune musique | `Sky Peak Prairie.ogg` |
| Xatu apparaît par `MakeCharactersFromList` en pleine vue | la **caméra** le révèle par un travelling de 60 frames : il était là depuis le début |
| `GameLoad` laissait le joueur bloqué sur une carte-couloir | renvoie vers la ville |

**Contenu narratif — ce que Xatu révèle et ce qu'il tait.**

Le mécanisme canonique est repris (un devin qui fixe le soleil, entre en transe,
voit). Le contenu est propre à New Era et articulé au fil rouge :

- il **confirme** ce que la Team Alakazam avance au ch7 — un titan de magma agi
  par une force extérieure — et donne la direction ;
- il est le **premier témoin extérieur** à percevoir la Voix du héros : « Tu portes
  une voix qui n'est pas la tienne. » Jusque-là, seuls le héros et le joueur le
  savaient ;
- il **refuse de nommer** : « Ce n'est pas à moi de le dire. Et il est trop tôt. »
  Il donne une méthode, pas une réponse : « Ne demandez pas ce que c'est. Demandez
  depuis quand. »

Aucun terme interdit avant l'arc 6 (« Necrozma », « Eternatus », « l'Abîme »,
« prison ») n'apparaît. Ni Rayquaza, ni la météorite, ni la Tour Céleste ne sont
évoqués : le twist du ch10 reste intact. Xatu bute sur l'ombre et se tait — ce
silence **est** le point de la scène.

Répliques : 1 à 2 phrases, sous 150 caractères hors `[pause=N]`. Corps sous
`pcall`, restauration de `CutsceneMode`/caméra/speaker garantie même en cas
d'échec, sortie assurée.

---

## 3. Quizz de Kirlia — placé au Café Spinda

Le commit `ee06be8` livrait 98 lignes de quiz avec son handler, mais **aucune
entité `Kirlia` n'existait sur aucune carte** (`grep -rl "Kirlia" Data/Ground/`
ne renvoyait rien ; les 113 entités de `metano_town.rsground` ne la contenaient
pas ; `CharacterEssentials` ne déclarait ni `Kirlia`, ni `Ralts`, ni `Gardevoir`).
Le contenu était injouable.

**Placement retenu : le Café Spinda**, conformément à la demande. C'est l'endroit
où l'on s'assoit pour réviser, et cela évite d'encombrer `metano_town`.

`tools/add_kirlia_cafe.py` :
- round-trip prouvé avant écriture (`metano_cafe` = `indent=0`, BOM préservé) ;
- position **(96, 168)**, salon gauche — validée : 4 cases à `Tags=0`, dans la
  composante accessible depuis `Main_Entrance_Marker`, sans chevauchement
  (marge 8 px) avec les 25 colliders existants ;
- `Dir8.Right` (6) : tournée vers la salle, pas vers le mur ;
- espèce `kirlia`, `Gender.Female`, entité construite à partir du schéma sérialisé
  de `Cafe_Owner` pour hériter exactement du format de cette version du moteur ;
- script idempotent, **96 insertions / 0 suppression**.

Le quiz a été **déplacé et réécrit** dans `ground/metano_cafe/init.lua` :

- handler unique `Kirlia_Action` sous `pcall`, avec restauration garantie ;
- **trois états** au lieu d'un : avant le ch8 elle révise et le tournoi n'est pas
  annoncé ; pendant le ch8 elle fait passer l'épreuve ; après, elle commente le
  score obtenu avec une réplique distincte par résultat ;
- `SV.Chapter8.QuizScore` n'est plus écrit qu'**après les trois réponses**, au
  verdict ;
- question 2 (Rayquaza / Tour Céleste) : lore vérifié comme **déjà établi** au ch5
  (`mount_windswept_entrance_ch_5.lua:5342`, « l'Arbitre du Ciel ») et rappelé au
  ch7. Aucune révélation prématurée ;
- dialogues resserrés au registre du personnage — une érudite sèche, pas
  enthousiaste.

Code mort retiré : 98 lignes dans `metano_town_ch_8.lua`, 5 lignes de routeur dans
`metano_town/init.lua`.

`SV.Chapter8.QuizScore` est désormais déclaré dans `scriptvars.lua` avec un
commentaire expliquant que `nil` est un **état initial valide et signifiant** (il
déclenche la proposition du quiz), et un garde ajouté dans `OnUpgrade` qui se
contente de garantir l'existence de la table `Chapter8` sans forcer le champ à
`false` — ce qui priverait le joueur du quiz.

---

## 4. Goinfrex — crash prouvé au Café

`metano_cafe/init.lua:702` et `:832` (commit `4e1d765`) appelaient
`MakeCharactersFromList({{'Goinfrex', ...}})` alors que la table `characters` de
`CharacterEssentials` (197 clés) ne contenait pas `Goinfrex`.

Preuve du comportement, simulée en Lua réel :

```
pcall(characters['Goinfrex'].species)
-> (False, "attempt to index a nil value (field '?')")
```

Le `pcall` de la ligne 80 empêchait le gel — la règle « toute scène sous `pcall` »
a fait son office. Mais `SV.metano_cafe.LastDailyCutsceneDay = day` était écrit
**ligne 691, avant** le crash ligne 702 : le jour était consommé sans que la scène
soit jouée. **2 des 7 scènes quotidiennes (28 % du cycle) ne s'affichaient jamais**,
silencieusement.

Deux correctifs :
1. `Goinfrex` déclaré dans `CharacterEssentials` (espèce `munchlax`, attestée dans
   `ground/personality_test/init.lua:188`) ;
2. `LastDailyCutsceneDay` déplacé **après** le corps de la scène — correctif de
   robustesse valable indépendamment du reste.

---

## 5. Team Dazzling — trois défauts de placement

La scène de `11c91bf` (2026-08-01) est bien déclenchée et bien écrite sur le plan
du rythme. Mais l'analyse géométrique de `gloomy_forest_entrance.rsground`
(75×75 tuiles, 600×600 px) révèle trois défauts matériels :

| # | Défaut | Preuve | Correctif |
|---|---|---|---|
| 1 | Partenaire à (328, 480) : **à cheval sur un mur** | tags des 4 cases de 8 px = `[1, 0, 1, 0]` | (296, 480), 4 cases libres |
| 2 | Trio Dazzling en (40,280)/(20,300)/(40,320) : cases libres mais dans une **poche isolée** du plateau d'entrée | BFS depuis `Main_Entrance_Marker` : non atteignables | (136,336)/(144,296)/(144,320), bord gauche accessible, hors champ caméra |
| 3 | Adagio marche vers (130, 270) : **pleine roche** | tags = `[1, 1, 1, 1]` | (152, 272) |

Le défaut 2 est le plus grave : les trois PNJ étaient dans une zone déconnectée,
donc `EightWayMove` ne pouvait pas les amener vers le duo — l'entrée en scène
comique ne se jouait pas, les trois restaient plantés.

Vérification après correctif : les **10 positions** de la scène (5 départs,
5 destinations) sont libres et dans la composante accessible.

*Note* : la scène pose `GROUND:AddMapStatus("clouds_overhead")`, statut absent de
`Data/MapStatus/`. Ce n'est **pas** un défaut de ce commit — le statut est utilisé
de longue date par 4 cartes dont `metano_town` et provient du jeu de base. Non
touché.

---

## 6. Nouvel outil : `verify_entity_handlers.py`

L'affaire Kirlia a révélé un angle mort : `audit_bugs.py` détecte les entités sans
handler (objet muet), mais **rien** ne détectait le sens inverse — un handler sans
entité, c'est-à-dire du contenu écrit et injouable.

L'outil croise les handlers `<map>.<Nom>_Action|_Touch|_Think|_EntSpawned` avec les
entités réellement présentes dans le `.rsground`, en tenant compte des quatre modes
de création légitimes : entité de carte, `MakeCharactersFromList` (listes
multi-lignes comprises), `MakeCharacterAtMarker`, `SpawnerDoSpawn`,
`GroundObject`/`GroundChar` construits par l'API, et personnages instanciés depuis
les **modules partagés** (`TownNight.lua`, `npc_routines.lua`…).

**Réglage du bruit.** La première version sortait 465 signalements, presque tous
faux. Conformément à la règle « corriger ses propres outils quand ils mentent »,
quatre passes de correction :

| Version | Signalements | Correction apportée |
|---|---:|---|
| v1 | 465 | regex ne captait que la 1ʳᵉ entrée d'une liste multi-lignes |
| v2 | 375 | catégorie B ramassait des tables d'objets (`xcl_element_fire_silk`…) |
| v3 | 95 | ignorait les modules partagés |
| v4 | 27 | confondait fonctions internes (`<map>_ch_5.Ganlon_Action`) et vrais handlers |
| **v5** | **14** | ajout de `GroundObject`/`GroundChar` |

**Test de non-régression** : sur le HEAD d'origine (`git stash`), l'outil détecte
bien les deux bugs réels pour lesquels il a été écrit —
`Kirlia_Action -> aucune entite « Kirlia »` et `« Goinfrex » absent de la table
characters`. Après correctifs, les deux ont disparu.

Les **14 restants** sont hors périmètre de ce lot (`Butterfree`,
`Kangaskhan_Rock`, `Passerby_1/2`, `Metapod`, `Silcoon`, `testmap`…) : à trier.

---

## 7. Mesures avant / après

| Contrôle | Avant (`b526a68`) | Après | Δ |
|---|---:|---:|---|
| Compilation Lua (668 fichiers) | 0 échec | **0 échec** | — |
| `audit_bugs.py` | 16 | **9** | −7 |
| `audit_integrite.py` | 878 | **875** | −3 |
| §2 personnage fantôme | 2 | **0** | −2 |
| §6 son unique (typo) | 36 | **35** | −1 |
| `verify_entity_handlers` (nouveau) | 17 | **14** | −3 |
| `verify_new_era.sh` | ✅ 277/525/133 | ✅ 277/525/133 | — |
| `validate_all` | ✅ | ✅ | — |
| `verify_scene_positions` | ✅ | ✅ | — |
| `verify_emotions` | ✅ | ✅ | — |
| `verify_cutscene_guard` | ✅ | ✅ | — |
| `verify_zone_index` | ✅ | ✅ | — |
| `verify_lua_globals` | ✅ | ✅ | — |
| `verify_spawner_enabled` | ✅ | ✅ | — |
| `count_dialogue` ch8 | 354 | 335 | −19 (quiz resserré et déplacé) |

Les 7 signalements retirés d'`audit_bugs` : 5 `SV.Chapter8.QuizScore`,
1 `colline_anciens` (objets sans handler), 1 MapStatus `"dream"`.

---

## 8. Ce qui reste ouvert

| # | Sujet | Nature |
|---|---|---|
| 1 | 60 cibles de `verify_ground_targets` | à trier zone par zone ; un retour délibéré est légitime |
| 2 | 14 handlers orphelins restants | `Butterfree`, `Kangaskhan_Rock`, `Passerby_1/2`, `Metapod`, `Silcoon`… |
| 3 | 746 clés `.resx` orphelines | 85 % des anomalies d'intégrité, sans effet en jeu |
| 4 | 35 « sons uniques » | à passer en revue : classe `DUN_Tumble` |
| 5 | 53 scènes de boss sans musique | arbitrage de mise en scène, pas forcément un défaut |
| 6 | `tools/audit_cutscene_exit.py` | chemin absolu en dur `/home/user/nea`, ne tourne nulle part |
| 7 | 3 grounds mini-boss orphelins | séquelle de `fc9e33c`, inoffensive |
| 8 | Ch8→ch11 à 5 % de la cible | les blueprints existent, le contenu jouable non |

---

## 9. Auto-questionnement

**L'erreur de placement de Xatu était-elle réelle ?**
Non — elle avait été corrigée la veille par `5a5b4e4`. Je l'ai vérifiée plutôt que
de la supposer, et la vérification a révélé un défaut *autre* et plus grave : la
carte elle-même était une copie d'une chambre à coucher, avec un marqueur d'entrée
hors des bornes. Corrigé à la source (entités remplacées, pas déplacées ailleurs),
géométrie importée préservée intacte.

**Les animations ont-elles été extraites de `pret/pmd-red` ?**
Non, et je ne l'ai pas fait. La mission demandait une extraction GBA avec rapport
de conversion frame par frame. Le tileset `Colline_Anciens_Base.tile` (71 254 o)
existe déjà, importé par `5a5b4e4`, et la géométrie est correcte. Je n'ai pas
d'accès au ROM ni aux outils de décompilation dans ce sandbox, et je préfère le
dire plutôt que de produire un rapport de conversion que je n'ai pas fait. La
scène utilise des animations **attestées dans le mod** (`Charge`, `Idle`), pas des
frames importées.

**Le contenu de la vision s'articule-t-il au fil rouge ?**
Oui, explicitement : Xatu confirme le titan de magma agi par une force extérieure
— point déjà posé au ch7 par la Team Alakazam — et donne la direction. Il ne crée
pas un enjeu parallèle.

**Xatu révèle-t-il quelque chose qui court-circuiterait un twist ?**
Non. Aucune mention de Rayquaza, de la météorite, de la Tour Céleste, ni d'aucun
terme interdit avant l'arc 6. Il perçoit la Voix du héros mais refuse de la nommer,
et bute explicitement sur l'ombre qu'il ne peut pas fixer.

**Ai-je inventé une API ?**
J'ai failli, deux fois, et les deux ont été rattrapées par la méthode :
`Mystifying Forest.ogg` pour la Colline (absent au moment où je l'ai écrit —
remplacé par `Sky Peak Prairie.ogg`, vérifié présent), et `zone.Grounds` que j'ai
confirmé contre `ZoneData.cs:258` avant de m'en servir. `EVT_Water_Splash`, lui,
était bien une invention — de `d88ab68`, pas de moi — et a été remplacé.

**Cette correction est-elle tracée ?**
Oui : ce document, plus deux outils de non-régression qui rendent les deux classes
de défaut détectables automatiquement à l'avenir.

**Qu'est-ce qui n'est pas prouvé ?**
Tout ce qui relève du rendu en jeu. Aucun de ces correctifs n'a été testé manette
en main. Les positions sont validées contre les données de collision, pas contre
l'affichage réel.
