# AUDIT MONT WINDSEP (Mont Venteux) — 2026-07-29

> Revue intégrale ordonnée par la directive de revue (annexe B de
> `PASSATION_AGENT_ARENA.md`) : Grounds, Entrance, Donjon, cinématiques,
> transitions. Chaque incohérence est consignée avec **fichier + ligne** et
> la preuve qui l'établit. Rien ici n'est testé en jeu : audit statique
> uniquement.
>
> Base revue : commit `b7afed9` + restauration de la passation (`7020c50`).

---

## 1. ÉTAT RÉEL MESURÉ (css corridors avec le §14 de la passation)

Le tableau comparatif du §14 de la passation est **périmé**. Mesures refaites
(le Tunnel matche au chiffre près les références : 214 coroutines, 114
CharAnimateTurnTo, 83 CharTurnToChar — la comparaison est fiable) :

| métrique | Tunnel (référence validée) | Mont actuel |
|---|---|---|
| lignes (`*_ch_5.lua`) | 2426 | 2335 |
| boîtes de dialogue | 237 | 195 |
| émotions (`CharSetEmote`) | 64 | 33 |
| coroutines (`BranchCoroutine`) | 214 | 90 |
| tours vers interlocuteur | 114 + 83 | 32 + 37 |
| caméra | 11 | 33 |

La veillée `CampNightfall` couvre **déjà** les 6 actes du §14 en 16 sections
internes (fichier, lignes 77 → 1197) : dîner, conversations parallèles,
silence, coucher, rêve, matin, rassemblement, cordées, départs, scène finale.
Phileas **veille** déjà (section 8 : poste (256,148) ; section 9 : gag du
piqué de bec). Le manque est ailleurs : voir §4, point R1.

Carte `mount_windswept_entrance` : **648×504 px** (81×63 tuiles, mesuré dans
le `.rsground` ; le §14 disait 552×504 — chiffre périmé).

---

## 2. INVENTAIRE DES SCÈNES

### Entrance (`mount_windswept_entrance`)
- `ArrivalCutscene` — arrivée par le sud au couchant (`dusk`), remontée en
  file indienne, installation du camp. Clés `MWE5_001`…`020`.
  Appelle ensuite `CampNightfall` puis `SetParty`.
