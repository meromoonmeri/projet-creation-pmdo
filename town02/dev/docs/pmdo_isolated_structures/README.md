# Structures PMDO isolées compatibles NNV

Autorité : `audinowho/DumpAsset` au commit `9d864d1425f002b051e7a54fffc639988d8ef9c9`.

## Règle

Seuls les objets autonomes de `Content/Object/` sont admis. Aucun morceau de
Ground, de Map ou de tileset n'est extrait. Les pixels, dimensions, palettes,
transparences et frames restent strictement identiques. Sur NNV, les structures
devront être des `GroundObject` séparés au-dessus des layers source.

## Structures qualifiées

| Asset | Dimensions | Frames | Usage possible |
|---|---:|---:|---|
| `House_Normal.dir` | 112×112 | 1 | Maison végétale |
| `Tent.dir` | 80×80 | 1 | Tente décorée |
| `Tent_Plain.dir` | 96×96 | 1 | Tente simple |

## Audit marchand / Kecleon

Aucun stand Kecleon autonome, comptoir complet ou étal marchand complet n'existe
sous `Content/Object/`. `Tile_Shop.dir` est un marqueur de sol 24×24 utilisé par
le système de boutique, pas une structure physique. Il est donc exclu.

Composants de marché réellement isolés et utilisables sans altération :

- `Berry_Basket_Blue`, `Berry_Basket_Red` ;
- `Mission_Board`, `Storage`, `Pot` ;
- `Stump_Table`, `Stump_Table_Indoors` ;
- `Stump_Chair`, `Stump_Chair_Indoors` ;
- `Sign`, `Sign_Crossroads`, `Fence`.

Ces composants ne constituent pas à eux seuls un stand. Il est interdit de
compléter l'étal en découpant `TownBase.tile` ou un Ground PMDO.

## Inventaire exhaustif

`inventory.json` classe les **92** fichiers `.dir` de `Content/Object/` :
structures, mobilier de marché, décor, conteneurs, navigation, objets spéciaux,
marqueurs de donjon et pièges. Aucun autre asset isolé n'est ignoré.

## Statut

`NOT_PLACED / NOT_RUN`. Cet inventaire n'autorise encore aucun placement : les
positions, emprises de collision et interactions doivent être validées sans
modifier un seul pixel de `rmvillage`.
