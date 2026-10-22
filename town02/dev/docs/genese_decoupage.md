# Cinématique de la Genèse — découpage à valider

> **Aucune image n'a été produite.** Ce document est le livrable de cadrage demandé.
> Rien ne part en production avant validation de ce découpage complet
> (fond + personnages + caméra + texte).
>
> Dernière mise à jour : 25/07/2026.

---

## 0. Ce qui a été vérifié avant d'écrire (preuves)

### Le format `.dir` est un flipbook natif — décodé, pas supposé

```
[0..3]    uint32  taille du PNG
[4..7]    uint32  (0)
[8..]     1 PNG = planche contenant TOUTES les frames en grille
[-16..-1] uint32 largeurFrame, uint32 hauteurFrame, uint32, uint32 nbFrames
```

Vérifié sur les 11 fonds du projet :

| Fichier | Planche | Frame | Frames |
|---|---|---|---|
| `Dream_Back` | 1536×1920 | **192×240** | **63** |
| `Dream_Front` | 1536×1920 | 192×240 | 63 |
| `SE5_Wind_Background` | 5120×256 | 256×256 | **20** |
| `Chapter_1..4`, `Steam`, `Wanted_Poster`… | 320×240 | 320×240 | 1 |

**Conclusion : aucun système nouveau à construire.** Le moteur lit déjà des
flipbooks. `Dream_Back` (63 frames, produit par Palika) et
`SE5_Wind_Background` (20 frames, fond du Mont Venteux) sont les deux
précédents internes.

### Le vrai précédent de scène narrée : `personality_test`, pas Searing Crucible

`searing_crucible_ch_5.lua` (1305 lignes, 232 appels de mise en scène) est une
masterclass de **mise en scène de personnages**, mais il n'a **aucune séquence
d'image plein écran**. Le pattern à reprendre est celui du quiz d'introduction :

- `Background` de type `LayeredBG` avec 2 couches animées à vitesses opposées
- `UI:WaitShowVoiceOver(texte, -1)` pour la narration sans boîte de dialogue

### Vocabulaire technique disponible (compté dans le projet)

| Appel | Occurrences | Usage ici |
|---|---:|---|
| `GAME:MoveCamera(x, y, frames, instant)` | 174 | travellings et zooms |
| `GAME:FadeIn` / `FadeOut` | 281 / 197 | transitions entre actes |
| `GROUND:MoveScreen(ScreenMover(min,max,durée))` | via `BossFX` | secousses |
| `GROUND:CharSetAnim(chara, "Anim", boucle)` | 117× `Idle` | animation des sprites |
| `GROUND:MoveToPosition` / `MoveInDirection` | — | déplacements |

### Sprites : **zéro création nécessaire**

| Sprite | Statut |
|---|---|
| **Mew (151)** | Dans DumpAsset. Planche 352×352, **jeu complet** : Idle, flottement, Twirl, 8 directions |
| Bulbizarre (1), Salamèche (4), Carapuce (7) | **Déjà embarqués** dans le projet |
| Métamorph (133), Germignon (152), Héricendre (155), Kaiminus (158) | **Déjà embarqués** |
| Vipélierre (495), Gruikui (498) | **Déjà embarqués** |

Mew est le seul à copier depuis DumpAsset (122 Ko). Les 9 autres sont déjà là.

---

## 1. L'exception, assumée explicitement

Ce projet suit la règle « **aucun nouvel asset pour les zones récurrentes** ».

**Cette cinématique y déroge, et c'est assumé** : c'est une pièce maîtresse
narrative unique, jouée une seule fois, et le moteur exige un `.dir` — aucun
fond existant ne peut représenter la Genèse. La dérogation porte
**uniquement sur les 5 planches de fond**. Tous les sprites sont réutilisés.

Ce débat n'a pas à être rouvert pour les cinématiques futures : elles devront
réutiliser ces planches ou l'existant.

---

## 2. Volume de production

**64 images uniques de 320×240**, réparties en 5 planches.

Le calcul qui a écarté le flipbook intégral : 320×240 à 8 img/s ⇒ une planche
8×8 = 64 frames ≈ **8 secondes**. Une cinématique de 4-5 min en flipbook
continu demanderait **~2400 images**. Irréaliste.

La méthode retenue est celle d'Explorers of Sky et de `Dream_Back` :
**une boucle animée par plan-clé**, le mouvement venant de la caméra et des
sprites, pas d'un défilement image par image du décor.

Production avec **Pillow** (déjà utilisé pour les 5 salles de boss). Palettes
reprises de `ConcealedRuins` (or corrompu) et `Dream_Back` (irisé).
Aucun outil externe.

---

## 3. Déclencheur diégétique

