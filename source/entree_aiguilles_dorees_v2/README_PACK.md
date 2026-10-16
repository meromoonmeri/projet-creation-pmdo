# EAD2 — Aiguilles dorées, entrée immersive

**Correction artistique demandée par l'utilisateur** : la V1 ressemblait à une petite grotte posée
au fond d'une arène. La V2 remplace cette composition, sans écraser le précédent essai.

- Environnement plein cadre : masses rocheuses coupées par les bords, voûte et stalactites en haut.
- Grande façade et piliers, approche sableuse large au premier plan, profondeur dessinée à l'intérieur.
- Pas de couronne ovale entourée d'un fond uni. Pas de bouche remplacée par un simple aplat noir.
- Terrain final **768×576, 4:3**, 96×72 cases de 8 px (`TexSize=1`).
- Référence canonique **D14P12A**, réellement fournie au générateur ; provenance dans `reference/`.
  Le nom « Aiguilles dorées » est descriptif, pas une identification officielle du code ROM.

## Origine des pixels et calques

Terrain généré référencé, pas pixels ROM extraits. Bruts conservés à 1200×896 ; contour du sol et
masque de profondeur relevés sur cette nouvelle composition (`config.json`). Réduction uniforme
BOX pondérée par classe, palette sans dither, aucun étirement.
La profondeur étant dessinée, il n'y a **pas de zone magenta à remplir** dans cette version.
Le calque de profondeur conserve ses colonnes lointaines et son sol dans l'ombre, palette séparée.
Le sol complet est réutilisé byte-à-byte depuis la V1, **support sous les masses uniquement** :
aucun alignement entre les deux compositions n'est revendiqué, le sol visible vient de la V2.

Ordre bas → haut : sol complet, sol praticable, ombres existantes au sol, talus, parois et aiguilles,
profondeur dessinée, poussière calcaire (24×5 ticks), Top vide `Layer=4`.
La poussière est recalculée avec les couleurs du rip, pas une animation officielle.

## Ground PMDO 0.8.12

Namespace `entree_aiguilles_dorees_v2`, Ground `ead2_entree_aiguilles_dorees`.
Marqueur `entrance` au sud et `donjon_seuil` au nord, avant la profondeur dessinée.
Aucun warp, aucun PNJ ni destination liée. Les collisions sont conservatrices et doivent être
contrôlées en jeu ; le masque ne certifie pas un déplacement réel dans PMDO.

Importer les PNG avec **PNG to Tileset, 8 px**, sans redimensionnement, noms `EAD2_*` conservés.
Pour installer le projet complet : copier le dossier du ZIP dans `PMDO/MODS/`, activer le mod,
puis ouvrir le Ground. Dans un mod existant, fermer PMDO, extraire tout le projet puis lancer
`python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run` puis sans `--dry-run`.
L'installateur fusionne l'index et protège les fichiers modifiés.

## Reproduire

```sh
.venv/bin/pip install -r source/entree_aiguilles_dorees_v2/requirements.txt
.venv/bin/python source/entree_aiguilles_dorees_v2/build.py
.venv/bin/python source/entree_aiguilles_dorees_v2/verify.py
.venv/bin/python source/entree_aiguilles_dorees_v2/package.py
```

Les helpers sont chargés dans une instance isolée depuis EDR1 ; le lot EDR1 n'est pas modifié.
Sources communes : `source/maps_suite_v1/pipeline.py`, codecs `source/pmdo_cote/`.
Sorties régénérables : `renders/entree_aiguilles_dorees_v2/` ; staging dans `.cache/`.

**Limites :** `art_approved: false`, `runtime_tested: false`, `render_tested: false`.
L'aperçu normalisé et les vérifications Python ne remplacent ni l'accord artistique utilisateur,
ni le chargeur réel, ni le contrôle du rendu et de l'échelle dans PMDO.
