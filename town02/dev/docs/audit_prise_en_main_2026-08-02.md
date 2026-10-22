# Audit de prise en main — 2026-08-02

**Branche auditée :** `arena/019fad83-new-era-abyss-to-ascension-v4`
**HEAD :** `b526a68` — *fix(ch5/midpoint): prevent relay black screen and resync zone index* (2026-08-02 08:21 UTC)
**Rien n'a été modifié ni poussé.** Ce document est le rapport demandé avant toute application.

---

## 0. Blocage à lever : pas d'accès en écriture

```
$ git push --dry-run origin HEAD:arena/019fad83-new-era-abyss-to-ascension-v4
fatal: could not read Username for 'https://github.com': No such device or address
```

Le clone est anonyme (HTTPS public). Aucun credential n'est présent dans le sandbox :
pas de `~/.git-credentials`, pas de `~/.netrc`, pas de `credential.helper`, aucune
variable d'environnement contenant un token. Le dépôt est public, donc la lecture
fonctionne — mais **je ne peux pas commiter ni pousser** tant que le token n'est pas
fourni dans cette session. Tout ce qui suit est donc du diagnostic, pas de la
correction appliquée.

---

## 1. Étape 0 — Reprise du fil chronologique

### Environnement

| Vérification | Résultat |
|---|---|
| `lupa` | installé (compilation Lua opérationnelle) |
| `Data/Script/halcyon/TownNight.lua` | présent |
| `tools/audit_bugs.py` | présent |
| `tools/png2tileset.py` | présent |

Checkout à jour, rien à résoudre avant d'écrire.

### Les 5 derniers commits, et ce qu'ils changent réellement

| Date | Hash | Portée réelle (vérifiée par `--stat`) |
|---|---|---|
| 08-02 | `b526a68` | Corrige l'écran noir du relais Mont Windsep. Supprime la transition `EnterGroundMap` imbriquée dans `Enter`, resynchronise `Data/Zone/index.idx`, ajoute `tools/verify_zone_index.py`. **Build `2026-08-03-N` → `2026-08-03-O`.** |
| 08-02 | `ee06be8` | Quiz de Kirlia (ch8) : `Kirlia_Action` dans `metano_town_ch_8.lua` (+98 l.) et routage dans `init.lua` (+5 l.). **2 fichiers seulement.** |
| 08-02 | `478876d` | Blueprint ch8 Grand Tournoi (10 guildes, 3 épreuves) — documentaire. |
| 08-02 | `4e1d765` | Cinématiques quotidiennes du Café Spinda (7 scènes) + jobs Bekipan sur donjons classiques. |
| 08-02 | `6d88a6b` | Discussions de coucher avec le partenaire, ch6→ch10. |

### Correction d'un document daté par le code

`docs/PASSATION_AGENT_ARENA.md` (2026-07-29) écrit :

> Dernier tag de build posé : **`2026-08-01-U`**. Le prochain lot doit incrémenter à `2026-08-01-V`.

**Contredit par le code.** Les trois fichiers portent aujourd'hui :

```
Data/Script/halcyon/main.lua:63                          build 2026-08-03-O
Data/Script/halcyon/scriptvars.lua:1425                  build 2026-08-03-O
ground/vast_steppe_midpoint/init.lua:25                  build 2026-08-03-O
```

Le prochain lot doit donc incrémenter à **`2026-08-03-P`**, pas à `2026-08-01-V`.
La série a changé de préfixe de date depuis la rédaction de la passation.

### Règle méthodologique confirmée par l'historique

`fc9e33c` (2026-08-01) — *retrait des mini-boss (Steppe, Tunnel, Mont)* — puis
`19f9341` — *suppression définitive des segments de mini-boss*. L'avertissement du
prompt est exact : la règle « mini-boss tous les 20 étages » est morte. Voir §4.2
pour ce qu'il en reste dans le dépôt.

---

## 2. Étape 5 — Batterie de validation, résultats mesurés

Tous les outils ont été exécutés sur le HEAD, sans modification préalable.