**Lieu** : hall du 3ᵉ étage de la guilde (`guild_third_floor_lobby`).
**Personnage** : **Phileas**, le Noctowl Vice-Maître — vérifié dans
`CharacterEssentials.lua:43` (`species="noctowl", nickname='Phileas'`).

**Condition** : `SV.ChapterProgression.Chapter == 7`
et `SV.Chapter7.SawAnimaCoreCorruption == true`
et `not SV.Chapter7.HeardGenesisTale`.

Le joueur ne clique pas sur « voir la cinématique ». Il parle à Phileas après
avoir vu le Cœur corrompu, et **le partenaire pose la question à sa place** :

> **Partenaire** — « Phileas… Le Cœur là-bas. Il était *malade*.
> Je ne savais même pas qu'un Cœur pouvait tomber malade. »
>
> **Phileas** — « …Peu de Pokémon le savent. »
> « Dis-moi — vous a-t-on déjà raconté d'où vient la vie ? »
>
> **Partenaire** — « D'où elle… vient ? »
>
> **Phileas** — « Alors installez-vous. C'est une longue histoire,
> et je crois que vous êtes prêts à l'entendre. »

---

## 4. Découpage scène par scène

Chaque acte : **planche animée en boucle + sprites + mouvement de caméra + narration**.

La caméra raconte l'arc : **immobile et oppressante au début → naissance du
mouvement avec la vie → apaisement final**.

---

### ACTE 1 — Le monde avant la vie
**Planche** `Genesis_Void` · **12 frames** · ~40 s

| | |
|---|---|
| **Écran** | Roche nue jusqu'à l'horizon, ciel sans soleil. Brumes grises très lentes. Les 12 frames animent uniquement la dérive des brumes — rien d'autre ne bouge. |
| **Sprites** | **Aucun.** L'absence est le sujet. |
| **Caméra** | **Immobile 12 s**, puis travelling latéral très lent : `GAME:MoveCamera(x+180, y, 900, false)`. Vitesse volontairement en dessous du confort : le vide doit peser. |

> « Avant les forêts. Avant les rivières. Avant le premier battement d'aile…
> il y avait ceci. »
>
> « De la pierre, et du silence. Un monde parfaitement immobile —
> et parfaitement mort. »
>
> « Rien ne naissait. Rien ne mourait. Il n'y avait rien pour cela. »

---

### ACTE 2 — Mew
**Planche** `Genesis_Mew` · **16 frames** · ~50 s

| | |
|---|---|
| **Écran** | Même roche, mais une lueur rose monte de l'horizon. Les 16 frames font pulser cette lueur — respiration lente, comme un cœur. |
| **Sprites** | **Mew (151)**, `Idle` en boucle. Entre par le **haut de l'écran**, descend lentement en flottant : `GROUND:MoveToPosition(mew, cx, cy, false, 8)` sur ~6 s. Puis `Twirl` une seule fois, au moment exact de « elle a dansé ». |
| **Caméra** | **Le mouvement naît ici.** Zoom progressif sur la silhouette : `GAME:MoveCamera(mewX, mewY, 240, false)`, puis maintien. Premier plan cadré du film. |

> « Et puis — quelque chose est apparu. »
>
> « Petite. Plus petite que vous. Seule au milieu de tout ce vide. »
>
> « On ne sait pas d'où elle venait. Peut-être de nulle part.
> Peut-être qu'elle a toujours été là, à attendre. »
>
> « Elle n'a pas parlé. Elle n'a pas ordonné. Elle a *dansé*. »

*(déclencher `Twirl` sur cette dernière ligne, puis `BossFX.Flash` très doux)*

---

### ACTE 3 — La diversité du vivant
**Planche** `Genesis_Life` · **16 frames** · ~60 s

| | |
|---|---|
| **Écran** | Éclats de lumière se dispersant depuis le centre. Mousse, puis herbe, puis arbres poussent en accéléré sur la roche. Les 16 frames animent la poussée. |
| **Sprites** | Mew reste au centre (`Idle`). **9 silhouettes apparaissent une à une**, toutes **déjà dans le projet** : Bulbizarre (1), Salamèche (4), Carapuce (7), Germignon (152), Héricendre (155), Kaiminus (158), Vipélierre (495), Gruikui (498), Métamorph (133). Chacune : `Hide` → `Unhide` + petit `Hop`, espacées de 25 frames. Métamorph **en dernier**, seul à changer de forme — clin d'œil au lien Mew/Métamorph, sans l'expliciter. |
| **Caméra** | **Dézoom continu** — la caméra recule à mesure que le monde se remplit : `GAME:MoveCamera(cx, cy, 600, false)` vers un cadre large. Le mouvement suit la dispersion. |

> « De chaque pas de sa danse, quelque chose naissait. »
>
> « Ce qui nage. Ce qui vole. Ce qui creuse.
> Ce qui brûle, ce qui gèle, ce qui rêve. »
>
> « Aucun ne lui ressemblait. C'était le but. »
>
> « Elle ne voulait pas d'un monde à son image.
> Elle voulait un monde qui la surprenne. »

