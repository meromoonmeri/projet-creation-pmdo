# La Voix et les Visions du héros — build 2026-07-31-M

## La demande

> « Comme dans PMD Rescue Team, le héros parle à cette voix et **il est le seul
> à pouvoir l'entendre** depuis le début de l'aventure. À chaque fois que cette
> voix lui parle, il doit avoir une nausée (les mêmes animations que quand le
> héros a des visions du passé ou du futur dans Sky). Les scènes flashback des
> anciens jeux — Team Alakazam qui pourchasse l'ancien héros, la météorite
> détruite par Rayquaza, Dialga qui parle au héros avant leur duel à Temporal
> Tower — tout ça doit être des visions du passé du héros de New Era, pour
> qu'il comprenne les événements du lore. »

Deux choses distinctes, traitées séparément :

1. **La Voix** — elle existait déjà (37 occurrences dès le chapitre 1), mais
   elle parlait « à la cantonade », sans effet physique et sans que rien ne
   marque que le héros est le seul à l'entendre.
2. **Les visions** — elles n'existaient pas du tout.

---

## 1. La Voix : le héros seul, et ça lui coûte

### `Data/Script/halcyon/VoiceVisions.lua`

Nouveau module. `VoiceVisions.Speak{...}` orchestre la séquence en 4 temps :

1. **Le monde se fige** — la musique est coupée net.
2. **Le haut-le-cœur** — l'écran *tangue* (`ScreenMover`, amplitude faible mais
   longue : c'est un vertige, pas un séisme), le héros passe en animation
   `Hurt` avec l'emote `shock`, un voile sombre couvre l'écran.
3. **La Voix parle** — speaker anonyme `\uE040`, sans nom, sans portrait.
4. **Le monde revient** — et **le témoin n'a rien entendu**. Il a seulement vu
   son ami s'arrêter net et blêmir.

Le point 4 est le cœur du dispositif : le paramètre `witness` fait réagir le
partenaire à la **pâleur** du héros, jamais à ce qui a été dit.

Trois intensités de nausée (`level` 1 à 3), de la gêne passagère à
l'effondrement.

### Appliqué rétroactivement à tout l'existant

Plutôt que d'éditer 20 fichiers, la nausée a été ajoutée aux **deux points de
passage** par lesquels la Voix transite déjà :

| Point de passage | Portée |
|---|---|
| `BossFX.Voice()` | toutes les scènes de boss du mod |
| `SuaireArc.voice()` | les 5 actes de l'arc 2 |

Un patch dans chacun, et **toutes les prises de parole existantes** de la Voix
provoquent désormais le malaise — y compris celles écrites il y a des semaines.

---

## 2. Les visions du passé

### `Data/Script/halcyon/HeroVisions.lua`

Cinq visions, une par grand moment du lore des jeux officiels, rejouées comme
des **échos que le héros ne comprend pas**.

| # | Vision | Ch. | Écho de | Musique | Fonds |
|---|---|---|---|---|---|
| 1 | **La Chasse** | 3 | un héros accusé, traqué par une équipe d'élite | `Team Skull` | `Wanted_Poster`, `Chapter_3`, `Dream_Back` |
| 2 | **La Météore** | 5 | un dragon du ciel brise la pierre qui tombe | `Sky Tower` | `Chapter_2`, `Dream_Front`, `Genesis_Fade` |
| 3 | **Le Rouage** | 7 | les mécanismes du temps arrêtés, un monde figé | `Time Gear Remix` | `Genesis_Cores`, `Dusknoir` |
| 4 | **Le Sommet** | 9 | le duel au faîte d'une tour qui s'effondre | `Temporal Tower` | `Chapter_4`, `Dusknoir`, `Genesis_Void` |
| 5 | **L'Effacement** | 10 | celui qui a tout sauvé disparaît, oublié de tous | `Goodnight` | `Dream_Front`, `Genesis_Fade`, `Genesis_Void` |

Format repris des visions de *Ciel* : **voix off** (`WaitShowVoiceOver`), pas de
boîte de dialogue, pas de speaker — on ne peut pas attribuer la parole à des
personnages que le héros ne connaît pas.

### La règle d'or : reconnaître sans nommer

**Aucun nom propre des jeux d'origine n'est prononcé.** Ni Dialga, ni Rayquaza,
ni Alakazam, ni Grovyle. Le joueur *reconnaît*, le héros *non*. C'est ce qui
rend les visions troublantes plutôt qu'explicatives.

Exemples :

