# ECV1 — Entrée Couloir violet sud → nord, format 4:3 vaste

- **Demande** : « Push et passe a la prochaine ! », après ETC1 (27 septembre). C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **couloir rocheux violet qui s'ouvre sur une grande salle**, choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_couloir_violet_sud_nord_v1.html` (racine) ou `review/ECV1_scene_animee.webp`. La page d'accueil du serveur d'aperçus le liste en tête.
- Pack PMDO 0.8.12 : `ECV1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `ECV1_`) : `ECV1_calques_png_8px.zip`.
- Source : `source/entree_couloir_violet_sud_nord_v1/`, 12 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1 (`down_class`, palettes, grille) et d'ESN1 (BFS). Rien n'est repris des branches sœurs.

## Pourquoi ce biome

Chaque capture candidate a été cherchée avec `git grep -F` dans les `*.py` et `*.md` des **72 branches distantes** (inventaires exclus).

- `large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png` (312 × 720, 34 couleurs) n'est la source d'**aucun lot**, sur aucune branche : **0 occurrence**. Son titre d'audit, « Couloir rocheux violet » (nom du jeu et de la scène **non confirmé**), n'apparaît que dans notre `REPRISE_MAPS.md`.
- Candidats écartés : `oldcastlepmd` (libre, mais c'est une salle intérieure) ; `iceroadpmdsky` (5 branches), `entrancearidedungeonpmdsky` (6), `arenapmdskybeach` (7), `Mt. Thunder` (3), `Waterfall_Cave_*` (3–4), `Mushroom Forest` (55), `Steam_Cave_Peak` (48), `Murky Forest` (56) : déjà utilisés.
- C'est encore une grotte après ESC1, mais d'une tout autre matière : un sol mauve marbré et des rochers bleu-violet, sans cristaux ni eau.

## Méthode : textures canoniques par rendu généré référencé

La capture montre un sol mauve marbré (93,80,114 ; r > g d'environ 16), des rochers empilés bleu-violet (r = g, b nettement plus haut), des falaises striées sombres sur les bords, un fond bleu nuit et quelques gravillons. Elle a été **passée au générateur comme image de référence** pour les trois bruts. Les prompts complets sont dans `manifest.json` → `generation`.

1. `bruts/decor.png` (1200 × 896) : **premier essai, conforme**. Arrivée au sud par un couloir étroit entre deux parois de rochers. Le couloir s'ouvre sur une grande salle semée de huit amas de rochers. Au nord, un tunnel sombre s'ouvre dans une arche de rochers, et le sol mène jusqu'à lui. Falaises striées au fond, noir hors carte dans les coins.
2. `bruts/sol_complet.png` : sol mauve seul, plein cadre. Moyenne (95,80,113), à **2,1** du sol de la capture. Fond plein : pas de recalage nécessaire.
3. `bruts/poussiere_poses.png` (672 × 1551) : la grille demandée **n'est pas respectée**. Le générateur a posé une colonne de 4 nuages dans un couloir magenta bordé de rochers. Les 4 nuages sont pris par fenêtre, en gardant les pixels mauves (r − g ≥ 10, b − r < 40) à plus de 3 px de tout rocher bleu de la planche (b − r ≥ 40). Les reflets clairs sont rendus au nuage (trous bouchés).

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, même classifieur de pixels des deux côtés. Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| sol mauve | 93.4,79.5,113.7 | 90.6,74.9,110.1 | 6,5 | sol | 8,9 |
| roche bleu-violet | 69.2,69.2,119.4 | 67.6,65.9,114.4 | 6,3 | rochers | 4,5 |
| roche bleu-violet | 69.2,69.2,119.4 | — | — | blocs | 25,6 |

Les **blocs** sont plus clairs que la moyenne : ce sont des rochers isolés, vus surtout par leurs faces éclairées, alors que la moyenne des parois compte aussi les creux sombres entre les rochers. Ils restent sous le seuil.

## Segmentation et palettes

Réduction : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`).

