# ETC1 — Entrée Clairière tropicale sud → nord, format 4:3 vaste

- **Demande** : « continue ! », après ESC1 (27 septembre). C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **clairière tropicale avec arrivée par un ponton**, choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_clairiere_tropicale_sud_nord_v1.html` (racine) ou `review/ETC1_scene_animee.webp`. La page d'accueil du serveur d'aperçus le liste en tête.
- Pack PMDO 0.8.12 : `ETC1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `ETC1_`) : `ETC1_calques_png_8px.zip`.
- Source : `source/entree_clairiere_tropicale_sud_nord_v1/`, 13 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1 (`down_class`, palettes, grille) et d'ESN1 (BFS). Rien n'est repris des branches sœurs.

## Pourquoi ce biome

Chaque capture candidate a été cherchée avec `git grep` dans les `*.py` et `*.md` des **72 branches distantes et de main**, et pas seulement par nom de lot.

- `large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png` (456 × 456) n'est la source d'**aucun lot**, sur aucune branche. Il n'apparaît que dans l'inventaire `zones_bg_audit_v1`, sous le titre « Clairière tropicale et rive » (nom du jeu et de la scène **non confirmé**).
- C'est le premier biome **tropical** de la série, et la première arrivée **par la mer**.
- Candidats écartés : `lakecrystalpmdsky` et `bassinchauffantpmdsky` (déjà utilisés sur la branche sœur `01a0e017`) ; `large.P04P01C` (déjà dans `references_fideles_v1` sur des dizaines de branches) ; `large.P27P01A` (cité par `maps_v17_spec`) ; `large.S05P03A` (couloir violet, libre, gardé pour la suite, mais encore une grotte après ESC1).

## Méthode : textures canoniques par rendu généré référencé

La capture montre une herbe claire vert-jaune (183,214,97), une jungle de buissons vert sombre, des palmiers, des hibiscus rouges, jaunes, cyan et roses, des dalles de sable, une rive de terre, un ponton de bois et une mer à bandes de vagues. Elle a été **passée au générateur comme image de référence**. Les prompts complets sont dans `manifest.json` → `generation`.

1. **Premier décor, écarté** (`bruts/ecartes/decor_magenta_essai1_herbe_acide.png`) : la composition était bonne, mais l'herbe était **acide** (226,242,51) : distance 69,8 au rip, au-dessus du seuil de 35. Le brut n'a pas été retouché ; il est gardé pour la traçabilité et n'est jamais lu par le build (test).
2. `bruts/decor_magenta.png` (1200 × 896) : **nouvelle génération**, édition du premier essai avec le rip en seconde référence, pour recaler l'herbe et la jungle sur la capture. Mer en **magenta pur**.
   - Arrivée au sud par un long ponton sur la mer. Chemin de dalles vers le nord à travers une grande clairière bordée de jungle, de palmiers et de fleurs. Entrée sombre dans un tertre de terre et de roche au nord.
3. `bruts/sol_complet.png` : herbe seule, éditée depuis le décor. Recalage (0, 0) : écart 4,40 contre 4,61 à 1 px.
4. `bruts/temoin_sans_objets.png` : le même décor **sans palmiers, fleurs, touffes ni cailloux**. Recalage (0, 0) : écart 7,52 contre 9,85 à 1 px. La différence décor − témoin isole les objets (59 : 6 palmiers, 22 massifs de fleurs, 31 touffes et cailloux). Ce témoin n'est jamais exporté.
5. `bruts/papillons_poses.png` (1024 × 1024) : planche 2 × 6 sur magenta, grille respectée. Un papillon orange, un papillon jaune, six poses de battement chacun.

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, même classifieur de pixels des deux côtés. Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| herbe claire | 182.6,213.5,96.7 | 199.0,224.2,90.9 | 20,4 | herbe | 20,4 |
| jungle | 103.8,138.7,50.7 | 85.7,131.0,25.5 | 32,0 | jungle | 33,5 |
| dalles | 239.6,209.1,147.1 | 231.8,198.9,125.5 | 25,1 | dalles | 13,3 |
| herbe (essai écarté) | 182.6,213.5,96.7 | 226.6,241.7,50.5 | **69,8** | — | — |

La jungle est la matière la plus éloignée (un peu plus sombre et plus saturée que la capture), mais elle reste sous le seuil.

## Segmentation et palettes

