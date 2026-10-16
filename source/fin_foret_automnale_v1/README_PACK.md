# FFA1 — Clairière finale de la Forêt automnale

Suite forestière après « la suite go », assortie à EFA1, sans supposer son approbation artistique.
Base d'édition PMDO 0.8.12, **768×576**, **96×72 cases de 8 px** (`TexSize=1`), huit calques + Top.
Namespace `fin_foret_automnale_v1`, Ground `ffa1_fin_foret_automnale`, graphiques `FFA1_*`.

## Référence et composition

Rip D24P11A (504×432), copié d'EFA1 avec la provenance : pret/pmd-sky commit
c8073235b39746a7ee74e6cea16c730bd91a1e67, skytemple-files 1.8.5, une frame, deux couches,
aucun BPA ni animation de palette. Empreintes du rendu et des blobs dans `reference/provenance.json`.
**Le rip reste vert ; l'automne est une interprétation inventée par génération référencée**,
pas un feuillage automnal officiel ni une recoloration scriptée d'EFA1. Nom de biome descriptif.

Nouveau décor 1200×896, rip et décor EFA1 réellement fournis dans `images=` : disposition
plus ouverte, lisière nord fermée, tronc fourchu au bord nord-ouest, mousse/litière et plages
de terre nue. Aucun objet central, grotte, structure ou passage nord. Le sol conserve un aspect
dallé par endroits ; ne pas faire passer le prompt pour une validation de conformité artistique.
Support de litière copié byte-à-byte d'EFA1, explicitement déclaré, non aligné sous les objets.
Ce n'est pas une nouvelle génération de sol ; le terrain visible vient du nouveau décor.
Prompt exact, sources, commits et empreintes dans `generation.json`.
**Pixels générés, pas des pixels ROM extraits ; seuls formats et grille sont natifs.**

## Diagnostic couleur : portée limitée

Même diagnostic qu'EFA1, appliqué sans changement aux tons chauds du bois/sol du rip et aux
bruts/sorties. Pas de comparaison des feuilles brunes avec les feuilles vertes officielles :
- `chauds_clairs` : R>120, G>80, 15<R-G<95, G-B>30, B<140 ;
- `chauds_sombres` : 35≤R≤120, 5<R-G<65, G-B>8, B<100.
Seuil RGB moyen **35**, sans recoloration ni hausse de seuil. Ces familles mélangent plusieurs
matières : elles n'attestent ni un feuillage automnal canonique, ni une identité des textures,
ni les raccords/volumes. Ne pas les comparer directement aux indices sol/végétation d'EFF1.
Politique explicite dans config, manifeste et aperçu.

## Calques et méthode

Du bas vers le haut : support complet, mousse/litière (`herbe`), terre nue (`terre`), ombres
existantes, sous-bois, zones de troncs/racines, feuillage, feuilles animées ; puis Top vide
(`DrawLayer.Top=4`). Pas de profondeur ni de bouche/à-plat noir sur cette fin.
Petites plantes et feuilles tombées restent avec les couches du sol, sans faux détourage promis.

Bois et feuilles étant bruns, leur séparation n'est pas faite par RGB : **huit polygones** de
troncs/racines sont relevés sur le nouveau brut, y compris la fourche nord-ouest. Zones d'édition,
pas détourage parfait de chaque branche. Test contre l'absorption de la canopée brune dans le bois.
Contour de sol propre à la fin, sous-bois bloquant sur une bande brute de 24 px ; ombres déjà
sombres du sol (luminance lissée 5 px <65), pas de voile ajouté. Aucun ancien lot/helper modifié.

Réduction BOX pondérée par classe, facteur uniforme 576/896, largeur 771 puis crop centré 768
(1 px à gauche, 2 à droite), palette terrain commune 96 sans dither. Alpha binaire, RGB nuls
sous transparence et partition sans trou/chevauchement.

## Animation et accès

Même loi qu'EFA1 : 24 émetteurs déterministes, 24 phases×5 ticks, boucle 2 s.
`k=(t+phase)%24`, visible k<18 ; `x=x0+round(4 sin(2 pi k/18))`, `y=y0+k-9` ; trois pixels
(0,0),(1,0),(1,1), clipping hors sol. Couleurs **bois/terre du rip**, pas de pixels de feuilles
officiels ; dessin et loi calculés, pas animation ROM. Le champ hérité `dust` décrit cet effet.

Trois marqueurs : arrivée sud, `boss` central non nommé et `objectif` devant la lisière nord.
Le repère boss n'instancie aucun Pokémon. Chemins avec dégagement 16×16, centre éloigné des
bords, aucun warp, seuil de donjon, PNJ, destination ou sortie. Collisions conservatrices à vérifier en jeu.

## Contrôles techniques exécutés

**15 tests PASS**, dont cinq mutations rejetées et un contrôle des zones de troncs.
**31 images reconstruites exactement** depuis huit banques natives. Même diagnostic et loi
de feuilles qu'EFA1, support copié et seconde référence vérifiés par empreinte.
Diagnostic final limité aux tons chauds : clairs **31,33**, sombres **31,57**, seuil 35.
Marqueurs : arrivée `[384,560]`, repère boss `[448,328]`, objectif `[384,160]` ; accès 16×16.
Ces contrôles ne constituent ni un test moteur ni une validation artistique.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/fin_foret_automnale_v1/requirements.txt
.venv/bin/python source/fin_foret_automnale_v1/build.py
.venv/bin/python -m unittest source.fin_foret_automnale_v1.test_build -v
.venv/bin/python source/fin_foret_automnale_v1/verify.py
.venv/bin/python source/fin_foret_automnale_v1/check_reproducibility.py
.venv/bin/python source/fin_foret_automnale_v1/package.py
```

Build dédié, pas CLI minérale générique ; codecs `source/pmdo_cote/`, helpers EDR1 dans une
instance isolée et gabarit réel 0.8.12 sous `source/cote_v5_expeditions/references/`.
Build hors ligne depuis les bruts versionnés. Vérificateur indépendant : relit les PNG des
banques .tile et reconstruit via le Ground, **pas le vrai chargeur PMDO**. Mutations sur copies.

## Livrer et installer

Sorties régénérables dans `renders/fin_foret_automnale_v1/`, staging sous `.cache/`.
`FFA1_projet_pmdo_0812.zip`, `FFA1_calques_png_8px.zip`, `index.html`, PNG/ORA et contrôles.
Médias lourds ignorés par Git, build puis package pour les retrouver.
Extraire le dossier du projet dans `PMDO/MODS/`, activer et ouvrir le Ground.
Fusion : fermer PMDO, extraire le ZIP, `python INSTALLER.py /chemin/mod --dry-run`, puis sans
`--dry-run`. Index fusionné avec sauvegarde, fichiers utilisateur modifiés protégés.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms uniques `FFA1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni chargeur réel, ni éditeur, ni caméra/échelle, rendu ou déplacements exécutés.
Tests Python ≠ validation artistique ou moteur. Résultats exécutés dans `STATUS.md`.
