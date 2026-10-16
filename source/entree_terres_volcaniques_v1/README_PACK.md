# ETV1 — Entrée des Terres volcaniques

Choix utilisateur explicite « Terres volcaniques » après demande de quitter les biomes forestiers.
Nouvelle composition, sans reprendre les anciens cratères à grotte ou les arènes de Groudon.
Namespace `entree_terres_volcaniques_v1`, Ground `etv1_entree_terres_volcaniques`, graphiques `ETV1_*`.

## Référence et origine des pixels

D41P41A, rip 552×576 depuis pret/pmd-sky, commit c8073235b39746a7ee74e6cea16c730bd91a1e67,
avec skytemple-files 1.8.5. Table bg_list index 103, une couche, aucun BPA, animation de palette
présente : le rendu de l'outil expose 26 images, **seule la frame 0 est conservée comme guide**.
Ce nombre ne décrit pas à lui seul la cadence ou la durée native du BPL. Provenance des trois
blobs et de bg_list.dat, empreintes et paramètres dans `reference/provenance.json`.
Le nom du biome est descriptif, pas un nom officiel déduit du code ROM.

Le rip est une arène avec un Pokémon et de la lave autour : il sert uniquement de référence
de matière/couleurs, pas de layout, d'objet ou de boss. Aucun Pokémon ou objet n'est repris.
Deux bruts 1200×896 : nouveau décor et support complet de cendre. Décor réussi au premier appel ;
deux appels du support sans image, puis reprise réussie avec prompt simplifié et le décor en
référence secondaire, **toujours avec le rip réellement en `images=`**. Tout est consigné dans
`generation.json` : prompts exacts, références, erreurs et empreintes. Aucun collage de bouts de
maps, aucune recoloration scriptée du terrain ; seuls formats et grille sont natifs.

## Composition et calques

768×576, 96×72 cases de 8 px, `TexSize=1`. Plateau de cendre entre de grandes corniches de
basalte, lave latérale et passage nord/sud. Le plateau reste assez frontal, avec un étranglement
sud et des corniches marquées : aucune conformité parfaite au prompt de terrain ouvert supposée.
Pas de bouche de grotte, construction, île fermée, objet central ou boss choisi.

Huit calques du bas vers le haut, puis **Top vide** (`DrawLayer.Top=4`) :
1. `sol_complet`, support de cendre indépendant, non aligné, caché sous le décor complet ;
2. `cendre`, partie claire du passage relevé ;
3. `ombres`, teintes plus sombres du sol déjà dessinées, pas un voile ajouté ;
4. `rebords`, bande de transition bloquante de 12 px bruts autour du passage ;
5. `basalte`, autres corniches et terrain hors passage ;
6. `profondeur`, prolongement nord dessiné, sans remplacement noir ;
7. `lave`, surface animée, 24×5 ticks ;
8. `braises`, petits pixels montants calculés sur la lave, 24×5 ticks.

Contours de passage/profondeur relevés sur ce nouveau brut. Lave brute :
`fill_holes(R>175, G>30, R-B>100, G-B>10)` ; ce masque de teintes chaudes n'est pas un
détourage parfait de chaque corniche. Ombres : luminance lissée 5 px <80 dans le passage.
Le passage exclut la lave ; les autres plates-formes restent conservativement bloquées.

Réduction BOX pondérée par classe : facteur uniforme 576/896, largeur 771 recadrée à 768
(1 px gauche, 2 droite). Palette commune 96 sans dither ; profondeur quantifiée séparément.
Alpha binaire, RGB nuls sous transparence, partition terrain exacte sans trou/chevauchement.
Codecs/helpers partagés inchangés. Build volcanique dédié, pas la CLI minérale générique.

## Diagnostic couleur : portée limitée

Familles choisies avant génération, mêmes masques rip/brut/sortie et seuil RGB moyen **35** :
- `cendre` : 65<R<160, |R-G|<18, |G-B|<20 ;
- `lave` : R>200, 65<G<245, B<140, R>G+5.
Échantillons testés : au moins 10 % de chaque image pour chacune des deux familles.
Indices propres à ces matières, **pas directement comparables aux scores forestiers**.
Ne certifient ni des textures officielles, ni les silhouettes, raccords, volumes ou échelle.