---

### ACTE 4 — Les Cœurs des Anima
**Planche** `Genesis_Cores` · **12 frames** · ~50 s

| | |
|---|---|
| **Écran** | Cristaux dorés qui descendent du ciel et s'ancrent dans le sol, un par région. Les 12 frames animent la pulsation dorée. **C'est ici qu'apparaît la couleur or de `ConcealedRuins`** — celle qu'on retrouvera dans les Profondeurs et sur Regigigas. |
| **Sprites** | Mew, `Idle`, **s'éloigne** : `GROUND:MoveInDirection(mew, Direction.Up, 120, false, 1)` — elle monte hors du cadre pendant la narration. Les 9 autres restent. |
| **Caméra** | Panoramique lent vers le haut, **suivant Mew qui part** : `GAME:MoveCamera(cx, cy-100, 480, false)`. La caméra la perd volontairement. |

> « Mais une danse ne dure pas éternellement. »
>
> « Alors avant de s'en aller, elle a laissé quelque chose derrière elle. »
>
> « Des Cœurs. Enfouis dans la roche, au fond des mers, sous les racines.
> Un pour chaque région du monde. »
>
> « Tant qu'un Cœur bat, sa région peut porter la vie.
> C'est elle qui continue de danser, à travers eux. »

---

### ACTE 5 — Retour au présent
**Planche** `Genesis_Fade` · **8 frames** · ~35 s

| | |
|---|---|
| **Écran** | L'or des Cœurs **se ternit**, vire au violet désaturé — la palette exacte de `DeepSealedRuin`, celle des étages 11-15 des Aegis Cave. Les 8 frames animent uniquement cette décoloration. |
| **Sprites** | **Aucun.** On revient au vide du début — mais corrompu, pas vierge. |
| **Caméra** | **Retour à l'immobilité totale.** Aucun mouvement pendant les 3 dernières répliques. Le contraste avec l'Acte 3 fait le travail. Puis `GAME:FadeOut(false, 120)`. |

> « Voilà d'où vous venez. Voilà d'où *tout* vient. »
>
> *(silence — 60 frames)*
>
> « Et voilà pourquoi ce que vous avez vu dans ces ruines
> m'empêche de dormir. »
>
> « Ce qui soutient la vie… peut aussi être vidé. »

**Dernière réplique volontairement ouverte.** Elle relie la Genèse au lore
canonique (`first_core_location_ch_3.lua:25-29` : *« Anima Cores are what allow
a region to sustain life »*) **sans trancher** Necrozma / Eternatus / autre.

---

## 5. Cohérence avec le lore existant

| Élément canonique | Source | Respecté |
|---|---|---|
| Les Cœurs permettent à une région de porter la vie | `first_core_location_ch_3.lua:25` | Acte 4 en donne l'origine |
| Briser un Cœur ⇒ la région perd cette capacité | `.lua:26-28` | Acte 5 le pose comme menace |
| Un Cœur peut être dans « une cité ancienne en ruines » | `.lua:20` | C'est exactement les Aegis Cave |
| Ambiguïté Necrozma/Eternatus | prompt ch.7 | Aucun nom prononcé |

L'Acte 5 **fournit la cause narrative** de la corruption du chapitre 7 sans la
nommer : si la vie vient d'un don, ce don peut être repris.

---

## 6. Technique vs narratif (à valider séparément)

### Technique
1. 5 planches `.dir` (64 frames, 320×240) générées avec Pillow
2. Carte `genesis_vision.rsground` — 40×30 tuiles, `Background` en `LayeredBG`
3. `ground/genesis_vision/genesis_vision_ch_7.lua` — modèle Searing Crucible
4. Copier `151.chara` (Mew) depuis DumpAsset — 122 Ko
5. Déclencheur dans `guild_third_floor_lobby_ch_7.lua`
6. Variables `SV.Chapter7.HeardGenesisTale`, `SawAnimaCoreCorruption`
7. ~45 clés resx EN + FR

### Narratif
1. Les 5 actes et leur texte (ci-dessus)
2. Le dialogue déclencheur
3. La chute « Ce qui soutient la vie… peut aussi être vidé. »
4. Le choix de Métamorph en dernier à l'Acte 3

---

## 7. Durée totale

**≈ 3 min 55 s**, hors dialogue déclencheur.

| Acte | Frames | Durée |
|---|---:|---:|
| 1 — Le vide | 12 | 40 s |
| 2 — Mew | 16 | 50 s |
| 3 — La vie | 16 | 60 s |
| 4 — Les Cœurs | 12 | 50 s |
| 5 — Le présent | 8 | 35 s |
| **Total** | **64** | **3 min 55** |
