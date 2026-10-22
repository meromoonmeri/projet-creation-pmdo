# Audit de fond en comble — Checkpoint mi-donjon « Crooked Cavern »

**Projet** : New Era : Abyss to Ascension — V2 (mod `halcyon` pour PMDO)
**Date** : 2026-07-25
**Demande** : zone de relais mi-donjon type Statue Kangourex pour **Crooked Cavern**
**Méthode** : audit refait intégralement à partir du code du projet et des sources externes (wiki PMDO). Le rapport précédent (`rapport_checkpoint_crooked_cavern_2026-07-25 (1).md`) a été **vérifié point par point** ; plusieurs de ses affirmations sont **corrigées** ci-dessous.

---

## 1. Résultat court (verdict indépendant)

1. **Crooked Cavern existe et est bien un donjon à boss** → le système de checkpoint s'applique (règle du prompt respectée). Preuves : §3.
2. **Il n'existe AUCUNE fonction native unique nommée « checkpoint / relay / save point »** dans le moteur PMDO / RogueEssence. Vérifié sur la liste officielle complète des fonctions Lua (§4.1, §4.6).
3. **Mais le mécanisme standard existe et est DÉJÀ codé dans ce projet** : le donjon **Searing Tunnel** possède un midpoint Kangourex pleinement fonctionnel. C'est le modèle canonique à réutiliser. Preuves : §5.
4. **Le rapport précédent se trompait sur un point bloquant** : il affirmait que `Data/Ground/searing_tunnel_midpoint.rsground` existait. **C'est faux** : aucune donnée de ground map n'est présente dans ce repo. C'est une **contrainte de faisabilité majeure** détaillée en §7.
5. **Décision recommandée** : réutiliser le patron Searing Tunnel (Ground Map de relais + `GAME:GroundSave` + redirection des défaites via `GAME:EndDungeonRun`/`GAME:EnterZone`), en l'écrivant de façon **réutilisable** pour les autres donjons à boss.

---

## 2. Ce que je CORRIGE du rapport précédent

Le rapport précédent était globalement dans la bonne direction, mais contenait 4 erreurs factuelles. Comme tu as demandé une vérification « refaite sérieusement », voici les corrections avec preuves :

| # | Affirmation du rapport précédent | Réalité vérifiée | Preuve |
|---|---|---|---|
| 1 | `Data/Ground/searing_tunnel_midpoint.rsground` existe | **FAUX.** Aucun fichier `.rsground` n'existe dans tout le repo. Le dossier `Data/Ground/` n'existe pas non plus. | `find . -name "*.rsground"` → 0 résultat ; census des extensions en §7 |
| 2 | `Statue_Dungeon.dir` est « confirmé disponible dans le projet » (selon le prompt, repris tel quel) | **FAUX dans le projet.** Seul `Kangaskhan_Rock.dir` est présent. `Statue_Dungeon.dir` n'existe que dans DumpAsset / base PMDO. | `ls Content/Object/` → `Kangaskhan_Rock.dir` + `Falling_Rock_Shadow.dir` uniquement |
| 3 | Le mécanisme repose sur « ligne 124 / 130 / 133 » du script zone Searing | Vrai dans le principe, mais **les numéros de ligne et la structure réels diffèrent**. La logique est dans les branches `segmentID == 1` et `segmentID == 2` (else). | `Data/Script/halcyon/zone/searing_tunnel/init.lua` |
| 4 | `SV.checkpoint` « n'est pas utilisée ailleurs, donc pas un système » | À moitié vrai. Elle n'est pas utilisée dans Halcyon, **mais c'est la variable standard documentée par le wiki PMDO** (`COMMON.EndDungeonDay(result, SV.checkpoint.Zone, …)`). Le projet l'ignore au profit de mapIDs codés en dur, mais ce n'est pas une variable fantôme. | [Tutorial:Basic Zone Scripts](https://wiki.pmdo.pmdcollab.org/Tutorial:Basic_Zone_Scripts) ; `scriptvars.lua:47` |

---

## 3. Vérification 1 — Crooked Cavern existe-t-il et est-il un donjon à boss ?

**OUI, sur les deux points.** Preuves directes dans `Data/Zone/crooked_cavern.json` :

