# Bibliothèque de référence — ressources techniques de la communauté PMD

Build : `2026-07-31-Y` · Analyse du 2026-07-28

Inventaire **exhaustif** des 6 dépôts demandés, avec pour chaque ressource :
ce qu'elle fait, comment elle fonctionne, et **si elle apporte une valeur
réelle à New Era** — ou pourquoi elle n'en apporte pas.

Méthode : clonage intégral (1,1 Go), exploration récursive, analyse des JSON
et des scripts Lua, **comparaison systématique avec l'existant New Era**
avant toute conclusion. Aucune ressource n'a été importée sans vérifier
qu'elle comblait un manque réel.

---

## 0. Tableau de bord

| dépôt | moteur | Items | Status | MapStatus | Zones | Particules | verdict |
|---|---|---|---|---|---|---|---|
| **pmd-red** | C/ASM GBA | — | — | — | — | — | référence de **structure**, non transposable telle quelle |
| **ExplorersOfSkyOrigins** | PMDO | 85 | 1 | 2 | 5 | 18 | mine de **techniques de mise en scène** |
| **ProjectEoN** | PMDO | 17 | 1 | **6** | 13 | 3 | **MapStatus visuels + IA d'escorte** |
| **ZMDO** | PMDO | 847 | 4 | 0 | 4 | 0 | 827 objets = mécanique propre à Zorua, **non pertinent** |
| **minior-game-jam** | PMDO | 0 | 0 | 1 | 16 | 1 | 1 MapStatus intéressant |
| **Mega_Stones** | PMDO | **48** | 1 | 0 | 1 | 0 | **manque critique comblé** |

New Era pour comparaison : 181 → **229** objets, 3 Status, 6 MapStatus,
208 zones, 3 particules.

---

## 1. LE TROU CRITIQUE TROUVÉ ET COMBLÉ — Mega Stones

### Le bug

New Era embarquait **tout le système Méga-Évolution** — scripts
(`Data/Script/megastones/`), boutique (`shady_shop`), zone, `scriptvars`,
traductions en 11 langues — mais **aucune des 48 pierres**.

Vérifié : `shady_shop/init.lua` référence 48 identifiants `mega_*`, et
`Data/Item/` n'en contenait **zéro**. La boutique vendait des objets
inexistants. C'est le manque le plus grave que cette analyse a révélé.

### Ce qui a été importé

| ressource | détail |
|---|---|
| **48 objets** `mega_*.json` | version alignée `0.8.11.0` → `0.8.9.0`, BOM UTF-8, `Released=true` |
| **`Data/Item/index.idx`** | 48 entrées ajoutées (181 → **229**), résumés d'origine conservés |
| **`Content/Item/MegaStone.dir`** + `MegaStoneDelta.dir` | sprites des gemmes |
| **`Content/Sound/Battle/Mega_Evolution.ogg`** | son de transformation |

### Adaptation à New Era (pas une copie)

- **Noms francisés** : les 48 portent leur nom FR officiel (Blizzarite,
  Ptéranite, Dracaufite X/Y, Lockpinite, Ténéfixite…). Le jeu est en
  français ; la source était en anglais uniquement.
- **Description réécrite**, pas traduite : « Une des mystérieuses
  Méga-Gemmes. Une fois par étage, elle libère la forme cachée de son
  porteur. » — formulation neutre, compatible avec le lore New Era, qui ne
  nomme aucune espèce et n'évoque aucun élément d'un autre projet.
- `Released=true` (la source les laissait à `false`).
- **Scripts inchangés** : `diff` confirme que `event_battle.lua` de New Era
  est déjà identique à la source. Les 48 objets s'y branchent sans aucune
  adaptation — `CancelIfWrongMon` / `CancelIfMegaEvent` / `Mega_Evolve`.

### Vérifications

- Les **48 références de la boutique résolvent** désormais.
- `index.idx` ↔ fichiers : **229/229**, aucun orphelin des deux côtés.
- BOM UTF-8 présent sur les 48.
- Assets moteur référencés (`Circle_Small_Purple_In`, `Light_Ball_Purple`,
  `Lightning`, `Mega_Background_Red`, `Fog_2`) : **non fournis par la
  source non plus** → ce sont des assets PMDO de base.