| Outil | Résultat | Écart vs passation |
|---|---|---|
| compilation Lua (`lupa`, 668 fichiers) | **0 échec** | — |
| `tools/audit_bugs.py` | **16 signalements** | passation citait 12 → +4 |
| `tools/verify_legend.py` | tout vérifié | — |
| `tools/verify_scene_positions.py` | 411 scènes, 0 hors carte | — |
| `tools/verify_bg_format.py` | 0 bug de format | — |
| `tools/verify_zone_index.py` | 4 zones cohérentes | outil créé par `b526a68` |
| `tools/validate_all.py` | 9 salles valides | — |
| `tools/audit_integrite.py` | **878 anomalies** | passation citait 925 → −47 |
| `tools/count_dialogue.py` | voir §5 | — |
| `verify_new_era.sh` | ✅ 277 maps, 525 tilesets, 133 musiques | conforme à `0b3b3a6` |
| `tools/verify_emotions.py` | 0 risque de crash portrait | — |
| `tools/verify_cutscene_guard.py` | 0 scène à risque | — |
| `tools/verify_spawner_enabled.py` | 0 spawner désactivé | — |
| `tools/verify_lua_globals.py` | 0 fonction fantôme | — |
| `tools/verify_midpoint_template.py` | aucun habillage dupliqué | — |

**Sur les écarts chiffrés.** Le prompt demande de comprendre la divergence plutôt
que de supposer. Les 878 anomalies (contre 925) s'expliquent par le travail de
traduction et de nettoyage des commits du 08-01 ; les 16 signalements (contre 12)
sont directement imputables aux deux commits du 08-02 — `4e1d765` et `ee06be8` en
ont introduit une partie, détaillée ci-dessous. **Ce ne sont pas des repères
figés qui auraient dérivé : ce sont deux régressions réelles.**

### Outil cassé

```
tools/audit_cutscene_exit.py:2  →  MOD='/home/user/nea'; os.chdir(MOD)
FileNotFoundError: [Errno 2] No such file or directory: '/home/user/nea'
```

Chemin absolu codé en dur, hérité d'un autre poste. L'outil ne tourne nulle part
ailleurs que sur la machine où il a été écrit. Conforme à la règle « corriger ses
propres outils quand ils mentent » : à réparer (une ligne, `sys.argv[1]`).

---

## 3. Deux régressions introduites hier, avec preuve

### 3.1 `Goinfrex` n'existe pas dans `CharacterEssentials` — crash garanti

**Fichier :** `Data/Script/halcyon/ground/metano_cafe/init.lua`, lignes **702** et **832**
**Introduit par :** `4e1d765` (2026-08-02 00:12)
**Détecté par :** `tools/audit_integrite.py` § 2 « PERSONNAGE FANTOME »

```lua
-- ligne 702, scène 0 du cycle quotidien
local goinfrex = CharacterEssentials.MakeCharactersFromList({{'Goinfrex', 140, 160, Direction.Right}})
-- ligne 832, scène 6
local goinfrex = CharacterEssentials.MakeCharactersFromList({{'Goinfrex', 140, 160, Direction.Right}})
```

**Preuve de l'absence.** La table `local characters` de
`Data/Script/halcyon/CharacterEssentials.lua` contient 197 clés. `Goinfrex` n'en
fait pas partie :

```
Goinfrex False    Ludicolo True    Linoone True    Gulpin True    Shuckle True
```

**Preuve du comportement.** `MakeCharactersFromList` (ligne 1775) déréférence
`characters[name].species` sans garde. Simulation en Lua réel :

```
pcall(characters['Goinfrex'].species)
→ (False, "attempt to index a nil value (field '?')")
```

**Portée réelle.** L'appel est enveloppé — `pcall(function() metano_cafe.PlayDailyCutscene() end)`
à la ligne 80 — donc **pas de gel du jeu**, la règle « toute scène sous `pcall` » a
fait son office. Mais la conséquence reste sérieuse : `SV.metano_cafe.LastDailyCutsceneDay = day`
est écrit **ligne 691, avant** le bloc qui plante ligne 702. Le jour est donc marqué
comme consommé alors que la scène n'a jamais été jouée.

**Résultat pour le joueur :** 2 des 7 scènes quotidiennes du Café (indices 0 et 6,
soit **28 % du cycle**) ne s'afficheront jamais, et le joueur perdra silencieusement
sa cinématique ces jours-là. Aucun message d'erreur visible.

Trois correctifs possibles, par ordre de préférence :
1. ajouter l'entrée `Goinfrex` (espèce `munchlax`, attestée dans
   `ground/personality_test/init.lua:188`) à `CharacterEssentials` ;
2. remplacer par un personnage déjà déclaré ;
3. déplacer l'écriture de `LastDailyCutsceneDay` **après** la scène — correctif de
   robustesse à faire dans tous les cas, indépendamment du reste.

### 3.2 Quiz de Kirlia — le PNJ n'existe sur aucune carte

**Introduit par :** `ee06be8` (2026-08-02 00:23)
**Non détecté par les outils existants** — c'est un angle mort de la batterie.

