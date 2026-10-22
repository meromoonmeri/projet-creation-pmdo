# Matrice de couverture — PMD_RED_RESCUE_TEAM

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
