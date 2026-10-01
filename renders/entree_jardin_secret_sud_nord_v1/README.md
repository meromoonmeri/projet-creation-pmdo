# EJS1 — Entrée Jardin secret sud → nord, format 4:3 vaste

- **Demande** : « Lance la suite ! », après EMT1 (27 septembre). C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **jardin secret** (prairie fleurie, souche dorée à marches sous un rayon de lumière), choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_jardin_secret_sud_nord_v1.html` (racine) ou `review/EJS1_scene_animee.webp`. La page d'accueil du serveur d'aperçus le liste en tête.
- Pack PMDO 0.8.12 : `EJS1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `EJS1_`) : `EJS1_calques_png_8px.zip`.
- Source : `source/entree_jardin_secret_sud_nord_v1/`, 11 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1 (`down_class`, palettes, grille) et d'ESN1 (BFS) ; `write_ora` et `ground_project` sont repris d'ECV1. Rien n'est repris des branches sœurs.

## Pourquoi ce biome

Le relevé fait pour EMT1 (97 images de la racine, 72 têtes, clés courtes) avait gardé `secretgarden` pour la suite. Il a été refait le 27 septembre sur les 72 têtes :

- `secretgarden` n'a servi qu'à d'anciens lots de jardin secret, sur `01a0d315` et `01a0d4b6`, jamais à une **entrée** de la série. Rien n'en est repris. C'est le même cas qu'EQS1 et EMT1.
- Après EJS1, la seule capture de la racine encore libre partout est `oldcastlepmd`, une salle intérieure. **La suite demande donc un choix** : réutiliser une capture avec une nouvelle disposition, faire une variante, ajouter de nouvelles captures, ou passer aux intérieurs.

## Méthode : textures canoniques par rendu généré référencé

La capture (408 × 408) montre une prairie jaune-vert bordée d'herbe touffue, deux arbres ronds, des rochers beiges, des fleurs blanches, jaunes et roses, une souche dorée au trou carré et à marches, et un rayon de lumière verte qui tombe du haut sur un fond vert sombre.

La capture a été **passée au générateur comme image de référence** pour le décor. Les prompts complets sont dans `manifest.json` → `generation`.

1. `bruts/decor.png` (1200 × 896) : **premier essai, conforme**. On arrive au sud par une allée entre deux haies. Elle ouvre sur une grande prairie fleurie, avec des arbres et des rochers, bordée de haies. Au nord, la souche sous le rayon.
2. `bruts/temoin_sans_objets.png` : le décor édité sans fleurs, rochers ni arbres. **Premier essai.** Il sert seulement à la segmentation et n'est jamais exporté. Recalage mesuré hors objets : écart moyen 2,28, contre 2,88 au mieux avec un décalage de 1 px.
3. `bruts/sol_complet.png` : herbe seule, plein cadre, éditée depuis le témoin. **Troisième essai**, (121.7,174.9,52.6), à **11,0** de l'herbe de la capture. Deux essais sont **écartés** et gardés dans `bruts/ecartes/` : grosses touffes vert acide (43,2) depuis le décor, et plaques tramées (45,7) depuis la capture seule.

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, même classifieur de pixels des deux côtés. Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| fond vert sombre | 47.5,87.9,53.9 | 43.9,82.1,46.8 | 9,9 | fond | 11,7 |
| herbe claire | 152.7,206.3,74.1 | 152.2,203.5,65.9 | 8,7 | herbe / prairie | 8,1 / 30,5 |
| herbe moyenne | 115.0,166.1,53.1 | 107.5,162.9,50.6 | 8,5 | ombres | 2,2 |
| roche beige | 137.2,129.6,68.4 | 153.6,138.9,75.4 | 20,1 | rochers | 20,5 |

La **prairie** est la plus éloignée (30,5), sous le seuil : c'est la partie la plus jaune de l'herbe claire (b < 50). La capture a aussi ce jaune au centre de sa prairie, mais la moyenne de son herbe claire est tirée vers le vert moyen.

## Segmentation et palettes

