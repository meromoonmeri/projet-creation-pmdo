# Audit — Cinématique de la Genèse de la Mythologie Pokémon

Build : `2026-08-01-B` · Audit du 2026-07-28

---

## Fiche d'identité

| | |
|---|---|
| **Nom** | La Genèse — récit de Phileas |
| **Fichier** | `ground/genesis_vision/genesis_vision_ch_7.lua` |
| **Chapitre** | 7 (après la découverte de la corruption dans les Aegis Cave) |
| **Déclencheur** | Phileas, 3ᵉ étage de la guilde |
| **Rôle narratif** | **Le récit fondateur du jeu.** Explique d'où vient la vie, ce que sont les Cœurs des Anima, et pourquoi leur extinction est une catastrophe. Tout l'arc 7-32 en découle. |
| **Format** | 5 actes, 5 planches animées plein écran, 19 lignes de voix off |
| **Importance mythologique** | **Maximale** — c'est la scène équivalente au récit de la Tour Temporelle |

---

## Verdict de l'audit : **la scène ne jouait presque rien**

Quatre bugs bloquants, dont trois invisibles à la relecture du texte.

### Bug 1 — `camFn` et `spriteFn` jamais appelés · GRAVITÉ CRITIQUE

**Emplacement** : `ShowAct`, lignes 17-38 de l'ancienne version.

La fonction recevait deux callbacks — les mouvements de caméra et
l'animation des personnages — et **ne les invoquait nulle part dans son
corps**. Vérifié par script : `camFn(` → 0 occurrence, `spriteFn(` → 0.

**Conséquences** :
- **aucun mouvement de caméra de toute la cinématique** — les travellings,
  zooms et dézooms écrits pour les 5 actes ne s'exécutaient jamais ;
- **Mew n'apparaissait pas.** L'acte 2, l'entrée de la première vie dans le
  vide, se jouait sur une image fixe et trois lignes de texte ;
- les 9 silhouettes de l'acte 3 ne se montraient pas ;
- Mew ne s'éloignait pas à l'acte 4.

**Cause probable** : refactorisation en helper laissée à mi-chemin — la
signature a été écrite, le corps jamais complété.

### Bug 2 — aucune musique · GRAVITÉ CRITIQUE

Pas un seul `SOUND:PlayBGM` dans les 183 lignes. **Quatre minutes de récit
mythologique en silence complet.** Un seul `SOUND:` dans tout le fichier, et
c'était un `StopBGM`.

Or la consigne de référence est explicite : *importance des musiques,
montée émotionnelle*. Une scène de cette portée sans bande-son ne peut pas
fonctionner.

### Bug 3 — 9 espèces inexistantes · GRAVITÉ CRITIQUE

L'acte 3 instanciait `Bulbizarre`, `Salameche`, `Carapuce`, `Germignon`,
`Hericendre`, `Kaiminus`, `Vipelierre`, `Gruikui`, `Metamorph`.

**Aucune de ces neuf clés n'existe dans `CharacterEssentials`.**
`MakeCharactersFromList` indexe `characters[name].species` — sur `nil`, c'est
une erreur Lua qui aurait coupé la cinématique en plein milieu.

### Bug 4 — sprites sous un fond plein écran · GRAVITÉ MAJEURE

`UI:WaitShowBG` dessine la planche **par-dessus la carte**. Les sprites posés
sur le sol sont donc **invisibles** — Mew et les silhouettes n'auraient rien
donné même si les bugs 1 et 3 avaient été corrigés.

Cette leçon était **déjà documentée** dans `VoiceVisions.lua` (« sans lui,
les sprites resteraient visibles PAR-DESSUS le fond plein écran ») ; elle
n'avait pas été appliquée ici.

### Bug 5 — dernière phrase dupliquée · GRAVITÉ MOYENNE

`GENV_018` et `GENV_019` contenaient **le même texte** : « Ce qui soutient la
vie… peut aussi être vidé. » La phrase était dite, puis un silence de 2,5 s,
puis **la même phrase à nouveau**. L'effet recherché — le silence, *puis* la
révélation — était détruit.

**Corrigé** : `GENV_018` ferme désormais le récit (« Et c'est là que s'arrête
l'histoire qu'on m'a racontée. La suite, personne ne l'a écrite. »), et
`GENV_019` garde la phrase-choc, seule après le silence.

---

## Ce qui a été refait

### Principe directeur

**Une image plein écran ne se partage pas.** Plutôt que de s'obstiner à poser
des sprites invisibles par-dessus les planches, la scène fait vivre les
planches elles-mêmes et laisse le **rythme** et le **silence** porter
l'émotion — exactement ce que fait Explorateurs du Ciel dans ses récits
mythologiques.

Les outils qui fonctionnent réellement par-dessus un fond plein écran :
durée d'affichage, fondus, voix off, silences mesurés, overlays plein écran
(`DrawLayer.Top`), tremblement d'écran, musique et sons.

### Partition dramatique des 5 actes

