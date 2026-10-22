# Restitution canonique — Magma Cavern

## Paquet

- Zone : `magma_cavern`
- D12P01 : `gorge_ardente_porte`
- D12P02 : `gorge_ardente_coeur`
- D12P04 : `fosse_ardente`
- arène : `magma_cavern_pit.rsmap`
- boss : Groudon niveau 37

## Structure

- Magma Cavern : 23 floors
- scène D12P02
- Magma Cavern Pit : 3 floors
- scène D12P04 puis Groudon dans la même fosse

Boutiques limitées aux floors 2–6. Monster Houses limitées aux floors 8–20.

## Géométrie

Caverne : grille 5×5, cellules 8×8, salles 4–8, halls larges 2–4, reconnexion 20 %.  
Pit : grille 3×4, cellules 10×10, salles 6–11, fort branchement, halls 2–3, reconnexion 10 %.

Aucun patron exact partagé. Les primitives montagneuses restent communes mais les paramètres sont propres.

## Cinématique et VFX

D12P02/D12P04 conservent FugitiveArc hors du donjon canonique. Dans le flux Magma Cavern, D12P04 joue la scène puis `VFX_Groudon_Awakening_Flame` avant le combat. L’arène 21×21 est dérivée directement de D12P04.

## Validation

- 26 floors comptés ;
- index synchronisé ;
- SpawnRangeList valides ;
- Groudon seul ;
- même salle pour scène et combat.
