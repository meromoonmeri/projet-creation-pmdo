# Registre de restitution des paquets PMD Red actifs

Un Ground enregistré dans `master_zone` n’est pas considéré terminé par sa seule présence. Il doit appartenir au JSON du donjon canonique correspondant et disposer de ses scènes, sa fin et ses combats dans les mêmes salles.

| Famille | Lieu canonique | Grounds actifs | Zone canonique complète | État |
|---|---|---|---|---|
| D04 | Sinister Woods | entrée D04P01 + clairière D04P02 | `gloomy_forest` (ID sauvegarde), nom public Sinister Woods | **restitué/recasté** |
| D08 | Lapis Cave | seuil D08P01 + fond D08P02 | absente | à produire |
| D09 | Mt. Blaze | pied D09P01 + milieu D09P02 + fin D09P03 | absente | à produire |
| D10 | Frosty Forest | orée D10P01 + milieu D10P02 + fin D10P03 | absente | à produire |
| D11 | Mt. Freeze | pied D11P01 + milieu D11P02 + fin D11P03 | absente | à produire |
| D12 | Magma Cavern | porte D12P01 + cœur D12P02 + fosse D12P04 | absente | à produire |
| D13 | Sky Tower | entrée D13P01 + palier D13P02 + sommet D13P03 | `sky_tower` | **restitué, sommet/cinématique conformes** |
| D23 | Wish Cave | fin D23P01 | `wish_cave` absente | à produire; Ground réservé Jirachi |

Les copies `arc_*` de D13 et les identifiants bruts D09/D10/D11 sont encore utilisés par l’Arc Fugitif. Elles sont des variantes scénaristiques actives, mais devront être remplacées par un dispatch de scène sur le paquet canonique afin d’éliminer les duplications physiques sans casser Ch11.

## Ordre de production imposé

1. Mt. Blaze D09 ;
2. Frosty Forest D10 ;
3. Mt. Freeze D11 ;
4. Lapis Cave D08 ;
5. Magma Cavern D12 ;
6. Wish Cave D23 ;
7. consolidation des variantes de l’Arc Fugitif.

Chaque lot doit livrer ensemble : JSON de zone, Ground d’entrée, Ground intermédiaire, Ground final, scènes recastées, `.rsmap` de combat dérivée du Ground final, index et tests statiques.