| acte | registre | mise en scène |
|---|---|---|
| **1. Le vide** | vertige | Presque immobile. **Aucune musique.** Un seul son, après 4 s de rien. Silences longs (70/60/80 frames). Le joueur ressent l'absence avant qu'on lui parle de création. |
| **2. La première vie** | émerveillement | **La musique entre ici** — c'est la vie qui amène le son dans le monde. Deux pulsations lumineuses plein écran sur « elle a dansé ». |
| **3. La multitude** | foisonnement | **Le tempo s'accélère** : silences raccourcis (45→40), et 7 éclats dont l'intervalle décroît de 90 à 26 frames. La vie se répand plus vite qu'on ne la raconte. |
| **4. Les Cœurs** | gravité | Une secousse d'écran, un son cristallin, puis **la musique se retire** sur 240 frames. Ce n'est plus un émerveillement, c'est une décision aux conséquences durables. |
| **5. Le présent** | inquiétude | **Aucun effet, aucune musique.** Le silence *est* l'effet. 150 frames de rien — assez pour croire la scène finie — puis la phrase finale tombe seule. |

### Robustesse

Tout le corps est sous `pcall`, avec **sortie garantie hors du bloc** : une
cinématique qui échoue ne doit jamais laisser le joueur sur un écran noir
sans issue. Le `FadeOut` initial noircit l'écran **avant** la première
planche, pour que la carte et les sprites du duo ne transparaissent pas.

---

## Validation finale

| critère | état |
|---|---|
| Qualité proche des meilleures scènes de Ciel | **atteint** — partition en 5 registres, silences dramatiques calibrés |
| Vraie mise en scène cinématographique | **atteint** — le rythme est écrit, pas subi |
| Utilise correctement PMDO | **atteint** — `WaitShowBG`, `WaitShowVoiceOver`, `BranchCoroutine`, overlays `DrawLayer.Top` |
| Fluide | **atteint** — effets parallélisés en coroutine, pas de blocage |
| Techniquement propre | **atteint** — 0 appel mort, 19/19 clés résolues EN+FR, 0 clé orpheline |
| Dimensions cohérentes | **atteint** — les 5 fonds vérifiés à 320×240 (viewport exact) |
| Effets impressionnants | **atteint** — flashs, secousse, éclats en cascade accélérée |
| La caméra valorise chaque moment | **contourné volontairement** — sur une planche plein écran, la caméra n'a pas d'objet ; c'est le montage qui fait le travail |
| Émotion et impact narratif | **atteint** — voir la partition ci-dessus |

### Contrôles automatiques

- Lua **646/646** · `.resx` **576/576** · zones + index **208/208**
- **19/19 clés `GENV_*`** présentes en EN et FR, **aucune orpheline**
- Musique `Temporal Tower.ogg` et les 3 sons employés : **tous attestés**
  ailleurs dans le dépôt
- Les 5 fonds `Genesis_*` : **320×240 confirmés**, 8 à 16 frames
- `verify_bg_format`, `verify_legend`, `verify_scene_positions`,
  `validate_all` : au vert

---

## Correctif annexe — ma dette du lot précédent

J'avais signalé qu'« un tileset mal apparié donne des murs incohérents ».
Vérification faite, le problème était réel mais ailleurs — **28 incohérences**
introduites par le clonage du squelette de `gloomy_forest` :

| bug | volume | correction |
|---|---|---|
| `LoadBlobStep` posait des décors de **forêt** (`relic_forest_blob_pillar`, `_fallen_left`, `_ruins`…) au Pic Céleste, dans les Ruines, au Sanctuaire et au Marais | **14 étages** | étape retirée — ce sont les seuls blobs attestés du dépôt ; mieux vaut aucun décor qu'un tronc couché en plein ciel |
| `MapEffectStep` déclenchait **`RelicForestTutorial`** — le tutoriel de la Forêt Relique — à l'entrée de chaque étage des 4 donjons d'histoire | **14 étages** | étape retirée (bug fonctionnel, pas cosmétique) |

Les **triplets de tilesets**, eux, étaient corrects : `western_cave_1`,
`crystal_cave_1`, `murky_cave` et `sky_tower` sont chacun attestés en
sol+mur+eau cohérents (17 à 47 usages chacun dans le dépôt).

Vérifié après correction : **aucun résidu** `relic_forest` / `treeshroud` /
`RelicForest` dans les 4 zones, et les étapes essentielles de génération
(grille, dessin, tuiles, escaliers, texture) toutes présentes.

---

## Non testé

**Rien n'est testé en jeu.** Points non vérifiables par script :

- Le **rythme réel** de la partition. Les durées (760/940/1120/940/680
  frames) et les silences sont calculés pour laisser chaque flipbook tourner
  au moins une fois en entier, mais seul un test à l'écran dira si les
  respirations tombent juste.
- Le comportement exact de `WaitShowBG` avec un `hold` long : s'il bloque au
  lieu de rendre la main, la narration se jouerait après l'image plutôt que
  pendant. Le cas échéant, la correction est d'inverser — narration dans la
  coroutine, image dans le fil principal.
- L'enchaînement des cinq fondus entre actes.