> « Ils sont quatre à le poursuivre. Des secouristes. Les meilleurs de leur
> temps. Ils ne le haïssent pas. Ils croient sincèrement bien faire.
> **C'est pire.** »

> « Au sommet, quelque chose les attend. Un gardien. Bleu. Énorme. Fou de
> douleur. « Vous êtes venus achever ce que vous avez commencé. » **Il se
> trompe. Il ne le saura jamais.** »

> « Il s'efface. Et avec lui s'efface le souvenir qu'il ait jamais existé.
> Le monde continue, heureux, sauvé, **et personne ne sait par qui.** »

Chaque vision se referme sur une pensée du héros qui la relie à *sa* situation :

> « (Il a tout donné. Et le monde ne se souvient même pas de son nom.
> ...Est-ce que ça m'attend, moi aussi ?) »

### Où elles se déclenchent

| Vision | Emplacement |
|---|---|
| Chasse | réveil du ch3 (`guild_heros_room_ch_3.FirstMorning`) |
| Météore | veillée post-expédition ch5 |
| Rouage | ch7, **juste après** le rêve existant — deux fragments la même nuit |
| Sommet | veillée ch9 |
| Effacement | veillée finale ch10 |

Sauf la première (au réveil, pour surprendre), toutes surviennent **pendant le
sommeil**, après que le partenaire s'est endormi : il ne peut rien voir.

---

## Choix technique : texte littéral

`HeroVisions` est appelé depuis **plusieurs grounds différents**. Or
`STRINGS.MapStrings` ne contient que les clés du ground courant : une clé
définie dans un seul `strings.resx` serait **introuvable** ailleurs.

Le module écrit donc son texte en clair, comme le fait déjà `SuaireArc.lua`
(module global lui aussi). `VoiceVisions` gère les deux modes via un
résolveur `resolve()` et le drapeau `literal`.

---

## Vérifications

- Lua **640/640** (+2 modules), `.resx` 576/576, zones 209/209
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- **10 fonds** et **5 musiques** référencés : tous présents dans `Content/`
- **35 chaînes affichables** analysées : **0 nom interdit**
  (`Dusknoir` n'apparaît que comme *nom de fichier image*, jamais à l'écran)
- Simulation : verrou de chapitre correct (ch1 → rien, ch3 → chasse, …),
  chaque vision jouée **une seule fois**, vision inconnue → `false` sans crash

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier :

- Les **fonds sont détournés** : `Wanted_Poster`, `Dusknoir`, `Chapter_2/3/4`
  et les `Genesis_*` n'ont pas été dessinés pour ces scènes. Le rendu peut
  être incohérent avec le texte. Ce sont les seuls fonds disponibles dans le
  dépôt — des planches dédiées seraient nettement mieux.
- `ScreenMover` et `MoveScreen` sont utilisés d'après `BossFX.ShakeScreen`
  (patron existant), mais l'effet « tangage » n'a pas été observé à l'écran.
- L'animation `Hurt` est supposée disponible pour toutes les espèces jouables
  en contexte *ground* — non vérifié. Tout est sous `pcall`, donc un échec
  dégrade la scène sans bloquer le joueur.

## Piste pour la suite

Les visions couvrent Rouge/Bleu et Ciel. Rien n'empêche d'en ajouter :
la table `HeroVisions.LIST` est déclarative — une entrée = une vision.

---

# Addendum — relecture des dépôts sources (build 2026-07-31-N)

## La question posée

> « Tu as pu voir des cinématiques équivalentes dans ces dépôts pour reproduire
> et l'adapter à New Era dans PMDO ? »

**Réponse honnête : non, pas pour la première version.** Les visions du build
`-M` ont été écrites de mémoire, sur le patron interne `genesis_vision`. Les
dépôts ont été relus **après** cette question. Ils ont apporté trois techniques
concrètes qui manquaient.

## Fichiers réellement ouverts

| Dépôt | Fichier | Ce qu'il apporte |
|---|---|---|
| ExplorersOfSkyOrigins | `Data/Script/eos/ground/storm_cutscene_a/init.lua` | la vision d'ouverture de Ciel, en Lua PMDO |
| ExplorersOfSkyOrigins | `Data/Script/eos/ground/chapter_card/init.lua` | carton-titre en coroutines parallèles |
| ExplorersOfSkyOrigins | `Data/Script/eos/ground/guild_bedroom_night/init.lua` | scène de chambre + script GBA en commentaire |
| pret/pmd-red | `data/scripts/` (`intro.inc`, `title.inc`) | structure des cinématiques d'ouverture |

EoSO est un remake de Ciel **dans le même moteur que nous** : son code est
directement transposable, contrairement à l'assembleur de `pmd-red`.

## Les trois techniques reprises

### 1. Le flash d'orage — remplace le voile coloré

`storm_cutscene_a` ne pose **aucun** `FlashEmitter`. Il enchaîne :

```lua
SOUND:PlaySE("Battle/EVT_CH01_Thunder")
GAME:FadeOut(true, 2)   -- true = fade le DÉCOR, garde l'interface
GAME:WaitFrames(4)
GAME:FadeIn(2)
GAME:WaitFrames(4)
```

…deux fois de suite, avec un son par éclair. Le `true` est la clé : il produit
le stroboscope caractéristique de Ciel. C'est plus net et plus lisible que le
voile violet que j'avais écrit.

Extrait en primitive : `VoiceVisions.Lightning(times, se)`, utilisée à
l'entrée des visions (3 éclairs) et à chaque prise de parole de la Voix (2).

### 2. La bascule de fin en trois coroutines synchronisées

Pour sortir d'une vision, EoSO lance **en parallèle** un fondu d'image, une
réplique calée sur la *même durée*, et un fondu du son — puis les joint :

```lua
local coro1 = TASK:BranchCoroutine(function() GAME:FadeOutFront(true, 120) end)
local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(..., 120) end)
local coro3 = TASK:BranchCoroutine(function() SOUND:FadeOutSE(..., 120) end)
TASK:JoinCoroutines({coro1, coro2, coro3})
```

Résultat : **la phrase s'efface exactement avec l'image**. C'est la signature
visuelle des visions de Sky, et je ne l'avais pas.

Ajouté via le champ `lastWord` — une phrase-écho par vision :

| Vision | Dernière phrase |
|---|---|
| La Chasse | « ...Ils ne m'ont jamais laissé m'expliquer. » |
| La Météore | « ...Il a payé pour nous, et nous ne savons même pas son nom. » |
| Le Rouage | « ...Le temps ne s'est pas arrêté. Il a été retenu. » |
| Le Sommet | « ...Pardonnez-nous. Nous n'avions pas d'autre chemin. » |
| L'Effacement | « ...Merci. Pour tout. Vraiment. » |

### 3. Le speaker inconnu posé une seule fois

EoSO appelle `ExplorerEssentials.SetSpeakerUnknown(nil)` **une fois** en tête de
scène, plutôt que de répéter le `SetSpeaker` à chaque ligne. Notre `\uE040`
produit le même effet ; il est désormais posé une seule fois par séquence.

## Ce que j'ai délibérément **pas** copié

- **`Data/Script/eos/…`** — l'arborescence d'EoSO est un mod complet séparé.
  Importer ses fichiers créerait un conflit de namespace avec `halcyon`.
- **Les sons `EVT_CH01_Thunder`** — ils appartiennent au contenu d'EoSO, absent
  de notre dépôt. J'utilise `EVT_Battle_Flash` et `EVT_Battle_Transition`, déjà
  employés ailleurs dans New Era.
- **Le texte anglais d'origine** — les visions restent des créations New Era en
  français. On reprend la *grammaire visuelle*, pas les dialogues.

## Vérifications après relecture

- Lua **640/640**, `.resx` 576/576, zones 209/209, `verify_legend` 0 échec
- **40 chaînes affichées** dans `HeroVisions` : **0 nom interdit**
- Les SE utilisés (`EVT_Battle_Flash`, `EVT_Battle_Transition`) sont déjà
  appelés ailleurs dans le mod — donc fournis par le moteur

## Ce qui reste non vérifié

**Toujours rien testé en jeu.** Le flash d'orage et la bascule en trois
coroutines sont transposés d'un code qui tourne (EoSO), mais leur rendu dans
*notre* contexte — cartes, timings, musiques — n'a pas été observé.

---

# Addendum 2 — audit du format PMDO (build 2026-07-31-O)

## La question

> « Vérifie qu'il n'y a aucun bug visuel avec le format, les dimensions de
> PMDO, quand tu calques les cinématiques de PMD Red Rescue Team. »

**Un vrai bug a été trouvé et corrigé.**

## Le piège : la taille du PNG n'est pas la taille de la frame

Les fonds de `Content/BG/*.dir` sont des **planches** (spritesheets), pas des
images fixes. Leur structure, retro-analysée et vérifiée sur les 16 fichiers :

```
[ PNG complet ][ 16 octets : frameW, frameH, 0, frameCount  (uint32 LE) ]
```

Exemple : `Dream_Back.dir` contient un PNG de **1536×1920**, mais ses frames
font **192×240** — 63 frames de 8 colonnes × 8 lignes.

Le viewport PMDO fait **320×240**. Un fond dont la frame n'est pas 320×240
laisse des bandes ou se retrouve étiré.

## Le bug

J'avais choisi `Dream_Back` et `Dream_Front` **sur leur nom** (« Dream » →
rêve), sans vérifier leurs dimensions. Leurs frames font **192×240** : plus
étroites que l'écran.