| Classe | Critère (pleine résolution) |
|---|---|
| Profondeur | lum lissée 5 px < 30 au haut-centre, ouverte 3 px, composante qui contient (600, 90), dilatée dans lum < 45 |
| Sol | r − g lissé ≥ 6 et lum lissée > 45, fermé et ouvert 2 px, plus grande composante, trous bouchés |
| Blocs | îlots de roche dans le sol, ≥ 600 px (8 blocs) |
| Gravillons | îlots de roche dans le sol, 12 à 600 px (38) |
| Ombres | sol à lum lissée < 62, à ≤ 30 px d'une paroi ou d'un îlot (lum 51,9 contre 83,0 pour le sol) |
| Vide | lum lissée < 24 hors sol, ouvert 4 px, > 3000 px, relié au bord de l'image. Les creux noirs entre les rochers restent aux rochers |
| Falaise | paroi **striée** : rapport gradient horizontal / vertical lissé 21 px > 1,5, fermé 6 px, > 4000 px |
| Rochers | le reste de la paroi, arche du tunnel comprise |

**Palettes par matière** : sol (sol complet, sol, ombres) 64 ; roche (gravillons, blocs, rochers, falaise) 96 ; sombre (vide, profondeur) 16.

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | sol_complet | brut `sol_complet` | fixe |
| 01 | sol | décor généré | fixe |
| 02 | ombres | sol assombri du décor | fixe |
| 03 | gravillons | décor généré | fixe |
| 04 | blocs | décor généré | fixe |
| 05 | rochers | décor généré | fixe |
| 06 | falaise | décor généré | fixe |
| 07 | vide | décor généré | fixe |
| 08 | profondeur | décor généré | fixe |
| 09 | eboulis | gravillons **exacts** du rip | 24 × 5 ticks |
| 10 | poussiere | poses générées | 24 × 5 ticks |

La scène boucle en **120 ticks (2 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animations

**Éboulis** :

- **Gravillons** : trois composantes de roche de la capture, **entièrement entourées de sol** (8-connexité), relevées avec leurs pixels et leurs couleurs exacts : petit 7 × 6 (y 113, x 136), moyen 10 × 7 (y 131, x 78), gros 12 × 12 (y 130, x 204).
- **Chute** : 4 chutes décalées de 6 phases, chacune au pied d'une paroi. Le point d'impact est le point de sol le plus proche de la cible avec une paroi (rochers ou bloc) 8 px et 20 px au-dessus : (160,165), (503,147), (210,280), (561,269).
- **Trajectoire** : chute accélérée −21, −16, −9, 0 (phases 0–3, impact en phase 3), rebond −3 puis −1, roulement de 4 px (1 px par phase), puis repos. Le gravillon est visible pendant les phases 0–19 et absent pendant 20–23, donc la boucle se referme sans saut. Il y a toujours au moins un gravillon en scène.
- **Tests** : pixels des poses = pixels du rip ; couleurs = sous-ensemble du rip ; recalcul des 24 phases depuis le manifeste ; phase 24 = phase 0 ; chute accélérée, pas de plus de 9 px ni plus de 1 px de roulement par phase ; repos au sol ; point d'impact au pied d'une paroi ; rien sur le tunnel.

**Poussière** :

- **Poses** : 4 fenêtres de la planche, réduites × 1/8 (couverture ≥ 35 %), 6 couleurs tirées de la planche : petit nuage 12 × 11, gros nuage 21 × 18, nuage étalé 24 × 19, volutes 25 × 19.
- **Cadence** : phases 3 à 6 de chaque chute (impact → volutes), soit 16 phases sur 24 sans recouvrement.
- **Tests** : 4 poses de taille croissante, ≤ 28 px ; les 3 premières forment une seule tache (≥ 80 %) ; aucun pixel bleu de rocher ; ≤ 6 couleurs ; recalcul depuis le manifeste.

## Collisions et accès

- `entrance` (384, 560) est au bord sud, dans le couloir d'arrivée. `donjon_seuil` (376, 88) est la première case 2 × 2 libre sous le tunnel.
- **Sol continu jusqu'au tunnel** : le praticable couvre plus de 90 % de la bande centrale sous la bouche (test).
- Le chemin de 16 × 16 px est prouvé par BFS : 2849 cases praticables sur 6912. Les blocs, les rochers, la falaise, le vide et le tunnel sont bloqués (test).
- Aucun warp.

## Tests : 12 PASS, 5 mutations vérifiées

Mutations qui font échouer le test visé :

- un pixel d'éboulis d'une couleur hors rip ;
- un trou dans le calque sol ;
- un pixel de la pose « gros gravillon » modifié ;
- une chute déplacée de 4 px dans le manifeste ;
- une phase de poussière dupliquée (phase 3 = phase 4).

Build en environ 30 s. **Pas de runtime PMDO, art non approuvé.**
