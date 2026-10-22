# Audit technique — New Era : Abyss to Ascension (HEAD = v0.5.0+27)

> **Statut : correctifs de la partie 1 APPLIQUÉS** (voir § « Correctifs appliqués » en fin de document).
> Diagnostic revérifié sur les sources officielles : code moteur RogueEssence
> (`GameProgress.EndGame`, `GameManager`, `LuaEngine.MakeLuaEntityCallbackName`),
> PMDOWiki (Script Reference / Map and Adventure Control) et PMDOTutorial v0.5–v0.8.

Analyse statique du dépôt (178 fichiers Lua / 60 724 lignes, 43 cartes `.rsground`,
3 487 clés `strings.resx`, 1 789 clés `stringsEx.resx`).

Méthode : parcours des callbacks moteur (`ExitSegment`, `PlotScripting`, `*_Action`,
`*_Touch`), recoupement des noms d'entités des cartes avec les scripts, et diff
EN/FR clé par clé. **Aucune exécution en jeu** — les priorités ci-dessous sont donc
à confirmer manette en main, mais chaque point cite le fichier et la ligne exacte.

---

## PARTIE 1 — Écran noir après une défaite en donjon

### Comment la sortie de donjon fonctionne normalement

Quand une run se termine, le moteur appelle `<zone>.ExitSegment(zone, result, rescue, segmentID, mapID)`.
C'est **au script** de faire sortir le joueur. Deux appels sont nécessaires :

```lua
GAME:EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare) -- écran de résultats + sauvegarde
GAME:EnterZone(zone, structure, mapid, entryid)                              -- transition effective
```

`GeneralFunctions.EndDungeonRun()` (`GeneralFunctions.lua:61`) enchaîne bien les deux.
**Si `ExitSegment` ne fait ni l'un ni l'autre, le moteur a fondu au noir pour quitter
l'étage et attend une destination qui n'arrive jamais → écran noir définitif.**
C'est exactement le symptôme décrit.

#### Preuve par le code moteur (RogueEssence)

Vérifié dans les sources, et non supposé :

- `ScriptGame._EndDungeonRun(...)` (`RogueEssence/Lua/ScriptGame.cs`) appelle
  `DataManager.Instance.Save.EndGame(result, new ZoneLoc(...), display, fanfare, completedZone)`.
- `MainProgress.EndGame(...)` (`RogueEssence/Data/GameProgress.cs:1169`) se contente de
  **renseigner `NextDest`** (`if (nextArea.IsValid()) NextDest = nextArea;`), d'afficher
  le `FinalResultsMenu` puis de rendre la main après `yield return new WaitForFrames(20)`.
  **Il ne produit aucun `SceneOutcome` : le joueur n'est pas déplacé.**
- Seul `GAME:EnterZone` / `GAME:EnterGroundMap` affecte `GameManager.SceneOutcome`
  (via `MoveToZone` / `MoveToGround`), ce qui déclenche réellement la transition.
- `NextDest` n'est reconsommé automatiquement qu'au **chargement** d'une partie
  (`TopMenu.cs:200/256`, `QuicksaveChosenMenu`, `ReplayChosenMenu`) ou pendant un
  **replay** (`GameManager.handleReplayDungeonEnd`) — **jamais** en fin de `ExitSegment`
  en jeu normal.

Conséquence : `EndDungeonRun` **seul ne suffit pas**. C'est bien
`GeneralFunctions.EndDungeonRun` (qui enchaîne `EndDungeonRun` + `EnterZone`) ou un
appel explicite à `EnterZone`/`EnterGroundMap` qui fait sortir le joueur.

#### Référence officielle du pattern

Le tutoriel officiel (`PMDOTutorial` v0.8, `zone/large_woods/init.lua`) traite bien
les trois issues, la défaite en premier :

```lua
function large_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, "tutorial_zone", -1, 0, 0)   -- défaite ET fuite
  else
    if segmentID == 0 then
      GAME:EnterZone('large_woods', -1, 0, 0)
    else
      SV.large_lake.BossComplete = true
      GAME:EnterZone('large_woods', -1, 0, 0)
    end
  end
end
```

