# Relict — pilote de conversion Map → Ground PMDO

## Verdict

**`PMDO_RUNTIME_VALIDATION_PASS` — artefact `PMDO_VALIDATED`, intégration
`ADAPTATION_REQUIRED`.**

La Map source 012 (« Playa ») est convertie de façon reproductible en Ground
PMDO 0.8.12 et atlas `.tile`, puis chargée dans le runtime headless exact. Le
pilote reste entièrement sous `external/BIBLIOTHEQUE_WORKSPACE/` : aucune
destination runtime, aucun Ground certifié, aucune route et aucun chapitre
historique n'ont été modifiés.

Le statut documentaire de la Zone source reste `SOURCE_DOCUMENTED`. Le statut
`PMDO_VALIDATED` qualifie uniquement l'artefact pilote dérivé.

## Choix du pilote

Map 012 est un pilote environnemental utile et borné :

- extérieur 35×33 tuiles de 32 px, soit 1120×1056 px ;
- trois couches source conservées dans leur ordre ;
- 974 tuiles bloquées et 181 libres ;
- aucun masque directionnel partiel ;
- tags terrain source 0, 3 et 7 conservés dans l'IR ;
- aucun événement, placement, acteur, panorama, brouillard ou VFX scripté ;
- deux définitions d'autotiles animés utilisées, à huit frames et 250 ms/frame.

Ce choix valide le cœur graphique et collisionnel sans confondre conversion de
Map et adaptation narrative.

## Représentation intermédiaire commune

Le contrat `schemas/map_ir.schema.json` sépare :

- identité, provenance et hashes source ;
- géométrie et matrices row-major de chaque couche ;
- masque de sorties directionnelles et tags terrain par tuile ;
- pages/placements d'entités expurgés ;
- panorama, fog et timeline visuelle ;
- autotiles, VFX environnementaux et animations Map ;
- contraintes de conversion et contenus interdits.

L'importeur Relict normalise les IDs RMXP utilisés en catalogue de frames RGBA
32×32. Pour Map 012, le catalogue contient 58 IDs (dont la tuile vide), 225
frames hashées et 24 variantes de tuile animées totalisant 192 frames. Le
convertisseur PMDO ne lit ni Marshal ni les conventions RMXP : Nova et
Reminiscencia pourront alimenter le même contrat via leurs propres importeurs.

## Ground et atlas produits

| Élément | Résultat |
|---|---:|
| Grille graphique | 35×33, `TexSize=4` |
| Couches Ground | 3 |
| Grille de collision PMDO | 140×132 cellules de 8 px |
| Cellules PMDO bloquées | 15 584 |
| Atlas | 133 entrées/payloads dédupliqués |
| Taille atlas | 42 426 octets |
| Timing autotile | 250 ms = 15 ticks PMDO à 60 Hz |
| Hash Ground | `5456299e6c64f51e7a69ae8e0af9089b3b1fab63d65dab757196882a087d5017` |
| Hash atlas | `ae3578078911215b0697994a3a5b457fb5d9ace9841c545a0e659dd6f7275ace` |

Le rendu statique du Ground reconstruit est identique pixel par pixel aux trois
couches documentées et au composite source au tick 0 : zéro pixel différent,
zéro delta de canal. Le tick 15 est distinct du tick 0, ce qui prouve que le
cycle d'eau n'a pas été aplati.

## Validation PMDO exacte

La validation réemploie la méthode Agent A, sans modifier ses Grounds ni son
lock :

- PMDO 0.8.12 :
  `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327` ;
- SDL headless patché :
  `2cec7b5f9603a8a856a94b3a5e4fb5bd5e93e3ed0d04b85431625d5acb14e71f` ;
- patch SDL :
  `7fb310776961e5a6a30cb9bc4550a070d3eb284b3813ee03406e418e60119f6f` ;
- overlay ignoré, indexes locaux, offscreen SDL et SwiftShader/ANGLE.

Gates runtime :

- index PMDO sans signature d'erreur : PASS ;
- chargement du Ground : PASS ;
- déplacement libre attendu `(0,+8)` : PASS ;
- déplacement contre obstacle attendu `(0,0)` : PASS ;
- capture des ticks PMDO 0 et 15 : PASS ;
- différence environnement runtime/référence hors acteur : **0 pixel** aux
  deux ticks ;
- cycle visible : les deux hashes environnementaux sont différents ;
- événement terminal : PASS.

Le personnage natif de la fixture occupait exactement 200 pixels, tous dans le
rectangle d'exclusion documenté. Les captures brutes restent ignorées. Avant
export, ce rectangle est remplacé par la référence environnementale ; aucun
pixel d'acteur source ou New Era n'entre donc dans BIBLIOTHEQUE.

## Confidentialité

Le Ground et les preuves exportées ne contiennent :

- aucun sprite de personnage ou de Pokémon ;
- aucun casting source ni `MissingNo` ;
- aucun dialogue ;
- aucun corps de script source ;
- aucun nom ou binaire audio.

Les scripts présents dans les outils sont uniquement le harness de validation
PMDO généré, hors candidat et hors runtime final.

## Limites et adaptation restante

La validation PMDO ne constitue pas une promotion New Era. Restent à décider :

1. traduction des tags terrain 3/7 vers un comportement Ground approuvé ;
2. nom français EU définitif, musique, entrées, sorties et routage ;
3. point narratif d'intégration sans toucher aux chapitres 1–5 ;
4. pilotes dédiés aux masques directionnels partiels, entités/pages/routes,
   timelines, overlays, animations Map et VFX ;
5. inventaire exhaustif Nova, puis Reminiscencia, avant leur adaptation.

## Reproduction

```bash
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/build_common_map_ir.py \
  --game relict --map-id 12
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/convert_map_ir_to_pmdo.py \
  --ir external/BIBLIOTHEQUE_WORKSPACE/games/relict/conversion/ir/map_012.json
bash tools/restore_pmdred_eu_validation_runtime.sh  # uniquement si le runtime ignoré manque
python3 external/BIBLIOTHEQUE_WORKSPACE/tools/validate_pmdo_runtime.py
python3 external/BIBLIOTHEQUE_WORKSPACE/tests/test_pmdo_pilot.py
```

Rapports machine :

- `games/relict/conversion/pmdo_pilot/map_012/reports/conversion_report.json` ;
- `games/relict/conversion/pmdo_pilot/map_012/runtime/runtime_report.json`.
