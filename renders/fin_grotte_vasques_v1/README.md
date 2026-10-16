# Fin Grotte aux vasques V1 (FGV1)

Zone de fin du donjon de la **Grotte aux vasques**, qui fait suite à l'entrée [EGV1](../entree_grotte_vasques_sud_nord_v1/README.md). Elle est au **format 4:3 vaste** : 768 × 576 px, soit 96 × 72 cases de 8 px (`TexSize=1`). La demande, datée du 16 octobre 2026, était : « Fait la zone de fin et passe enuite au prochaine map ! ». Le biome reste **à confirmer**.

- Aperçu autonome : [`apercu_fin_grotte_vasques_v1.html`](../../apercu_fin_grotte_vasques_v1.html)
- Sources : [`source/fin_grotte_vasques_v1/`](../../source/fin_grotte_vasques_v1/) (`build.py`, `test_build.py`, `mutations.py`, `package.py`)
- Livrables, régénérés par `build.py` puis `package.py` :
  - `FGV1_projet_pmdo_0812.zip` : projet PMDO 0.8.12 (Ground, banques `.tile`, `index.idx`, `Mod.xml`, `init.lua`, `INSTALLER.py`) ;
  - `FGV1_calques_png_8px.zip` : calques, frames, poses, masques, ORA, manifeste et référence ROM.

## Composition

On arrive au sud par un couloir de sable entre deux massifs de blocs. Il s'ouvre sur une grande arène de sable doré, traversée par **trois marches courbes**. Les deux pentes latérales de blocs portent des grappes de vasques turquoise, comme dans l'entrée. Au nord, une **cascade de vasques en pyramide** s'adosse à la voûte et ferme la salle. Des stalactites pendent devant un fond sarcelle sombre.

La consigne de l'utilisateur pour les fins s'applique : « pas d'artefact ni d'objet/structure en fin de donjon, seulement le décor ». Il n'y a donc ni autel, ni cristal, ni dalle, ni sortie, ni warp.

## Méthode (générateur + pipeline natif)

1. **Références** : le rip ROM `D56P41A`, une grande salle bordée de vasques extraite par `source/entree_grotte_vasques_sud_nord_v1/reference.py`, et le décor d'EGV1 pour la continuité. Les deux sont passés au générateur en `images=`.
2. **Générateur** :
   - `decor.png` : 1200 × 896, obtenu du premier coup, sans objet ni structure ;
   - `sol_complet.png` : édité depuis le décor au premier essai, en reprenant d'emblée la consigne de teinte d'EGV1, avec les marches gardées ;
   - planche de bulles : celle d'EGV1, **réutilisée** sans nouvelle génération (même sha256).
3. **Pipeline natif** (`build.py`) :
   - segmentation pleine résolution en sable, marches, ombres, eau, rebords, parois et fond ;
   - réduction ×0,643 par classe (BOX, attribution exclusive) et palettes MEDIANCUT sans tramage ;
   - **eau ramenée aux 14 couleurs exactes de l'eau de `D56P41A`** ;
   - Ground PMDO 0.8.12 sur le gabarit `cliffdaytest.rsground`.
4. **Marches** : leurs contremarches claires ne passent pas la règle de couleur du sable. Au premier build, elles tombaient en parois et coupaient l'arène en deux, si bien qu'aucun chemin 16 × 16 n'était trouvé. Elles sont maintenant reconnues là où le décor coïncide avec le sol complet recalé : écart médian 5 × 5 ≤ 12, contre une médiane de 5 dans la bande des marches et ≥ 19 pour 95 % des parois. Les parties claires vont au sol, les traits sombres aux ombres, et toutes sont praticables.

## Calques

