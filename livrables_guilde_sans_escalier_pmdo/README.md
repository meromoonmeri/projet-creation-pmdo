# Treehouses Monumentales de Guilde SANS ESCALIER EXTÉRIEUR — Jardin Secret & Sky Peak (PMDO 0.8.12)

## Règles architecturales strictes respectées sur 8 / 8 structures
- **ZÉRO escalier extérieur (`exterior_stairs_count: 0`)** : aucune rampe hélicoïdale externe ni volée de marches extérieure ; l'entrée se fait de plain-pied au pied du tronc creux et toute l'ascension s'effectue à l'intérieur du tronc vivant (hublots ronds, rosaces dorées, baies vitrées cintrées, monte-charges à poulie, balcons et cocons débouchant directement des portes hautes).
- **ZÉRO toiture pyramidale / pointue (`pyramidal_roofs_count: 0`)** : uniquement coupoles de feuilles rondes, cocons tressés sphériques, chambres-glands galbées, galeries cylindriques, pergolas plates et belvédères circulaires.
- **4 structures Style Jardin Secret (`GJN1`–`GJN4`)** + **4 structures Style Sky Peak / Pic Céleste (`GSN1`–`GSN4`)**.
- **Transparence binaire stricte** : PNG `RGBA` 100 % sans fond (`alpha ∈ {0, 255}`, `0 px` de halo chromatique).
- **Découpes `Avant_Base` / `Arriere_Under`** : partition exacte des pixels visibles sur frontière `8 px` sans reconstruction des pixels occultés.
- **Statut moteur** : `art_approved: false`, `runtime_tested: false`.

## Catalogue des 8 structures sans escalier extérieur

| Code `.tile` | Biome | Structure | Niveaux | Dimensions 1× PMDO (`8×8`) | Dimensions HD |
|---|---|---|---:|---:|---:|
| `GJN1` | Jardin Secret | Grande Arbre-Guilde QG à Tronc Creux — Cocons Suspendus, Rosace & Poulie | 4 | `360×240 px` (`45×30` tuiles) | `599×384 px` |
| `GJN2` | Jardin Secret | Arbre-Sanctuaire des Archives — Chambre-Gland à Rosace Dorée, Cocon & Balcon | 3 | `288×304 px` (`36×38` tuiles) | `632×640 px` |
| `GJN3` | Jardin Secret | Grand Arbre-Pont à 3 Houppiers — Baie Vitrée Courbe, Dômes & Passerelle Fleurie | 4 | `376×224 px` (`47×28` tuiles) | `640×355 px` |
| `GJN4` | Jardin Secret | Haute Tour-Arbre Creuse d'Observation — 4 Étages Internes, Cocons & Vigie | 5 | `192×328 px` (`24×41` tuiles) | `378×640 px` |
| `GSN1` | Sky Peak (Pic Céleste) | Grande Citadelle-Arbre QG — Tronc Creux, Cocons Tressés & Îlot aux Gracidées | 4 | `280×312 px` (`35×39` tuiles) | `348×383 px` |
| `GSN2` | Sky Peak (Pic Céleste) | Grand Relais Panoramique — Rotonde Vitrée Cintrée, Dômes & Pergola Plate Fleurie | 3 | `288×304 px` (`36×38` tuiles) | `625×627 px` |
| `GSN3` | Sky Peak (Pic Céleste) | Grand Arbre des Nuages à 3 Houppiers — Chambre-Gland Centrale & Dômes Latéraux | 3 | `376×192 px` (`47×24` tuiles) | `640×304 px` |
| `GSN4` | Sky Peak (Pic Céleste) | Haute Tour-Arbre Céleste Creuse — Rosace d'Or, Monte-Charge, Cocon & Belvédère | 4 | `272×288 px` (`34×36` tuiles) | `630×640 px` |
