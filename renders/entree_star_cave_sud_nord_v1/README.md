# ESC1 — Entrée Star Cave sud → nord, format 4:3 vaste

- **Demande** : « poursuis les prochaines maps ! », après EQS1 (27 septembre). C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **grotte de cristaux étoilée (Star Cave)**, choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_star_cave_sud_nord_v1.html` (racine) ou `review/ESC1_scene_animee.webp`. La page d'accueil du serveur d'aperçus (`source/serveur_apercus/serve.py`) le liste en tête.
- Pack PMDO 0.8.12 : `ESC1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `ESC1_`) : `ESC1_calques_png_8px.zip`.
- Source : `source/entree_star_cave_sud_nord_v1/`, 13 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1, et les fonctions génériques (poses, ORA, Ground) d'EQS1. Rien n'est repris des branches sœurs.

## Pourquoi ce biome

Leçon d'EQS1 appliquée : chaque rip candidat a été cherché dans **tout l'arbre** et dans les **70 branches distantes**, et pas seulement dans les lots de la série.

- `starcavepmdsky.png` n'est la source d'**aucun lot**, sur aucune branche. Il n'apparaît que dans des inventaires : `zones_bg_audit_v1`, et `zones_relayout_v1/v2` où il est marqué « pending_layout », jamais produit.
- C'est la seule **grotte de cristaux** de la série.
- Sa 2ᵉ vue montre une bouche sombre au nord : c'est directement le motif d'une entrée.
- Candidats écartés :
  - `secretgarden` : déjà produit sur deux anciennes branches (`jardin_secret`, `secretgarden_reseau`) ;
  - `junglewaterfallzonepmdsky` : ce serait encore une cascade ;
  - `oldcastlepmd` : une salle au trésor, un intérieur ;
  - `roadundergound` (route souterraine violette) et `rockgeyserlike` (geysers) : donnés ici à tort comme libres. **Correction du 27 septembre** : tous deux ont servi de relayouts natifs sur d'anciennes branches (`01a0b211`, et `01a0d42e` / `01a0d546` pour roadundergound), et les geysers sont déjà un motif de notre base (`jungle_geysers_v2`, `steam_cave_geysers_v1`). Voir `REPRISE_MAPS.md`.

## Méthode : textures canoniques par rendu généré référencé

La référence `starcavepmdsky.png` (1008 × 504) contient deux vues de 504 × 504 : la caverne ronde, puis la même avec la bouche. Elle montre :

- un sol bleu acier uni (47,111,151), avec des cratères ronds et de fines fissures ;
- une bande plus sombre contre les parois ;
- des parois de blocs de cristal facettés à reflets cyan ;
- des étoiles de quatre sortes (relevé ci-dessous).

Elle a été **passée au générateur comme image de référence** pour les trois bruts. Les prompts complets sont dans `manifest.json` → `generation`.

1. `bruts/decor.png` (1200 × 896) : décor complet et **nouveau** en 4:3, bon du premier coup.
   - L'arrivée est au sud par un couloir entre deux avancées de cristal. Il débouche sur une grande caverne en double lobe.
   - L'entrée sombre est au nord ; le sol s'assombrit en dégradé jusqu'au trou.
   - Il y a trois groupes de blocs. Les parois de cristal remplissent tous les bords.
   - Le décor est demandé **sans étoiles**, puisqu'elles sont animées sur leur propre calque. Il n'en contient aucune (0 pixel blanc, testé).
2. `bruts/sol_complet.png` : obtenu par édition du décor, bon du premier coup. Les cratères et les fissures sont gardés et prolongés sous les parois.
   - Recalage mesuré autour des cratères : (0, 0), écart 5,03, contre 6,43 au meilleur décalage de 1 px.
3. `bruts/poussiere_etoile_poses.png` (1440 × 720) : planche sur magenta. Pour une fois, la grille 2 × 6 est respectée : une rangée d'orbes, une rangée de nuées. Les fenêtres sont mesurées case par case.
   - **Frange magenta** : le générateur a fondu les grains pâles dans le fond malgré la consigne. Cela fait 2377 pixels teintés, comme (220,105,243).
   - Ces pixels sont traités comme du **fond** : ni gardés ni recolorés.
   - La **nuée 5** est donc écartée, car ses 416 pixels sont tous teintés. La nuée 4 perd 769 pixels sur 1643.
   - L'orbe 5 (un point de 1 px) est exportée mais pas utilisée dans la séquence.

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, avec le même classifieur de pixels des deux côtés. Le vide du rip (39,47,55) et les étoiles sont exclus. Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| sol | 47,111,151 | 50,109,146 | 5,7 | sol | 7,3 |
| cristal | 47,82,116 | 50,85,117 | 5,3 | parois | 4,0 |
| cristal | 47,82,116 | — | — | blocs | 3,9 |


## Normalisation, segmentation et palettes

