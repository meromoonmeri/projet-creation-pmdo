# Sonde runtime NRE `IsGameOver()` — mécanisme prouvé + instrumentation (2026-07-27)

## 1. Le mécanisme EXACT de la boucle infinie (lignes du moteur)

Sources lues intégralement : `DungeonScene.cs`, `DSceneZone.cs`, `GameManager.cs`,
`Map.cs`, `Zone.cs`, `LuaEngine.cs` (RogueCollab/RogueEssence).

```
DungeonScene.cs:281  public override IEnumerator ProcessInput()
DungeonScene.cs:283      if (IsGameOver())          ← appelé CHAQUE frame de la scène donjon
DSceneZone.cs:~46    public bool IsGameOver()
                         foreach (Character c in ZoneManager.Instance.CurrentMap.ActiveTeam.Players)
                                                            └─ CurrentMap.ActiveTeam == null → NRE
```

`Map.ActiveTeam` est `[NonSerialized]` (Map.cs). Il est :
- **détaché** par `DSceneZone.ExitFloor()` **ligne 53** : `CurrentMap.ActiveTeam = null;`
- **rattaché** uniquement par `Map.EnterMap()` (appelé par `EnterFloor`).

`GameManager.exitMap()` (ligne 576) appelle `ExitFloor()` **au tout début** de
CHAQUE transition (`MoveToZone` 667, `MoveToGround` 720). Si N'IMPORTE QUELLE
exception survient **après** `ExitFloor()` et **avant** `EnterFloor()/
EnterGround()`, la scène reste `DungeonScene` avec une carte à équipe nulle →
`ProcessInput` → `IsGameOver()` → **NRE à chaque frame, boucle infinie** — le
moteur n'a aucun chemin de récupération. C'est le mécanisme démontré du
symptôme, quelle que soit l'exception déclencheuse.

### Les déclencheurs possibles dans cette fenêtre (tous vérifiés côté données)

| Déclencheur (ligne moteur) | Scan effectué | Résultat |
|---|---|---|
| `MoveToGround:715` `Invalid Ground Map Name` (ground pas dans le résumé) | 129 zones × cibles EnterGroundMap | 42 corrigés au tour précédent, **0 restant** |
| `MoveToGround:731` `Cannot find ground map` (index dit oui, ZoneData dit non) | index↔JSON strict | **0 desync** |
| `MoveToGround:743` `GetEntryPointIdx` → KeyNotFoundException (marker absent de la **couche 0**) | 188 paires (ground, marker) des scripts | **0 manquant** |
| `MoveToZone:651` `Invalid Segment ID` | déjà corrigé (index) | 0 |
| Erreur Lua dans `OnEnterSegment`/`EnterSegment` | 528 scripts loadfile + revue EnterSegment ch5 | 0 erreur de chargement |
| `$values` orphelin / `rand.s` dégénéré dans les **.rsmap** (jamais scanné avant) | 370 rsmap | **0** |
| Génération d'étage : le moteur fait 5 tentatives puis **fallback map vide 10×10** (Zone.cs) — ne crashe PAS | — | non déclencheur |

**Conclusion statique** : dans la copie de CE dépôt, plus aucun déclencheur
connu n'est présent. Si le crash persiste chez toi À L'IDENTIQUE, il reste
deux possibilités que seule l'exécution peut départager : (a) la copie
installée dans MODS n'est pas synchronisée avec ce dépôt (les fixes des
3 derniers commits n'y sont pas), (b) un déclencheur que les scans statiques
ne peuvent pas voir (état de sauvegarde spécifique). D'où la sonde ci-dessous.

## 2. Instrumentation runtime livrée (ce commit)

### a) Service `nre_probe` (`Data/Script/halcyon/services/nre_probe/init.lua`)

Abonné à TOUS les événements moteur accessibles depuis Lua (ZoneInit,
DungeonModeBegin/End, DungeonMapInit, DungeonFloorEnter/Exit,
DungeonSegmentStart/End, GroundModeBegin/End, GroundMapEnter/Exit). À chaque
événement, il logge une ligne `[NREPROBE]` avec :

- zone / segment / map courants ;
- effectif et leader de `_DATA.Save.ActiveTeam` (source de vérité) ;
- **état de `CurrentMap.ActiveTeam`** : `TeamAttachee=OUI(n)` ou
  `TeamAttachee=NON <- IsGameOver() CRASHERAIT ICI` — c'est exactement la
  référence que le moteur déréférence ;
- nombre d'équipes ennemies.

Tous les accès sont sous `pcall` : la sonde ne peut pas crasher le jeu.

### b) Marqueur de version dans `main.lua`

`[NREPROBE] build 2026-07-27-B charge — si cette ligne est ABSENTE du log, la
copie du mod installee dans MODS est PERIMEE.`
→ tranche immédiatement l'hypothèse « installation périmée » (les logs que tu
m'as fournis ne contiennent AUCUN des logs `[BossSeq]` ajoutés au commit
précédent, ce qui est exactement la signature d'une copie non synchronisée).

### c) Sondes locales dans les 7 grounds boss/mini-boss ch5+ch7

`nre_snap()` au début de `Init()` et `Enter()` de vast_steppe_miniboss,
mount_windswept_miniboss, searing_tunnel_miniboss, vast_steppe_guardian,
mount_windswept_guardian, searing_crucible, cloven_ruins_boss + un log
`[NREPROBE][transition]` immédiatement AVANT chaque `ContinueDungeon` /
`EnterDungeon` / `EnterGroundMap` de la séquence.

### d) FILET DE SÉCURITÉ anti-boucle infinie (auto-récupération)

`NREProbe:Update()` détecte l'état « limbo » (un mode quitté —
DungeonModeEnd/GroundModeEnd — sans qu'aucun mode ne soit rentré) :
- après ~120 ticks : avertissement + snapshot complet dans le log ;
- après ~600 ticks : **renvoi forcé au bourg** (`GAME:EnterZone('master_zone',
  -1, 1, 0)`), ce qui casse la boucle NRE au lieu de geler le jeu.

Ce filet ne masque pas la cause : le log `[NREPROBE]` immédiatement précédent
identifie la transition fautive.

## 3. Mode d'emploi (ce dont j'ai besoin de toi)

1. **Resynchronise la copie installée** : recopie l'INTÉGRALITÉ du dépôt dans le
   dossier MODS (pas seulement Data/Script — aussi `Data/Zone/*.json` et
   `Data/Zone/index.idx`).
2. Lance le jeu : vérifie que le log contient `[NREPROBE] build 2026-07-27-B`.
   - **Absent** → l'installation n'est pas celle du dépôt : c'est la cause.
3. Reproduis le crash (relais Steppe → sortie nord → mini-boss).
4. Envoie-moi la section du log autour de la première NullReferenceException :
   les lignes `[NREPROBE]` et `[BossSeq]` juste avant donnent :
   - la transition exacte (zone/segment/ground source → cible) ;
   - l'état de l'équipe attachée à cet instant ;
   - le fichier/l'appel Lua responsable.

Avec ce log, la référence null, la ligne, la transition et le script fautif
seront identifiés **par preuve d'exécution**, sans supposition.

## 4. Fichiers de ce lot

- `Data/Script/halcyon/services/nre_probe/init.lua` (nouveau service, retirable)
- `Data/Script/halcyon/main.lua` (require + marqueur de build)
- 7 `ground/*/init.lua` + 5 `*_ch_5.lua` + 3 `zone/*/init.lua` (sondes locales)
- 528/528 scripts revalidés loadfile.
