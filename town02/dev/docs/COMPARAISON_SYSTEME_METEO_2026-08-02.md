# Système météo : ce que j'ai fait vs. le brief « portage Black & White »

Date : 2026-08-02 — branche `new-era-1-9`
Question posée : lequel des deux vaut mieux ?

Réponse courte : **le brief vise juste sur les objectifs, mais se trompe de
dépôt de référence et suppose une capacité technique que le mod n'a pas.**
Ce que j'ai livré couvre déjà une partie de ses attendus. Le reste est
atteignable — mais pas par la voie décrite.

---

## 1. Le dépôt de référence n'est pas le bon

Le brief demande d'analyser `openblack/bw1-decomp` en le présentant comme
« Pokémon Black & White ». Vérifié par l'API GitHub :

| Champ | Valeur réelle |
|---|---|
| Description | **« Decompilation of Black & White 1 »** |
| Organisation | openblack — « Open source implementation of **Black & White (2001)** » |
| Langages | C++, C, Assembly, Pascal |
| Fichiers météo | `Weather.cpp`, `WeatherRain.cpp`, `ClimateRainInfo.cpp`, `LHInetWeather.cpp`, `Terrain.cpp` |

C'est **Black & White de Lionhead Studios (2001)**, le jeu de dieu sur PC — pas
*Pokémon Version Noire et Blanche* (DS, 2010). Le préfixe `LH` = Lionhead.

Conséquence : ce dépôt contient un système météo **3D temps réel** couplé à un
terrain height-map, avec climat par région et synchronisation réseau. Rien n'y
est transposable à un moteur 2D en tuiles. Le référentiel pertinent pour un
rendu « Explorateurs du Ciel » reste ce que nous utilisons déjà : EoSO et
PMDODump.

Je le signale sans détour parce qu'un audit fondé sur ce dépôt aurait produit
des conclusions inapplicables — et j'aurais pu passer des heures dessus avant
de m'en apercevoir.

## 2. La contrainte que le brief ne prend pas en compte

`Mod.xml` de New Era :

```xml
<ModType>Quest</ModType>
<Namespace>halcyon</Namespace>
<GameVersion>0.8.12</GameVersion>
```

