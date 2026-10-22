# `t01p01` pre-promotion reserve

These are the exact destination bytes retained before the validated canonical migration on 2026-08-12. They are historical inputs, not canonical proof and not active assets.

| File | Pre-promotion SHA-256 |
| --- | --- |
| `t01p01.rsground` | `4f14a203166427d27c38d52946eb4c37d2ec5a9f2e085cf06bf924fbe9d1e284` |
| `t01p01_Base.tile` | `498b32238cecadd1783fd93ff6742db47cda1d45a624500e3b338a48f70b0535` |

The Ground's two project markers (`Main_Entrance_Marker`, `Cutscene_Marker`) and one `Teammate1`/`TEAMMATE_1` spawner were migrated unchanged into the canonical visual/collision candidate before that exact integrated artifact was run through PMDO 0.8.12. The historical visual data itself was not retained in the active destination: it had a false Pokémon Square comment, noncanonical edge behavior, omitted background parallax, and incorrect animation frame lengths.

An earlier independently retained import remains at `RESERVE/red_grounds/t01p01.rsground`; it is a distinct historical version with SHA-256 `79526eddfb94c197c3dce523a97481ae52ff4e80192a5429b96e028e3a49835a`. The matching earlier tile at `RESERVE/red_tiles/t01p01_Base.tile` is byte-identical to this pre-promotion tile.