À noter : `COMMON.EndDungeonDay` appartient à `origin.common` (PMDO de base) et
**n'est pas redéfini dans ce mod** — Halcyon utilise son propre
`GeneralFunctions.EndDungeonRun`, dont le commentaire d'en-tête (`GeneralFunctions.lua:60`,
« this places Common.EndDungeonDay ») indique qu'il en tient lieu. Les correctifs
ci-dessous utilisent donc `GeneralFunctions.EndDungeonRun`, cohérent avec le reste du mod.

### 🔴 Cause n°1 — `mount_windswept.ExitSegment` est **vide** (bug bloquant)

`Data/Script/halcyon/zone/mount_windswept/init.lua:30-33`

```lua
function mount_windswept.ExitSegment(zone, result, rescue, segmentID, mapID)


end
```

Aucun `EndDungeonRun`, aucun `EnterZone`. **Toute fin de run au Mont Vulcan
(défaite, fuite *et* victoire) laisse le joueur en écran noir, sans échappatoire
autre que fermer le jeu.**

Et ce donjon est bel et bien atteignable en jeu :

- `Data/Zone/mount_windswept.json` → `"Released": true`, 1 segment généré ;
- `metano_town/init.lua:165` l'inclut dans la liste du menu de destination :
  `{"relic_forest", ..., "searing_tunnel", "mount_windswept"}` ;
- `searing_crucible_ch_5.lua:1238` y envoie le joueur en fin de chapitre 5 :
  `GAME:EnterGroundMap('mount_windswept_entrance', 'Main_Entrance_Marker')`.

C'est le contenu en cours de développement du chapitre 5 (le `readme` annonce
« chapitre 5 en cours »), mais rien ne verrouille l'accès côté joueur.

**Correctif proposé** — aligner sur le modèle générique de `vast_steppe` :

```lua
function mount_windswept.ExitSegment(zone, result, rescue, segmentID, mapID)
    GeneralFunctions.RestoreIdleAnim()
    local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
    SV.adventure.Thief = false

    if exited == true then
        --ExitDungeonMissionCheck a déjà géré la sortie (sauvetage)
    else
        if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
            GAME:WaitFrames(20)
        end

        SV.TemporaryFlags.Dinnertime    = true
        SV.TemporaryFlags.Bedtime       = true
        SV.TemporaryFlags.MorningWakeup = true
        SV.TemporaryFlags.MorningAddress= true

        local exit_ground = 6 -- guild_dining_room
        if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end -- guild_second_floor
        GeneralFunctions.EndDungeonRun(result, "master_zone", -1, exit_ground, 0, true, true)
    end
end
```

Il faut aussi ajouter `require 'halcyon.GeneralFunctions'` en tête du fichier
(il n'y est pas, contrairement à `vast_steppe/init.lua`).

### 🔴 Cause n°2 — `cloven_ruins.ExitSegment` : branches vides

`Data/Script/halcyon/zone/cloven_ruins/init.lua:30-42`

```lua
elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- (vide)
else
    -- (vide)
end
```

`COMMON.ExitDungeonMissionCheck` est appelé, mais il ne provoque une sortie **que**
s'il s'agit d'un sauvetage (`if rescue == true then COMMON.EndRescue(...)`,
`common.lua:1006`). En jeu normal → même écran noir.

Risque réel plus faible : `Data/Zone/cloven_ruins.json` a `"Released": false` et
**0 segment**, la zone est donc invisible au menu. Mais `debug_tools/init.lua:139-142`
déverrouille *toutes* les zones en boucle, et `guild_guildmasters_room_ch_5.lua:101`
la référence déjà. À corriger sur le même modèle avant de la publier.

### ⚠️ Cause n°3 — donjons d'entraînement du dojo : pas de `EnterZone`

`bug_maze`, `electric_maze`, `fire_maze`, `flying_maze`, `grass_maze`, `rock_maze`,
`water_maze` terminent par :

```lua
GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)
```

C'est **correct** (le helper fait `EnterZone` en interne). En revanche `normal_maze`
et `beginner_lesson` appellent la version brute `GAME:EndDungeonRun(...)` **puis**
`GAME:EnterZone(...)` séparément — deux conventions coexistent pour un résultat
identique. Pas un bug, mais une incohérence qui explique pourquoi le cas
`mount_windswept` est passé inaperçu : il n'y a pas de modèle unique à copier.

