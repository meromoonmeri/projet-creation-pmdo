# Restitution de Sinister Woods — chapitre 6

## Identité

- ID technique conservé : `gloomy_forest` (compatibilité sauvegardes) ;
- nom public : **Sinister Woods** ;
- contexte : même lieu que Rescue Team, trente ans plus tard ;
- intrigue : sauvetage de Chenipent et rivalité avec Team Dazzling.

## Grounds canoniques

### D04P01 — entrée

`gloomy_forest_entrance.rsground` utilise désormais la géométrie 57×48, la collision et les positions du Ground canonique `SINISTER_WOODS_ENTRY`.

La scène source D04P01 est sobre : musique, deux messages et poses. L’adaptation conserve ce rythme avec le héros et son partenaire aux positions du port : `(208,192)` et `(240,192)`.

### D04P02 — clairière finale

Nouveau Ground actif : `sinister_woods_clearing.rsground`, géométrie 69×72 de `SINISTER_WOODS_END`.

Les slots originaux de Team Meanies sont recastés sans déplacement arbitraire :

| Slot source | Position | Casting New Era |
|---|---:|---|
| meneur central | `(272,192)` | Adagio |
| membre droite | `(312,224)` | Aria |
| membre gauche | `(240,224)` | Sonata |
| héros | `(256,256)` | héros New Era |
| partenaire | `(296,256)` | partenaire New Era |

La scène conserve les neuf boîtes principales de D04P02 et ses poses finales, avec les dialogues `GF6E_*` de l’arc New Era.

## Flux

- D04P01 joue l’approche au début du chapitre ;
- les segments procéduraux et le sauvetage existants restent compatibles ;
- après le segment 3, le joueur rejoint D04P02 ;
- la confrontation Team Dazzling est jouée dans la clairière canonique ;
- la scène lance ensuite l’arène intégrée du segment 4.

## Nettoyage des doublons

Les alias physiques `bois_sombres_oree` et `bois_sombres_fond` ont été supprimés. Leurs deux géométries survivent sous leurs identifiants fonctionnels uniques :

- `gloomy_forest_entrance` ;
- `sinister_woods_clearing`.

## Sauvegardes

Nouveau drapeau : `SV.Chapter6.SinisterApproachSeen`. `FinishedGloomyForestIntro` reste le verrou de la scène Team Dazzling pour ne pas casser les anciennes sauvegardes. `OnUpgrade` initialise le nouveau champ depuis l’ancien état.
