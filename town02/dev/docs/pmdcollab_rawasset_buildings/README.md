# PMDCollab RawAsset — inventaire des bâtiments autonomes

## Source

- dépôt : `https://github.com/PMDCollab/RawAsset`
- commit épinglé : `03c80dad937911572f8fb19903771a47956fc696`
- fichiers inspectés : les 89 PNG de `Object/` et les 23 feuilles de `Tile/`
- licence racine : `MISSING` (aucun fichier de licence racine détecté au commit épinglé)
- attribution : `UPSTREAM_ATTRIBUTION_REVIEW_REQUIRED_BEFORE_PROMOTION`

## Bâtiments autonomes complets

Trois bâtiments seulement passent les règles d’autonomie et d’absence de découpe de map :

| Asset RawAsset | Dimensions | Statut |
|---|---:|---|
| `Object/House_Normal.None.png` | 112×112 | `QUALIFIED_SOURCE_BUILDING` |
| `Object/Tent.Flip.png` | 80×80 | `QUALIFIED_SOURCE_BUILDING` |
| `Object/Tent_Plain.Flip.png` | 96×96 | `QUALIFIED_SOURCE_BUILDING` |

Les trois fichiers sont copiés intégralement et octet pour octet dans `qualified/`. Aucun recadrage, redimensionnement, changement de palette ou aplatissement de map n’est appliqué.

La comparaison visuelle avec l’inventaire PMDO/DumpAsset précédent confirme les mêmes trois structures. `House_Normal` et `Tent` sont identiques pixel par pixel. `Tent_Plain` est visuellement identique ; seule la couleur RGB de pixels entièrement transparents diffère entre les encodages PNG.

## Faux positifs explicitement exclus

- `Object/Block_Guild.None.png` : marqueur logique 24×24, pas un bâtiment de guilde.
- `Object/Storage.Flip.png` : conteneur 32×32, pas une maison.
- `Object/Tile_Shop.None.png` : marqueur de sol 24×24, pas un stand marchand physique.

Aucun stand Kecleon autonome complet n’est présent dans `Object/`.

## Feuilles interdites pour NNV

Les 23 images sous `Tile/` (`TownBase`, `PostOffice`, `GuildPath`, `InsideHut`, camps, etc.) sont des cartes ou feuilles de tileset. Elles sont inventoriées dans `manifest.json`, mais toutes portent :

- `EXCLUDED_MAP_OR_TILESET_SHEET` ;
- `placement_allowed = false`.

Elles ne doivent pas être découpées pour fabriquer artificiellement une structure NNV.

## SkyTemple et ROM NDS

La ROM patchée `WavetoNostalgia.NDS` est bien référencée dans `meromoonmeri/PMD-RED-PMDO-PORT`, mais seulement sous forme de pointeur Git LFS dans ce runtime. Le téléchargement du payload LFS reste bloqué par une coupure TLS vers `github-cloud.githubusercontent.com`. Aucune extraction SkyTemple de cette ROM ne peut donc être déclarée `RUN` ou `PASS` dans cet état.

Statuts exacts :

- RawAsset : `STRUCTURALLY_INVENTORIED` ;
- 3 bâtiments RawAsset : `QUALIFIED_SOURCE_BUILDING` ;
- extraction SkyTemple de Waves of Nostalgia : `BLOCKED_LFS_TLS / NOT_RUN` ;
- conversion en objets PMDO : `NOT_RUN` ;
- validation PMDO 0.8.12 : `NOT_RUN` ;
- placement NNV : `NOT_PLACED`.
