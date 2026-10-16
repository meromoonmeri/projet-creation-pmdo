# Entrée Crevasse enneigée sud → nord V1 (ECE1)

Nouvelle entrée de donjon de la série **sud → nord**, au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`). Elle répond à la demande du 16 octobre 2026, « Fait la zone de fin et passe enuite au prochaine map ! », juste après la fin [FGV1](../fin_grotte_vasques_v1/README.md). Le biome est neuf, choisi par l'agent parmi les maps ROM libres, et reste **à confirmer**. « Glace » figure parmi les biomes demandés par l'utilisateur : « passer aux prochains biomes : Ruine Légendaire, Glace, Apple Woods, … ».

- Aperçu autonome : [`apercu_entree_crevasse_enneigee_sud_nord_v1.html`](../../apercu_entree_crevasse_enneigee_sud_nord_v1.html)
- Sources : [`source/entree_crevasse_enneigee_sud_nord_v1/`](../../source/entree_crevasse_enneigee_sud_nord_v1/) (`reference.py`, `build.py`, `test_build.py`, `mutations.py`, `package.py`)
- Livrables, régénérés par `build.py` puis `package.py` :
  - `ECE1_projet_pmdo_0812.zip` : projet PMDO 0.8.12 (Ground, banques `.tile`, `index.idx`, `Mod.xml`, `init.lua`, `INSTALLER.py`) ;
  - `ECE1_calques_png_8px.zip` : calques, frames, poses, masques, ORA, manifeste et référence ROM.

## Composition

On arrive au **sud** sur un chemin de neige abaissé, bordé de deux bancs aux corniches rocheuses lavande. Les bancs sont parsemés de boules de neige. Sur les côtés s'ouvrent de larges clairières en terrasses. Le chemin s'élargit en parvis au pied d'une **grande falaise de glace** qui ferme tout le nord. Au centre, une **crevasse sombre** fend la falaise ; son sol en dégradé descend vers la bouche, entre deux parois écaillées et deux grappes de cristaux. Il n'y a aucune eau, si bien que rien ne se trouve devant la bouche là où l'on marche.

## Méthode (générateur + pipeline natif)

1. **Référence** : le rip ROM `D79P11A`, une falaise de glace lavande avec de la neige et des boules de neige. Il est extrait par `reference.py` depuis `pret/pmd-sky` (provenance et sha256 dans `references/provenance.json`). Aucune branche des deux dépôts n'utilise ce code. Son BPL n'anime rien : `palette_anim.json` est vide.
2. **Générateur** (`images=[D79P11A]`) :
   - `decor.png` : 1200 × 896, obtenu au premier essai ;
   - `source_poses.png` : planche sur magenta, avec 6 flocons et 6 phases d'éclat de givre, obtenue au premier essai.
3. **Sol complet** : deux éditions du générateur depuis le décor ont été **écartées** (prompts et défauts consignés dans le manifeste) :
   - la première donnait du bruit, des taches sombres et des restes de corniches (écart 13,4) ;
   - la seconde donnait de grandes taches bleues (écart 22,7).

   Il est donc **construit par le pipeline** : la neige praticable du décor, et le blanc du rip (255, 255, 255, sa couleur la plus fréquente) partout ailleurs.
4. **Pipeline natif** (`build.py`) :
   - segmentation pleine résolution :
     - neige : blanc, lavande claire ou ombre lisse avec b − r ≤ 45, alors que la roche est à 50–70 ;
     - sol de la grotte : trapèze lisse sous la bouche ;
     - bouche ;
     - falaises : au-dessus du pied, défini comme le premier pixel praticable de chaque colonne ;
     - corniches : en dessous ;
   - réduction ×0,643 par classe (BOX, attribution exclusive) ;
   - **toutes les couleurs ramenées aux 103 couleurs exactes du rip** (plus proche RGB ; écart moyen du brut 3,52, q99 10) ;
   - Ground PMDO 0.8.12 sur le gabarit `cliffdaytest.rsground`.
5. **Boules de neige** : la plupart ont des contours clairs et se fondent dans la neige. Un calque « congères » aurait été incohérent, avec certaines boules bloquantes et d'autres non. Elles restent donc peintes sur la neige, comme le relief du rip, et leurs 62 petits contours sombres sont rendus aux ombres.

## Calques

| # | Calque | Contenu | Animation |
|---|---|---|---|
| 00 | `sol_complet` | neige bord à bord | fixe |
| 01 | `neige` | neige blanche praticable | fixe |
| 02 | `ombres` | neige ombrée, boules de neige, sol de la grotte | fixe |
| 03 | `corniches` | rebords rocheux des bancs | fixe |
| 04 | `falaises` | falaise de glace, cristaux, parois de la crevasse | fixe |
| 05 | `profondeur` | bouche de la crevasse | fixe |
| 06 | `scintillements` | 16 éclats sur la glace de ton moyen (lum 150–215), 4 à 70 px au-dessus du pied | 48 × 4 ticks |
| 07 | `flocons` | 72 flocons (graine 1979) : chute de 40 à 80 px en ondulant, puis un point posé sur la neige | 48 × 4 ticks |
| 08 | Top | vide, `Layer=4` | — |

La scène boucle en 192 ticks (3,2 s). Les calques fixes forment une partition exacte de la carte, sans aucun alpha intermédiaire. Les poses sont réduites par 24 pour les flocons, soit 1 à 5 px, et par 15 pour les éclats, jusqu'à une étoile de 9 × 9 px. Leurs couleurs sont aussi celles du rip.

## Mesures

- **Fidélité au rip `D79P11A`** (même classifieur des deux côtés, seuil 35) :
  - brut : neige 0,2, ombre 1,3, roche 12,4 ;
  - calques finaux : neige 1,4, ombres 6,6, falaises 10,0, corniches 30,3. Les corniches sont plus claires que la roche moyenne du rip, mais restent sous le seuil.
- **Accès** :
  - `entrance` (384, 560) au sud, dans le chemin central ;
  - `donjon_seuil` (376, 264) sur le pas de la crevasse ;
  - chemin 16 × 16 recalculé par les tests sur la grille du Ground ;
  - 3 231 cases praticables sur 6 912 ; la falaise ferme les 25 premières rangées ;
  - aucun warp.
- **Ground** : 8 banques, 9 724 tuiles. L'aller-retour `.tile` → image est vérifié pour chaque calque.

## Tests

13 tests passent (`.venv/bin/python -m unittest source.entree_crevasse_enneigee_sud_nord_v1.test_build -v`). Ils couvrent :

- empreintes et référence ROM ; deux éditions écartées consignées, sans aucun brut écarté gardé ;
- segmentation **et** sol complet **recalculés** depuis le brut ;
- tailles, alpha et absence de magenta ;
- partition des calques, sans aucune eau ;
- **palette exacte du rip pour tous les calques et toutes les phases** ;
- fidélité ;
- poses recalculées depuis la planche ;
- scintillements recalculés, avec la boucle fermée ;
- flocons recalculés depuis la graine, avec une chute jamais vide ;
- ORA (date fixe, `mimetype` en tête) et scène ;
- accès : arrivée au sud, seuil sur le pas de la bouche, obstacles égaux aux calques, chemin recalculé ;
- unicité du préfixe ;
- aller-retour du Ground, avec seulement `entrance` et `donjon_seuil`, et aucun warp dans `init.lua`.

**29 mutations** sont toutes détectées (`mutations.py`). Elles incluent notamment :

- neige ou flocon hors palette du rip ;
- ombres blanchies ;
- bouche éclaircie ;
- éclat figé ;
- flocons placés à la main ;
- entrée dans une corniche ;
- seuil loin de la bouche ;
- falaise ouverte ;
- warp ajouté ;
- échecs du sol complet cachés.

## Limites (honnêtes)

- `art_approved: false`, `runtime_tested: false` : aucune revue artistique validée, aucun test dans PMDO.
- Le terrain est **généré** à partir du rip. Ce ne sont pas des tuiles natives : seules les **couleurs** sont exactes. Les falaises du décor répètent un motif en bandes, comme le générateur l'a dessiné.
- Les **boules de neige** sont praticables, peintes sur la neige. Seules les corniches, les falaises et la bouche bloquent.
- Les **flocons** et les **éclats** viennent d'une planche générée. Leur chronologie est créée par nous, car le rip est statique ; ce n'est pas une animation officielle.
- La zone de fin (`FCE1`, préfixe réservé) n'est pas encore faite ; aucun script ni donjon n'est fourni.
