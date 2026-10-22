# Grammaire des cinématiques — analyse des sources et application à New Era

Build `2026-07-31-P`

---

## 1. Le diagnostic, avant toute création

Avant d'écrire quoi que ce soit, j'ai mesuré la densité narrative réelle de
chaque chapitre (nombre de boîtes de dialogue, commentaires exclus) :

| Chapitre | Boîtes | Fichiers de scène |
|---|---|---|
| 1 | 633 | 13 |
| 2 | 577 | 18 |
| 3 | 573 | 20 |
| 4 | 442 | 19 |
| 5 | **1229** | 25 |
| 6 | 105 | 5 |
| 7 | 115 | 5 |
| 8 | **71** | 2 |
| 9 | **52** | 2 |
| 10 | **53** | 2 |

**Le déséquilibre est d'un facteur 10 à 20.** Les chapitres 8, 9 et 10 n'ont
que deux fichiers chacun : la chambre et la ville. Ni entrée de donjon
scénarisée, ni relais, ni arène mise en scène — alors que **les grounds
existent tous** (`crystal_sanctuary_entrance`, `forgotten_marsh_relay`,
`celestial_peak_entrance`…), avec un `init.lua` réduit à `GAME:FadeIn(20)`.

C'est là, et seulement là, que le besoin était prouvé. Le reste de ce document
part de ce constat.

---

## 2. Ce que j'ai analysé dans les sources

### Fichiers réellement ouverts

| Dépôt | Fichier | Ce qu'il enseigne |
|---|---|---|
| ExplorersOfSkyOrigins | `ground/beach/init.lua` | arrivée sur un lieu, malaise du héros, sortie synchronisée |
| ExplorersOfSkyOrigins | `ground/storm_cutscene_a/init.lua` | vision, éclairs stroboscopiques, bascule en coroutines |
| ExplorersOfSkyOrigins | `ground/chapter_card/init.lua` | carton-titre, aiguillage de progression |
| ExplorersOfSkyOrigins | `ground/guild_bedroom_night/init.lua` | veillée, script GBA conservé en commentaire |
| ExplorersOfSkyOrigins | `CharacterActions.lua` | `DizzyFade`, `ShakeHead`, `ScaredJump`, `Explain` |
| pret/pmd-red | `data/scripts/` | structure des cinématiques d'ouverture |

EoS Origins tourne **sur le même moteur que nous**. Son code est directement
transposable, contrairement à l'assembleur GBA de `pmd-red`.

### La grammaire extraite

**a) On établit le lieu avant les personnages.**
Dans `beach`, le son d'ambiance monte, *puis* 60 frames passent, *puis*
quelqu'un parle. Le joueur entend le lieu, le voit, et seulement ensuite on
lui adresse la parole.

**b) Le dialogue va du concret à l'abstrait.**
Constat sensoriel → réaction affective → décision d'avancer. Jamais l'inverse.
On ne commente pas l'enjeu avant d'avoir décrit ce qu'on a sous les yeux.

**c) La caméra suit le sujet du discours.**
Elle cadre le décor pendant qu'on le décrit, puis redescend sur le duo au
moment de la décision. Le mouvement accompagne le changement de sujet.

**d) Rien ne « coupe » : tout s'éteint ensemble.**
Le patron `BranchCoroutine` × 3 + `JoinCoroutines` synchronise fondu d'image,
réplique et fondu sonore sur la *même* durée.

**e) Le geste remplace la réplique.**
Sky fait parler les corps : un pas de côté, un hochement de tête, un sursaut.
`CharacterActions` existe uniquement pour ça.

---

## 3. Ce qui a été créé

### `Data/Script/halcyon/ChapterScenes.lua`

Trois scènes d'arrivée, une par chapitre orphelin. **Chacune a une identité
distincte** — c'était une exigence explicite :

| Ch. | Lieu | Registre | Ouverture | Ressort |
|---|---|---|---|---|
| 8 | Sanctuaire de Cristal | **contemplation** | une cascade *silencieuse* | la beauté inquiète parce qu'elle est trop parfaite |
| 9 | Marais de l'Oubli | **malaise physique** | une *odeur* avant la vue | la menace est déjà passée par là |
| 10 | Pic Céleste | **adrénaline** | le *vent* qui frappe de côté | les rivaux ont de l'avance et savent où aller |