Réduction : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`). Le critère complet est dans `manifest.json` → `segmentation`.

| Classe | Critère (pleine résolution) |
|---|---|
| Fond | lum lissée du témoin < 85, vert, ouvert 3 px, relié au bord |
| Rayon | verts très vifs (g − r > 70) ou très clairs du témoin en haut-centre, reliés au bord haut. Les objets du décor posés dessus (le rocher à gauche du faisceau) en sortent |
| Souche | doré au haut-centre, > 3000 px, trous bouchés |
| Profondeur | lum < 75 dans la souche, plus grande composante |
| Marches | toute la souche sous le trou, dans sa largeur ± 2 px |
| Haies | témoin texturé (écart-type sur 9 px > 6), > 3000 px, ouvert 5 px puis redilaté |
| Objets | écart décor / témoin > 28 : fleurs (< 400 px, ≥ 20 % de pixels de fleur, 145), rochers (beiges, lum > 115, 26), ombres portées (herbe plate sombre), arbres (le reste, 19) |
| Herbe | hors objets : prairie (b < 50), ombres (lum < 150), herbe (le reste) |

Deux corrections ont été faites au premier build, parce que le chemin de 16 px ne passait pas :

- **Marches** : prises d'abord comme les seuls barreaux clairs, elles ne touchaient pas l'herbe. Elles couvrent maintenant toute la colonne sous le trou.
- **Lisière de l'allée** : une fine bande texturée entre la prairie et l'allée sud était classée en haie. Elle barrait l'allée à y ≈ 448. L'ouverture de 5 px retire ces lisières fines ; les vraies haies font plus de 30 px d'épaisseur.

**Palettes par matière** : herbe (sol complet, prairie, herbe, ombres) 64 ; fleurs 24 ; rochers 32 ; végétation (arbres, haies) 96 ; souche (souche, marches, profondeur) 48 ; fond 8.

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | sol_complet | brut `sol_complet` | fixe |
| 01 | prairie | décor généré | fixe |
| 02 | herbe | décor généré | fixe |
| 03 | ombres | décor généré | fixe |
| 04 | fleurs | décor généré | fixe |
| 05 | rochers | décor généré | fixe |
| 06 | arbres | décor généré | fixe |
| 07 | haies | décor généré | fixe |
| 08 | souche | décor généré | fixe |
| 09 | marches | décor généré | fixe |
| 10 | profondeur | décor généré | fixe |
| 11 | fond | décor généré | fixe |
| 12 | rayon | forme générée, **rampe exacte** du rip | 24 × 5 ticks |
| 13 | lucioles | couleurs **exactes** du rayon du rip, créées par nous | 24 × 5 ticks |

La scène boucle en **120 ticks (2 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animations

- **Rampe** : les 22 verts du rayon de la capture (zone y < 95, x 130–280), triés du sombre (47,95,55) au blanc. Chaque pixel du rayon généré prend le cran de rampe le plus proche : la phase 0 est le rayon du rendu, aux couleurs de la capture.
- **Souffle** : `cran = clip(cran0 + round(2 sin(2π t / 24)) × min(1, cran0 / 6))`. Le faisceau s'éclaircit puis s'assombrit de 2 crans. Les 6 crans les plus sombres sont atténués, et le cran 0 reste figé, pour que le bord ne fasse pas d'arête contre le fond.
- **Lucioles** : 10, dont 6 près de la souche et dans le faisceau, et 4 dans la prairie. Chacune monte de 2 px par phase en ondulant (± 2 ou 3 px), en point de 1 px ou en croix de 3 × 3. Couleurs : (207,255,151), (231,255,199) et (255,255,255), toutes prises dans la rampe du rayon. Au premier build, deux lucioles partaient des racines de la souche ; le test l'a vu, et elles ont été décalées sur le côté.
- **Tests** :
  - rampe identique à la capture, triée ;
  - recalcul des 24 phases du rayon depuis les crans enregistrés, phase 24 = phase 0, souffle de 2 crans exactement, bord figé ;
  - recalcul des lucioles **depuis le manifeste**, phase 24 = phase 0 ;
  - 10 lucioles distinctes à chaque phase, jamais sur la souche, les marches ni le trou.

## Collisions et accès

- `entrance` (384, 560) est au bord sud, dans l'allée. `donjon_seuil` (376, 128) est au pied du trou, sur les marches.
- Le chemin de 16 × 16 px est prouvé par BFS : 2121 cases praticables sur 6912. Les rochers, les arbres, les haies, la souche, le trou, le fond et le rayon sont bloqués (test).
- Les ombres au pied des arbres sont séparées de l'herbe par un contour d'arbre de 1 à 3 px. La connexité est donc calculée sur le praticable fermé de 2 px, mais le masque reste limité aux pixels praticables.
- Quelques poches d'herbe sombre, murées entre les haies et les rochers, ne sont pas reliées au sud et restent bloquées.
- Aucun warp.

## Tests : 11 PASS, 8 mutations vérifiées

Mutations qui font échouer le test visé :

- un pixel du rayon hors rampe ;
- une phase de lucioles décalée (boucle cassée) ;
- la distance du sol complet changée dans le manifeste ;
- un cran de la rampe changé dans le manifeste ;
- une case praticable bloquée dans le Ground ;
- l'image fusionnée de l'ORA altérée ;
- le préfixe `EJS1` repris par un autre lot ;
- le masque des marches vidé.

Build en environ 30 s. **Pas de runtime PMDO, art non approuvé.**
