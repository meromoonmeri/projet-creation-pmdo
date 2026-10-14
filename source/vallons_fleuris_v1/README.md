# Vallons Fleuris — FVF1 + EVF1

Recomposition reproductible des compositions complètes restaurées. Le build ne régénère ni ne remplace les deux décors : il repart des bruts exacts et de leur calque de sol séparé.

## Génération

```bash
.venv/bin/python source/vallons_fleuris_v1/build.py
.venv/bin/python source/vallons_fleuris_v1/test_build.py
```

Le script normalise uniformément les bruts `1200×896` vers `768×576` (`96×72` cases de `8 px`), détecte le masque magenta, puis exporte les calques, les quatre phases d’eau, les scintillements, les scènes complètes PNG/WebP, les ORA multicalques, les manifestes et `apercu_vallons_fleuris_v1.html`. Les répertoires source des autres lots — dont ETT2 — ne sont pas modifiés.

## Eau — pixels d’animation natifs Metano Town River

- Source : `source/eau_metano/natifs/Metano_Town_River_Animation_1.tile` à `_4.tile`, vérifiée par `source/eau_metano/animations_carte.json` (carte source Halcyon, commit `da6c2130d641507447e6386a5e47a296e8cb4c71`). La cadence native est de quatre phases, `10 ticks` par phase.
- Sur les `3200` cellules River référencées, le build retient les cellules d’eau opaques dont les pixels restent cyan/bleus dans les quatre frames. Les séquences réellement animées fournissent `477` cellules source (`361` séquences distinctes).
- Comme la géométrie des rivières FVF1/EVF1 est celle des décors générés, ces cellules `8×8` sont réaffectées à la grille du masque magenta. Leurs pixels ne sont ni recolorés ni redimensionnés ; le masque ne les coupe qu’à la rive. **Il s’agit d’une adaptation à ces biomes, pas de la disposition canonique de la carte Metano Town.** La provenance et les `TexLoc` employés sont consignés dans chaque `manifest.json`.
- Les scintillements continuent d’utiliser séparément les modules natifs `Metano_Town_River_Sparkles.tile`. Aucun aplat turquoise de remplacement ni écume synthétique n’est créé.

## Fleurs — animation officielle bloquée en attente des sources

Les frames officielles Sky Peak attendues ne sont pas présentes dans ce checkout. La référence documentée est `2cwdrrs469f61.gif` (`504×504`, quatre frames de `200 ms`), avec les quatre images extraites attendues sous `source/sky_peak_v1/gif_0.png` à `gif_3.png`. Aucune ressource vérifiable n’a été fournie ici.

En conséquence, le build **n’invente pas** de sprite, palette ou poses de substitution : les fleurs déjà peintes dans les décors générés restent intégralement statiques. Pour débloquer l’animation officielle, fournir `2cwdrrs469f61.gif` ou ses quatre frames Sky Peak originales.

## Statut et exports

- Les pixels du décor restent attribués à l’art généré restauré ; ils ne sont jamais présentés comme des tuiles natives.
- `art_approved`, `runtime_tested` et `canonical_flower_frames_verified` restent à `false`.
- Les collisions du viewer sont indicatives ; ce n’est ni un build Ground ni une validation runtime.
- Les livrables FVF1/EVF1 se trouvent sous `renders/fin_vallon_fleuri_sanctuaire_v1/` et `renders/entree_vallon_fleuri_sud_nord_v1/`. Les manifestes détaillent empreintes, sources, cadence, cellules natives réassemblées, calques et limites.
