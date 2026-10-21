# Treehouses Monumentales de Guilde — Styles Jardin Secret & Sky Peak (PMDO 0.8.12 / Halcyon 8×8)

## Direction artistique & contraintes respectées
- **Zéro toiture pyramidale / pointue / triangulaire** : 100 % architectures organiques rondes (coupoles de feuilles courbes, cocons tressés sphériques, chambres-glands galbées, galeries cylindriques, pergolas plates et belvédères circulaires).
- **4 structures Style Jardin Secret (`GJS1`–`GJS4`)** : feuillage vert pomme/chartreuse lumineux, grappes florales corail/lilas/or, racines moussues et rochers gréseux chauds.
- **4 structures Style Sky Peak / Pic Céleste (`GSP1`–`GSP4`)** : feuillage menthe-émeraude d'altitude, bouquets de Gracidées rose corail à 5 pétales, rubans blancs du ciel et rochers alpins gris-bleutés ciselés.
- **Transparence native stricte** : PNG `RGBA` 100 % sans fond (`alpha ∈ {0, 255}`, `0 px` de halo chromatique).
- **Découpe de calques (`Arriere_Under` / `Avant_Base`)** : séparation de surface visible sur frontière multiple de `8 px` (`Avant_Base ∪ Arriere_Under == Complet`, `∩ == ∅`). Cette découpe ne reconstruit pas les pixels occultés derrière les éléments de premier plan.
- **Statut d'intégration moteur** : `art_approved: false`, `runtime_tested: false` (prêt à importer dans `Content/Tile/` PMDO 0.8.12 / Tiled).

## Catalogue des 8 structures monumentales

| Code `.tile` | Biome | Structure | Étages | Dimensions 1× PMDO (`8×8`) | Dimensions HD |
|---|---|---|---:|---:|---:|
| `GJS1` | Jardin Secret | Grande Arbre-Guilde QG — Arche de Feuilles, Escalier Spirale & Cocons | 4 | `288×304 px` (`36×38` tuiles) | `627×640 px` |
| `GJS2` | Jardin Secret | Grand Arbre Multi-Branches — Dômes Feuillus, Pont Fleuri & Belvédère | 3 | `368×184 px` (`46×23` tuiles) | `640×298 px` |
| `GJS3` | Jardin Secret | Arbre-Sanctuaire Botanique — Chambre-Gland à Rosace Dorée & Poulie | 3 | `312×232 px` (`39×29` tuiles) | `547×386 px` |
| `GJS4` | Jardin Secret | Arbre-Observatoire Hélicoïdal — 4 Paliers Fleuris, Cocon Suspendu & Vigie | 4 | `240×288 px` (`30×36` tuiles) | `546×640 px` |
| `GSP1` | Sky Peak (Pic Céleste) | Grande Citadelle-Arbre QG — Cocons Tressés & Gracidées du Pic Céleste | 4 | `288×304 px` (`36×38` tuiles) | `626×640 px` |
| `GSP2` | Sky Peak (Pic Céleste) | Grand Arbre des Nuages — Dômes de Feuilles & Pont aux Rubans Célestes | 3 | `360×216 px` (`45×27` tuiles) | `640×355 px` |
| `GSP3` | Sky Peak (Pic Céleste) | Grand Arbre-Relais Panoramique — Galerie Ronde, Dômes & Pergola Fleurie | 3 | `288×304 px` (`36×38` tuiles) | `630×640 px` |
| `GSP4` | Sky Peak (Pic Céleste) | Arbre-Observatoire des Cimes — Escalier Spirale, Cocon & Rubans du Ciel | 4 | `232×304 px` (`29×38` tuiles) | `507×640 px` |
