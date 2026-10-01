# Étude — animations canoniques d'eau et de magma (PMD Explorateurs du Ciel) et leur portage PMDO

- **Demande** : « j'aimerais que tu regardes les animations canoniques des maps magma / de l'eau, par exemple sur la map **S01P02A** » (dépôt `meromoonmeri/PMD-SKY-PMDO-PORT`), 27 septembre.
- **Nature** : une **étude**, pas une carte de la série. Aucun pixel n'est copié dans les lots de la série.
- **Aperçu** : `apercu_etude_animations_canoniques_sky_v1.html` (racine). Il rejoue côte à côte la piste exacte et la piste du port, avec la formule du moteur.
- **Source** : `source/etude_animations_canoniques_sky_v1/` (`etude.py`, `test_etude.py`, `viewer_template.html`), 9 tests.

## Sources, figées par commit

| Source | Dépôt | Commit | Usage |
|---|---|---|---|
| Fichiers de la ROM | `pret/pmd-sky`, `files/MAP_BG` | `c8073235` | `.bpl` (palettes et animation de palette), `.bpc` (tuiles), `.bma` (disposition), `.bpa` (tuiles animées). Téléchargés dans `.cache`, jamais versionnés ici ; sha256 au rapport |
| Port PMDO | `meromoonmeri/PMD-SKY-PMDO-PORT` | `d62110a0` | Grounds, banques `.tile` et aperçus de s01p02a, d41p41a, v03p08a, pour l'audit |
| Moteur | `RogueCollab/RogueEssence` | `ee6811c2` | `TileLayer.Draw` : `currentFrame = totalTick / FrameToTick(FrameLength) % Frames.Count` |

Lecture des formats avec `skytemple-files` (installé dans `.venv`, pas versionné).

## Comment le jeu anime l'eau et la lave

Deux mécanismes indépendants :

1. **Animation de palette (BPL)** : c'est celle de l'eau et de la lave. Les pixels ne bougent pas ; leurs couleurs tournent. Chaque palette animée a une suite de jeux de 15 couleurs (les « crans ») et une durée par cran, en frames à 60 par seconde.
2. **Tuiles animées (BPA)** : plusieurs versions de chaque tuile, chacune avec sa durée. Sur s01p02a, ce sont les fleurs qui se balancent.

Le moteur RogueEssence affiche une piste de tuile par `totalTick / FrameLength % nombre de frames`, sur une horloge globale, en frames à 60 par seconde, comme la DS. **Une piste PMDO reproduit donc exactement l'animation du jeu si `FrameLength` = durée NDS, et si la suite des frames garde ses répétitions et son ordre.**

Inventaire des 472 BPL de la ROM : **110 cartes** ont une animation de palette, dont **48 à dominante d'eau** et **8 de magma** (teinte moyenne des couleurs animées ; règle au rapport). 85 fichiers BPA. Détail : `inventaire_animations_sky.json`.

## Les trois cartes étudiées

| Carte | Rôle | Palettes animées | BPA | Boucle |
|---|---|---|---|---|
| **s01p02a** | eau : mer de la clairière tropicale | n° 7 et 8 : 10 crans × 10 frames | 88 tuiles, 4 crans × 12 frames (fleurs) | 1200 ticks (20 s) |
| **d41p41a** | magma : arène cernée de lave | n° 10 et 11 : 13 crans × 10 | aucun | 130 ticks |
| **v03p08a** | magma : scène de lave | n° 12 : 10 crans × 12 ; n° 13 : 20 crans × 8 | aucun | 480 ticks (8 s) |

- **Mer de s01p02a** : une vraie **rotation**. Les entrées 1 à 10 de la palette 7 avancent d'un cran à chaque frame (test) ; les entrées 11 à 13 pulsent à part. La palette 8 suit une autre suite, pour l'écume. La mer et les fleurs n'ont aucun pixel en commun (test).
- **Magma** : même principe. Sur d41p41a, la lave tourne sur 13 crans ; dans 1779 cases, le 13e redonne le 1er. Sur v03p08a, 826 cases font un **aller-retour** 0‑1‑2‑3‑4‑5‑4‑3‑2‑1, une lueur qui respire.
- `cartes/<carte>_cycles_palette.png` : une ligne par cran, 15 couleurs ; la rotation se voit en diagonales. `cartes/<carte>_vrai_<boucle>ticks.webp` : l'animation à sa vraie vitesse, tick par tick.

**Rendu de vérité** : image indexée de skytemple (`bma.to_pil(..., pal_ani=False)`, une image par cran de BPA), plus les palettes du tick t (cran de chaque palette = `t // durée % nombre`). À t = 0, il est identique pixel à pixel à l'aperçu publié par le port (test, pour les trois cartes).

## Pistes exactes

