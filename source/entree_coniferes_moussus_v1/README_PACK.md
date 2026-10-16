# ECM1 — Entrée de la Forêt de conifères moussus

Suite forestière après « continue », suivant FFA1. Nouvelle proposition de conifères, sans
supposer d'approbation des cartes précédentes. Aucun ancien lot remplacé ou fusionné.
Namespace `entree_coniferes_moussus_v1`, Ground `ecm1_entree_coniferes_moussus`, graphiques `ECM1_*`.

## Référence et origine

Rip D24P11A, 504×432, pret/pmd-sky commit c8073235b39746a7ee74e6cea16c730bd91a1e67.
Rendu skytemple-files 1.8.5 : une frame, deux couches, aucun BPA ni animation de palette.
Référence et provenance copiées d'EFF1 ; hashes des blobs conservés dans `reference/provenance.json`.
**Ce rip montre des feuillus : les conifères sont inventés**, pas des sprites officiels de sapins.
Le nom du biome est descriptif, sans identification officielle supposée à partir du code ROM.

Deux nouvelles générations réussies au premier appel, le rip réellement fourni dans `images=` :
décor et support de mousse/litière, 1200×896 chacun. Prompts exacts, dimensions et empreintes dans
`generation.json`. Pas de collage de bouts de maps, pas de recoloration scriptée du terrain.
Conifères étagés, racines sur les côtés, sentier en S et clairière ouverte au centre/sud ; la
trace de terre continue visuellement au nord sans grotte, structure ou aplat noir. Conifères
plus stylisés que le rip, mousse assez unie, terre encore un peu dallée : aucune conformité
parfaite au prompt ou approbation artistique revendiquée.
**Pixels générés ; seuls les formats et la grille sont natifs.**

## Format et calques

768×576, grille 8 px, 96×72 cases, `TexSize=1`, PMDO 0.8.12. Neuf calques puis Top vide :
sol complet, mousse (`herbe`), terre (`chemin`), ombres existantes, sous-bois, troncs/racines,
feuillage, profondeur dessinée, aiguilles animées. Top : `DrawLayer.Top=4`.

Contours relevés sur ce nouveau décor dans `config.json` : espace de sol et prolongement nord.
Bande bloquante de sous-bois 24 px bruts ; ombres du sol déjà dessinées, luminance lissée 5 px
<65 ; terre par différence R-G/G-B, troncs par tons chauds hors sol et bande. Petites fougères
et détails du sol restent avec mousse/ombres ; zones d'édition, pas détourage parfait promis.
Support indépendant non aligné, caché sous la partition complète du décor visible.

Réduction BOX pondérée par classe, facteur uniforme 576/896, largeur 771 recadrée à 768
(1 px à gauche, 2 à droite). Terrain : palette commune de 96 couleurs sans dither ; profondeur
quantifiée séparément en gardant les volumes dessinés, aucun remplissage noir. Alpha binaire,
RGB nuls sous transparence ; partition terrain exacte sans trou ou chevauchement.
Codecs et helpers communs inchangés ; utiliser le build dédié, pas la CLI minérale générique.

## Diagnostic couleur et portée

Même diagnostic RGB qu'EFF1, inchangé sur rip, brut et sortie :
- sol chaud : R>120, G>80, 15<R-G<95, G-B>30, B<140 ;
- végétation : G>1,1R, G>1,25B, G>50, B<160.
Seuil de distance RGB moyenne **35 inchangé**, sans recalage de couleur. Ce diagnostic ne
certifie ni la forme de conifères, ni les textures, les volumes, raccords ou échelle en jeu.

Couverture minimale des échantillons testés : **5 % sol / 10 % végétation**, contre 10 %/10 %
dans EFF1. Le sentier de terre occupe seulement 8,63 % du brut ECM1 avec ces mêmes masques.
Cette adaptation explicite du test de représentativité ne change ni les familles de couleur
ni le seuil 35. Scores brut : sol 23,54 / végétation 27,09 ; sortie : **21,22 / 28,13**.

## Animation et accès

Aiguilles calculées : 24 émetteurs déterministes, 24 phases×5 ticks, boucle 2 s.
`k=(t+phase)%24`, visible k<18, `x=x0+round(4 sin(2 pi k/18))`, `y=y0+k-9`.
Deux pixels diagonaux (0,0),(1,1), et non les trois pixels des feuilles EFF1.
Quatre couleurs vertes prélevées dans le rip, clipping hors sol praticable. Loi et dessin
recalculés : ce n'est ni un sprite de conifère ni une animation officielle. Le champ de
manifeste hérité `dust` désigne cet effet. Pas de brume ou de rayons ajoutés.

Arrivée `[384,560]`, seuil `[384,168]`, accessibles avec dégagement 16×16. Le prolongement
nord est une couche dessinée bloquante derrière ce marqueur, pas une destination raccordée.
Aucun warp, boss, Pokémon, PNJ ou objet instancié. Collisions conservatrices, à contrôler en jeu.

## Contrôles exécutés

**14 tests PASS**, dont cinq mutations rejetées ; **32 images reconstruites exactement** depuis
neuf banques relues indépendamment. Provenance, masques, accès, Top, alpha, cadence et loi
d'animation contrôlés. Installateur : simulation sans écriture, fusion/sauvegarde de l'index,
idempotence et protection contre l'écrasement d'une carte utilisateur modifiée.
Tests destructifs exclusivement sur copies temporaires. Pas le vrai chargeur PMDO.
Résultats de reproductibilité et livraison dans `STATUS.md`.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_coniferes_moussus_v1/requirements.txt
.venv/bin/python source/entree_coniferes_moussus_v1/build.py
.venv/bin/python -m unittest source.entree_coniferes_moussus_v1.test_build -v
.venv/bin/python source/entree_coniferes_moussus_v1/verify.py
.venv/bin/python source/entree_coniferes_moussus_v1/check_reproducibility.py
.venv/bin/python source/entree_coniferes_moussus_v1/package.py
```

Build hors ligne depuis les bruts versionnés. Helpers EDR1 chargés dans une instance isolée,
codecs `source/pmdo_cote/`, gabarit réel 0.8.12 sous `source/cote_v5_expeditions/references/`.

## Livrer et installer

Sorties dans `renders/entree_coniferes_moussus_v1/`, staging régénérable sous `.cache/`.
`ECM1_projet_pmdo_0812.zip`, `ECM1_calques_png_8px.zip`, `index.html`, PNG/ORA et WebP animé.
Sources/bruts versionnés ; médias lourds ignorés par Git, build puis package pour les retrouver.
Extraire le dossier du projet dans `PMDO/MODS/`, activer et ouvrir le Ground.
Fusion : fermer PMDO, extraire le ZIP, `python INSTALLER.py /chemin/mod --dry-run`, puis sans
`--dry-run`. Index fusionné avec sauvegarde, fichiers utilisateur modifiés protégés.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms uniques `ECM1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni chargeur réel, ni éditeur, ni caméra/échelle, rendu ou déplacements en jeu testés.
Les tests Python ne remplacent pas l'avis artistique ni le contrôle dans PMDO.
