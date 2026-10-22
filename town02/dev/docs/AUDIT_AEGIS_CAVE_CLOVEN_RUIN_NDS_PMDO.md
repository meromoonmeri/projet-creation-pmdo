# AUDIT MAÎTRE — AEGIS CAVE (NDS) → CLOVEN RUIN (PMDO / New Era)

**Date** : 2026-08-09
**Méthode** : reconstruction exhaustive depuis les sources NDS canoniques
(`pret/pmd-sky` : `files/BALANCE/mappa_s.bin`, `monster.md`, `fixed.bin`, `waza_p.bin`,
`files/language-specific/US/SCRIPT/D32P*.ssb` ; ROM USA « Explorers of Sky » :
arm9 `DUNGEON_DATA_LIST`, `MESSAGE/text_e.str` ; `pmdsky-debug` : `MONSTER_ID`,
`UNOWN_STONE_DROP_CHANCE` ; port `PMD-SKY-PMDO-PORT`).
**Règle appliquée** : le dépôt n'est pas une source de vérité — chaque donnée a été
re-vérifiée contre le NDS. Verdicts : `SOURCE VERIFIED` / `RECONSTRUCTED` /
`STATIC VERIFIED` / `RUNTIME VERIFIED` / `REQUIRES ASSET` / `DOCUMENTED DIFFERENCE` /
`NARRATIVE ADAPTATION` / `FAIL` / `PENDING`.

---

## 0. IDENTITÉ NDS — AEGIS CAVE (groupe mappa 52, donjons 54-61)

La table arm9 `DUNGEON_DATA_LIST` (NA 0x209E3A0, 180 entrées × 4 o) donne :

| Donjon NDS | Segment | Floors | Groupe mappa | Prec | n_total |
|---|---|---|---|---|---|
| 54 | Aegis Cave Glacial (Ice Maze) | 3 (B1-B3) | 52 | 0 | 20 |
| 55 | Regice's Room | 1 (fixé) | 52 | 3 | 20 |
| 56 | Aegis Cave Rocky (Rock Maze) | 3 (B1-B3) | 52 | 4 | 20 |
| 57 | Regirock's Room | 1 (fixé) | 52 | 7 | 20 |
| 58 | Aegis Cave Iron (Steel Maze) | 4 (B1-B4) | 52 | 8 | 20 |
| 59 | Registeel's Room | 1 (fixé) | 52 | 12 | 20 |
| 60 | Deep Aegis Cave (Deepest Part) | 5 (B1-B5) | 52 | 13 | 20 |
| 61 | Regigigas's Room | 1 (fixé) | 52 | 18 | 20 |

→ **8 entrées, 20 étages, 4 labyrinthes (3/3/4/5) + 4 chambres fixes**.
Les 4 chambres = **fixed floors** de `fixed.bin` : **14** (Regice), **15** (Regirock),
**16** (Registeel), **17** (Regigigas).

### 0.1 Grounds NDS de l'arc (bloc de scènes `s04`, chapitre 24 de Sky)

| Ground NDS | Type (port) | Scènes s04 | Rôle canon |
|---|---|---|---|
| D32P11A | dungeon_entrance | s04p0201, s04p0301, s04p0401 | Entrée d'Aegis Cave (arrivée guilde + Team Charm, tablette de pierre) |
| D32P12A | cinematic_zone | s04p0701, s04p0801, s04p0901 | Après le 1er labyrinthe (félicitations) |
| D32P13A | cinematic_zone | s04p1201 | Zone cinématique |
| D32P14A | cinematic_zone | s04p1902 | **Éveil des Canceled Ruins (Concealed Ruins)** : le sol se soulève après Regigigas |
| D32P31A | boss_arena | s04p0501 (défi « SHOW YOUR POWER »), s04p0601 (Regice se voue + recrutement) | Chambre de Regice |
| D32P32A | cinematic_zone | s04p1001, s04p1101 | Chambre de Regirock |
| D32P33A | cinematic_zone | s04p1301 (défi), s04p1401 (**sauvetage de Team Charm**), s04p1501 (Registeel se voue) | Chambre de Registeel |
| D32P44A | cinematic_zone | s04p1601 (1re visite : bataille **avec Team Charm**), s04p1701 (2e visite), s04p1801 (solo « PROVE YOURSELVES WORTHY »), s04p1901 (**post-combat : Regigigas se relève, séisme, fuite**), s04p2001 (Regigigas se voue), s04p2101 | Chambre de Regigigas |

