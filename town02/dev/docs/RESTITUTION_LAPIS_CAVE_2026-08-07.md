# Restitution canonique — Lapis Cave

## Paquet

- Zone : `lapis_cave`
- entrée : D08P01 `grotte_lazuli_seuil`
- sortie : D08P02 `grotte_lazuli_fond`
- 14 floors
- aucun boss, aucune arène artificielle

## Règles Rescue Team conservées

- aucune boutique Kecleon ;
- aucune Monster House ;
- obscurité sur les floors 1–4 et 9–14 ;
- visibilité normale sur les floors 5–8 ;
- scène D08P02 à la sortie.

## Géométrie

- grille 5×4 ;
- cellules 8×8 ;
- salles 4–8 ;
- BranchRatio 60–91 % ;
- halls 1–2 avec biais de virage 70 ;
- reconnexion 25 %.

Aucun patron exact partagé. La signature reste apparentée aux autres grottes/montagnes car elle utilise les mêmes primitives RogueElements, mais ses paramètres et son rythme sont distincts.

## Arc Fugitif

D08P02 conserve FugitiveArc par défaut. Le contexte `SV.CanonicalDungeons.Pending='lapis_cave_exit'` joue la scène canonique de sortie puis termine le donjon, sans dupliquer le Ground.

## Validation

- 14 floors comptés ;
- JSON valide ;
- index synchronisé ;
- SpawnRangeList valides ;
- aucune boutique/Monster House répartie ;
- aucun faux combat final.
