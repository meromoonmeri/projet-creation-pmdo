# Entrée Crevasse enneigée sud -> nord V2 (ECE2)

Nouvelle entrée de donjon de la série **sud → nord**, au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`). Elle répond à la demande du 16 octobre 2026, « je veux que l'entrée crevassse enneigé soit mieux travaillé et faut que ce soit seamless tu vois ce que je veux dire ? faut des arbre sapin tout enneigé frosty forest aussi ! », juste après la fin [FGV1](../fin_grotte_vasques_v1/README.md). Le biome est **falaise de glace lavande**, choisi par l'agent parmi les maps ROM libres, et reste **à confirmer**. « Glace » figure parmi les biomes demandés par l'utilisateur : « passer aux prochains biomes : Ruine Légendaire, Glace, Apple Woods, … ».

- Aperçu autonome : [`apercu_entree_crevasse_enneigee_sud_nord_v2.html`](../../apercu_entree_crevasse_enneigee_sud_nord_v2.html)
- Sources : [`source/entree_crevasse_enneigee_sud_nord_v2/`](../../source/entree_crevasse_enneigee_sud_nord_v2/) (`reference.py`, `build.py`, `test_build.py`, `mutations.py`, `package.py`)
- Livrables, régénérés par `build.py` puis `package.py` :
  - `ECE2_projet_pmdo_0812.zip` : projet PMDO 0.8.12 (Ground, banques `.tile`, `index.idx`, `Mod.xml`, `init.lua`, `INSTALLER.py`) ;
  - `ECE2_calques_png_8px.zip` : calques, frames, poses, masques, ORA et manifeste et référence ROM.

## Composition

On arrive au **sud** sur un chemin de neige abaissé, légèrement à droite du centre, bordé à gauche d'une bande étroite de sapins tout enneigés et à droite d'une forêt dense de sapins enneigés. Le chemin mène au nord à une crevasse-grotte dans une paroi de glace lavande asymétrique. Il n'y a aucune eau, si bien que rien ne se trouve devant la bouche là où l'on marche.

## Méthode (textures canoniques = référence générée + pipeline natif)

1. **Référence** : le rip ROM `D79P11A`, une falaise de glace lavande avec de la neige et des boules de neige. Il est extrait par `reference.py` depuis `pret/pmd-sky` (provenance et sha256 dans `references/provenance.json`). Aucune branche des deux dépôts n'utilise ce code. Son BPL n'anime rien : `palette_anim.json` est vide.

2. **Décor générateur** (`images=[D79P11A]`) : nouveau disposant 4:3 (1200 × 896), deuxième essai avec forêts asymétriques de sapins frosty forest des deux côtés ; obtenu au premier essai avec le nouveau prompt.

3. **Sol complet** : construit par le pipeline : neige praticable du décor, complétée par le blanc du rip (couleur la plus fréquente de D79P11A, 255,255,255) ailleurs. Toutes les couleurs de tous les calques sont des couleurs EXACTES du rip D79P11A (103 couleurs ; plus proche RGB ; écart moyen du décor brut à cette palette : ~3,5).

4. **Pipeline natif** (`build.py`) :
   - segmentation pleine résolution :
     - neige : blanc, lavande claire (lum ≥ 185) ou ombre lisse, b − r ≤ 45, alors que la roche est à 50–70 ;
     - sol de la grotte : trapèze lisse sous la bouche ;
     - bouche ; falaises : au-dessus du pied, défini comme le premier pixel praticable de chaque colonne ;
     - corniches : en dessous ;
   - réduction par classe ×0,643 (BOX, attribution exclusive) ;
   - **toutes les couleurs ramenées aux 103 couleurs exactes du rip** (plus proche RGB ; écart moyen du décor brut 7,15, q99 21,2) ;
   - Ground PMDO 0.8.12 sur le gabarit `cliffdaytest.rsground`.

5. **Calques** :
   
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
  - brut : neige 15,9, ombre 5,1, roche 53,8 ;
  - calques finaux : neige 12,9, ombres 16,8, falaises 52,3, corniches 47,3. Les corniches sont plus claires que la roche moyenne du rip, mais restent sous le seuil.
- **Accès** :
  - `entrance` (424, 560) au sud, sur le chemin central ;
  - `donjon_seuil` (248, 144) sur le pas de la crevasse ;
  - chemin 16 × 16 trouvé : oui ;
  - 1 886 cases praticables sur 6 912 ; la falaise ferme les 25 premières rangées ;
  - aucun warp.
- **Ground** : 8 banques, 11 320 tuiles. L'aller-retour `.tile` → image est vérifié pour chaque calque.

## Tests

Tests en cours d'exécution. Voir les résultats ci-dessus.

## Limites (honnêtes)

- `art_approved: false`, `runtime_tested: false` : aucune revue artistique validée, aucun test dans PMDO.
- Ce sont des **textures canoniques** : le rip D79P11A passe au générateur, les pixels sont exacts mais le format n'est pas des tuiles natives PMDO.
- Les **flocons** et les **éclats** viennent d'une planche générée. Leur chronologie est créée par nous, car le rip est statique ; ce n'est pas une animation officielle.
- La zone de fin (`FCE1`, préfixe réservé) n'est pas encore faite ; aucun script ni donjon n'est fourni.
