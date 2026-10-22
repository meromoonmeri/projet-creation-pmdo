# `t01p05` exhaustive exact-PMDO validation

`PASS` — additively promoted on 2026-08-12 after exhaustive PMDO 0.8.12 validation.

| Gate | Result |
| --- | --- |
| Visual | 281/281 complete 648×384 RGBA samples pixel-exact and opaque; 0 mismatched pixels; maximum delta 0 |
| Animation | 280 primary ticks (every tick 0–279) cover two complete cycles of all four cell-local schedules; reload tick 0 passed; 72 unique primary RGBA frames |
| Channels | BPA: 6×7 ticks (cycle 42); palette 8: 7×2 (cycle 14); palette 9: 5×4 (cycle 20); maximum local cycle 140 |
| Collision | One BMA layer, 3,282 solid cells, hash `837505e12b177795b8b83789db46a7d6c583d8d349750cd0eef4fb27afccc2df`; movement `(0, 8)`, blocked `(0, 0)` |
| Lifecycle | Two loads/exits, same-Ground re-entry, four cleanup probes, sink/final cleanup, strict order, terminal `end`: all pass |
| Classification | Authenticated Makuhita Dojo interior: training battle arena; arena `true`, boss `false`, cinematic `false`. Dormant project scene remains separately unvalidated |
| Destination | `Data/Ground/t01p05.rsground`, `Content/Tile/t01p05_Base.tile`, one zone entry after `t01p04` |

Exact PMDO hash: `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. EU ROM hash: `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Identity, preservation, and scope

Authenticated extraction identifies canonical debug ID 6, map/file ID 7, Ground place ID 6, conversion type 1, and weather 9. Pinned `pret/pmd-red` enum index 7 is `MAP_MAKUHITA_DOJO_INSIDE`. This corrects the old reserve/audit exterior label `MAP_FILE_ID_MAKUHITA_DOJO`, which is index 6 and authenticated `t01p04`.

Lowercase destinations were absent. The exact tested bare candidate was installed without its fixture-only marker. Historical reserve bytes, the active French `dojo_ossatueur` Ground/tile/script/entities, and dormant `arc_fugitif/scene/t01p05.lua` remain unchanged. The scene is absent from Fugitive registries/sequence and there is no lowercase Ground init, so it was not routed or claimed complete.

The interior is separately classified as an arena because it is the canonical training battle facility interior; it is not a boss Ground. This pass validates map/tile rendering, complete animation timing, collision, entry/exit/re-entry, cleanup, and reload—not battle rules, opponents, narrative, dialogue, music, cameras, VFX, choreography, or cinematics.

## Evidence

- `report.json`: complete per-sample pixel metrics and screenshot hashes.
- `events.jsonl`: untouched 865-event exact-PMDO lifecycle stream.
- `actual/` and `comparisons/`: primary ticks 0/279 and reload tick 0.
- `fixture_manifest.json`, runtime/index/engine/comparison logs, `post_promotion_index.log`.
- `validation_record.json`, `promotion_record.json`, `provenance.json`: classification, destination, identity correction, preservation, and hashes.
- `commands.sh`: bounded exact-hash reproduction.
- `evidence_hashes.sha256`: durable evidence manifest.

Dungeon restitution remains unchanged and passing (27 relationships, 204 AT4PX streams, 131 rendered frames, 138 files).
