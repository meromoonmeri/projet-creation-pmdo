# EQS1 — Entrée Sables mouvants sud → nord, format 4:3 vaste

- **Demande** : « Poursuis le projet » (27 septembre), après EUL1. C'est la carte suivante de la série des entrées de donjon sud → nord.
- **Biome** : **désert aux sables mouvants**. Comme pour EUL1, il a été choisi par l'agent ; **il reste à confirmer**.
- **Taille** : **768 × 576 px = 96 × 72 cases de 8 px**.

Fichiers :

- Aperçu : `apercu_entree_sables_mouvants_sud_nord_v1.html` (racine) ou `review/EQS1_scene_animee.webp`.
- Pack PMDO 0.8.12 : `EQS1_projet_pmdo_0812.zip`.
- Calques PNG 8 px (préfixe `EQS1_`) : `EQS1_calques_png_8px.zip`.
- Source : `source/entree_sables_mouvants_sud_nord_v1/`, 14 tests.
- Base : branche de session. Les utilitaires viennent d'EWC1 et du gabarit Jungle ; rien n'est repris des branches sœurs.

## Pourquoi ce biome

Avant le choix, on a relevé les références principales déjà utilisées dans la **série des entrées sud → nord**, toutes branches confondues : la branche de session et les sœurs `01a0de11`, `01a0dfad`, `01a0dfe2`, `01a0e001`, `01a0e017` et `01a0e2db`.

- Toutes les références que `REPRISE_MAPS.md` donnait encore comme libres ont été prises entre-temps : Foggy Forest (EFF1/EFF2), Dark Crater Pit (EDP1/ECF1), Waterfall gem (ECC1), Southern Jungle exit et exit 2 (ESJ1, EJT1), Sealed Ruin pit (ESR1), Waterfall ledge (EWL1).
- `witheringdesert.png` n'est la référence d'**aucune entrée de la série**. C'est aussi le **seul désert** de la série ; l'entrée aride de `01a0e017` est un canyon rocheux sans sable mouvant.
- Le rip offre trois effets propres au biome : les chutes de sable, la fosse qui aspire et les rayons de soleil.

Le même rip a **déjà servi hors de la série**. Ces usages ont été relevés avant le commit, en balayant les 70 branches distantes :

- **Duo désert DB1**, sur la base de cette branche (`renders/dungeon_biomes_v1/`, 23 septembre) : une entrée et une zone finale générées, avec le voile météo natif W05. C'est un autre format et une autre série, sans Ground 4:3 ni calques 8 px de ce type.
- **Branche ancienne `01a0d498`** (25 septembre, non fusionnée) : « Furnace Desert en biome eau », le rip d'origine repeint en eau.

Les **sables mouvants** existent aussi dans l'Entrée Ruine (ERN1, réf. Sealed Ruin) : une nappe animée façon rivière Métano. EQS1 a une vraie fosse circulaire aux couleurs du rip Furnace Desert.

## Méthode : textures canoniques par rendu généré référencé

La référence `witheringdesert.png` est **Furnace Desert, version originale** : une zone amie de *PMD Rescue Team*, carte H20P01 selon l'audit de `dungeon_biomes_v1`. Elle montre :

- un sable jaune vif avec des stries ocre ;
- des rochers olive en strates plates arrondies ;
- des pierres dressées ;
- deux chutes de sable en chevrons ;
- une fosse de sable mouvant en anneaux lobés ;
- des rayons de soleil.

Elle a été **passée au générateur comme image de référence**. Les prompts complets sont dans `manifest.json` → `generation`.

Le prompt du décor dit par erreur « Explorers of Sky desert ». Il est gardé tel qu'envoyé ; c'est l'image de référence qui fait foi, et le titre du manifeste est corrigé.

1. `bruts/decor_magenta.png` (1200 × 896) : décor complet et **nouveau** en 4:3, bon du premier coup. La fosse **et** les deux chutes sont en magenta.
   - L'arrivée est au sud, entre des pierres dressées. Le chemin débouche sur un large bassin de sable.
   - Au nord, une falaise en strates porte l'entrée sombre, encadrée par les deux chutes de sable.
   - La fosse est dans la partie est du bassin, **à l'écart du chemin**.
