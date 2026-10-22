# Correction du rendu final — Sky Tower Summit D13P03

## Problème

Le précédent export utilisait uniquement la BMA/material-layer de D13P03. Dans Rescue Team, cette couche ne contient pas tout le framebuffer final : le ciel, l’horizon et les nuages sont complétés par des couches matérielles/overlays. Le résultat PMDO affichait donc des tuiles noires ou un décor incomplet malgré une BMA techniquement lisible.

## Source retenue

- décompilation : `pret/pmd-red`, D13P03/gs209 ;
- framework : `PMD-RED-PMDO-PORT` ;
- référence du rendu final visible : `Sky_Tower_summit_RTRB.png`, 551×576 RGBA.

L’image est alignée sur la grille source 69×75 : largeur complétée à 552 px par duplication de la dernière colonne et bande basse prolongée jusqu’à 600 px. Aucun redimensionnement ni filtrage n’est appliqué.

## Conversion

- planche Ground 8 px : `SkyTowerSummitCanonical_Base.tile` ;
- 5 175 entrées, 949 images uniques ;
- erreur de relecture : 0 écart supérieur à 2/255 ;
- Ground `tour_ciel_sommet` : collision et entités gs209 conservées ;
- arène `.rsmap` : reconstruite depuis ce même rendu final ;
- planche combat 24 px : `tour_ciel_sommet_Canonical_Final_Render.tile`.

## Validation

`tools/verify_sky_tower_summit.py` reconstruit le Ground et le compare au PNG final pixel par pixel. Résultat attendu : **0 pixel différent sur 331 200**.

Cette méthode devient la règle pour toute carte dont le rendu final utilise des couches absentes de la BMA seule : valider le framebuffer final, pas uniquement la tilemap brute.
