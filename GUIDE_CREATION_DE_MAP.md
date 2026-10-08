# Guide de création d'une carte PMDO

Méthode réellement employée dans `projet-pmdo`, cible **PMDO 0.8.12**. Elle produit des cartes
*Ground* ouvrables dans l'éditeur de développement, avec leurs calques PNG, leurs animations, leurs
marqueurs et leurs collisions.

La **procédure de session** (gabarit, commandes, préfixes, carte suivante) est dans
**[WORKFLOW.md](WORKFLOW.md)** et **[source/methode_serie_sud_nord/](source/methode_serie_sud_nord/)**.
Chaque chantier de la série a son propre `WORKFLOW.md` (relance, bruts `GEN`, limites de l'extraction).

---

## 1. Vocabulaire et formats

| Élément | Extension | Rôle |
|---|---|---|
| **Ground** | `.rsground` | La carte : taille en cases, calques, collisions, objets, **markers**, entités. C'est le fichier qu'on ouvre dans l'éditeur Ground. |
| **Tileset** | `.tile` | Banque de tuiles natives (banque + métadonnées). Produite/relue par le codec `source/pmdo_cote/`. |
| **Index de tiles** | `index.idx` | Index natif des tilesets du mod ; `INSTALLER.py` le **fusionne** et sauvegarde l'ancien. |
| **Tiled** | `.tmj` / `.tsj` | Sources d'édition (cartes et tilesets Tiled) pour les salles et kits. |
| **Planche de sprites** | `_Anim` / `_Offsets` / `_Shadow` + `AnimData.xml` | Format sprite PMD (personnages/objets). |
| **Provenance** | `provenance.json`, `.npz` | Chemin distant, commit, hash de blob Git, SHA-256 local, coordonnées source de chaque tuile. |

Structure d'un **projet PMDO** généré (ce que produit `build.py` dans `.cache/<projet>/<namespace>/`) :

```
<namespace>/
├── Mod.xml
├── Content/Tile/*.tile
├── Content/Tile/index.idx
├── Data/Ground/<asset>.rsground
├── Data/Script/<namespace>/ground/<asset>/init.lua
├── INSTALLER.py
└── README.md
```

Installation : copier le dossier dans `PMDO/MODS/`, l'activer, ouvrir le Ground.
Dans un mod existant : `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run` puis sans `--dry-run`.

---

## 2. Tailles et grille

- **Grille : 8 px.** Toute image de jeu est nette, en 8 px, sans rééchantillonnage.
- **Standard actuel : 4:3 vaste — 768 × 576 px = 96 × 72 cases** (`TexSize=1`), ≈ 2,4 × 2,4 écrans PMDO.
- Anciens lots : formats plus petits (ex. 320 × 240 px = 40 × 30 cases, grille 8 px, référence Palika).
- Une réduction depuis un rendu généré se fait à **facteur uniforme en X et Y**, par **moyenne
  pondérée par classe** (aucun mélange entre classes), chaque pixel attribué à la classe de poids maximal.

---

## 3. Les six étapes

### Étape 1 — Composition (rendu généré)

Générer l'image complète à partir d'une **référence canonique** (rip PMD : `starcavepmdsky.png`,
`witheringdesert.png`, `Dark_Crater_*`, `Sealed_Ruin_*`, `Mt_Bristle_*`, carte du monde…).
Conventions :
- décor complet **sur magenta** (le magenta remplace ce qui doit être détouré ou devenir un élément
  animé : torrent, rivière, vide) ;
- le sol complet est généré **séparément** (`sol_complet.png`) ;
- le rendu est un **guide de composition** : il n'est pas importable tel quel.

> Le détail du mécanisme — formules de détourage, segmentation en matières, réduction 2×2 par classe,
> palette commune, contrôle de fidélité — est dans **[METHODE_MAGENTA_ET_GENERATEUR.md](METHODE_MAGENTA_ET_GENERATEUR.md)**.
> En résumé : `key()` détoure le magenta par **rapport de canaux** (`r > 1.45 g`, `b > 1.45 g` +
> frange antialiasée), `classify()` découpe le décor en masques de matières (eau, roche, berge, sable…),
> la réduction se fait à **facteur uniforme** par **moyenne 2×2 par classe** (aucun mélange entre
> matières, arbitrage par vote), puis une **palette commune de 96 couleurs** (MEDIANCUT, sans dither)
> harmonise tous les calques.

Contrôle de fidélité : comparer les couleurs des zones clés au rip, **seuil ≈ 35** (distance de
couleur) ; noter les valeurs dans le `README_PACK.md` (ex. « sol 6,8 · cristal 30,8 »).

### Étape 2 — Reconstruction en tuiles natives

Reconstruire avec de **vraies tuiles natives de 8 px** : sélection guidée par la composition, sans
recolorer, tourner, retourner ni agrandir les tuiles natives. Conserver la provenance de chaque tuile
(commit + blob Git + SHA-256) dans `provenance.json`.

### Étape 3 — Découpage en calques

Un calque par fonction, **du bas vers le haut**, plus un calque `Top` vide au-dessus :

| Exemple (Entrée Jungle) | Ordre |
|---|---|
| `00_…` | rivière et mare façon Métano (4 × 10 ticks) |
| `01_…` | scintillements natifs |
| `02_sol_complet` | sol complet (fixe) |
| `03…09` | clairière, sentier, terre, berge, rochers, îlots d'arbres, jungle |
| `10_entree_sombre` | entrée sombre (fixe) |
| `11_papillons` | animation (48 × 5 ticks, boucle 4 s) |
| `12` | **vide**, `Layer=4` (Top) |

Règles : transparence propre, **magenta exact** là où il faut, bases de fenêtres transparentes,
animations chacune sur son calque, scène avec un PPCM de ticks (ex. 240 ticks = 4 s).

Pour la guilde, le kit impose **11 calques** (`00_exterieur` → `10_bordure_avant`), 6 ambiances
(jour, nuit, crépuscule, aube, soir, orageux), 12 salles et des règles d'accès strictes
(`kit.json`, `source/regles_acces.json`) : aucune porte non autorisée, pas de battant aux accès
ordinaires, pas de fausse porte de fond.

### Étape 4 — Markers, collisions, accès

- `entrance` au sud sur le sentier ; `boss` au centre (arènes) ; `objectif` au nord (pied de l'alcôve, seuil).
- **Aucun warp** sauf demande explicite ; une fin de donjon n'a ni sortie ni warp.
- Vérifier un **chemin libre** (ex. 16 × 16 px) sur la grille, et fournir la vue
  `review/<PFX>_collisions_marqueurs.png`. « À contrôler en jeu ».

### Étape 5 — Tests, vérification, paquet

```sh
.venv/bin/python source/<projet>/build.py                  # génère renders/<projet>/
.venv/bin/python -m unittest source.<projet>.test_build -v # tests d'images/formats/cadence
.venv/bin/python source/<projet>/verify.py                 # contrôle aveugle des sorties
.venv/bin/python source/<projet>/package.py                # ZIP projet PMDO + ZIP calques + aperçu HTML
```

`package.py` produit typiquement :
- `<PFX>_projet_pmdo_0812.zip` — le projet PMDO prêt à déposer dans `MODS/` ;
- `<PFX>_calques_png_8px.zip` — les calques PNG, les animations, l'ORA, le manifeste, les aperçus ;
- `apercu_<projet>.html` — visionneuse autonome (images en base64, hors ligne, calques animés).

Environnement : `.venv` avec **Pillow ≈ 12.3, NumPy ≈ 2.4, SciPy ≈ 1.17**.

### Étape 6 — Test avec le vrai moteur (facultatif mais décisif)

`source/pmdo_runtime/` contient l'installation PMDO 0.8.12 vérifiée (SHA-256 de l'archive officielle)
et `verify_ground_runtime.py` : il appelle le **vrai chargeur** via
`DataManager.Instance:GetGround(assetName)` dans `test_ground_load.lua`, sans affichage.
20 Ground du pack Expéditions ont été désérialisés par le binaire réel (code 0).

> L'affichage de l'éditeur et le rendu en jeu **n'ont pas été validés** (crash natif code 139 dans
> l'environnement de test). Un test Python, même à 0 différence de pixel, **ne vaut pas** validation
> artistique, d'échelle ou d'intégration.

---

## 4. Contrat d'import (utilisateur ↔ projet)

L'import se fait **dans l'éditeur PMDO Dev, via « PNG to Tileset »** :

- les PNG de jeu doivent être **natifs, nets, structurellement cohérents** avec la matière de référence
  (Métano), pas des illustrations générées simplement agrandies ;
- tailles d'import documentées explicitement : **8 px** ; dimensions divisibles, rectangles complets,
  absence de resampling ;
- l'importeur nomme les tilesets **par basename** : deux fichiers homonymes de dossiers différents
  s'écrasent → préfixes uniques (`METANO_V3_*`, `EJN1_*`, `v50812_*`…).

Après l'import, un audit réel (`audits/metano_import/RAPPORT.md`) a montré qu'un assemblage par
fragments de 8 px et colonnes d'ombre répétées **ne préserve pas les volumes natifs** : privilégier des
**modules natifs complets** (sommet, face, pied, retours) étalonnés sur la référence.

---

## 5. Livrer un lot

1. Un identifiant de lot propre (`v50812_*`, `EJN1`, `FSM1`, `FST1`, `FCT1`…) — les préfixes déjà pris
   ailleurs ne se réutilisent pas.
2. `README_PACK.md` : identifiant, format, calques (tableau), marqueurs, limites, ce qui est généré
   et ce qui est natif.
3. `WORKFLOW.md` du lot : rip, liste `GEN`, seuils, commandes de relance (gabarit :
   `OUTILS/ecrire_workflows_lots.py` ou copie du Jungle). `STATUS.md` si l’état n’est pas trivial.
4. Les sorties dans un dossier de rendu dédié, **jamais en écrasant** un lot antérieur.
5. Une entrée dans le journal (`JOURNAL_GUILDE_TREEHOUSE.md`) : demande, décisions, fidélité mesurée,
   tests (PASS/échecs), `art_approved`, ce qui reste à confirmer.
6. Ne jamais déclarer comme fait : un test moteur non exécuté, une approbation artistique, une
   ouverture de carte.

---

## 6. Pièges connus (rencontrés pour de vrai)

- **Homonymes de tuiles** entre dossiers → écrasement silencieux à l'import.
- **Assemblage par fragments** : les volumes natifs ne survivent pas ; l'utilisateur voit des falaises
  « trop petites » et une « qualité désastreuse ».
- **Décor généré en 2:1** (ex. 1440 × 720) → écarté, ne correspond pas au format standard.
- **Aperçus HTML lourds** : intégrer les images en base64 fait des fichiers de 20–30 Mo ; les générer
  à la demande, pas les versionner.
- **`.venv` absente** après un checkout → recréer (Pillow 12.3 / NumPy 2.4 / SciPy 1.17) avant de conclure
  qu'un test échoue.
- **Horodatages ZIP** : les archives ORA ne sont pas byte-identiques d'un build à l'autre (16 membres
  identiques, horodatage différent) — comparer les membres, pas le fichier.
- **Branches sœurs** : un lot peut exister sur une branche distante et pas sur `main` ; vérifier la
  branche de la session avant de conclure qu'un fichier manque.
