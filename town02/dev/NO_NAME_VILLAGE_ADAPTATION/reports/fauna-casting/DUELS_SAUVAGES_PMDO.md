# PMDO accepte-t-il les duels à l'état sauvage ? — audit moteur

Source lue : `RogueCollab/RogueEssence` (`master`, commit `a03f2eac`, 16/08/2026),
récupéré via `codeload.github.com`. C'est le moteur de `GameVersion 0.8.12`
déclaré dans `Mod.xml`.

## Réponse courte

**Non sur un Ground. Oui sur une Map de donjon.**

Le combat n'existe nulle part dans la couche Ground de RogueEssence. Il n'y a
pas « un duel sauvage qu'on active » : il faut faire basculer le joueur vers
une carte de donjon, et le dépôt sait déjà le faire.

## Preuve 1 — le Ground n'a aucun système de combat

| Élément | Ground | Donjon |
|---|---|---|
| Classe personnage | `GroundChar` (`Ground/GroundChar.cs`) | `Character` (`Dungeon/Characters/Character.cs`) |
| Points de vie | **aucun champ HP** | `public int HP;` (l. 255) |
| Équipes / factions | **aucune** | `MapTeams` / `AllyTeams` / `Faction {None, Player, Friend, Foe}` |
| Résolution d'attaque | **aucune** | `DSceneAction.GetMatchup()` (l. 664-711) |
| Tours | aucun | `Dungeon/Turns/` |

`GroundChar` hérite de `GroundAIUser` et porte `Data` (un `CharData` : espèce,
niveau, talents, capacités) — mais `CharData` ne contient **pas** de HP. Les HP
n'apparaissent que sur `Character`, la classe de donjon. Un `GroundChar` ne
peut donc structurellement ni frapper, ni encaisser, ni mourir.

## Preuve 2 — la touche « Attaque » sur un Ground déclenche un dialogue

`Ground/GroundScene.cs` l. 232 :

```csharp
if (input.JustPressed(FrameInput.InputType.Attack))
    action = new GameAction(GameAction.ActionType.Attack, Dir8.None);
```

et `Ground/GSceneZone.cs` l. 143-148 :

```csharp
case GameAction.ActionType.Attack:
    character.CurrentCommand = action;
    yield return CoroutineManager.Instance.StartCoroutine(ProcessObjectInteract(character));
    break;
```

`ProcessObjectInteract` (`Ground/GSceneMap.cs` l. 89-119) cherche l'entité
devant le joueur et appelle `talkTo.Interact(...)`, qui lance l'événement Lua
`Action`. **Le bouton d'attaque du Ground est le bouton de dialogue.** C'est
exactement le canal qu'utilise déjà `NNVLife.WildTalk`.

## Preuve 3 — le seul combat possible passe par une Map de donjon

`Lua/ScriptGameAdventure.cs` expose `EnterDungeon` (l. 59-72) et
`ContinueDungeon` (l. 83-93). Le dépôt utilise déjà ce chaînage deux fois :

- **Duel Team Dazzling** (`docs/duel_team_dazzling_ch6.md`) :
  `DazzlingArc.TrialIntro()` → `GAME:ContinueDungeon("gloomy_forest", 7, 0, 0, ...)`,
  segment dont le `Floor` est un `LoadGen` + `MappedRoomStep` pointant
  `Data/Map/serment_dazzling_arene.rsmap`, `IsRelevant = false`.
- **Pillards de Metano** (`Data/Script/halcyon/TownRaid.lua` l. 20-35) : même
  patron, trois cartes `metano_raid_1/2/3`.

Le patron est donc déjà éprouvé dans ce mod, avec sa propre documentation.

## Preuve 4 — les factions permettent trois régimes de rencontre

`Dungeon/Maps/Map.cs` l. 850-894 et `Dungeon/DSceneAction.cs` l. 676-711 :

| Placement | Faction | Comportement |
|---|---|---|
| `MapTeams.Add(team)` | `Foe` | **hostile** — attaque à vue |
| `AllyTeams.Add(team)` | `Friend` | **pacifique** — trêve imposée |
| `AllyTeams` + `team.FoeConflict = true` | `Friend` | pacifique avec le joueur, **hostile envers les Foe** |

Ce troisième régime (`Team.cs` l. 26) est la clé d'une faune crédible : des
Pokémon sauvages qui ne s'en prennent pas au joueur mais se battent entre eux.
Le dépôt ne l'utilise nulle part pour l'instant.

`dungeon_life.lua` (l. 100-120) montre déjà le placement `AllyTeams` +
`MonsterTeam` + `RefreshTraits` + `UpdateExploration` : la mécanique est
opérationnelle et testée dans ce mod.

## Ce que cela implique pour la faune de NNV

Les 2 019 occurrences de faune vivent dans des **Grounds** (`rmvillage`, `rm14`,
`rm82`…). Donc, en l'état :

1. **Aucune des 2 019 ne peut être un combat.** Elles sont des `GroundChar` :
   elles bougent, réagissent à la distance, parlent. C'est ce que fait déjà
   `NNVLife` (`timid` fuit, `territorial` se tourne vers le joueur).
2. **Un duel sauvage se construit à part** : Ground → cinématique courte →
   `ContinueDungeon` vers un segment `IsRelevant = false` avec une `.rsmap`
   dédiée → retour au Ground. Rien à modifier dans le moteur.
3. Le GML source donne les candidats naturels au duel : les objets `objmob*`
   ont un `hp`, un `dmg` et un `level` (ex. `objmobwn4` : `maxhp = 35`,
   `dig`+`bite` ; `objmobwn2` : `maxhp = 15`, `level = 5`). Les `objbgmob*`
   (papillon, luciole, bug, oiseau, grenouille) n'ont **ni hp ni dmg** : ce sont
   des figurants, jamais des adversaires.

### Coût réel d'un duel

Par duel : 1 `.rsmap` (clone géométrique d'une arène existante), 1 segment de
zone `IsRelevant = false`, 1 entrée `Data/Zone/index.idx` resynchronisée,
1 fonction Lua d'intro/sortie. Piège connu et documenté : oublier l'injection
dans `index.idx` produit le **damier mauve/noir**
(`docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md`).

## Statut

`AUDIT_ONLY` — aucun fichier de jeu modifié. Aucun duel n'est implémenté :
la décision d'en créer un, et pour quelles espèces, t'appartient.
