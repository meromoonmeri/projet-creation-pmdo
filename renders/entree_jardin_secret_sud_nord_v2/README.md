# EJS2 — Entrée Jardin secret V2 : le temple miniature de Celebi, sud → nord, 4:3 vaste

- **Demande** : « Je veux un petit temple miniature qui tiens sur la buche celebi gardien secret », puis « lance la suite ! » (27 septembre).
- **Choix de l'agent, à confirmer** (les questions ont été passées) :
  - c'est une **nouvelle version, EJS2**, et **EJS1 reste intacte** ;
  - la **porte du temple devient l'entrée du donjon** ; les marches de la souche et un parvis de pierre y mènent ;
  - **Celebi apparaît en emblème lumineux sur le fronton**, pas en sprite.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_jardin_secret_sud_nord_v2.html` (racine) ou `review/EJS2_scene_animee.webp`.
- Pack PMDO 0.8.12 : `EJS2_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `EJS2_`) : `EJS2_calques_png_8px.zip`.
- Source : `source/entree_jardin_secret_sud_nord_v2/`, 13 tests. Le build part de celui d'EJS1 (branche de session) ; rien n'est repris des branches sœurs.

## Méthode : un seul brut nouveau, collé seulement sur la souche

Le décor, le témoin et le sol complet sont **ceux d'EJS1**, relus dans `source/entree_jardin_secret_sud_nord_v1/bruts/` et jamais copiés. Il n'y a qu'un nouveau brut :

- `bruts/decor_temple.png` (1200 × 896). Le générateur a reçu **le décor d'EJS1 et la capture `secretgarden.png`** en images de référence, avec la consigne de ne changer que la souche. **Premier essai, conforme.** Le prompt complet est dans `manifest.json` → `generation`.
- Recalage du brut sur EJS1, mesuré hors de la fenêtre de la souche : décalage (0, 0), écart moyen **3,76**, contre 6,22 au mieux avec un décalage de 1 px.
- **Zone collée** : l'écart lissé sur 3 px entre les deux bruts, au-dessus de 22 dans la fenêtre y 60–280, x 500–700, en ne gardant que la plus grande composante. Elle est fermée sur 3 px, ses trous sont bouchés, puis elle est dilatée de 2 px. Cela donne **9227 px**, de y 82 à 242 et de x 555 à 647 (masque : `masques/EJS2_zone_collee_pleine_resolution.png`).
- **Hors de cette zone, le décor est celui d'EJS1 au pixel près**, et un test le vérifie. La couture ne se voit pas, même agrandie.

Le temple : toit vert en feuille, piliers de bois, socle de pierre grise posé sur la souche, porte sombre, emblème vert clair de Celebi sur le fronton. Un escalier de souche descend du parvis jusqu'à la prairie.

**Fidélité au rip** : les matières du terrain sont celles d'EJS1. Les distances des calques finaux sont toutes sous le seuil de 35 : prairie 31,5, herbe 7,3, ombres 2,2, rochers 20,6, fond 11,7. Le temple n'existe pas dans la capture, donc il n'a pas de matière de référence à mesurer. **Ce sont des pixels générés, pas des tuiles natives.**

## Segmentation du temple (pleine résolution, dans la zone collée)

| Classe | Critère |
|---|---|
| Socle | plus grande composante grise (saturation < 30, lum 120–235) ; son bas (y 202) borne le temple |
| Porte → `profondeur` | plus grande composante lum < 70, trous bouchés : 496 px, y 157–180, x 589–611 |
| Emblème | boîte de 18 px au-dessus de la porte, ± 12 px autour de son centre, lum > 165 et vert (g > r + 15), fermé 1 px |
| Marches | zone collée et souche sous la porte, dans la largeur de l'ancien trou ± 2 px : parvis de pierre et escalier |
| Temple | le reste de la zone collée au-dessus du bas du socle |

Le rayon ne recouvre jamais le temple. Deux lucioles de départ, qui tombaient sur le toit, ont été décalées : (360,96) devient (344,96), et (414,90) devient (428,90).

**Palettes** : les mêmes qu'EJS1, plus un groupe `temple` de 48 couleurs.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | sol_complet (brut d'EJS1) | fixe |
| 01–07 | prairie, herbe, ombres, fleurs, rochers, arbres, haies | fixe |
| 08 | souche | fixe |
| 09 | **temple** | fixe |
| 10 | marches (escalier et parvis, praticables) | fixe |
| 11 | profondeur (porte du temple) | fixe |
| 12 | fond | fixe |
| 13 | **emblème de Celebi** | 24 × 5 ticks |
| 14 | rayon | 24 × 5 ticks |
| 15 | lucioles | 24 × 5 ticks |

Le Ground ajoute un calque Top vide, soit 17 calques. La scène boucle en **120 ticks (2 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animation de l'emblème

- Chaque pixel de l'emblème prend le cran le plus proche sur la **rampe exacte des 22 verts du rayon de la capture**, la même que celle du rayon.
- Lueur : `cran = clip(cran0 + round(3 (1 − cos(2π u / 24)) / 2))`, avec `u = min(t, 24 − t)`. L'emblème monte de 3 crans jusqu'au blanc à la phase 12, puis redescend.
- Au premier build, `round` appliqué à 1,4999… et à 1,5000… rendait l'aller-retour bancal (t = 6 contre t = 18). Le test l'a vu, et le calcul sur `u` rend la lueur symétrique par construction.
- **Tests** :
  - couleurs incluses dans la rampe, elle-même incluse dans le rip ;
  - recalcul des 24 phases depuis les crans enregistrés ;
  - phase 24 = phase 0, et phase 0 = emblème du rendu ;
  - 3 crans à la phase 12, aller-retour symétrique ;
  - l'emblème s'éclaire bien (lum + 10).

Le rayon et les lucioles sont ceux d'EJS1.

## Collisions et accès

- `entrance` (384, 560) est au bord sud. `donjon_seuil` (376, 120) est sur le parvis, juste sous la porte du temple.
- Le chemin de 16 × 16 px est prouvé par BFS : **2141 cases praticables** sur 6912.
- Le temple, sa porte, l'emblème, la souche, les rochers, les arbres, les haies, le fond et le rayon sont bloqués (test).
- Aucun warp.

## Tests : 13 PASS, mutations vérifiées

Les 11 tests d'EJS1 sont adaptés. Deux tests sont nouveaux :

- **temple collé sur la souche** :
  - décor égal à EJS1 hors de la zone et égal au brut dans la zone ;
  - zone incluse dans la fenêtre, recalage recalculé ;
  - pied du temple sur la souche, temple dans sa largeur et plus petit que 80 × 70 px ;
  - porte entourée par le temple, marches juste dessous ;
  - emblème centré au-dessus de la porte et entouré par le temple ;
- **emblème** : rampe exacte et boucle fermée.

Les nouveaux tests détectent ces mutations :

- un pixel de l'emblème hors rampe ;
- la phase 12 remplacée par la phase 0 ;
- un pixel de la zone collée hors de la fenêtre ;
- le masque du temple remonté de 40 px.

Build en environ 30 s. **Pas de runtime PMDO, art non approuvé.**
