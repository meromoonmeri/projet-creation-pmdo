# Entrée Grotte aux vasques — sud → nord V1 (EGV1)

Entrée de donjon de la série sud → nord, au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`). C'est un **biome neuf**, choisi par l'agent le 16 octobre 2026 en réponse à « Poursuis le projet… méthode création de map pmd texture canonique ! Méthode de production des maps PMD (générateur + pipeline natif) ». Il **reste à confirmer**.

- Aperçu autonome : [`apercu_entree_grotte_vasques_sud_nord_v1.html`](../../apercu_entree_grotte_vasques_sud_nord_v1.html)
- Sources : [`source/entree_grotte_vasques_sud_nord_v1/`](../../source/entree_grotte_vasques_sud_nord_v1/) (`reference.py`, `build.py`, `test_build.py`, `mutations.py`, `package.py`)
- Livrables, régénérés par `build.py` puis `package.py` : `EGV1_projet_pmdo_0812.zip` (projet PMDO 0.8.12 : Ground, banques `.tile`, `index.idx`, `Mod.xml`, `init.lua`, `INSTALLER.py`) et `EGV1_calques_png_8px.zip` (calques, frames, poses, masques, ORA, manifeste, références ROM).

## Pourquoi ce biome

Les quatre fins encore ouvertes sur `main` (Clairière tropicale, Couloir violet, Mt. Thunder, Jardin secret) existent déjà sur les branches sœurs. Sur l'une d'elles, l'utilisateur a demandé de passer aux zones inédites. Un relevé a donc été fait le 16 octobre. Il couvre le contenu de toutes les branches de `projet-creation-pmdo` et les lots des 15 branches de `projet-pmdo`, en cherchant les codes ROM, les captures nommées et les préfixes. Il fait apparaître **137 maps « D » de la ROM jamais utilisées**. Parmi elles, `D56P12A` a été retenue : une grotte de grès doré, des stalactites et des vasques turquoise en terrasses, avec une eau animée par palette. Aucune branche ne l'utilise. Le nom officiel du lieu n'est pas identifié par une capture (le préfixe `dNN` n'est pas le `DUNGEON_ID`) : « Grotte aux vasques » est un nom de travail.

## Méthode (générateur + pipeline natif)

1. **Références canoniques** (`reference.py`) : rendu skytemple de `D56P12A` et `D56P41A` depuis `pret/pmd-sky`, au commit épinglé par l'outil maps PMD Sky. Sont enregistrés le chemin, le hash de blob Git et le SHA-256 des BMA, BPC et BPL, le SHA-256 des PNG, ainsi que l'animation de palette exacte du BPL : palette 13, 5 emplacements, 32 frames × 2 ticks.
2. **Générateur, rips en `images=`** :
   - `decor.png` 1200 × 896, obtenu du premier coup ;
   - `sol_complet.png`, édité depuis le décor au quatrième essai : deux réponses vides, puis un sable jaune saturé écarté ;
   - `source_poses.png`, une planche sur magenta dont 10 poses sur 21 sont retenues.
3. **Pipeline natif** (`build.py`) :
   - segmentation pleine résolution en sable, ombres, eau, rebords, flèches rocheuses, parois et profondeur ;
   - réduction ×0,643 par classe (BOX, attribution exclusive) ;
   - palettes MEDIANCUT sans tramage : terrain 96, roche 96, rebords 64 ;
   - **eau ramenée aux 12 couleurs exactes de l'eau du rip**, par plus proche luminance ;
   - calques transparents de 8 px et Ground PMDO 0.8.12 sur le gabarit `cliffdaytest.rsground`, un Ground de l'utilisateur (le ZIP Métano des anciens lots n'est pas dans ce dépôt).

## Calques

| # | Calque | Contenu | Animation |
|---|---|---|---|
| 00 | `sol_complet` | sable bord à bord (sous tout) | fixe |
| 01 | `sol` | sable praticable | fixe |
| 02 | `ombres` | sable assombri devant la bouche | fixe |
| 03 | `vasques` | eau (couleurs du rip) + rebords | fixe |
| 04 | `parois` | blocs dorés, stalactites | fixe |
| 05 | `blocs` | 5 flèches rocheuses sur le sable | fixe |
| 06 | `profondeur` | bouche du tunnel + fond sarcelle | fixe |
| 07 | `reflets_vasques` | 10 653 px d'eau claire, 5 emplacements | 32 × 2 ticks (BPL exact) |
| 08 | `bulles_source` | 10 sources : bulle, éclatement, anneaux | 32 × 4 ticks |
| 09 | Top | vide, `Layer=4` | — |

La scène boucle en 128 ticks. Les calques fixes forment une partition exacte de la carte, sans aucun alpha intermédiaire.

## Mesures

- **Fidélité au rip D56P12A** (même classifieur des deux côtés, seuil 35) :
  - brut : sable 6,5, eau 34,7, roche 2,4 ;
  - calques finaux : sol 10,6, vasques 15,6, parois 2,5, flèches 5,3.

  L'eau du brut est trop grise (R ≈ 63 contre 30). Le remappage sur les couleurs du rip la corrige. Par rapport à `D56P41A`, le brut est à sable 3,2, eau 13,4, roche 12,1.
- **Sol complet** recalé au pixel près : écart 3,1 en (0, 0) contre 3,96 au mieux pour un décalage de 1 px.
- **Accès** :
  - `entrance` (384, 560) au sud, `donjon_seuil` (376, 144) juste sous la bouche ;
  - chemin 16 × 16 trouvé ; 1 519 cases praticables sur 6 912 ;
  - aucune eau devant l'entrée ; aucun warp.
- **Ground** : 9 banques, 24 717 tuiles. L'aller-retour `.tile` → image est vérifié pour chaque calque.

## Tests

13 tests passent (`.venv/bin/python -m unittest source.entree_grotte_vasques_sud_nord_v1.test_build -v`). Ils couvrent :

- empreintes et provenance ROM ;
- recalage du sol complet ;
- tailles, alpha et absence de magenta ;
- partition des calques ;
- palettes et matières, avec l'eau aux couleurs exactes du rip ;
- fidélité ;
- reflets égaux, frame par frame, à l'animation de palette du BPL, avec le même enchaînement d'états que la ROM ;
- bulles recalculées depuis le manifeste et jamais hors des vasques ;
- ORA et scène ;
- accès, sans eau devant l'entrée ;
- unicité du préfixe ;
- aller-retour du Ground.

**19 mutations** sont toutes détectées (`mutations.py`). Le build est reproductible : 95 fichiers identiques d'une exécution à l'autre.

## Limites (honnêtes)

- `art_approved: false`, `runtime_tested: false` : aucune revue artistique validée, aucun test dans PMDO.
- Le terrain est **généré** à partir des rips. Ce ne sont pas des tuiles natives. Les vasques sont posées sur les pentes de blocs, comme dans le rip, plutôt qu'en grandes terrasses séparées.
- Seules les **couleurs** de l'eau et l'**animation de palette** des reflets sont exactes. Les pixels qui les portent viennent du rendu généré.
- Les **bulles** sont un dessin généré dont les couleurs sont ramenées à l'eau du rip. Leur chronologie est créée par nous ; ce n'est pas une animation officielle.
- Les ombres portées des flèches, très fines dans le rendu, restent dans le calque `blocs`. Le calque `ombres` (549 px) couvre surtout le sable assombri devant la bouche.
- Le mod `guilde_entrees_sud_nord` liste maintenant EGV1, marqué à confirmer, mais n'a **pas** été reconstruit dans ce dépôt : les ZIP des lots précédents n'y sont pas.