Et **zéro fichier `.cs`, `.dll` ou `.csproj`** dans tout le dépôt (vérifié sur
les 4 233 chemins de l'arbre Git).

Un mod de type Quest fournit des **données** (JSON) et des **scripts Lua**. Il
ne compile pas de C#. Or le brief demande :

> « Optimise le système […] grâce à un système de **pooling** et en évitant
> les allocations inutiles. »

Le pooling de particules se fait dans la boucle de rendu, en C#, côté moteur.
**Ce n'est pas accessible depuis un mod Quest.** Demander ce point à ce niveau
n'est pas réalisable sans forker RogueEssence — ce qui change complètement la
nature du projet et casserait la compatibilité avec les mises à jour du moteur.

Bonne nouvelle, cependant : **le pooling est déjà fait par le moteur.**

## 3. Ce que le moteur fournit déjà — et que le brief propose de réécrire

`RogueCollab/RogueEssence` (branche `master`) contient **23 émetteurs**
dans `RogueEssence/Content/Animation/Emitters/` :

```
AfterImage, Area, Between, Clamp, Expandable, Flash, Fountain, Gather,
List, MoveTo, Overlay, Release, Repeat, ScreenRain, Single, Spin,
Sprinkle, SqueezedArea, Stream, SwingSwitch, Vortex, Wind
```

### `ScreenRainEmitter` — code source lu

```csharp
public AnimData Anim;          // l'animation de la particule
public AnimData ResultAnim;    // l'animation d'impact au sol
public DrawLayer Layer;
public int ParticlesPerBurst;  // densité
public int BurstTime;          // fréquence des salves
public int HeightSpeed;        // vitesse de chute (pixels/sec)
public int SpeedDiff;          // dérive horizontale = DIRECTION DU VENT
```

Les paramètres demandés par le brief — **intensité** (`ParticlesPerBurst`),
**vitesse** (`HeightSpeed`), **direction du vent** (`SpeedDiff`), **densité**
(`BurstTime`) — existent déjà et sont exposés dans le JSON du MapStatus.

Le `Update()` recycle les animations dans `scene.Anims[Layer]` : la gestion
mémoire est celle du moteur, pas la nôtre.

### `FiniteOverlayEmitter` — code source lu

```csharp
public BGAnimData Anim;   // texture plein écran
public Loc Movement;      // défilement (pixels/sec)
public bool RepeatX, RepeatY;
public int FadeIn, FadeOut, TotalTime;   // TRANSITIONS
public Color Color;                       // COULEUR et LUMINOSITÉ
public DrawLayer Layer;
```

Voilà **couleur, luminosité, transitions et défilement** — quatre autres
attendus du brief, déjà natifs.

Et il est **déjà piloté depuis Lua** dans le projet : `BossFX.Overlay()`
(`BossFX.lua`), utilisé 8 fois. La brume, la teinte d'orage et l'assombrissement
passent par là.

## 4. Ce que j'ai livré, mesuré contre le brief

`Data/MapStatus/falling_rain.json` + entrée dans `index.idx`.

| Attendu du brief | État |
|---|---|
| Pluie | **fait** — `falling_rain`, paramètres canoniques du moteur |
| Intensité, vitesse, densité, direction du vent | **exposés** par `ScreenRainEmitter` |
| Activable depuis Grounds / cinématiques | **fait** — `GROUND:AddMapStatus("falling_rain")` |
| 60 FPS, pooling | **assuré par le moteur**, hors de portée d'un mod Quest |
| Style Explorateurs | **respecté** — même famille que `winter_snow`, pas d'effet de combat |
| Pluie légère / forte / orage / blizzard / brouillard / sable / vent | **non fait** |
| Son, transitions par météo | **non fait** |

Donc : environ la moitié des attendus, sur une seule météo. Le brief voit plus
large, et il a raison de le faire.

## 5. Ce qui est réellement faisable, et comment

Toute la partie « modulaire, 9 météos configurables » est atteignable **sans
une ligne de C#**, en combinant trois briques déjà présentes :

| Météo | Recette |
|---|---|
| Pluie légère | `ScreenRainEmitter`, `ParticlesPerBurst 1`, `BurstTime 6` |
| Pluie | `falling_rain` actuel (2 / 3 frames) |
| Forte pluie | `ParticlesPerBurst 4`, `BurstTime 2`, `SpeedDiff 180` + overlay sombre |
| Orage | forte pluie + `BossFX.Flash` rythmé + `SOUND:PlaySE` |
| Neige | `winter_snow` (existe) |
| Blizzard | `winter_snow` + `SpeedDiff` élevé + overlay blanc défilant |
| Brouillard | `FiniteOverlayEmitter` seul, texture grise, `Movement` lent |
| Tempête de sable | `falling_ash` (existe) + teinte ocre via `Color` |
| Vent | `blowing_wind` / `blowing_wind_fast` (existent) |

**Six des neuf météos réutilisent des MapStatus déjà présents dans le projet.**

L'orage est le seul cas qui demande du Lua : un module qui alterne éclair,
délai, tonnerre. C'est exactement le type de chose que `BossFX` fait déjà.

### La vraie limite, elle est graphique

`Content/Particle/` du projet ne contient que 4 animations : `Snow_Fall`,
`Ash_Fall`, `Sakura_Fall`, `Leaf_Fall`. L'animation `Rain` que j'ai référencée
vient du **moteur** (le jeu de base l'utilise dans son MapStatus `rain`) — je
l'ai vérifié dans `MapStatusInfo.cs`, mais **je ne l'ai pas vue à l'écran**.

`Content/BG/` contient 22 textures, dont aucune de brume ou de nappe de pluie
générique (`Steam.dir` et `SE5_Wind_Background.dir` sont les plus proches).

Le brouillard et le blizzard demanderont donc **de vrais assets graphiques**,
pas du code. C'est là qu'est le travail, pas dans le système.

## 6. Verdict

**Ni l'un ni l'autre en l'état — mais pas à parts égales.**

Le brief a raison sur l'ambition : un système modulaire à 9 météos est le bon
objectif, et mon `falling_rain` isolé est trop étroit.

Mais il se trompe sur trois points, et chacun coûterait cher :

1. **Le dépôt** — Black & White de Lionhead n'a aucun rapport avec Pokémon ni
   avec un moteur 2D en tuiles.
2. **Le pooling** — inaccessible depuis un mod Quest, et déjà assuré par le
   moteur. L'exiger conduirait soit à forker RogueEssence, soit à écrire un
   faux système qui n'optimise rien.
3. **« Créer une implémentation originale »** — réécrire ce que le moteur
   fournit déjà (23 émetteurs) serait une régression : plus de code à
   maintenir, moins de performance, et une rupture à chaque mise à jour.

**La bonne approche** : garder l'ambition du brief (9 météos, configurables,
activables partout), et l'implémenter comme une **couche de configuration Lua**
au-dessus des émetteurs existants — un module `Weather.lua` exposant
`Weather.Set("orage", {intensite=3, vent=180})`, qui pose le bon MapStatus,
règle l'overlay et déclenche les sons. Zéro C#, zéro réécriture moteur.

Et budgéter séparément les **assets graphiques** manquants (brume, sable), qui
sont le seul vrai obstacle.

## Réserve

Je n'ai pas lu les 1 709 fichiers de `bw1-decomp` : l'identification du jeu
(description du dépôt, organisation, noms de fichiers `LH*`, langages) suffit à
établir qu'il ne s'agit pas de Pokémon. Si vous pensiez à un autre dépôt —
une décompilation de *Pokémon Noir/Blanc* — donnez-le moi et je l'analyse.

Et `falling_rain` n'a pas été vu à l'écran.
