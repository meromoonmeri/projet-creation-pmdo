# Bibliothèque de structures PMD isolées

Cette bibliothèque applique la règle suivante : **aucun fichier livré n’est un crop rectangulaire contaminé d’une map**.

## Premier lot validé

| ID | Source | Dimensions | Méthode |
|---|---|---:|---|
| `merchant_stand_01` | PMD Red, Pokémon Square (`T01P01`) | 72×60 | reconstruction BMA/BPC/BPL + masque de contour fermé |
| `merchant_counter_01` | PMD Red, Pokémon Square (`T01P01`) | 56×20 | reconstruction BMA/BPC/BPL + masque de contour fermé |
| `house_01` | PMDCollab RawAsset | 112×112 | PNG source autonome complet |
| `tent_01` | PMDCollab RawAsset | 80×80 | PNG source autonome complet |
| `tent_02` | PMDCollab RawAsset | 96×96 | PNG source autonome complet |

Les fichiers finaux sont dans `buildings/`. `library.png` est uniquement une planche de visualisation ; les PNG individuels restent à leur résolution native.

## Reconstruction des deux stands

Sources épinglées :

- `pret/pmd-red` au commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d` ;
- `skytemple-files 1.8.5` pour décoder la géométrie et la couche BMA ;
- ressources originales `T01P01.bpl`, `T01P01c.bpc`, `T01P01m.bma`.

Procédure :

1. la couche BMA est décodée avec SkyTemple ;
2. les chunks et tiles BPC PMD Red sont reconstruits à leur position source ;
3. chaque pixel est relié à sa coordonnée de tuile, son chunk, son index BPC, sa palette et ses flips ;
4. un masque alpha est construit à partir de la composante fermée de la structure ;
5. le masque doit être strictement identique pour cinq seuils indépendants : `90, 110, 125, 140, 160` ;
6. les pixels extérieurs accessibles depuis le bord sont supprimés, donc le sol environnant n’est pas conservé ;
7. le résultat est resserré uniquement après application du masque alpha ;
8. chaque pixel opaque est comparé au rendu source.

`merchant_counter_01` apparaît deux fois dans la map. Les deux occurrences ont été comparées au PNG exporté et donnent chacune **0 pixel différent**.

## Validation

Pour les deux structures reconstruites :

- fond transparent : oui ;
- terrain extérieur : absent ;
- NPC : absent — BMA/BPC/BPL `MAP_BG` ne contient aucune couche acteur ;
- palette : inchangée ;
- interpolation : aucune ;
- redimensionnement : aucun ;
- références vers des tiles animées manquantes dans les structures sélectionnées : aucune ;
- correspondance source : 0 pixel différent ;
- provenance exacte des tiles : enregistrée dans `manifest.json`.

Le rendu source global contient quelques références animées BPA que le rendu statique n’emploie pas, mais aucune ne touche les deux structures exportées. Elles ne sont donc ni inventées ni remplacées.

## Limites et statut

Ce lot reste volontairement petit. Les bâtiments dont les contours traversent des tiles composites ambiguës ne sont pas exportés.

- extraction source : `PIXEL_EXACT_SOURCE_STRUCTURE` ;
- conversion PMDO `GroundObject` : `NOT_RUN` ;
- validation PMDO 0.8.12 : `NOT_RUN` ;
- placement NNV : `NOT_PLACED`.

Reproduction :

```bash
PYTHONPATH=/path/to/skytemple-files-and-pillow \
python3 tools/extract_pmd_shop_structures.py \
  --pret /path/to/pret-pmd-red \
  --rawasset /path/to/PMDCollab-RawAsset \
  --out docs/pmd_structure_library
```
