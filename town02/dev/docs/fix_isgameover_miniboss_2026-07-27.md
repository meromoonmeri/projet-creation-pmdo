# Crash mini-boss `IsGameOver()` NRE — analyse cause racine + passe de fiabilisation (2026-07-27)

## 1. Réponse à la question : génération ou script ?

**Les deux pistes ont été tranchées.** L'audit précédent garantit la génération
des étages (MapID/autotiles/teams 100 % valides — re-vérifié : 0 slot null dans
les MonsterTeams des 370 maps, 0 intrinsic/skill/item cassé). Le crash
`NullReferenceException` dans `DungeonScene.IsGameOver()` vient du **flux de
scripts autour de la salle**, pas de la map elle-même. Trois défauts réels ont
été trouvés, dont deux **bloquants**.

### Cause racine n°1 (le NRE lui-même) : `ContinueDungeon` sans session active

Code moteur vérifié (`DSceneZone.cs`) :
```csharp
public bool IsGameOver() {
    foreach (Character c in ZoneManager.Instance.CurrentMap.ActiveTeam.Players) ...
}
```
`ActiveTeam` est `[NonSerialized]` (Map.cs) : il n'est attaché à la carte que
lorsqu'une **session d'aventure** est ouverte (`BeginGameInSegment`) ou
continuée (`BeginSegment`). La séquence cassée :

1. Le joueur meurt au-delà du checkpoint → `EndDungeonRun` → respawn au
   **relais copie master_zone** (ground 62). La session d'aventure est FERMÉE.
2. Sortie nord du relais → l'ancien code envoyait vers le donjon, et les
   grounds de cinématique mini-boss enchaînent sur
   `GAME:ContinueDungeon(zone, seg, …)` = `BeginSegment` = **continuer une
   session… qui n'existe plus**. La carte de combat se charge sans
   `ActiveTeam` attaché.
3. Premier tick d'input → `ProcessInput` → `IsGameOver()` →
   `CurrentMap.ActiveTeam` = null → **NRE**. (« L'étage semble ne pas se
   charger » = même état, vu avant le premier input.)

**Fix** : les sorties nord des relais routent selon l'état de session
(`_ZONE.CurrentZoneID`) — session active → `EnterGroundMap`/`ContinueDungeon` ;
session fermée (master_zone) → `EnterDungeon` (= `BeginGameInSegment`, ouvre
une session neuve, y compris `(-1, 1)` pour arriver sur le ground de
cinématique du mini-boss). Logs `[BossSeq]` ajoutés à chaque étape (entrée
salle, scène, transition combat, victoire/défaite) comme demandé.

### Cause racine n°2 (bloquante, 42 zones) : arènes absentes des `GroundMaps`

Code moteur (`GameManager.MoveToGround`) : `EnterGroundMap(name, entry)` vérifie
`summary.GroundValid(mapname)` — le ground DOIT être listé dans les `Grounds`
du résumé de la zone COURANTE, sinon `ArgumentException: Invalid Ground Map
Name`. Or **42 arènes de boss d'Ancrage** (arene_trone_magma, abime_tempetes,
champ_braises, lac_savoir/espoir/courage, sanctuaire_voeu, escalier_origine…)
étaient appelées par le `ExitSegment` de leur zone **sans être déclarées** dans
les `GroundMaps` de cette zone → l'entrée en salle de boss de TOUS les donjons
légendaires ch11-32 plantait. **Fix** : 42 grounds ajoutés aux `GroundMaps` de
leurs 42 zones + `index.idx` resynchronisé (129/129, re-scan : 0
`ContinueDungeon` à risque restant).

### Cause racine n°3 : mini-boss steppe/mont **orphelins** + scènes corrompues

- Le relais de la Grande Steppe et du Mont Venteux envoyaient **directement au
  segment 2** : l'arène du mini-boss n'était jamais jouée dans le nouveau flux
  à checkpoint (elle datait du flux ancien seg0→miniboss). Rebranché :
  Nord = rencontre mini-boss (si `SteppeMiniBossCleared`/`MountMiniBossCleared`
  = false), sinon segment 2. Flags **persistants** ajoutés (`scriptvars.lua` +
  rétroactif OnUpgrade pour les parties existantes) — les anciens flags
  `*Defeated` étaient des flags de routage remis à false après la scène, donc
  inutilisables pour « déjà vaincu ».