**Réduction** : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`).

**Segmentation** en pleine résolution, avec des seuils mesurés sur des fenêtres de contrôle :

| Classe | Critère | Mesure |
|---|---|---|
| Sol | couleur du sol à ± 8, fermé 3 px puis ouvert 2 px ; trous < 150 px rendus au sol | sol (49,109,146), écart-type local 0,9 ; 8 trous (cratères, fissures) |
| Blocs | trous du sol ≥ 150 px | 13 blocs |
| Entrée sombre | lum < 45 au haut-centre, ouverture de 4 px, dilatation limitée à lum < 60 | bouche (31,40,49), lum 38 |
| Ombres | sol assombri contigu (≤ 28 px du sol, b − r > 55, écart-type < 7), plus le dégradé devant la bouche (≤ 40 px, lum > 38) | bande de 20 à 25 px (lum 95 → 60) ; sans le dégradé, une bande de paroi séparait le sol de la bouche |
| Parois | le reste, coins sombres compris | écart-type 7 à 11 |

**Palettes séparées** :

| Groupe | Couleurs max |
|---|---|
| Terrain : sol complet, sol, ombres | 96 |
| Cristal : parois, blocs | 96 |
| Entrée sombre | 12 |

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | sol_complet | brut `sol_complet` | fixe |
| 01 | sol | décor généré | fixe |
| 02 | ombres | sol assombri du décor (séparé, pas inventé) | fixe |
| 03 | parois | décor généré | fixe |
| 04 | blocs | décor généré | fixe |
| 05 | profondeur | décor généré | fixe |
| 06 | reflets | rampe cyan du rip sur les facettes | 24 × 5 ticks |
| 07 | etoiles | sprites exacts du rip | 24 × 5 ticks |
| 08 | poussiere_etoile | poses générées | 24 × 5 ticks |

La scène boucle en **120 ticks (2 s)**. Aucun calque n'a d'alpha intermédiaire.

## Animations

**Étoiles** : les 254 étoiles du rip ont été relevées pixel par pixel. Il y en a de quatre formes, reprises telles quelles :

| Forme | Pixels | Nombre dans le rip |
|---|---|---|
| croix blanche | cœur (255,255,255), bras (79,167,207) | 96 |
| croix lavande | cœur (119,127,175), bras (111,119,167) | 70 |
| étoile lavande (losange 5 × 5) | (111,119,167), (119,135,175), cœur (119,127,175) | 48 |
| étoile verte (losange 5 × 5) | (55,159,143), cœur blanc | 40 |

- Il y a deux familles : blanche (point → croix blanche → étoile verte) et lavande (point → croix lavande → étoile lavande). Elles sont tirées 54/46, comme dans le rip.
- Deux cycles de 24 phases :
  - **veille** : l'étoile est toujours visible, grandit puis décroît ;
  - **éclat** : l'étoile jaillit puis s'éteint pendant 17 phases.
- 210 étoiles : 150 sur les parois et les blocs, 60 sur le sol. Elles sont espacées d'au moins 14 px et restent à plus de 8 px de la bouche.
- **Tests** :
  - les 4 formes existent bien dans le rip ;
  - chaque tache, à chaque phase, est un sprite entier et exact ;
  - les fichiers sont identiques au recalcul depuis le manifeste, et la phase 24 est égale à la phase 0.

**Reflets des cristaux** :

- **Facettes** : les pixels de cristal au-dessus du quantile 0,88 de luminance (lum ≥ 106, 31 745 px). Chaque facette reçoit son cran dans la rampe cyan du rip : (71,151,191), (87,167,199), (103,191,215), (135,207,215).
- **Vague** : une vague diagonale (u = x + y, période 480 px) avance de 20 px par phase. Elle relève les facettes de 2 crans au cœur (± 6 px) et d'un cran dans le halo (± 16 px).
- **Tests** :
  - couleurs de la rampe seulement ;
  - reflets sur les facettes seulement ;
  - un reflet n'assombrit jamais ;
  - la vague avance toujours, de 20 px en moyenne.

**Poussière d'étoile** :

- 5 émetteurs sur le sol dégagé, espacés de plus de 110 px.
- L'orbe naît en point, grossit, passe au lavande, puis se disperse en nuée. Le tout monte de 1 px par phase.
- Les émetteurs sont décalés dans la boucle, pour qu'il y ait toujours de la poussière en l'air.

## Collisions et accès

- `entrance` (376, 560) est au sud, au bout du couloir. `donjon_seuil` (376, 120) est la première case 2 × 2 libre sous l'entrée sombre.
- Le chemin de 16 × 16 px est prouvé par BFS.
- Il y a 2814 cases praticables sur 6912. Les parois, les blocs et la bouche sont bloqués (test).
- Aucun warp.

## Tests : 13 PASS, 8 mutations vérifiées

Mutations qui font échouer le test visé :

- phase 5 des étoiles remplacée par la phase 4 ;
- un pixel d'étoile hors des couleurs du rip ;
- une branche de grande étoile retirée ;
- un reflet posé sur le sol ;
- une phase de reflets passée au cran le plus sombre ;
- phase 23 de la poussière égale à la phase 10 ;
- ombres aussi claires que le sol ;
- un grain teinté de magenta.

Build reproductible : 101 fichiers identiques sur 102, seul l'ORA change (horodatages). Il prend environ 30 s. **Pas de runtime PMDO, art non approuvé.**
