# SVJ2 — Les Fournaises : quatre cartes avec jaillissements de magma

Demande : beaucoup de nouvelles maps, colonnes de flamme/magma qui montent sans sommet visible,
avec jaillissements depuis la lave. Après une interruption et « Fait d'autre map », finalisation
de ce lot de quatre nouvelles compositions, pas un simple réexport d'ETV1.

| Carte | Rôle | Ground |
|---|---|---|
| VJ21 — Chenal des Fournaises | Traversée sinueuse entre des chenaux | `vj21_chenal` |
| VJ22 — Défilé des Scories | Corniches et contournements asymétriques | `vj22_defile` |
| VJ23 — Bassins Bouillonnants | Passage entre des poches de lave | `vj23_bassins` |
| VJ24 — Caldeira des Éruptions | Clairière finale, nord fermé | `vj24_caldeira` |

Un seul projet PMDO 0.8.12, namespace `suite_jaillissements_v2`, **quatre Ground et 43 banques**
aux préfixes distincts VJ21/VJ22/VJ23/VJ24. Chaque carte : **768×576, 96×72 cases de 8 px**, TexSize=1.
Les trois traversées ont 11 calques + Top vide, la fin 10 + Top vide, sans profondeur de fin.
Aucun warp ou destination raccordée. Repère boss non nommé sur la fin, aucun Pokémon instancié.

## Origine et provenance

Référence D41P41A 552×576 et provenance copiées byte-à-byte d'ETV1 : pret/pmd-sky c8073235,
une couche, aucun BPA, animation de palette présente ; outil exposant 26 images, frame 0 seule
conservée comme guide. Ne pas en déduire une cadence native. Pas de Pokémon, symbole ou objet repris.
Le nom du biome est descriptif. Revue des noms de chemins des branches distantes sans fusion :
`branch_review.json`, pas audit exhaustif de tous les contenus.

**Quatre nouveaux décors générés** 1200×896, avec rip réellement dans `images=`. Corrections
également au générateur : retrait de marches involontaires sur VJ22, motifs évoquant des visages
sur VJ23, et éclaircissement de la lave trop rouge de VJ24 (deux corrections). Pour la dernière,
un crop non agrandi du rip [0,0,200,50] sert de guide de lave ; pas un assemblage de terrain.
Les premiers bruts et étapes de correction restent conservés, avec prompts exacts et hashes.
**Les corrections ne garantissent pas une conservation pixel-à-pixel du reste de la carte** :
notamment la cendre de VJ24 est devenue plus chaude. Voir generation.json dans chaque sous-dossier.

**Nouveau sprite de colonne** 784×1360, généré avec le rip en référence, fond magenta :
`shared/colonne_magenta.png`, prompt/dimensions/hashes dans `shared/generation.json`. Shaft hors
cadre au nord, matière bosselée, bouche éruptive et gouttes détachées. Pas de sprite AGM3 repris.
Support de cendre ETV1 **réutilisé et déclaré**, non aligné/caché sous la partition complète,
pas une nouvelle génération de support. Aucun collage de morceaux de maps ni recoloration du
terrain par script. **Pixels générés et transformés ; formats/grille natifs seulement.**

## Calques, du bas vers le haut

Support complet, cendre, teintes sombres du sol, rebords, basalte, prolongement nord dessiné
(traversées seulement), lave, braises, **corps des colonnes**, **gerbes à la bouche**, **gouttes projetées**.
Puis Top vide (`DrawLayer.Top=4`). Les cinq pistes animées sont chacune en 24 phases×5 ticks.
Boucle commune 120 ticks, 2 secondes. Pas de WebP lourd dupliqué pour quatre cartes : galerie
canvas animée depuis les PNG, avec choix de carte/calques, zoom, curseur, collisions/marqueurs.

Passage : enveloppe relevée pour chaque nouvelle disposition, luminance médiane 5 px >=65,
fermeture 2 px, composante principale, érosion 2 px, exclusion lave/profondeur. Le bord sud est
restauré après fermeture pour conserver l'arrivée. Bande de transition bloquante 12 px bruts.
Ombres : teintes sombres déjà dessinées, luminance lissée 5 px <80, pas ajout de voile.
Lave : fill_holes(R>175,G>30,R-B>100,G-B>10). Zones d'édition, pas détourage parfait.

Réduction BOX pondérée par classe, facteur uniforme 576/896, largeur 771 recadrée à 768
(1 px gauche, 2 droite), palette terrain commune 96 sans dither, profondeur séparée. Alpha binaire,
RGB nuls sous transparence, partition exacte. Les autres plates-formes restent conservativement
bloquées. Aucun ancien helper, sprite ou lot modifié.

## Colonnes montantes, gerbes et projections

La préparation de bande/palette réutilise le helper AGM3 **chargé dans une instance isolée**, avec
le NOUVEAU sprite et de nouveaux paramètres : BODY_END=940, CROWN_TOP=950, MOUTH_ROW=1200,
CROWN_X=[0,784]. Palette de 32 couleurs tirée du nouveau sprite ; réduction pondérée par masque,
raccord de bande sur 20 %, re-quantification et contour 1 px. Transformation explicite de pixels
générés, pas des pixels ROM exacts ni une animation officielle.

