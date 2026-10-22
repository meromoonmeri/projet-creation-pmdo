# Donjons PMDO — Reminiscencia et Relict

## Résultat

Les Maps environnementales restent des Grounds, tandis que les zones de donjon
possèdent désormais de vrais candidats `ZoneData` PMDO/RogueElements.

| Jeu | Donjons | Étages | Entrées de roster |
|---|---:|---:|---:|
| Reminiscencia | 17 | 402 | 510 |
| Relict | 5 | 120 | 150 |
| Total | 22 | 522 | 660 |

Chaque donjon contient exactement **30 espèces distinctes**. Le lot emploie 246
espèces différentes au total.

## Structure PMDO native

Chaque candidat utilise :

- `RogueEssence.LevelGen.RangeDictSegment` ;
- plusieurs variantes `GridFloorGen` couvrant tous les étages sans trou ;
- `RogueElements.FloorStairsStep` avec `stairs_go_up` ou
  `stairs_go_down` sur chaque générateur d'étage ;
- plans en grille, salles connectées, branches, couloirs et
  `AddTunnelStep` ;
- Monster Houses via `SpreadHouseZoneStep` ;
- objets, argent et tuiles d'effet issus de modèles PMDO 0.8.12 existants ;
- équipes sauvages de 1 à 4 Pokémon ;
- plafond de 14 ennemis présents et respawn de 20 ticks.

Les structures ne sont pas des JSON inventés : chaque biome dérive d'un donjon
PMDO déjà fonctionnel (`gloomy_forest`, `crooked_cavern`, `frosty_forest`,
`cloven_ruins`, `illuminant_riverbed`, `searing_tunnel` ou `vast_steppe`). Seul
le premier segment procédural autonome est repris ; aucun Ground ou boss d'un
autre lieu n'est croisé avec le nouveau donjon.

## Donjons Reminiscencia

Forêt, grotte, forêt enneigée, prison, forêt Foliodoro, palais de justice,
temple de Varuna, lac, volcan, falaise, tour, mine, champs de blé, baie, brèche,
tour brûlée et Chutes Météore.

Chaque famille est reliée au manifeste MapTemplate précédent, mais la génération
d'étages est désormais effectuée par RogueElements : les escaliers et connexions
ne dépendent plus des téléportations RMXP entre salles 20×15.

## Donjons Relict

- Tour du Destin — 30 étages ;
- Terres Immaculées — 22 étages ;
- Mont Couronné — 26 étages ;
- Retraite Ancienne — 20 étages ;
- Côte Lazuli — 22 étages.

## Pokémon

Les identifiants d'espèce sont limités aux espèces déjà référencées par les zones
PMDO du projet. Chaque roster contient 30 espèces adaptées au biome, avec niveaux
progressifs, tactiques variées et poids communs/rares. Les compétences explicites
du modèle ont été vidées afin que PMDO attribue un moveset légal selon le niveau.

## Validation

- 22 JSON parsés et inspectés exhaustivement ;
- 522 étages couverts par des ranges continus ;
- présence d'un `FloorStairsStep` dans chaque variante de générateur ;
- tunnel et Monster House présents dans chaque donjon ;
- 30 espèces distinctes par zone ;
- équipes de 3 et 4 Pokémon confirmées ;
- `MaxFoes=14`, `RespawnTime=20` confirmés ;
- les 22 zones ont passé l'indexeur du runtime **PMDO 0.8.12 exact** ;
- aucune zone n'est absente de `index.idx` dans la fixture ;
- aucune destination `Data/Zone`, aucun Ground certifié et aucun chapitre
  historique n'a été modifié.

Les candidats restent sous
`games/<jeu>/conversion/pmdo_dungeons/` jusqu'à la décision de promotion et de
raccord narratif.
