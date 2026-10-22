# Cinématiques, quêtes secondaires et monde vivant — chapitres 6 à 10

Date : 2026-08-02 — branche `new-era-1-9`, commit `0c84477`
Mesuré sur les fichiers, pas estimé. 752 fonctions Lua contenant au moins
6 boîtes de dialogue ont été analysées et classées.

---

## Méthode

Une **cinématique** est une fonction qui passe en `CutsceneMode(true)`, ou qui
présente au moins 3 des 4 familles de mise en scène, ou qui dépasse 15 boîtes.
Les handlers de PNJ (`*_Action`, `*Talk`, `*_Touch`) en sont exclus : un
dialogue d'habitant, même long, n'est pas une cinématique.

Une cinématique est dite **qualitative** quand elle mobilise au moins 3 des
4 familles — caméra, déplacement, orientation, animation — et ne contient
aucune narration interne (interdite par le §4 du guide).

**Correction en cours d'analyse** : ma première passe classait les 169
`*_AdventureTalk` du ch6 comme cinématiques, ce qui donnait un faux « 49
cinématiques dont 35 faibles ». Ce sont des dialogues de PNJ. Reclassés.

---

## 1. Le tableau d'ensemble

| Ch | Cinématiques | Qualitatives | Moyennes | Squelettes | Boîtes ciné | PNJ longs | Boîtes PNJ |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 40 | 12 | 2 | 2 | 1 762 | 6 | 357 |
| 2 | 29 | 14 | 3 | 8 | 1 621 | 11 | 84 |
| 3 | 30 | 13 | 2 | 11 | 2 276 | 16 | 926 |
| 4 | 15 | 12 | 2 | 1 | 663 | 10 | 200 |
| **5** | **53** | **34** | 3 | 4 | **2 210** | 51 | 1 053 |
| **6** | **16** | **5** | 4 | 2 | 269 | **169** | **1 877** |
| **7** | **6** | **1** | 2 | 0 | 80 | **178** | **1 845** |
| **8** | **4** | **2** | 1 | 1 | 135 | 4 | 30 |
| **9** | **3** | **0** | 1 | 2 | 215 | 9 | 67 |
| **10** | **4** | **0** | 1 | 1 | 56 | 6 | 47 |
| 11 | 1 | 0 | 0 | 0 | 11 | 0 | 0 |

**Le chapitre 5 est le sommet du projet** : 53 cinématiques, 34 qualitatives.
C'est le seul chapitre qui tienne le niveau annoncé.

**Rupture nette après le ch5.** Les ch6 et ch7 ont beaucoup de contenu, mais il
est presque entièrement dans les **dialogues de PNJ** (1 877 et 1 845 boîtes),
pas dans les cinématiques (269 et 80). Les ch8, 9 et 10 n'ont **ni l'un ni
l'autre**.

**Zéro cinématique qualitative aux ch9 et ch10.**

## 2. Détail par chapitre

### Chapitre 6 — 16 cinématiques, 5 qualitatives

| Scène | Boîtes | Verdict |
|---|---:|---|
| `metano_town_ch_6.DazzlingIntroduction` | 36 | **qualitative** — 2 caméras, 13 déplacements, 27 orientations, 39 animations |
| `gloomy_forest_entrance_ch_6.ArrivalCutscene` | 22 | **qualitative** — la mieux mise en scène du chapitre (8 caméras, 20 déplacements, 29 orientations) |
| `metano_town_ch_6.PostDefeatCutscene` | 10 | qualitative |
| `gloomy_forest_boss_ch_6.FirstBossScene` | 11 | qualitative |
| `gloomy_forest_midpoint_ch_6.WipedCutscene` | 6 | qualitative |
| `guild_guildmasters_room_ch_6.GuildmasterAudience` | **26** | **squelette** — 2 caméras, **0 déplacement, 0 orientation, 0 animation** |
| `DazzlingArc.TrialIntro` | 25 | squelette |
| `BATTLE_SCRIPT.SynergyScarfPass` | 19 | squelette |
| `DazzlingArc.TrialVictory` / `TrialDefeat` | 16 / 15 | squelettes |