Pour chaque case de 8 px, l'étude calcule la piste PMDO minimale qui reproduit la vérité : `FrameLength` = PGCD des instants de changement, puis la suite des frames, **sans déduplication**, raccourcie seulement si elle se répète en entier. Chaque piste est vérifiée tick par tick sur deux boucles (test).

| Carte | Pistes exactes (frames × ticks) | Motifs par case les plus fréquents (crans égaux en pixels) |
|---|---|---|
| s01p02a | mer 10 × 10 (871 cases) ; fleurs 4 × 12 (246) | mer 0‑…‑9 (839) ; fleurs 0‑1‑0‑2 (185), 0‑1‑2‑1 (27), 0‑1‑0‑0 (23), 0‑1‑2‑3 (11) |
| d41p41a | 13 × 10 (3113) | 0‑…‑11‑0 (1779), 0‑0‑1‑…‑10‑0 (745), aller-retour 0‑0‑1‑2‑3‑4‑5‑4‑3‑6‑1‑0‑0 (515) |
| v03p08a | 10 × 12 (936) ; 10 × 8 (94) ; 20 × 8 (42) | 0‑1‑2‑3‑4‑5‑4‑3‑2‑1 (826) |

Aucune case ne mélange deux rythmes sur ces cartes : chaque case n'a besoin que d'une piste.

## Audit du Ground publié par PMD-SKY-PMDO-PORT

Le convertisseur du port (`tools/convert_nds_map.py`) prend l'aperçu de skytemple (`to_pil(..., pal_ani=True)`). Cet aperçu avance tout **à pas égaux** : une image par entrée de la table de palettes (20 pour s01p02a, 26 pour d41p41a), le BPA avançant d'un cran à chaque image. skytemple le signale lui-même : il « ne tient pas compte des vitesses ». Ensuite, dans chaque case, le port ne garde que les **frames uniques, dans l'ordre de première apparition**, avec `FrameLength = 10` partout. Un test le prouve : cette recette redonne **exactement** toutes les pistes des trois Grounds du port.

Conséquences, mesurées case par case sur le PPCM des deux pistes :

| Carte | Cases animées | Cases fausses | Temps faux moyen | Cause |
|---|---|---|---|---|
| s01p02a | 1117 | 278 | 16,7 % | mer juste à 97 % (seules 32 cases de bord, aux couleurs répétées, dérivent) ; **fleurs fausses 65,5 % du temps** : 0‑1‑0‑2 devient 0‑1‑2, et 10 ticks au lieu de 12 |
| d41p41a | 3113 | 3052 | **88,7 %** | 13 crans ramenés à 12, 11, 8, 7 ou 6 selon la case : chaque case dérive à son rythme, la lave « grouille » au lieu de tourner |
| v03p08a | 1072 | 1072 | **71,7 %** | aller-retour de 10 crans ramené à 6, et 10 ticks au lieu de 12 ou 8 |

`audit/<carte>_audit_port.png` : cases fausses en rouge (plus vif = plus souvent fausses), pixels animés par palette en bleu, par BPA en magenta.

**Correction** (non appliquée au dépôt du port, qui n'est pas celui-ci) : construire chaque piste depuis la vraie ligne du temps (durée NDS de chaque source, crans répétés gardés), comme `exact_track` ici. Si une case mêlait deux rythmes, il faudrait soit une piste au PGCD des durées, soit une piste par source sur deux calques.

## Ce que cela change pour nos cartes

- **Eau et lave canoniques = rotation de palette.** Pour la série (rendu généré référencé), on peut ramener les pixels d'eau ou de lave générés à des **index de la palette animée** de la ROM, puis faire tourner exactement ses crans, ses couleurs et ses durées. C'est la même idée que la rampe du rayon d'EJS1, mais avec le vrai cycle du jeu.
- **s01p03a** (la capture d'ETC1) a **la même animation de palette que s01p02a**, octet pour octet (vérifié). La mer d'ETC1 (vagues qui montent de 2 px) n'est donc pas l'animation canonique ; une ETC2 pourrait reprendre le vrai cycle 10 × 10.
- **Pistes** : toujours `FrameLength` = durée du jeu, et **jamais** de déduplication qui casse l'ordre ou les répétitions.

## Tests : 9 PASS, 4 mutations vérifiées

Mutations détectées : temps faux du magma changé au rapport ; motif des fleurs changé au rapport (détecté après l'ajout du test « rapport = recalcul », parce que le test des fleurs lisait le rapport recalculé) ; une piste du Ground du port inversée ; `FrameLength` d'une piste exacte changé dans l'aperçu. L'aperçu a aussi été rejoué hors navigateur (node) : nombre moyen de cases différentes par tick identique à l'audit Python (186,6 contre 186,5 sur s01p02a). **Pas de test dans PMDO.**

Étude en environ 20 s (hors premier téléchargement).