2. `bruts/sol_complet.png` : obtenu par édition du décor, au 2ᵉ essai.
   - Le 1ᵉʳ essai (« only plain sand ») a rendu un aplat jaune lisse, sans stries ni pixel-art. Il a été écarté.
   - Le 2ᵉ garde les stries ocre, le chemin plus clair et les tas de sable au pied des chutes.
   - Recalage mesuré sur le sable du bassin : (0, 0), écart 4,46, contre 4,68 au meilleur décalage de 1 px.
3. `bruts/poussiere_poses.png` : planche sur magenta, 1ᵉʳ essai.
   - Le générateur a rendu 3 rangées au lieu de 2 ; la 3ᵉ répète le tourbillon.
   - On garde 6 bouffées de poussière et 6 tourbillons, choisis à la main par fenêtre, tous réduits à ×1/8 (couverture 0,25).

### Fidélité au rip, mesurée par test

Distances entre couleurs moyennes RGB, avec le même classifieur de pixels des deux côtés. Seuil du test : 35.

| Matière | Rip | Brut généré | Distance brut | Calque final | Distance finale |
|---|---|---|---|---|---|
| sable | 249,226,106 | 245,220,92 | 15,3 | sable | 15,5 |
| roche | 115,107,84 | 106,97,70 | 20,4 | roches | 22,0 |
| roche | 115,107,84 | — | — | pierres | 17,7 |

- **Roche** : celle du rip est un peu plus claire, car les rayons l'éclaircissent sur la capture.
- **Fosse et chutes** : aucune distance n'est calculée, puisqu'elles n'utilisent **que des couleurs du rip** (sous-ensemble testé).

## Normalisation, segmentation et palettes

**Réduction** : facteur uniforme 576/896, recadrage centré à 768, moyenne par classe (`down_class`).

**Segmentation** en pleine résolution, avec des seuils mesurés sur des fenêtres de contrôle du brut :

| Classe | Critère | Mesure |
|---|---|---|
| Fosse et chutes | magenta et frange (r − g > 60 et b − g > 60), dilatés de 2 px ; chutes = composantes qui touchent le haut | 3 composantes |
| Entrée sombre | lum < 55 au haut-centre, **ouverture de 4 px** | sans ouverture, les fentes sombres des rochers formaient des filaments reliés à la bouche |
| Sable | r − b > 95 et r > 175, grande composante, trous < 400 px comblés | sable r − b ≈ 146 ; stries 138-180 ; roche 7-79 |
| Bord de fosse | roche ou sable assombri (lum lissée < 205) à ≤ 14 px de la fosse | la lèvre sombre en haut de la fosse était classée roche |
| Ombres | sable à ≤ 16 px des roches et lum lissée < 200 | lum lissée 174 au contact, 193 à 3-6 px, 201 à 6-10, 216 au-delà de 20 |
| Pierres dressées | composantes de roche de 150 à 5000 px | 7 pierres ; les masses rocheuses font ≥ 80 000 px |
| Roches | le reste, dalles grises comprises | — |

**Palettes séparées** :

| Groupe | Couleurs max |
|---|---|
| Terrain : sol complet, sable, ombres, bord de fosse | 96 |
| Roche : roches, pierres | 64 |
| Entrée sombre | 12 |

## Calques (bas → haut)

| # | Calque | Origine | Animation |
|---|---|---|---|
| 00 | fosse | lignes de 1 px aux couleurs du rip | 12 × 10 ticks |
| 01 | sol_complet | brut `sol_complet` | fixe |
| 02 | sable | décor généré | fixe |
| 03 | ombres | sable assombri du décor (séparé, pas inventé) | fixe |
| 04 | bord_fosse | lèvre sombre du décor | fixe |
| 05 | roche | décor généré | fixe |
| 06 | pierres | décor généré | fixe |
| 07 | profondeur | décor généré | fixe |
| 08 | chutes | chevrons aux couleurs du rip | 24 × 5 ticks |
| 09 | poussiere | poses générées | 24 × 5 ticks |
| 10 | rayons | overlay translucide (255,255,191) | 12 × 10 ticks |