Le défaut le plus visible : **l'audience du maître de guilde**, 26 boîtes, est
une liste de répliques. Personne ne bouge, personne ne se tourne.

### Chapitre 7 — 6 cinématiques, 1 qualitative

| Scène | Boîtes | Verdict |
|---|---:|---|
| `metano_town_ch_7.AlakazamScene` | 13 | **qualitative** (la seule) |
| `cloven_ruins_boss_ch_7.FirstPreBossScene` | 27 | squelette — 7 caméras mais **0 orientation** |
| `metano_town_ch_7.GreatReunion` | 17 | squelette — **0 orientation** |
| `guild_heros_room_ch_7.DreamCutscene` | 8 | moyenne |

Le ch7 est le chapitre le plus riche en dialogues de ville (1 845 boîtes) et le
plus pauvre en cinématiques (80 boîtes). **Le déséquilibre est de 23 contre 1.**

C'est d'autant plus problématique que le ch7 doit porter, selon vos briefs,
l'arc Groudon avec ses trois donjons et ses longues cinématiques de 6 à 15
minutes. Il n'y a aujourd'hui aucune structure pour cela.

### Chapitre 8 — 4 cinématiques, 2 qualitatives

Les deux « qualitatives » sont `metano_cafe.CheckForItems` et `RemoveItems` —
52 boîtes chacune, mais ce sont des **fonctions de café**, pas des scènes
d'histoire. Elles gonflent le score sans porter le chapitre.

`metano_cafe.KirliaQuiz` : 25 boîtes, **squelette** (0 caméra, 0 déplacement,
0 orientation). C'est le quiz déjà livré, et il n'est pas mis en scène.

**Le Sanctuaire de Cristal et Diancie n'ont aucune cinématique d'histoire
recensée** en dehors du pré-boss du mini-boss.

### Chapitre 9 — 3 cinématiques, 0 qualitative

| Scène | Boîtes | Verdict |
|---|---:|---|
| `metano_town_ch_9.SetupGround` | **194** | **squelette** — 0 caméra, 0 déplacement, 0 orientation |
| `ChapterAftermath.MarshVictory` | 15 | **squelette** — 0 caméra, 0 déplacement, 0 orientation, 0 son |
| `forgotten_marsh_miniboss_ch_9.FirstPreBossScene` | 6 | moyenne |

**Le plus grave du projet.** `MarshVictory` est **la scène pivot de toute la
trame** — celle où le Cercle du Suaire se montre et dit « Nous sommes venus
COMPTER », phrase qui arme les chapitres 9 à 11. Elle est jouée sans une seule
caméra, sans un mouvement, sans un son.

`SetupGround` à 194 boîtes est un cas particulier : c'est une fonction de
placement qui contient des dialogues, pas une scène. À découper.

### Chapitre 10 — 4 cinématiques, 0 qualitative

| Scène | Boîtes | Verdict |
|---|---:|---|
| `ChapterAftermath.PeakVictory` | 19 | **squelette** — 0 caméra, 0 déplacement, 0 orientation, 0 son |
| `ChapterScenes.PeakArrival` | 15 | squelette |
| `autel_celeste.PlayPostVictoryScene` | 14 | squelette — **et jamais appelée** (cf. blocage documenté) |
| `guild_heros_room_ch_10.PostPeakBedtalk` | 8 | moyenne |

Le climax du Livre I — le plus ancien gardien du monde qui demande pardon — est
un enchaînement de répliques sans mise en scène.

## 3. Quêtes secondaires — le point le plus sain

`SideQuests.lua`, 662 lignes, **15 requêtes, exactement 3 par chapitre du ch6
au ch10** :

| Ch | Requêtes |
|---|---|
| 6 | `q6_petitdej`, `q6_etal`, `q6_autographe` |
| 7 | `q7_seisme`, `q7_peur`, `q7_eau` |
| 8 | `q8_cristaux`, `q8_reves`, `q8_climat` |
| 9 | `q9_rumeurs`, `q9_fugitifs`, `q9_cloche` |
| 10 | `q10_derniervoeu`, `q10_lettre`, `q10_espoir` |

