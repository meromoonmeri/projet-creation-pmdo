# Restitution canonique — Mt. Blaze

## Paquet

- Zone : `mt_blaze`
- Nom public : Mt. Blaze — trente ans plus tard
- Entrée : D09P01 `mont_cendre_pied`
- Cinématique intermédiaire : D09P02 `d09p02`
- Sommet/cinématique : D09P03 `d09p03`
- Arène : `mt_blaze_summit.rsmap`, dérivée directement de D09P03
- Boss canonique : Moltres

## Structure

1. Mt. Blaze 1F–12F : 12 floors procéduraux ;
2. D09P02 : cinématique canonique recastée ;
3. Mt. Blaze Peak 1F–3F : trois floors plus verticaux et ramifiés ;
4. D09P03 : scène du sommet puis combat Moltres dans la même salle.

## Géométrie propre

Première section : grille 4×4, cellules 9×9, salles 5–9, halls 1–3, reconnexion 30 %.  
Peak : grille 3×5, cellules 8×8, salles 4–7, branches fortes, halls 1–2, reconnexion 15 %.

Similarité maximale mesurée : 33,3 % avec Searing Tunnel ; aucun patron exact partagé.

## Compatibilité Arc Fugitif

Les Grounds D09P02/D09P03 gardent leur comportement `FugitiveArc` par défaut. Un état `SV.CanonicalDungeons.Pending` sélectionne le flux Mt. Blaze uniquement lorsque le joueur vient de la zone canonique. Il n’existe donc aucune copie physique des Grounds.

## Validation

- JSON valide ;
- index Zone synchronisé : 12 + 3 floors, boss hors comptage ;
- SpawnRangeList : valides ;
- arène D09P03 : 23×23, même décor que la cinématique ;
- boss : Moltres seul ;
- géométrie : aucun clone exact.