La scène boucle en PPCM = **120 ticks (2 s)**.

## Animations

**Fosse de sable mouvant** :

- La séquence de lignes de 1 px est relevée sur le rip, du bord vers le centre : `(255,255,95) (255,239,95) (255,223,95) (255,231,95) (255,223,95) (255,239,95)`, soit une période de 6 px.
- Les lignes sont indexées par la distance au bord, avec 6 lobes (amplitude 2,5 px) qui tournent d'un tour en 12 phases.
- Les anneaux **s'enfoncent vers le centre** de 0,5 px par phase, soit une séquence complète en 12 phases.
- Le liseré clair du bord reste fixe.
- **Test** : les phases 0, 5 et 11 sont recalculées depuis le manifeste, et la phase 12 est égale à la phase 0. L'avance vers le centre est mesurée à lobes neutralisés : entre 0 et 1,5 px à chaque pas, 0,5 en moyenne.

**Chutes de sable** :

- Le motif du rip a été relevé caractère par caractère : fond (255,215,95) et zigzags en V, pointes vers le bas.
  - Pas horizontal de 15 px, rangées tous les 16 px, décalées d'un demi-pas une fois sur deux.
  - Liseré de 2 px et cœur de 3 px, avec 3 paires de couleurs en cycle.
- Le motif est **redessiné** avec les couleurs exactes, pas copié.
- La période est de 96 px (quinconce × cycle des couleurs), avec un défilement de 4 px vers le sud par phase sur 24 phases.
- **Test** : translation pure de chaque phase à la suivante, 23 → 0 compris.

**Poussière** :

- Au pied de chaque chute, 2 bouffées sont décalées d'une demi-vie : il y a toujours de la poussière.
- 3 tourbillons de grains naissent sur le sable dégagé, grossissent, tournent, se dispersent et dérivent de 1 px vers l'est par phase active.
- Les tourbillons sont détourés au sable et restent à plus de 40 px de la fosse.

**Rayons de soleil** :

- Sur le rip, l'éclaircissement est **additif** : +53 sur le ciel (63,127,255 → 116,180,255), environ +19 sur le halo de sable plus bas, et il s'estompe vers le bas.
- PMDO mélange les calques en alpha. On pose donc la couleur du rip (255,255,191) avec un alpha équivalent : 0,28-0,41 sur le ciel et 0,30 sur le sable, d'où un alpha maximal de 80/255 et des paliers de 16.
- 5 rayons parallèles, de pente dx/dy = 0,95 (mesurée sur le rip), s'estompent jusqu'à 62 % de la hauteur. Leur largeur respire de ± 1,5 px.
- Aucun rayon ne touche l'entrée sombre (test).
- C'est le seul calque à alpha intermédiaire. Le codec `.tile` prémultiplie l'alpha, donc le test d'aller-retour compare après prémultiplication.

## Collisions et accès

- `entrance` (384, 560) est au sud, sur le sable. `donjon_seuil` (368, 152) est la première case 2 × 2 libre sous l'entrée sombre.
- Le chemin de 16 × 16 px est prouvé par BFS.
- Il y a 2454 cases praticables sur 6912. La fosse, son bord, les roches, les pierres, les chutes et la bouche sont bloqués (test).
- Aucun warp.

## Tests : 14 PASS, 7 mutations vérifiées

Mutations qui font échouer le test visé :

- phase 5 de la fosse remplacée par la phase 4 ;
- un pixel de la fosse hors des couleurs du rip ;
- phase 12 des chutes égale à la phase 11 ;
- phase 23 de la poussière égale à la phase 10 ;
- lumière sur l'entrée sombre ;
- alpha hors paliers dans les rayons ;
- ombres aussi claires que le sable.

Le build prend environ 30 s. **Pas de runtime PMDO, art non approuvé.**