> **Retombée importante** : ceci lève le doute que j'avais signalé au lot
> précédent sur `Fog_2`. Un mod tiers publié et fonctionnel l'utilise sans
> l'embarquer → c'est bien un asset du moteur. `Heat_Wave`, `Silver_Wind` et
> `Cosmic_Power` relèvent très probablement du même cas.

---

## 2. RESSOURCES RETENUES POUR INTÉGRATION FUTURE (non appliquées)

Documentées ici pour pouvoir être posées proprement quand le besoin narratif
existera. Je ne les ai **pas** importées : ajouter une ressource sans usage
scénaristique produit du contenu mort.

### 2.1 MapStatus visuels — ProjectEoN (6) + minior (1)

Le patron est simple et **entièrement transposable** :

```
MapStatusData
  └─ Emitter : OverlayEmitter
       ├─ Anim : { AnimIndex, FrameTime, Alpha }   ← Alpha = force du voile
       ├─ Movement : { X, Y }                      ← défilement (pluie, nuages)
       └─ Layer                                    ← 4 = par-dessus le décor
  └─ RepeatMethod : MapStatusRefreshEvent          ← rejoue à chaque étage
```

| statut | source | intérêt pour New Era |
|---|---|---|
| `cutscene_rain` / `non_colliding_rain` | EoN | **pluie de cinématique** — manque réel : nos scènes de tempête n'ont que des overlays ponctuels |
| `clouds_overhead` | EoN | nuages défilants, utile au Pic Céleste |
| `fog` | EoN | brouillard avec compte à rebours (`MapStatusCountDownEvent`) |
| `sunset` | EoN | voile chaud, `White` avec Alpha bas |
| `blood_moon` | minior | **`Red_Tint` Alpha 50** — exactement l'outil pour une nuit anormale |

New Era possède déjà `blowing_wind`, `darkness`, `dusk`, `steam`,
`mysterious_distortion` : le manque porte donc sur **pluie** et **teinte
colorée**.

### 2.2 IA — ProjectEoN (3)

| IA | plans | pourquoi c'est utile |
|---|---|---|
| **`escortee`** | `FollowLeaderPlan` → `AvoidFoesPlan` → `Explore` → `Wait` → `AttackFoes(-6)` | **manque avéré** : New Era génère des missions d'escorte (`mission_gen.lua` l.2169) mais n'a pas d'IA d'escorté. L'escorté utilise donc une IA inadaptée qui fonce sur les ennemis au lieu de les fuir. |
| `stick_together` | `PrepareWithLeaderPlan` en tête | groupe soudé, IQ 413 |
| `wander_normal` | déjà présent nativement | — |

**Recommandation** : importer `escortee` quand les missions d'escorte seront
testées. C'est un correctif de gameplay, pas un ajout cosmétique.

### 2.3 Techniques de mise en scène — EoSO

Déjà exploitées dans les lots précédents, consignées ici pour mémoire :

- `CharacterActions.lua` — `ShakeHead`, `ScaredJump`, `HopOnce/Twice`,
  `LookAround`, **`DizzyFade`** (transposé en `VoiceVisions.DizzyVeil`),
  `Explain`.
- `storm_cutscene_a` — flash d'orage, bascule de fin en coroutines calées.
- `beach/init.lua` — établir le lieu avant les personnages.
- `chapter_card` — carton-titre en coroutines parallèles.
- **`missiongen_lib`** (4488 lignes contre 3085 chez nous) : générateur de
  missions plus complet, avec menus dédiés et un **mode devcheck** de
  1622 lignes. À étudier si le job board doit être étendu — mais notre
  `mission_gen.lua` est déjà fonctionnel et intégré au lore.

### 2.4 Particules disponibles

| source | particules | note |
|---|---|---|
| EoSO | 18 (`AuraParticle` 32×32/16 fr., 11 bulles de plage, `BeachSparkle`) | **spécifiques à la plage** — peu réutilisables hors de ce décor |
| EoN | `Confuse` (32×32/4), `Razor_Leaf_Charge_Dark` (96×96/27) | `Confuse` générique et propre |
| minior | `Dragon_Ascent_Explosion` (104×104/7) | belle explosion, réutilisable pour un boss volant |

