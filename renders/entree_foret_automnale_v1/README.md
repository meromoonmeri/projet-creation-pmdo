# EFA1 — Entrée de la Forêt automnale

Nouvelle proposition forestière après « LA SUITE », distincte des cartes EFF1/FFF1.
PMDO 0.8.12, **768×576**, **96×72 cases de 8 px** (`TexSize=1`), neuf calques + Top vide.
Namespace `entree_foret_automnale_v1`, Ground `efa1_entree_foret_automnale`, graphiques `EFA1_*`.
Pas une aventure jouable raccordée, aucune approbation artistique supposée.

## Référence et palette : distinction importante

Rip D24P11A (504×432), copié d'EFF1 avec sa provenance : pret/pmd-sky commit
c8073235b39746a7ee74e6cea16c730bd91a1e67, skytemple-files 1.8.5, une frame, deux couches,
aucun BPA ni animation de palette. Empreintes et blobs dans `reference/provenance.json`.
Le rip **reste vert**. La saison automnale est **inventée par le générateur**, pas une variante
officielle du jeu, ni une recoloration scriptée d'EFF1. Le nom de biome est descriptif.

Deux générations nouvelles avec le rip réellement fourni en `images=` : décor et support de
litière, 1200×896 chacun. Prompts exacts et empreintes dans `generation.json`. Support indépendant
non aligné ; sol visible issu du décor. La courbe du chemin diffère de l'intention du prompt et
conserve un aspect de terre dallée ; ne pas prétendre à une conformité artistique parfaite.
Terrain généré référencé, **pas des pixels officiels extraits** ; formats et grille natifs seulement.

Le diagnostic RGB emploie les tons chauds déjà présents dans le **bois/sol** du rip, sur les
mêmes règles pour référence/brut/sortie, pas ses feuilles vertes comme cible du feuillage brun :
- `chauds_clairs` : R>120, G>80, 15<R-G<95, G-B>30, B<140 ;
- `chauds_sombres` : 35≤R≤120, 5<R-G<65, G-B>8, B<100.
Seuil de distance moyenne **35**, sans recoloration ni hausse de seuil. Ces classes mélangent
plusieurs matières et n'attestent **ni un feuillage automnal canonique ni une identité des textures**.
La politique est explicite dans la config et le manifeste. Pas de certification de raccords ou volumes.

## Calques et méthode

Du bas vers le haut : support complet, mousse/litière (`herbe`), chemin, ombres existantes,
sous-bois, zones de troncs/racines, feuillage, profondeur forestière dessinée, feuilles animées,
puis Top vide (`DrawLayer.Top=4`). Petites plantes et feuilles tombées restent avec les couches du sol.

En automne, **bois et feuillage sont tous deux bruns** : une règle RGB ne peut les séparer.
Les troncs/racines sont donc relevés par sept polygones sur le brut, dans `trunk_polygons_raw`.
Ce sont des zones d'édition mesurées, pas un détourage sémantique parfait de chaque branche.
Un test vérifie que la canopée brune n'est pas absorbée dans le calque des troncs.
Contour de sol et profondeur également relevés sur ce nouveau rendu. Sous-bois : bande de 24 px.
Ombres : zones sombres déjà dessinées, luminance lissée 5 px <65, pas un voile ajouté.

Réduction BOX pondérée par classe, facteur uniforme 576/896, largeur 771 puis crop centré 768
(1 px à gauche, 2 à droite), palette commune 96 sans dither ; profondeur quantifiée séparément,
sans remplacement par un aplat noir. Alpha binaire, RGB nuls sous transparence, partition sans trou.
Aucun ancien lot ni helper commun modifié.

## Animation et accès

Feuilles calculées sur un calque indépendant : 24 émetteurs, 24 phases×5 ticks, boucle 2 s.
`k=(t+phase)%24`, visible k<18 ; `x=x0+round(4 sin(2 pi k/18))`, `y=y0+k-9` ; trois pixels
(0,0),(1,0),(1,1), clipping au sol. Couleurs chaudes **bois/terre du rip**, ni dessin ni animation
ni pixels de feuilles officiels. Le rip est statique. Le champ `dust` du manifeste est hérité
et son label décrit les feuilles calculées, pas de la poussière.

Arrivée sud, seuil forestier nord et chemin avec dégagement 16×16. Le seuil est un marqueur,
pas un téléporteur. Aucun warp, boss choisi, PNJ ou destination. Collisions conservatrices à vérifier en jeu.

## Contrôles techniques exécutés

**15 tests PASS**, dont cinq mutations rejetées et un test de séparation des zones de troncs.
**32 images reconstruites exactement** depuis neuf banques. Diagnostic final sur tons chauds :
clairs **27,48**, sombres **32,15**, seuil 35. Ces deux indices ne se comparent pas directement
aux mesures sol/végétation des lots verts antérieurs. Arrivée `[384,560]`, seuil `[384,160]`,
accès avec dégagement 16×16 ; ceci ne constitue pas une validation dans le moteur.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_foret_automnale_v1/requirements.txt
.venv/bin/python source/entree_foret_automnale_v1/build.py
.venv/bin/python -m unittest source.entree_foret_automnale_v1.test_build -v
.venv/bin/python source/entree_foret_automnale_v1/verify.py
.venv/bin/python source/entree_foret_automnale_v1/check_reproducibility.py
.venv/bin/python source/entree_foret_automnale_v1/package.py
```

Build dédié, pas CLI minérale générique ; codecs `source/pmdo_cote/`, helpers EDR1 dans une
instance isolée et gabarit réel 0.8.12 conservé sous `source/cote_v5_expeditions/references/`.
Build hors ligne depuis les bruts versionnés. Vérificateur indépendant : relit les PNG des .tile
et reconstruit via le Ground, **pas le vrai chargeur PMDO**. Mutations sur copies temporaires.

## Livrer et installer

Sorties régénérables dans `renders/entree_foret_automnale_v1/`, staging sous `.cache/`.
`EFA1_projet_pmdo_0812.zip`, `EFA1_calques_png_8px.zip`, `index.html`, PNG/ORA et contrôles.
Médias lourds ignorés par Git ; build puis package pour les retrouver.
Extraire le dossier projet dans `PMDO/MODS/`, activer le mod et ouvrir le Ground.
Pour fusionner : fermer PMDO, extraire le ZIP, lancer `python INSTALLER.py /chemin/mod --dry-run`
puis sans `--dry-run`. Index fusionné avec sauvegarde, fichiers utilisateur modifiés protégés.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms uniques `EFA1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Aucun test du chargeur réel, de l'éditeur, de la caméra/échelle, du rendu ou des déplacements.
Tests Python ≠ approbation artistique ou moteur. Résultats exécutés dans `STATUS.md`.
