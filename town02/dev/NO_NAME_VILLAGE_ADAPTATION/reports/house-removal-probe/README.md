# Que trouve-t-on SOUS les structures de `rmvillage` ?

Sonde en lecture seule. Objectif unique : déterminer si un terrain NNV valide
existe **déjà** sous chacune des quatre maisons, ou si retirer la structure
révélerait des tuiles noires / vides.

Aucun fichier de `Data/` n'est écrit, aucune tuile n'est créée, aucune maison
n'est reconstruite, aucun terrain PMU n'est substitué. Les quatre saisons, le
1:1 4992×4992, les collisions, animations, particules et les PASS runtime
PMDO 0.8.12 restent intacts.

## Réponse

**Le terrain est déjà présent, complet, sous les quatre maisons.**

| Structure | Ancre source | Périmètre structurel | `NNV ground` | Terrain rendu | Pixels noirs | Résultat |
|---|---|---:|---:|---:|---:|---|
| `objplayerhouse` | (-64, 2816) | 1200×984 | 100 % | 100 % | 0 | `GROUND_ALREADY_PRESENT` |
| `objloggerhouse` | (704, 1344) | 948×840 | 100 % | 100 % | 0 | `GROUND_ALREADY_PRESENT` |
| `objhunterhouse` | (3712, 1472) | 948×856 | 100 % | 100 % | 0 | `GROUND_ALREADY_PRESENT` |
| `objcarpenterhouse` | (1216, -128) | 1192×728 | 100 % | 100 % | 0 | `GROUND_ALREADY_PRESENT` |

Mesuré sur les quatre saisons : `NNV ground` est rempli à **100 %** sous les
quatre emprises dans `spring`, `summer`, `autumn` et `winter`.

La mesure pixel confirme la mesure cellule : sur l'emprise exacte de chaque
structure, le rendu des seuls layers de terrain donne **100,000 % de couverture
opaque et 0 pixel noir**. Il n'y a donc ni trou, ni tuile manquante, ni
placeholder derrière les maisons.

## Preuve visuelle

`<structure>_1_intact.png` — la zone telle qu'elle est aujourd'hui.
`<structure>_2_structure_removed.png` — les mêmes layers, structure masquée.
`<structure>_3_terrain_only.png` — uniquement le lit de terrain.

Le rendu « structure retirée » montre un sol **fini** : herbe, chemin de terre,
transitions herbe/terre, rochers, souches, buissons et fleurs sont tous déjà
là. Rien n'a été ajouté ; ces pixels existaient sous la maison.

Détail notable et utile : la **porte reste visible** après suppression. Elle
n'appartient pas au sprite de la maison, c'est une entité `GroundObject`
distincte avec son propre collider. C'est elle qui constitue l'ancre d'entrée
qu'un remplacement devra respecter.

## Découpe des rôles (ce qui appartient à quoi)

- `BUILDING_ONLY` — layers `NNV HouseBelow` et `NNV sHouseBelow`. Ce sont les
  seuls layers masqués par la sonde.
- `NNV_TERRAIN` — `NNV ground`, `NNV groundtex`, `NNV grass0`, `NNV grass1`.
  Intégralement présent sous les structures ; reste NNV.
- `NNV_DECORATION` — `trees`, `plants`, `vegetation`, `cliff`, `Below`,
  `instances`. Non touché ; reste NNV.
- `NNV_COLLISION` — grille native 624×624 en cases de 8 px. Sous les emprises :
  58,3 % / 78,4 % / 75,4 % / 75,8 % de cases bloquées. Ces cases sont dérivées
  du masque solide **de la maison actuelle** : un remplacement devra les
  re-dériver depuis la nouvelle structure, jamais les réutiliser telles quelles.
- `NNV_ENTRY` — `Exit_Door_106508/106510/106509/106511`, colliders 64×64 aux
  positions (940, 3296), (1096, 1952), (3912, 2080), (2200, 608). Indépendants
  du sprite, ils survivent à la suppression.

## Conséquence

Le remplacement d'une structure NNV est **techniquement viable côté terrain** :
retirer la maison ne laisse aucun trou à combler, donc aucune raison — et
aucune permission — d'importer du sol, de l'herbe, des arbres ou des rochers
PMU. Le terrain NNV reste intégralement NNV.

Les deux contraintes qui subsistent pour un remplacement réel, et qui ne sont
pas traitées par cette sonde :

1. la collision doit être re-dérivée depuis la structure de remplacement ;
2. l'ancre d'entrée existante doit rester cohérente avec la nouvelle structure.

## Reproduire

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/probe_house_underlying_ground.py --season summer
```

## Statut

`READ_ONLY_PROBE_PASS`. Aucune promotion, aucune certification, aucune
modification de `rmvillage`.