Trois planches étaient concernées :

| Vision | Planche | Avant | Après |
|---|---|---|---|
| La Chasse | le fugitif qui court | `Dream_Back` 192×240 | `Genesis_Fade` 320×240 |
| La Météore | l'impact | `Dream_Front` 192×240 | `Genesis_Void` 320×240 |
| L'Effacement | la plage au lever du jour | `Dream_Front` 192×240 | `Genesis_Life` 320×240 |

Les remplaçants ne sont pas choisis au hasard : `Genesis_Fade` (8 frames, fondu
progressif) rend la fuite qui s'efface, `Genesis_Void` (12 frames) le choc,
`Genesis_Life` (16 frames) le monde vivant qui continue.

## Inventaire complet des fonds

| Fond | Planche | Frame | Frames | Plein écran |
|---|---|---|---|---|
| `Chapter_1..4` | 320×240 | **320×240** | 1 | oui |
| `Dusknoir` | 320×240 | **320×240** | 1 | oui |
| `Wanted_Poster` | 320×240 | **320×240** | 1 | oui |
| `Title_Screen_Background` | 320×240 | **320×240** | 1 | oui |
| `Genesis_Fade` | 960×720 | **320×240** | 8 | oui |
| `Genesis_Cores` | 1280×720 | **320×240** | 12 | oui |
| `Genesis_Void` | 1280×720 | **320×240** | 12 | oui |
| `Genesis_Life` | 1280×960 | **320×240** | 16 | oui |
| `Genesis_Mew` | 1280×960 | **320×240** | 16 | oui |
| `Dream_Back` | 1536×1920 | 192×240 | 63 | **NON** |
| `Dream_Front` | 1536×1920 | 192×240 | 63 | **NON** |
| `SE5_Wind_Background` | 5120×256 | 256×256 | 20 | **NON** (bandeau défilant) |
| `Steam` | 128×128 | 128×128 | 1 | **NON** (tuile) |