Le commit ajoute 98 lignes de quiz et le routeur :

```lua
-- ground/metano_town/init.lua:3286
function metano_town.Kirlia_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  assert(pcall(load("metano_town_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Kirlia_Action(...,...)"), obj, activator))
end
```

**Preuve que le contenu est inatteignable.** Trois vérifications convergentes :

1. `Data/Ground/metano_town.rsground` contient 113 entités. Aucune ne s'appelle
   `Kirlia` (liste complète extraite et inspectée).
2. `grep -rl "Kirlia" Data/Ground/` → **aucun fichier**. Le PNJ n'est sur aucune
   carte du mod.
3. `CharacterEssentials` ne déclare ni `Kirlia`, ni `Ralts`, ni `Gardevoir` — le PNJ
   ne peut donc pas non plus être créé dynamiquement par
   `MakeCharactersFromList`.
4. `NPCRoutines.SetupChapter8Ground()` (`npc_routines.lua:274`) ne mentionne pas
   Kirlia, et `metano_town_ch_8.SetupGround()` ne fait aucun `Unhide` la concernant.

**Conclusion :** 98 lignes de contenu — un quiz à 3 questions avec scoring — sont
écrites, compilent, et sont **totalement injouables**. Il manque le placement de
l'entité dans le `.rsground`.

### 3.3 `SV.Chapter8.QuizScore` non déclaré

**Détecté par :** `tools/audit_bugs.py` § D — 5 occurrences
(`metano_town_ch_8.lua:1127, 1128, 1202, 1206, 1210`)

`SV.Chapter8` est bien déclaré (`scriptvars.lua:1205`) avec 21 champs, mais
`QuizScore` n'y figure pas. Une partie neuve arrive donc avec `nil`.

Le code teste `if SV.Chapter8.QuizScore ~= nil then`, donc le `nil` initial est
géré — le comportement au premier passage est correct. Mais la règle projet est
explicite et non négociable : *toute nouvelle table `SV` doit être déclarée dans
`scriptvars.lua` **et** rattrapée dans `OnUpgrade`*. Ici **ni l'un ni l'autre** :
aucune mention de `QuizScore` dans `services/debug_tools/init.lua`.

À noter que le même fichier `scriptvars.lua` documente précisément ce type
d'oubli pour un champ voisin :

> `CrystalSanctuaryComplete` — *« Il n'était déclaré NULLE PART : une partie neuve
> arrivait donc avec nil. »*

Le réflexe existe dans le projet ; il n'a pas été appliqué au commit d'hier.

---

## 4. État de santé structurel

### 4.1 Ce qui est sain

- **Compilation** : 668 fichiers Lua, zéro erreur de syntaxe.
- **Index de zones** : synchronisé après `b526a68`, validé par le nouvel outil.
- **Positions de scène** : 411 fichiers rattachés, aucune entité hors carte.
- **Portraits** : aucune émotion invalide — la leçon de `7715486`
  (`Shock` → `Surprised`) a été outillée en garde-fou permanent.
- **Gardes de cinématique** : 0 scène rendant la main avant d'armer le mode.
- **Intégrité globale** : ✅ 277 maps, 525 tilesets, 133 musiques.

### 4.2 Séquelles du retrait des mini-boss

Les commits `fc9e33c` et `19f9341` ont retiré les mini-boss. Il reste dans le dépôt :

- **3 ground maps orphelines** : `vast_steppe_miniboss`, `searing_tunnel_miniboss`,
  `mount_windswept_miniboss`. Elles sont encore listées dans les `GroundMaps` de
  leurs zones et dans `index.idx` (2 occurrences chacune), et `validate_all.py` les
  valide toujours — mais **aucun `EnterGroundMap` ne les cible plus** :

  ```
  grep -rn "EnterGroundMap([\"']vast_steppe_miniboss"   → aucun résultat
  grep -rn "EnterGroundMap([\"']searing_tunnel_miniboss" → aucun résultat
  grep -rn "EnterGroundMap([\"']mount_windswept_miniboss" → aucun résultat
  ```

  Ce sont donc des cartes mortes, mais **inoffensives** : leur présence dans
  `index.idx` est cohérente avec les JSON, et l'index est validé. Pas urgent.
  À trancher : nettoyage, ou réutilisation pour un autre usage.

- `tools/audit_fade_leaks.py` signale encore des fuites de fondu dans
  `vast_steppe_miniboss_ch_5.lua` (lignes 560/566) — code d'une carte devenue
  inatteignable. **Faux positif de fait**, à documenter comme tel plutôt qu'à
  corriger, conformément à la règle sur les faux positifs.

