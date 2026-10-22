# Reminiscencia — 552 rendus PNG source normalisés

> Archive statique : la cible active est désormais `TexSize=2`, 16 px et
> 320×240, décrite dans `REMINISCENCIA_PMDO_CONVERSION.md`. Les mentions
> `TexSize=4` ci-dessous concernent uniquement l'ancienne passe source.

## Résultat

L'archive canonique V2.3 a été récupérée via l'archive GitHub incluant les
objets LFS, puis vérifiée avant extraction :

- SHA-256 : `cf74db06c2c06b36cdd88c3139ab8c123b932269c34e7b0f10349f05e475be08` ;
- taille : 341 630 283 octets ;
- aucun code source exécuté ;
- archive brute absente de Git New Era.

Les **552 Maps** ont chacune un PNG dans
`games/reminiscencia/conversion/pmdo_renders/maps/`.

## Assemblage

Chaque rendu utilise une grille PMDO cible de 32 px (`TexSize=4`) et assemble :

1. panorama RMXP quand il est défini et disponible ;
2. trois couches de tuiles dans l'ordre source ;
3. événements-tuiles environnementaux visibles ;
4. fond noir PMDO pour les cellules transparentes.

Les événements utilisant des sprites d'acteurs ne sont jamais rendus. Les noms,
dialogues, scripts et fichiers audio ne sont pas exportés.

## Couverture

| Gate | Résultat |
|---|---:|
| Maps inventoriées et rendues | 552 |
| Rendus environnementaux complets | 522 |
| Maps à adapter — dépendances absentes | 29 |
| Scènes casting/UI exclues | 1 |
| Pages de contact lisibles | 12 |
| Panoramas assemblés | 14 |
| Événements-tuiles assemblés | 8 |

Les Maps problématiques conservent un PNG, mais les tuiles que la source ne
permet pas de résoudre sont affichées en magenta. Elles ne sont donc pas
présentées comme `PMDO_VALIDATED`.

Les principaux groupes à revoir sont :

- Map 325 : ID d'autotile pointant vers un slot source vide ;
- Map 469 « Sootopolis » : tileset absent de l'archive ;
- Maps 515–538 et 548–551 : assets « Meteor Falls » absents ;
- Map 539 : deux autotiles « PlayaShallow » absents.

La Map 463 est une scène dont le casting/UI est directement dessiné dans le
tileset. Ses pixels source sont exclus et remplacés par un placeholder neutre.

## Consultation

- planche globale : `conversion/pmdo_renders/contact_sheet.png` ;
- pages 1–12 : `conversion/pmdo_renders/contact_pages/` ;
- fichiers individuels : `conversion/pmdo_renders/maps/map_NNN.png` ;
- preuve machine : `conversion/pmdo_renders/manifest.json`.

Reminiscencia demeure prioritaire : collisions, placements, animations et VFX
doivent maintenant être qualifiés avant la conversion Ground en série. Nova ne
commence qu'ensuite.
