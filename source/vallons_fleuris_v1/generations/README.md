# Générations eau magenta — FVF1 / EVF1

## Procédure

Les deux images ont été produites à partir des compositions complètes `decor_magenta.png` fournies comme références d’édition au générateur. Le générateur a dessiné une proposition d’eau **sur l’image complète** ; le build ne reprend ensuite que les pixels de cette proposition qui tombent dans le masque magenta (avec sa frange antialiasée mesurée sur le brut original). Toute la scène hors masque est conservée depuis le décor restauré, sans modification par le générateur.

Ces images sont des **compositions générées**, pas des pixels/tuiles natifs Metano. Elles servent de source de matière pour le calque d’eau ajusté à la silhouette déjà présente dans chaque carte. Le calque conserve une boucle quatre phases de 10 ticks ; l’animation par déplacement subtil de texture est procédurale, pas l’animation native de la carte Palika. Les scintillements restent des modules natifs séparés. La carte River canonique complète est, elle, reconstruite et exportée à part pour provenance/inspection.

## Sources, tailles et empreintes

| Carte | Image de contexte | SHA-256 du contexte | Image générée | SHA-256 généré | Taille |
|---|---|---|---|---|---|
| FVF1 | `source/fin_vallon_fleuri_sanctuaire_v1/bruts/decor_magenta.png` | `0c714c253b40519f94f89cece8542b558d7a7c43c4700ce4287c5a62a907a836` | `FVF1_water_fill_generated.png` | `c09c8efd1bd6f6e6aff6a8419b764eb7208c8868bb76a168269cb85b37e04c58` | 1200×896 |
| EVF1 | `source/entree_vallon_fleuri_sud_nord_v1/bruts/decor_magenta.png` | `183cfa0377f2d7b727e37b1c8ef91d769d6e265a647eaac082a4bc9a8ecb243c` | `EVF1_water_fill_generated.png` | `9b61fb56c9eeb7c6f081d1c7d947a8c9642ae0fd11f70211502f502bc969242d` | 1200×896 |

## Prompts employés

**FVF1** — « Edit the provided full game-map image. Create one complete 4:3 overhead retro monster-RPG map image, preserving the input composition. Replace the vivid magenta water placeholder ONLY with coherent clear light-cyan/turquoise river water in a polished hand-painted pixel-art style that matches the surrounding ground, cliffs, trees, flowers and stones. The magenta placeholder marks the exact water footprint: fill those corridors and the small round pond completely, keep the current banks, central grass island, bridge and every object in their same places. Use a calm pale aqua base, narrow dark-blue flowing curves and modest small cyan highlights, with subtle irregular wave bands. Keep water gentle and readable at an 8-pixel game-tile scale. Avoid large triangular facets, sharp shards, geometric patchwork, foam, waterfalls, extra islands, extra objects, labels, UI, or any redesign. The rest of the image is only a style/composition reference; the final water will be clipped to the original magenta mask, so focus on plausible continuous river-water texture. »

**EVF1** — « Edit the provided full overhead game-map image. Create one complete 4:3 retro monster-RPG pixel-art map image, preserving the original composition. Replace the bright magenta placeholder ONLY with continuous clear light-cyan/turquoise water, matching the surrounding hand-painted pixel-art ground, rocky banks, cave, trees, shrubs, flowers and stepping stones. The magenta color marks the exact river footprint: fill both visible horizontal reaches fully and keep the central stepping-stone crossing and all objects in their same locations. Water should read as a calm, connected river, with a pale aqua base, gently curving narrow dark-blue current lines and modest cyan ripples at an 8-pixel game-tile scale. No large triangular facets, angular shards, patchwork, foam, waterfalls, extra islands, extra objects, labels, UI, or redesign. The rest of the image is only a style/composition reference; the final water will be clipped to the original magenta mask, so focus on plausible continuous river-water texture. »

## Limites déclarées

Le générateur a produit les rendus finaux sauvegardés ici ; une reproduction ultérieure nécessite ces fichiers exacts, le service de génération ne garantissant pas une réédition déterministe. Le rendu dans le masque peut contenir des pixels générés. Ne pas l’appeler texture native Metano. Les masques, le cadrage, le sol, le décor hors eau, l’ordre des calques et la cadence du build restent reproductibles.