**Recommandation** : faire passer toutes les zones par `GeneralFunctions.EndDungeonRun`,
et surtout s'assurer que **chaque branche** (défaite / fuite / victoire) se termine par
une transition explicite.

> ⚠️ **Correction d'une version antérieure de ce rapport.** J'avais proposé un
> « filet de sécurité » basé sur `_ZONE.CurrentZoneID`. Cette propriété n'est **pas
> documentée** dans le Script Reference du wiki et je ne l'ai pas retrouvée exposée
> au Lua côté moteur ; `ZoneManager.Instance.CurrentZoneID` existe bien en C#, mais
> je n'ai **pas vérifié** qu'elle soit accessible via le binding `_ZONE`. La suggestion
> est donc retirée : la structure `if exited == true then ... else ... end` employée
> dans les correctifs couvre déjà tous les cas sans recourir à une API incertaine.

### ✅ Ce qui est correct (pour info)

Les donjons de l'histoire gèrent tous proprement la défaite, avec la séquence que
vous décrivez (réveil → dîner → dodo → lendemain) :

| Donjon | Défaite → destination | Flags posés |
|---|---|---|
| `relic_forest` (ch.1) | ground map 9 ou 0 + `DeathFadeOutDialogue` | scénarisés |
| `illuminant_riverbed` | dining room (6) ou 2ᵉ étage (22) | Dinner/Bed/Morning |
| `crooked_cavern` | idem + réplique du partenaire | + `FailedCavern` |
| `apricorn_grove` | idem | Dinner/Bed/Morning |
| `vast_steppe` | ch.5 → entrée (46), sinon dîner | `DiedSteppe` |
| `searing_tunnel` | ch.5 → entrée (47) / mi-parcours (48) | `DiedPastCheckpoint` |

Le trio `Dinnertime` / `Bedtime` / `MorningWakeup` est bien positionné, et
`guild_dining_room/init.lua:67` puis `guild_heros_room/init.lua:108` enchaînent
dîner → nuit → matin. **La logique « lendemain » que vous attendez existe donc déjà** —
elle n'est simplement jamais atteinte sur les deux zones ci-dessus.

### 🟠 Bugs secondaires à l'entrée du Mont Vulcan

Même une fois `ExitSegment` corrigé, la carte `mount_windswept_entrance` est incomplète :

1. **Entité `Dungeon Entrance` avec une espace** (`Data/Ground/mount_windswept_entrance.rsground`),
   alors que toutes les autres cartes utilisent `Dungeon_Entrance` (souligné) —
   cf. `vast_steppe_entrance`, `searing_tunnel_entrance`.

   *Confirmé par le moteur* : `LuaEngine.MakeLuaEntityCallbackName`
   (`RogueEssence/Lua/LuaEngine.cs:261`) construit le nom du callback ainsi :
   ```csharp
   return String.Format("{2}.{0}_{1}", entname, type.ToString(), MapCurrentScriptSym);
   ```
   Avec `entname = "Dungeon Entrance"`, cela donne
   `mount_windswept_entrance.Dungeon Entrance_Touch` — un identifiant Lua
   **syntaxiquement invalide** (espace au milieu), donc impossible à définir
   ou à appeler. L'entrée du donjon ne pouvait structurellement pas fonctionner.
2. **Aucun handler `Dungeon_Entrance_Touch`** dans
   `mount_windswept_entrance/init.lua` → même corrigé, toucher l'entrée ne fait rien.
3. **`Kangaskhan_Rock` présent sur la carte, aucun `Kangaskhan_Rock_Action`**
   (0 occurrence) → interagir avec le rocher lève une erreur Lua.
4. `PlotScripting()` ne fait que `GAME:FadeIn(20)` : `ArrivalCutscene()` (écrite,
   `mount_windswept_entrance_ch_5.lua:78`) n'est jamais appelée.

---

## PARTIE 2 — Autres bugs relevés

### 🔴 Clés de texte référencées mais **absentes du fichier source EN**

