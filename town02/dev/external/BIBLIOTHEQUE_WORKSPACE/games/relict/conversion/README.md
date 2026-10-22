# Conversion BIBLIOTHEQUE → PMDO

Cette arborescence est une zone de préparation **hors runtime New Era**. Aucun
fichier n'est copié vers `Data/Ground/` ou `Content/Tile/` à la racine du mod.

## Chaîne reproductible

1. `tools/build_common_map_ir.py` transforme les preuves source qualifiées en
   IR commun (`schemas/map_ir.schema.json`).
2. L'importeur source normalise chaque tuile utilisée en frames RGBA 32×32
   hashées. Le convertisseur cible n'a donc pas besoin de connaître RMXP,
   Nova, Relict ou Reminiscencia.
3. `tools/convert_map_ir_to_pmdo.py` produit un `.rsground`, un atlas `.tile`,
   des rendus de contrôle et un rapport statique.
4. `tools/build_pmdo_runtime_fixture.py` étend uniquement l'overlay ignoré de
   la méthode Agent A : mêmes indexes locaux, spawn déterministe, SDL patché et
   SwiftShader/ANGLE.
5. `tools/validate_pmdo_runtime.py` charge le candidat dans PMDO 0.8.12, teste
   un déplacement libre et un déplacement bloqué, puis compare les rendus
   environnementaux aux ticks PMDO 0 et 15.
6. `tests/test_pmdo_pilot.py` verrouille IR, hashes, géométrie, collisions,
   timing, confidentialité, reproductibilité et preuve runtime.

## Statuts

Le statut de la Map source reste `SOURCE_DOCUMENTED`. Le candidat pilote peut
atteindre `PMDO_CONVERTED`, puis `PMDO_VALIDATED`, sans devenir un Ground New
Era intégré. Les besoins narratifs, terrain, casting et routage restent
`ADAPTATION_REQUIRED` jusqu'à une promotion contractuelle séparée.

## Pilote actuel

`map_012` (« Playa ») a été retenue parce qu'elle exerce la géométrie 3 couches,
les collisions binaires et deux autotiles d'eau animés, sans événement, acteur,
panorama, brouillard ni commande visuelle. Ses livrables sont sous :

- `ir/map_012.json` et `ir/assets/map_012/` ;
- `pmdo_pilot/map_012/Data/Ground/` ;
- `pmdo_pilot/map_012/Content/Tile/` ;
- `pmdo_pilot/map_012/reports/` ;
- `pmdo_pilot/map_012/runtime/` ;
- `pmdo_renders/maps/` pour les 34 PNG finaux ;
- `pmdo_renders/contact_sheet.png` pour la planche globale annotée.

Le pilote historique reste inchangé. Le lot exhaustif canonique est désormais
sous `pmdo_candidates/` : 28 Grounds à 16 px/`TexSize=2`, 8 atlas, 28 previews,
28 sidecars et deux preuves runtime exactes (Maps 012 et 002). Les Maps 002,
007 et 014 restent `ADAPTATION_REQUIRED` pour leurs passages directionnels
partiels conservés en sidecar. Voir `reports/RELICT_PMDO_CONVERSION.md`.

Cinq vrais donjons RogueElements sont générés sous `pmdo_dungeons/` : Tour du
Destin, Terres Immaculées, Mont Couronné, Retraite Ancienne et Côte Lazuli.
Ils totalisent 120 étages et 30 espèces distinctes par zone.
