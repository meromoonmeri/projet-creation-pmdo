# Restitution canonique — Mt. Freeze

## Paquet

- Zone : `mt_freeze`
- D11P01 : `mont_gele_pied`
- D11P02 : transition vers Mt. Freeze Peak
- D11P03 : sommet et rencontre Ninetales

## Structure canonique

- Mt. Freeze : 15 floors
- D11P02
- Mt. Freeze Peak : 5 floors
- D11P03 : cinématique finale

Aucun combat artificiel n’est ajouté : la rencontre de Ninetales reste une scène, conformément à Rescue Team.

## Géométrie propre

Mt. Freeze : grille 4×5, cellules 9×9, salles 5–9, halls 1–3, reconnexion 35 %.  
Peak : grille verticale 2×6, cellules 7×7, salles 3–6, branchement 85–101 %, halls très sinueux, reconnexion 10 %.

Aucun patron exact partagé. Les briques de génération restent apparentées aux autres montagnes, mais les dimensions, densités et paramètres sont propres.

## Double contexte

D11P02 et D11P03 servent aussi à l’Arc Fugitif. Le dispatch `SV.CanonicalDungeons.Pending` sélectionne Mt. Freeze sans dupliquer les Grounds ni casser FugitiveArc.

## Validation

- 20 floors comptés ;
- index synchronisé ;
- SpawnRangeList valides ;
- JSON valide ;
- D11P03 reste la scène finale sans fausse arène.