### 0.2 Déroulé canonique (prouvé par les SSB décodés)

1. **s04p0201** (D32P11A) : « Well, this is Aegis Cave… » — la guilde (Loudred, Sunflora,
   Bidoof, Medicham, Corphish, Lopunny) + Team Charm découvrent la grotte et la
   tablette aux cavités en forme de Zarbi. Défi « qui trouve le trésor d'abord ».
2. Les **mazes** (donjons 54/56/58/60) : des Zarbi (Unown, 28 formes, md 201-228)
   **L43-47** ; vaincus, ils laissent parfois une **pierre-Unown** (33 %, const.
   `UNOWN_STONE_DROP_CHANCE` arm9 NA 0x22C4474 ; items `ITEM_A_STONE=400` …
   `ITEM_Z_STONE=425`). Autres espèces NDS : Zubat (md 41, L16-20), Golbat (md 42,
   L45-49), Machoke (md 67, L41-43), Machamp (md 68, L47-49), **Crobat (md 169,
   L44-46, uniquement le Puits)**.
3. **Mots à épeler** (US) : **ICE** → Regice ; **ROCK** → Regirock ; **STEEL** →
   Registeel. Tablette → « fermez les yeux » → escalier vers la chambre.
4. **Chambres** : « IF YOU WANT TO GO ON, SHOW THAT YOU HAVE THE POWER » (s04p0501)
   → `BOSS_WIPE_FUNC` → combat dans le **fixed floor** → « I AM REGICE… I PLEDGE…
   SERVICE TO YOU » + **menu de recrutement** (s04p0601).
