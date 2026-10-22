# Relict — rapport Sprint 4 animations de Map

## Périmètre

Les timelines de Maps utilisent dix IDs `RPG::Animation` : 3, 4, 8, 9, 10,
11, 12, 17, 18 et 19. Ils totalisent 123 déclenchements directs ou scriptés.
L'audit visuel des feuilles confirme qu'il s'agit d'effets/emotes et non de
sprites de casting.

## Extraction

`Data/Animations.rxdata` est parsé sans exécuter Ruby. Pour chaque animation,
le pipeline conserve :

- ID source et contextes exacts d'utilisation ;
- position d'ancrage ;
- ordre des frames ;
- chaque cellule source : pattern, X/Y signé, zoom, angle, miroir, opacité et
  blend normal/additif/soustractif ;
- timings de flash et couleurs ;
- présence des cues audio sous forme de hash, sans exporter d'audio ;
- provenance et hash de la définition et de la feuille graphique.

Les dix feuilles utilisées n'emploient ni rotation ni miroir. Le renderer pur
Python compose les cellules 192×192 dans un canevas neutre 640×480 ancré en
320×240, tout en conservant les transformations exactes dans `metadata.json`.

## Résultat

- 10 animations documentées ;
- 231 frames PNG individuelles ;
- 10 contact sheets ;
- 0 transformation non supportée ;
- 0 pixel de casting ;
- 0 binaire audio exporté.

L'autorité `Sprite_AnimationSprite.rb` établit 20 frames par seconde en
l'absence de suffixe source, soit **50 ms par frame** pour les dix animations.
Le script n'est ni exécuté ni copié ; son hash et la constante font autorité.

Chaque animation est stockée sous :

```text
animations/map_effects/<animation_id>/
  metadata.json
  contact_sheet.png
  layers/layer_00/frame_000.png
  layers/layer_00/frame_001.png
  ...
```

Ces frames restent des preuves source. Aucune conversion PMDO n'est commencée.