- `CampNightfall` — veillée complète en 16 sections (repas, conversations
  parallèles, silence + premier frisson (Nausea 1), ordre du soir, déploiement
  des couchages sous fondu (`dusk`→`darkness`), coucher décalé, scène intime
  duo, **rêve** (DreamSky + `Genesis_Void`, Voix ``, tangage), réveil
  en sursaut, matin (Nausea 2), rassemblement, cordées, départs par le
  sentier nord-est, chemin du nord, scène finale devant l'entrée).
  Clés `MWE5_021`…`075`, `080`…`117`, `201`.
- `KODefeatCutscene` / `RetreatReturnCutscene` — retours en mauvaise posture
  (flags `PlayTempMountScene` + `MountLastExitReason`). Clés `MWE5_120`…`127`.
- `WindSecretScene` — secret Hyko × Penticus (nuit, texte littéral FR).
- 9 actions PNJ (`Tropius_Action`…`Zigzagoon_Action`, texte littéral FR) +
  `LegendOfTheSkyArbiter` (légende via Reinier, choix Oui/Non).
- Helpers décor : `BuildCampDay`, `BuildCampMorning`, `DeployBeds`,
  `PurgeDecor`, table `BEDS`.

### Midpoint (`mount_windswept_midpoint`, ground officiel canyon_camp 1152×624)
- `FirstArrival` — arrivée au relais (titre, marche, dialogue du duo).
- `SetupGround` — placement Ganlon/Shuca + aiguillage scènes.
- `FallenFragmentScene` — le Fragment tombé du ciel (Météno), après le
  mini-boss, une fois.
- `SummitVigilScene` — dernière veillée avant le sommet (après gardien).
- `WipedCutscene` — réveil au relais après défaite segment 2.
- `Partner_Action` / `Ganlon_Action` / `Shuca_Action` — variantes d'état.

### Mini-boss (`mount_windswept_miniboss`, Scorplane + Airmure)
- `FirstPreBossScene` (Voix → flash → émergence, registre des sentinelles) ·
  `SecondPreBossScene` · `DefeatedBoss` (pcall + sortie garantie → midpoint) ·
  `DiedToBoss` (→ entrance). Clés `MWM_*`.

### Gardien (`mount_windswept_guardian`, Ptéra)
- `FirstPreBossScene` (orage, Voix, révélation « les angles ») ·
  `SecondPreBossScene` · `DefeatedBoss` (pcall + clôture ch5 → ch6,
  `FinishedExpedition`, retour guilde) · `DiedToBoss` (→ entrance).
  Clés `MWG_*`. Rejouabilité via `ReplayEnding.EmptyArena` (`MWG_R0*`).

---

## 3. GRAPHES DES TRANSITIONS (tous chemins, victoire ET défaite)

```
guilde / Metano (ch5)
  → (Dungeon_Entrance_Touch, entrance init.lua:183) → donjon seg0
searing_crucible (fin Tunnel)
  → searing_crucible_ch_5.lua:1274 EnterGroundMap → ENTRANCE (ArrivalCutscene)
ENTRANCE
  → donjon seg0 (Risk)            | victoire seg0 → MIDPOINT (zone init.lua)
                                   | défaite seg0  → ENTRANCE carte 50
                                     (KO/Retreat cutscene)
MIDPOINT (carte 63)
  → North_Exit → arène MINI-BOSS (si non vaincu) | sinon seg2 (Crêtes)
  → South_Exit → ENTRANCE
MINI-BOSS (seg1)
  → victoire → DefeatedBoss → MIDPOINT (MountMiniBossCleared)
  → défaite  → DiedToBoss  → ENTRANCE
seg2 (Crêtes)
  → victoire → arène GARDIEN (seg3)
  → défaite  → MIDPOINT carte 63, WindsweptMidState='DeathArrival' → WipedCutscene
GARDIEN (seg3)
  → victoire → DefeatedBoss → ch6, FinishedExpedition → guilde
  → défaite  → DiedToBoss → ENTRANCE
seg4 (Annexe Toupie) → sortie douce master_zone
Rejouabilité (post-histoire) : zones ch6+ → affichage `ReplayEnding`.
```

Flags relus : cohérents (`MountMiniBossSeen/Defeated/Lost/Cleared`,
`MountGuardianSeen/Defeated/Lost`, `PlayedMountMidpointIntro`,
`FragmentSceneSeen`, `MountVigilSceneSeen`, `WindSecretSceneSeen`,
`FinishedMountWindsweptIntro`, `PlayTempMountScene`, `MountLastExitReason`,
`LostMountain`, `DiedToWind`, `WindsweptMidState`).

---

## 4. INCOHÉRENCES CONFIRMÉES

### I1 — Entrée : Ganlon/Shuca parlent avec les dialogues de Hyko/Almotz — **HAUTE** — ✅ CORRIGÉ (lot 1, 77401fb)
`ground/mount_windswept_entrance/init.lua:108-120` : `Teammate2_Action` →
`Growlithe_Action`, `Teammate3_Action` → `Zigzagoon_Action`.
Or après `SetParty` (appelé à la fin d'`ArrivalCutscene`,
`mount_windswept_entrance_ch_5.lua:1624`), Teammate2 = **Ganlon** et
Teammate3 = **Shuca** (preuve : midpoint `init.lua` route bien vers
`Ganlon_Action`/`Shuca_Action`). En exploration post-intro au camp, parler à
Ganlon affiche les textes de Hyko (« wouf » inclus,
`mount_windswept_entrance_ch_5.lua` `Growlithe_Action`).
Fix : router vers `Cranidos_Action` / `Mareep_Action` (existent, lignes
2055 / 2038, variantes complètes pour tous les états).

### I2 — Relais : Ganlon dit « wouf » — **MOYENNE**
`mount_windswept_midpoint_ch_5.lua`, `WipedCutscene` (~lignes 470-520) :
- commentaire : « Hyko et Almotz ont porté le duo jusqu'au camp » alors que
  les variables sont `ganlon`/`shuca` (reliquat de l'adaptation Tunnel→Mont) ;
- réplique de Ganlon : « Le camp de base tient bon,[pause=10] **wouf**… »
  (tic de Hyko, pas de Ganlon) ;
- Shuca (Wattouat, sans moustaches) : « J'en tremble encore des **moustaches** ».
`SetupGround` (même fichier) : commentaires « Almotz près d'un feu, Hyko en
poste au bord est » tout aussi obsolètes.

### I3 — Mini-boss : `MWM_027` (la Voix) jouée sans speaker — **MOYENNE**
`mount_windswept_miniboss_ch_5.lua` (~ligne 158) : le commentaire dit
« la Voix pose l'enjeu : mériter le sommet », mais l'appel est
`UI:WaitShowDialogue(...)` **sans** `SetSpeaker("")` — contrairement à
toutes les autres lignes de la Voix du même fichier (MWM_008, 015…).
Texte FR vérifié : « Le ciel a ses gardiens.[pause=15] Prouvez que vous
méritez le sommet. » → s'affichera en boîte narration au lieu de la Voix.

### I4 — Relais : feu de la veillée du sommet jamais purgé — **FAIBLE/MOYENNE**
`SummitVigilScene` ajoute `Decorations[0].Anims:Add(Campfire @ (830,372))`
sans jamais le retirer. Vérifié : aucun feu en dur à cet endroit (les 4 feux
statiques `Campfire_0..3` sont à (304,480), (400,168), (496,344), (856,200)
— `GroundObjects`, `triggerType 0`, non concernés par une purge du calque
`Decorations`). Le feu ajouté **persiste** après la scène : résidu visuel
permanent au centre du relais. Fix : purge ciblée en fin de scène.

### I5 — Transition Tunnel → Mont : fondu mal calé + répliques sur écran noir — **À TRAITER** (candidat du « fondu du tunnel » de la directive)
Côté départ (`searing_crucible_ch_5.lua:1240-1263`) : le fondu
(`FadeOutBGM 60` + `FadeOut 60`) démarre à t=50 frames pendant que Zigzagoon
marche encore (fin de marche t≈83), puis **90 frames de noir plein** avant
`EnterGroundMap` (ligne 1274).
Côté arrivée (`ArrivalCutscene`) : après la mise en place, **deux répliques
(`MWE5_001`, `MWE5_002`) sont jouées sur écran noir** avant le
`GAME:FadeIn(40)`. La grammaire du projet (passation §4.1) impose :
« le son monte, puis l'image, puis le mot ». Ici le mot précède l'image,
puis l'image se lève sur des personnages déjà installés.
Impossible de prouver en jeu ici : les faits mesurés (90f de noir + 2 boîtes
sur noir + FadeIn tardif) correspondent au « fondu mal exécuté (timing
incorrect) » signalé dans la directive. Correction proposée au lot
transition (voir §5).

### I6 — `Sleep` / `EventSleep` mixtes — **FAIBLE**
4 occurrences `"Sleep"` (`mount_windswept_entrance_ch_5.lua:518, 542, 593,
1309`) au milieu d'`EventSleep`. Les deux anims sont attestées dans le dépôt ;
à harmoniser **seulement** si la différence est visible (la directive « ne
corriger que le confirmé » s'applique — non corrigé au lot 1).

### I7 — Cosmétique code — **FAIBLE**
`mount_windswept_entrance_ch_5.lua:1623` : `--for testing` au-dessus de
`SetParty`, fonction appelée en production par `ArrivalCutscene` ; et
`SetParty` réassigne `hero`/`partner` en **globales** (commentaire interne
l'explique, mais c'est une dette de lisibilité).

### I8 — Harmonisation d'affichage — **FAIBLE (signalé, non corrigé)**
« Aérodactyle » (textes de la guilde) vs « Aerodactyl » / « AERODACTYL »
(`MWG_004`, `MWG_021`) vs leurs voisins FR officiels « Scorplane »/« Airmure »
dans les mêmes scènes. Pas de violation de règle ; cohérence de style à
trancher par l'utilisateur.

---

## 5. POINTS DE REFONTE (directive de méthode, test de crédibilité)

### R1 — LE RÉVEIL DU RÊVE : Phileas ne réagit pas — **LE MANQUE CENTRAL**
Fin de la section 10 de `CampNightfall` (~lignes 653-663) : le héros se
réveille **en sursaut** dans le noir (`MWE5_085` « Shouting », `MWE5_086`
« Worried »), puis… se rendort seul. **Personne ne réagit.** Or Phileas
assure la garde à (256,148), à 2 cases du lit du héros (256,164) — trajet
prouvé libre et atteignable (BFS sur la grille d'obstacles, 2026-07-29).
La directive de méthode cite **exactement ce cas** comme référence de
crédibilité (*« lever la tête, se tourner vers le héros, s'approcher,
s'arrêter à une distance crédible, engager le dialogue, rassurer, puis
reprendre son poste »*).
Refonte proposée (insert après `MWE5_086`) :
1. Phileas s'anime (bruissement), se tourne vers le héros ;
2. s'approche (MoveToPosition (272,156), case libre vérifiée) ;
3. dialogue bref (3-5 boîtes, il rassure SANS révéler — le héros ne comprend
   pas, le joueur relie ; Phileas parle en savant qui « a entendu le vent
   changer ») ;
4. le héros se rendort (`EventSleep`) apaisé ;
5. Phileas regagne son poste (256,148) et reprend la veille — cohérent avec
   sa téléportation matinale (296,160) en section 11.
Textes avant mise en œuvre soumis à validation (lot 2).

### R2 — Standard gestuel « une réplique = un geste »
195 boîtes mais 33 émotes / 69 tours seulement (Tunnel : 64 / 197 pour 237).
Sections les plus plates (relevé) : 3 (tablée, MWE5_024-028 — plusieurs
répliques en file sans orientation), 12-13 (rassemblement/cordées — les
prises de parole de Kino, Reinier, Phileas ne font pivoter personne).
Chantier d'enrichissement, par sections, sur validation.

---

## 6. VÉRIFICATIONS PASSÉES SANS OBSERVATION

- Routages de zone (segment par segment, victoire ET défaite) : cohérents,
  sorties garanties présentes aux endroits critiques.
- `ReplayEnding.EmptyArena` (gardien) : positions dans l'arène 208×176 ✓.
- Flags `SV.Chapter5.*` : aucun usage non déclaré détecté (scriptvars relu).
- `triggerType 0` partout pour les feux/tentes en dur ✓ (décoratifs).
- Mots interdits : `verify_legend.py` vert sur tout le périmètre.
- Caméras rendues au joueur (`MoveCamera(0,0,1,true)`) présentes à la fin de
  toutes les scènes d'exploration ✓ (fix `b7afed9`).
- « Abîme » n'apparaît que dans des **commentaires** (jamais en texte
  affiché) ✓.

---

## 7. PLAN DE LOTS PROPOSÉ

| lot | contenu | périmètre fichiers | risque |
|---|---|---|---|
| **1. Corrections confirmées** ✅ livré `77401fb` | I1 (routage Actions), I2 (« wouf », commentaires), I3 (speaker Voix), I4 (purge feu), I7 (commentaires) + tag build **W** | entrance/init.lua, entrance_ch_5.lua (commentaires), midpoint_ch_5.lua, miniboss_ch_5.lua + 3 fichiers de tag | faible, chirurgical |
| **2. Le rêve de la Source + R1** ✅ livré (tag build **X**) | **Dépassement de scope acté par l'utilisateur (carte blanche 2026-07-29)** : le rêve noir (détail juste au-dessous, §5 R1) est **reconstruit en entier** — nouvelle map `songe_source` (clone de luminous_spring + dream parallax du test de personnalité), apparition progressive de Gardevoir, dialogue héros↔elle ; et R1 s'y emboîte au retour : réveil agité au camp + veille de Phileas (`DreamWakeAndMorning`, MWE5_090/091/118/119). Voir `docs/CONCEPTION_songe_source.md`. | songe_source.* (créés), entrance_ch_5.lua, entrance/init.lua, CharacterEssentials, scriptvars, debug_tools, resx ×4 | moyen (écriture neuve + nouvelle carte) |
| **3. I5 — transition Tunnel→Mont** ✅ livré (tag build **Y**) | Côté départ (crucible) : le fondu ne démarre plus à mi-marche — les quatre filent à l'image, puis `FadeOutBGM(40)` + `FadeOut(40)`, et les 90 frames de noir plein sont résorbées en 20. Côté arrivée : grammaire « le son, puis l'image, puis le mot » — `PlayBGM('Canyon Camp.ogg')` + `FadeIn(40)` **avant** `MWE5_001/002` (plus de répliques sur noir), et la musique du camp meurt avec l'image en fin de veillée (`FadeOutBGM(60)` sous le fondu vers le songe). | searing_crucible_ch_5.lua, entrance_ch_5.lua + 3 fichiers de tag | moyen (visuel, validé par l'utilisateur) |
| **4. R2 — standard gestuel** ✅ livré (tag build **Z**) | Sections 3 (tablée), 12 (rassemblement), 13 (cordées) : chaque réplique accompagnée. Mesures (boîtes → émotes/tours) : S3 5 → 2/4 devenus **7/5** ; S12 8 → 0/0 devenus **12/2** (+ SE d'exclamation sur l'appel MWE5_089) ; S13 17 → 8/7 devenus **9/8**. Que des emotes/tours attestés (`happy/notice/glowing/sweatdrop/determined/exclaim`, `CharTurnToChar(Animated)`, `PlayBattleSE`), aucun texte touché, aucun déplacement ajouté ; cadrage vérifié (écran 320×240, cam (256,228)/(256,268)/(256,196) : tous les acteurs des nouvelles réactions sont dans le champ ; rin/coco en y=368 = 20 px de marge basse). | entrance_ch_5.lua + 3 fichiers de tag | faible mais volumineux |

Validation avant chaque commit : compile lupa, `audit_bugs.py` (12),
`verify_legend.py`, `verify_scene_positions.py`, `verify_bg_format.py`,
`validate_all.py`, `audit_integrite.py` (925), `count_dialogue.py`.
Mesures avant/après par `git stash` si nécessaire.

*Rappel : rien n'a jamais été testé en jeu. Validation statique seule.*
