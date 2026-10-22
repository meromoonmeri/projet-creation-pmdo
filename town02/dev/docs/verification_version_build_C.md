# Vérification « quelle version tourne réellement ? » — arbre de décision (2026-07-27, build C)

## 0. Note sur le fichier de log joint

Le fichier `2026-07-27.txt` n'est pas arrivé dans mon espace de travail
(dossier d'upload vide côté sandbox). Je n'ai donc pas pu le lire — renvoie-le
ou colle l'extrait. Mais l'étape ci-dessous est de toute façon **préalable** :
elle permet de trancher sans ambiguïté, avec ou sans ce fichier.

## 1. Où apparaît la TOUTE PREMIÈRE ligne `[NREPROBE]` (réponse précise)

Ordre de chargement du moteur (vérifié dans LuaEngine.cs) : au **lancement du
jeu**, le moteur initialise le script engine du mod → exécute `main.lua` (top
niveau) → instancie les services → publie `EngineServiceEvents.Init`.

Donc, **au lancement du jeu, AVANT l'écran titre**, tu dois voir dans l'ordre :

```
[NREPROBE] build 2026-07-27-C charge (main.lua) — PREMIERE ligne attendue, au LANCEMENT du jeu. ...
[NREPROBE] service nre_probe ACTIF (EngineServiceEvents.Init) — build 2026-07-27-C
```

Puis, dès que tu cliques « Continuer » :

```
[NREPROBE] LoadSavedData <-- sauvegarde chargee (menu Continuer) | zone=... Save.Team=...
```

**Pas besoin d'attendre le crash** : si ces 2 premières lignes sont absentes du
tout début du log, la version exécutée n'est pas celle du dépôt. Point final.

## 2. Le tag de build est AUSSI sur une ligne que tu vois DÉJÀ

Tes logs contiennent déjà :
```
Loading default script variable values..
Script variables default values loaded!
```
Cette ligne vient de `scriptvars.lua` **du mod**. Elle est maintenant :
```
Script variables default values loaded! [build 2026-07-27-C]
```
→ **Preuve croisée imparable** : si tu vois encore `Script variables default
values loaded!` SANS `[build 2026-07-27-C]`, alors le jeu charge une copie
périmée de `Data/Script/halcyon/` — même si tu penses avoir copié les fichiers
(mauvais dossier MODS, doublon de mod, cache, quête dupliquée…).

De même, `=>> Init_vast_steppe_midpoint <<=` (présent dans ton log de crash)
est devenu `=>> Init_vast_steppe_midpoint <<= [build 2026-07-27-C]`.

## 3. Les trois cas, et comment le log les distingue

| Cas | Signature dans le log |
|---|---|
| **1. Mauvaise version chargée** | `Script variables default values loaded!` sans `[build 2026-07-27-C]` ET aucune ligne `[NREPROBE]` au lancement. |
| **2. Bonne version, crash AVANT les scripts instrumentés** | Les 2 lignes `[NREPROBE]` du lancement sont là, `...loaded! [build 2026-07-27-C]` est là, puis la NRE survient SANS ligne `[NREPROBE][transition]`/`nre_snap` avant elle. Les événements moteur (`DungeonModeEnd`, `GroundModeBegin`…) loggés par la sonde diront jusqu'où le flux est allé — la sonde s'abonne aux événements **moteur**, pas seulement aux scripts des salles : même si le crash précède tout script de mini-boss, on verra le dernier événement moteur franchi. |
| **3. Bonne version, crash APRÈS les scripts** | Lignes `[NREPROBE][...Enter]`, `[NREPROBE][transition] ...` visibles, la dernière identifie la transition fautive + l'état `TeamAttachee=OUI/NON`. |

### Sur l'hypothèse « le crash arrive avant les scripts » (ta question)

Elle est couverte : la stack de ton crash d'origine se termine par
`=>> Init_vast_steppe_midpoint <<=`, qui est un print **du script du mod** —
donc, dans la partie qui a crashé, le flux ATTEIGNAIT déjà les scripts Lua
du relais. Un crash « avant tout script » est incompatible avec ce marqueur.
Mais par sécurité, la sonde loggue désormais aussi les événements les plus
précoces disponibles côté Lua : `Init` (lancement), `NewGame`,
`LoadSavedData` (clic Continuer), `ZoneInit`, plus `EnterSegment`/
`ExitSegment` des 3 zones ch5 et `Enter`/`North_Exit_Touch` des relais.
Il n'existe **aucune fenêtre** entre le clic « Continuer » et le crash qui ne
soit pas encadrée par au moins un de ces logs — si la bonne version tourne.

## 4. Pourquoi le service ne pourrait-il PAS se charger ? (audit demandé)

Vérifié point par point :
- `main.lua` → `require 'halcyon.services.nre_probe'` : présent (ligne 16) ;
  le chemin correspond à `Data/Script/halcyon/services/nre_probe/init.lua` ✔
- Le service suit EXACTEMENT le patron de `debug_tools` (Class('NREProbe',
  BaseService) + `SCRIPT:AddService("NREProbe", NREProbe:new())` en fin de
  fichier) — même mécanisme d'enregistrement que les 4 services existants qui,
  eux, fonctionnent chez toi (leurs effets sont visibles en jeu) ✔
- Les noms d'événements utilisés existent tous dans l'enum du moteur
  (`EServiceEvents` de LuaEngine.cs, exposée en Lua sous
  `EngineServiceEvents`) : Init, NewGame, LoadSavedData, ZoneInit,
  DungeonModeBegin/End, DungeonMapInit, DungeonFloorEnter/Exit,
  DungeonSegmentStart/End, GroundModeBegin/End, GroundMapEnter/Exit ✔
- `loadfile` valide sur les 528 scripts (aucune erreur de syntaxe qui
  empêcherait `main.lua` de finir son chargement) ✔
- Un `require` qui échouerait ferait échouer TOUT `main.lua` → les services
  existants (menu debug, etc.) disparaîtraient aussi — symptôme impossible à
  manquer ✔

Conclusion : si la copie chargée est celle du dépôt, la sonde démarre. Le seul
mode de défaillance restant est une copie non synchronisée — précisément ce
que le tag `[build 2026-07-27-C]` sur une ligne DÉJÀ visible chez toi permet
de prouver en 5 secondes.

## 5. Check-list d'installation (2 minutes)

1. Repère le dossier du mod chargé par le jeu : celui affiché dans le menu
   Mods/Quests du jeu (namespace `halcyon`). Attention aux DOUBLONS : deux
   dossiers contenant un Mod.xml avec le même nom — le jeu peut charger
   l'autre.
2. Supprime le contenu de ce dossier et recopie TOUT le dépôt (Data/, Content/,
   Mod.xml). Pas de copie partielle.
3. Lance le jeu, ouvre le log : cherche `2026-07-27-C`.
   - présent → reproduis le crash, envoie les 30 dernières lignes avant la
     première NullReferenceException ;
   - absent → le dossier que tu viens d'écraser n'est pas celui que le jeu
     charge : cherche le doublon (autre dossier MODS, autre profil, autre
     lanceur).
