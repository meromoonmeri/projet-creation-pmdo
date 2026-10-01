# EMT1 — Entrée Mt. Thunder sud → nord, format 4:3 vaste

- **Demande** : « Continue ! Très bon travail », après ECV1 (27 septembre). C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **sommet d'orage au-dessus des nuages**, choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_mt_thunder_sud_nord_v1.html` (racine) ou `review/EMT1_scene_animee.webp`. La page d'accueil du serveur d'aperçus le liste en tête.
- Pack PMDO 0.8.12 : `EMT1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `EMT1_`) : `EMT1_calques_png_8px.zip`.
- Source : `source/entree_mt_thunder_sud_nord_v1/`, 10 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1 (`down_class`, palettes, grille) et d'ESN1 (BFS) ; `write_ora` et `ground_project` sont repris d'ECV1. Rien n'est repris des branches sœurs.

## Pourquoi ce biome

Relevé du 27 septembre sur les **97 images de la racine**, par `git grep -o -F` dans les `*.py` et `*.md` des **72 têtes**, inventaires exclus. Les clés sont courtes, parce que les lots citent souvent une forme abrégée : le code pour les `large.*` (`P04P01C`), le nom du lieu pour les noms GBA/DS (`Mt. Thunder`), le radical pour les autres. Un premier passage avec les noms de fichiers complets sous-comptait beaucoup, par exemple `Murky Forest` à 0 au lieu de 56.

- **Plus aucune capture de la racine n'est libre partout**, sauf `oldcastlepmd` (une salle intérieure). `large.P21P02A` (0 occurrence) est un doublon de `forêtglomypmdsky`, déjà utilisé sur 48 branches.
- **Mt. Thunder** n'a jamais servi à une **entrée** de la série. Il n'a servi qu'à `mt_thunder_orage_v1`, sur trois anciennes branches (`01a0d8a8`, `01a0d9b3`, `01a0d9f7`), dont rien n'est repris. C'est le même cas qu'EQS1 avec `witheringdesert`.
- La planche apporte des **sprites d'animation exacts** : 4 éclairs, l'arc « Flash » et les couleurs « Normal » / « Fading ».
- Autre candidat au même statut : `secretgarden` (jardin secret sur `01a0d315` et `01a0d4b6`), gardé pour la suite.

## Méthode : textures canoniques par rendu généré référencé

La planche (432 × 498) a deux parties :

- **Scène** (y < 352) : plateau de sable jaune pâle (232,224,160), falaises de roche brune, pics, mer de nuages d'orage en tons discrets, du ciel (64,56,64) au blanc (240,240,240).
- **Planche d'animation** (y ≥ 352, fond noir) : 4 éclairs d'une seule couleur (240,240,0), l'arc « Flash » en (240,240,128), et deux paires de pastilles : « Normal » (240,240,128) et (240,240,0), « Fading » (184,176,120) et (160,152,32). Note de la planche : « Taken from the left side. Beside the first lightning, they all appear mirrored on the right side. »

La planche a été **passée au générateur comme image de référence** pour les deux bruts. Les prompts complets sont dans `manifest.json` → `generation`.

1. `bruts/decor.png` (1200 × 896) : **premier essai, conforme**. On arrive au sud par une crête de sable étroite qui sort des nuages. Elle monte vers un grand plateau de sable bordé de falaises, coupé par une falaise en gradin ouverte au centre. Pics et pierres moussues. Au nord, une grotte dans un piton de la même roche. Mer de nuages sur les côtés, ciel d'orage en haut.
2. `bruts/sol_complet.png` : sable seul, plein cadre. Moyenne (234,225,157), à **3,7** du sable de la capture. Le sable de la capture est lui aussi presque uni.

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, même classifieur de pixels des deux côtés, sur la **scène** du rip (y < 352). Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| sable | 231.5,222.3,156.5 | 229.4,219.9,154.1 | 4,0 | sable | 5,8 |
| roche brune | 166.1,141.3,115.7 | 161.5,137.3,112.6 | 6,8 | falaise / piton | 10,4 / 2,2 |
| ciel (gris, lum < 90) | 64.2,56.2,64.1 | 59.3,52.3,60.0 | 7,4 | ciel | 7,9 |
| nuages sombres (lum 90–170) | 127.7,119.7,127.7 | 138.7,131.2,138.9 | 19,5 | nuages | 16,6 |
| nuages clairs (lum ≥ 170) | 219.3,219.2,219.2 | 211.6,211.4,211.3 | 13,5 | nuages | 15,9 |

**Mesure des nuages par ton, et pourquoi** : la première mesure prenait tous les gris de l'orage en un seul groupe et donnait **41,3**, au-dessus du seuil. Mais les nuages sont faits de tons discrets, et leur moyenne dépend surtout des proportions : la scène du rip compte beaucoup de ciel sombre, alors que le bas de la carte générée est blanc. Cette mesure compare donc la composition, pas la couleur. Elle est remplacée par la mesure par ton, et gardée dans le manifeste (`nuages_un_seul_groupe_ecarte`) avec sa raison ; un test la recalcule.

## Segmentation et palettes

Réduction : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`).