Aucune n'ouvre, ne se termine ni ne respire de la même façon.

**Chapitre 8 — le silence comme anomalie**
> « Écoute...[pause] Non. N'écoute pas. Il n'y a RIEN à écouter. »
> « Je ne vois pas une bibliothèque. Je vois un endroit qu'on a fermé.
> Et le silence, c'est le couvercle. »

**Chapitre 9 — la peur admise, et le geste qui la dit**
Le partenaire fait un pas *vers* le héros avant de parler — `MoveInDirection`,
pas une réplique.
> « ...Je peux rester près de toi ? C'est bête, je sais. »
> → « (Ce n'est pas bête. Je l'allais demander.) »

**Chapitre 10 — les rivaux qu'on entend sans les voir**
> « Le vent apporte un éclat de voix. Un rire, peut-être. Puis plus rien. »
> « Pourquoi est-ce qu'ils montent SI vite ? Ils ne cherchent pas. Ils SAVENT
> où aller. » → « (Quelqu'un leur a dit. Ou quelque chose.) »

Cette dernière réplique n'est pas gratuite : elle prépare la révélation du
chapitre 10 sans la livrer.

### `DizzyFade` intégré aux visions

`CharacterActions.DizzyFade()` est **l'effet des Cris Temporels** de Sky : un
voile noir semi-transparent (alpha 128) en `RepeatX`/`RepeatY`.

Le `RepeatX/RepeatY` est le point important : un `FlashEmitter` ponctuel ne
couvre qu'une zone autour de son point d'émission — c'était le défaut de ma
première version, déjà rencontré sur la brume du Tunnel Ardent. L'overlay
répété couvre l'écran quelle que soit la taille de la carte.

Ajouté comme `VoiceVisions.DizzyVeil()`, appelé automatiquement dès que la
nausée atteint le niveau 2.

---

## 4. Cohérence vérifiée

- **Aucun nom interdit** dans les 31 répliques (contrôle automatisé).
- **La Voix reste anonyme.**
- **Chronologie respectée** : le ch10 évoque l'avance de Fulgur, déjà établie ;
  le ch9 montre les traces du Cercle du Suaire, introduit au ch9 côté donjon.
- **Longueur des boîtes** : la plus longue fait 109 caractères (limite ~150).
- **Format des fonds** : `verify_bg_format.py` — aucun bug.
- Rejouabilité : les scènes sont gardées par `PlayedArrivalScene`, avec
  rattrapage `OnUpgrade` pour les sauvegardes en cours.

---

## 5. Résultat mesuré, et ce qui reste à faire

| Ch. | Avant | Après |
|---|---|---|
| 8 | 71 | ~81 |
| 9 | 52 | ~70 |
| 10 | 53 | ~71 |

**Soyons clairs : c'est une amélioration, pas une égalisation.** Les chapitres
8-10 restent très en dessous des chapitres 1-5. Ce lot pose les *scènes
d'arrivée* — le maillon le plus visiblement absent — mais il manque encore,
pour chacun de ces trois chapitres :

- une scène de **relais mi-donjon** avec dialogue de progression ;
- une scène **d'après-boss** (les arènes enchaînent directement) ;
- des **PNJ de ville réactifs** à l'avancement intra-chapitre ;
- pour le ch6, rien n'a été fait dans ce lot (105 boîtes, à traiter aussi).

Atteindre la densité des chapitres 1-5 demanderait plusieurs lots de cette
taille. Je préfère l'annoncer que le laisser croire.

---

## 6. Non vérifié

**Rien n'est testé en jeu.** En particulier :

- Les **coordonnées de caméra** (`camera`, `focus`) sont posées d'après les
  conventions des autres grounds, **sans avoir ouvert les `.rsground`
  correspondants**. Le cadrage peut tomber à côté du décor voulu.
- Le `MoveInDirection` du partenaire au ch9 suppose de la place libre à sa
  droite — non vérifié sur la carte.
- Les musiques (`Crystal Crossing`, `Dark Hill`, `Sky Peak Prairie`) existent
  bien, mais leur justesse de ton n'a pas été jugée à l'écoute.

---

# Addendum — les images animées (build 2026-07-31-Q)

## La question

> « Est-ce que tu as repris les scènes avec les images animées de PMD Rescue
> Team et EoS PMDO, et intégré ça dans New Era intelligemment ? »

**Réponse en deux temps.**

**Non, je n'ai importé aucune image** des dépôts sources. Copier
`Content/BG/*.dir` d'EoS Origins poserait un problème d'attribution, gonflerait
le dépôt, et surtout : leurs fonds représentent *leurs* lieux (la plage de
Ciel, le Krabby, la falaise). Ils n'ont pas de sens dans New Era.

**Mais j'avais raté trois fonds animés déjà présents chez nous**, jamais
utilisés depuis le début du projet. C'est ça, le vrai gisement.

## Les fonds animés du dépôt : état des lieux

| Fond | Frame | Frames | Avant | Après |
|---|---|---|---|---|
| `Genesis_Cores` | 320×240 | 12 | utilisé | utilisé |
| `Genesis_Fade` | 320×240 | 8 | utilisé | utilisé |
| `Genesis_Life` | 320×240 | 16 | utilisé | utilisé |
| `Genesis_Void` | 320×240 | 12 | utilisé | utilisé |
| `Genesis_Mew` | 320×240 | 16 | Genèse ch7 | Genèse ch7 |
| **`Dream_Back`** | 192×240 | **63** | **inexploité** | **ciel de rêve** |
| **`Dream_Front`** | 192×240 | **63** | **inexploité** | **ciel de rêve** |
| **`SE5_Wind_Background`** | 256×256 | **20** | **inexploité** | **vent du Pic** |

## Ce que j'avais mal compris

Au build `-O`, j'avais **écarté** `Dream_Back`/`Dream_Front` parce que leurs
frames font 192×240 — plus étroites que le viewport. C'était juste **pour un
usage en fond plein écran**.

Mais leur format raconte autre chose :

```
PNG 1536×1920 → grille 8×8 → 63 frames de 192×240
Deux fichiers jumeaux : _Back et _Front
```

192 px de large, deux couches jumelles, 63 frames : ce sont des **nuages
défilants en parallaxe**. Le ciel de rêve d'Explorateurs du Ciel. Ils ne sont
pas faits pour être *affichés*, mais pour **défiler en boucle**.

## Ce qui a été fait

### `VoiceVisions.DreamSky()` — la parallaxe

Deux couches lancées via `BossFX.Overlay` (qui gère déjà `RepeatX` +
`Movement`, cf. `common.lua:498`) :

- `Dream_Back` défile à **24 px/s** sur `DrawLayer.Bottom` — le lointain
- `Dream_Front` défile à **56 px/s** sur `DrawLayer.Back` — le proche

C'est le **différentiel de vitesse** qui crée la profondeur.

**Placement narratif** : réservé à la vision de **L'Effacement** (ch10) — la
plage au lever du jour, l'ami qui devient transparent. La scène la plus
onirique de l'arc, et la seule qui se passe *hors du temps*. Activé via
`plate.dreamSky = true` sur les deux planches concernées.

### `SE5_Wind_Background` — le vent du Pic

Bandeau de 5120×256 conçu pour défiler horizontalement. Dans la scène
d'arrivée du **chapitre 10**, il *est* le vent : rafales traversant l'écran de
droite à gauche à 180 px/s pendant toute la scène, sous le dialogue.

Le texte dit « le vent frappe de côté » — maintenant on le voit.

### `Genesis_Mew` : délibérément laissé de côté

Il sert déjà à la cinématique de la Genèse (ch7). Le réutiliser ailleurs
brouillerait le lore : cette image *est* associée à un moment précis du récit.

## Correction du vérificateur

`tools/verify_bg_format.py` ne détectait que `WaitShowBG` — il aurait signalé
mes nouveaux overlays comme des erreurs, ou pire, serait resté silencieux en
donnant une fausse assurance.

Il distingue désormais **deux usages aux contraintes différentes** :

- **plein écran** (`WaitShowBG`, `bg='...'`) → frame **obligatoirement** 320×240
- **overlay défilant** (`BossFX.Overlay`) → **taille libre**, la tuile est
  répétée et déplacée

Et il liste maintenant les fonds présents mais jamais utilisés — pour que le
prochain gisement ne dorme pas trois mois.

```
10 fond(s) plein écran, tous en frame 320x240.
3 fond(s) utilisé(s) en overlay défilant (taille libre) :
    Dream_Back             frame 192x240, 63 frames
    Dream_Front            frame 192x240, 63 frames
    SE5_Wind_Background    frame 256x256, 20 frames
3 fond(s) présent(s) mais jamais utilisé(s) : Genesis_Mew, Steam, Title_Screen_Background
RESULTAT : AUCUN BUG DE FORMAT
```

## Non vérifié

**Rien n'est testé en jeu.** En particulier :

- Les **vitesses de défilement** (24 / 56 / 180 px/s) sont des valeurs de
  départ raisonnées, pas observées. La parallaxe peut être trop lente ou le
  vent trop agressif.
- Les **couches de rendu** (`Bottom` pour le lointain, `Back` pour le proche)
  supposent que `WaitShowBG` s'affiche au-dessus. Si l'ordre est inversé, les
  nuages masqueraient l'image fixe au lieu de passer derrière.
- `Dream_Back`/`Front` ont **63 frames** : leur vitesse d'animation propre
  face à la durée d'affichage n'a pas été validée.

---

# Addendum 3 — après-boss ch8-10, d'après `pmd-red` (build 2026-07-31-R)

## Le trou comblé

Après le lot précédent, le manque le plus grave restait l'**après-boss**. On
battait Diancie, Laggron ou Lugia, et… `SV.ChapterN.DefeatedX = true`, puis
fin de journée. Les trois combats les plus importants du jeu se terminaient
plus sèchement qu'un donjon secondaire.

## Ce que `pret/pmd-red` apprend

`data/scripts/intro.inc` est de l'assembleur GBA — illisible en tant que
contenu, mais sa **structure d'exécution** est très instructive :

**1. Les fils parallèles synchronisés par drapeaux.**
```asm
setFlag 5        @ thread A signale
waitFlag 5       @ thread B attendait ce signal
```
Le script lance plusieurs threads : l'un anime la caméra, l'autre déplace un
acteur, un troisième enchaîne les animations. Personne n'attend inutilement.
→ Transposé en `BranchCoroutine` + `JoinCoroutines` : le boss s'effondre
**pendant** que l'écran tremble, pas après.

**2. La cascade d'animations sur un seul acteur.**
```asm
setAnimation 0xE ... setAnimation 0xF ... 0x10 ... 0x11
```
L'acteur ne joue pas *une* animation : il en traverse une **suite**, avec des
déplacements entre. D'où la sensation d'un corps qui réagit dans la durée.
→ Transposé dans `collapse()` : `Hurt` → secousse → `EventSleep`, avec des
temps morts. Le boss ne disparaît plus d'un bloc.

## Les trois scènes créées

Chacune a une **fonction dramatique distincte** dans la montée de l'arc :

| Ch. | Rôle | Ce qui se passe | Registre |
|---|---|---|---|
| 8 | **le doute semé** | Diancie ne perd pas : elle **cède** | trouble |
| 9 | **la confirmation** | Le Cercle ne se bat pas : il **compte** | effroi froid |
| 10 | **le vertige** | Lugia ne juge plus : il **s'excuse** | renversement |

### Ch8 — la question qui reste

Diancie s'agenouille et se débarrasse du Fragment plutôt que de le donner.
Puis :

> « Un gardien protège ce qui est fragile. Alors pourquoi les premiers ont-ils
> bâti des **MURS** autour de leur lumière ? »
> — « ...Je ne sais pas. » — « Moi non plus. Et j'ai eu mille ans pour y
> réfléchir. »

### Ch9 — la pièce du puzzle

Le Cercle du Suaire n'attaque pas. Il **interrompt la joie** du partenaire en
plein milieu (rupture de rythme volontaire) :

> « Trois. » — « Nous ne sommes pas venus vous arrêter. Nous sommes venus
> **COMPTER**. »
> « Chaque Cœur que vous ranimez brille un peu plus fort. Et chaque fois qu'un
> Cœur brille, **une paroi s'amincit**. »
> — « Une paroi de QUOI ? » — « Continuez. Vous comprendrez au dernier. »

Le mécanisme est nommé ; **ce qu'il retient ne l'est pas**. Le twist reste
intact pour l'arc 6.

### Ch10 — le renversement

Le plus ancien gardien du monde demande pardon à deux gamins :

> « Je gardais le sommet ? Non. » → *(Il gardait le CHEMIN. Pour que personne
> n'arrive jusqu'ici.)*
> « **Pardon.** Pour ce que nous avons fait, et pour ce que vous allez devoir
> défaire. »

Et pour la première fois, la Voix parle **devant témoin** — Lugia ne réagit
pas, confirmant que le héros seul l'entend :

> « ...Il en a trop dit. »
> → *(Elle avait peur. Pour la première fois, elle avait PEUR.)*

## Densité : résultat mesuré

| Ch. | Départ | Après lot précédent | Maintenant |
|---|---|---|---|
| 8 | 71 | 81 | **96** |
| 9 | 52 | 70 | **85** |
| 10 | 53 | 71 | **86** |

## Vérifications

- Lua **642/642**, `.resx` 576/576, zones 209/209
- `verify_legend` 0 échec, `verify_bg_format` aucun bug
- **47 répliques**, **0 nom interdit** — le mot « prison » n'est jamais
  prononcé (contrôlé automatiquement)
- Réplique la plus longue : 118 caractères (limite ~150)
- Casting vérifié présent : `Diancie`, `Swampert`, `Lugia`, `Suaire_Banette`
- Rattrapage `OnUpgrade` : une partie ayant déjà battu le boss ne rejouera
  pas la scène hors contexte

## Non vérifié

**Rien n'est testé en jeu.** Les positions (`hero`, `partner`, `camera`) et
celles des boss suivent les conventions des scènes ch5, **sans ouverture des
`.rsground`**. Sur `crystal_sanctuary_boss` et `forgotten_marsh_boss`
(320×240), le cadrage est contraint — c'est le point le plus à risque.

## Ce qui reste, honnêtement

- **ch6 : 105 boîtes**, toujours pas traité.
- Les **relais** ch8-10 n'ont que 3 boîtes chacun (`RelayScenes` générique).
- Aucun **PNJ de ville réactif** à l'avancement intra-chapitre.

---

# Addendum 4 — le Veilleur du Canyon (build 2026-07-31-S)

## L'exemple que tu as donné

> « la scène avec Xatu tu peux la reprendre car tôt ou tard dans l'histoire on
> devra aller au donjon Grand Canyon et à la fin pour lui parler »

Bonne intuition : **tout était déjà en place**, sauf le personnage.

| Élément | État avant |
|---|---|
| `Data/Ground/grand_canyon_porte.rsground` | importé 1:1 de pmd-red (D07P01) |
| `new_era_zone_07` | « Canyon des Voix Éteintes », débloquée ch11+ |
| Scène de fin de donjon | existante, mais **générique** (deux piliers qui s'allument) |
| Xatu | **absent du casting** |

## La fonction reprise, pas la scène

Dans les jeux d'origine, le Xatu du Grand Canyon a une fonction dramatique
précise : **c'est un témoin qui se tait**. Il voit, il sait, il refuse de dire.
Le joueur repart avec moins de réponses qu'en arrivant — et c'est voulu.

C'est **cette fonction** qui est reprise. Le reste est neuf, et surtout : il
sert *notre* intrigue.

### Trois raccords avec le lore existant

**1. Il explique un détail déjà planté.** Le nom FR de la zone est « Canyon des
Voix Éteintes », et la scène disait déjà que le canyon ne renvoie aucun écho.
Le Veilleur donne la cause :

> « Le canyon ne mange pas vos voix. **C'est moi.** Je les écoute depuis si
> longtemps que je les garde. Toutes. Y compris celles qu'on ne devrait pas
> entendre. »

**2. Il est le premier tiers à confirmer la Voix.** Jusqu'ici, seuls le héros
et le joueur savaient. Un personnage extérieur à l'intrigue le dit tout haut :

> « Tu en portes une. Une voix qui n'est pas la tienne, et que personne d'autre
> n'entend. »
> — « Comment vous... Il ne l'a dit à PERSONNE. »
> — « Il ne l'a pas dit. **Elle**, si. Elle parle fort, pour qui sait écouter
> le silence. »

Le héros a une **nausée** au moment où on en parle (`VoiceVisions.Nausea`) :
le dispositif établi sert la scène au lieu d'être décoratif.

**3. Il refuse de nommer — et donne une méthode.**

> « Je vois assez loin pour savoir que nommer une chose, c'est lui ouvrir la
> porte. »
> « Vous demandez tous CE QUE c'est. Demandez plutôt **DEPUIS QUAND** elle lui
> parle. »
> → *(Depuis quand... Je ne me souviens pas d'un seul jour sans elle.)*

Aucune révélation, aucun nom interdit. La quête est **relancée**, pas résolue.
Et il donne rendez-vous : « quand vous reviendrez, rapportez-moi la réponse ».

## Détails de mise en scène

- **Il n'arrive pas** : « Il ne s'est pas posé : il était là. » Il ne repart
  pas non plus, il « cesse d'être visible, comme le reste des voix d'ici ».
- Le lieu est établi **avant** le personnage (règle tirée de `beach`).
- Casting : `Canyon_Xatu`, surnommé **« Veilleur »** — le nom « Xatu »
  n'apparaît jamais à l'écran, cohérent avec les autres Veilleurs du Réseau.

## Vérifications

- Lua **642/642**, `.resx` 576/576, zones 209/209
- `verify_legend` 0 échec, `verify_bg_format` aucun bug
- **29 répliques**, **0 nom interdit** (contrôle automatisé), plus longue
  109 caractères
- `xatu` confirmé présent dans `MonsterFeature.json` (1011 espèces)
- `grand_canyon_porte` bien déclaré dans les `GroundMaps` de la zone **et**
  dans `index.idx` — sans quoi `EnterGroundMap` échouerait
- Sortie garantie hors du `pcall` : aucun blocage possible

## Le patron est réutilisable

**31 autres grounds pmd-red** sont importés et marqués « réserve » dans
`docs/registre_donjons_new_era.md` : `mont_gele_pied`, `gouffre_muet_bord`,
`foret_givree_oree`, `grotte_lazuli_seuil`… Chacun peut recevoir le même
traitement :

1. identifier la **fonction dramatique** du lieu d'origine ;
2. trouver le **raccord** avec un élément déjà planté dans New Era ;
3. créer un personnage au **rôle** équivalent, au nom et au propos neufs ;
4. ne jamais résoudre — relancer.

## Non vérifié

**Rien n'est testé en jeu.** Les positions (héros 224,224 · partenaire 192,224
· Veilleur 208,152) reprennent celles de la scène précédente pour le duo, mais
celle du Veilleur est **choisie sans avoir ouvert le `.rsground`** : il peut
apparaître dans le vide ou derrière un relief.

---

# Addendum 5 — vérification des positions (build 2026-07-31-T)

## La demande

> « regarde les positions des entités des scènes venant des GitHub originaux »

C'était le bon réflexe : je posais mes coordonnées « d'après les conventions
des autres cartes », **sans jamais ouvrir les `.rsground`**. Je l'annonçais
comme réserve à chaque lot. Cette fois j'ai vérifié — et je me suis trompé
deux fois avant de trouver la bonne méthode.

## Le piège : la taille d'une carte n'est pas dans `Layers`

**Première tentative.** J'ai lu `Layers[0].Tiles` × 8 px. Résultat pour
`vast_steppe_midpoint` : 176×264. L'outil a signalé 31 positions « hors
carte »… dont celles du contenu Halcyon d'origine **qui fonctionne en jeu**.

Signal d'alarme : quand un outil accuse du code testé et jouable, c'est
l'outil qui a tort.

**Vérification.** Le `.rsground` lui-même place `Stump_3` à (704,424) et
`Kangaskhan_Rock` à (696,216) — largement au-delà de 176×264. Un fichier ne
peut pas être hors de sa propre carte : ma lecture était fausse.

**Deuxième tentative.** La vraie grille est `obstacles` (collision, cases de
8 px). Mais j'ai lu `len(ob[0])` pour la largeur → `mount_windswept_midpoint`
donnait 624×1152, alors que son `entrance_east` est à **x=1132**.

**La bonne réponse.** La grille est indexée **`[x][y]`**, pas `[y][x]`.
Vérifié statistiquement sur les **269 cartes** du dépôt, en confrontant chaque
ancrage à sa propre carte :

| Lecture | Ancrages aberrants |
|---|---|
| `[x][y]` (largeur = `len(ob)`) | **5** |
| `[y][x]` (largeur = `len(ob[0])`) | **147** |

## L'erreur que j'ai failli commettre

Entre les deux, j'avais « corrigé » **14 arènes de légendaires** en recadrant
tout sur des tailles fausses — par exemple `arene_trone_magma` ramenée à
208×216 alors qu'elle fait réellement **624×648**.

J'ai annulé (`git checkout`) dès que la contradiction est apparue. **Aucune de
ces fausses corrections n'a été commitée.** Le contenu d'origine est intact.

## Résultat, avec la bonne formule

```
385 fichier(s) de scène rattaché(s) à une carte.
RESULTAT : AUCUNE ENTITE A PLUS D UN ECRAN HORS CARTE
```

**Aucun bug de position dans tout le dépôt.** Les entités qui sortent
légèrement des bornes sont un usage **volontaire** : un personnage entre ou
sort du champ. Le contenu Halcyon d'origine en est plein.

## Une vraie correction : le Canyon

La seule scène réellement mal placée était la mienne, écrite au lot précédent.

| | Avant | Après | Source |
|---|---|---|---|
| Héros | (224, 224) | **(208, 232)** | `Main_Entrance_Marker` |
| Partenaire | (192, 224) | **(256, 232)** | spawner `TEAMMATE_1` |
| Veilleur | (208, 152) | **(240, 120)** | `Cutscene_Marker` |
| Caméra | (208, 208) | **(240, 176)** | entre le duo et l'éperon |

Le partenaire était à x=192 alors que son spawner officiel est à x=256 : il
serait apparu **64 px à côté de sa place**. Les trois entités reposent
désormais sur les ancrages du fichier, pas sur une supposition.

## Nouvel outil : `tools/verify_scene_positions.py`

- lit la taille réelle via `obstacles`, indexé `[x][y]` ;
- extrait `TeleportTo`, `MoveCamera` et `MakeCharactersFromList` des scripts ;
- ne signale que les positions à **plus d'un écran** hors carte — au-delà, le
  sprite ne peut plus revenir dans le cadre ;
- affiche les ancrages officiels du `.rsground` pour donner la bonne valeur.

Le seuil est le point important : sans lui, l'outil noie les vrais défauts
sous 31 faux positifs.

## Sur `CregALeg/minior-game-jam`

Dépôt consulté : mod PMDO complet (Minior the Fallen Star), même moteur.
Rien n'en a été importé dans ce lot — le travail portait sur la **méthode de
placement**, et celle-ci se lit dans nos propres `.rsground`. Le dépôt reste
une référence utile pour de futurs patrons de scène.

## Non vérifié

Les positions sont désormais **exactes par rapport aux ancrages déclarés**.
Reste ce qu'aucun script ne peut dire : si le décor à cet endroit est bien
celui qu'on imagine (un éperon rocheux visible, et non un pan de ciel vide).
Seul un test en jeu le confirmera.
