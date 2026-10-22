# PASSATION — New Era : Abyss to Ascension

> **Document de reprise pour le prochain agent Arena.**
> À coller intégralement en début de nouvelle session.
> Écrit le 2026-07-29, après le merge de la PR #3 dans `main` (`e6f9e8d`).

---

## 0. OÙ REPRENDRE

Le travail de la session précédente est **intégralement mergé dans `main`**
(commit de merge `e6f9e8d`, PR #3). Rien n'est à récupérer sur une branche :
une nouvelle session partant de `main` a déjà tout.

Dernier tag de build posé : **`2026-08-01-U`**.
Le prochain lot doit incrémenter à `2026-08-01-V`.

**Vérification à faire en tout premier :**

```bash
git log --oneline -3
python3 -c "import lupa" || pip install --break-system-packages lupa Pillow numpy
ls Data/Script/halcyon/TownNight.lua tools/audit_bugs.py   # doivent exister
```

Si ces fichiers manquent, le checkout n'est pas à jour — ne rien écrire avant
d'avoir résolu ça.

---

## 1. LE PROJET

Mod PMDO (moteur RogueEssence, C# + Lua) — fork narratif de Halcyon.
Namespace Lua : **`halcyon`**. Jeu en **français**.
Dépôt : `meromoonmeri/new-era-abyss-to-ascension-V4`.

L'utilisateur écrit en français, style direct, souvent sans ponctuation.
**Répondre en français.** Il teste lui-même en jeu et signale ce qui casse.

Il a validé la direction : *« tu as compris l'essence de New Era, le jeu doit
avoir cette âme unique qui fait vibrer le joueur »*.

**Objectif de contenu :** porter les chapitres 5 à 10 à ~3000 boîtes de
dialogue chacun, pour 23-30 h de jeu. Mesure actuelle : ~15 h.

---

## 2. MÉTHODOLOGIE — LE CŒUR DE LA PASSATION

Ce qui a fonctionné n'est pas un style, c'est une discipline. Elle est
reproductible et **doit être reprise telle quelle**.

### 2.1 Preuve avant hypothèse

Ne jamais affirmer sans avoir ouvert le fichier. Trois erreurs réelles que
supposer aurait laissé passer :

| supposé | réalité vérifiée |
|---|---|
| `SV.storyProgression.Chapter` | **n'existe pas** → `SV.ChapterProgression.Chapter` (458 usages) |
| `Guildmaster.ogg` | le fichier est `Guildmaster Wigglytuff.ogg` |
| `DUN_Tumble` | SE inexistant → `DUN_Rollout` (attesté) |

### 2.2 Ne jamais inventer une API

Avant d'utiliser un appel moteur, compter ses occurrences **hors du fichier
courant**. Zéro occurrence = invention.

```bash
grep -rl "MonAPI" --include=*.lua Data/Script | grep -v mon_fichier | wc -l
```

Deux inventions attrapées ainsi :
- `Anims:Clear()` → la vraie méthode est `Anims:RemoveAt(i)` en boucle
  descendante (patron dans `event_single.lua:724`)
- `CharAnimateTurnToChar` → la vraie est `CharTurnToCharAnimated` (547 usages)

### 2.3 Prouver le format d'un JSON avant de l'écrire

**La leçon la plus coûteuse : 153 905 lignes réécrites en devinant.**

```python
d = json.loads(s)
assert json.dumps(d, ensure_ascii=False, indent=0) == s   # ou indent=2, ou compact
```

Formats rencontrés dans le dépôt :
- `indent=0` — grounds de la guilde (`guild_guildmasters_room.rsground`)
- compact `separators=(', ', ': ')` — `metano_town.rsground`, `.rsmap`
- `indent=2` — `MapStatus/*.json`

**Tous les JSON ont un BOM UTF-8** : lire en `utf-8-sig`, réécrire avec
`f.write('\ufeff')`. Sauf exceptions mesurées : 5 MapStatus sur 7 n'en ont pas.

Après écriture, **comparer structurellement** ancien/nouveau champ par champ et
lister ce qui a changé. Un patch propre modifie 4 champs, pas 4000.

Cas vécu : `metano_town.rsground` réécrit en `indent=2` a fait passer le clone
de 38 Mo à **94 Mo** (alerte GitHub).

### 2.4 Toute table `SV` neuve : déclarer ET rattraper

Bug qui a coûté une partie neuve : `GloomyPlayedMidpointIntro` lu mais déclaré
nulle part → `nil`.

1. Déclarer dans `Data/Script/halcyon/scriptvars.lua`
2. Rattraper dans `OnUpgrade` de `services/debug_tools/init.lua`, **en
   déduisant** l'état pour ne pas régresser un joueur en cours :

```lua
if SV.Chapter8.CrystalSanctuaryComplete == nil then
    SV.Chapter8.CrystalSanctuaryComplete = (SV.Chapter8.DefeatedDiancie == true)
end
```

**Preuve utile** : lire un champ absent d'une table *existante* rend `nil` (pas
de crash). Lire un champ sur une table *absente* **crashe**.

### 2.5 Vérifier la marchabilité ET l'accessibilité

```python
libre = ob[x//8][y//8]['Tags'] == 0        # marchable
```

Mais marchable ≠ atteignable. Faire un **parcours en largeur** depuis l'entrée
du joueur : une zone peut être libre et isolée par un mur. C'est ainsi qu'une
porte inatteignable a été évitée dans le bureau de Penticus.

### 2.6 Vérifier que chaque objet a son handler

- `triggerType 0` = **décoratif**, jamais activable (preuve : les 13 `Food_*`
  du réfectoire n'ont aucun handler et la salle fonctionne)
- `1` → handler `<Nom>_Action`
- `2` / `3` → handler `<Nom>_Touch`

Un objet `trig=1` sans handler est **muet en jeu**. 12 PNJ étaient dans ce cas.

**Piège** : le nom du module Lua ne suit pas toujours le dossier —
`ground/guild_top_left_bedroom/` déclare `guild_Top_Left_bedroom`.

### 2.7 Corriger ses propres outils
`audit_bugs.py` a d'abord sorti **68 signalements**. Après tri : **56 étaient
des faux positifs de l'outil lui-même**. Un outil qui crie au loup ne sert à
rien. Résultat stabilisé : **12**, tous documentés inoffensifs.

Faux positifs corrigés (à ne pas réintroduire) :
- code dans un bloc `--[[ ]]` compté comme vivant
- `local` successifs pris pour des champs de table sans virgule
- namespaces multiples (`megastones/scriptvars.lua` ignoré)
- plusieurs champs sur une ligne (`Map = 1, Entry = 0`)
- `triggerType 0` compté comme interactif

De même, `count_dialogue.py` comptait `TownVoicesLate` pour **3 boîtes au lieu
de 668** : les répliques y sont des valeurs de table, pas des appels.

### 2.8 Mesurer avant / après

Pour prouver qu'on n'a rien cassé :

```bash
python3 tools/audit_integrite.py .     # mesurer
git stash && python3 tools/audit_integrite.py . && git stash pop
```

Référence établie : **925 anomalies** (dette préexistante de clés orphelines),
identique avant et après tous les lots de la session.

### 2.9 Honnêteté

Signaler ses erreurs, les faux positifs de ses propres outils, et **répéter
que rien n'est testé en jeu**. Tout est validé statiquement.

---

## 3. RÈGLES PROJET NON NÉGOCIABLES

- Jamais **« Necrozma »**, **« Eternatus »**, **« l'Abîme »**, **« prison »**
  dans un texte affiché (le twist des Cœurs-prison est réservé à l'arc 6)
- **Ne jamais nommer les personnages des jeux d'origine** — le joueur
  reconnaît, le héros non
- La Voix reste **anonyme** : speaker ``, jamais de nom ni de portrait
- La Voix **ne parle pas en ville de jour** (exception motivée : la nuit, au
  puits, quand le héros est seul)
- `strings.resx` = **anglais** · `strings.fr.resx` = **français**
- Répliques : **1-2 phrases, < 150 caractères** hors `[pause=N]`
- Modules globaux → **texte littéral**, jamais `STRINGS.MapStrings`
- Aucun légendaire / fabuleux en boss ou spawn d'add-on
- Tout sous `pcall`, **sortie garantie** : une scène qui casse ne doit jamais
  figer le joueur
- Piège Lua : insérer un champ en collant un commentaire avale la virgule →
  **virgule avant le commentaire**
- Toute zone `.json` modifiée → resynchroniser `Data/Zone/index.idx`
- `GAME:EnterGroundMap(nom, marker)` ne marche que si `nom` est dans les
  `GroundMaps` de la zone courante
- Incrémenter le tag de build dans **3 fichiers** : `main.lua`,
  `scriptvars.lua`, `ground/vast_steppe_midpoint/init.lua`
- Imports pmd-red / EoSO : géométrie **1:1**, seuls dialogues et casting changent

---

## 4. GRAMMAIRE DES CINÉMATIQUES

Relevée dans EoSO (`beach/init.lua`, `storm_cutscene_a`, `chapter_card`) et
appliquée partout depuis :

1. **Le lieu avant les personnages** — le son monte, puis l'image, puis le mot
2. **Constat sensoriel → réaction affective → décision**, jamais l'inverse
3. La caméra cadre le **décor**, puis redescend sur le duo au moment de décider
4. Les départs sont des **coroutines jointes** : marche, fondu et musique
   se terminent ensemble
5. **Chacun parle de son métier** — personne ne résume l'intrigue ; la ville
   ne *sait* pas, elle *perçoit les effets*
6. **Le corps parle avant la bouche** — montrer l'état physique avant de le
   commenter (un évanouissement : jambes qui lâchent, écran qui tangue, chute,
   puis le noir)

---

## 5. CASTING (vérifié — une erreur a déjà été commise ici)

| instance | espèce | surnom | rôle |
|---|---|---|---|
| `Tropius` | tropius | **Penticus** | **maître de guilde** |
| `Noctowl` | noctowl | **Phileas** | le savant / archiviste |
| `Audino` | audino | **Rin** | tient l'assemblée (2ᵉ étage) |
| `Snubbull` | snubbull | **Coco** | cuisinière |
| `Mareep` | mareep | **Shuca** | recrue |
| `Cranidos` | cranidos | **Ganlon** | recrue (râleur) |
| `Breloom` | breloom | **Kino** | équipe |
| `Girafarig` | girafarig | **Reinier** | équipe |
| `Growlithe` | growlithe | **Hyko** | garde |
| `Zigzagoon` | zigzagoon | **Almotz** | garde |
| `Chatot` | chatot | **Falo** | **musicien de Metano — PAS un membre de la guilde** |

**Erreur commise et corrigée** : une scène convoquait « Phileas, maître de
guilde » et « Chatot, son second ». Les deux étaient faux. Preuve dans
`guild_third_floor_lobby_ch_7.lua` : Penticus ouvre l'adresse du matin et donne
la parole — *« …les Aegis Cave. Phileas ? »* — et Phileas répond
*« Merci, Penticus »*.

---

## 6. FORMATS DE FICHIERS DÉCODÉS

### `.tile` (Content/Tile)
```
[0..3]   uint32  tileSize = 8
[4..7]   uint32  nbEntrées
[8..]    table   x(u32) y(u32) offset(u64) × nbEntrées
[offset] uint32 taillePNG + uint32 padding + PNG 8×8 RGBA
```
Plusieurs entrées peuvent pointer le même offset (tuiles mutualisées).
Round-trip prouvé : MD5 identique sur 1 231 857 octets.

### `.dir` (Content/BG, Content/Particle)
```
[uint32 taillePNG][uint32 0][PNG][frameW][frameH][LocHeight][frameCount]
```
Les 4 derniers champs sont des uint32 LE. Viewport PMDO = **320×240** : un fond
plein écran (`WaitShowBG`) doit avoir des frames 320×240.

Exemple vérifié — `Ash_Fall.dir` : PNG 192×16, frameW/H 16, 12 frames
(0-7 = chute, 8-11 = impact).

### `.rsground`
La taille est dans **`obstacles`**, indexé **`[x][y]`** :
`largeur = len(ob)*8`, `hauteur = len(ob[0])*8`. Case libre si `Tags == 0`.
Entités dans `d['Object']['Entities'][0]` → `MapChars`, `GroundObjects`,
`Spawners`, `Markers` (position dans `Collider` X/Y).

### `.rsmap` (arènes)
`MapTeams[0].Players[]` = les combattants. Champs utiles : `CurrentForm`,
`BaseForm`, `Level`, `HP`, **`MaxHPBonus`**, `Skills`, `serializationLoc`,
`Tactic`, `Unrecruitable`.

**`HP` et `MaxHPBonus` décrivent le même réservoir** : PV totaux = somme des deux.

---

## 7. API PMDO — CE QUI EST ATTESTÉ

Référence complète : `PMDODump/DataAsset/Docs/Script.txt` (3275 lignes, 255
fonctions). New Era en exploite **202/255**.

**Attestées et sûres** (nb de fichiers) :
`GROUND:CharTurnToCharAnimated` (547) · `GROUND:MoveToPosition` (50) ·
`GROUND:CharSetAnim` (128) · `GeneralFunctions.HeroDialogue` (62) ·
`TASK:JoinCoroutines` (78) · `TASK:BranchCoroutine` · `GROUND:CharSetEmote` ·
`GROUND:TeleportTo` · `GROUND:AddMapStatus` / `RemoveMapStatus` ·
`GROUND:MoveScreen(RogueEssence.Content.ScreenMover(min,max,durée))` ·
`GAME:MoveCamera` · `GAME:FadeIn` / `FadeOut` · `GAME:CutsceneMode` ·
`UI:WaitShowDialogue` · `UI:WaitShowVoiceOver` · `UI:WaitShowBG` ·
`UI:ChoiceMenuYesNo` · `SOUND:PlayBGM` / `FadeOutBGM` / `PlayBattleSE` ·
`Decorations[0].Anims:Add` (41) / `:RemoveAt` (25)

**À NE PAS UTILISER — n'existent pas :**
- `Anims:Clear()`
- `CharAnimateTurnToChar`
- `STRINGS.Format` (le point) → toujours **`STRINGS:Format`** (deux-points)

**SE attestés** : `EVT_Battle_Flash` (33) · `DUN_Money` (22) ·
`EVT_Emote_Exclaim_2` (12) · `DUN_Shadow_Force` (3) · `DUN_Rollout` (2) ·
`DUN_Heal_Bell` (4) · `_UNK_DUN_Water_Drop` (2)

**Patron de rêve / vision** (vérifié `guild_heros_room_ch_5.lua:142-165`) :
```lua
SOUND:FadeOutBGM(120)
GAME:FadeOut(false, 120)
UI:WaitShowVoiceOver("[speed=0.5]...texte...[pause=30] suite...[speed=1]", -1)
```
Assets présents : `Dream_Back.dir`, `Dream_Front.dir` (192×240, 63 frames).

---

## 8. MODULES GLOBAUX (Data/Script/halcyon/)

| module | rôle |
|---|---|
| `VoiceVisions` | la Voix parle au héros seul (`Speak`) + visions en planches (`Play`) |
| `HeroVisions` | visions spécifiques du héros |
| `ChapterScenes` | scènes d'arrivée devant les donjons ch8-10 |
| `ChapterAftermath` | scènes d'après-boss |
| `ReplayEnding` | rejouabilité des donjons d'histoire |
| `DazzlingArc` | Team Dazzling (ch6) |
| `VeilleurArc` / `LegendArc` | les 10 Veilleurs, les 42 gardiens |
| `BossFX` | signatures d'apparition (`EmergeShadow`, `StrikeThunder`…) |
| `BossMusic` | 12 thèmes distincts pour 49 arènes |
| `EngineKit` | 5 API PMDO inexploitées |
| `SideQuests` | requêtes de Metano (ch6, verrou de progression) |
| `TownVoices` | 26 PNJ réactifs, **ch6** |
| `TownVoicesLate` | **420 répliques, ch7-10** (26 PNJ × 4 chapitres × 4 paliers) |
| `TownVoicesNight` | 59 habitants réagissent aux raids |
| `TownNight` | choix de fin de journée + Metano de nuit |
| `TownNightScenes` | cinématiques de nuit par chapitre + Voix au puits |
| `TownRaid` | pillards nocturnes (3 vagues) |
| `TownPlunder` | conséquences d'un raid perdu |
| `TownReward` | récompenses d'un raid gagné |
| `RaidScenes` | écroulement / chevet de la guilde / fuite des ombres |
| `NightWatch` | le tour de guet (raison narrative de la nuit) |
| `Seasons` | saisons de Metano pilotées par le chapitre |

---

## 9. OUTILS (tools/) — INVENTAIRE COMPLET

**54 scripts au total** *(recompté le 2026-07-30 ; la valeur 41 datait d'une session antérieure).* Ils se rangent en quatre familles. Les VÉRIFICATEURS
tournent avant chaque commit ; les autres sont des outils ponctuels, gardés
comme référence de méthode.

### 9.1 VÉRIFICATEURS — à lancer avant chaque commit

| outil | usage | référence attendue |
|---|---|---|
| `audit_bugs.py` | **12 contrôles d'exécution** : fonctions appelées et absentes, champs `SV` non déclarés, objets de carte sans handler, zones/cartes/items/MapStatus inexistants, cycles de `require`, `STRINGS.Format`, virgule avalée, `Released=false` | **12 signalements**, tous documentés inoffensifs (§11) |
| `verify_legend.py` | mots interdits dans les textes affichés | tout vert |
| `verify_scene_positions.py` | entités placées hors carte | tout vert |
| `verify_bg_format.py` | format et dimensions des `.dir` | tout vert |
| `validate_all.py` | géométrie et marchabilité des arènes | tout vert |
| `audit_integrite.py` | intégrité globale (clés, références) | **925** (dette connue) |
| `audit_dialogues.py` | dialogues anglais réellement **visibles** en jeu | — |
| `audit_boss_cinematics.py` | qualité des scènes de boss | — |
| `count_dialogue.py` | densité de dialogue par chapitre | voir §10 |
| `validate_ch5.py` | validation de bout en bout du chapitre 5 | — |

### 9.2 SIMULATEURS — exécutent réellement du Lua

Rares et précieux : ils font tourner la logique du mod hors du jeu.

| outil | usage |
|---|---|
| `simulate.py` | exécute la logique Lua du mod dans un moteur RogueEssence simulé |
| `test_scenarios.py` | rejoue des scénarios complets en exécutant le vrai code Lua |
| `sim_legend.py` | simulation des rencontres légendaires |

### 9.3 GÉNÉRATEURS D'ASSETS

| outil | usage |
|---|---|
| `gen_season_particles.py` | dessine les `.dir` de particules saisonnières (sakura / feuilles / neige) au format exact du moteur |
| `tile_night.py` | conversion colorimétrique des tilesets en version nuit |
| `retile_lugia_arena.py` | retile l'arène de Lugia avec le bon tileset |
| `rebuild_tile_index.py` | régénère `Content/Tile/index.idx` depuis les `.tile` présents |
| `gen_boss_cinematics.py` | génère les 42 scènes « Éveil des Ancrages » (Livre II) |

### 9.4 IMPORTEURS ET CORRECTIFS PONCTUELS

Outils d'une passe, conservés parce qu'ils **documentent la méthode**
d'import 1:1 depuis pmd-red / EoSO.

*Conversion pmd-red :* `pmdred_lib.py` (bibliothèque commune) ·
`convert_pmdred_ground.py` (une carte GBA `.bpl.bpc.bma` → New Era) ·
`convert_pmdred_batch.py` (par lot) · `convert_relays_official.py`
(relais → grounds officiels PMDO)

*Vagues d'import :* `import_wave1_dungeons.py` (7 donjons ch1-4) ·
`import_wave2_dungeons.py` (15 donjons ch2-10) ·
`import_wave3_anchors.py` + `import_wave3b_anchors.py` +
`import_wave3c_mythicals.py` (Ancrages ch11-32, duos separes, fabuleux) ·
`import_wave4_sloth.py` (82 grounds) ·
`import_wave6_friendareas.py` (57 Friend Areas → arènes de boss) ·
`import_aegis_arena.py` (Sanctuaire des Titans, Regigigas ch7)

*Ajouts de contenu :* `add_annexe_toupie.py` (étage mystère) ·
`add_checkpoint_scenes.py` (mort après relais = réveil au relais) ·
`add_crooked_profondeurs.py` · `add_reseau_veilleurs.py`

*Add-ons réseau :* `gen_addon_pmdred_network.py` + `gen_addon_pmdred_network_v2.py`
(Anciens Chemins) · `gen_addon_sky_network.py` (Réseau du Ciel)

*Correctifs :* `fix_ch7_ch10_flow.py` (flux de progression) ·
`fix_ground_serialization.py` (écran noir au chargement des grounds importés) ·
`fix_grounds_entities.py` (placement des spawners, objets, triggers) ·
`rebalance_bosses.py` (renivelage des boss ch6-10)

### 9.5 Séquence de validation complète

```bash
# 1. compilation Lua de TOUS les fichiers
python3 -c "import lupa,glob; L=lupa.LuaRuntime(); \
[L.compile(open(f,encoding='utf-8').read()) for f in glob.glob('Data/Script/**/*.lua',recursive=True)]"

# 2. les vérificateurs
python3 tools/audit_bugs.py .              # doit rester a 12
python3 tools/verify_legend.py .
python3 tools/verify_scene_positions.py .
python3 tools/verify_bg_format.py .
python3 tools/validate_all.py .
python3 tools/audit_integrite.py .         # reference 925
python3 tools/count_dialogue.py
```

**Prérequis** : `pip install --break-system-packages lupa Pillow numpy`.
Ces paquets disparaissent si le sandbox est recloné — les réinstaller alors.

**Mesure avant/après** pour prouver qu'on n'a rien cassé :
```bash
python3 tools/audit_integrite.py .
git stash && python3 tools/audit_integrite.py . && git stash pop
```

**Note** : 7 de ces outils (`audit_bugs`, `audit_integrite`,
`verify_scene_positions`, `verify_bg_format`, `audit_boss_cinematics`,
`gen_season_particles`, `tile_night`) ont été créés au fil des sessions et
vivent sur `main`. S'ils manquent dans un checkout, c'est que celui-ci n'est
pas à jour — voir §0.

## 10. DENSITÉ MESURÉE

| ch | boîtes | objectif |
|---|---|---|
| 1-4 | 2481 | — |
| 5 | 1586 | 7000 |
| 6 | **457** | 7000 |
| 7 | **397** | 7000 |
| 8 | **324** | 7000 |
| 9 | **307** | 7000 |
| 10 | **256** | 7000 |

Repères : 1 étage ≈ 2 min, 1 boîte ≈ 6 s. Total actuel ≈ 15 h, cible 23-30 h.

---

## 11. LES 12 SIGNALEMENTS RESTANTS (tous inoffensifs, documentés)

- **5× `SV.guildmaster_summit.GameComplete`** — résidu d'add-on non installé,
  jamais écrit ni déclaré. Sans effet : rend `nil` → `false`.
- **4× objets sans handler** — `testmap` (carte d'atelier jamais référencée),
  3 plages absentes de `master_zone` donc inatteignables.
- **3× zones `Released=false`** — `imbion_*`, zones en réserve.

**Ne pas les « corriger » sans raison** : ce sont des faux positifs assumés.

---

## 12. DETTES PRÉEXISTANTES CONNUES

- 727 clés `.resx` orphelines (dette d'écriture, pas un bug d'exécution)
- 74 clés `Connect_*` du bureau de poste (menu réseau hors périmètre)
- 36 clés `megastones` sans traduction FR
- `machine_recall_box.json` sans BOM
- IA `escortee` (EoN) documentée mais non importée — manque avéré pour les
  missions d'escorte
- Cartes `guilde_parvis_soir` / `_nuit` / `guilde_sous_sol_nuit` : coquilles
  vides (19 lignes, « RÉSERVE »), absentes de `master_zone`
- 31 grounds pmd-red « en réserve » non traités
- Chapitres 11-32 : donjons et 42 cinématiques d'Ancrage prêts, scénario non écrit

---

## 13. FAUX POSITIFS À NE PAS REFAIRE

- Doublons `.resx` non consécutifs = branches `if/else` exclusives (choix
  d'écriture, pas un bug)
- `Food_*` du réfectoire : `triggerType 0`, décoratifs
- `Teammate1` est natif ; `Slugma_*` créés par `GroundChar` direct
- `Fog_2`, `Black`, `Heat_Wave`, `Silver_Wind`, `Cosmic_Power`,
  `clouds_overhead` : assets **moteur**, absents du mod par conception
- Les « Chambres des Âges » (`chambre_agee_an` / `_o`) ne sont **pas** des
  chambres à coucher : ce sont des cavernes (imports pmd-red, `Boss_Marker`,
  musique de carrière)
- `Hay_Bed.dir` n'est **pas** du mobilier d'intérieur : il est rangé à côté de
  `Campfire.dir` dans `Content/Object/`, et la carte
  `mount_windswept_midpoint` porte déjà 3 tentes + 4 feux. Un bivouac **est**
  le vocabulaire visuel de ce donjon.

---

## 14. CHANTIER EN COURS — MONT VENTEUX

### État

La cinématique d'arrivée est **corrigée** (bugs visuels réglés) mais reste
**très en dessous** de son équivalent au Tunnel Incandescent.

| | Tunnel | Mont | cible |
|---|---|---|---|
| lignes | 2426 | 898 | — |
| boîtes | 235 | 100 | ~230 |
| émotions | 64 | 7 | ~55 |
| caméra | 11 | 2 | ~10 |
| coroutines | 214 | 13 | ~90 |

Le nom de la scène du Tunnel dit ce qui manque :
`ArrivalDinnerNightAndAddressCutscene` — arrivée, **dîner**, nuit **et adresse
du matin**.

### Ce qui a déjà été corrigé

- **Décor dédoublé** : `SetupGround` et la cinématique posaient chacun les
  mêmes 12 paillasses + le même feu (256,220). 14 `Anims:Add` pour zéro purge,
  et `SetupGround` rappelé à chaque entrée → empilement infini.
  → constructeur unique `BuildCamp()` avec purge par `RemoveAt`.
- **Paillasse dans la roche** : le lit 11 en (312,108) tombait sur `Tags ≠ 0`.
  → déplacé en (384,196). Les 12 sont sur sol libre.
- **2 PNJ assis sur un lit** : Rin (lit 7) et Coco (lit 5) → remontées de 16 px.
- **Veillée ajoutée** (`CampNightfall`) : repas, silence, coucher en décalé.

### Plan en 6 actes

**Acte 1 — Arrivée** *(existe, ne pas toucher)* — clés `MWE5_001` à `020`

**Acte 2 — Le repas** *(9 → ~60 boîtes)*
Trois conversations **en parallèle**, pas en file d'attente :
- *feu ouest* — Kino & Reinier : provisions, météo de demain
- *feu est* — Ganlon & Hyko : la friction habituelle
- *près du duo* — Shuca & Almotz : l'émerveillement des jeunes

3 `BranchCoroutine` simultanées + `MoveCamera` qui bascule + `JoinCoroutines`.

**Acte 3 — Le silence** *(2 → ~15)* — les émotions s'éteignent en cascade,
Penticus dit sa phrase.

**Acte 4 — Le coucher** *(3 → ~25)* — une réplique par membre en rejoignant sa
couche, décalage 12 frames.

**Acte 5 — LE RÊVE** *(neuf, ~40 boîtes)* — façon Rescue Team
Infrastructure vérifiée : `Dream_Back.dir`, `Dream_Front.dir`, patron complet
dans `guild_heros_room_ch_5.lua:142-165`. `WaitShowVoiceOver` = pas de boîte,
pas de locuteur — le format des rêves de Rouge/Bleu.

Contenu : la veille de gravir la montagne — le vent qui parle avant d'être du
vent, une hauteur déjà gravie mais dans un autre corps, la Voix (``,
anonyme) qui dit ce que le héros **oubliera au réveil** :
*« Un rêve ? Je n'arrive déjà plus à m'en souvenir. »*

Règle : le héros ne comprend pas ce qu'il voit, **c'est au joueur de
reconnaître**.

**Acte 6 — L'ADRESSE DU MATIN** *(neuf, ~70 boîtes)*
Le vrai manque. `RemoveMapStatus("darkness")`, la lumière revient, le camp se
lève, Penticus fait le point et distribue les rôles, l'expédition part. C'est
ce qui ferme le cycle.

### Points d'appui vérifiés

**Carte** `mount_windswept_entrance` : 552×504, tilesets
`Mount_Windswept_Base/Fringe/Mountain/Objects/Objects_Under/Shadows`,
musique `Canyon Camp.ogg`. Seulement 2 objets : `Kangaskhan_Rock`,
`Dungeon_Entrance`.

**Positions** (toutes libres, zéro conflit avec les lits) :
feu `(256,220)` · Penticus `(212,244)` · Phileas `(300,244)` ·
Rin `(220,260)` · Coco `(292,260)` · Shuca `(204,312)` · Ganlon `(308,312)` ·
Kino `(160,300)` · Reinier `(360,300)` · Hyko `(292,428)` · Almotz `(244,428)`

**Table `BEDS`** (12 couchages, tous sur sol libre, déjà dans le fichier) :
`(256,164) (301,175) (334,208) (334,248) (301,281) (256,292) (211,281)`
`(178,248) (178,208) (211,175) (384,196) (344,132)`

**Point d'accroche** : `CampNightfall()` dans
`Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua`

**Texte littéral français** dans le script — les clés `MWE5_` s'arrêtent à 020.

### Ordre conseillé

1. **Acte 5 (rêve)** — le plus fort narrativement, infra déjà là
2. **Acte 6 (matin)** — ferme le cycle
3. **Acte 2 (repas)** — apporte le volume
4. **Actes 3-4** — enrichissement

---

## 15. AUTRES CHANTIERS OUVERTS

- **Étendre `TownVoicesNight`** aux PNJ des ch7-10 (fait pour le ch6)
- **Choix de fin de journée** : branché sur 9 points / 10 zones. Les 6 exclus
  mènent à un ground dédié (Sanctum, Luminous Spring, Apricorn Glade,
  crooked_den, Crucible) ou à une veillée imposée — **ne pas les brancher**
- **Phileas n'a aucun dialogue** dans le bureau du maître alors qu'il dit y
  travailler
- **Pas de fichier de chapitre** `guild_guildmasters_room_ch_7..10` — un
  routeur tolérant a été posé, mais le contenu manque
- **Fenêtres allumées la nuit** : la conversion des tilesets est
  colorimétrique, pas du pixel-art. Les `.tile` `_Night` sont remplaçables.

---

## 16. RÉSERVE PERMANENTE

**RIEN N'A JAMAIS ÉTÉ TESTÉ EN JEU.** Une trentaine de lots validés
statiquement seulement : compilation Lua, cohérence JSON, positions,
marchabilité, absence de mots interdits.

Les points les plus sensibles à surveiller au premier test :
- le collider de `Bedroom_Door` (posé sur une case de mur, bureau du maître)
- `PoseGroundAction("Faint")` fige une pose — si elle n'est pas levée, le duo
  reste couché
- `ContinueDungeon("gloomy_forest", 6..8)` pour les raids : segments ajoutés,
  jamais chargés en jeu
- le rendu des tuiles de nuit et des particules saisonnières

---

## 17. PROMPT À COLLER EN DÉBUT DE NOUVELLE SESSION

> Reprise du mod PMDO **New Era : Abyss to Ascension** (namespace `halcyon`,
> jeu en **français**). Réponds en français.
>
> **Lis d'abord `docs/PASSATION_AGENT_ARENA.md`** — il contient la
> méthodologie, les formats de fichiers décodés, le casting vérifié, les API
> attestées, les pièges à éviter et le chantier en cours.
>
> **Méthode exigée** : preuve avant hypothèse — vérifier dans les fichiers
> avant d'affirmer, ne jamais inventer une API (compter ses occurrences hors
> du fichier courant), prouver le format d'un JSON par round-trip avant de
> l'écrire, patchs chirurgicaux uniquement. Signaler honnêtement ses erreurs,
> les faux positifs de ses propres outils, et rappeler que rien n'est testé
> en jeu.
>
> **Règles non négociables** : jamais « Necrozma », « Eternatus », « l'Abîme »,
> « prison » dans un texte affiché. Ne jamais nommer les personnages des jeux
> d'origine — le joueur reconnaît, le héros non. Répliques de 1-2 phrases,
> < 150 caractères hors `[pause=N]`. Toute table `SV` neuve déclarée dans
> `scriptvars.lua` **et** rattrapée dans `OnUpgrade`. Incrémenter le tag de
> build dans les 3 fichiers (prochain : `2026-08-01-V`).
>
> **Validation avant chaque commit** : compilation Lua de tous les fichiers,
> `audit_bugs.py` (doit rester à 12), `verify_legend.py`,
> `verify_scene_positions.py`, `audit_integrite.py` (référence 925).
>
> **Chantier prioritaire** : porter la cinématique d'arrivée du Mont Venteux au
> niveau de celle du Tunnel Incandescent — voir §14 de la passation. Commencer
> par l'acte 5 (le rêve, façon Rescue Team), puis l'acte 6 (l'adresse du
> matin).

---

# ANNEXE A — DIRECTIVE DE MÉTHODE (reçue le 2026-07-29)

## 0. Compréhension globale avant tout développement

Ne développe jamais une fonctionnalité ou une cinématique de manière isolée. Avant de coder ou d'écrire quoi que ce soit :

- Acquiers une vision globale de la trame scénaristique, de l'architecture du projet et du fonctionnement du moteur PMDO, pour que chaque modification s'intègre naturellement à l'ensemble.
- Lis et analyse la documentation disponible, les scripts existants, les Grounds, les Entrances, les Donjons et les cinématiques déjà validées.
- Comprends les capacités et contraintes du moteur : scripting, gestion des événements, caméra, animations, déplacements, dialogues, transitions, GroundMaps, Donjons, objets interactifs.
- Maîtrise la chronologie narrative complète : relations entre personnages, personnalité, rôle dans la Guilde, motivations, connaissances à chaque instant de l'histoire, évolution au fil des chapitres. Un personnage ne doit jamais agir ou parler d'une façon qui contredit ce qu'il sait, ce qu'il a vécu ou son caractère.

### Connaissance exhaustive du projet

Cette compréhension globale n'est pas une lecture rapide ou un survol : elle implique de **connaître le projet par cœur**, au même titre qu'un scénariste connaît par cœur la série sur laquelle il travaille.

- Lire l'intégralité des dialogues de tous les chapitres déjà écrits, pas seulement ceux de la scène en cours ou du chapitre le plus récent.
- Lire l'intégralité des cinématiques déjà produites (chapitre par chapitre), y compris celles qui semblent sans lien direct avec la tâche en cours — une réplique ou un détail posé au chapitre 1 peut conditionner une scène du chapitre 20.
- Retenir, pour chaque personnage : ce qu'il sait à un instant T, ce qu'il ignore encore, ce qu'il a vécu, comment son caractère et sa façon de parler ont évolué au fil des chapitres.
- Retenir la chronologie exacte des événements et les liens de cause à conséquence entre les chapitres, pour ne jamais écrire une scène qui présuppose une information que le personnage ne devrait pas encore avoir, ou qui contredit un événement déjà posé ailleurs.
- Avant toute nouvelle tâche, si un doute existe sur un fait narratif (ce qu'un personnage sait, un événement passé, une relation entre deux personnages), relire les chapitres et cinématiques concernés plutôt que de supposer ou d'improviser. Une hypothèse non vérifiée sur la continuité est une source directe d'incohérence.
- Cette exigence s'applique en continu : à chaque nouveau chapitre ou cinématique ajouté au projet, l'intégrer à cette connaissance d'ensemble avant de travailler sur la suite.

Avant de travailler sur une scène, pose-toi systématiquement :

- Qu'est-ce qui s'est passé avant ?
- Pourquoi cette scène existe-t-elle ?
- Quelles informations les personnages possèdent-ils à cet instant ?
- Quelles seront les conséquences de cette scène sur la suite de l'histoire ?
- Cette scène est-elle cohérente avec les chapitres précédents et prépare-t-elle correctement les suivants ?
- Le moteur permet-il une meilleure mise en scène que celle actuellement proposée ?

Le moteur n'est pas une simple contrainte technique : cherche systématiquement l'usage le plus intelligent de ses capacités. Avant d'implémenter une solution, demande-toi s'il n'existe pas une approche plus propre, plus élégante, plus immersive ou plus fidèle à Pokémon Mystery Dungeon.

Raisonne simultanément comme développeur, game designer, narrative designer, level designer, cinematic designer et testeur qualité. L'objectif n'est pas seulement que le contenu fonctionne, mais qu'il soit cohérent avec le reste du projet, exploite correctement le moteur, et atteigne un niveau de finition digne d'un jeu officiel. Chaque modification suit deux phases : analyse/réflexion, puis audit/validation.

### Principe général (cinématiques)

N'exécute jamais une liste d'événements de façon mécanique. Avant d'écrire ou de modifier une cinématique, pense en scénariste-réalisateur : pour chaque personnage présent, demande-toi *« Que ferait-il à cet instant précis, compte tenu de son rôle, de son caractère, de ce qu'il voit, entend et sait ? »*. Chaque action doit avoir une raison d'être et découler logiquement de la situation.

**Exemple de référence (Mont Windsep)** : si le héros se réveille brusquement d'un cauchemar alors que Philéas assure la veille nocturne, celui-ci ne peut pas rester passif. Son rôle de mentor et de vétéran implique qu'il réagisse aussitôt : lever la tête, se tourner vers le héros, s'approcher, s'arrêter à une distance crédible, engager le dialogue, chercher à le rassurer, puis reprendre son poste. Un personnage important qui reste inactif alors qu'il devrait intervenir casse la crédibilité de la scène.

### Règles de mise en scène

**Personnages toujours actifs**

- Aucun personnage ne doit rester figé en attendant son tour de parole.
- Chaque dialogue s'accompagne de mise en scène : déplacements, changements de direction, regards, animations d'émotion, pauses, réactions, mouvements de caméra.

**Orientation et regard**

- Un personnage qui parle doit tourner la tête ou le sprite vers son interlocuteur.
- Quand un nouveau personnage intervient, les autres se tournent vers lui.
- Tout bruit, événement ou explosion doit déclencher un regard vers la source avant toute réaction.

**Déplacements crédibles**

- Un personnage ne se téléporte jamais mentalement d'un état à un autre.
- Il marche jusqu'à son interlocuteur, s'arrête à une distance naturelle, se retourne si besoin, puis parle.
- Une fois la conversation terminée, il reprend son activité ou quitte la scène de façon logique.
- Pas de changement de direction aléatoire, de rotation gratuite ou de déplacement sans justification.

**Positionnement**

- Les PNJ ne se superposent jamais, ne se bloquent pas mutuellement et ne sortent pas du champ de caméra pendant une scène importante.
- Les formations doivent paraître naturelles et rendre la scène lisible.
- Les protagonistes principaux restent visibles quand c'est nécessaire ; la caméra suit intelligemment les déplacements.
- Dans les déplacements de groupe (ex. Mont Windsep), garder un espacement crédible entre les Pokémon : éviter les groupes trop compacts qui donnent une impression de blocage ou de collage.

### Audit final (obligatoire avant de considérer une scène terminée)

Vérifier systématiquement :

1. Réactions de chaque personnage aux événements
2. Positionnement et déplacements
3. Orientation (regardent-ils leur interlocuteur / la source d'un événement ?)
4. Animations et expressions
5. Cohérence dialogues / émotions
6. Mouvements de caméra — mouvement doux, sans exclure d'entités actives hors champ
7. Distances entre personnages — espacement naturel, notamment dans les déplacements de groupe (cf. retour Mont Windsep)
8. Entrées et sorties de scène
9. Collisions et superpositions
10. Continuité entre cinématiques et Grounds

**Test de crédibilité** : si un joueur peut se demander *« Pourquoi ce personnage ne réagit-il pas ? »*, *« Pourquoi personne ne regarde celui qui parle ? »*, *« Pourquoi ce PNJ reste immobile ? »*, *« Pourquoi ce personnage ne s'approche-t-il pas ? »* ou *« Pourquoi cette réaction paraît-elle artificielle ? »* — la scène n'est pas terminée. Corrige-la jusqu'à ce que chaque personnage donne l'impression de vivre réellement la scène.

**Objectif final** : chaque cinématique doit pouvoir être confondue avec une cinématique officielle de Pokémon Mystery Dungeon, tant par l'écriture que par la mise en scène, le langage corporel, le comportement des personnages et le niveau de finition.

**Repère qualité déjà validé** : les cinématiques des chapitres 1 à 5 de New Era, jusqu'à l'entrance du Mont Windsep incluse (polish & fix effectués), correspondent au niveau attendu. S'en servir comme référence de comparaison pour tout nouveau contenu.

### Auto-questionnement : esthétique et positionnement sur le Ground

Avant de valider une scène ou une transition sur un Ground, se poser systématiquement :

**Positionnement des personnages**

- Le placement de chaque PNJ sur le Ground est-il justifié par son rôle et son emploi du temps (garde en faction, marchand à son étal, PNJ en veille, PNJ endormi) ?
- Le nombre de Pokémon présents sur le Ground après une cinématique est-il cohérent avec la narration ? (ex : un lieu ne doit pas se vider intégralement sans raison scénarisée)
- Les personnages qui doivent logiquement rester (parce qu'ils vivent là, montent la garde, etc.) sont-ils toujours présents, ou ont-ils disparu par erreur technique ?

**Collisions et décor**

- Les éléments de décor solides (feu de camp, rochers, meubles, tentes) bloquent-ils réellement le passage, ou le joueur/PNJ peut-il traverser un objet censé être un obstacle ?
- Reste-t-il des objets visuels temporaires (sacs, effets de quête, marqueurs) que la scène aurait dû faire disparaître une fois leur rôle narratif terminé ?

**Cohérence sonore et élémentaire**

- Le bruitage associé à une action (objet utilisé, capacité, soin) correspond-il au personnage qui l'exécute (son type, sa personnalité, sa cohérence interne) ?
- Dans une séquence de rêve, de vision ou de flashback, seuls les sons justifiés narrativement doivent être audibles — un bruitage du monde réel qui n'a aucune raison de s'y trouver casse l'immersion.

**Ton et rythme**

- Une rupture de ton (moment comique après une scène tendue, OST qui détend l'ambiance) est-elle amenée de façon crédible, avec une transition qui justifie le changement plutôt qu'un contraste brutal et gratuit ?
- Chaque personnage réagit-il à l'écart de ton avec sa propre personnalité (l'un lance la blague, l'autre s'agace, un troisième reste sérieux) plutôt que tous réagissant de façon uniforme ?

Si l'une de ces questions révèle une incohérence, la scène n'est pas terminée : elle doit être corrigée avant validation.

### Transitions entre scènes et entre lieux

Une transition n'est jamais un simple effet technique posé entre deux blocs de contenu : elle fait partie de la mise en scène et doit être pensée comme telle. Un fondu mal calé casse l'immersion aussi sûrement qu'un personnage qui ne réagit pas.

**Avant d'implémenter une transition, se demander :**

- Quel type de transition sert le mieux ce changement de lieu ou de temps (fondu au noir, fondu enchaîné, coupe directe, transition avec chargement) ? Le choix doit être justifié par la nature du changement (ellipse temporelle, changement de zone, réveil, mort/évanouissement, retour en arrière), pas posé par défaut.
- Le timing du fondu est-il calé sur la fin réelle de l'action en cours, ou coupe-t-il un mouvement, une réplique ou une animation avant qu'elle soit terminée ?
- À l'entrée dans le nouveau lieu, le fondu se lève-t-il une fois que tout est en place (caméra positionnée, personnages à leur point de départ, décor chargé), ou le joueur voit-il une image incomplète, un personnage encore en train de se placer, ou un pop-in de décor ?
- Y a-t-il un flottement injustifié (silence ou écran noir trop long) entre la fin d'une scène et le début de la suivante, ou à l'inverse un enchaînement trop brusque qui ne laisse pas respirer le changement de lieu ?
- Le son (OST, ambiance, bruitages) suit-il la logique de la transition, ou coupe-t-il/reprend-il de façon incohérente avec l'image (musique de l'ancienne zone qui continue après le fondu, silence soudain, coupure sèche d'un morceau) ?
- Si la transition marque un changement d'état du personnage (sortie de rêve, perte de conscience, téléportation), l'effet visuel choisi correspond-il à ce changement d'état, ou est-ce un fondu générique réutilisé sans distinction ?

**Test de crédibilité spécifique aux transitions** : si un joueur peut se demander *« Pourquoi ce fondu tombe-t-il à ce moment précis ? »*, *« Pourquoi je vois encore le lieu précédent alors que le nouveau a déjà commencé ? »*, *« Pourquoi ce silence / cette coupure de musique ? »* ou *« Pourquoi ça met du temps à charger devant moi ? »*, la transition n'est pas terminée.

**Exemple identifié à corriger — Tunnel du Mont Windsep** : un fondu mal exécuté a été relevé sur cette transition (timing incorrect). C'est un cas concret à utiliser comme référence négative : avant de considérer une transition comme validée, la comparer à ce défaut connu pour vérifier qu'il n'a pas été reproduit ailleurs.

### Outils internes à concevoir (pipeline de production)

Ne te contente pas de produire du contenu : conçois aussi tes propres outils de travail. Si une tâche est répétitive, complexe ou soumise à de nombreux critères de qualité, crée un outil, un générateur, une checklist ou un workflow qui garantit le respect systématique des exigences du projet.

Construis progressivement une suite d'outils internes dédiée à New Era, par exemple :

- un **générateur de cinématiques** construisant une scène selon les standards PMD et les critères de ce projet ;
- un **analyseur de cohérence scénaristique** vérifiant personnages, réactions, connaissances, motivations et causalité des événements ;
- un **vérificateur de mise en scène** contrôlant caméra, déplacements, animations, rotations de sprites, regards, pauses, émotions, effets visuels et rythme ;
- un **audit de Ground** détectant les incohérences de mapping, collisions, positionnement des PNJ, décor, objets interactifs et continuité inter-maps ;
- un **analyseur de dialogues** détectant conversations artificielles, transitions brusques, répétitions, ruptures de sujet incohérentes, personnages hors-caractère ;
- un **contrôleur de continuité** comparant chapitres, cinématiques et Grounds pour éviter les contradictions.

Ces outils doivent être spécifiques à New Era et intégrer tous les critères de qualité de ce projet — pas génériques. À chaque nouvelle exigence, fais-les évoluer pour qu'ils la contrôlent automatiquement lors des générations suivantes.

Une cinématique générée doit couvrir : découpage cinématographique, storyboard des événements, placements initiaux, déplacements, orientations, regards, animations et émotions, mouvements de caméra, effets visuels et sonores, temps de pause, rythme narratif, transitions, conditions de déclenchement, conséquences sur les scènes suivantes. Chaque scène générée doit ensuite être confrontée automatiquement aux outils d'analyse avant d'être considérée comme terminée.

Objectif : un véritable pipeline de production digne d'un studio de développement, où chaque nouvel outil améliore la qualité des générations suivantes, réduit les erreurs, empêche la réapparition d'anciens bugs, et fait progresser le niveau de finition en continu. Face à une erreur récurrente, ne te contente pas de la corriger : améliore l'outil ou le processus pour qu'elle ne puisse plus se reproduire.

---

# ANNEXE B — DIRECTIVE DE REVUE : MONT WINDSEP (reçue le 2026-07-29)

Le Mont Windsep dans son intégralité (Grounds, Entrance, Donjon, cinématiques, transitions) doit être repassé au crible de l'ensemble des règles de ce document — mise en scène, positionnement, audit final, esthétique du Ground, et transitions — et pas uniquement sur le point du fondu du tunnel déjà identifié.

Procéder scène par scène et transition par transition :

1. Lister chaque cinématique et chaque transition de zone du Mont Windsep.
2. Pour chacune, appliquer l'audit final (10 points) et le test de crédibilité.
3. Pour chaque transition, appliquer spécifiquement la checklist de la section précédente.
4. Consigner les incohérences trouvées avec leur localisation précise (fichier + scène), sans se limiter au fondu du tunnel déjà signalé.
5. Ne corriger que ce qui est confirmé comme incohérent après audit — ne pas modifier une scène qui passe déjà le test de crédibilité, pour éviter toute régression sur du contenu déjà validé.

---

# ANNEXE C — RÉVISION AEGIS CAVE + AUDIT MODE DEV (2026-08-07)

## Aegis Cave : la conversion d54-d61 est NON canonique (purge)

Le commit 2180945 convertissait files/MAP_BG/d54…d61 de pret/pmd-sky en 19
grounds « Aegis Cave » en supposant numéro de donjon == numéro de groupe de
cartes. **Faux, vérifié par désassemblage SSB** (skytemple-files,
`to_explorerscript`) sur les scènes du jeu :

- d54 = Jungle Méridionale (ES4) : n06a0501 « Nous sommes sorties de la
  Jungle Méridionale » ; d54p31a/p32a rendues à 94-96 % vert (feuillage).
- d55 = Carrière Rocher (ES4) : BGM_BOULDER_QUARRY ; n06a3401 = coffre vide
  / Team AWD.
- d56 = Caverne Calcaire (ES4) : n06a2802 « I-in a limestone cavern! »,
  BGM_LIMESTONE_CAVERN.
- d57 = Mont Travail (ES3, Sunflora/Haunter) : n04a2001 « Je vais t'arrêter,
  Haunter ! », « hot hot hot! » (lave).
- d58-d61 = UN SEUL template (md5 identiques .bma/.bpc/.bpl, même layout
  57×57, 23 % libre) — pas 4 salles distinctes.
- d50-d53 = ES5 (Falaises Spatiales, montagnes de glace ; Primal Dialga sur
  d53p41a/b « GIGI GIGIGIGI »).

La table (donjon, étage) → (groupe de cartes, map) vit dans
`DUNGEON/dungeon.bin`, absent du repo : **les vrais étages fixes d'Aegis
Cave ne sont pas extractibles ici**. Les 19 grounds + 19 planches ont été
déplacés vers `RESERVE/aegis_non_canonique/` (README sur place).
`tools/convert_sky_aegis.py` est conservé, marqué NON CANONIQUE.
`docs/MANIFESTE_CONVERSION_SKY.md` corrigé en conséquence.

**Ce qui est canonique et déjà intégré dans cloven_ruins (ne rien casser) :**
mots Zarbi GLACE/ROCHE/ACIER (RuinesZarbi.lua), pierres `ruines_pierre_*`,
tablette « fermer les yeux », boucle de secteur, ordre Regice→Regirock→
Registeel→Regigigas, Puits B1-B5, Regigigas + 4 Hitmonlee + 4 Bronzong,
renforts Team Charme, finale RuinesTitan/RuinesRenforts. Arènes = étages
fixes (rsmap) où l'éveil ET le combat ont lieu sur la même carte.

## Audit mode dev — corrections livrées

1. **50 grounds fantômes matérialisés** (tools/materialise_phantoms.py) :
   les noms déclarés dans index.idx (master_zone index 10, 70-118 ;
   normal_maze) sans fichier faisaient crasher le warp du mode dev. Ils
   sont ENCASTRÉS dans la numérotation utilisée par des index en dur des
   scripts ch1-6 → impossible de les retirer. Chaque fantôme est désormais
   un minuscule ground de débogage (16×12 cellules, une planche partagée
   `debug_placeholder_Base.tile`), marqué PLACEHOLDER dans son Comment.
   Résultat audit : C1 50 → 0. Ne pas supprimer ces fichiers.
2. **26 références musicales cassées corrigées** (tools/fix_musiques.py) :
   `Boss Battle.ogg`/`Boss Battle 2.ogg` → `Boss Battle!.ogg` (23 rsmap de
   boss, dont jardin_secret ch4 / foret_embuscade ch5 / desert_oublies ch6
   — correction DATA uniquement, aucun script/structure ch1-6 touché) ;
   `Rayquazas Domain.ogg` → `Sky Tower.ogg` (tour_ciel_sommet,
   arc_tour_ciel_sommet) ; `Desert Region.ogg` → `Forsaken Desert.ogg`
   (desert_oublies) ; `Threat.ogg` → `Rising Fear.ogg` (marais_errants_fond).
   C7 : 26 → 0.
3. **Index des tilesets régénéré** (590 planches) après purge aegis +
   ajout placeholder.
4. **Audit ground correlation : 0 bloquant, 9 avertissements** (U1 noms
   internes dupliqués = copies d'arcs intentionnelles ; C8 retours
   volontaires ; C9 mapping waterfall_pond=113→sanctuaire_voeu assumé ;
   C3/C5 : bois_sombres_fond + 4 midpoints non branchés — les brancher
   toucherait les zones ch1-6, INTERDIT, laisser en l'état).
5. **Vérifs complètes** : 510+ Lua compilent 0 erreur ; tous les JSON
   parsent ; MapID des LayeredSegment existent ; EnterDungeon/
   ContinueDungeon segments dans les bornes ; SceneDebug 36/36 cibles et
   entrées valides ; dungeon_entrance_mapping résolu (cloven_ruins=56).

## Pièges à éviter

- `open(f, 'w')` AVANT de lire pour réécrire un JSON → fichier tronqué à 0
  octet (vécu). Toujours parser d'abord, écrire ensuite.
- Les numéros de donjon (enums.h DUNGEON_*) ne sont PAS les numéros de
  groupes de cartes (MAP_BG) hors plage d01-d49 — ne jamais réutiliser
  l'hypothèse d54=Ice Aegis Cave.
- Ne pas supprimer les entrées fantômes d'index.idx : les index en dur des
  scripts ch1-6 en dépendent (base_camp_2=10, abime_tempetes=70…).