### 4.3 Les 878 anomalies d'intégrité, par nature

| § | Nature | Nb | Lecture |
|---|---|---:|---|
| 8 | Clé `.resx` orpheline | **746** | 85 % du total. Traductions écrites en avance ou dialogues retirés sans purge. Sans effet en jeu. |
| 7 | Scène de boss sans musique | 53 | À arbitrer scène par scène — le silence peut être un choix de mise en scène assumé. |
| 6 | Son unique (typo possible) | 36 | Risque réel type `DUN_Tumble` → à passer en revue. |
| 4 | Texte dupliqué consécutif | 28 | Répétitions à l'écran. |
| 5 | Instance inconnue (Hide/Unhide) | 12 | Appels sur des entités absentes. |
| 2 | Personnage fantôme | 2 | **Goinfrex** — §3.1. |
| 1 | Paramètre mort | 1 | `ChooseAmountMenu.lua`, `callback` jamais invoqué. |

Le § 8 étant du bruit sans impact, la charge réelle est de **132 anomalies**, dont
seules celles des § 2, 5 et 6 touchent le jeu.

### 4.4 Autres signalements de `audit_bugs.py`

- **`SV.guildmaster_summit.GameComplete`** lu dans 5 fichiers des namespaces
  `megastones` et `source_duns_imbi` — code hérité hors `halcyon`, non déclaré.
  À vérifier : ces namespaces sont-ils encore actifs ?
- **`colline_anciens`** : 3 objets sans handler (`Bedroom_Exit_Touch`,
  `Book_Action`, `Save_Point_Touch`) → **muets en jeu**. La carte a été convertie
  récemment (`5a5b4e4`, 08-01) et `e4055e7` documente déjà un problème d'import
  sur cette même carte. À relier.
- **MapStatus `"dream"` inconnu** (`colline_anciens/init.lua:92`) — même carte.
- **`testmap`** : 23 objets sans handler — carte de test, sans impact.
- **3 zones `Released=false`** : `imbion_coven_cave`, `imbion_haunted_bazar`,
  `imbion_sentient_workshop`.
- **91 avertissements** de `verify_ground_registration` : `RespawnAllies` sans
  spawner `TEAMMATE_1` (partenaire absent, erreur loguée non fatale).

---

## 5. Volumétrie narrative — l'objectif est loin

