# Vallons Fleuris — FVF1 + EVF1

Recomposition reproductible des compositions complètes restaurées. Le build ne régénère ni ne remplace les deux décors : il repart des bruts exacts et de leur calque de sol séparé.

## Génération

```bash
.venv/bin/python source/vallons_fleuris_v1/build.py
.venv/bin/python source/vallons_fleuris_v1/test_build.py
```

Le script normalise uniformément les bruts `1200×896` vers `768×576` (`96×72` cases de `8 px`), détecte le masque magenta, puis exporte les calques, les quatre phases d’eau, les scintillements, les scènes complètes PNG/WebP, les ORA multicalques, les manifestes et `apercu_vallons_fleuris_v1.html`. Les répertoires source des autres lots — dont ETT2 — ne sont pas modifiés.

## Eau — calque cartographique natif Metano Town River

- Source : Palikadude/Halcyon, carte `Data/Ground/metano_town.rsground`, commit `da6c2130d641507447e6386a5e47a296e8cb4c71`. Les quatre planches `Metano_Town_River_Animation_1.tile` à `_4.tile` sont référencées par `source/eau_metano/animations_carte.json` ; cadence native : quatre phases de `10 ticks`.
- Les `3200` entrées `River` ont été revérifiées une par une : `example_map_cell == TexLoc` pour les quatre phases et les `3200` coordonnées sont uniques. Le build reconstruit donc quatre calques complets `142×189` cases (`1136×1512 px`) en plaçant chaque cellule native `8×8` à ses coordonnées de carte d’origine. Les PNG de ces calques sont exportés sous `renders/metano_town_native_river/` et référencés dans chaque manifeste.
- Les statistiques de la source restent documentées : `2365` cellules opaques de surface, `477` cellules opaques animées (`361` séquences distinctes), `750` cellules alpha-partielles de rive (`656` animées ; `566` séquences distinctes ; `278` empreintes alpha).
- FVF1/EVF1 sont des biomes générés : dans leurs masques, le build associe une composante entière de la rivière native à chaque bassin, selon la silhouette et l’échelle. Les composantes restent des régions contiguës de la carte Metano, transformées en bloc uniquement par rotation éventuelle et redimensionnement `NEAREST`, puis clippées au masque magenta. Dans les transparences de la fenêtre source, le RGB est prélevé sur le pixel River natif non transparent le plus proche de la même composante — sans couleur de remplacement. Les sources, coordonnées, rotations, facteurs d’échelle et scores de silhouette sont consignés dans le manifeste.
- Cette méthode remplace le patch natif `64×64 px` répété et le placement indépendant de cellules de berge. Les calques source complets conservent exactement leur disposition PMDO ; leur adaptation aux formes des deux cartes ne prétend pas être le placement canonique complet de la carte Metano Town.
- Les scintillements restent les modules natifs distincts de `Metano_Town_River_Sparkles.tile`. Aucun aplat de substitution ni écume synthétique n’est ajouté.

## Fleurs — animation officielle bloquée en attente des sources

Les frames officielles Sky Peak attendues ne sont pas présentes dans ce checkout. La référence documentée est `2cwdrrs469f61.gif` (`504×504`, quatre frames de `200 ms`), avec les quatre images extraites attendues sous `source/sky_peak_v1/gif_0.png` à `gif_3.png`. Aucune ressource vérifiable n’a été fournie ici.

En conséquence, le build **n’invente pas** de sprite, palette ou poses de substitution : les fleurs déjà peintes dans les décors générés restent intégralement statiques. Pour débloquer l’animation officielle, fournir `2cwdrrs469f61.gif` ou ses quatre frames Sky Peak originales.

## Statut et exports

- Les pixels du décor restent attribués à l’art généré restauré ; ils ne sont jamais présentés comme des tuiles natives.
- `art_approved`, `runtime_tested` et `canonical_flower_frames_verified` restent à `false`.
- Les collisions du viewer sont indicatives ; ce n’est ni un build Ground ni une validation runtime.
- Les livrables FVF1/EVF1 se trouvent sous `renders/fin_vallon_fleuri_sanctuaire_v1/` et `renders/entree_vallon_fleuri_sud_nord_v1/`. Les manifestes détaillent empreintes, sources, cadence, cellules natives réassemblées, calques et limites.