| Classe | Critère (pleine résolution) |
|---|---|
| Profondeur | lum < 55 au haut-centre, ouverte 3 px, composante qui touche (580–620, 110–160), dilatée dans lum < 70 |
| Sable | r > 195, g > 175, r − b > 45, fermé et ouvert 2 px, > 20000 px, trous bouchés |
| Relief | sable + roche brune + grotte, fermé 3 px, trous bouchés. La rangée du haut compte comme relief au-dessus du piton, dont le sommet gris touche le bord |
| Pics | îlots du sable ≥ 150 px (14), fermés et bouchés : les pics sont clairs à l'intérieur, seul leur contour sortait |
| Cailloux | îlots du sable de 12 à 150 px (42) |
| Seuil | roche sous la bouche entre les montants de l'arche, colonne par colonne jusqu'au premier sable (≤ 30 px) |
| Piton | roche du relief à y < 190 et 430 < x < 780 |
| Falaise | le reste de la roche |
| Ciel | gris de lum < 90 hors relief, ouvert 3 px, relié au bord haut |
| Nuages | le reste hors relief |

**Seuil** : sans ce calque, le sol de terre de la grotte (un dégradé du sombre au sable) tombait dans le piton. La bande praticable sous la bouche n'atteignait que 75 %, et le marqueur de seuil restait à 13 px de la grotte. C'est la recette d'ETC1.

**Palettes par matière** : sable (sol complet, sable) 32 ; roche (cailloux, pics, falaise, piton, seuil) 96 ; orage (ciel, nuages) 32 ; grotte 12.

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | sol_complet | brut `sol_complet` | fixe |
| 01 | sable | décor généré | fixe |
| 02 | cailloux | décor généré | fixe |
| 03 | pics | décor généré | fixe |
| 04 | falaise | décor généré | fixe |
| 05 | piton | décor généré | fixe |
| 06 | seuil | décor généré | fixe |
| 07 | profondeur | décor généré | fixe |
| 08 | ciel | décor généré | fixe |
| 09 | nuages | décor généré | fixe |
| 10 | lueurs | arc « Flash » **exact** de la planche | 48 × 5 ticks |
| 11 | eclairs | 4 éclairs **exacts** de la planche | 48 × 5 ticks |

La scène boucle en **240 ticks (4 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animations

- **Sprites** : chaque éclair est la seule composante de (240,240,0) dans sa boîte de la planche. L'arc est l'ensemble des pixels (240,240,128) de sa boîte. Test : les poses sont identiques aux pixels de la planche.
- **Couleurs** : l'éclair est en (240,240,0) pendant 2 phases (« Normal »), puis en (160,152,32) pendant 2 phases (« Fading »), puis disparaît. L'arc suit, en (240,240,128) puis (184,176,120). C'est une **interprétation** des pastilles : paire pâle pour l'arc (qui est dessiné en pâle), paire vive pour l'éclair (dessiné en vif).
- **Frappes** : 6 par boucle, une toutes les 8 phases, jamais deux à la fois.

  | Éclair | Côté | Phase |
  |---|---|---|
  | 1 | gauche | 0 |
  | 3 | miroir à droite | 8 |
  | 2 | gauche | 16 |
  | 4 | miroir à droite | 24 |
  | 3 | gauche | 32 |
  | 2 | miroir à droite | 40 |

  L'éclair 1 frappe à gauche seulement, comme l'indique la planche.
- **Arc** : centré sous le point le plus bas de l'éclair. Il s'allume sur le nuage où l'éclair touche.
- **Limite** : l'éclair 3 touche le bas de la planche (y = 498) ; il est peut-être tronqué.
- **Tests** :
  - pastilles lues sur la planche ;
  - couleurs exactes par calque et par phase ;
  - recalcul des 48 phases **depuis le manifeste**, positions des arcs comprises ; phase 48 = phase 0 ;
  - Normal → Fading → rien ; jamais deux éclairs à la fois ;
  - éclair 1 à gauche seulement ;
  - éclairs et arcs uniquement sur le ciel et les nuages, à plus de 2 px du relief ;
  - l'arc s'allume exactement quand l'éclair est là.

## Collisions et accès

- `entrance` (384, 560) est au bord sud, sur la crête. `donjon_seuil` (376, 96) est au ras de la grotte, sur le seuil.
- **Sable jusqu'à la grotte** : sous la bouche, le seuil puis le sable sont praticables à plus de 90 % dans la bande centrale (test).
- Le chemin de 16 × 16 px est prouvé par BFS : 1385 cases praticables sur 6912. Les pics, la falaise, le piton, la grotte, le ciel et les nuages sont bloqués (test).
- Aucun warp.

## Tests : 10 PASS, 6 mutations vérifiées

Mutations qui font échouer le test visé :

- un pixel d'éclair blanc (hors planche) ;
- un pixel d'éclair posé sur le plateau ;
- une phase « Fading » figée (phase 10 = phase 8) ;
- une frappe déplacée de 6 px dans le manifeste. Elle passait au premier essai, parce que le test recalculait depuis les constantes du build ; il recalcule désormais depuis le manifeste ;
- un arc allumé sans éclair (phase 5 = phase 0) ;
- un trou dans le calque sable.

Build en environ 45 s. **Pas de runtime PMDO, art non approuvé.**