## Lave et braises : animations calculées, pas le BPL

Les pixels de la lave viennent du nouveau décor généré, pas de la ROM. La surface ondule
par déplacement d'échantillons entiers, **sans recoloration**, avec masque et rive de 3 px fixes :

`theta=2*pi*(t%24)/24`

`dx=rint(2*(sin(theta+y/19)-sin(y/19)))`

`dy=rint(2*(cos(theta+x/23)-cos(x/23)))`

On lit le pixel généré à `(x+dx,y+dy)`, ramené au plus proche pixel intérieur si nécessaire.
Seule l'érosion de 3 px du masque est mobile. Phase 0 identique à la surface de base ; boucle
fermée de 2 s. Ondulation cyclique, **pas écoulement net, simulation physique ou animation BPL**.
Les couleurs du terrain sont préservées après la quantification documentée.

Braises : 24 émetteurs déterministes, `k=(t+phase)%24`, visibles k<18,
`x=x0+round(3*sin(2*pi*k/18))`, `y=y0-k+9`, pixels (0,0),(0,-1), clipping dans la lave.
Quatre couleurs chaudes exactes de la frame 0 du rip ; loi et dessin calculés. Le champ
hérité `dust` désigne ces braises. Aucun personnage ou objet de jeu instancié.

## Accès et contrôles

Arrivée au sud et repère `donjon_seuil` au nord, passage 16×16. Le fond nord est décoratif
et bloquant ; aucun warp, destination, PNJ, boss ou aventure jouable raccordée.
**17 tests PASS**, six mutations rejetées et **54 reconstructions exactes** depuis huit banques.
Arrivée `[384,560]`, seuil `[320,112]`. Diagnostic final cendre **5,87**, lave **9,94**, seuil 35.
Contrôles et résultats effectivement exécutés dans `STATUS.md`. Les vérifications reconstruisent
les PNG depuis les banques .tile et le Ground avec un lecteur indépendant, pas le vrai PMDO.
Tests destructifs sur copies, installateur testé en simulation/fusion/protection.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_terres_volcaniques_v1/requirements.txt
.venv/bin/python source/entree_terres_volcaniques_v1/build.py
.venv/bin/python -m unittest source.entree_terres_volcaniques_v1.test_build -v
.venv/bin/python source/entree_terres_volcaniques_v1/verify.py
.venv/bin/python source/entree_terres_volcaniques_v1/check_reproducibility.py
.venv/bin/python source/entree_terres_volcaniques_v1/package.py
```

Build hors ligne depuis les bruts/PNG de référence versionnés. Régénération optionnelle du
rip : installer `skytemple-files==1.8.5`, puis exécuter `extract_reference.py` avec gh configuré.
Ce script n'altère pas l'index ROM partagé. Revue des branches dans `branch_review.json` :
recherche de noms de chemins associés et du namespace, pas audit de tous les contenus.

## Livrer et installer

Sorties dans `renders/entree_terres_volcaniques_v1/`, staging régénérable sous `.cache/`.
`ETV1_projet_pmdo_0812.zip`, `ETV1_calques_png_8px.zip`, `index.html`, calques PNG/ORA et WebP.
Sources/bruts versionnés ; médias lourds ignorés par Git, build puis package pour les retrouver.
Extraire le dossier du projet dans `PMDO/MODS/`, activer et ouvrir le Ground.
Fusion : fermer PMDO, extraire le ZIP, `python INSTALLER.py /chemin/mod --dry-run`, puis sans
`--dry-run`. Index fusionné avec sauvegarde, fichiers utilisateur modifiés protégés.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms uniques `ETV1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni chargeur réel, ni éditeur, ni caméra/échelle, rendu ou déplacements dans PMDO testés.
Tests Python ≠ validation moteur ou artistique.
