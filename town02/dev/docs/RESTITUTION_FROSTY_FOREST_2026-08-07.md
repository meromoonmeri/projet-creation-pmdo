# Restitution canonique — Frosty Forest

## Paquet

- Zone : `frosty_forest`
- D10P01 : `foret_givree_oree`
- D10P02 : cinématique intermédiaire
- D10P03 : Cœur de Frosty Forest
- Arène : `frosty_forest_summit.rsmap`
- Boss : Articuno niveau 33

## Structure canonique

- Frosty Forest : 9 floors
- D10P02
- Frosty Grotto : 5 floors
- D10P03 puis combat Articuno dans le même lieu

## Géométrie propre

Forêt : grille 5×3, cellules 8×8, salles 4–8, branches modérées, reconnexion 45 %.  
Grotto : grille verticale 3×5, cellules 7×7, salles 3–6, branches 75–101 %, halls sinueux, reconnexion 20 %.

Aucun patron exact partagé. Similarité maximale : 33,3 % avec Mt. Blaze/Searing Tunnel, en raison de briques RogueElements communes mais de paramètres et topologies distincts.

## Compatibilité

D10P02 et D10P03 conservent leur flux FugitiveArc par défaut. `SV.CanonicalDungeons.Pending` sélectionne le flux canonique sans créer de copie de Ground.

## Validation

- 14 floors comptés ;
- SpawnRangeList valides ;
- index synchronisé ;
- D10P03 et arène 22×21 ;
- Articuno seul ;
- scène et combat dans le même décor.
