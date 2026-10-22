# Application du plan — Cinématique du campement du Mont Windsep

**Build `2026-08-03-H`** · Le plan fourni est archivé tel quel dans
`docs/PLAN_cinematique_campement_windsep.md`. **Rien n'a été testé en jeu.**

Référence technique relue avant écriture : PMDOTutorial v0.6, Lesson 6 —
`Data/Script/tutorial/ground/large_lake/init.lua` (patron `CutsceneMode` →
`MoveCamera` → `FadeIn` → dialogue → `PlayBGM` sur l'événement).

---

## Décisions prises avec toi avant d'écrire

| Question | Réponse retenue |
|---|---|
| Qui s'endort pendant la discussion intime ? | **Le partenaire du héros** (Teammate1). Kino reste un membre distinct de la Guilde, il dort de son côté pour le gag de Philéas. |
| Gag Galon vs débat « Pomme Parfaite » | **Les deux coexistent** : gag Galon à l'annonce du dîner, débat pendant le repas. |
| Fin de l'Acte 4 | **La scène finale devant la porte est conservée**, puis dispersion → reprise de contrôle. |

---

## Acte 1 — le défaut structurel corrigé

Le plan exige : *« tous les membres sont déjà présents ; personne n'arrive de
l'extérieur après le héros ; c'est son arrivée qui déclenche le rassemblement. »*

Le code faisait **l'inverse** : Kino et Reinier étaient créés puis `GROUND:Hide`,
et remontaient le sentier **après** le duo (ancienne section 1 de `CampNightfall`,
93 lignes). Le déclencheur du rassemblement était donc une arrivée extérieure de plus.

| Beat | Ce qui a été fait |
|---|---|
| 1.0 | Kino (356,318) et Reinier (376,290) présents dès la 1ʳᵉ frame, 34 px l'un de l'autre, 85 px du membre le plus proche — « à l'écart » mesuré |
| 1.1 | Boucle `dubBusy` : leur discussion tourne en fond pendant toute la montée (Reinier expose, Kino hoche, Kino s'anime) |
| 1.3 | Ils remarquent le héros **les derniers** ; Kino d'abord, Reinier 20 frames après — et Reinier regarde d'abord **Kino** (« pourquoi tu ne m'écoutes plus ? ») avant de suivre son regard |
| 1.4 | Convergence réelle vers (326,326) et (328,288), trajets vérifiés marchables, ≥40 px de tous |
| 1.5 | Deux répliques propres : `MWE5_179` (Kino l'enthousiaste), `MWE5_180` (Reinier le méticuleux) |
| — | L'ancienne section 1 de `CampNightfall` est supprimée ; `MWE5_021`/`022` (« vous voilà enfin ! ») retirées des deux .resx |

**Correction transverse** : Hyko et Almotz étaient muets et immobiles pendant les
six accueils (3 beats). C'est `tools/audit_causalite.py` qui l'a signalé. Ils
écoutent désormais chaque locuteur (variable `ecoutants`).

---

## Acte 2 — le silence, qui était le vrai sujet

Le plan est catégorique : *« Après le début du repas, TOUTE MUSIQUE DISPARAÎT
[…] Lorsque Plum surgit, AUCUNE OST ne doit jouer avant son arrivée. »*

**Le contraste n'existait pas** : `PlayBGM('Guildmaster Wigglytuff.ogg')` démarrait
dès le débat de la Pomme Parfaite. La « reprise » censée ponctuer la chute de Plum
retombait sur un morceau **déjà en train de jouer**.

- Ce `PlayBGM` est remplacé par un SE court (`EVT_Emote_Exclaim_Surprised`) : ça
  ponctue sans occuper l'espace sonore.
- Le silence avant l'irruption passe de 70 à **110 frames** (~2 s d'ambiance de feu seule).
- Vérifié : le **premier** `PlayBGM` de l'acte est maintenant celui de la chute.

**Gag Galon (beat 1.8)** implémenté sur l'annonce réelle du repas par Coco
(`MWE5_G01`) : cascade de 11 têtes décalées de 4 frames → **50 frames de silence
total** → Galon craque (`MWE5_G02`), Coco enfonce (`MWE5_G03`), pensée du héros
(`MWE5_G04`).

---

## Acte 3 — ordre des beats inversé

Le plan place la discussion intime en **3.2**, *avant* les histoires (3.6). Le code
faisait l'inverse. Les deux blocs ont été permutés (`8bis` = intime, `8ter` = histoires).

Sans cette permutation, l'endormissement du partenaire n'interrompait plus rien et
la scène se terminait sur le moment calme au lieu du gag de Kino.

**Beats 3.3-3.5 écrits** : la phrase se délite (`[speed=0.4]`), la tête dodeline
(`LookAround` à 10 frames), il bascule en `EventSleep`. Le héros **ne dit rien** :
il se tourne, marque 28 frames, goutte de sueur — *puis seulement* une pensée.

**Piège évité** : j'avais écrit `BossFX.Particle("Sleep_Z", …)`. Vérification faite,
`Content/Particle` ne contient que `Ash_Fall`, `Emote_Eating`, `Leaf_Fall`,
`Sakura_Fall`, `Slugma_Materialize(_Reverse)`, `Snow_Fall`. `BossFX.Particle` échoue
**en silence** sur un nom absent — l'effet aurait été cru joué. Appel retiré, et
`BossFX` n'était de toute façon pas `require` dans ce fichier.

---

## Acte 4 — dispersion et reprise de contrôle

- **Texte de transition adapté** : `MWE5_052` passe de « Le lendemain matin... » à
  *« Après une soirée inoubliable tous ensemble... le lendemain matin. »* — le plan
  interdit le texte générique recopié.
- **Beat 4.7** : les quatre PNJ rejoignent, par déplacement visible, **exactement**
  le poste que `SetupGround` leur donnera. Avant, ils restaient plantés où la scène
  finale les avait laissés — Penticus barrait l'axe de montée.
- **Beat 4.10** : l'échange Shuca/Galon (`MWE5_E01`..`E04`) est déclenché par
  `Dungeon_Entrance_Touch`, une seule fois (`SV.Chapter5.MountDoorTalkDone`).

**Écart assumé et justifié** : le plan les décrit « pré-placés à l'entrée ». C'est
techniquement impossible — `SetParty` les met dans l'**équipe du joueur**
(`AddPlayerTeam`), le moteur les fait donc suivre le héros. Les y téléporter
produirait deux sprites qui glissent vers le joueur dès la 1ʳᵉ frame. L'intention
est rendue autrement : ils accompagnent le héros, et l'échange se joue à la porte.

---

## Règle de narration appliquée partout

*« Aucune boîte de narration omnisciente ; elle n'accompagne QUE un fondu. »*

| Clé | Avant | Après |
|---|---|---|
| `MWE5_023` | boîte centrée en plein repas | **supprimée** → Coco annonce le repas |
| `MWE5_158` | boîte centrée | pensée attribuée (`HeroDialogue`) |
| `MWE5_155/156/157` | boîtes centrées | pensées attribuées |
| `MWE5_085/086` | boîtes centrées | pensées attribuées |
| `MWE5_196` | boîte centrée | pensée attribuée |
| `MWE5_072/073` | après le `FadeIn` | **avant** — le texte prépare l'image |

Il ne reste que **3** boîtes centrées, toutes légitimes : `MWE5_072/073` et
`MWE5_051` (narration sur fondu) et `MWE5_070` (« Ouais !!! », cri choral que
personne ne peut porter seul).

`MWE5_072` disait « douze paillasses » alors qu'il y en a 11 ou 12 selon la
présence de Plum → reformulé sans compte.

---

## Outil amélioré

`tools/audit_causalite.py` — deux corrections issues de faux positifs réels :
1. accepte la numérotation à deux niveaux (`1.3.`) ;
2. résout les listes d'auditeurs passées **par variable**
   (`local ecoutants = {...}` puis `SaysA(x, e, k, ecoutants)`). Sans ça, un groupe
   qui écoute via une variable passait pour absent — c'est ce qui masquait, puis
   sur-signalait, Hyko et Almotz.

---

## Baselines

| Contrôle | Avant | Après |
|---|---|---|
| `audit_bugs.py` | 12 | **12** |
| `audit_integrite.py` | 850 | **849** |
| `count_dialogue.py` ch5 | 1619 | 1612 |
| Compilation Lua | 670 / 0 err | **670 / 0 err** |
| `audit_causalite` sur cette carte | 2 | **0** |

Baisse de ch5 : suppression de `MWE5_021/022/023` et de répliques d'arrivée
devenues contradictoires. Clés ajoutées (`MWE5_179/180`, `G01`-`G04`, `D01/D02`,
`E01`-`E04`) présentes en **FR et EN**. XML des deux .resx validé.

Verts : `verify_scene_positions`, `verify_lua_globals`, `verify_cutscene_guard`,
`verify_spawner_enabled`, `verify_legend`.

---

## Non traité dans ce lot

La **section 3 du document** (refonte du rêve de Gardevoir) est un brief distinct,
qui demande une décision de ta part : le document lui-même signale deux directions
artistiques contradictoires (Option A « Ground riche » vs Option B « parallax
Rescue Team », marquée retenue). L'Option B implique de réutiliser **à l'identique**
le parallax et la musique du test de personnalité — à confirmer avant que je touche
à `hero_dream`.