Réduction : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`).

| Classe | Critère (pleine résolution) |
|---|---|
| Mer | magenta **relié au bord sud** (les hibiscus roses passent le test de teinte mais ne sont pas reliés), plus le **filet clair rose-blanc** que le générateur a peint contre la rive (2484 px), rendu à l'eau |
| Ponton | colonnes non-eau du bas de l'image (x 559–641), jusqu'à la première rangée d'herbe |
| Entrée sombre | lum < 45 au haut-centre, ouverture 3 px, dilatation limitée à lum < 60 |
| Palmiers, fleurs, touffes | objets décor − témoin : > 2500 px = palmier ; ≥ 12 % de pixels de fleur saturés = fleurs ; le reste = touffes et cailloux |
| Rive | brun à moins de 60 px de l'eau |
| Seuil | sol de terre de la bouche (lum 45–110), entre les montants de l'arche |
| Tertre | beige-brun au nord ; rien sous la bouche entre les montants |
| Dalles | beige dans la clairière, 30 à 4000 px |
| Herbe | luminance lissée 9 px > 178 |
| Ombres | herbe assombrie **au pied du tertre** (lum 162 contre 202), à ≤ 45 px du tertre, plus la transition terre → herbe devant la bouche |
| Jungle | le reste |

**Ombres** : contre la jungle, l'herbe ne s'assombrit pas (lum 199 à 0–3 px, 202 au-delà). Il n'y a donc d'ombres qu'au pied du tertre, séparées du rendu, pas inventées.

**Palettes par matière** : un groupe partagé herbe + dalles + touffes ramenait les dalles au vert (0 pixel de sable), et un groupe fleurs + jungle effaçait les hibiscus (0 pixel saturé). D'où six groupes : herbe (sol complet, herbe, ombres) 96, dalles et touffes 64, fleurs 48, végétation (jungle, palmiers) 96, terre et bois (tertre, seuil, rive, ponton) 64, entrée sombre 12.

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | sol_complet | brut `sol_complet` | fixe |
| 01 | herbe | décor généré | fixe |
| 02 | ombres | herbe assombrie du décor | fixe |
| 03 | dalles | décor généré | fixe |
| 04 | touffes | décor généré (touffes et cailloux) | fixe |
| 05 | fleurs | décor généré | fixe |
| 06 | jungle | décor généré | fixe |
| 07 | palmiers | décor généré | fixe |
| 08 | tertre | décor généré | fixe |
| 09 | seuil | décor généré | fixe |
| 10 | profondeur | décor généré | fixe |
| 11 | rive | décor généré | fixe |
| 12 | ponton | décor généré | fixe |
| 13 | mer | profil, crête et couleurs exacts du rip | 24 × 5 ticks |
| 14 | papillons | poses générées | 24 × 5 ticks |

La scène boucle en **120 ticks (2 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animations

**Mer** :

- **Profil** : les 48 couleurs de la colonne x = 0 du rip, de la crête (215,231,247) en y = 404 jusqu'à la suivante. Il y a 9 bleus, du blanc de crête à (15,95,199).
- **Crête** : pour chaque colonne x = 0..71 du rip, la première rangée blanche. Ce tronçon se referme sur lui-même (y = 404 en x = 0 et en x = 72), donc la crête se répète tous les 72 px sans saut, et la banque de tuiles reste petite.
- **Défilement** : les vagues montent de **2 px par phase** vers la rive (48 px en 24 phases, boucle fermée).
- **Rive, sans liseré** : le filet blanc du rip contre la rive n'est **pas** repris. À ≤ 2 px de la terre (et du ponton), seule la **bande sombre** (15,95,199) du rip. À ≤ 8 px, les couleurs claires deviennent (63,143,215) : la crête s'apaise avant d'arriver. Les bords de l'image comptent comme de l'eau.
- **Tests** : couleurs = sous-ensemble du rip ; profil et crête identiques au rip ; recalcul depuis le manifeste ; phase 24 = phase 0 ; avance exacte de 2 px au large ; bande sombre sur chaque pixel qui touche la terre ; aucune couleur claire à ≤ 8 px ; pas d'eau à moins de 150 px de l'entrée.

**Papillons** :

- **Poses** : fenêtres de 180 px réduites × 1/12, 10 couleurs tirées de la planche. Les papillons étroits sont à 115–135 px de leurs voisins : chaque fenêtre ne garde que la composante qui contient son centre, sinon des bouts des voisins apparaissaient.
- **Battement** : poses 0, 1, 2, 3, 4, 3, 2, 1 (8 phases, 3 battements par boucle). La pose 5 (identique à la pose 0) n'est pas utilisée.
- **Vol** : 4 papillons (2 orange, 2 jaunes) en huit fermé au-dessus de la clairière, x = cx + ax·sin(2πt/24), y = cy + ay·sin(4πt/24), décalés dans la boucle.
- **Tests** : recalcul depuis le manifeste ; phase 24 = phase 0 ; pas de moins de 16 px entre deux phases (23 → 0 compris) ; une seule tache par pose ; rien sur l'entrée sombre.

## Collisions et accès

- `entrance` (384, 560) est sur le ponton, au bord sud. `donjon_seuil` (368, 160) est la première case 2 × 2 libre sous l'entrée sombre, sur le seuil de terre.
- **Sol sec jusqu'à la bouche** : sous l'entrée, entre les montants, ni jungle ni eau (test). Le praticable couvre plus de 90 % de la bande centrale sous la bouche.
- Le chemin de 16 × 16 px est prouvé par BFS : 1824 cases praticables sur 6912. La jungle, les palmiers, le tertre, la rive, la mer et la bouche sont bloqués (test). Les fleurs sont hors du praticable.
- Aucun warp.

## Tests : 13 PASS, 5 mutations vérifiées

Mutations qui font échouer le test visé :

- un trait blanc de crête (215,231,247) posé sur la rive ;
- une phase de la mer figée (phase 4 = phase 3) ;
- une phase des papillons dupliquée (phase 8 = phase 7) ;
- les ombres passées à la couleur moyenne de l'herbe ;
- de la jungle devant la bouche.

Build en environ 30 s. **Pas de runtime PMDO, art non approuvé.**