- Ligne 5-8 : `"DefaultText": "Crooked Cavern"`, `"fr": "Caverne Tortueuse"` → le donjon existe et est traduit.
- Ligne 27 : `"Segments": [` → la zone est bien structurée.
- Ligne 29 : segment 0 = `RogueEssence.LevelGen.RangeDictSegment` (partie **procédurale**, étages 5→10 selon le rapport, confirmé par `Range` ligne 1001).
- Lignes 342 et 829 : présence de **`PMDC.LevelGen.BossRoom`** → bosses/gardiens dans la génération.
- Lignes 2842-2858 : segment 1 = `LayeredSegment` contenant un **`LoadGen`** qui charge `"MapID": "chapter_3_boss_fight"` → **segment de boss en arène préfabriquée**.
- Ligne 2894 : `"GroundMaps": [` liste `crooked_cavern_entrance`, `crooked_den` (voir `master_zone.json` lignes 83075-83076).

**Conclusion** : Crooked Cavern = donjon histoire à boss (3e donjon du jeu, chapitre 3). Le checkpoint est applicable selon la règle du prompt. ✅

Flux actuel (vérifié dans `Data/Script/halcyon/zone/crooked_cavern/init.lua` + `Data/Script/halcyon/ground/crooked_den/crooked_den_ch_3.lua`) :

```
Segment 0 (procédural) ──clear──▶ crooked_den (scène pré-boss)
                                        │
                            FirstPreBossScene / SecondPreBossScene
                                        │
                  GAME:ContinueDungeon("crooked_cavern", 1, 0, 0, …)   (ligne 489 & 813)
                                        │
                              Segment 1 : boss (chapter_3_boss_fight.rsmap)
                                        │
                    défaite → LostToBoss → retour à crooked_den
                    victoire → DefeatedBoss → suite de l'histoire
```

**À noter** : Crooked Cavern a DÉJÀ un retour pré-boss scénarisé (mort au boss → `crooked_den`). Mais `crooked_den` est un **hub de cinématique**, pas un sanctuaire : pas de Statue Kangourex, pas de sauvegarde, pas de stockage, pas de décor de refuge. C'est précisément ce que le checkpoint doit ajouter.

---

## 4. Checklist de vérification obligatoire (les 8 points)

### 4.1 RogueEssence / moteur — fonctions natives

