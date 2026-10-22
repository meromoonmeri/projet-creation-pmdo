# Capacités natives de PMDO — assimilation et exploitation

Build : `2026-07-31-Z` · Étude du 2026-07-28

Analyse de **PMDODump** (documentation officielle du moteur) et du
**dungeon-pack** de DoubleTrio, avec un objectif : savoir exactement ce que
le moteur sait faire, pour ne jamais réinventer ce qui existe déjà.

---

## 1. PMDODump — la documentation officielle du moteur

### Ce que le dépôt contient réellement

| dossier | contenu | exploitable ? |
|---|---|---|
| **`DataAsset/Docs/`** | **13 fichiers, 4842 lignes de doc API officielle** | **oui, c'est la mine** |
| `DataAsset/{Item,Monster,Zone,String}` | données de référence du jeu de base | comparatif |
| `Scripts/` | outils Python (`itemGen`, `monsterGen`, `localization`) | outillage |
| `PMDC/` | sous-module **vide** dans le clone | — |
| `RawAsset/`, `DumpAsset/` | **vides** (les assets sont dans les *releases*, pas le dépôt) | — |

Les 13 documents couvrent : `Script`, `DataManager`, `MonsterData`,
`BattleContext`, `ItemData`, `BattleData`, `Character`, `StatusData`,
`TileData`, `SkillData`, `MapStatusData`, `GroundChar`, `IntrinsicData`.

### L'audit qui compte : que New Era exploite-t-il déjà ?

J'ai extrait les **255 fonctions d'API** documentées et les ai croisées avec
tout le code de New Era.

| namespace | fonctions documentées |
|---|---|
| `GAME:` | 101 |
| `UI:` | 71 |
| `GROUND:` | 45 |
| `SOUND:` | 18 |
| `DUNGEON:` | 13 |
| `TASK:` | 8 |
| `STRINGS:` | 5 |
| `AI:` | 4 |

**Résultat : New Era utilise déjà 202 des 255 fonctions (79 %).** Le moteur
est globalement bien exploité — ce n'était pas acquis d'avance.

Restaient **62 fonctions inutilisées**. La plupart sont sans intérêt ici
(`GAME:RestartRogue`, `GAME:SetupLuaFunctions`, `UI:_DummyWait`…), mais
**cinq changent réellement la qualité d'une cinématique** — et aucune
n'était employée dans les **186 fichiers de scène** du mod.

---

## 2. Ce qui a été implémenté — `EngineKit.lua`

Module qui met ces capacités natives à disposition derrière une API courte,
documentée, et protégée par `pcall` (si une API manque sur une version de
moteur plus ancienne, la scène continue au lieu de planter).

### 2.1 `UI:SetSpeakerReverse` — le face-à-face

**Le défaut le plus visible de nos scènes** : dans un dialogue à deux, les
deux portraits regardent du même côté. Les interlocuteurs ne se font jamais
face.

Convention retenue pour New Era :
- **héros et alliés** → portrait retourné, ils regardent vers la gauche ;
- **PNJ et boss** → portrait à l'endroit.

**Appliqué immédiatement** aux 4 modules de scènes globaux — `DazzlingArc`,
`ChapterAftermath`, `LegendArc`, `VeilleurArc` — soit **toutes les scènes
d'après-boss du jeu**, sans toucher une seule ligne de dialogue : le helper
`say()` détecte l'allié et retourne le portrait tout seul.

### 2.2 `GAME:MoveCameraToChara` — caméra qui suit un acteur

Nos scènes utilisent `MoveCamera(x, y)` en coordonnées **absolues** : chaque
cadrage se recalcule à la main et devient faux dès que l'acteur bouge. C'est
d'ailleurs la source des erreurs de position corrigées aux lots précédents.

`EngineKit.CamOn(chara, dx, dy, durée)` centre sur le personnage.
`EngineKit.CamBetween(a, b)` cadre entre deux acteurs, décalé de 16 px vers
le haut pour laisser la place à la boîte de dialogue.

### 2.3 `SOUND:WaitFanfare` — le moment solennel

Coupe la musique le temps du son, la reprend seule, et **attend la durée
exacte**. Remplace le trio `FadeOutBGM` + `PlayBattleSE` + `WaitFrames(durée
devinée)` qu'on écrivait à la main. Repli automatique si le son n'existe pas.

### 2.4 `UI:SetBounds` / `UI:ResetBounds` — boîte déplaçable

Quand celui qui parle est en bas de l'écran, la boîte standard le recouvre.
`EngineKit.SayTop()` la remonte le temps de la réplique puis restaure.

### 2.5 `UI:SetSpeakTime` — cadence de frappe

Un réglage, un effet de ton immédiat : `grave` (14) pour un aveu, `normal`
(6), `vif` (3) pour une panique. `EngineKit.SetTone('grave')`.

**Bonus** : `DUNGEON:DungeonCurrentFloor` et `DUNGEON:DungeonAssetName`
permettent à un script de savoir où il se joue sans qu'on le lui passe en
argument — utile pour un dialogue qui réagit à la profondeur atteinte.

---

## 3. Dungeon Pack — bibliothèque de conception