- **6 cinématiques `DiedToBoss` réécrites** (steppe/tunnel/mont mini-boss,
  steppe/mont gardien, Regigigas ch7) : l'ancien code était un collage
  corrompu — dialogues joués AVANT `CutsceneMode(true)`/`FadeIn` (affichés sur
  écran noir, hors mode cinématique, pendant que le moteur traite encore des
  inputs — exactement la fenêtre où un NRE d'état est possible), répliques de
  VICTOIRE mélangées dans la défaite, héros/partenaire `Hide()` en pleine
  scène. Nouveau storyboard (cf. §2).

## 2. Mise en scène des 6 scènes de défaite réécrites (storyboard)

1. **Fondu d'ouverture** : le duo est au sol (EventSleep), caméra basse.
2. **Travelling vertical** vers le vainqueur (40-60 frames) — la caméra révèle
   le boss avant qu'il « parle ».
3. **Triomphe** : emote + Hop (mini-boss) ou posture Charge (gardiens/Titan),
   ligne de narration centrée.
4. **La Voix de l'Abysse** : 3 répliques, silences de 20-30 frames entre elles.
5. **Retour caméra sur le duo** : le partenaire se réveille (`Wake`), réplique
   de douleur — regard cohérent, plus de dialogue « depuis nulle part ».
6. **Retraite du boss** (narration centrée) → fondu noir → retour à l'entrée.

Chaque étape est logguée (`[BossSeq][…]`). 2 clés inversées EN/FR
supplémentaires corrigées au passage (VSM_020, MWM_018, CRB_016 — ratées par
l'heuristique globale car peu de mots-outils).

## 3. Scan systémique (la même erreur ailleurs ?)

| Pattern | Scan | Résultat |
|---|---|---|
| dialogue avant `CutsceneMode(true)` | 527 scripts, toutes fonctions | 7 trouvées → **7 réécrites**, 0 restante |
| `ContinueDungeon` depuis un ground hors `GroundMaps` de la zone | 244 grounds × 129 zones | 42 trouvées → **42 zones patchées**, 0 restante |
| slots null dans MonsterTeams des maps | 370 rsmap | 0 |
| `EnterGroundMap` vers ground inexistant | tous scripts | 0 |
| `LuaBeginBattleEvent`/`map_clear_check` | 6 arènes ch3-5 + moteur | conformes au patron officiel (map_clear_check = base game) |
| index désync après patchs | 129 zones | 0 (resync automatique inclus) |

## 4. Fichiers modifiés

- `Data/Script/halcyon/ground/vast_steppe_midpoint/init.lua` — routage session + mini-boss rebranché + logs
- `Data/Script/halcyon/ground/mount_windswept_midpoint/init.lua` — idem
- `Data/Script/halcyon/ground/{vast_steppe,mount_windswept,searing_tunnel}_miniboss/*_ch_5.lua` — DiedToBoss réécrit, flag Cleared posé dans DefeatedBoss, logs
- `Data/Script/halcyon/ground/{vast_steppe,mount_windswept}_guardian/*_ch_5.lua` — DiedToBoss réécrit
- `Data/Script/halcyon/ground/cloven_ruins_boss/cloven_ruins_boss_ch_7.lua` — DiedToBoss réécrit
- `Data/Script/halcyon/scriptvars.lua` — flags persistants `*MiniBossCleared`
- `Data/Script/halcyon/services/debug_tools/init.lua` — rétroactif OnUpgrade
- **42 `Data/Zone/*.json`** — arènes ajoutées aux GroundMaps + `Data/Zone/index.idx` resync
- 3 paires resx — VSM_020/MWM_018/CRB_016 remises dans la bonne langue

## 5. Validation

527/527 scripts Lua chargent sans erreur ; 0 JSON invalide ; index 100 %
synchrone ; 0 pattern corrompu restant ; toutes les cibles de transition
existent. Le grand chantier « caméra dynamique/personnages vivants sur TOUTES
les cinématiques » (demandes §2-§11) est engagé ici sur les 7 scènes les plus
critiques (défaites boss) ; la généralisation aux ~100 autres scènes est un
chantier continu — les scènes déjà conformes (FirstArrival ch5, WipedCutscene
vague 8, 42 cinés d'Ancrage vague 7) suivent déjà cette grammaire.
