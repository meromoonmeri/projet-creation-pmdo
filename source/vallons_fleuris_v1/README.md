# Vallons Fleuris — FVF1 + EVF1

Recomposition reproductible des compositions complètes restaurées. Le build repart des bruts exacts de décor et du calque de sol séparé ; il conserve les compositions, fonds, objets et effets restaurés, puis exporte les calques et les scènes assemblées. L’eau générée des essais précédents est rejetée et n’est pas utilisée.

## Génération

```bash
.venv/bin/python source/vallons_fleuris_v1/build.py
.venv/bin/python source/vallons_fleuris_v1/test_build.py
```

Le script normalise uniformément les bruts `1200×896` vers `768×576` (`96×72` cases de `8 px`), détecte le masque magenta, puis exporte les calques, les quatre phases d’eau native, les scintillements, les scènes complètes PNG/WebP, les ORA multicalques, les manifestes et `apercu_vallons_fleuris_v1.html`. Les répertoires source des autres lots — dont ETT2 — ne sont pas modifiés.

## Eau — frames natives Metano Town dans les masques magenta exacts

- Source : Palikadude/Halcyon, carte `Data/Ground/metano_town.rsground`, commit `da6c2130d641507447e6386a5e47a296e8cb4c71`. Les quatre planches `Metano_Town_River_Animation_1.tile` à `_4.tile` sont référencées par `source/eau_metano/animations_carte.json` ; cadence source : quatre phases de `10 ticks`.
- Les `3200` entrées `River` ont été revérifiées : pour les quatre phases, `example_map_cell == TexLoc` et les coordonnées sont uniques. Le build reconstruit et exporte séparément les quatre calques complets de la carte native, `142×189` cases (`1136×1512 px`), à leurs coordonnées d’origine, sous `renders/metano_town_native_river/`.
- La vidéo fournie `marvelousvalley.mp4` sert de **référence visuelle** pour la scène FVF1 et son eau continue, cyan, aux reflets discrets. Elle n’est pas une source de pixels : aucun échantillon vidéo n’est utilisé dans les exports.
- Pour remplir FVF1 et EVF1, le build choisit une fenêtre native contiguë de `96×72` cases (`768×576 px`), à l’échelle 1:1, en comparant l’occupation du masque aux cellules River natives dominées par la surface d’eau calme. Les donneurs RGB sont les pixels opaques dont chaque canal reste au moins à `RGB modal natif − 10` ; la base cyan et les reflets plus clairs restent admissibles, les grandes facettes bleu foncé sont écartées (`source_calm_water_base_rgb_native` dans le manifeste). Les rives alpha-partielles, chutes/cascades et facettes bleues marquées sont exclues des donneurs pour éviter que leurs grandes formes s’étalent dans le canal. Il n’y a ni rotation, ni miroir, ni redimensionnement, ni recoloration, ni mosaïque ou répétition de patches, ni appariement individuel des composantes/berges. **La fenêtre est un crop adapté, pas la carte source complète et pas une conservation de son agencement complet dans le biome.** Ses coordonnées et son IoU sont inscrits au manifeste.
- Chaque RGB visible est recopié d’un pixel natif de surface calme dans cette fenêtre ; pour compléter les transparences, le plus proche pixel donneur est recherché séparément dans chaque phase. L’alpha final suit exactement le masque magenta. La vidéo sert uniquement à comparer visuellement le canal, sans fournir de pixels. Il ne s’agit ni d’eau générée, ni d’une prétention à conserver la carte source entière.
- Les phases de sortie utilisent les quatre frames natives dans leur ordre et leur cadence source. Les scintillements restent des modules natifs distincts de `Metano_Town_River_Sparkles.tile`, sans recoloration ni transformation.
- Les statistiques de la carte source complète restent documentées dans les manifestes : `2365` cellules opaques de surface, `477` cellules opaques animées (`361` séquences distinctes), `750` cellules alpha-partielles de rive (`656` animées ; `566` séquences distinctes ; `278` empreintes alpha).

## Fleurs — animation officielle en attente des sources

Les frames officielles Sky Peak attendues ne sont pas présentes dans ce checkout. La référence documentée est `2cwdrrs469f61.gif` (`504×504`, quatre frames de `200 ms`), avec les quatre images extraites attendues sous `source/sky_peak_v1/gif_0.png` à `gif_3.png`. Aucune ressource vérifiable n’a été fournie ici.

Le build n’invente pas de sprite, de palette ni de poses de substitution : les fleurs déjà peintes dans les décors restent statiques. Pour débloquer l’animation officielle, fournir `2cwdrrs469f61.gif` ou ses quatre frames Sky Peak originales.

## Statut et exports

- Les pixels du décor restent attribués à l’art généré restauré ; ils ne sont jamais présentés comme des tuiles natives.
- `art_approved`, `runtime_tested` et `canonical_flower_frames_verified` restent à `false`.
- Les collisions du viewer sont indicatives ; ce n’est ni un build Ground ni une validation runtime.
- Les livrables FVF1/EVF1 se trouvent sous `renders/fin_vallon_fleuri_sanctuaire_v1/` et `renders/entree_vallon_fleuri_sud_nord_v1/`. Les manifestes séparent clairement la provenance native de l’eau, des scintillements et de la carte complète, documentent le crop, l’alpha exact, la cadence et les limites.