**Formats vérifiés** avec `tools/verify_bg_format.py` : tous conformes à la
structure `[PNG][16 octets : frameW, frameH, 0, frameCount]`. Aucune surprise
de dimension.

Fait notable : **`Black.dir` existe chez EoSO** (645×645, 1 frame) — c'est le
fond que `VoiceVisions.DizzyVeil` utilise et que j'avais signalé comme non
attesté. Confirmation qu'il s'agit d'un asset moteur standard.

---

## 3. RESSOURCES ÉCARTÉES — et pourquoi

Conserver **uniquement ce qui apporte une valeur réelle** faisait partie de
la consigne. Voici ce que j'ai délibérément laissé de côté.

| ressource | volume | raison du rejet |
|---|---|---|
| **ZMDO `sketch_*`** | **827 objets** | Mécanique propre à Zorua : chaque objet est un « croquis » enseignant une capacité (`TMEvent` + `MoveLearnEvent`). C'est un système de CT déguisé, sans rapport avec la progression de New Era. Les importer noierait le sac du joueur. |
| pièges pmd-red (20) | — | **New Era les a déjà tous**, et davantage (30 relevés dans les zones : `trap_toxic_spikes`, `trap_stealth_rock`, `trap_grudge`… absents de Rouge). Fournis nativement par PMDO. |
| `FIXED_ROOM_*` pmd-red | ~40 | Salles fixes de légendaires. New Era a **déjà 42 arènes** avec sa propre géométrie et son casting. Reprendre les leurs contredirait le scénario. |
| EoSO `Data/Item` | 85 | 39 `held_*`, 16 `bow_*`, 13 `orb_*`, 11 `seed_*` — **tous déjà présents** dans les 181 objets de New Era. |
| EoN `mission_lost_*` / `mission_stolen_*` | 6 | **Déjà présents** et déjà câblés dans notre `mission_gen.lua` (l.1261-1268). |
| villages, hubs, portraits, sprites, dialogues, scénarios | — | Explicitement hors périmètre. |
| ZMDO `Status` (`dancing`, `transform`…) | 4 | Liés aux mécaniques Zorua (`RegularAttackNeededEvent`). Sans usage dans New Era. |
| Génération de donjon scriptée | — | EoSO : **0** `FLOOR_GEN_SCRIPT`. EoN : 1. ZMDO : 1 (`Test`). **New Era est plus avancé** avec `SpawnChapter5*`, `SpawnChapter6Chenipent`, `NewEraMystery`. Rien à prendre. |

---

## 4. Ce que l'analyse confirme sur New Era

Point encourageant, mesuré et non supposé : sur les systèmes de fond
(génération de donjon, pièges, objets, structure des zones), **New Era est
déjà au niveau ou au-dessus** des cinq mods PMDO analysés. Les seuls vrais
manques identifiés étaient :

1. **les 48 Mega Stones** → comblé dans ce lot ;
2. **l'IA `escortee`** → documenté, à poser avec les missions d'escorte ;
3. **les MapStatus de pluie / teinte** → documentés, à poser avec une scène
   qui les justifie.

---

## Validation

Lua **645/645** · `.resx` **576/576** · Items JSON **229/229** (BOM vérifié
sur les 48 nouveaux) · `index.idx` ↔ fichiers **229/229 sans orphelin** ·
`verify_legend`, `verify_scene_positions`, `verify_bg_format` au vert.

Note : `Data/Item/machine_recall_box.json` n'a pas de BOM — fichier
**préexistant** au commit de base `45c445a`, hors périmètre de ce lot, non
modifié.

## Non testé

**Rien n'est testé en jeu.** En particulier :

- La Méga-Évolution en combat (transformation `Form 1` / `Form 2`) dépend de
  la présence des **formes méga dans les sprites du moteur**. Si une espèce
  n'a pas de forme 1, `Transform` échouera pour cette pierre-là.
- L'affichage du sprite `MegaStone` (icône 9, catégorie 13).
- La boutique `shady_shop` n'a jamais pu être testée avant, faute d'objets.