Chacune a ses six états (`ask`, `accept`, `refuse`, `pending`, `solve`, `done`),
un demandeur et une cible nommés, et une « seconde couche » documentée : le
quotidien qui laisse deviner que le monde va mal.

C'est **conforme au plan directeur** et bien conçu. Réserve : je n'ai pas
vérifié que les 15 requêtes sont effectivement **branchées** en jeu ni que le
mécanisme de blocage du palier de chapitre fonctionne.

Complément : `SideExpeditions.lua` (391 l., 6 expéditions) et `SuaireArc.lua`
(429 l., 5 actes) ajoutent du contenu optionnel lié à l'intrigue.

## 4. Monde vivant — deux régimes très différents

### Les fichiers de ville

| Ch | Lignes | PNJ interactifs | PNJ à variantes | Boîtes |
|---:|---:|---:|---:|---:|
| 5 | 181 | 24 | 0 | 110 |
| **6** | **6 981** | 47 | **33** | **2 631** |
| **7** | **6 844** | 54 | **33** | **2 820** |
| 8 | 1 136 | 53 | **0** | 216 |
| 9 | 1 101 | 53 | **0** | 194 |
| 10 | 647 | 53 | **0** | 144 |
| 11 | — | — | — | **fichier absent** |

Les ch6 et ch7 ont un vrai monde vivant : 33 PNJ avec dix variantes de
discussion chacun, réactives à l'avancement.

**Les ch8, 9 et 10 ont autant de PNJ interactifs (53) mais zéro variante.**
Chaque habitant y dit une seule phrase, quel que soit l'état du monde. C'est ce
qui explique l'écart : 2 820 boîtes au ch7 contre 144 au ch10, à effectif égal.

**`metano_town_ch_11.lua` n'existe pas** — la ville n'a aucun état pour le
chapitre de l'accusation, alors que c'est précisément le chapitre où elle se
retourne contre le héros.

### Les modules transverses

| Module | Lignes | Fiches | États |
|---|---:|---:|---:|
| `TownVoicesLate.lua` | 787 | 106 | 420 |
| `TownVoicesArc.lua` | 441 | 39 | 190 |
| `TownVoices.lua` | 357 | 27 | 130 |
| `TownVoicesNight.lua` | 361 | 60 | 118 |
| `TownLife.lua` | 342 | 29 | — |
| `TownNight.lua` | 446 | 4 | — |
| `TownPlace.lua` | 239 | 11 | — |

`TownVoicesArc.lua` couvre bien les ch8, 9 et 10 (2 états chacun) — c'est le
module que j'avais produit pour compenser. Mais 190 états répartis sur trois
chapitres ne remplacent pas les 33 PNJ à dix variantes du ch7.

## 5. Synthèse

**Ce qui va bien**
- Le chapitre 5 : 34 cinématiques qualitatives, référence du projet.
- Les quêtes secondaires : 3 par chapitre, écrites, avec double lecture.
- Le monde vivant des ch6 et ch7.

**Ce qui ne va pas**
- **0 cinématique qualitative aux ch9 et ch10.**
- La scène pivot du Suaire (`MarshVictory`) est un squelette.
- Le climax du Livre I (`PeakVictory`) est un squelette, et la scène Rayquaza
  qui devait le remplacer n'est jamais appelée.
- Les ch8-10 ont 53 PNJ chacun et aucune variante de dialogue.
- `metano_town_ch_11.lua` n'existe pas.
- Le ch7 a un rapport de 23 pour 1 entre dialogues de ville et cinématiques,
  alors qu'il doit accueillir l'arc Groudon.

**Le gisement le plus rentable** : mettre en scène les squelettes existants.
`MarshVictory`, `PeakVictory`, `GuildmasterAudience`, `GreatReunion`,
`FirstPreBossScene` du ch7 et `KirliaQuiz` totalisent environ 130 boîtes déjà
écrites qui ne demandent que caméras, déplacements et orientations — pas de
nouveau texte.

## Réserve

L'outil mesure la **présence** d'une mise en scène, pas sa qualité artistique.
Une scène classée « qualitative » peut être mal rythmée ; une scène classée
« squelette » est en revanche certainement dépourvue de mise en scène.

Rien n'est testé manette en main.