Quatre jets par carte : deux arrière-plan (échelle .16), deux plus grands (échelle .23), phases
décalées. Emplacements déterministes relevés automatiquement dans les mares : distance lave>14,
aucun pixel du couloir vertical du corps sur le passage, centres dans les bandes latérales,
ordre arrière/avant par hauteur de bouche. Les coordonnées réellement retenues sont au manifeste.

Pour u=((t-phase)%24)/24, la bande monte de

`shift = round(P*(u - 0.6*sin(4*pi*u)/(4*pi))) mod P`.

Sa vitesse non arrondie est P*(1-0.6*cos(4*pi*u)) >0 : **aucune marche arrière**, une période par
boucle et deux poussées. Le corps est tracé de y=0 à la bouche : **sommet invisible sur toutes
les phases**, continuité vérifiée sur chaque ligne. Pas un jet qui s'éteint et laisse apparaître
un capuchon au milieu du cadre. La couronne générée est ancrée à la bouche, traduite de ±2 px,
clippée dans la lave, sans rotation de palette. Le helper découpe sa partie basse en ellipse
irrégulière. Les gouttes détachées générées suivent deux vols paraboliques par boucle ; elles
peuvent passer devant la roche, jamais devant le passage. Corps/gerbes/gouttes sont séparés.

Lave : ondulation de la matière du décor généré, déplacement périodique sans recoloration,
rive 3 px et alpha fixes, phase 0 identité (recette ETV1 réutilisée sans modification).
Braises : petits pixels montants aux couleurs chaudes du rip, séparés des projections générées.
Ces animations sont **calculées**, ni BPL/BPA officiel ni simulation physique.

## Vérification et reproductibilité

Lecteur indépendant : relit les PNG des banques .tile et reconstruit les **503 images** depuis
les quatre Ground ; formats, index, alpha, partitions, accès 16×16, corps touchant le bord haut,
bouches dans la lave, absence d'occlusion du passage, masques/rives et cadences contrôlés.
Ce n'est pas le chargeur PMDO. Suite de tests paramétrée sur les quatre cartes, oracle scalaire
indépendant de l'ascension, palette du nouveau sprite, cinq mutations sur copies, installateur
fusion/sauvegarde/idempotence/protection d'une carte utilisateur modifiée.

**Reproductibilité rejouée sur VJ21 seulement**, 167 fichiers/membres ORA identiques. Les trois
autres cartes n'ont pas été reconstruites deux fois dans cette livraison ; ne pas le prétendre.
Le script `check_reproducibility.py --all` permet de les rejouer. Exclut ZIP/HTML, horodatages ORA
et caches Python. Résultats effectivement exécutés dans tests.json/verification.json et STATUS.md.

Même diagnostic cendre/lave qu'ETV1, mêmes familles et seuil35, sans hausse :
cendre 65<R<160, |R-G|<18, |G-B|<20 ; lave R>200,65<G<245,B<140,R>G+5.
Il mesure des familles de couleur, pas conformité artistique, textures officielles ou volumes.
Non comparable directement aux scores forestiers. Grandes falaises et centre encore assez
circulaire sur la fin, grain plus sobre sur VJ21, colonne très contrastée : avis artistique en attente.

## Reproduire depuis la racine

```sh
.venv/bin/pip install -r source/entree_terres_volcaniques_v1/requirements.txt
.venv/bin/python -m source.suite_jaillissements_v2.build
.venv/bin/python -m source.suite_jaillissements_v2.check_reproducibility
.venv/bin/python -m source.suite_jaillissements_v2.package
# Optionnel, rejouer les quatre :
.venv/bin/python -m source.suite_jaillissements_v2.check_reproducibility --all
```

Package fusionne les quatre staging, teste le résultat, puis écrit les deux archives et la galerie.
Pas de tests réseau nécessaires après obtention des bruts, rip et anciens helpers versionnés.

## Livrer et installer

`renders/suite_jaillissements_v2/SVJ2_projet_pmdo_0812.zip` : projet à quatre cartes, extraire dans
PMDO/MODS, activer et ouvrir un des Ground. Pas une aventure jouable, pas de transitions créées.
Fusion : fermer PMDO, extraire, `python INSTALLER.py /chemin/mod --dry-run`, puis sans --dry-run.
L'index des 43 banques est fusionné avec sauvegarde, les fichiers utilisateur modifiés protégés.
`SVJ2_calques_png_8px.zip` : calques PNG, ORA, masques, contrôles et sprite généré sur magenta.
Import PNG manuel : **8 px**, sans redimensionnement. Index HTML + catalogue + images doivent
être servis ensemble (`python -m http.server 8011 --bind 0.0.0.0`) ; pas de fichier HTML autonome.
Médias lourds ignorés par Git, sources/bruts et rapports conservés ; build/package les régénèrent.

`art_approved=false`, `runtime_tested=false`, `render_tested=false`. Ni vrai chargeur, éditeur,
caméra/échelle, rendu ou déplacements dans PMDO testés. Tests Python ≠ validation moteur/artistique.
