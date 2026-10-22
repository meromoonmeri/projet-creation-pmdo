# RED vs SKY — comparaison par dimensions (jamais fusionnées)

Chaque ligne cite sa preuve. Les GAPs sont montrés, pas moyennés.

| Dimension | RED (EU) | SKY (EU) | GAP principal |
|---|---|---|---|
| ROM authentifiée | PASS (sha256 0f9d125d…) | PASS (sha256 1fa39d35…) | — |
| Extraction scripts | 69/133 stations exactes + chaîne EVENT_* 399/407 ROM_DECODED | 3760/3760 SSB + 1884/1884 SSA + 315/315 LSD | Red: 64 stations REVIEW_REQUIRED (graphe EU ≠ pret) |
| Dialogues | 3073 blocs 5 langues (69 stations) | tous les SSB avec strings 5 langues | Red: stations REVIEW sans textes décodés |
| Classification ressources | partielle (types de grounds GBA distingués par table de conversion) | complète 460/460 par preuves ROM (8 catégories) | Red: classifieur formel à écrire (modèle Sky) |
| Grounds runtime | 219 validés (campagne 0ec8129, pixel-perfect) + 5 routes avec grounds entrée/fin | 95/95 MAP LOAD+MOVE + 9 hub pilotes | Sky: NPC/interactions pas encore posés ; Red: idem |
| Donjons runtime | 89/89 zones CANONICAL_RUNTIME_PASS (1848 étages) — 15 CH1-5 restaurées hors matrice | 43/43 histoire (d01-d43) CANONICAL_RUNTIME_PASS | Sky: post-game d44+ NOT_BUILT |
| Tables vs ROM | manifests par donjon (rom_manifest.json) + zones alignées | 43/43 zones EXACT (comparateur structurel par étage) | Red: comparateur automatique par étage à généraliser |
| Boss arenas | 6 fixed rooms GBA (Skarmory/Zapdos/Moltres/Glalie + GROUDON/RAYQUAZA décodés fixedmap.inc RLE) | 10 arènes fixed.bin (Team Skull→DIALGA) | — |
| Cinématiques extraites | 133 cif.json + cast ROM 27 scènes + EVENT_* décodés | 3760 SSB décompilés + intégrabilité classée | — |
| Cinématiques runtime | 3 scènes cast prouvées | 370 scènes compilées (SE/VFX émotes, cast SSA PNJ, caméra), 34 runtime PASS échantillonnées | Red: compilateur cif→Lua à écrire (modèle sky_compile_scenes) |
| Background défilant | non traité | pilote SCROLL_RUNTIME_PASS (s13p05a) | Red: recensement des écrans défilants GBA |
| Progression graphe | 121 états SCENARIO_MAIN (chaîne EVENT_* ROM_DECODED, atteignabilité 121/121) | 245 états, 97 bit flags, atteignabilité prouvée | — |
| Progression runtime | ordre des chapitres appliqué par le journey | SV.SkyScenario + déblocages, PROGRESSION_RUNTIME_PASS | Red: SV dédiée à porter (modèle progression.lua) |
| Journey global | RED_GLOBAL_JOURNEY_PASS — 13 chapitres, 182 étages, 6 boss SANS GAP (Groudon/Rayquaza inclus) | GLOBAL_JOURNEY_PASS — 14 chapitres, 313 étages, 10 boss | — |
| Persistance | RED_RESUME_RUNTIME_PASS (save 7.0 t01p02b→quit→process 2→LoadProgress→reprise 8.0) | RESUME_RUNTIME_PASS (save→quit→load→continue) | — |
| Post-game | zones construites (ch.6-32 mod) mais pas journey canonique Red | NOT_BUILT (d44+) | les deux |

## Priorités de convergence (Red → niveau Sky)
1. ~~Chaîner Magma Cavern→Sky Tower→Rayquaza~~ FAIT (arènes fixedmap.inc décodées, RED_GLOBAL_JOURNEY_PASS sans gap).
2. ~~Test de persistance Red~~ FAIT (redresume:save/load, redprogression.lua, preuve jsonl).
3. Compilateur cif→Lua Red (dialogues 5 langues déjà extraits).
4. Classifieur formel des grounds Red (modèle sky_classify_grounds).