Ces appels sont dans du code actif (vérifié ligne par ligne, hors commentaires) :
`STRINGS.MapStrings['CLE']` renvoie `nil` → texte vide ou exception selon le contexte.

| Carte | Clé | Ligne |
|---|---|---|
| `metano_town` | `Item_Give_Storage` | `init.lua:1910` |
| `metano_town` | `Tutor_Info_004` | `init.lua:2013` |
| `post_office` | `Connect_Option_Advanced` | `init.lua:236` et `:550` |
| `post_office` | `Rescue_Begin` | `init.lua:431` et `:698` |
| `post_office` | +33 autres clés `Connect_*` / `Rescue_*` | — |

Le `strings.resx` de `post_office` ne contient que **49 clés** alors que le script en
référence **~85**. Ce n'est pas une régression de traduction : le fichier EN est
incomplet **depuis l'import initial** (commit `4ea3617`, identique au tag `v0.5.0`).
C'est un bug amont d'Halcyon, pas du travail FR.

### 🟠 Handlers de chapitre manquants (erreur Lua à l'interaction)

Le motif `assert(pcall(load("<map>_ch_" .. Chapter .. ".<Fn>(...)")))` échoue quand la
variante du chapitre courant n'existe pas. ~160 combinaisons sont incomplètes ;
les plus exposées (PNJ visibles hors de leur chapitre) :

- `metano_water_home` : `Wooper_Girl_Action`, `Wooper_Boy_Action` → **définies pour aucun chapitre**
- `metano_normal_home` : `Zigzagoon_Action` → aucun chapitre
- `metano_grass_home` : `Oddish_Action` → aucun chapitre
- `metano_inn` : `Nidoking_Action`, `Passerby_2_Action` → aucun chapitre
- `metano_town` : `Nidoran_Male_Action` → aucun chapitre
- `guild_bottom_right_bedroom` : `Growlithe_Action` → aucun chapitre
- `guild_heros_room` / `guild_storage_hallway` : `Event_Trigger_1_Touch` → aucun chapitre

Le `pcall` évite le crash, mais l'interaction ne produit **rien** (PNJ muet).

### 🟠 `Assembly_Info_001` → `_008` : clés fantômes

Présentes dans `guild_third_floor_lobby/strings.resx` avec pour seule valeur
`"info 1"` … `"info 8"` — texte de remplacement jamais rédigé, et non traduites en FR
(ce sont les 8 seules clés FR manquantes de cette carte).

### 🟡 Divers

- `Data/Script/halcyon/ground/metano_town/strings.resx` contient une clé `test` = `"test"` ;
  `altere_pond` contient `test` = `"touhou is for weebs"` ; `guild_first_floor` contient
  `dummy_string`. Résidus de développement à nettoyer.
- `test_grounds`, `testmap`, `testmap_2` sont livrés dans le mod (cartes de debug,
  `test_grounds` référencé comme ground map 52 de `master_zone`).
- `searing_tunnel/init.lua` : le commentaire annonce que le flag `LostTunnel`
  « ne servira probablement à rien » — il est effectivement posé mais jamais lu.
- Deux définitions successives de `GeneralFunctions.DeathFadeOutDialogue`
  (lignes 1658 et 1721) ; la seconde est dans un bloc `--[[ ]]--`, donc inerte. OK,
  mais source de confusion.

---

## PARTIE 3 — État réel de la traduction française

Le mod est **très largement traduit**. Chiffres exacts :

| Périmètre | Total | Traduit | Reste |
|---|---:|---:|---:|
| `Strings/stringsEx.resx` (dialogues génériques) | 1 789 | 1 709 | **80** |
| `strings.resx` des 43 cartes | 3 487 | 3 463 | **24** |
| Dialogues **codés en dur** dans les `.lua` | — | — | **~860** |

### Ce qu'il reste dans les `.resx` (facile)

**80 clés dans `stringsEx.fr.resx`** — toutes du même bloc, les commentaires
d'expédition de Ganlon/Shuca/Rin (chapitre 5) :

