# Matrice de couverture — campagnes PMD Red EU & Sky EU

Dimensions SÉPARÉES (règle §49) : aucun pourcentage global fusionné n'existe ni ne doit être calculé.


## PMD_RED_RESCUE_TEAM

| Dimension | Couverture | Statut | Source |
|---|---|---|---|
| extraction_grounds | 254/254 (100.0%) | **PASS** | MANIFEST.totals.grounds |
| render_visual | 254/254 (100.0%) | **PASS** | AUDIT.coverage.render_pct |
| frames_animation | — | **PASS** | AUDIT.frame_status (période minimale réelle par tuile) |
| runtime_pmdo | 219/254 (86.2%) | **PARTIAL** | MANIFEST.totals.runtime_validated (campagne 219 : mismatched_pixel_count=0 dans PMDO 0.8.12 réel) |
| cinematic_sequences | 132/254 (52.0%) | **PARTIAL** | MANIFEST.totals.with_cinematic (cif.json ROM) |
| dialogues_5_langues | 69/133 (51.9%) | **PARTIAL** | Cinematics/DIALOGUES_INDEX.json (69 stations graphe EU exact, 3073 blocs) |
| canonical_cast | 27/27 (100.0%) | **PASS** | eu_scene_cast.json (gGroundLivesTypeData 0x27BEEC) + preuve runtime 3 scènes |
| event_chain_rom_decoded | 399/407 (98.0%) | **PASS** | Cinematics/EVENT_SCRIPTS_INDEX.json (gFunctionScriptTable EU @0x08294450, décodage octet par octet) |
| playable_progression | 121/121 (100.0%) | **PASS** | Docs/PLAYABLE_PROGRESSION.json (EVENT→stations→dialogues) |
| dungeons_procedural_runtime | 89/89 (100.0%) | **PARTIAL** | dev/docs/canonical_dungeon_runtime/matrix.json (89/89 CANONICAL_RUNTIME_PASS, 1848 étages) |
| full_journey_runtime | 13/13 (100.0%) | **PASS** | dev/docs/canonical/red/global_journey_runtime_proof.jsonl (mode redjourney) |
| save_resume_runtime | 1/1 (100.0%) | **PASS** | dev/docs/canonical/red/resume_runtime_proof.jsonl (dev/tools/red_resume_runtime_test.py) |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |

## PMD_SKY_EXPLORERS

| Dimension | Couverture | Statut | Source |
|---|---|---|---|
| extraction_grounds | 460/460 (100.0%) | **PASS** | MANIFEST.totals.grounds |
| render_visual | 459/460 (99.8%) | **PARTIAL** | AUDIT.coverage.render_pct |
| frames_animation | — | **PASS** | AUDIT.frame_status |
| rom_scripts_ssb | 3760/3760 (100.0%) | **PASS** | Cinematics/ROM_SCRIPTS_INDEX.json (ExplorerScript + dialogues 5 langues) |
| rom_scripts_ssa | 1884/1884 (100.0%) | **PASS** | idem (placements acteurs/objets/events/triggers) |
| cinematic_linked_grounds | 336/460 (73.0%) | **PARTIAL** | MANIFEST.totals.with_cinematic (LEVEL_MAP_LINKS level→MAP_BG) |
| progression_graph | — | **PASS** | Docs/PROGRESSION_GRAPH.json (SSB décompilés ROM) |
| playable_progression | 244/245 (99.6%) | **PASS** | Docs/PLAYABLE_PROGRESSION.json (état→scène→ground→dialogues) |
| cinematic_integrability | 2763/3760 (73.5%) | **PARTIAL** | Docs/CINEMATIC_INTEGRABILITY.json (table curatée ssb_coverage, 0 opcode inconnu) |
| ground_classification | 437/460 (95.0%) | **PARTIAL** | Docs/GROUND_CLASSIFICATION.json (mapty×SCRIPT×collision×xrefs SSB — jamais le nom de fichier) |
| runtime_pmdo_grounds_map | 96/95 (101.1%) | **PASS** | dev/docs/canonical/sky/hub_grounds_runtime_proof.jsonl (sky_hub_zone + mode sky: du ground_gameplay_validator) |
| progression_runtime | 14/14 (100.0%) | **PASS** | dev/docs/canonical/sky/progression_runtime_proof.jsonl (skyscenes/progression.lua, SV natif) |
| full_journey_runtime | 14/14 (100.0%) | **PASS** | dev/docs/canonical/sky/global_journey_runtime_proof.jsonl (mode skyjourney global) |
| save_resume_runtime | 1/1 (100.0%) | **PASS** | dev/docs/canonical/sky/resume_runtime_proof.jsonl |
| scrolling_background_runtime | 1/213 (0.5%) | **PARTIAL** | dev/docs/canonical/sky/scroll_pilot_runtime_proof.jsonl |
| cinematic_runtime | 1/3760 (0.0%) | **PARTIAL** | dev/docs/canonical/sky/cinematic_m01a0204_runtime_proof.jsonl (SkyCanonScenes.lua, mode skyscene:) |
| cinematic_compiled | 2157/3760 (57.4%) | **PARTIAL** | Docs/SCENE_COMPILER_REPORT.json (compilateur FAIL-CLOSED) + compiled_scenes_runtime_proof.jsonl |
| dual_screen_focus_runtime | 70/195 (35.9%) | **PARTIAL** | Docs/DUAL_SCREEN_TIMELINES.json + DUAL_SCREEN_VERIFICATION.json + dev/docs/canonical/sky/dual_screen_runtime_proof.jsonl |
| gameplay_tables_extraction | 178/180 (98.9%) | **PASS** | Tables/DUNGEON_TABLES_INDEX.json (mappa_s.bin EU : 1795 étages, spawns/pièges/items bruts) |
| pmdo_mapping_species | 484/484 (100.0%) | **PASS** | Tables/PMDO_MAPPING.json |
| pmdo_mapping_items | 205/290 (70.7%) | **PARTIAL** | Tables/PMDO_MAPPING.json |
| dungeon_zones_vs_rom | 86/86 (100.0%) | **PASS** | Tables/ZONE_VS_ROM_COMPARISON.json (comparaison structurelle par étage) |
| dungeon_runtime_pmdo | 86/180 (47.8%) | **PARTIAL** | dev/docs/canonical_dungeon_runtime/matrix.json + mapgen_*.jsonl (PMDO 0.8.12 réel) |
| story_chains_end_to_end | 9/9 (100.0%) | **PASS** | dev/docs/canonical/sky/story_chains_runtime_proof.jsonl (red_story_route_validator, chaînes sky) |
| audit_verdict | — | **AUDIT_PASS** | AUDIT.json (8 familles A-H) |
