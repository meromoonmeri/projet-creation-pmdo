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
- Les `3200` cellules River sont vérifiées sur les quatre planches. Parmi elles, `2365` cellules de surface sont opaques et cyan/bleues ; `477` ont une variation native (dont `361` séquences distinctes). Les `750` cellules alpha-partielles de rive fournissent `566` séquences distinctes (`656` cellules animées ; `278` empreintes alpha).
- La surface emploie un extrait **contigu et natif** aux `TexLoc` `[128,4]`–`[135,11]` : `8×8` cellules, soit `64×64 px`, choisi pour sa faible couture de répétition. Il est répété à l’échelle `1:1` dans l’eau générée ; aucun pixel n’est recoloré, tourné, inversé ou agrandi.
- Pour les cellules de contour, chaque case `8×8` du masque est comparée aux quatre empreintes alpha de chaque module de rive natif. Le module qui épouse le mieux la silhouette locale est posé sur la surface native ; en cas d’égalité, le choix suit le voisinage des `TexLoc` et privilégie les variantes animées, pas un mélange aléatoire. L’alpha final reste exactement celui du masque généré. Cette composition conserve les bordures et leurs phases animées, au lieu de réaffecter au hasard des cellules de rivière.
- La rivière prend sa forme dans les bruts générés FVF1/EVF1. **Cette adaptation cohérente de la surface et des berges n’est pas l’agencement canonique de la carte Metano Town.** La provenance et chaque `TexLoc` de rive sont consignées dans le manifeste.
- Les scintillements continuent d’utiliser séparément les modules natifs `Metano_Town_River_Sparkles.tile`. Aucun aplat turquoise de remplacement ni écume synthétique n’est créé.

## Fleurs — animation officielle bloquée en attente des sources

Les frames officielles Sky Peak attendues ne sont pas présentes dans ce checkout. La référence documentée est `2cwdrrs469f61.gif` (`504×504`, quatre frames de `200 ms`), avec les quatre images extraites attendues sous `source/sky_peak_v1/gif_0.png` à `gif_3.png`. Aucune ressource vérifiable n’a été fournie ici.

En conséquence, le build **n’invente pas** de sprite, palette ou poses de substitution : les fleurs déjà peintes dans les décors générés restent intégralement statiques. Pour débloquer l’animation officielle, fournir `2cwdrrs469f61.gif` ou ses quatre frames Sky Peak originales.

## Statut et exports

- Les pixels du décor restent attribués à l’art généré restauré ; ils ne sont jamais présentés comme des tuiles natives.
- `art_approved`, `runtime_tested` et `canonical_flower_frames_verified` restent à `false`.
- Les collisions du viewer sont indicatives ; ce n’est ni un build Ground ni une validation runtime.
- Les livrables FVF1/EVF1 se trouvent sous `renders/fin_vallon_fleuri_sanctuaire_v1/` et `renders/entree_vallon_fleuri_sud_nord_v1/`. Les manifestes détaillent empreintes, sources, cadence, cellules natives réassemblées, calques et limites.
