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
| `GJS1` | Jardin Secret | Grande Arbre-Guilde QG — Arche de Feuilles, Escalier Spirale & Cocons | 4 | `360×368 px` (`45×46` tuiles) | `974×995 px` |
| `GJS2` | Jardin Secret | Grand Arbre Multi-Branches — Dômes Feuillus, Pont Fleuri & Belvédère | 3 | `456×232 px` (`57×29` tuiles) | `1538×718 px` |
| `GJS3` | Jardin Secret | Arbre-Sanctuaire Botanique — Chambre-Gland à Rosace Dorée & Poulie | 3 | `352×256 px` (`44×32` tuiles) | `1077×759 px` |
| `GJS4` | Jardin Secret | Arbre-Observatoire Hélicoïdal — 4 Paliers Fleuris, Cocon Suspendu & Vigie | 4 | `288×352 px` (`36×44` tuiles) | `831×980 px` |
| `GSP1` | Sky Peak (Pic Céleste) | Grande Citadelle-Arbre QG — Cocons Tressés & Gracidées du Pic Céleste | 4 | `352×368 px` (`44×46` tuiles) | `973×995 px` |
| `GSP2` | Sky Peak (Pic Céleste) | Grand Arbre des Nuages — Dômes de Feuilles & Pont aux Rubans Célestes | 3 | `440×256 px` (`55×32` tuiles) | `1370×759 px` |
| `GSP3` | Sky Peak (Pic Céleste) | Grand Arbre-Relais Panoramique — Galerie Ronde, Dômes & Pergola Fleurie | 3 | `360×368 px` (`45×46` tuiles) | `950×965 px` |
| `GSP4` | Sky Peak (Pic Céleste) | Arbre-Observatoire des Cimes — Escalier Spirale, Cocon & Rubans du Ciel | 4 | `280×360 px` (`35×45` tuiles) | `789×996 px` |