`tools/count_dialogue.py`, cible affichée par l'outil : **7000 boîtes par chapitre**
(et non 3000 comme l'indique la passation du 07-29 — le curseur a été relevé).

| Chapitre | Boîtes | Cible | Complétion |
|---|---:|---:|---:|
| ch1 | 644 | — | — |
| ch2 | 659 | — | — |
| ch3 | 659 | — | — |
| ch4 | 524 | — | — |
| ch5 | 1 740 | 7 000 | 25 % |
| **ch6** | **3 030** | 7 000 | **43 %** |
| **ch7** | **3 012** | 7 000 | **43 %** |
| ch8 | 354 | 7 000 | 5 % |
| ch9 | 318 | 7 000 | 5 % |
| ch10 | 256 | 7 000 | 4 % |
| ch11 | 19 | 7 000 | 0,3 % |

Multi-chapitres : 169. Commun : 2 101. **Total ≈ 13 500 boîtes.**

Lecture : `a267058` (08-01) annonçait « 3000+ lignes par chapitre » pour ch6 et ch7
— **c'est atteint et vérifié** (3030 et 3012). Mais la cible de l'outil étant à 7000,
ces deux chapitres sont à 43 %. Les chapitres 8 à 11 sont à l'état de squelette :
les blueprints existent (`478876d` pour le ch8, `e4de92e` pour le ch12), le contenu
jouable non. Le ch8 est particulièrement révélateur — un blueprint complet de
tournoi à 10 guildes, et 354 boîtes.

---

## 6. Étape 7 — Réponses aux questions de connaissance

**Quel est le dernier commit et que change-t-il ?**
`b526a68`, 2026-08-02 08:21 UTC. Il supprime une transition `EnterGroundMap`
imbriquée dans le callback `Enter` du relais Mont Windsep — le moteur était encore
dans `GroundMap.OnEnter` quand une nouvelle chaîne `SceneOutcome` était armée, d'où
le fondu noir bloquant. Il resynchronise `Data/Zone/index.idx` (désynchronisé par
`e8ca019`, `93a191d`, `19f9341`), ajoute un garde `pcall` restaurant `CutsceneMode`,
caméra et fondu, crée `tools/verify_zone_index.py`, et passe le build en
`2026-08-03-O`.

**Quels chantiers sont en cours d'après les commits récents ?**
Trois fronts, d'après les 08-01/08-02 :
1. *Stabilisation du ch5* — relais, écrans noirs, collisions, retrait des mini-boss.
   C'est le chantier qui consomme le plus de commits correctifs.
2. *Expansion ch6-ch7* — objectif 3000 lignes atteint, réunion Team Alakazam, Xatu
   à la Colline des Anciens, lore Rescue Team.
3. *Amorçage ch8-ch12* — blueprints écrits, implémentation à peine commencée. Les
   deux commits du 08-02 (Quiz Kirlia, Café) appartiennent à ce front, et **ce sont
   précisément eux qui ont introduit les deux régressions du §3**.

**Quels outils couvrent déjà le besoin ?**
`tools/` contient 74 scripts. Pour tout audit à venir, ce qui existe déjà :
positions de scène, émotions, gardes de cinématique, index de zones, spawners,
globales Lua, fuites de fondu, causalité narrative, format des fonds, template de
point médian, intégrité globale, comptage de dialogues. **Ne rien reconstruire
sans avoir vérifié cette liste.** Manque en revanche un vérificateur croisant
*handler Lua ↔ entité présente dans le `.rsground`* — c'est exactement l'angle mort
qui a laissé passer Kirlia (§3.2).

**Quelles règles ont été amendées ?**
- Mini-boss : supprimés (`fc9e33c`, `19f9341`). Seuls les boss finaux subsistent.
- La Voix : ne commente plus les boss (`d7ba1ec`) ; Tornadus porte sa scène avec son
  portrait (`6afffca`). Son usage se réduit — vérifier avant toute scène l'impliquant.
- Tag de build : série `2026-08-03-*`, prochain `P` — et non `2026-08-01-V`.
- Cible de dialogue : 7000/chapitre dans l'outil, pas 3000.

---

## 7. Ce que je propose, par ordre de priorité

Rien n'est appliqué. Ordre de traitement suggéré, du plus rentable au moins urgent.

| # | Action | Effort | Effet |
|---|---|---|---|
| 1 | Déclarer `Goinfrex` dans `CharacterEssentials` (espèce `munchlax`) | 8 lignes | Débloque 2 des 7 scènes du Café |
| 2 | Déplacer `LastDailyCutsceneDay = day` après la scène | 2 lignes | Plus de jour consommé à vide |
| 3 | Déclarer `SV.Chapter8.QuizScore` + rattrapage `OnUpgrade` | ~6 lignes | Conformité à la règle projet |
| 4 | Placer l'entité `Kirlia` dans `metano_town.rsground` | édition `.rsground` | Rend jouables 98 lignes déjà écrites |
| 5 | Réparer `tools/audit_cutscene_exit.py` (chemin en dur) | 1 ligne | Outil réutilisable |
| 6 | Écrire `verify_entity_handlers.py` (handler ↔ entité `.rsground`) | ~80 lignes | Ferme l'angle mort qui a laissé passer #4 |
| 7 | Traiter les 36 « sons uniques » et 12 « instances inconnues » | à évaluer | Anomalies à impact réel en jeu |
| 8 | Statuer sur les 3 grounds mini-boss orphelins | décision | Nettoyage ou réemploi |
| 9 | Purger les 746 clés `.resx` orphelines | scripté | Cosmétique, sans impact jeu |

Les points 1 à 3 sont des correctifs mécaniques, prouvés, sans risque de
régression. Le point 4 touche un `.rsground` : il exige un round-trip JSON validé
avant écriture, conformément à la règle. Le point 6 est le plus structurant à moyen
terme — c'est ce qui évitera qu'un futur commit réintroduise le même défaut.

**Aucun de ces points n'est testé manette en main.** Le sandbox ne lance pas le jeu ;
seule une vérification humaine peut confirmer.

---

## 8. Ce dont j'ai besoin pour continuer

1. **Le token GitHub**, sans lequel je ne peux ni commiter ni pousser.
2. **Ton arbitrage sur l'ordre** ci-dessus — je pars sur 1→3 en premier lot
   (correctifs prouvés, incrément de build `2026-08-03-P`), sauf indication contraire.
3. **Une décision sur Kirlia** : placer l'entité dans le `.rsground`, ou différer le
   quiz jusqu'à la vraie implémentation du tournoi du ch8 ?
