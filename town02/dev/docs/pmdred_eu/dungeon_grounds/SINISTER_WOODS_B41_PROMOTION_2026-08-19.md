# Sinister Woods b41 — promotion contrôlée

**Verdict : `SINISTER_WOODS_B41_PROMOTION_PASS_UNIQUE_NAMESPACE`**

Preuve machine :
`SINISTER_WOODS_B41_PROMOTION_2026-08-19.json`.

## Décision de namespace

La comparaison initiale identifiait `TreeshroudForest1.tile` et les trois
AutoTiles `treeshroud_forest_1_*` comme matériau à remplacer, mais l'audit des
consommateurs a établi que ces noms sont partagés :

- `relic_forest` les utilise sur cinq étages ;
- les six `relic_forest_blob_*.rsmap` les utilisent transitivement ;
- `gloomy_forest_miniboss`, `verdant_oath_arena` et des Grounds les utilisent
  encore.

Remplacer ces noms globalement aurait changé Relic Forest et plusieurs cartes
New Era. Cela aurait violé la séparation demandée. La route sûre et prouvée
est donc de déplacer **uniquement l'usage procédural Sinister Woods** vers son
namespace PMD Red :

- `Content/Tile/SinisterWoodsB41.tile` ;
- `Data/AutoTile/sinister_woods_b41_floor.json` ;
- `Data/AutoTile/sinister_woods_b41_wall.json` ;
- `Data/AutoTile/sinister_woods_b41_secondary.json`.

Les anciens noms Treeshroud et tous les six blobs Relic Forest sont conservés
intacts. `Data/Zone/gloomy_forest.json` ne contient plus aucune référence
`treeshroud_forest_1_*` dans ses trois `MapTextureStep` procéduraux ; il possède
neuf références b41 uniques. D04P01/D04P02 n'ont pas été modifiés.

## Provenance et validation

Les quatre assets promus sont dérivés de `b41fon`, `b41cel`, `b41cex`, `b41pal`
et `b41canm` de la ROM PMD Red EU authentifiée, dungeon ID 3, tileset 41.
La ligne finale D04P02 reste la voie `b65*` déjà validée.

Validation indépendante :

- 47 codes AutoTile PMDO × 3 variantes CEX pour chaque famille ;
- 2 001 contrôles de couches ;
- 32 016 contrôles pixels ;
- 16 records CANM et durées indépendantes 12/8 conservés ;
- adaptateur one-shot runtime testé : 405 couches à durée 8 puis 1 596 à
  durée 12, à chaque entrée d'étage ;
- `Content/Tile/index.idx` : 953/953 feuilles cohérentes ;
- index de zone : `gloomy_forest` cohérent ;
- gate statique Sinister Woods : tables Pokémon exactes, musique, progression,
  absence de Relic Forest et namespace b41 complet.

## Runtime post-promotion

La fixture de post-promotion charge les fichiers de production, indexe PMDO
0.8.12 et parcourt les segments 0, 1 et 3 :

| Segment | Dimensions | Collision libre/bloquée | Musique | Ombre |
|---:|---:|---|---|---|
| 0 | `38×51` | oui / oui | `Sinister Woods.ogg` | — |
| 1 | `51×38` | oui / oui | `Sinister Woods.ogg` | — |
| 3 | `38×64` | oui / oui | `Sinister Woods.ogg` | `deep_shadow` + `dusk` |

Terminaison : `NORMAL_EXIT`, code `0`, terminal observé, sortie gracieuse,
aucun watchdog, aucun processus résiduel et aucun diagnostic interdit.

La régression Relic Forest post-route résout toujours les six maps, génère son
étage et termine normalement. Aucun `relic_forest_blob_*`, `Data/Zone/relic_forest`
ou Ground D04P01/D04P02 n'est touché.

## Limite honnête

Cette promotion certifie le **matériau et le runtime graphique de la zone
Sinister Woods** dans cette route PMDO. Elle ne certifie pas encore le
portage narratif complet des 133 scènes, les 27 chaînes cinématiques ni le
parcours PMD Red de bout en bout. Le registre global reste donc `BLOCKED` sur
ces composants, conformément à la règle de ne pas confondre une zone jouable
avec le jeu entier terminé.