- `TALK_FULL_3100` → `TALK_FULL_3164` (Cranidos ×5 personnalités, Mareep)
- `TALK_HALF_31xx` et `TALK_PINCH_31xx` correspondants
- `TALK_FULL_9999` / `TALK_HALF_9999` / `TALK_PINCH_9999` (messages d'erreur de
  personnalité — à laisser en anglais, ils s'adressent au développeur)

**24 clés de cartes**, dont 8 vraies (`Assembly_Info_00x`, ci-dessus) et le reste
des résidus de test (`test`, `dummy_string`) ou la carte de debug `test_grounds` (12).

### Le vrai chantier : ~860 dialogues en dur dans le code

Ce sont eux que vous voyez encore en anglais en jeu. Ils **ne peuvent pas** être
traduits via les `.resx` : il faut les extraire vers les fichiers de langue puis
remplacer par `STRINGS:Format(STRINGS.MapStrings['CLE'])`. Répartition (hors cartes de test) :

| Fichier | Occurrences | Impact joueur |
|---|---:|---|
| `PartnerEssentials.lua` | **348** | ⚠️ maximal — bavardages du partenaire, vus en permanence |
| `ground/guild_bottom_right_bedroom/init.lua` | **157** | fort — l'almanach d'Almotz (tout le contenu d'aide) |
| `dungeon_event/beginner_lesson_evt.lua` | 42 | fort — tutoriel du dojo |
| `event_single.lua` | 38 | fort — messages de mission en donjon |
| `ground/guild_second_floor/init.lua` | 33 | fort — remise des missions, tableau de quêtes |
| `ground/guild_heros_room/init.lua` | 27 | fort — menu du livre (écharpes, surnoms, rang) |
| `event_battle.lua` | 26 | moyen — escortes, sauvetages |
| `ground/personality_test/init.lua` | 24 | fort — quiz de personnalité (tout début de partie) |
| `GeneralFunctions.lua` | 21 | ⚠️ **messages système** |
| `ground/metano_town/init.lua` | 17 | moyen |

### Messages système visibles en anglais (priorité haute, petit volume)

Ce sont les plus voyants pour un joueur francophone, et il n'y en a qu'une poignée :

```
GeneralFunctions.lua:1116  "What would you like to do?" / "Save and continue." / "Save and quit." / "Cancel"
GeneralFunctions.lua:1122  "Game saved!"
GeneralFunctions.lua:1127  "Game saved! Returning to title."
GeneralFunctions.lua:1224  "Team X received <objet>."
GeneralFunctions.lua:1244  "The <objet> was sent to storage."
GeneralFunctions.lua:1305  "Team X earned N Adventurer Rank Points!"
GeneralFunctions.lua:1341  "Congratulations!"
GeneralFunctions.lua:1342  "Team X went up in rank from the ... Rank to the ... Rank!"
GeneralFunctions.lua:1346  "The number of items you can store in your Treasure Bag has increased..."
GeneralFunctions.lua:1380  "For advancing in rank, your team was awarded a <objet>."
GeneralFunctions.lua:2202  "All unequipped items have been stored."
GeneralFunctions.lua:1884  "You have more ongoing missions, but would you like to leave the dungeon?"
GeneralFunctions.lua:1888  "Do you really want to leave?"
common.lua:872             "Have one of your team members return to the guild to make room for your client, X."
common.lua:879             "Send X back to the guild?"
common.lua:908             "Added X to the party as a guest."
metano_town/init.lua:144   "Would you like to enter <donjon>?"
metano_town/init.lua:418   "<donjon> is the destination.\nIs that correct?"
searing_tunnel_midpoint:96 "Would you like to continue?"
searing_tunnel_midpoint:138 "Would you like to return to Metano Town?"
apricorn_grove_entrance:166 "Should we head back into the dungeon, or ...?" / "Go back in" / "Head home"
guild_heros_room/init.lua:180 "Change scarves" / "Change nicknames" / "Change team name" / "Check rank" / "Nothing"
```

### Objectifs de mission (tableau des quêtes) — non traduits

`mission_gen.lua:1973-1983` et `:2658-2674` construisent les objectifs par
concaténation anglaise :

```lua
self.objective = "Rescue " .. self.target .. "."
self.objective = "Escort " .. self.client .. " to " .. self.target .. "."
self.objective = "Arrest " .. self.target .. "."
self.objective = "Find " .. self.item .. " for " .. self.client .. "."
self.objective = "Deliver " .. self.item .. " to " .. self.client .. "."
objective       = "Arrest cowardly " .. target .. "."
objective       = "Arrest big boss " .. target .. "."
message         = "Go as far as you can."                      -- mission_gen.lua:2733
message         = "Defeat X's clan!"                           -- mission_gen.lua:2729
```

À convertir en clés `stringsEx` avec placeholders (`{0}`, `{1}`) — attention, la
structure de phrase française impose de revoir l'ordre des arguments.

### Données de jeu (`Data/*.json`) sans localisation FR

Le moteur affiche le `DefaultText` anglais faute de `LocalTexts.fr` :

- **18 noms de donjons sur 19** : Apricorn Grove, Crooked Cavern, Illuminant Riverbed,
  Relic Forest, Searing Tunnel, Vast Steppe, Mt. Windswept, Aegis Cave, et les
  7 labyrinthes du dojo (`Bug Maze`, `Fire Maze`…). **Très visible** : ces noms
  apparaissent dans le menu de destination, les missions et les dialogues via
  `zone:GetColoredName()`.
- **13 rangs sur 14** : Bronze, Silver, Gold, Diamond, Master, Guildmaster…
- **27 objets** : les 4 boissons du café (`Apple Cider`, `Domi Blend`, `Cheri Bomb`,
  `Endurance Tonic`), les 6 coffres (`Dainty Box`…), 9 objets tenus
  (`Synergy Scarf`, `Zinc Band`, `Band of Passage`…), `Quick Seed`, les objets de
  mission (`Lost Scarf`…) — plus ~40 descriptions d'objets (baies, gummis, orbes).
- **5 statuts de carte** (`Blowing Wind`, `Darkness`, `Steam`…) et 3 statuts
  (`Critical Health`, `Synergizing`, `Endurance Tonic`), noms **et** descriptions.
- 11 teintes de skin, 1 emote (`Eating`).

Les 21 fichiers `Data/Monster/` sont eux **correctement traduits** (`LocalTexts.fr`
présent), tout comme 154 objets sur 181.

### Qualité de la traduction existante — 2 régressions réelles

Comparaison placeholder par placeholder entre EN et FR :

```
relic_forest / RF1_022 : EN utilise {0} {1} {2}  → FR n'en utilise aucun
relic_forest / RF1_023 : EN utilise {0} {1} {2} {3} → FR n'en utilise aucun
```

```
EN : "(Hmm...[pause=0] {0} {1} stunned,[pause=10] actually...[pause=0]...)"
FR : "(Hmm...[pause=0] En fait, cet air sonné...[pause=10] Et si c..."
```

La reformulation française a supprimé les variables (nom du héros, pronoms adaptés
au genre). Ce n'est **pas un crash** — `String.Format` tolère les arguments en trop —
mais le texte perd l'adaptation au personnage choisi. À revoir si l'intention était
de conserver la mention du héros.

Vérifications passées sans erreur, à signaler :
- **0** fichier `.resx` XML invalide (sur ~600 fichiers).
- **0** clé dupliquée dans les fichiers FR.
- **0** cas de « plus de placeholders dans le texte que d'arguments fournis »
  (le piège classique qui coupe une cinématique en plein milieu) — ni en EN ni en FR.
- 5 clés seulement sont identiques EN/FR dans `stringsEx`, et c'est normal
  (`"Zzzz... Zzzz..."`, `"RRRRR..."`, onomatopées).

---

## Plan d'action suggéré

**Immédiat (débloque le jeu)**
1. Écrire `mount_windswept.ExitSegment` (patch fourni ci-dessus).
2. Renommer l'entité `Dungeon Entrance` → `Dungeon_Entrance` dans
   `mount_windswept_entrance.rsground` + écrire `Dungeon_Entrance_Touch`
   et `Kangaskhan_Rock_Action`.
3. Ajouter le filet de sécurité générique en fin de chaque `ExitSegment`.
4. Remplir les branches vides de `cloven_ruins.ExitSegment`.

**Traduction, par rapport visibilité/effort**
5. Localiser `Data/Zone/*.json` (18 noms de donjons) — ~30 min, très visible.
6. Localiser `Data/Rank/*.json` (13 rangs) et les 27 objets + descriptions manquantes.
7. Traduire les ~25 messages système de `GeneralFunctions.lua` / `common.lua`.
8. Traduire les objectifs de mission de `mission_gen.lua`.
9. Finir les 80 clés `TALK_*_31xx` de `stringsEx.fr.resx` (chapitre 5).
10. Gros chantier : extraire les 348 lignes de `PartnerEssentials.lua` puis les
    157 de l'almanach d'Almotz vers des `.resx`.

Les scripts `docs/extract_dialogues.py`, `docs/extract_inline.py` et
`docs/gen_stringsEx_fr.py` déjà présents dans le dépôt couvrent la mécanique
d'extraction pour les points 9 et 10.

---

## Correctifs appliqués

Les points 1 à 4 du plan d'action ont été implémentés. 4 fichiers modifiés,
+101 / −5 lignes.

| Fichier | Changement |
|---|---|
| `Data/Script/halcyon/zone/mount_windswept/init.lua` | `ExitSegment` implémentée (défaite / fuite / victoire) + `require 'halcyon.GeneralFunctions'` |
| `Data/Script/halcyon/zone/cloven_ruins/init.lua` | branches vides remplies + `require 'halcyon.GeneralFunctions'` |
| `Data/Ground/mount_windswept_entrance.rsground` | entité `Dungeon Entrance` → `Dungeon_Entrance` |
| `.../ground/mount_windswept_entrance/init.lua` | ajout de `Dungeon_Entrance_Touch` et `Kangaskhan_Rock_Action` + `require` |

Choix d'implémentation :

- Modèle repris de `zone/vast_steppe/init.lua` (même mod, cas générique hors chapitre 5),
  pour rester cohérent avec le style existant plutôt que d'introduire un pattern étranger.
- Sortie via `GeneralFunctions.EndDungeonRun(...)`, qui enchaîne bien
  `GAME:EndDungeonRun` **puis** `GAME:EnterZone` — indispensable d'après le code moteur.
- Destination : ground map **6** (`guild_dining_room`), ou **22** (`guild_second_floor`)
  si une mission est à rendre. Indices vérifiés dans `Data/Zone/master_zone.json`.
- Pose des flags `Dinnertime` / `Bedtime` / `MorningWakeup` / `MorningAddress`
  → enchaîne dîner → nuit → lendemain, la séquence attendue.
- `SV.adventure.Thief = false` au passage, comme dans les autres zones.
- `Dungeon_Entrance_Touch` calquée sur `metano_town.North_Exit_Touch`
  (confirmation Oui/Non, fondu, `SV.partner.Spawn = "Default"`, puis `GAME:EnterDungeon`
  avec `DungeonStakes.Risk`).

Vérifications post-correctif :

- **178/178** fichiers Lua du mod compilent sans erreur de syntaxe (parsés via `load()`).
- **17/17** zones de donjon disposent désormais d'une transition dans `ExitSegment`.
  Restent `master_zone` et `backup_master_zone`, qui sont les hubs de ground maps
  (53 et 46 cartes) et non des donjons — faux positifs légitimes.
- `mount_windswept_entrance.rsground` toujours valide en JSON, BOM UTF-8 préservé,
  l'occurrence remplacée était unique dans tout `Data/`.

### Reste à faire / non vérifiable sans lancer le jeu

- **Test manuel indispensable** : perdre volontairement au Mont Vulcan et vérifier
  l'enchaînement résultats → dîner → nuit → matin.
- La **cinématique d'arrivée** `mount_windswept_entrance_ch_5.ArrivalCutscene()` est
  écrite mais toujours jamais appelée : `PlotScripting()` ne fait que `GAME:FadeIn(20)`.
  Je ne l'ai pas branchée car cela relève d'un choix de conception narrative
  (à quelle condition de progression la déclencher), pas d'une correction de bug.
- Les positions/markers utilisés par cette cinématique n'ont pas été audités.
- `cloven_ruins` reste `"Released": false` avec 0 segment : le correctif est préventif,
  il n'a pas pu être exercé.