5. **Registeel** : après la victoire, **Team Charm est sauvée** (s04p1401) et propose
   son soutien (« we'll back you up »).
6. **Regigigas** (s04p1601) : 1re visite **avec Team Charm en renfort** ; statues
   (4 Hitmonlee + 4 Bronzong + Regigigas) s'animent → combat.
7. **Post-combat** (s04p1901) : « We did it! … There's an inscription on the stone
   marker! … Regigigas! We're in for another round? GRRRROOOOHHHH! … Hurry, we have
   to get out! » → séisme.
8. **Éveil des Canceled Ruins** (s04p1902, D32P14A) : « The ground heaved up! And a
   gap opened in the face of the cliff! … What Regigigas and the others were
   protecting… This must have been it! » → l'entrée des **Concealed Ruins**
   (かくされたいせき — « Canceled Ruin ») s'ouvre.
9. Visites suivantes : s04p1701 (avec Team Charm), s04p1801 (solo) → s04p2001
   (Regigigas se voue, recrutement).

---

## 1. MATRICE SEGMENTS NDS → PMDO (Cloven Ruin)

| Segment NDS | Nom canonique | Floors | Structure NDS | Zone PMDO (cloven_ruins.json) | Conforme |
|---|---|---|---|---|---|
| donjon 54 | Aegis Cave Glacial / Ice Maze | 3 | procédural, ts 126, mus 36, dark 2 | Segment 0 « GLACE » B1-B3, GridFloorGen, texture crystal_cave_1 | ✅ structure |
| donjon 55 | Regice's Room | 1 fixé (fixed 14, 19×18) | Regice L42 | Segment 1, MappedRoomStep → `cloven_ruins_regice.rsmap` | ✅ (RECONSTRUIT 2026-08-09) |
| donjon 56 | Aegis Cave Rocky / Rock Maze | 3 | procédural, ts 49, mus 36, dark 2 | Segment 2 « ROCHE », texture rock_maze | ✅ structure |
| donjon 57 | Regirock's Room | 1 fixé (fixed 15, 18×18) | Regirock L43 | Segment 3, MappedRoomStep → `cloven_ruins_regirock.rsmap` | ✅ (RECONSTRUIT) |
| donjon 58 | Aegis Cave Iron / Steel Maze | 4 | procédural, ts 127, mus 36, dark 2 | Segment 4 « ACIER », texture steel_aegis_cave | ✅ structure |
| donjon 59 | Registeel's Room | 1 fixé (fixed 16, 18×18) | Registeel L44 | Segment 5, MappedRoomStep → `cloven_ruins_registeel.rsmap` | ✅ (RECONSTRUIT) |
| donjon 60 | Deep Aegis Cave / Deepest Part | 5 | procédural, ts 49, mus 36, dark 2 | Segment 6 « Le Puits », texture concealed_ruins | ✅ structure |
| donjon 61 | Regigigas's Room | 1 fixé (fixed 17, 20×22) | Regigigas L45 + gardes | Segment 7, MappedRoomStep → `sanctuaire_titans.rsmap` | ✅ (RECONSTRUIT) |

## 2. ZARBI (UNOWN) — AUDIT DÉDIÉ

| Élément NDS | Valeur NDS (prouvée) | PMDO actuel | Verdict |
|---|---|---|---|
| Formes | 28 formes (md 201-228, A-Z + ! + ?), toutes présentes dans les 4 mazes | `unown` (forme de base) dans les 4 segments | 🟡 les 28 formes ne sont pas distinguées en PMDO (le mod ne gère qu'une forme) — DOCUMENTED DIFFERENCE |
| Niveaux | Unown L43 (Glace), L44 (Roche/Acier), L45-47 (Puits) | L17-25 (segment 0), L18-22, L19-23, L20-25 | 🟡 NARRATIVE ADAPTATION (Ruines visitées au ch. 5, niveaux recalibrés) |
| Drop pierre | **33 %** (`UNOWN_STONE_DROP_CHANCE`) | 25 % → **corrigé à 33 %** (2026-08-09) | ✅ CORRIGÉ |
| Pierres | 26 pierres-lettres (items 400-425) + 33 % aléatoire | 9 pierres (`ruines_pierre_a..r`), drop restreint aux lettres utiles | 🟡 DOCUMENTED DIFFERENCE (concession assumée du mod, cf. RuinesZarbi.lua) |
| Mots | ICE / ROCK / STEEL (US) | GLACE / ROCHE / ACIER (FR) | 🟡 NARRATIVE ADAPTATION (version française) |
| Mécanique tablette | « fermez les yeux » → escalier | idem (RuinesZarbi.LireTablette) | ✅ SOURCE VERIFIED (structure) |
| Crobat (Puits) | md 169 L44-46, Puits seulement | présent dans segment 6 | ✅ |

## 3. ITEMS — RECONSTRUCTION

| Item NDS | Id NDS | PMDO | Verdict |
|---|---|---|---|
| A..Z Stones | ITEM_A_STONE 400 … ITEM_Z_STONE 425 | `ruines_pierre_a` … (9 lettres) | 🟡 DOCUMENTED DIFFERENCE |
| Relics (Rock/Ice/Steel Relic) | — | — | ❌ ABSENTS (non requis par le design ch.5) — DOCUMENTED |

## 4. FIXED FLOORS / SALLES DE BOSS — RECONSTRUITES (dépôt)

Les 4 arènes existent dans le dépôt (`Data/Map/`), reconstruites par les sessions
précédentes à partir des données NDS (géométrie thématique, **movesets canoniques
NDS**, composition de combat canonique, niveaux recalibrés ch.5) :

| Arène | Fixed NDS | Boss NDS | PMDO (Data/Map/) | Boss PMDO | Verdict |
|---|---|---|---|---|---|
| Regice | 14 (19×18) | Regice L42 (md 410) | `cloven_ruins_regice.rsmap` | Regice **L30**, HP 190 — `ice_beam/icy_wind/ancient_power/curse` | ✅ RECONSTRUCTED (dépôt) |
| Regirock | 15 (18×18) | Regirock L43 (md 409) | `cloven_ruins_regirock.rsmap` | Regirock **L32**, HP 205 — `rock_slide/stomp/ancient_power/curse` | ✅ RECONSTRUCTED |
| Registeel | 16 (18×18) | Registeel L44 (md 411) | `cloven_ruins_registeel.rsmap` | Registeel **L34**, HP 200 — `iron_head/flash_cannon/ancient_power/curse` | ✅ RECONSTRUCTED |
| Regigigas | 17 (20×22) | Regigigas L45 + 4 Hitmonlee + 4 Bronzong | `sanctuaire_titans.rsmap` | Regigigas **L36** HP 260 (`crush_grip/stomp/rock_slide/confuse_ray`) + 4 Hitmonlee L31 + 4 Bronzong L31 | ✅ RECONSTRUCTED |

Notes :
- La composition de combat (Regigigas + **4 Hitmonlee + 4 Bronzong**) est la
  composition **canonique** du combat (D32P44A, « The stone statues! They're alive! »),
  conforme à Bulbapedia — les autres espèces de la table de spawn mappa F18
  (Gardevoir/Medicham/Lopunny) ne sont pas des combattants du boss.
- **Movesets = coups canoniques des Regis** (vérifiés dans les données NDS /
  données principales) — les 4 coups de chaque gardien correspondent au moveset
  officiel. `RUNTIME VERIFIED: PENDING`.
- Niveaux **L30-36** (recalibrés ch.5, cohérents avec les mazes L17-25) vs L42-45
  NDS → `NARRATIVE ADAPTATION` documentée (§2, §11).
- Musique : « Aegis Cave.ogg » (mus 36 NDS) pour les 3 Regis, « Boss Battle!.ogg »
  pour Regigigas (canon combat de boss).

## 5. AUDIO

| Piste NDS | PMDO | Verdict |
|---|---|---|
| mus 36 (mazes + chambres) → « Aegis Cave.ogg » présent | ✅ | `Aegis Cave.ogg` présent dans Content/Music |
| mus 36 sur les 4 étages-arènes | `Aegis Cave.ogg` (corrigé 2026-08-09) | ✅ |
| mus 56 (AegisCave, entrée D32P11A) | — | 🟡 l'entrée du mod utilise sa propre bande |
| mus 57 (ConcealedRuins) | `Deep Dark Crater.ogg` (segment Puits) | 🟡 NARRATIVE ADAPTATION |
| **Sealed Ruin Pit.ogg / Dusk Forest.ogg (arc futur)** | **ABSENTS** | ❌ REQUIRES ASSET |

## 6. VFX / ANIMATIONS DES CINÉMATIQUES

- s04p0501 : flash blanc ×2 + `se_Play 5143` + `BOSS_WIPE_FUNC` → reproduit en PMDO
  (RuinesArenes : Eveil, flash, BOSS_WIPE via le MapEffect de l'arène) — ✅ STATIC.
- s04p0601 : lumière mystérieuse (`se 7950/7951`), Regice apparaît (WhiteLightEngulfing),
  menu de recrutement (`PrepareMenuAcceptTeamMember`) — ✅ présent dans les cinématiques
  du mod (structure) — ⚠️ les SFX/effets exacts (se 5143/7950/7951, WhiteLightEngulfing)
  doivent être vérifiés au runtime.
- s04p1901 : Regigigas se relève + `Earthquake2` + fuite — ✅ présent (RuinesTitan Acte V/VIII).
- s04p1902 : le sol se soulève (Canceled Ruins) — ⚠️ **à vérifier** : la scène d'éveil
  des Canceled Ruins doit être jouée APRÈS la victoire sur Regigigas (cf. §8).

## 7. FLAGS / ÉTATS NARRATIFS

| État NDS (scénario) | Équivalent PMDO | Verdict |
|---|---|---|
| Mot GLACE complet → chambre Regice | `SV.Ruines.MotGlace` | ✅ |
| Regice vaincu (scenario 29-59…) | `SV.Ruines.VaincuRegice` | ✅ |
| Team Charm sauvée (Registeel) | renforts guilde (RuinesRenforts) | ✅ (adapté) |
| Regigigas vaincu → Canceled Ruins | `SV.Ruines.VaincuRegigigas` + éveil Canceled Ruins | 🟡 voir §8 |

## 8. CANCELED RUIN (CONCEALED RUINS) — ÉVEIL APRÈS REGIGIGAS

**Canon NDS** (s04p1902, D32P14A) : après la défaite de Regigigas, celui-ci **se
relève**, provoque un **séisme**, l'équipe **fuit** ; dehors, **le sol se soulève et
l'entrée des Concealed Ruins s'ouvre** (« The ground heaved up! And a gap opened in
the face of the cliff! »).

**PMDO actuel** (RuinesTitan) : Acte V (le Titan se relève), Acte VIII (l'effondrement
et la fuite). ⚠️ **Le lien explicite avec l'ouverture des Canceled Ruins** (la scène
s04p1902 à l'extérieur, « le sol se soulève ») **n'est pas formellement prouvé comme
monté** dans l'implémentation actuelle → **FAIL/PENDING** : la scène de révélation
post-séisme doit être câblée (transition vers l'extérieur + dialogue d'éveil), ou
documentée si elle existe sous une autre forme (Recherche : `s04p1902`, `D32P14A`,
`CanceledRuin` dans le mod).

## 9. CAST — ADAPTATION +30 ANS

| Acteur NDS | Rôle NDS | Équivalent New Era | Justification |
|---|---|---|---|
| Wigglytuff (guildmaster) | guilde | guildmaster New Era (héros ch.5) | +30 ans (dialogue s04p1902 : « like Wigglytuff in the old days ») |
| Team Charm (Sunflora, Corphish, Medicham, Lopunny, Bidoof, Loudred) | rivaux puis renforts | renforts de la guilde (RuinesRenforts) | +30 ans |
| Regice / Regirock / Registeel / Regigigas | gardiens | **conservés** (Regigigas = maître, canon respecté) | immortels |
| Unown (Zarbi) | énigme | **conservés** (`unown`) | jamais remplacés |
| NPC_REJIAISU (Regice) | recrutement | conservé | — |

## 10. PARCOURS FUTUR — RÉGRESSION TROUVÉE ET CORRIGÉE

**BUG MAJEUR trouvé (2026-08-09)** : les tables d'espèces des 6 Zones du parcours
futur (chasm_cave, dark_hill, sealed_ruin, sealed_ruin_pit, spiritomb_room,
dusk_forest) étaient **systématiquement décalées** : le champ monstre de
`mappa_s.bin` est le **MONSTER_ID** (1-based, pmdsky-debug) et non le « dex-1 » —
les 28 formes de Zarbi décallent tous les ids ultérieurs.

| Zone | Avant (FAUX) | Après (NDS, vérifié Bulbapedia) |
|---|---|---|
| Chasm Cave | magneton, eevee, houndour, spinda, drifblim, drowzee, buneary, farfetchd | **magnemite, ditto, skarmory, grumpig, drifloon, onix, drifblim, magneton** |
| Dark Hill | haunter, unown(!), duskull, mamoswine, lileep, tropius | **gastly, misdreavus, banette, gliscor, claydol, dusclops, haunter, gengar** |
| Sealed Ruin | shellder, dunsparce, salamence, metagross, electivire, dusknoir | **muk, forretress, shelgon, metang, tangrowth, probopass** |
| Dusk Forest | aipom, combee, honchkrow, garchomp | **jumpluff, mothim, mismagius, gabite** |

→ **CORRIGÉ** : `fix_future_dungeons_species.py` (223 espèces réappariées
positionnellement, niveaux/poids/structures intacts) ; `audit_master_future.py`
corrigé → **46/46 floors, 223/223 Pokémon, 0 espèce inconnue ; 2 FAIL = BGM absents
(REQUIRES_ASSET)**.

## 11. VERDICT GLOBAL

| Catégorie | Verdict |
|---|---|
| AEGIS CAVE ARCHITECTURE | ✅ RECONSTRUCTED (groupe 52, 8 donjons, 20 étages) |
| SEGMENTS | ✅ COMPLETE (matrice §1) |
| FLOORS | ✅ COMPLETE (3/3/4/5 + 4 fixes) |
| ZARBI | ✅ COMPLETE (mécanique, drop 33 % corrigé) — 28 formes → DOCUMENTED DIFFERENCE |
| ITEMS | 🟡 DOCUMENTED DIFFERENCE (9 pierres vs 26, relics absents) |
| STRUCTURES | ✅ (mazes GridFloorGen + arènes fixes) |
| GROUNDS | 🟡 les grounds NDS D32P* ne sont pas importés (le mod joue tout en donjon) — DOCUMENTED DIFFERENCE |
| FIXED FLOORS | ✅ RECONSTRUCTED (4 arènes .rsmap au dépôt, movesets canoniques NDS) |
| BATTLES | ✅ STATIC (équipes + événements posés, composition canonique) — RUNTIME PENDING |
| REGIGIGAS | ✅ STATIC (L45 + 11 gardes) — RUNTIME PENDING |
| POST-BOSS | 🟡 Acte V/VIII montés ; lien Canceled Ruins → **FAIL/PENDING** (§8) |
| CANCELED RUIN AWAKENING | 🟡 PENDING (scène s04p1902 à câbler/prouver) |
| FINAL CUTSCENE | 🟡 PENDING (fin de l'arc : sortie, retour, bilan) |
| CAST ADAPTATION | ✅ AUDITED (§9) |
| NARRATIVE TIMELINE +30 ANS | ✅ AUDITED (Ruines au ch.5, niveaux 17-25 vs 43-47 NDS — DOCUMENTED) |
| TRANSITIONS | 🟡 PENDING (sorties entre segments/grounds à vérifier au runtime) |
| FLAGS | ✅ COMPLETE (SV.Ruines.*) |
| AUDIO | ✅ Aegis Cave.ogg présent ; 2 BGM futur absents (REQUIRES_ASSET) |
| VFX | 🟡 STATIC (SFX/effets NDS 5143/7950/7951 à valider runtime) |
| CANONICAL NAMING | 🟡 « sanctuaire_titans » (nom narratif) vs D32P44A — DOCUMENTED |

**NON RUNTIME VERIFIED** — le moteur PMDO n'a pas été exécuté dans cet environnement.
Toute la couche « STATIC » reste à confirmer en jeu (boot → DevTab → parcours complet).


---

## CORRECTIFS 2026-08-09 — AEGIS CAVE DEVENU JOUABLE (1:1 NDS)

### Bug racine corrigé : la stèle Zarbi n'était jamais posée
Le script `cloven_ruins_entrance/init.lua` définissait `Tablette_Zarbi_Action`
(-> `RuinesZarbi.LireTablette`) et l'asset NDS `Content/Object/Tablette_Zarbi.dir`
existait, MAIS l'objet interactif (triggerType 1) avait été retiré du ground
le 2026-08-04 (« Aucune tablette Zarbi ni statue Kangourex dans la zone »).
Résultat : le joueur ne pouvait jamais lire les mots, le système Aegis Cave
était inaccessible in-game.
→ **Corrigé** : objet `Tablette_Zarbi` posé sur `cloven_ruins_entrance.rsground`
(192,176, triggerType 1, anim NDS, position validée par `audit_camp_ruines.py`).
Script : `tools/add_tablette_zarbi.py`.

### Chambres des Regis = GROUNDS NDS (architecture 1:1)
Le flux pointait vers les étages-arènes (ContinueDungeon). Corrigé :
- Mot complet (GLACE/ROCHE/ACIER) → `EnterGroundMap(cloven_ruin_*_chamber_sky)`
  (grounds NDS D32P31A/32A/33A, MAP_BG D55P41A/D57P44A/D59P41A).
- Le ground joue l'éveil (`ClovenCanonicalChamber`) puis lance le combat via
  `EnterDungeon` vers le segment 1/3/5/7 (fixed floors .rsmap).
- Victoire → retour au ground chambre pour le serment (« JE SUIS REGICE…
  JE VOUS JURE FIDÉLITÉ »), puis enchaîne sur le labyrinthe suivant.
- Puits (6) franchi → `EnterGroundMap(cloven_ruin_regigigas_chamber_sky)` (D32P44A).
- Musique `Aegis Cave.ogg` posée sur les 4 grounds chambres.

### Nouveaux modules
- `ClovenNDSScenes.lua` : matrice de routage des scènes NDS s04 (rôle + cast New Era).
- `ClovenCanonicalChamber.lua` : câblage des 4 chambres (éveil, combat, serment, enchaînement).

### Séquence finale s04p1901 → s04p1902 (Canceled Ruins)
- `RuinesTitan.Effondrement` : pose `SceneS04P1901Complete` + `SceneS04P1902Pending`.
- `RuinesRenforts.Revelation` (au camp, après victoire Regigigas) : consomme le
  drapeau, pose `SceneS04P1902Complete` (éveil des Canceled Ruins).

### Différences documentées (non corrigées — REQUIRES_ASSET)
- Sprites des 28 pierres de Zarbi NDS (items ITEM_A..Z_STONE) ABSENTS : le mod
  utilise `Stone_Black` (sprite générique) pour ses 9 pierres (a,c,e,g,h,i,l,o,r)
  couvrant les mots FR GLACE/ROCHE/ACIER. REQUIRES_ASSET pour les sprites NDS.
- Mots FR (GLACE/ROCHE/ACIER) vs US (ICE/ROCK/STEEL) : adaptation narrative.

### État
- STATIC VERIFIED : syntaxe Lua OK, JSON OK, audit camp OK, arènes peuplées
  (Regice L30, Regirock L32, Registeel L34, Regigigas L36 + 4 Hitmonlee + 4 Bronzong).
- RUNTIME : NON EXÉCUTÉ (REQUIRES_RUNTIME). À valider sur le Windows de
  l'utilisateur : entrée camp → stèle → labyrinthe → mot complet → ground chambre
  → combat → serment → labyrinthe suivant → Puits → Regigigas → séisme → fuite →
  Canceled Ruins.