## Nouvel outil : `tools/verify_bg_format.py`

Pour que ce bug ne puisse plus revenir, un vérificateur automatique :

- lit la taille de frame réelle de chaque `.dir` ;
- croise avec **tous** les fonds référencés dans les scripts
  (`bg='...'` et `WaitShowBG("...")`), commentaires exclus ;
- échoue si un fond utilisé n'est pas en 320×240, ou s'il n'existe pas.

```
$ python3 tools/verify_bg_format.py .
10 fond(s) utilisé(s) par les scripts, tous en frame 320x240.
RESULTAT : AUCUN BUG DE FORMAT
```

## Deux autres points vérifiés

**Les sprites par-dessus le fond.** EoSO fait `GROUND:Hide("PLAYER")` en tête
de scène, parce que ses cinématiques ont leur propre carte. Nos visions se
jouent sur la carte courante : sans précaution, le duo resterait visible
au-dessus du fond plein écran. Le `FadeOut(false, 40)` posé avant les planches
noircit tout l'écran et règle le problème — c'est désormais commenté comme
**indispensable**, pour qu'on ne le retire pas par inadvertance.

**La longueur des répliques.** Une boîte PMDO tient ~3 lignes de ~38 caractères,
soit ~150 caractères hors balises `[pause=N]`. Les 40 répliques ont été
mesurées : la plus longue fait **105 caractères**. **0 dépassement.**

## Ce qui reste non vérifié

Le cadrage est maintenant correct *par construction*, mais **le rendu n'a
toujours pas été observé en jeu**. En particulier, les fonds `Genesis_*` sont
**animés** (8 à 16 frames) : leur vitesse de défilement face aux `hold` demandés
(180 à 230 frames) n'a pas été validée à l'écran. Si l'animation boucle trop
vite, il faudra ajuster les `hold`.
