# Global PMDO Import Integrity Audit

Classification: **static exhaustive discovery**. No runtime PASS inferred.

## Coverage
- zones: 57
- dungeons: 57
- structures: 139
- segments: 139
- floors: 841
- grounds: 218
- tile_sheets: 731
- frames: 954041
- tile_references: 954041
- markers: 453
- spawners: 304
- entities: 468
- transitions: 327
- bosses: 182
- lua_files: 681
- cinematic_candidate_files: 466

## Verdict counts
- TOTAL_DISCOVERED: 1913145
- TOTAL_AUDITED: 1913145
- TOTAL_FIXED: 0
- TOTAL_RUNTIME_PASS: 0
- TOTAL_RUNTIME_FAIL: 0
- TOTAL_INCONCLUSIVE: 0
- TOTAL_NOT_TESTED: 400
- problems: 42

## Findings by type
- ORPHAN_GROUND: 11
- CROSS_DUNGEON_FLOOR_NAME: 10
- SPAWNER_OUT_OF_BOUNDS: 10
- INVALID_TRANSITION_TARGET: 10
- ZONE_INDEX_GROUNDS_STALE: 1

## Tornadus
`CRITICAL_RUNTIME_BLOCKER — INCONCLUSIVE`. Full interactive cutscene repetition tests have not run in this batch.
