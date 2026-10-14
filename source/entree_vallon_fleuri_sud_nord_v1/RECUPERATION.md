# Récupération partielle — Entrée Vallon Fleuri (EVF1)

Origine : commit `934a1b4e9b5a9875362ef394798ceef80db67867` (`Add files via upload`, 14 octobre 2026). Le helper de ce commit nomme explicitement `entree_vallon_fleuri_sud_nord_v1`, et le gabarit FVF1 confirme l'identifiant d'entrée associée `EVF1`.

## Fichiers restaurés

- `bruts/decor_magenta.png` ← ancien `decor_magenta.png` : composition d’entrée de la clairière, bouche de grotte au nord et chemin sud (hash vérifié contre le blob du commit source). L’ancien `decor_magenta (4).png`, initialement attribué à EVF1, est en réalité le décor noir-or ETT2 identifié par les seuils de son `build.py`.
- `bruts/sol_complet.png` ← ancien `sol_complet (1).png` : brut de prairie. Son contenu est identique à `sol_complet.png` du lot FVF1.

## Éléments absents du dernier commit

Aucun générateur, test, référence, manifest, gabarit de revue, calque exporté, ORA ou Ground EVF1 n'était présent dans ce commit. Les bruts restent la source de vérité de cette restitution.

## Reconstruction multicalque depuis les bruts restaurés — 14 octobre 2026

Le build commun `source/vallons_fleuris_v1/build.py` compose maintenant EVF1 **depuis ces deux bruts exacts** (décor et sol), sans régénération et sans substitution par une zone voisine. L'échelle est uniforme, sans étirement, vers 768 × 576 px / 96 × 72 cases. Sorties locales :

- `renders/entree_vallon_fleuri_sud_nord_v1/EVF1_entree_vallon_fleuri_sud_nord_v1_calques.ora` : ORA multicalque ;
- `renders/entree_vallon_fleuri_sud_nord_v1/manifest.json` : empreintes, sources, provenance, animations et limites ;
- `renders/entree_vallon_fleuri_sud_nord_v1/review/EVF1_scene_animee.webp` : carte complète animée, et `review/EVF1_scene_t000.png` ;
- viewer commun : `apercu_vallons_fleuris_v1.html?map=EVF1`.

L'eau visible est générée sur la composition complète puis segmentée strictement avec le masque magenta du décor restauré ; les pixels générés hors masque ne sont pas repris. Sa boucle de quatre phases utilise un déplacement subtil déterministe de texture, pas l'animation ni les pixels natifs de Metano. Les quatre frames natifs de la carte River sont reconstruits séparément aux coordonnées sources et exportés comme référence ; les scintillements proviennent des modules natifs de `Metano_Town_River_Sparkles.tile`. Les fleurs d'origine restent statiques et les frames officielles Sky Peak sont absentes. `art_approved`, `canonical_flower_frames_verified` et `runtime_tested` sont `false` ; aucune collision runtime/Ground n'est revendiquée.

Reconstruction et vérification : `.venv/bin/python source/vallons_fleuris_v1/build.py`, puis `.venv/bin/python source/vallons_fleuris_v1/test_build.py`.