| # | Calque | Contenu | Animation |
|---|---|---|---|
| 00 | `sol_complet` | sable bord à bord, marches comprises | fixe |
| 01 | `sol` | sable praticable, contremarches claires | fixe |
| 02 | `ombres` | traits sombres des marches, sable assombri au pied des pentes | fixe |
| 03 | `vasques` | eau (14 couleurs du rip) + rebords | fixe |
| 04 | `parois` | blocs dorés, stalactites | fixe |
| 05 | `fond` | fond sarcelle derrière les stalactites | fixe |
| 06 | `reflets_vasques` | 26 980 px d'eau, 6 emplacements | 12 × 8 ticks (BPL exact de `D56P41A`) |
| 07 | `bulles_source` | 10 sources : bulle, éclatement, anneaux | 24 × 4 ticks |
| 08 | Top | vide, `Layer=4` | — |

La scène boucle en 96 ticks. Les calques fixes forment une partition exacte de la carte, sans aucun alpha intermédiaire. Le calque `profondeur` d'EGV1 n'existe pas ici, car la fin n'a pas de bouche : seul le fond sarcelle reste.

## Mesures

- **Fidélité au rip `D56P41A`** (même classifieur des deux côtés, seuil 35) :
  - brut : sable 6,1, eau 16,8, roche 14,0 ;
  - calques finaux : sol 10,8, vasques 8,9, parois 16,2.

  Par rapport à `D56P12A` (rip de l'entrée), le brut est à sable 9,2, eau 37,1, roche 1,3.
- **Sol complet** recalé au pixel près : écart 3,17 en (0, 0) contre 3,89 au mieux pour un décalage de 1 px.
- **Accès** :
  - `entrance` (384, 560) au sud ;
  - `boss` (392, 368) au cœur de l'arène, à plus de 40 px de toute paroi ;
  - `objectif` (424, 232) au pied de la cascade ;
  - chemins 16 × 16 vers le boss et vers l'objectif, recalculés par les tests sur la grille du Ground ;
  - 1 236 cases praticables sur 6 912 ; aucune sortie, aucun warp.
- **Ground** : 8 banques, 22 957 tuiles. L'aller-retour `.tile` → image est vérifié pour chaque calque.

## Tests

13 tests passent (`.venv/bin/python -m unittest source.fin_grotte_vasques_v1.test_build -v`). Ils couvrent :

- empreintes, référence ROM et planche d'EGV1 réutilisée telle quelle ;
- recalage du sol complet ;
- tailles, alpha et absence de magenta ;
- partition des calques, sans `profondeur` ;
- palettes et matières, avec l'eau aux couleurs exactes du rip ;
- marches praticables et arène d'un seul tenant ;
- fidélité ;
- reflets égaux, frame par frame, à l'animation de palette du BPL, avec le même enchaînement d'états que la ROM ;
- bulles recalculées depuis le manifeste, avec les mêmes masques que l'entrée ;
- ORA et scène ;
- accès : boss loin des parois, objectif au pied de la cascade, obstacles égaux aux calques, chemins recalculés ;
- unicité du préfixe ;
- aller-retour du Ground, avec seulement les 3 marqueurs `entrance`, `boss` et `objectif`.

**24 mutations** sont toutes détectées (`mutations.py`). Elles incluent notamment :

- reflets à la cadence de l'entrée ;
- eau à la palette de l'entrée ;
- boss contre une paroi ;
- objectif hors de la colonne centrale ;
- warp ajouté ;
- marches bloquées.

## Limites (honnêtes)

- `art_approved: false`, `runtime_tested: false` : aucune revue artistique validée, aucun test dans PMDO.
- Le terrain est **généré** à partir du rip et du décor d'EGV1. Ce ne sont pas des tuiles natives. Les pentes latérales reprennent volontairement celles de l'entrée.
- Seules les **couleurs** de l'eau et l'**animation de palette** des reflets sont exactes. Les pixels qui les portent viennent du rendu généré. 65 % de l'eau scintille, comme les grandes nappes du rip.
- Les **bulles** reprennent les poses d'EGV1 avec des couleurs ramenées à l'eau de `D56P41A`. Leur chronologie est créée par nous ; ce n'est pas une animation officielle.
- La fin n'est pas reliée en jeu à l'entrée : aucun script et aucun donjon ne sont fournis.
