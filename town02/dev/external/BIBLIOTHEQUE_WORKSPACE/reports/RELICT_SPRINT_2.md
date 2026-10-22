# Relict — rapport Sprint 2 previews et autotiles

## Prévisualisations de Maps

Le renderer pur Python reconstruit les tiles RMXP sans appeler le moteur source :

- tilesets 32×32 à partir de l'ID 384 ;
- 48 combinaisons d'autotiles RMXP composées depuis quatre quarts 16×16 ;
- frame 0 utilisée comme autorité statique des previews ;
- alpha source conservé entre les trois couches.

Résultat :

- 28 previews canoniques ;
- 6 previews supplémentaires pour les variantes divergentes ;
- 10 planches de référence tileset/autotiles ;
- 214 PNG de preview ;
- aucun tile ID manquant.

Chaque Map possède :

```text
layer_00.png
layer_01.png
layer_02.png
composite.png
collision.png
entities_placeholders.png
```

Les collisions utilisent le passage et la priorité RGSS1 : vert pour les
cellules ouvertes dans les quatre directions, rouge pour les cellules bloquées,
orange pour les passages directionnels partiels. Les données brutes restent
conservées séparément.

Les placeholders sont superposés sans importer le casting source :

- magenta : acteur à remplacer par le casting New Era ;
- cyan : entité environnementale utilisant un tile ;
- jaune : marqueur logique sans graphique.

## Autotiles animés

Les 33 autotiles utilisés par les Maps et variantes ont été audités :

- 16 statiques ;
- 17 animés ;
- 88 frames source exportées individuellement ;
- 15 animations au format RMXP 96×128 multi-frame ;
- 2 animations custom mono-tile 32×32 (`ShiningStar1/2`) ;
- aucune disposition d'image non supportée.

Chaque animation possède :

```text
metadata.json
contact_sheet.png
layers/layer_00/frame_000.png
layers/layer_00/frame_001.png
...
```

L'ordre et la boucle sont préservés. Un audit statique ciblé de
`TilemapRenderer::AUTOTILE_FRAME_DURATION` établit une durée source exacte de
5/20 seconde, soit **250 ms par frame**, pour les 17 noms utilisés (aucun suffixe
de durée). Le script n'est ni exécuté ni copié ; seuls son hash et la constante
font autorité.

## Reproductibilité

`tools/build_relict_library.py` reconstruit l'inventaire, les frames et les
previews, puis régénère `manifests/generated_hashes.sha256` couvrant 529 sorties.

Aucune conversion PMDO n'est commencée. Les sorties restent des preuves source
et des données préparatoires.