Vérifié via la **liste officielle complète** des fonctions Lua du wiki : [Script Reference / Lua Function Reference](https://wiki.pmdo.pmdcollab.org/Script_Reference). Le namespace `Game` contient, et **seulement**, ces fonctions de contrôle de carte/aventure :

`GroundSave`, `EnterGroundMap`, `EnterDungeon`, `ContinueDungeon`, `EndDungeonRun`, `EnterZone`, `EnterRescue`, `RestartToTitle`, `RestartRogue`, `CutsceneMode`…

**Aucune** fonction nommée `Checkpoint`, `Relay`, `SavePoint`, `MidDungeonSave`, `RestPoint`. Le concept n'existe pas comme primitive.

Signatures confirmées sur [Map and Adventure Control](https://wiki.pmdo.pmdcollab.org/Game_(functions)/Map_and_Adventure_Control) :

| Fonction | Signature documentée | Rôle |
|---|---|---|
| `GAME:GroundSave` | `()` | « Saves the game while in ground mode. » |
| `GAME:EnterGroundMap` | `(id, entryPoint, preserveMusic)` ou `(zone, id, entryPoint, preserveMusic)` | entrer une ground map |
| `GAME:EnterDungeon` | `(dunID, structID, mapID, entry, stakes, recorded, silentRestrict)` | démarrer une **nouvelle** aventure |
| `GAME:ContinueDungeon` | `(dunID, structID, mapID, entry)` | **poursuivre** l'aventure en cours |
| `GAME:EndDungeonRun` | `(result, zoneID, structID, mapID, entryID, display, fanfare, completedZone)` | terminer le run + envoyer vers une destination |
| `GAME:EnterZone` | `(dunID, structID, mapID, entry)` | entrer une zone + débuter une aventure |

> `structID = -1` représente les **ground maps** (documenté). C'est ce qui permet de cibler un midpoint en ground mode.

La **preuve que ces fonctions existent** est aussi empirique : elles sont **appelées partout** dans les scripts du mod (le mod ne tournerait pas sinon). Exemples vérifiés : `ContinueDungeon` est utilisé dans `crooked_den_ch_3.lua:489,813`, `apricorn_glade_ch_4.lua:1173`, `gloomy_forest_boss_ch_6.lua:76`, `mount_windswept_*_ch_5.lua`, etc.

### 4.2 RogueElements

RogueElements fournit les **structures de génération** (`RangeDictSegment`, `LayeredSegment`, `LoadGen`, `MapLoadContext`, `MappedRoomStep`), **pas** de règles de sauvegarde. C'est confirmé par l'usage dans le projet : segment 0 = `RangeDictSegment`, segment de boss = `LayeredSegment` + `LoadGen` (`crooked_cavern.json:29, 2842, 2845`). Rien à coder côté génération pour le checkpoint.

### 4.3 PMDC

Couche Pokémon-spécifique. Présent dans Crooked Cavern via :
- `PMDC.LevelGen.BossRoom` (`crooked_cavern.json:342, 829`) — placement de boss.
- `PMDC.LevelGen.SaveVarsZoneStep` (`crooked_cavern.json:1010`) — génère **en fonction des variables de sauvegarde** (utile : permet de conditionner la génération à `CheckpointUnlocked`). Ce n'est **pas** un système de respawn checkpoint complet, mais un levier utilisable.

### 4.4 PMDODump / DumpAsset

(non clonés dans ce workspace, mais la conclusion asset est tranchée par inspection du projet lui-même — §6.1.)

### 4.5 PMDOTutorial

Le tutoriel officiel confirme le **patron standard** du retour-checkpoint dans [Tutorial:Basic Zone Scripts](https://wiki.pmdo.pmdcollab.org/Tutorial:Basic_Zone_Scripts) :

```lua
-- fallback : renvoyer au dernier checkpoint (lieu de reprise du run)
COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment,
                     SV.checkpoint.Map, SV.checkpoint.Entry)
```

Donc `SV.checkpoint` + `COMMON.EndDungeonDay` est le **mécanisme natif documenté** pour « retourner au point de reprise ». Important : c'est le retour de **fin de journée de donjon** (entrée / ville), **pas** un midpoint Kangourex. Les deux concepts sont distincts (§5).

### 4.6 Wiki PMDO

- [Script Reference](https://wiki.pmdo.pmdcollab.org/Script_Reference) : **aucune** fonction checkpoint/relay dans tout le référentiel Lua.
- [Map and Adventure Control](https://wiki.pmdo.pmdcollab.org/Game_(functions)/Map_and_Adventure_Control) : `ContinueDungeon` est documenté textuellement comme **« Used in rescue team like midpoint contexts (where PP and belly is not restored). »** → c'est la brique native du midpoint.
- [Floor Generation Overview](https://wiki.pmdo.pmdcollab.org/Floor_Generation_Overview) : couvre LoadGen / Zone Steps / priorités (Save Variables, Houses, Spawn Mobs…). **Aucun concept de checkpoint mi-donjon** ; c'est de la génération procédurale pure.

### 4.7 Le projet Halcyon lui-même — **le point clé**

Le projet contient **déjà un midpoint Kangourex fonctionnel** : **Searing Tunnel**. C'est le seul donjon du mod à en avoir un. Détail du mécanisme en §5.

Autres donjons à boss vérifiés : **aucun** n'a de midpoint (ils n'ont que des grounds `*_boss` / `*_miniboss` / `*_guardian`, pas de `*_midpoint`) :
- `gloomy_forest` : clear → `gloomy_forest_boss` ; mort → mapID 1.
- `mount_windswept` : clear → `mount_windswept_miniboss`/`_guardian` ; mort → `exit_ground`.
- `vast_steppe` : clear → `vast_steppe_miniboss`/`_guardian` ; mort → mapID 46/47.

→ **Le checkpoint mi-donjon est actuellement unique à Searing Tunnel.** L'étendre à Crooked Cavern (puis aux autres donjons à boss) est une généralisation, pas une recréation.

### 4.8 Catalogue d'assets

Vérifié directement dans `Content/Object/` :
- ✅ **`Kangaskhan_Rock.dir`** présent (objet statue Kangourex, binaire avec PNG embarqué). Déjà câblé à `GeneralFunctions.Kangashkhan_Rock_Interact` et utilisé par **5** ground maps (`gloomy_forest_entrance`, `mount_windswept_entrance`, `vast_steppe_entrance`, `searing_tunnel_entrance`, `searing_tunnel_midpoint`).
- ❌ **`Statue_Dungeon.dir` ABSENT** du projet (contrairement à ce que dit le prompt). Il n'existe que dans DumpAsset / la base PMDO.
- ❌ `Statue_Friend.dir`, `Statue_Guild.dir` également absents du projet.

---

## 5. Comment fonctionne RÉELLEMENT le checkpoint Searing Tunnel (le modèle)

Sources : `zone/searing_tunnel/init.lua`, `ground/searing_tunnel_midpoint/init.lua`, `ground/searing_tunnel_midpoint/searing_tunnel_midpoint_ch_5.lua`, `scriptvars.lua`.

### 5.1 Les variables de sauvegarde impliquées
- `SV.SearingTunnel.DiedPastCheckpoint` (`scriptvars.lua:850`) — *« flag whether you died in depths/crucible. Needed for cutscenes on wiping and waking up back in the checkpoint. »*
- `SV.Chapter5.TunnelMidpointState` (`scriptvars.lua:769`) — état de scène : `'FirstArrival'` / `'RepeatArrival'` / `'DeathArrival'`.
- `SV.Chapter5.PlayedMidpointIntro` (`scriptvars.lua:768`).

### 5.2 Le hook de défaite (dans `zone/searing_tunnel/init.lua`, `ExitSegment`)
- Segment 0 clear → envoi vers le midpoint (mapID 48) : `GAME:EndDungeonRun(..., "master_zone", -1, 48, 0, …)` / `EnterGroundMap('searing_tunnel_miniboss' …)`.
- **Segment 1 mort** (lignes 124-133) : `SV.SearingTunnel.DiedPastCheckpoint = true` → `TunnelMidpointState = 'DeathArrival'` → `GAME:EndDungeonRun(result, "master_zone", -1, 48, 0, true, true)` → `GAME:EnterZone("master_zone", -1, 48, 0)` **= retour au midpoint**.
- **Boss (segment 2) mort** (lignes 181-189) : même logique → retour au midpoint (mapID 48).
- **Échappé (Escaped)** depuis le segment 1 : renvoyé à l'**entrée** (mapID 47), **PAS** au checkpoint → nuance importante : « escape » ≠ « mort après checkpoint ».

### 5.3 La ground map midpoint (`ground/searing_tunnel_midpoint/init.lua`)
- `PlotScripting()` branche sur 3 cas : `FirstArrival` (intro), `DiedPastCheckpoint` (`WipedCutscene`), sinon `SetupGround`.
- `Kangaskhan_Rock_Action` → `GeneralFunctions.Kangashkhan_Rock_Interact` (menu Stockage / Retrait / Tout stocker / Banque / **Save**).
- `North_Exit_Touch` → `GAME:EnterDungeon("searing_tunnel", 1, 0, 0, DungeonStakes.Risk, true, false)` = **continuer dans la 2e moitié** (segment 1).
- `South_Exit_Touch` → retour à l'entrée / ville.
- `GameSave`/`GameLoad` → sauvent/chargent la position du partenaire.

### 5.4 L'intention de design, confirmée par le code du projet
`searing_tunnel_midpoint_ch_5.lua:325` :
> *« Looks like we're back at the midpoint… If any of us faint past the midway point, looks like we get sent back here instead of the entrance. »*

→ C'est **exactement** le comportement demandé pour Crooked Cavern.

---

## 6. État actuel de Crooked Cavern vs. l'objectif

| Aspect | Aujourd'hui (Crooked) | Objectif (checkpoint) |
|---|---|---|
| Lieu de repos mi-donjon | ❌ aucun (`crooked_den` = scène, pas refuge) | ✅ sanctuaire Kangourex |
| Statue Kangourex | ❌ | ✅ |
| Sauvegarde mi-donjon | ❌ | ✅ via `GAME:GroundSave` |
| Stockage / banque | ❌ | ✅ via `Kangashkhan_Rock_Interact` |
| Respawn post-checkpoint | partiel (mort boss → `crooked_den`) | ✅ vers le midpoint |
| Pas de retour arrière | n/a | ✅ sortie unique vers l'avant |

---

## 7. ⚠️ CONTRAINTE DE FAISABILITÉ MAJEURE — données de ground map absentes

C'est la découverte la plus importante de cet audit, **manquée par le rapport précédent**.

**Fait** : ce repo GitHub **ne contient aucune donnée de layout de ground map**.
- Aucun fichier `.rsground`, `.dat` de ground map, ni dossier `Data/Ground/`.
- Le champ `"GroundMaps"` de chaque zone (`crooked_cavern.json:2894`, `master_zone.json:83033`) n'est qu'une **liste de noms** (60 chaînes), pas les données de tiles/entités.
- Les 16 fichiers `.rsmap` sont des maps de **donjon** (`RogueEssence.Dungeon.Map`, ex. `chapter_3_boss_fight.rsmap` qui charge le boss), **pas** des ground maps.
- Extensions présentes dans `Data/` : `bin idx json jsonpatch lua resx rsmap xml`. Aucune extension de ground map.

**Conséquence** : les ground maps (`crooked_den`, `searing_tunnel_midpoint`, `metano_town`…) sont **référencées par nom** mais leurs layouts (tiles, placement du Kangaskhan Rock, zones de toucher des sorties `North_Exit_Touch`, entry points) sont **absents du repo**. Ils vivent dans le dossier de travail PMDO de l'auteur (produits par le **Ground Map Editor**, un outil GUI de la build de dev PMDO).

**Implication pour l'implémentation** — elle se scinde obligatoirement en deux :

| Partie | Faisable dans ce workspace ? |
|---|---|
| **Logique script** (routage défaite, variables SV, interaction Kangourex, dialogues FR, enregistrement de la nouvelle ground map dans `master_zone.json`) | ✅ **Oui** — 100% texte/Lua/JSON |
| **Authoring du layout de la salle** (tiles grotte, socle, placement de `Kangaskhan_Rock`, zones de sortie, ambiance) | ❌ **Non** — nécessite le **Ground Map Editor** (GUI PMDO) pour produire le fichier binaire `crooked_cavern_midpoint` |

Je ne peux donc pas « construire la salle » entièrement ici. Je peux livrer toute la couche logique + un guide précis d'authoring côté éditeur.

---

## 8. Décision technique recommandée

**Réutiliser le patron Searing Tunnel**, en l'écrivant **une fois de façon réutilisable** (pas en dur pour Crooked seulement), puis l'instancier pour chaque donjon à boss.

Composants à créer / modifier :

### 8.1 Variables SV (dans `scriptvars.lua`)
```lua
SV.CrookedCavern = {
  CheckpointUnlocked = false,
  DiedPastCheckpoint = false,
  MidpointState = 'FirstArrival',  -- FirstArrival / RepeatArrival / DeathArrival
}
```
→ **Généralisable** : un même sous-table par donjon à boss, ou une table générique `SV.Midpoints[zoneID]`.

### 8.2 Nouvelle ground map `crooked_cavern_midpoint`
- **Enregistrement** : ajouter `"crooked_cavern_midpoint"` dans la liste `GroundMaps` de `master_zone.json` ( ligne 83076, après `"crooked_den"`).
- **Layout** : à authoriser dans le Ground Map Editor (cf. §7). Biome : réutiliser `Content/Tile/Crooked_Cavern_Base.tile`, `Crooked_Cavern_Objects.tile`, `Crooked_Cavern_Shadows.tile`, `Crooked_Den.tile` (déjà présents).
- **Entités** : un objet `Kangaskhan_Rock` (asset `Kangaskhan_Rock.dir` confirmé), une sortie `North_Exit` (vers `crooked_den`), **pas** de sortie arrière (règle « pas de retour en arrière »).
- **mapID** : à déterminer (Searing = 48 ; Crooked devra obtenir le sien dans la liste `GroundMaps` de master_zone).

### 8.3 Script midpoint `Data/Script/halcyon/ground/crooked_cavern_midpoint/init.lua`
Cloner la structure de `searing_tunnel_midpoint/init.lua` :
- `PlotScripting()` sur 3 états (FirstArrival / DeathArrival / repeat).
- `Kangaskhan_Rock_Action` → `GeneralFunctions.Kangashkhan_Rock_Interact`.
- `North_Exit_Touch` → `GAME:EnterGroundMap("crooked_den", "Main_Entrance_Marker")` (préserve la scène pré-boss existante).
- `GameSave`/`GameLoad` via `PartnerEssentials`.
- **Pas de `South_Exit_Touch`** (pas de retour arrière), ou un retrait validé explicitement.

### 8.4 Routage dans `zone/crooked_cavern/init.lua` (`ExitSegment`)
- Segment 0 **clear** : au lieu d'aller direct à `crooked_den`, envoyer au midpoint (`GAME:EnterGroundMap('crooked_cavern_midpoint', …)`) et y activer le checkpoint.
- Segment 1 (boss) **mort** : `SV.CrookedCavern.DiedPastCheckpoint = true` + `MidpointState = 'DeathArrival'` + `GAME:EndDungeonRun(..., "master_zone", -1, <midpoint_mapID>, 0, true, true)` puis `GAME:EnterZone("master_zone", -1, <midpoint_mapID>, 0)` — **retour au midpoint, pas à l'entrée**.
- `Escaped` : renvoyer à l'entrée (cohérent avec Searing Tunnel).

### 8.5 Hook de pénalités
**Ne pas recoder** les règles d'inventaire : elles passent par `GAME:EndDungeonRun` → `GameProgress.EndGame(...)` → `OnLossPenalty` (moteur). À laisser intact.

---

## 9. Décision de design à trancher avant de coder

Deux points nécessitent ton arbitrage (ils ne sont pas tranchables par défaut) :

### 9.1 Soin PP / Ventre au checkpoint ?
- **PMD classique** (Mt. Thunder étage 11, Statue Kangourex) : la statue **remet PP et Ventre à fond** ET sauvegarde.
- **Searing Tunnel (Halcyon)** : le midpoint **ne soigne pas** — le wiki le dit explicitement pour `ContinueDungeon` : *« where PP and belly is not restored »*. Le `Kangashkhan_Rock_Interact` n'appelle aucune fonction de soin.

→ Veux-tu le comportement **PMD classique** (refus → ajout d'un appel de soin dans le midpoint) ou la **cohérence Halcyon** (pas de soin, comme Searing Tunnel) ?

### 9.2 Une « seconde moitié » procédurale pour Crooked Cavern ?
Actuellement Crooked Cavern = 1 segment procédural + boss. Le prompt évoque une « seconde moitié plus dangereuse ». Deux options :
- **(a) Simple** : le checkpoint s'insère entre le segment 0 et le boss (sanctuaire « reprendre souffle avant le boss »). Aucun nouveau segment à générer.
- **(b) Étendu** : ajouter un 2e segment procédural plus dur après le checkpoint (Crooked devient 3 segments comme Searing Tunnel : segment 0, segment 1 « profondeurs », boss). Plus de travail, plus fidèle à « seconde moitié ».

---

## 10. Dialogues FR (à placer dans les strings de la ground map)

> *« L'antique Statue Kangourex veille sur les explorateurs épuisés. »*
> *« Votre aventure a été enregistrée en toute sécurité. »*

**Bug à corriger au passage** : `GeneralFunctions.Kangashkhan_Rock_Interact` (`GeneralFunctions.lua`, table `choices`) contient un libellé **en anglais codé en dur** : `{ "Save", true }`. À remplacer par `{ STRINGS:FormatKey('MENU_SAVE'), true }` (ou une clé FR équivalente). C'est valable pour **toutes** les maps qui l'utilisent (donc pour Crooked ET la cohérence générale).

Ambiance sonore candidates à valider en jeu (déjà présentes dans `Content/Music`) : `Heartwarming.ogg`, `Goodnight.ogg`, `At the End of the Day.ogg`, `Star Cave.ogg`.

---

## 11. Checklist de test (après implémentation)

1. Entrer Crooked Cavern normalement, clearer le segment 0.
2. Vérifier l'arrivée automatique dans `crooked_cavern_midpoint`.
3. Vérifier `SV.CrookedCavern.CheckpointUnlocked = true` (debug tools / save).
4. Interagir avec la Statue Kangourex → menu Stockage/Retrait/Tout stocker/Banque/Sauvegarder s'affiche.
5. Sauvegarder, quitter, recharger → retour correct au midpoint.
6. Sortir par le nord → arrive à `crooked_den` (scène pré-boss **préservée**).
7. Vérifier qu'**aucune** sortie arrière vers le segment 0 n'existe.
8. Perdre au boss → respawn au **midpoint** (`DeathArrival`), **pas** à l'entrée.
9. Vérifier que les pénalités d'inventaire sont celles standard PMDO (via `OnLossPenalty`).
10. Vérifier la non-régression des cinématiques `LostToBoss` / `SecondPreBossScene` / `DefeatedBoss`.
11. Si choix 9.1 = soin PMD classique : vérifier PP + Ventre restaurés à l'activation.
12. Tester le chargement sur une **installation PMDO complète** : si jamais on référence `Statue_Dungeon`, vérifier qu'il se charge ; sinon rester sur `Kangaskhan_Rock` (recommandé, déjà présent).
13. (Réutilisabilité) répéter la même instanciation pour un 2e donjon à boss et vérifier qu'aucun code en dur ne bloque.

---

## 12. Statut

- ✅ Audit terminé, refait intégralement à partir des sources.
- ✅ Crooked Cavern confirmé donjon à boss.
- ✅ Aucune fonction native checkpoint ; mécanisme standard déjà codé (Searing Tunnel).
- ✅ **Implémentation livrée** (voir §13) : toute la couche logique + config.
- ⏳ **Reste l'éditeur** : authoring du layout de la salle relay (§14-A) + tuning de difficulté du segment « Profondeurs » (§14-B).

---

## 13. Journal d'implémentation (réalisé dans ce repo)

Arbitrages appliqués : **§9.1 = `halcyon_coherence`** (pas de soin PP/Ventre), **§9.2 = `etendu`** (3 segments).

### Fichiers créés
- `Data/Script/halcyon/ground/crooked_cavern_midpoint/init.lua` — logique de la ground map relay (3 états, Kangaskhan Rock, sortie avant unique).
- `Data/Script/halcyon/ground/crooked_cavern_midpoint/crooked_cavern_midpoint_ch_3.lua` — scènes (FirstArrival / WipedCutscene / SetupGround / ContinueScene / Partner_Action). Coordonnées marquées `TODO_MAP`.
- `Data/Script/halcyon/ground/crooked_cavern_midpoint/strings.resx` (EN) + `strings.fr.resx` (FR) — 13 clés `CCM3_*`, XML validé.
- `tools/add_crooked_profondeurs.py` — outil (transparent, ré-exécutable) qui insère le segment « Profondeurs ».
- `docs/authoring_crooked_cavern_midpoint.md` — guide d'authoring éditeur (layout salle + tuning difficulté).

### Fichiers modifiés
- `Data/Script/halcyon/scriptvars.lua` — ajout `SV.CrookedCavern.DiedPastCheckpoint` + flags `SV.Chapter3.CrookedPlayedMidpointIntro` / `CrookedMidpointState`.
- `Data/Script/halcyon/services/debug_tools/init.lua` — garde-fous `nil` pour compatibilité des sauvegardes existantes (modèle Searing).
- `Data/Script/halcyon/zone/crooked_cavern/init.lua` — `ExitSegment` réécrit pour **3 segments** + routage checkpoint (segment 0 clear → relay mapID 60 ; mort segment 1/2 → relay). Logique story ch3 (gate `FinishedRootScene`) préservée et commentée.
- `Data/Script/halcyon/ground/crooked_den/crooked_den_ch_3.lua` — `ContinueDungeon("crooked_cavern", 1…)` → **`2`** (boss décalé en segment 2), lignes 489 & 813.
- `Data/Script/halcyon/GeneralFunctions.lua` — fix bug : bouton `"Save"` (EN dur) → `"Sauvegarder."` (cohérent FR ; valable pour les 5 maps utilisant le handler).
- `Data/Zone/master_zone.json` — `crooked_cavern_midpoint` enregistré en fin de liste `GroundMaps` (→ **mapID 60**, zéro décalage des mapID existants).
- `Data/Zone/crooked_cavern.json` — **3 segments** (segment 1 « Profondeurs » inséré par duplication sûre du segment 0, format plat PMDO préservé, boss en segment 2). Vérifié : `chapter_3_boss_fight` toujours en segment 2.

### Vérifications automatisées passées
- JSON valides (`crooked_cavern.json` 3 segments ; `master_zone.json` 61 ground maps ; resx XML valides).
- mapID cohérents : relay = 60 partout (zone script), boss = segment 2 (ContinueDungeon), Profondeurs = segment 1 (EnterDungeon depuis le relay).
- Scripts Lua équilibrés (`function`/`if-then`/`for-do`/`while-do`/`repeat` vs `end`/`until`) sur les 3 fichiers concernés.

### Réutilisabilité (autres donjons à boss)
Le patron est générique. Pour l'étendre (ex. `gloomy_forest`, `mount_windswept`) :
1. ajouter un relay ground map + scripts (cloner `crooked_cavern_midpoint`), l'enregistrer en fin de `GroundMaps` (noter son mapID) ;
2. ajouter une table `SV.<Zone> = { DiedPastCheckpoint = false }` + flags chapitre + garde-fous `nil` ;
3. reprendre le routage `ExitSegment` (segment clair → relay ; mort post-checkpoint → relay).
Adapter le **décor au biome** de chaque donjon (cf. exigence du prompt) — pas de salle générique copiée.

---

## 14. Reste à faire côté éditeur (non faisable depuis ce repo)

### 14-A. Authoring du layout du relay `crooked_cavern_midpoint`
La ground map est enregistrée (mapID 60) et scriptée, mais son **layout n'existe pas** (le repo ne contient aucune donnée de ground map — cf. §7). À créer dans le **Ground Map Editor** : tilesets grotte existants, entités nommées `Main_Entrance_Marker` / `North_Exit` / `Kangaskhan_Rock` (objet `Kangaskhan_Rock.dir`), BGM `Heartwarming.ogg`, ambiance sanctuaire (cristaux, mousse, fleurs, **aucun ennemi/piège**), **sortie avant unique**. Puis régler les coordonnées `TODO_MAP` du fichier scène. Détails : `docs/authoring_crooked_cavern_midpoint.md`.

### 14-B. Tuning de difficulté du segment « Profondeurs »
Le segment 1 est un **scaffold** = copie exacte du segment 0 (même roster, niveaux auto-scalés). À durcir dans le **Zone Editor** + playtest : espèces plus costauds, densité, pièges, Monster Houses. Ne peut pas se faire à l'aveugle depuis le texte.

---

## 15. Checklist de test (à passer en jeu)

1. Lancer Crooked Cavern (run du boss, `FinishedRootScene == false`), clearer le segment 0.
2. Arrivée automatique dans `crooked_cavern_midpoint` (mapID 60), intro `FirstArrival` jouée.
3. `SV.Chapter3.CrookedPlayedMidpointIntro == true` après l'intro.
4. Interagir avec la Statue Kangourex → menu FR (Stockage / Retrait / Tout stocker / Banque / **Sauvegarder.** / Annuler).
5. Sauvegarder, quitter, recharger → retour correct au relay.
6. **Aucune sortie arrière** : seul `North_Exit` est disponible.
7. Sortir par le nord → `EnterDungeon("crooked_cavern", 1, 0, 0)` → **Profondeurs** (segment 1).
8. Clearer la Profondeurs → `crooked_den` → `FirstPreBossScene` → boss (segment 2). **Non-régression** des scènes existantes.
9. Mourir dans la Profondeurs → respawn au **relay** (`DeathArrival` / `WipedCutscene`), PAS à l'entrée.
10. Mourir au boss → respawn au **relay** (branche `LostToBoss` du `WipedCutscene`).
11. S'échapper (Escape Orb) depuis la Profondeurs → retour à l'**entrée** (mapID 41), pas au relay (par conception, miroir Searing).
12. Pénalités d'inventaire = règles standard PMDO (`OnLossPenalty`), inchangées.
13. PP / Ventre **NON restaurés** au checkpoint (décision `halcyon_coherence`).
14. Post-boss (`FinishedRootScene == true`), replays → `crooked_den` GenericEnding (chemin inchangé).
15. (Coordonnées `TODO_MAP`) vérifier que les téléportations/déplacements du relay collent au layout réel après authoring éditeur.
16. (Réutilisabilité) vérifier qu'aucun mapID codé en dur n'a été cassé (indices GroundMaps préservés).