245 Mo, 47 scripts Lua, 28 102 lignes. Trois donjons (Wishmaker Cave,
Terrasphere, Adventurer's Peak).

### Ce qui est remarquable

| système | volume | idée de conception |
|---|---|---|
| **Enchantements** | 5492 lignes | Modificateurs de règles choisis **avant** l'expédition, façon roguelite. Hooks `on_checkpoint`, `on_checkpoint_exit`. |
| **Checkpoints** | 804 lignes | Boutique **générée aléatoirement** à chaque palier, coffre, choix « continuer / rentrer ». |
| **Quêtes** | 1391 lignes | Objectifs internes au donjon, indépendants du job board. |
| **Table de vœux** | 2400 lignes (5 paliers) | Récompense à paliers de rareté. |
| **`ShimmeringZoneStep`** | — | **La meilleure technique du pack** (voir ci-dessous). |

### `ShimmeringZoneStep` — l'aléa d'étage visible

75 % de chance, à chaque étage, d'appliquer **une règle globale tirée au
sort** : précision parfaite, coups critiques boostés, immunité aux statuts,
protection contre les baisses de stats…

Le mécanisme, entièrement natif :

```
ActiveEffect()                                  ← conteneur de règles
  ├─ OnActions:Add(PMDC.Dungeon.SureShotEvent())
  ├─ BeforeStatusAdds:Add(StateStatusCheck(...))
  └─ OnMapStarts:Add(SingleCharScriptEvent("LogShimmeringEvent"))
DefaultMapStatusStep(MapGenContext)             ← pose le MapStatus visuel
MapEffectStep(MapGenContext)                    ← injecte l'ActiveEffect
queue:Enqueue(Priority(-6), ...)
```

**New Era maîtrise déjà `ActiveEffect` + `MapEffectStep`** (`dungeon_life.lua`
— marchand itinérant, danseurs, zone secrète). La brique qui nous manque est
`DefaultMapStatusStep`, qui **pose un MapStatus par génération** : c'est ce
qui rend l'effet *visible* au lieu d'être une règle invisible.

### `ScreenRainEmitter` — l'émetteur natif de pluie

Trouvaille technique du pack. Structure exacte relevée :

```json
{ "$type": "RogueEssence.Content.ScreenRainEmitter",
  "Anim":       { "AnimIndex": "...", "StartFrame": 0, "EndFrame": 3 },
  "ResultAnim": { "AnimIndex": "...", "StartFrame": 4, "EndFrame": 6 },
  "Layer": 4, "ParticlesPerBurst": 1, "BurstTime": 20,
  "HeightSpeed": -100, "SpeedDiff": 50 }
```

`Anim` = la particule qui tombe, `ResultAnim` = l'impact au sol. C'est
**exactement** la brique qui manquait pour la pluie et la neige signalées
au lot précédent. Documenté ici, à poser quand une scène le justifiera.

---

## 4. Ce qui a été délibérément écarté

| ressource | motif |
|---|---|
| Système d'enchantements (5492 l.) | Excellent, mais **roguelite** : choisir ses modificateurs avant l'expédition contredit la progression narrative de New Era. |
| Table de vœux | Liée à Wishmaker Cave et à son économie propre. |
| Donjons du pack | Consigne explicite : ne jamais reproduire un donjon. Ce sont les **techniques** qui sont retenues. |
| `beholder.lua` | Bibliothèque d'événements tierce. New Era a déjà ses propres hooks ; ajouter une couche d'indirection compliquerait le débogage. |
| Menus custom (5 fichiers) | New Era a déjà `Data/Script/halcyon/menu`. |

---

## 5. Conclusion de l'étude

Le moteur PMDO **supporte nativement** tout ce que ces deux dépôts font :
aucune de leurs fonctionnalités ne dépend d'un fork ou d'un patch. Tout est
donc transposable dans New Era, à condition d'en avoir l'usage.

Trois constats mesurés :

1. **New Era exploite déjà 79 % de l'API du moteur** et maîtrise les
   systèmes avancés (`ActiveEffect`, `MapEffectStep`, `ScriptGenStep`,
   `MobSpawnInteractable`, `SpreadStepRangeZoneStep`).
2. Le vrai manque n'était pas technique mais **ergonomique** : cinq API de
   confort jamais utilisées, dont le face-à-face des dialogues — corrigé
   dans ce lot, sur toutes les scènes d'après-boss.
3. Les briques encore à poser sont identifiées et documentées :
   `DefaultMapStatusStep`, `ScreenRainEmitter`, et l'IA `escortee` du lot
   précédent.

## Validation

Lua **646/646** · `.resx` **576/576** · zones + index **208/208** ·
items **229/229 sans orphelin** · `verify_legend`, `verify_scene_positions`,
`verify_bg_format` au vert.

Les 8 fonctions employées par `EngineKit` ont été **vérifiées présentes dans
la documentation officielle** avant usage.

## Non testé

**Rien n'est testé en jeu.** En particulier, le rendu du face-à-face dépend
de la présence des portraits retournés côté moteur ; si `SetSpeakerReverse`
n'a pas d'effet sur une version donnée, le `pcall` garantit que la scène se
déroule normalement, simplement sans le retournement.
