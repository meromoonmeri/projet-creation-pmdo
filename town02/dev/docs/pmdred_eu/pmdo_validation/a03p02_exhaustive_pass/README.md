# a03p02 exhaustive exact-PMDO pass

`PASS — PROMOTED BY INTEGRATION-PRESERVING MIGRATION`

Canonical EU `MAP_FUGITIVES_BLIZZARD_ROAD`. Exact PMDO 0.8.12: 28 events, 1 primary samples through tick 0 plus reload 0, 2/2 RGBA exact/opaque, zero mismatches/delta, 1 unique frames, collision/movement/re-entry/cleanup PASS, native `LoadPhase.Unload` NORMAL_EXIT status 0, no signal/SIGSEGV/kill/orphan. The exact tested artifact preserves 1 active Markers and 0 active Spawners; every non-entity serialized value except the exact Sheet alias is canonical. The former active Ground is retained at `RESERVE/pmdred_pre_promotion/a03p02/a03p02.rsground` (`ca7278d2c16e3843a089ab20904b7c3b5d85542d24987573604ffe12e83c9ff3`). The candidate tile bytes are unchanged under `a03p02_pmdred_Base`; historical `a03p02_Base.tile` remains active at `5d492bd32d1c0fbebce449bf85624865d333eb5743b0acb5adacf5ce7fb9cf2a`. Scripts/routes are untouched, and the existing zone entry is byte-for-byte unchanged. Ground-only; events, actors, music and narrative routing are not claimed.

- canonical Ground baseline: `1802dc409408b7ae85f12ba5e318babe74b232632c3b055fc7a252586b51a463`
- integrated Ground before alias: `4c685a550e2cc6a9cf58f0b640ed3f206700639ac9dd0c39e1a35d1d8c16634c`
- `Data/Ground/a03p02.rsground` (integrated + exact Sheet alias): `f6ffbf9eaa95c54ee343d750b4bea01d11f833af468ce27a4798c42a97824f02`
- `Content/Tile/a03p02_pmdred_Base.tile` (byte-identical candidate): `076d64fb6b4f86ef10fc0861a1b2cf4e01f4d88a434b220c886575c6fe30898c`
- preexisting zone index 309 preserved, SHA `182f2a76a5a572807409183936c74a9df906731e34d002c12c712516ef708359`
