# Relict — rapport Sprint 0–1

## Résultat

Le pipeline source v1 est opérationnel sur le commit BIBLIOTHEQUE
`6963878956ec4c53833c03f26aa6a9aafd17800f` sans exécuter le fangame, Ruby,
`Scripts.rxdata` ou `Game.exe`.

Inventaire obtenu :

- 28 Maps canoniques ;
- 8 variantes conflictuelles, dont 2 byte-identiques et 6 divergentes ;
- 10 tilesets utilisés ;
- 43 assets environnementaux résolus, variantes incluses ;
- aucune dépendance visuelle manquante ;
- 100 événements source ;
- 115 placements par page ;
- 68 placements de casting convertis en placeholders ;
- 5 entités graphiques basées sur un tile ;
- 42 marqueurs logiques sans graphique.

## Géométrie et collisions

Pour chaque Map canonique et chaque variante divergente, le pipeline conserve :

1. les trois couches RMXP, valeur de tile par valeur de tile ;
2. les dimensions en tiles et en pixels de 32 px ;
3. les tables complètes `passages`, `priorities` et `terrain_tags` du tileset ;
4. une grille directionnelle dérivée (`down`, `left`, `right`, `up`) selon
   l'algorithme standard RGSS1 top-down fondé sur priorités et passages ;
5. le tile effectif et le terrain tag effectif par cellule ;
6. le hash de chaque sortie et de chaque fichier source impliqué.

Les éventuels overrides contenus dans les scripts propriétaires ne sont jamais
exécutés. La donnée brute reste donc l'autorité et la grille dérivée indique
explicitement cette limite.

## Entités remplaçables par New Era

Chaque événement et chacune de ses pages conservent :

- coordonnées X/Y ;
- direction, pattern, opacité et blend ;
- vitesse, fréquence et type de mouvement ;
- route de mouvement avec paramètres scalaires sûrs ;
- trigger et flags de conditions ;
- `through`, `always_on_top` et comportement collisionnel dynamique ;
- compte des commandes visuelles de scène.

Les noms d'événements, noms de fichiers de personnages, dialogues et corps de
scripts ne sont pas exportés. Les identités graphiques deviennent des hashes et
les acteurs sont identifiés par des IDs stables tels que
`map_016_entity_0002_page_00`. Ces emplacements pourront recevoir le casting
New Era sans importer celui du fangame.

## Garanties de non-mélange

- aucun fichier brut du fangame n'est dupliqué dans l'overlay ;
- aucun sprite humain, trainer ou Pokémon n'est exporté ;
- aucun dialogue, script, moteur, exécutable ou audio n'est exporté ;
- aucun fichier `Data/`, `Content/`, Ground ou chapitre de New Era n'est touché ;
- aucune conversion PMDO n'est commencée.

## Validation

`tests/test_relict_inventory.py` contrôle la provenance, les 28 Maps, les huit
variantes, les collisions, les coordonnées et routes des entités, la redaction,
les hashes, les contrats fermés et la reproduction byte-exacte de l'inventaire.

Résultat : **7 tests PASS**.

## Suite

Le lot suivant doit produire les previews multi-couches, masques de collision
et placeholders, puis auditer les autotiles et animations environnementales
frame par frame. Il ne doit toujours pas convertir les Maps vers PMDO avant
qualification visuelle complète.
